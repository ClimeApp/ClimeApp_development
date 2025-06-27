# Helper Functions of ClimeApp 

#### Internal Functions ####
# (Functions used ONLY by other functions)

## GENERATE TITLE MONTHS
## data input = month_range

generate_title_months = function(MR){
  print(MR)
  if (!is.null(MR) && length(MR) >= 2 && !any(is.na(MR)) && MR[1] == 1 && MR[2] == 12){
    title_months = "Annual"
  } else if (!is.null(MR) && length(MR) >= 2 && !any(is.na(MR))) {
    month_letters  = c("D","J","F","M","A","M","J","J","A","S","O","N","D")
    title_months = paste(month_letters[(MR[1]:MR[2])+1], collapse = "")
  } else {
    title_months = "Invalid"
  }
  return(title_months)
}


#### General Functions ####

## (General) Creating c(min,max) numeric Vector for range_months data input

create_month_range = function(month_names_vector){
  month_names_list = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
  month_range_full = match(month_names_vector,month_names_list)-1
  month_range = c(month_range_full[1],tail(month_range_full,n=1))
  
  return(month_range)
}


## (General) Create a subset of longitude IDs for plotting, tables and reading in data
##           UPDATE: Always creates a subset that is 1 grid point longer at either end
##                   than the given lat/lon range (to allow for cutting)

create_subset_lon_IDs = function(lon_range){
  subset_lon_IDs = which((lon >= lon_range[1]-2.8125) & (lon <= lon_range[2]+2.8125))
  return(subset_lon_IDs)
}


## (General) Create a subset of latitude IDs for plotting, tables and reading in data

create_subset_lat_IDs = function(lat_range){
  subset_lat_IDs = which((lat >= lat_range[1]-2.774456) & (lat <= lat_range[2]+2.774456))
  return(subset_lat_IDs)
}


## (General) GENERATE MAP DIMENSIONS
##           Creates a vector of dimensions for the on-screen map and downloads: 
##           c(on screen width,on screen height, download width, download height, lon/lat)
##           output_width = session$clientData$output_>>INSERT OUTPUT NAME <<_width
##           output_height = session$clientData$output_>>INSERT OUTPUT NAME <<_height
##           hide_axis = TRUE or FALSE

generate_map_dimensions = function(subset_lon_IDs,
                                   subset_lat_IDs,
                                   output_width,
                                   output_height,
                                   hide_axis) {
  
  lon_over_lat = ((length(subset_lon_IDs) - 1) * 1.875) / ((length(subset_lat_IDs) -
                                                              1) * 1.849638)
  
  # Width of left axis + key in pixels
  if (hide_axis == TRUE) {
    w_ax = 175
  } else {
    w_ax = 70 # TO CHECK!!!
  }
  # Height of bottom axis + title in pixels
  h_ax = 110
  
  # Set width and height when map is BELOW input tab
  if (output_width < 750) {
    w = output_width
    h = ((w - w_ax) * (1 / lon_over_lat)) + h_ax
    
    # Set w/h by height (i.e for a tall map)
  } else if ((output_width / output_height) > lon_over_lat) {
    h = output_height * 0.8
    w = ((h - h_ax) * (lon_over_lat)) + w_ax
    # Deal with too large widths
    if (w > output_width) {
      w = output_width * 0.75
      h = ((w - w_ax) * (1 / lon_over_lat)) + h_ax
      # Deal with very tiny widths
    } else if (w < 500) {
      w = 500
    }
    
    # Set w/h by width (i.e.for wide map)
  } else {
    w = output_width * 0.9
    h = ((w - w_ax) * (1 / lon_over_lat)) + h_ax
    # Deal with too large heights
    if (h > output_height) {
      h = output_height * 0.75
      w = ((h - h_ax) * (lon_over_lat)) + w_ax
      # Deal with very tiny heights
    } else if (h < 175) {
      h = 175
    }
  }
  
  # Generate download dimensions
  total_image_size = 6000000
  m = sqrt(total_image_size / (w * h))
  w_d = m * w
  h_d = m * h
  
  return(c(w, h, w_d, h_d, lon_over_lat))
}


## (General) GENERATE DATA ID
##           Creates a vector with the reference numbers for ModE data:
##           c(pre-processed data? (0 = NO, 1 = yes, preloaded, 2 = yes, not preloaded)
##             ,dataset,variable,season)
##           data_set = "ModE-RA","ModE-Sim","ModE-RAclim" or "SD Ratio"

generate_data_ID = function(dataset,
                            variable,
                            month_range){
  
  # Generate dataset reference
  if (dataset == "ModE-RA"){
    dataset_ref = 1
  } else if (dataset == "ModE-Sim"){
    dataset_ref = 2
  } else if (dataset == "ModE-RAclim"){
    dataset_ref = 3
  } else { # dataset == "Sd Ratio"
    dataset_ref = 4   
  }
  
  # generate variable reference
  if (variable == "Temperature"){
    variable_ref = 1      
  } else if (variable == "Precipitation"){
    variable_ref = 2
  } else if (variable == "SLP"){
    variable_ref = 3
  } else { # (variable == "Z500")
    variable_ref = 4
  }
  
  # Check for pp data and add season reference
  if (dataset == "ModE-RA" & variable != "Z500"){
    # generate season reference
    if (identical(month_range,c(1,12))){
      season_ref = 5
      pp_available = 1
    } else if (identical(month_range,c(0,2))){
      season_ref = 1
      pp_available = 1
    } else if (identical(month_range,c(3,5))){
      season_ref = 2
      pp_available = 1
    } else if (identical(month_range,c(6,8))){
      season_ref = 3
      pp_available = 1
    } else if (identical(month_range,c(9,11))){
      season_ref = 4
      pp_available = 1
    } else {
      season_ref = NA
      pp_available = 0
    } 
  } else { # Other data (may be preprocessed, but may need to be loaded in) 
    if (identical(month_range,c(1,12))){
      season_ref = 5
      pp_available = 2
    } else if (identical(month_range,c(0,2))){
      season_ref = 1
      pp_available = 2
    } else if (identical(month_range,c(3,5))){
      season_ref = 2
      pp_available = 2
    } else if (identical(month_range,c(6,8))){
      season_ref = 3
      pp_available = 2
    } else if (identical(month_range,c(9,11))){
      season_ref = 4
      pp_available = 2
    } else {
      season_ref = NA
      pp_available = 0
    } 
  }
  
  # Create data reference
  data_ref = c(pp_available,dataset_ref,variable_ref,season_ref)
  
  return (data_ref)
}        


## (General) LOAD FULL ModE DATA - load ModE-RA/sim/clim/SDratio data for a chosen variable
##           and data source
##           dataset = "ModE-RA","ModE-Sim","ModE-RAclim","SD Ratio"

load_ModE_data = function(dataset,
                          variable){
  # Mod E-RA
  if (dataset == "ModE-RA"){
    # get variable name and open file
    vname =  switch(variable,
                    "Temperature"   = "temp2",
                    "Precipitation" = "totprec",
                    "SLP"           = "slp",
                    "Z500"          = "geopoth_50000")
    
    data_nc = nc_open(paste0("data/ModE-RA/Monthly/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_",vname,"_abs_1421-2008_mon.nc"))
    
    # extract data and convert units if necessary                  
    if (variable == "Temperature"){
      data_output = ncvar_get(data_nc,varid="temp2")-273.15 
    } else if (variable == "Precipitation"){
      data_output = ncvar_get(data_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month 
    } else if (variable == "SLP"){
      data_output = ncvar_get(data_nc,varid="slp")/100 
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    nc_close(data_nc)
  } 
  # ModE-SIM
  else if (dataset == "ModE-Sim"){
    # get variable name and open file
    vname =  switch(variable,
                    "Temperature"   = "temp2",
                    "Precipitation" = "totprec",
                    "SLP"           = "slp",
                    "Z500"          = "geopoth_50000")
    
    data_nc = nc_open(paste0("data/ModE-SIM/Monthly/ModE-Sim_ensmean_",vname,"_abs_1420-2009.nc"))
    
    # extract data and convert units if necessary                  
    if (variable == "Temperature"){
      data_output = ncvar_get(data_nc,varid="temp2")-273.15 
    } else if (variable == "Precipitation"){
      data_output = ncvar_get(data_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month 
    } else if (variable == "SLP"){
      data_output = ncvar_get(data_nc,varid="slp")/100 
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    # remove the first year (1421)
    data_output = data_output[,,13:7080]
    
    nc_close(data_nc)
  }
  # ModE-RAclim
  else if (dataset == "ModE-RAclim"){
    # get variable name and open file
    vname =  switch(variable,
                    "Temperature"   = "temp2",
                    "Precipitation" = "totprec",
                    "SLP"           = "slp",
                    "Z500"          = "geopoth_50000")
    data_nc = nc_open(paste0("data/ModE-RAclim/Monthly/ModE-RAclim_ensmean_",vname,"_anom_1421-2008_mon.nc"))
    
    # extract data and convert units if necessary                  
    if (variable == "Temperature"){
      data_output = ncvar_get(data_nc,varid="temp2") 
    } else if (variable == "Precipitation"){
      data_output = ncvar_get(data_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month 
    } else if (variable == "SLP"){
      data_output = ncvar_get(data_nc,varid="slp")/100 
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    nc_close(data_nc)
  }
  
  # SDratio
  else if (dataset == "SD Ratio"){
    # get variable name and open file
    vname =  switch(variable,
                    "Temperature"   = "temp2",
                    "Precipitation" = "totprec",
                    "SLP"           = "slp",
                    "Z500"          = "geopoth_50000")
    data_nc = nc_open(paste0("data/SD_ratio/Monthly/ModE-RA_lowres_20mem_Set_1420-3_1850-1_sdratio_",vname,"_anom_wrt_1901-2000_1421-2008_mon.nc"))
    
    # extract data and convert units if necessary                  
    if (variable == "Temperature"){
      data_output = ncvar_get(data_nc,varid="temp2") 
    } else if (variable == "Precipitation"){
      data_output = ncvar_get(data_nc,varid="totprec")
    } else if (variable == "SLP"){
      data_output = ncvar_get(data_nc,varid="slp")
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    nc_close(data_nc)
  }
  
  
  return(data_output)
}


## (General) LOAD PRE-PROCESSED ModE DATA - load ModE-RA/sim/clim/SDratio pp_data for a chosen variable
##           and month range
##           data_ID = as created by generate_data_ID

load_preprocessed_data = function(data_ID){
  
  # Mod E-RA
  if (data_ID[2] == 1){ # ModE-RA
    # get variable and month names
    vname = "geopoth_50000"
    mname = switch(data_ID[4],
                   "1" = "djf",
                   "2" = "mam",
                   "3" = "jja",
                   "4" = "son",
                   "5" = "year")
    
    # Open file
    data_nc = nc_open(paste0("data/ModE-RA/",mname,"/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_",vname,"_abs_1421-2008_",mname,".nc"))
    
    # extract data and convert units if necessary                  
    data_output = ncvar_get(data_nc,varid="geopoth")
    
    nc_close(data_nc)
  } 
  
  # ModE-SIM
  else if (data_ID[2] == 2){ # ModE-Sim
    # get variable name and month names
    vname =  switch(data_ID[3],
                    "1" = "temp2",
                    "2" = "totprec",
                    "3" = "slp",
                    "4" = "geopoth_50000")
    mname = switch(data_ID[4],
                   "1" = "djf",
                   "2" = "mam",
                   "3" = "jja",
                   "4" = "son",
                   "5" = "year")
    
    # open file
    data_nc = nc_open(paste0("data/ModE-SIM/",mname,"/ModE-Sim_lowres_20mem_Set_1420-3_1850-1_ensmean_",vname,"_abs_1420-2009_",mname,".nc"))
    
    # extract data and convert units if necessary                  
    if (data_ID[3] == 1){
      data_output = ncvar_get(data_nc,varid="temp2")-273.15 
    } else if (data_ID[3] == 2){
      data_output = ncvar_get(data_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month 
    } else if (data_ID[3] == 3){
      data_output = ncvar_get(data_nc,varid="slp")/100 
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    # remove the first year (1421)
    data_output = data_output[,,2:589]
    
    nc_close(data_nc)
  }
  
  # ModE-RAclim
  else if (data_ID[2] == 3) { # ModE-RAclim
    # get variable name and month names
    vname =  switch(data_ID[3],
                    "1" = "temp2",
                    "2" = "totprec",
                    "3" = "slp",
                    "4" = "geopoth_50000")
    mname = switch(data_ID[4],
                   "1" = "djf",
                   "2" = "mam",
                   "3" = "jja",
                   "4" = "son",
                   "5" = "year")
    
    # Open file
    data_nc = nc_open(paste0("data/ModE-RAclim/",mname,"/ModE-RAclim_ensmean_",vname,"_anom_1421-2008_",mname,".nc"))
    
    # extract data and convert units if necessary                  
    if (data_ID[3] == 1){
      data_output = ncvar_get(data_nc,varid="temp2") 
    } else if (data_ID[3] == 2){
      data_output = ncvar_get(data_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month 
    } else if (data_ID[3] == 3){
      data_output = ncvar_get(data_nc,varid="slp")/100 
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    nc_close(data_nc)
  }
  
  # SDratio
  else if (data_ID[2] == 4){
    # get variable name and month names
    vname =  switch(data_ID[3],
                    "1" = "temp2",
                    "2" = "totprec",
                    "3" = "slp",
                    "4" = "geopoth_50000")
    mname = switch(data_ID[4],
                   "1" = "djf",
                   "2" = "mam",
                   "3" = "jja",
                   "4" = "son",
                   "5" = "year")
    
    # Open file
    data_nc = nc_open(paste0("data/SD_ratio/",mname,"/ModE-RA_lowres_20mem_Set_1420-3_1850-1_sd_ratio_",vname,"_abs_1421-2008_",mname,".nc"))
    
    # extract data and convert units if necessary                  
    if (data_ID[3] == 1){
      data_output = ncvar_get(data_nc,varid="temp2") 
    } else if (data_ID[3] == 2){
      data_output = ncvar_get(data_nc,varid="totprec")
    } else if (data_ID[3] == 3){
      data_output = ncvar_get(data_nc,varid="slp")
    } else {
      data_output = ncvar_get(data_nc,varid="geopoth")
    }
    
    nc_close(data_nc)
    
    # Add an extra year at the start for djf
    if(mname == "djf"){
      empty_year = array(NA, dim = c(192,96,588))
      empty_year[,,c(2:588)] = data_output
      data_output = empty_year
    }
  }
  
  return(data_output)
  
}


## (General) CREATE GEOGRAPHIC SUBSET - returns a new dataset with a reduced geographic area
##           data_input = any ModE-RA variable (temp_data/prec_data/SlP_data etc.)
##                        (this should already be assigned as "custom_data()")
##                        OR
##                        any preprocessed ModE-RA variable

create_latlon_subset = function(data_input,
                                data_ID,
                                subset_lon_IDs,
                                subset_lat_IDs){
  if (data_ID[1] == 1){
    # subset preprocessed data
    data_subset = pp_data[[data_ID[4]]][[data_ID[3]]][subset_lon_IDs,subset_lat_IDs,]
  } 
  else {
    # subset base/loaded preprocessed data
    data_subset = data_input[subset_lon_IDs,subset_lat_IDs,]
  }
  return(data_subset)
}


## (General) CREATE YEAR & MONTH SUBSET - returns a new dataset of mean yearly values 
##                                        within a reduced time range
##           data_input = any create_latlon_subset data

create_yearly_subset = function(data_input,
                                data_ID,
                                year_range,
                                month_range){
  # Check for preprocessed subset
  if (data_ID[1] != 0){
    year_IDs = (year_range[1]-1420):(year_range[2]-1420) 
    data_subset = data_input[,,year_IDs]
  } 
  # Calculate subset from scratch
  else {
    dim_data = dim(data_input)
    years = year_range[1]:year_range[2]
    
    data_subset = array(NA,dim=c(dim_data[1],dim_data[2], length(years)))
    
    for (i in 1:length(years)){
      Y = years[i]
      M1 = ((12*(Y-1421))+month_range[1]) ; M2 = ((12*(Y-1421))+month_range[2]) 
      data_subset[,,i] = apply(data_input[,,M1:M2],c(1:2),mean)
    }
  }
  
  return(data_subset)
}


## (General) CONVERT ABSOLUTE YEARLY SUBSET TO ANOMALIES
##           data_input = any create_yearly_subset data
##           ref_data = averaged create_yearly_subset data for the ref period

convert_subset_to_anomalies = function(data_input,
                                       ref_data){
  
  # find dimensions of the reference data
  dim_data = dim(data_input)
  
  # Repeat ref data if year range > 1 year
  if (length(dim_data) == 2){ 
    baseline_array = ref_data
  } else {
    # duplicate into an array
    baseline_array = array(ref_data,dim= c(dim_data[1],dim_data[2], dim_data[3]))
  }
  
  # Take baseline data from absolute data to calculate anomalies
  anomaly_data = data_input-baseline_array
  
  return(anomaly_data)
}


## (General) GENERATE MAP,TS & FILE TITLES - creates a dataframe of map_title,
##                                           map_subtitle, ts_title, ts_axis,file_title,
##                                           netcdf_title for Anomalies and Composites
##           tab = "general" or "composites", "reference", or "sdratio"
##           dataset = "ModE-RA","ModE-Sim","ModE-RAclim"
##           mode = "Absolute" or "Anomaly" for general tab
##                  "Absolute", "Fixed reference" or ""X years prior"
##                   for composites tab
##           map/ts_title_mode = "Default" or "Custom"
##           year_range,baseline_range,baseline_years_before 
##                = set to NA if not relevant for selected tab
##           map/ts_custom_title1/2 = user entered titles and subtitles
##           map/ts_title_size = numeric value for the title font size, default = 18
##           ts_data = timeseries data (numeric vector) for statistics (Mean, Range, SD) values displayed in TS subtitles

generate_titles = function(tab,
                           dataset,
                           variable,
                           mode,
                           map_title_mode = "Default",
                           ts_title_mode = "Default",
                           month_range,
                           year_range,
                           baseline_range = NA,
                           baseline_years_before = NA,
                           lon_range,
                           lat_range,
                           map_custom_title1 = NA,
                           map_custom_title2 = NA,
                           ts_custom_title1 = NA,
                           ts_custom_title2 = NA,
                           map_title_size = 18,
                           ts_title_size = 18,
                           ts_data = NA) {
  
  
  # Generate title months
  title_months = generate_title_months(month_range)
  
  # Create map_title & map_subtitle:
  # Averages and Anomalies titles
  if (tab=="general"){
    if (mode == "Absolute"){
      map_title = paste(dataset," ",title_months," ",variable," ",year_range[1],"-",year_range[2], sep = "")
      map_subtitle = ""
    } else {
      map_title = paste(dataset," ",title_months," ",variable," Anomaly ",year_range[1],"-",year_range[2], sep = "")
      map_subtitle = paste("Ref. = ",baseline_range[1],"-",baseline_range[2], sep = "") 
    } 
  }
  
  # Composites titles
  else if (tab=="composites"){
    if (mode == "Absolute"){
      map_title = paste(dataset," ",title_months," ",variable," Absolute values (Composite years)", sep = "")
      map_subtitle = ""
    } else if (mode == "Fixed reference") {
      map_title = paste(dataset," ",title_months," ",variable," Anomaly (Composite years)", sep = "")
      map_subtitle = paste("Ref. = ",baseline_range[1],"-",baseline_range[2], sep = "") 
    } else if (mode == "X years prior") {
      map_title = paste(dataset," ",title_months," ",variable," Anomaly (Composite years)", sep = "")
      map_subtitle = paste("Ref. = ",baseline_years_before," yrs prior", sep = "")
    } else {
      map_title = paste(dataset," ",title_months," ",variable," Anomaly (Composite years)", sep = "")
      map_subtitle = paste("Ref. = Reference years")  
    }
  }
  
  # Reference period titles
  else if (tab=="reference"){
    map_title = paste(dataset," ",title_months," ",variable," Absolute values (Reference years)", sep = "")
    map_subtitle = ""
  }
  
  # SD ratio titles
  else if (tab=="sdratio"){
    if (is.na(year_range[1])){
      map_title = paste(dataset," ",title_months," SD Ratio (Composite years)", sep = "")
      map_subtitle = ""
    } else{
      map_title = paste(dataset," ",title_months," SD Ratio ",year_range[1],"-",year_range[2], sep = "")
      map_subtitle = "" 
    }
  }
  
  # Create Timeseries title, subtitle and axis titles
  if (tab=="composites"){
    ts_title = paste(substr(map_title, 1, nchar(map_title) - 18),
                     " [",lon_range[1],":",lon_range[2],"\u00B0E, ",lat_range[1],":",lat_range[2],"\u00B0N]", sep = "")
  } else {
    ts_title = paste(substr(map_title, 1, nchar(map_title) - 10),
                     " [",lon_range[1],":",lon_range[2],"\u00B0E, ",lat_range[1],":",lat_range[2],"\u00B0N]", sep = "")
  }
  
  v_unit <- get_variable_properties(variable)$unit
  
  if (mode == "Absolute"){
    ts_axis = paste(title_months," Mean ",variable," [",v_unit, "]",sep = "")
  } else {
    ts_axis = paste(title_months," ",variable," Anomaly [",v_unit, "]",sep = "")
  }
  
  if (is.data.frame(ts_data)){# using is.null doesn't work because is.null(NA) = FALSE, using is.na doesn't work because is.na(data.frame) = c(FALSE, FALSE, FALSE, ...)
    stats = generate_stats_ts(as.vector(ts_data$Mean)) #transform into vector, because generate_stats_ts expects a vector
    
    ts_subtitle <- paste(
      "Mean = ",
      signif(stats$mean, 3),
      v_unit,
      "   Range = ",
      signif(stats$min, 3),
      v_unit,
      ":",
      signif(stats$max, 3),
      v_unit,
      "   SD = ",
      signif(stats$sd, 3),
      v_unit,
      sep = ""
    )
    if (map_subtitle != "") {
      ts_subtitle = paste0(ts_subtitle, "\n", map_subtitle)
    }
  } else {
    if (map_subtitle != "") {
      ts_subtitle <- map_subtitle
    } else {
      ts_subtitle <- ""
    }
  }
  
  # Replace with custom titles
  if (map_title_mode == "Custom"){
    if(map_custom_title1 != ""){
      map_title = map_custom_title1
    }
    if(map_custom_title2 != ""){
      map_subtitle = map_custom_title2
    }
  }
  
  if (ts_title_mode == "Custom"){
    if(ts_custom_title1 != ""){
      ts_title = ts_custom_title1
    }
    ts_subtitle = ""
  }
  
  # Create title for filenames
  tf1 = gsub("[[:punct:]]", "", map_title)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Netcdf title
  netcdf_title = gsub(paste(variable),"NCDF-Data",file_title)
  
  # Combine into dataframe
  m_titles = data.frame(
    map_title,
    map_subtitle,
    ts_title,
    ts_subtitle,
    ts_axis,
    file_title,
    netcdf_title,
    map_title_size,
    ts_title_size,
    v_unit
  )
  
  return(m_titles)
}


## (General) GENERATE STATISTICS TIMESERIES DATA - creates a dataframe of statistics from timeseries data
##           data = timeseries data (numeric vector)
##           returns a numeric vector of mean, sd, min, max

generate_stats_ts = function(data){
  
  mean = mean(data, na.rm = TRUE)
  sd = sd(data, na.rm = TRUE)
  min = min(data, na.rm = TRUE)
  max = max(data, na.rm = TRUE)
  
  ts_stats = data.frame(mean, sd, min, max)
  return(ts_stats)
}

## (General) SET DEFAULT/CUSTOM AXIS VALUES
##           data_input = same as data_input for mapping function
##           mode = "Absolute" or "Anomalies"

#For Map Plots
set_axis_values = function(data_input,
                           mode){
  
  if (mode == "Absolute"){
    minmax = c(min(data_input),max(data_input))  
  } else {
    z_max = max(abs(data_input))
    minmax = c(-z_max,z_max)
  }
  
  minmax = signif(minmax,digits = 3)
  
  return(minmax)
}

#For TS Plots
set_ts_axis_values = function(data_input) {
  minmax = range(data_input, na.rm = TRUE)
  return(signif(minmax, digits = 3))
}


## (General) ***DESCRIPTION WILL BE UPDATED *** DEFAULT MAP PLOTTING FUNCTION - including taking average of dataset
##           data_input = map_datatable

##           variable = modE variable OR "SD Ratio" OR NULL (default) if mode == "Correlation"
##           mode = "Absolute", "Correlation", or ">any other text<" <- code will assume it's anomalies
##           axis_range = as created by "set_axis_values" function
##           hide_axis = TRUE or FALSE
##           points/highlights/stat_highlights_data = as created by the 
##                create_new..._data functions OR and empty dataframe if not 
##                available/used
##           c_borders = TRUE or FALSE depending on whether country borders are to be plotted
##           plotOrder = vector of shapefile names in the order they should be plotted
##           shpPickers = vector of shapefile names that have colour pickers (?)
##           plotType = "shp_colour_" or "shp_colour2_" etc. depending on the Analysis (Anomalies, Composite etc.)
##

# Plot map with ggplot2
plot_map <- function(data_input,
                     lon_lat_range,
                     variable = NULL,
                     mode = NULL,
                     titles = NULL,
                     axis_range = NULL,
                     hide_axis = FALSE,
                     points_data = data.frame(),
                     highlights_data = data.frame(),
                     stat_highlights_data = data.frame(),
                     c_borders = TRUE,
                     white_ocean = FALSE,
                     white_land = FALSE,
                     plotOrder = NULL,
                     shpPickers = NULL,
                     input = NULL,
                     plotType = "default",
                     projection = "UTM (default)",
                     center_lat = 0,
                     center_lon = 0,
                     show_rivers = FALSE,
                     label_rivers = FALSE,
                     show_lakes = FALSE,
                     label_lakes = FALSE,
                     show_mountains = FALSE,
                     label_mountains = FALSE) {

  # Define color picker prefix for shapefiles
  color_picker_prefix <- plotType
  
  # Define the color palette and unit based on the variable and mode
  if (!is.null(variable)) {  # Check if variable is not NULL
    if (variable == "Temperature") {
      v_col <- rev(brewer.pal(11, "RdBu"))
      v_unit <- "\u00B0C"
    } else if (variable == "Precipitation") {
      v_col <- brewer.pal(11, "BrBG")
      v_unit <- "mm/mon."
    } else if (variable == "SLP") {
      v_col <- rev(brewer.pal(11, "PRGn"))
      v_unit <- "hPa"
    } else if (variable == "Z500") {
      v_col <- rev(brewer.pal(11, "PRGn"))
      v_unit <- "m"
    }}
  
  # Handle the 'mode' condition as well
  if (!is.null(mode)) {  # Ensure mode is not NULL
    if (mode == "Correlation") {
      v_col <- rev(brewer.pal(11, "PuOr"))
      v_unit <- "r"
      
    } else if (mode == "Regression_coefficients") {
      v_col <- viridis(11, option = "turbo")
      v_unit <- "Coefficient"
      titles$map_title <- titles$map_title_coeff
      titles$map_subtitle <- titles$map_subtitle_coeff #overwrite titles$map_subtitle because ggplot uses it
      titles$map_title_size <- titles$map_title_size_coeff
      
    } else if (mode == "Regression_p_values") {
      v_col <- rev(brewer.pal(5, "Greens"))
      v_unit <- "p\nValues"
      v_lev <- c(0, 0.01, 0.05, 0.1, 0.2, 1)
      titles$map_title <- titles$map_title_pvals
      titles$map_subtitle <- titles$map_subtitle_pvals
      titles$map_title_size <- titles$map_title_size_pvals
      
    } else if (mode == "Regression_residuals") {
      v_unit <- paste("Residuals\n", v_unit)  # v_col and v_unit previously defined by variable
      titles$map_title <- titles$map_title_res
      titles$map_subtitle <- titles$map_subtitle_res
      titles$map_title_size <- titles$map_title_size_res
      
    } else if (mode == "SD Ratio") {
      v_col <- rev(brewer.pal(9, "Greens"))
      v_unit <- ""
    }}
  
  if (is.null(axis_range)) {  # If axis range is not provided, calculate dynamically
    max_abs_z <- max(abs(values(data_input)))
    axis_range <- c(-max_abs_z, max_abs_z)
  }
  
  p <- ggplot() +
    geom_spatraster_contour_filled(data = data_input, aes(fill = after_stat(level_mid)), bins = 20)+
    scale_fill_stepsn(
      NULL,
      n.breaks = 20,
      nice.breaks = TRUE, # Place breaks at nice values
      #labels = scales::number_format(accuracy = 2), # Uncomment if you want to round to 2 decimal places
      colors = v_col,
      limits = axis_range
    ) +
    labs(fill = v_unit) +
    # Style the color bar
    guides(
      fill = if(hide_axis) {
        "none"
      } else {
        guide_colorbar(
          barwidth = 2,
          barheight = unit(0.75, "npc"), # Match the height of the plot
          title = v_unit,
          title.position = "top",
          title.hjust = 0.25, # Center the title
          display = "rectangles",
          draw.ulim = FALSE, draw.llim = FALSE,
          label.theme = element_text(size = titles$map_title_size / 1.6),
          title.theme = element_text(size = titles$map_title_size / 1.6), # text size of the color bar labels and title is propotional with the plot title size
          frame.colour = "black",
          frame.linewidth = 0.5,
          ticks.colour = "black",
          ticks.linewidth = 0.5
        )
      }
    )
  
  # Theme
  if(projection == "UTM (default)"){
    p <- p + theme_bw()
  } else {
    p <- p + theme_minimal()
  }
  
  # Add coastline and country borders without inheriting x and y aesthetics
  p <- p + geom_sf(data = coast, color = "#333333", size = 0.5, inherit.aes = FALSE)
  if (white_ocean) {
    p <- p + geom_sf(data = oceans, fill = "#DDDDDD", size = 0.5, inherit.aes = FALSE)}
  if (white_land) {
    p <- p + geom_sf(data = land, fill = "#DDDDDD", size = 0.5, inherit.aes = FALSE)}
  if (c_borders) {
    p <- p + geom_sf(data = countries, color = "#333333", fill = NA, size = 0.5, inherit.aes = FALSE)}
  
  if (show_rivers) {
    p <- p + geom_sf(data = rivers, color = "#2A52BE", size = 0.2, inherit.aes = FALSE)
    if (label_rivers && "name" %in% names(rivers)) {
      p <- p + geom_text(
        data = st_centroid(rivers),
        aes(label = name, geometry = geometry),
        stat = "sf_coordinates",
        size = 5,
        color = "black",
        inherit.aes = FALSE
      )
    }
  }
  if (show_lakes) {
    p <- p + geom_sf(data = lakes, fill = "#DDDDDD", color = NA, inherit.aes = FALSE)
    if (label_lakes && "name" %in% names(lakes)) {
      p <- p + geom_text(
        data = st_point_on_surface(lakes),
        aes(label = name, geometry = geometry),
        stat = "sf_coordinates",
        size = 5,
        color = "black",
        nudge_x = -1,  # leftward
        inherit.aes = FALSE
      )
    }
  }
  
  if (show_mountains) {
    p <- p + geom_sf(data = mountains, color = "#333333", size = 3, shape = 17, inherit.aes = FALSE)
    if (label_mountains && "name" %in% names(mountains)) {
      p <- p + geom_text(
        data = mountains,
        aes(label = name, geometry = geometry),
        stat = "sf_coordinates",
        size = 5,
        color = "black",
        nudge_y = 0.75,  # upward
        inherit.aes = FALSE
      )
    }
  }
  
  # Add shapefiles (if provided) based on plotOrder and shpPickers
  for (file in plotOrder) {
    file_name <- tools::file_path_sans_ext(basename(file))
    if (file_name %in% shpPickers) {

      shape <- st_read(file)

      # Set or transform CRS to WGS84
      if (is.na(st_crs(shape))) {
        message(paste("CRS missing for", file_name, "- setting CRS to WGS84 (EPSG:4326)"))
        shape <- st_set_crs(shape, st_crs(4326))
      } else {
        shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
      }
      
      # Plot based on geometry type
      geom_type <- st_geometry_type(shape)
      color <- input[[paste0(color_picker_prefix, file_name)]]
      
      if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
        p <- p + geom_sf(data = shape, fill = NA, color = color, size = 0.5, inherit.aes = FALSE)
      } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
        p <- p + geom_sf(data = shape, color = color, size = 0.5, inherit.aes = FALSE)
      } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
        p <- p + geom_sf(data = shape, color = color, size = 2, inherit.aes = FALSE)
      }
    }
  }
  
  # Set projection
  if (projection == "Robinson") {
    p <- p + coord_sf(crs = st_crs("+proj=robin"))
  } else if (projection == "Orthographic") {
    formula = paste0("+proj=ortho +lat_0=", center_lat, " +lon_0=", center_lon, " +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs")
    p <- p + coord_sf(crs = st_crs(formula))
  } else if (projection == "LAEA"){
    formula = paste0("+proj=laea +lat_0=", center_lat, " +lon_0=", center_lon, " +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs")
    p <- p + coord_sf(crs = st_crs(formula))
  } else { # if UTM (default)
    # Edit lon_lat_range if its a point
    if (lon_lat_range[1]==lon_lat_range[2]){
      lon_lat_range[1] = lon_lat_range[1] - 0.5 
      lon_lat_range[2] = lon_lat_range[2] + 0.5 
    }
    if (lon_lat_range[3]==lon_lat_range[4]){
      lon_lat_range[3] = lon_lat_range[3] - 0.5
      lon_lat_range[4] = lon_lat_range[4] + 0.5 
    }
    # Edit lon_lat_range if its at the edge of the map
    if (lon_lat_range[1]<(-179.0625)){
      lon_lat_range[1] = -179.0625
    }
    if (lon_lat_range[2]>177.1875){
      lon_lat_range[2] = 177.1875
    }
    if (lon_lat_range[3]<(-87.64735)){
      lon_lat_range[3] = -87.64735
    }
    if (lon_lat_range[4]>87.64735){
      lon_lat_range[4] = 87.64735
    }
    # Set limits of plot to lon_lat range 
    p <- p + coord_sf(xlim = lon_lat_range[1:2], ylim = lon_lat_range[3:4], expand = FALSE)
  }
  
  # Add title and subtitle if provided
  if (!is.null(titles)) {
    if (titles$map_title != " ") {
      p <- p + ggtitle(titles$map_title)
    }
    if (titles$map_subtitle != " ") {
      p <- p + labs(subtitle = titles$map_subtitle)
    }
    p <- p + theme(
      plot.title = element_text(size = titles$map_title_size, face = "bold"),
      plot.subtitle = element_text(size = titles$map_title_size / 1.3, face = "plain"),
      axis.text=element_text(size = titles$map_title_size / 1.6),
    )
  }
  
  # Add point and highlights (without legend)
  if (nrow(stat_highlights_data) > 0) {
    filtered_stat_highlights_data <- subset(stat_highlights_data, criteria_vals == 1) # if criteria_vals == 0, the point is not added to the map
    
    if (nrow(filtered_stat_highlights_data) > 0) {
      print(filtered_stat_highlights_data)
      p <- p + 
        geom_point(data = filtered_stat_highlights_data, aes(x = x_vals, y = y_vals), size = 1, shape=20, show.legend = FALSE)
    }
  }
  
  if (nrow(points_data) > 0 && all(c("x_value", "y_value", "color", "shape", "size", "label") %in% colnames(points_data))) {
    p <- p + 
      geom_point(data = points_data, aes(x = x_value, y = y_value, color = color, shape = shape, size = size), show.legend = FALSE) +
      geom_text(data = points_data, aes(x = x_value, y = y_value, label = label), position = position_nudge(y = -0.5), show.legend = FALSE) +
      scale_color_identity() +
      scale_shape_identity() +
      labs(x = NULL, y = NULL)
  }
  
  if (nrow(highlights_data) > 0 && all(c("x1", "x2", "y1", "y2", "color", "type") %in% colnames(highlights_data))) {
    
    # Boxes
    if (any(highlights_data$type == "Box")) {
      p <- p +
        geom_rect(data = subset(highlights_data, type == "Box"),
                  aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, color = color),
                  fill = NA, size = 1, show.legend = FALSE) +
        scale_color_identity()
    }
    
    # Hatched boxes
    if (any(highlights_data$type == "Hatched")) {
      p <- p +
        geom_rect(data = subset(highlights_data, type == "Hatched"),
                  aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, fill = color),
                  fill = subset(highlights_data, type == "Hatched")$color,
                  color = NA, alpha = 0.5, show.legend = FALSE)
    }
  }
  
  return(p)
}



## (General) CREATE MAP DATATABLE
##           data_input = yearly_subset or subset_to_anomalies data

create_map_datatable = function(data_input,
                                subset_lon_IDs,
                                subset_lat_IDs){
  
  # find x,y & z values
  x = lon[subset_lon_IDs]
  y = lat[subset_lat_IDs]
  
  data_mean = apply(data_input,c(1:2),mean) # finds mean of input data
  z = data_mean[,rev(1:length(y))]
  
  # Transpose and rotate z
  map_data =t(z)[order(ncol(z):1),]
  
  # Add degree symbols and cardinal directions for longitude and latitude
  x_labels = ifelse(x >= 0,
                    paste(x, "\u00B0E", sep = ""),
                    paste(abs(x), "\u00B0W", sep = ""))
  y_labels = ifelse(y >= 0,
                    paste(round(y, digits = 3), "\u00B0N", sep = ""),
                    paste(abs(round(y, digits = 3)), "\u00B0S", sep = ""))
  
  # Apply labels to map data
  colnames(map_data) = x_labels
  rownames(map_data) = y_labels
  
  return(map_data)
}


## (General) CREATE BASIC TIMESERIES DATATABLE
##           data_input = same as data_input for create_map_datatable
##           year_input = either year_range or year_set (for composites)
##           year_input_type = "range" (for general) or "set" (for composites)
##           returns a dataframe of Year, Mean, Min, Max

create_timeseries_datatable = function(data_input,
                                       year_input,
                                       year_input_type,
                                       subset_lon_IDs,
                                       subset_lat_IDs){
  
  # Remove outer rows and columns from map data
  cut_data_input = data_input[-c(1,dim(data_input)[1]),-c(1,dim(data_input)[2]),]
  cut_subset_lon_IDs = subset_lon_IDs[-c(1,length(subset_lon_IDs))]
  cut_subset_lat_IDs = subset_lat_IDs[-c(1,length(subset_lat_IDs))]
  
  # Create years column
  if (year_input_type == "range"){
    Year = year_input[1]:year_input[2]
  } else {
    Year = year_input
  }
  
  # Check that cut_data is more than a single point
  if (is.null(dim(cut_data_input))){
    Mean = cut_data_input
    Min = cut_data_input
    Max = cut_data_input
  } 
  else {
    # Calculate weighted Mean column
    latlon_weights_reduced = latlon_weights[cut_subset_lat_IDs,cut_subset_lon_IDs]
    weight_function = function(df,llwr){df_weighted = (df*llwr)/sum(llwr)}
    data_weighted = apply(cut_data_input,c(3),weight_function, t(latlon_weights_reduced))
    Mean = apply(data_weighted,c(2),sum)
    
    # create Min and Max columns
    Min = apply(cut_data_input,c(3),min)
    Max = apply(cut_data_input,c(3),max)
  }
  
  # Create dataframe
  timeseries_data = data.frame(Year,Mean,Min,Max)
  
  return(timeseries_data)
}


## (General) ADD STATISTICS COLUMNS TO TS DATATABLE - adds Moving_Average, Percentile
##           and unit columns to TS datatable (if required) otherwise returns original
##           data_input = output from create_timeseries_datatable
##           add_moving_average = TRUE or FALSE
##           moving_average_range = single number (3 to 33)
##           moving_average_alignment = "before","center","right"
##           add_percentiles = TRUE of FALSE
##           percentiles = a vector of percentile values c(0.9,0.95 or 0.99)
##           use_MA_percentiles = TRUE or FALSE

add_stats_to_TS_datatable = function(data_input,
                                     add_moving_average,
                                     moving_average_range,
                                     moving_average_alignment,
                                     add_percentiles,
                                     percentiles,
                                     use_MA_percentiles){
  # Set up variables
  Year = data_input[,1]
  Mean = data_input[,2]
  
  # Create moving average column
  Moving_Average = NULL
  if (add_moving_average == TRUE){
    Moving_Average = rollmean(Mean, k=moving_average_range, fill=NA, align=moving_average_alignment)
  }
  
  # Create percentile columns
  Percentile_0.005 = NULL ; Percentile_0.995 = NULL
  Percentile_0.025 = NULL ; Percentile_0.975 = NULL
  Percentile_0.05 = NULL ; Percentile_0.95 = NULL
  
  if (add_percentiles == TRUE){
    
    # Check to see if there there are more than 10 year values
    if (length(Year) > 10){
      # Test data for normality
      p_value = shapiro.test(Mean)[[2]]
    } else {
      p_value = 0
    }

    # 0.9 Percentile 
    if (0.9 %in% percentiles){
      # Use normal distribution to find percentiles
      if(p_value>0.05){
        upper_percentile_value = qnorm(.95,mean(Mean),sd(Mean))
        lower_percentile_value = qnorm(.05,mean(Mean),sd(Mean))
      }
      # Find percentiles for non-normal data
      else {
        upper_percentile_value = as.numeric(quantile(Mean, .95)) 
        lower_percentile_value = as.numeric(quantile(Mean, .05))
      }
      
      # Constant percentiles  
      if (use_MA_percentiles == FALSE){
        Percentile_0.95 = rep(upper_percentile_value,length(Year))
        Percentile_0.05 = rep(lower_percentile_value,length(Year))
      }
      # Use moving average for percentiles 
      else {
        p_diff = (upper_percentile_value-lower_percentile_value)/2
        Percentile_0.95 = Moving_Average+p_diff
        Percentile_0.05 = Moving_Average-p_diff
      }
    }
    
    # 0.95 Percentile 
    if (0.95 %in% percentiles){
      # Use normal distribution to find percentiles
      if(p_value>0.05){
        upper_percentile_value = qnorm(.975,mean(Mean),sd(Mean))
        lower_percentile_value = qnorm(.025,mean(Mean),sd(Mean))
      }
      # Find percentiles for non-normal data
      else {
        upper_percentile_value = as.numeric(quantile(Mean, .975)) 
        lower_percentile_value = as.numeric(quantile(Mean, .025))
      }
      
      # Constant percentiles  
      if (use_MA_percentiles == FALSE){
        Percentile_0.975 = rep(upper_percentile_value,length(Year))
        Percentile_0.025 = rep(lower_percentile_value,length(Year))
      }
      # Use moving average for percentiles 
      else {
        p_diff = (upper_percentile_value-lower_percentile_value)/2
        Percentile_0.975 = Moving_Average+p_diff
        Percentile_0.025 = Moving_Average-p_diff
      }
    }
    
    # 0.99 Percentile 
    if (0.99 %in% percentiles){
      # Use normal distribution to find percentiles
      if(p_value>0.05){
        upper_percentile_value = qnorm(.995,mean(Mean),sd(Mean))
        lower_percentile_value = qnorm(.005,mean(Mean),sd(Mean))
      }
      # Find percentiles for non-normal data
      else {
        upper_percentile_value = as.numeric(quantile(Mean, .995)) 
        lower_percentile_value = as.numeric(quantile(Mean, .005))
      }
      
      # Constant percentiles  
      if (use_MA_percentiles == FALSE){
        Percentile_0.995 = rep(upper_percentile_value,length(Year))
        Percentile_0.005 = rep(lower_percentile_value,length(Year))
      }
      # Use moving average for percentiles 
      else {
        p_diff = (upper_percentile_value-lower_percentile_value)/2
        Percentile_0.995 = Moving_Average+p_diff
        Percentile_0.005 = Moving_Average-p_diff
      }
    }
  }
  
  # Update Timeseries data
  timeseries_data = data_input
  
  if (!is.null(Moving_Average)){
    timeseries_data = data.frame(timeseries_data,Moving_Average)
  }
  if (!is.null(Percentile_0.005)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.005)
  }
  if (!is.null(Percentile_0.025)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.025)
  }
  if (!is.null(Percentile_0.05)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.05)
  }
  if (!is.null(Percentile_0.95)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.95)
  }
  if (!is.null(Percentile_0.975)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.975)
  }
  if (!is.null(Percentile_0.995)){
    timeseries_data = data.frame(timeseries_data,Percentile_0.995)
  }
  
  return(timeseries_data)
}


#' PLOT TIMESERIES 
#'
#' This function sets up time series plots based on the specified type.
#'
#' @param type Character. "Anomaly", "Composites", "Monthly", "Correlation","Regression_Trend" or "Regression_Residual".
#' @param data data.frame. The main time series data table.
#' @param variable Character. Variable name: "Temperature", "Precipitation", "SLP", "Z500", or "other" (user data).
#' @param data_v1 data.frame. Time series data table for variable1 (only for "Correlation").
#' @param data_v2 data.frame. Time series data table for variable2 (only for "Correlation").
#' @param variable1 Character. Variable name for first correlation dataset (only for "Correlation").
#' @param variable2 Character. Variable name for second correlation dataset (only for "Correlation").
#' @param ref Numeric. Mean value of the reference data (default: NA).
#' @param year_range Numeric vector. Start and end year.
#' @param month_range_1 Numeric vector. Start and end month (only for "Monthly").
#' @param month_range_2 Numeric vector. Start and end month (only for "Monthly").
#' @param titles Character vector. Contains titles, subtitles, axis titles, and custom titles/subtitles.
#' @param show_key Logical. TRUE or FALSE, whether to show a key.
#' @param key_position Character. Position of the key: "top", "bottom", "left", "right", "none".
#' @param show_ticks Show yearly Ticks: Logical. TRUE or FALSE, whether to change ticks
#' @param tick_interval Numeric. Interval of ticks for X Axis
#' @param moving_ave Logical. TRUE or FALSE, whether to show a moving average.
#' @param moving_ave_year Numeric. Number of years for moving average calculation (e.g., 11-year moving average).
#' @param custom_percentile Logical. TRUE or FALSE, whether to show custom percentiles.
#' @param percentiles Numeric. Percentile value (e.g., c(0.9, 0.95, 0.99)).
#' @param highlights data.frame. Data frame containing highlight information.
#' @param lines data.frame. Data frame containing line information.
#' @param points data.frame. Data frame containing point information.
#'
#' @return A ggplot object.

plot_timeseries <- function(type,
                            mode = NA,
                            data = NA,
                            variable = NA,
                            data_v1 = NA,
                            data_v2 = NA,
                            variable1 = NA,
                            variable2 = NA,
                            ref = NA,
                            year_range = NA,
                            month_range_1 = NA,
                            month_range_2 = NA,
                            titles = NA,
                            #titles_mode=NA, titles_corr=NA, titles_reg=NA, titles_custom=NA,
                            show_key = FALSE,
                            key_position = NA,
                            show_ref = FALSE,
                            show_ticks = FALSE,
                            tick_interval = NA,
                            moving_ave = FALSE,
                            moving_ave_year = NA,
                            custom_percentile = FALSE,
                            percentiles = NA,
                            highlights = NA,
                            lines = NA,
                            points = NA,
                            axis_range = NULL)
{
  
  # Create empty dataframes for Lines, Points, Fills and boxes  
  lines_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(lines_data) = c("ID","label","x","y","lcolor","ltype","lwidth","key_show")
  
  points_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x","y","pcolor","pshape","psize","key_show")
  
  fills_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x1","x2","y1","y2","fill","key_show")
  
  boxes_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x1","x2","y1","y2","bcolor","key_show")
  
  # Set up inital row IDs
  lID = 1 ; pID = 1 ; fID = 1 ; bID = 1
  
  # Extract ylimits from data
  if (type == "Correlation") {
    y_min = min(data_v1[, 2], na.rm = TRUE)
    y_max = max(data_v1[, 2], na.rm = TRUE)
  } else if (type == "Regression_Trend") {
    y_min = min(data[, c(2, 3)])
    y_max = max(data[, c(2, 3)])
  } else if (type == "Regression_Residual") {
    y_min = min(data[, 4])
    y_max = max(data[, 4])
  } else {
    y_min = min(data[, 2])
    y_max = max(data[, 2])
  }

  # Axis Range Setting with optional padding
  if (!is.null(axis_range) && length(axis_range) == 2 && !any(is.na(axis_range))) {
    # Apply padding even to user-specified range
    y_range <- axis_range[2] - axis_range[1]
    y_Min <- axis_range[1] - (0.1 * y_range)
    y_Max <- axis_range[2] + (0.1 * y_range)
  } else {
    # Auto mode
    y_range <- y_max - y_min
    y_Min <- y_min - (0.1 * y_range)
    y_Max <- y_max + (0.1 * y_range)
  }
  
  # Edit year range if required:
  if (type == "Composites"){
    year_range = range(year_range)
  }
  
  # Add a vertical white line to set axis limits 
  new_line = data.frame(
    ID = lID,
    label = NA,
    x = year_range[1],
    y = c(y_Min,y_Max),
    lcolor = "white",
    ltype = "solid",
    lwidth = 1,
    key_show = FALSE
  )
  lines_data = rbind(lines_data,new_line)
  lID = lID+1
  
  print("Error1")
  
  # Add custom lines to data:
  if (!is.null(lines) && nrow(lines) > 0) {
    
    for (i in 1:nrow(lines)) {
      line_data <- lines[i, ]
      
      if (line_data$orientation == "Vertical"){
        x_line = line_data$location
        y_line = c(y_Min,y_Max)
      } else { # Orientation == "Horizontal"
        x_line = year_range
        y_line = line_data$location
      }
      
      new_line = data.frame(
        ID = lID,
        label = line_data$label,
        x = x_line,
        y = y_line,
        lcolor = line_data$color,
        ltype = line_data$type,
        lwidth = 1,
        key_show = line_data$key_show
      )
      lines_data = rbind(lines_data,new_line)
      lID = lID+1
    }
  }
  
  # Add Percentile Lines
  if(custom_percentile){
    # Find column for percentiles
    if (moving_ave){
      percentile_column = 6  
    } else {
      percentile_column = 5  
    }
    
    # Add lower percentile
    lower_percentile = data.frame(
      ID = lID,
      label = gsub("_", " ",gsub("\\[.*?\\]", "", colnames(data)[percentile_column])),
      x = data$Year,
      y = data[,percentile_column],
      lcolor = "gold2",
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,lower_percentile)
    lID = lID+1
    
    # Add upper percentile
    upper_percentile = data.frame(
      ID = lID,
      label = gsub("_", " ",gsub("\\[.*?\\]", "", colnames(data)[percentile_column+1])),
      x = data$Year,
      y = data[,percentile_column+1],
      lcolor = "firebrick4",
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,upper_percentile)
    lID = lID+1
  }
  
  # Add main line/points to data:
  if (type == "Anomaly" || type == "Monthly") {
    new_line = data.frame(
      ID = lID,
      label = paste(generate_title_months(month_range_1), variable, type),
      x = data$Year,
      y = data[,2],
      lcolor = get_variable_properties(variable)$color,
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1
    
  } else if (type == "Correlation") {
    new_line = data.frame(
      ID = lID,
      label = titles$V1_axis_label,
      x = data_v1$Year,
      y = data_v1[,2],
      lcolor = titles$V1_color,
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1
  } else if (type == "Composites") {
    new_point = data.frame(
      ID = pID,
      label = paste(generate_title_months(month_range_1), variable, type),
      x = as.double(data$Year),
      y = data[,2],
      pcolor = get_variable_properties(variable)$color,
      pshape = "●",
      psize = as.integer(4),
      key_show = TRUE
    )
    points_data = rbind(points_data,new_point)
    pID = pID+1
  } else if (type =="Regression_Trend"){
    new_line = data.frame(
      ID = lID,
      label = "Original",
      x = data$Year,
      y = data[,2],
      lcolor = titles$color_d,
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1  
  } else if (type =="Regression_Residual"){
    new_line = data.frame(
      ID = lID,
      label = "Residual",
      x = data$Year,
      y = data[,4],
      lcolor = titles$color_d,
      ltype = "dashed",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1  
  } else {
    stop("Invalid plot type")
  }# else if (type == "Regression"){} TBC #
  
  # Add secondary line to data:
  if (type == "Correlation") {
    # Convert data
    min_v1 <- y_min
    max_v1 <- y_max
    min_v2 <- min(data_v2[,2], na.rm = TRUE)
    max_v2 <- max(data_v2[,2], na.rm = TRUE)
    
    v2_adjusted <- (data_v2[,2] - min_v2) / (max_v2 - min_v2)  # normalize to [0, 1]
    v2_adjusted <- v2_adjusted * (max_v1 - min_v1) + min_v1     # scale to v1 range
    
    # add to lines
    new_line = data.frame(
      ID = lID,
      label = titles$V2_axis_label,
      x = data_v2$Year,
      y = v2_adjusted,
      lcolor = titles$V2_color,
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1
  }
  
  if (type =="Regression_Trend"){
    new_line = data.frame(
      ID = lID,
      label = "Trend",
      x = data$Year,
      y = data[,3],
      lcolor = "black",
      ltype = "solid",
      lwidth = 1,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1  
  }
  
  # Add moving average line to data 
  if(moving_ave){
    # Add moving average data
    if (type=="Correlation"){
      average_line = data.frame(
        ID = lID,
        label = paste0(moving_ave_year,"-Yr Moving Average "),
        x = data_v1$Year,
        y = data_v1[,5],
        lcolor = titles$V1_color,
        ltype = "solid",
        lwidth = 1.5,
        key_show = TRUE
      )
      lines_data = rbind(lines_data,average_line)
      lID = lID+1
      
      average_line = data.frame(
        ID = lID,
        label = paste0(moving_ave_year,"-Yr Moving Average"),
        x = data_v2$Year,
        y = data_v2[,5],
        lcolor = titles$V2_color,
        ltype = "solid",
        lwidth = 1.5,
        key_show = TRUE
      )
      lines_data = rbind(lines_data,average_line)
      lID = lID+1
      
    } else {
      average_line = data.frame(
        ID = lID,
        label = paste0(moving_ave_year,"-Yr Moving Average"),
        x = data$Year,
        y = data[,5],
        lcolor = "black",
        ltype = "solid",
        lwidth = 1.5,
        key_show = TRUE
      )
      lines_data = rbind(lines_data,average_line)
      lID = lID+1
    }
  }
  
  # Add custom points to data:
  if (!is.null(points) && nrow(points) > 0) {
    
    for (i in 1:nrow(points)) {
      point_data <- points[i, ]
      
      new_point = data.frame(
        ID = pID,
        label = point_data$label,
        x = point_data$x_value,
        y = point_data$y_value,
        pcolor = point_data$color,
        pshape = point_data$shape,
        psize = point_data$size,
        key_show = FALSE
      )
      points_data = rbind(points_data,new_point)
      pID = pID+1
    }
  }
  
  # Add custom highlights to data:
  if (!is.null(highlights) && nrow(highlights) > 0) {
    
    if(any(highlights$type == "Fill")) {
      fills <- subset(highlights, type == "Fill")
      
      for (i in 1:nrow(fills)) {
        fill_data <- fills[i, ]
        
        new_fill = data.frame(
          ID = fID,
          label = fill_data$label,
          x1 = fill_data$x1,
          x2 = fill_data$x2,
          y1 = fill_data$y1,
          y2 = fill_data$y2,
          fill = fill_data$color,
          key_show = fill_data$key_show
        )
        fills_data = rbind(fills_data,new_fill)
        fID = fID+1
      }
    }
    
    if(any(highlights$type == "Box")) {
      boxes <- subset(highlights, type == "Box")
      
      for (i in 1:nrow(boxes)) {
        box_data <- boxes[i, ]
        
        new_box = data.frame(
          ID = bID,
          label = box_data$label,
          x1 = box_data$x1,
          x2 = box_data$x2,
          y1 = box_data$y1,
          y2 = box_data$y2,
          bcolor = box_data$color,
          key_show = box_data$key_show
        )
        boxes_data = rbind(boxes_data,new_box)
        bID = bID+1
      }
    }
    
  }
  print("Error2")
  # Plot data 
  p = ggplot()
  
  # Plot fills
  if (nrow(fills_data>0)){
    
    #Plot
    for (i in 1:(fID-1)){
      fill_data = subset(fills_data, ID == i)
      
      if (fill_data$key_show){ # Show on legend
        p = p +  geom_rect(
          data = fill_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, fill = label),
          alpha = 0.5,
          inherit.aes = FALSE
        ) 
      } else { # Don't show on legend
        p = p +  geom_rect(
          data = fill_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2),
          fill = fill_data$fill,
          alpha = 0.5,
          inherit.aes = FALSE
        )  
      }
    }
    
    # Add legend
    fills_legend = unique(subset(fills_data, key_show == TRUE)[,c("ID","label","fill")])
    if (!is.null(fills_legend) && nrow(fills_legend)>0){
      p = p + scale_fill_manual(values = setNames(fills_legend$fill,fills_legend$label))
    }
  }
  print("Error2.2")
  # Plot lines
  if (nrow(lines_data>0)){
    
    #Plot
    for (i in 1:(lID-1)){
      line_data = subset(lines_data, ID == i)
      
      if (line_data$key_show[1]){ # Show on legend
        p = p + geom_line(
          data = line_data,
          aes(x = x, y = y, linetype = label),
          linewidth = line_data$lwidth[1],
          color = line_data$lcolor[1]
        ) 
      } else { # Don't show on legend
        p = p + geom_line(
          data = line_data,
          aes(x = x, y = y),
          linetype = line_data$ltype[1],
          linewidth = line_data$lwidth[1],
          color = line_data$lcolor[1]
        ) 
      }
    }
    
    # Add legend
    lines_legend = unique(subset(lines_data, key_show == TRUE)[,c("ID","label","ltype")])
    if (!is.null(lines_legend) && nrow(lines_legend)>0){
      p = p + scale_linetype_manual(values = setNames(lines_legend$ltype,lines_legend$label))
    }
  }
  
  # Plot Boxes
  if (nrow(boxes_data>0)){
    
    #Plot
    for (i in 1:(bID-1)){
      box_data = subset(boxes_data, ID == i)
      
      if (box_data$key_show){ # Show on legend
        p = p +  geom_rect(
          data = box_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, color = label),
          fill = "white", alpha = 0, linewidth = 1,
          inherit.aes = FALSE
        ) 
      } else { # Don't show on legend
        p = p +  geom_rect(
          data = box_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2),
          color = box_data$bcolor,
          fill = "white", alpha = 0, linewidth = 1,
          inherit.aes = FALSE
        )  
      }
    }
    
    # Add legend
    boxes_legend = unique(subset(boxes_data, key_show == TRUE)[,c("ID","label","bcolor")])
    if (!is.null(boxes_legend) && nrow(boxes_legend)>0){
      p = p + scale_color_manual(values = setNames(boxes_legend$bcolor,boxes_legend$label))
    }
  }
  
  # Plot points
  if (nrow(points_data)>0){
    
    for (i in 1:nrow(points_data)){
      point_data = points_data[i,]
      
      if (point_data$key_show){ # Show on legend
        p = p + geom_point(
          data = point_data,
          aes(x = x, y = y, shape = label),
          size = point_data$psize,
          color = point_data$pcolor
        ) 
      } else { # Don't show on legend
        p = p + geom_point(
          data = point_data,
          aes(x = x, y = y),
          shape = point_data$pshape,
          size = point_data$psize,
          color = point_data$pcolor
        )
      }  
      # Add labels
      if (type == "Composites"){start_ID = 1} else {start_ID = 0}
      
      if (point_data$ID > start_ID) {
        p <- p + geom_text(
          data = point_data,
          aes(x = x, y = y, label = label),
          vjust = -1.5,   # vertical adjustment
          hjust = 0.5,  # horizontal adjustment
          size = 5,     # text size
          color = "black"  # or any color you want
        )
      }
    }
    
    # Add legend
    points_legend = unique(subset(points_data, key_show == TRUE)[,c("ID","label","pshape")])
    if (!is.null(points_legend) && nrow(points_legend)>0){
      p = p + scale_shape_manual(values = setNames(points_legend$pshape,points_legend$label))
    }
  }
  
  print("Error3")

  # Add theme
  p <- p + theme_bw(base_size = 18)
  
  # Add title and subtitle if provided
  if (!is.null(titles)) {
    p <- p + labs(x = "Year", y = titles$ts_axis)
    
    # Add secondary axis for correlation
    if (type =="Correlation"){
      p = p + scale_y_continuous(
        name = sub(";.*$", "", titles$V1_axis_label),
        limits = c(y_Min,y_Max),expand = c(0, 0),
        sec.axis = sec_axis(~ ( . - min_v1) / (max_v1 - min_v1) * (max_v2 - min_v2) + min_v2,
                            name = sub(";.*$", "", titles$V2_axis_label)) # Shift and scale the secondary axis
      ) +
        
        theme(
          axis.title.y = element_text(color = titles$V1_color),
          axis.title.y.right = element_text(color = titles$V2_color)
        ) 
    }
    
    # Get rid of titles for Regression Residual TS
    if (type =="Regression_Residual"){
      titles$ts_title = "  "
      titles$ts_subtitle = "  "
    }
    
    if (titles$ts_title != " ") {
      p <- p + ggtitle(titles$ts_title)
    }
    
    # if (!is.null(titles$ts_subtitle)) {
    #   p <- p + labs(subtitle = titles$ts_subtitle)
    # }
    
    if (!is.null(titles$ts_subtitle) && !is.na(titles$ts_subtitle) && titles$ts_subtitle != "") {
      p <- p + labs(subtitle = titles$ts_subtitle)
    }
    
    p <- p + theme(
      plot.title = element_text(size = titles$ts_title_size, face = "bold"),
      plot.subtitle = element_text(size = titles$ts_title_size / 1.3, face = "plain"),
      axis.text=element_text(size = titles$ts_title_size / 1.6),
    )
  } 
  
  # Set legend groupings
  if (type == "Composites") {
    p <- p + guides(
      fill = guide_legend(title = NULL, order = 3),
      color = guide_legend(title = NULL, order = 4),
      linetype = guide_legend(title = NULL, order = 2),
      shape = guide_legend(title = "Legend", order = 1)
    )
  } else {
    p <- p + guides(
      fill = guide_legend(title = NULL, order = 3),
      color = guide_legend(title = NULL, order = 4),
      linetype = guide_legend(title = "Legend", order = 1),
      shape = guide_legend(title = NULL, order = 2)
    )
  }
  
  # Set legend visibility and position
  if (show_key) {
    p <- p + theme(legend.position = key_position)  # Apply the position from `key_position`
  } else {
    p <- p + theme(legend.position = "none")  # Remove the legend if `show_key == FALSE`
  }
  
  # Optional: If you want to make sure legends don’t appear for other components when `show_key == FALSE`
  if (!show_key) {
    p <- p + guides(fill= "none",color= "none", linetype = "none",shape= "none")  # Ensure guides are turned off
  }
  
  # Remove whitespace
  p <- p + scale_x_continuous(limits = year_range,expand = c(0, 0))
  if(type != "Correlation"){
    p = p + scale_y_continuous(limits = c(y_Min,y_Max),expand = c(0, 0))
  }
  
  # Add tick marks
  if (show_ticks) {
    p <- p + scale_x_continuous(
      limits = year_range,
      expand = c(0, 0),
      breaks = seq(year_range[1], year_range[2], by = tick_interval)
    )
  } else {
    p <- p + scale_x_continuous(
      limits = year_range,
      expand = c(0, 0)
    )
  }
  
  # Add reference line
  if (show_ref){
    p = p + 
      geom_hline(yintercept = 0, color = "black", linetype = "solid", size = 1) +  
      annotate("text", 
               x = year_range[1] + diff(year_range)/25.5,  # mimic text_x offset
               y = 0,                                      # label at line
               label = paste0(ref, titles$v_unit),
               vjust = -0.5,                               # just above line
               size = 5)
  }
  
  # Return the final plot
  return(p)
}


## ADD DATA TO TS - Adds data to a ggplot timeseries. Either as a line or a point
##          data = data to be added. dataframe with columns 'Year', 'Mean', 'Min', 'Max' (for anomalies), and 'Year', 'Original', 'Trend', 'Residuals' (for regression)
##          variable = variable to be added (for regression: the DV)
##          plottype = "Anomalies", "Correlation", "Regression", "Monthly"
##          legend_label = string identifying the colors and linetype later added via scale_color_manual and scale_linetype_manual
##          vcol = variable colour (only required for composites)

add_data_to_TS <- function(data,
                           variable,
                           plottype,
                           legend_label,
                           show_key,
                           vcol) {
  
  # Ensure legend_label is part of the data
  data$legend_label <- factor(rep(legend_label, nrow(data)), levels = legend_label)
  
  y <- data[, 2]
  
  # Return the appropriate geom layer without modifying a plot
  if (plottype == "Composites") {
    return(geom_point(
      data = data,
      aes(x = Year, y = y, shape = legend_label),
      color = vcol,
      size = 2,
      show.legend = show_key
    ))
  } else {
    return(geom_line(
      data = data,
      aes(x = Year, y = y, color = legend_label, linetype = legend_label),
      linewidth = 1,
      show.legend = show_key
    ))
  }
  print(legend_label)
}


## (General) ADD CUSTOM FEATURES TO TIMESERIES PLOT (Points, Lines, Highlights)
##              p = ggplot object containing the timeseries plot
##              highlights_data = dataframe with columns x1, x2, y1, y2, color, type
##              lines_data = dataframe with columns location, color, type, orientation
##              points_data = dataframe with columns x_value, y_value, color, shape, size, label
##              labels, colors, linetypes = lists that track legend entries

add_timeseries_custom_features <- function(p,
                                           highlights_data = NULL,
                                           lines_data = NULL,
                                           points_data = NULL,
                                           labels = NULL,
                                           colors = NULL,
                                           linetypes = NULL,
                                           year_range = NULL,
                                           data_mean = NULL) {
  
  # --- CUSTOM LINES ---
  if (!is.null(lines_data) && nrow(lines_data) > 0) {
    
    # Create a key_label column to control legend inclusion
    lines_data$key_label <- ifelse(lines_data$key_show, lines_data$label, NA)
    
    # Add all lines to plot
    for (i in 1:nrow(lines_data)) {
      line_data <- lines_data[i, ]
      
      # Vertical lines
      if (line_data$orientation == "Vertical") {
        p <- p + geom_vline(data = line_data,
                            aes(xintercept = location),
                            color = line_data$color,
                            linetype = line_data$type,
                            size = 1,
                            show.legend = FALSE)
      }
      
      # Horizontal lines
      if (line_data$orientation == "Horizontal") {
        p <- p + geom_hline(data = line_data,
                            aes(yintercept = location),
                            color = line_data$color,
                            linetype = line_data$type,
                            size = 1,
                            show.legend = FALSE)
      }
    }
    
    # Add ghost_lines to show on key
    lines_to_show <- subset(lines_data, key_show == TRUE)
    
    if (length(lines_to_show[,1]>0)){
      for (i in 1:nrow(lines_to_show)) {
        line <- lines_to_show[i, ]
        
        # Create a ghost line data frame with NA x/y values
        ghost_line <- data.frame(
          x = year_range,
          y = c(data_mean,data_mean + 0.0000001),
          label = line$label
        )
        
        # Add the ghost line (only in legend)
        p <- p + geom_line(
          data = ghost_line,
          aes(x = x, y = y, color = label, linetype = label),
          alpha = 0,
          size = 1,
          show.legend = TRUE,
          na.rm = TRUE
        )
        
        # Update legend entries
        labels <- c(labels, line$label)
        colors <- c(colors, line$color)
        linetypes <- c(linetypes, line$type)
      }
    }
    
  }  
  
  return(list(p = p, labels = labels, colors = colors, linetypes = linetypes))
}


## (General) GET VARIABLE PROPERTIES

get_variable_properties <- function(variable,
                                    secondary = FALSE) {
  # Determine unit
  unit <- switch(variable,
                 "Temperature" = "\u00B0C",
                 "Precipitation" = "mm/month",
                 "SLP" = "hPa",
                 "Z500" = "m",
                 "other" = "units")  # Default for custom variables
  
  # Determine color
  if (secondary == FALSE){
    color <- switch(variable,
                    "Temperature" = "red3",
                    "Precipitation" = "turquoise4",
                    "SLP" = "purple4",
                    "Z500" = "green4",
                    "other" = "darkorange2",  # Default for custom variables
                    "black")  # Fallback
  } else { #use different colors for Correlation if the variables are the same
    color <- switch(variable,
                    "Temperature" = "red2",
                    "Precipitation" = "turquoise2",
                    "SLP" = "purple2",
                    "Z500" = "green2",
                    "other" = "saddlebrown",  # Default for custom variables
                    "black")  # Fallback
  }
  
  # Return both unit and color
  return(list(unit = unit, color = color))
}

## (General) REWRITE MAPTABLE - rewrites maptable to get rid of degree symbols 
##                              Set subset_lon/lat to NA for correlation/regression

rewrite_maptable = function(maptable,
                            subset_lon_IDs,
                            subset_lat_IDs){
  
  if (is.na(subset_lon_IDs[1])){
    rnames = rownames(maptable)
    cnames = colnames(maptable)
    
    maptable1 = rbind(as.numeric(substr(cnames, 1, nchar(cnames) - 1)),as.matrix(maptable))
    maptable2 = cbind(c("Lat/Lon", as.numeric(substr(rnames, 1, nchar(rnames) - 1))), maptable1)
    colnames(maptable2)<- NULL
    
  } else {
    maptable1 = rbind(round(lon[subset_lon_IDs],digits = 3),as.matrix(maptable))
    maptable2 = cbind(c("Lat/Lon", round(lat[subset_lat_IDs],digits = 3)), maptable1)
  }
  
  return(maptable2)
}


## (General) REWRITE TS TABLE - rewites ts_datatable to round values and add units
##                              to column headings 

rewrite_tstable = function(tstable,
                           variable){
  
  # Create units
  if (variable == "Temperature"){
    v_unit = "[\u00B0C]"
  } else if (variable == "Precipitation"){
    v_unit = "[mm/month]"
  } else if (variable == "SLP"|variable == "Z500"){
    v_unit = "[m]"
  } else {
    v_unit = ""
  }
  
  newnames = paste(colnames(tstable),"",v_unit, sep = "")
  colnames(tstable) = c("Year",newnames[-1])
  
  new_tstable = round(tstable, 2)
  
  return(new_tstable)
}


## (General) LOAD MODE-RA SOURCE DATA loads ModE-RA data sources for
##           a given year and season
##           year = a single user selected or default year
##           season = "summer" or "winter"

load_modera_source_data = function(year,
                                   season){
  # Load data
  feedback_data = read.csv(paste0("data/feedback_archive_fin/",season,year,".csv"))  
}


## (General) PLOT MODE-RA SOURCES creates a plot of the ModE-RA data sources for
##           a given year and season
##           year = a single user selected or default year
##           season = "summer" or "winter"
##           minmax_lonlat = c(min_lon,max_lon,min_lat,max_lat) ->
##                           c(-180,180,-90,90) for non-zoomed plot

plot_modera_sources = function(ME_source_data,
                               year,
                               season,
                               minmax_lonlat){
  
  # Load data
  world=map_data("world")
  
  # Sum total sources and observations
  
  if (identical(minmax_lonlat, c(-180, 180, -90, 90))) {
    total_observations = sum(ME_source_data$Omitted_Duplicates) + nrow(ME_source_data)
    visible_sources = nrow(ME_source_data)
    cut_sources = sum(ME_source_data$Omitted_Duplicates)
  } else {
    in_boundary = ME_source_data$LON > minmax_lonlat[1] & ME_source_data$LON < minmax_lonlat[2] &
      ME_source_data$LAT > minmax_lonlat[3] & ME_source_data$LAT < minmax_lonlat[4]
    total_observations = sum(ME_source_data$Omitted_Duplicates[in_boundary]) + sum(in_boundary)
    visible_sources = sum(in_boundary)
    cut_sources = sum(ME_source_data$Omitted_Duplicates[in_boundary])
  }
  
  # Create Season & Year title
  if (season == "summer"){
    season_title = "Apr. to Sept."
    yr = year
  } else {
    season_title = "Oct. to Mar."
    yr = paste0((year-1),"/",year)
  }
  
  # Set color scheme
  type_list = c("ice_proxy","glacier_ice_proxy","lake_sediment_proxy","tree_proxy","coral_proxy","instrumental_data","documentary_proxy","speleothem_proxy","bivalve_proxy","other_proxy")
  # Paul Tol's Muted Colour List for Colour Blind People
  color_list = c('#88CCEE', '#332288', '#DDCC77', '#117733', '#CC6677', '#882255', '#44AA99', '#999933', '#AA4499', '#000000')
  # color_list = brewer.pal(10,"Paired")
  named_colors = setNames(color_list,type_list)
  
  # Set shape scheme
  variable_list = c("sea_level_pressure","no_of_rainy_days","pressure","precipitation","temperature","historical_proxy","natural_proxy")
  shape_list = c(3,2,4,6,5,0,1)
  named_shapes = setNames(shape_list,variable_list)
  
  # Plot
  ggplot() + geom_polygon(data=world, aes(x=long, y=lat, group=group), fill="grey", color = "darkgrey") + 
    geom_sf() + coord_sf(xlim = minmax_lonlat[c(1,2)], ylim = minmax_lonlat[c(3,4)], crs = st_crs(4326), expand = FALSE) +
    geom_point(data=ME_source_data, aes(x=LON, y=LAT, color=TYPE, shape=VARIABLE), alpha=1, size = 1.5) +
    labs(title = paste0("Assimilated Observations - ",season_title," ",yr),
         subtitle = paste0("Total Sources = ", visible_sources), x = "", y = "") +
    scale_shape_manual(values = named_shapes) +
    scale_colour_manual(values = named_colors) +
    guides() + 
    theme_classic()+
    theme(panel.border = element_rect(colour = "black", fill=NA))  
}


## (General) DOWNLOAD MODE-RA SOURCES DATA

download_feedback_data = function(global_data,
                                  lon_range,
                                  lat_range) {
  
  # Subset data based on lon and lat range
  subset_data = global_data[(global_data$LON > lon_range[1]) & (global_data$LON < lon_range[2]) &
                              (global_data$LAT > lat_range[1]) & (global_data$LAT < lat_range[2]), ]
}

## (General) PLOT MODE-RA SOURCES AS TIME SERIES in the new ModE-RA section
##           data = The read and prepared data for the TS plot
##           year_column = Name of the Column of the Years (X Axis, I think) = "Year"
##           selected_columns = Input of the selected lines of the source plots (Set fix to all Columns)
##           line_titles = Titles for the legend of the plot
##           title = "Total Global Sources"
##           x_label = "Year"
##           y_label = "No. of Sources"
##           x_ticks_every = 20
##           year_range = Input of the Year Range of the Sources

# Custom function for formatting y-axis labels with apostrophe for thousands separator
comma_apostrophe <- function(x) {
  format(x, big.mark = "'", scientific = FALSE)
}

# Function to create the time series plot for selected lines with a legend
plot_ts_modera_sources <- function(data,
                                   year_column,
                                   selected_columns,
                                   line_titles,
                                   title,
                                   x_label,
                                   y_label,
                                   x_ticks_every,
                                   year_range) {
  # Filter data based on the selected year range
  data <- data %>% filter(get(year_column) >= year_range[1], get(year_column) <= year_range[2])
  
  # Define custom colors for each line (adjust as needed)
  line_colors <- c(
    "Global Sources (Apr. - Sept.)" = "#882255",
    "Global Sources (Oct. - Mar.)" = "#332288",
    "Global Sources Total" = "#117733"
  )
  
  # Calculate the maximum value of the selected columns
  max_value <- data %>% select(all_of(selected_columns)) %>% max(na.rm = TRUE)
  
  # Determine appropriate breaks based on the maximum value (rounded up to next whole number)
  y_breaks <- ceiling(seq(0, max_value, length.out = 10))
  
  # Determine x-axis tick marks dynamically based on year range
  if ((year_range[2] - year_range[1]) <= 10) {
    x_ticks_every <- 2  # Tick every year if range is 10 years or less
  } else if ((year_range[2] - year_range[1]) <= 20) {
    x_ticks_every <- 5  # Tick every 5 years if range is between 11 and 20 years
  } else {
    x_ticks_every <- 20  # Default tick interval if range is more than 20 years
  }
  
  # Create an empty plot object using ggplot
  p <- ggplot(data) +
    labs(title = title, x = x_label, y = y_label, color = "Legend (select individual lines below)") +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 20, color = "#094030"),
      axis.title.x = element_text(size = 15, color = "#094030"),
      axis.title.y = element_text(size = 15, color = "#094030"),
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.title = element_text(size = 12, face = "bold", color = "#094030")  # Make the legend title bold
    )
  
  # Add each selected line to the plot with customized titles and colors
  for (col in selected_columns) {
    title <- line_titles[[col]]
    p <- p + geom_line(aes_string(x = year_column, y = col, color = shQuote(title)), linewidth = 1)
  }
  
  # Adjust x-axis tick marks
  if (x_ticks_every > 1) {
    p <- p + scale_x_continuous(breaks = seq(year_range[1], year_range[2], by = x_ticks_every))
  }
  
  # Format y-axis labels with apostrophe for thousands separator
  p <- p + scale_y_continuous(labels = comma_apostrophe, breaks = y_breaks)
  
  # Set manual color scale with consistent colors
  p <- p + scale_color_manual(values = line_colors)
  
  # Convert ggplot to plotly for interactivity
  p <- ggplotly(p, tooltip = c("x","y"))
  
  return(p)
}

## (General) GENERATE CUSTOM NETCDF
##           data_input = map plotting data
##           tab = "general" or "composites"
##           ncdf_ID = randomly generated ID from ClimeApp
##           user_nc_variables = a string with all ModE-RA variables to be 
##                               included in the netcdf 
##           mode = "Absolute","Anomalies","Anomaly_fixed" or "Anomaly_yrs_prior"
##           year_range = year_range for general tab or year_set for composites 
##           baseline_range,baseline_years_before = NA if not used

generate_custom_netcdf = function(data_input,
                                  tab,dataset,
                                  ncdf_ID,
                                  variable,
                                  user_nc_variables,
                                  mode,subset_lon_IDs,
                                  subset_lat_IDs,
                                  month_range,
                                  year_range,
                                  baseline_range,
                                  baseline_years_before){
  
  # Create NA variables for each ModE-RA variable
  temp_variable_data = NA
  prec_variable_data = NA
  SLP_variable_data = NA
  Z500_variable_data = NA
  
  for (i in user_nc_variables){
    if (i == variable){
      variable_data = data_input
    } else {
      
      # Generate data_ID for new variable
      data_ref = generate_data_ID(dataset,i,month_range)
      
      # Access variable base data (if pp data not available)
      if (data_ref[1]==0){
        data1 = load_ModE_data(dataset,i)
      } else if (data_ref[1]==2){
        data1 = load_preprocessed_data(data_ref)
      } else {
        data1 = NA
      }
      # Generate latlon subset data
      data2 =  create_latlon_subset(data1, data_ref, subset_lon_IDs, subset_lat_IDs)
      # Generate yearly subset data
      if (tab == "general"){
        data3 = create_yearly_subset(data2, data_ref, year_range, month_range)
      }
      else if (tab == "composites"){
        data3 =  create_yearly_subset_composite(data2, data_ref, year_range, month_range) 
      }
      # Generate reference data 
      if (tab == "general"){
        refd = create_yearly_subset(data2, data_ref, baseline_range, month_range)
        data4 = apply(refd,c(1:2),mean)
      }
      else if (tab == "composites"){ # TBC if used for COMPOSITES!
        refd =  create_yearly_subset_composite(data2, data_ref, baseline_range, month_range) 
        data4 = apply(refd,c(1:2),mean)
      }
      
      # Generate anomalies data
      if (mode == "Absolute"){ # TBC
        variable_data = data3
      } else if (mode == "Anomaly_yrs_prior"){ #TBC
        variable_data = convert_composite_to_anomalies(data3,data2,data_ref,year_range,month_range,baseline_years_before)
      } else {
        variable_data = convert_subset_to_anomalies(data3,data4)
      }
    }
    # Save variable data
    if (i == "Temperature"){temp_variable_data = variable_data}
    else if (i == "Precipitation"){prec_variable_data = variable_data}
    else if (i == "SLP"){SLP_variable_data = variable_data}
    else if (i == "Z500"){Z500_variable_data = variable_data}
  }
  
  # Define dimensions
  londim <- ncdim_def("longitude","degrees_east",as.double(lon[subset_lon_IDs])) 
  latdim <- ncdim_def("latitude","degrees_north",as.double(lat[subset_lat_IDs])) 
  if (tab == "general"){
    timedim <- ncdim_def("time","year",as.double(seq(year_range[1],year_range[2],1)))  
  } else { # for composites
    timedim <- ncdim_def("time","year",as.double(year_range)) 
  }
  
  # Create variable long_name additions:
  if (mode == "Absolute"){
    ln_extension = ""
  } else if (mode == "Anomaly_yrs_prior"){
    ln_extension = paste(", anomaly compared to",baseline_years_before,"years prior")
  } else {
    ln_extension = paste(", anomaly compared to",baseline_range[1],"to",baseline_range[2],"reference period")
  }
  
  # Define variables and create list of variable defs
  variable_def_list = list()
  
  if ("Temperature" %in% user_nc_variables){
    dlname <- paste("air temperature at 2m",ln_extension, sep = "")
    temp_def <- ncvar_def("air_temperature","deg_C",list(londim,latdim,timedim),missval=NULL,dlname,prec="single")
    variable_def_list = append(variable_def_list,list(temp_def))
  }
  if ("Precipitation" %in% user_nc_variables){
    dlname <- paste("total_precipitation (rain and snow)",ln_extension, sep = "")
    prec_def <- ncvar_def("total_precipitation","mm/month",list(londim,latdim,timedim),missval=NULL,dlname,prec="single")
    variable_def_list = append(variable_def_list,list(prec_def))
  }
  if ("SLP" %in% user_nc_variables){
    dlname <- paste("air pressure at sea level",ln_extension, sep = "")
    SLP_def <- ncvar_def("air_pressure_at_sea_level","hPa",list(londim,latdim,timedim),missval=NULL,dlname,prec="single")
    variable_def_list = append(variable_def_list,list(SLP_def))
  }
  if ("Z500" %in% user_nc_variables){
    dlname <- paste("500 hPa geopotential height",ln_extension, sep = "") 
    Z500_def <- ncvar_def("geopotential_height","m",list(londim,latdim,timedim),missval=NULL,dlname,prec="single")# to check
    variable_def_list = append(variable_def_list,list(Z500_def))
  }  
  
  # Create netCDF file 
  ncfname <- paste("user_ncdf/netcdf_",ncdf_ID,".nc", sep="")
  ncout <- nc_create(ncfname,variable_def_list,force_v4=TRUE)
  
  # Add variable data to netcdf file
  if ("Temperature" %in% user_nc_variables){
    ncvar_put(ncout,temp_def,temp_variable_data)
  }
  if ("Precipitation" %in% user_nc_variables){
    ncvar_put(ncout,prec_def,prec_variable_data)
  }
  if ("SLP" %in% user_nc_variables){
    ncvar_put(ncout,SLP_def,SLP_variable_data)
  }
  if ("Z500" %in% user_nc_variables){
    ncvar_put(ncout,Z500_def,Z500_variable_data)
  }
  
  # Add additional attributes into dimension variables
  ncatt_put(ncout,"longitude","axis","X") 
  ncatt_put(ncout,"latitude","axis","Y")
  ncatt_put(ncout,"time","axis","T")
  
  # Add global attributes
  ncatt_put(ncout,0,"data","ModE-RA Project")
  ncatt_put(ncout,0,"grid","1.875 deg_longitude, 1.865 deg_latitude")
  ncatt_put(ncout,0,"institution","Institute of Geography,University of Bern")
  ncatt_put(ncout,0,"source","ClimeApp") 
  #ncatt_put(ncout,0,"references","tbc") # to be completed
  history <- paste("Created", date(), sep=", ")
  ncatt_put(ncout,0,"history",history)
  ncatt_put(ncout,0,"Conventions","CF-1.4")
  
  # Export netcdf
  nc_close(ncout)
}

## (General) CREATE A GEOREFERENCED TIFF RASTER FROM THE MAP DATATABLE WITH OPTION TO SAVE IT TO A FILE
##           map_data = numeric 2d vector, output of create_map_datatable()
##           output_file = where to write it

create_geotiff <- function(map_data,
                           output_file = NULL) {
  
  # Extract longitudes and latitudes from column and row names and retaining original sign
  x <- as.numeric(gsub("°[EW]", "", colnames(map_data))) *
    ifelse(grepl("E", colnames(map_data)), 1, -1)
  
  y <- as.numeric(gsub("°[NS]", "", rownames(map_data))) * 
    ifelse(grepl("N", rownames(map_data)), 1, -1)
  
  # Check if dimensions of the matrix match the lon/lat lengths
  if (ncol(map_data) != length(x) || nrow(map_data) != length(y)) {
    stop("Matrix dimensions do not match the provided longitude/latitude ranges")
  }
  
  r <- rast(as.matrix(map_data))
  ext(r) <- ext(min(x), max(x), min(y), max(y)) # define raster extent
  
  crs(r) <- "EPSG:4326"  # EPSG:4326 = WGS84
  
  # Save the raster as a georeferenced TIFF file (terra package)
  # This option is only executed if the argument output_file is provided (used for the download)
  if(!is.null(output_file)) {
    writeRaster(r, output_file, filetype = "GTiff", overwrite = TRUE)
  }
  
  return(r)
}

## (General) Load SDRATIO data


## (General) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR PLOT
##           data input = Input form Plot Customization

generate_metadata <- function(axis_mode,
                              axis_input,
                              hide_axis,
                              title_mode,
                              title1_input,
                              title2_input, 
                              custom_statistic,
                              sd_ratio,
                              hide_borders) {
  
  # Adjust axis_input based on axis_mode
  if (axis_mode == "Automatic") {
    axis_input <- NA
  } else if (length(axis_input) == 2) {
    axis_input <- paste(axis_input, collapse = ",")
  }
  
  # Create the metadata data frame with explicit column names
  meta_input <- data.frame(
    axis_mode, 
    axis_input, 
    hide_axis, 
    title_mode, 
    title1_input, 
    title2_input,
    custom_statistic, 
    sd_ratio, 
    hide_borders
  )
  
  return(meta_input)
}

## (General) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR TS
##           data input = Input form Plot Customization

generate_metadata_ts <- function(title_mode_ts,
                                 title1_input_ts,
                                 show_key_ts,
                                 key_position_ts,
                                 show_ref_ts,
                                 custom_average_ts,
                                 year_moving_ts,
                                 percentile_ts,
                                 moving_percentile_ts) {
  
  
  # Create the metadata data frame with explicit column names
  meta_input_ts <- data.frame(
    title_mode_ts, 
    title1_input_ts, 
    show_key_ts, 
    key_position_ts, 
    show_ref_ts, 
    custom_average_ts,
    year_moving_ts, 
    percentile_ts, 
    moving_percentile_ts
  )
  
  return(meta_input_ts)
}


## (General) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##           data input = Generation plot inputs from side bar

generate_metadata_plot <- function(dataset,
                                   variable,
                                   range_years,
                                   select_sg_year,
                                   sg_year,
                                   season_sel,
                                   range_months,
                                   ref_period,
                                   select_sg_ref,
                                   sg_ref,
                                   lon_range,
                                   lat_range,
                                   lonlat_vals) {
  
  #Generate dataframe from plot inputs
  plot_input <- data.frame(
    dataset,
    variable,
    range_years,
    select_sg_year,
    sg_year,
    season_sel,
    range_months,
    ref_period,
    select_sg_ref,
    sg_ref,
    lon_range,
    lat_range,
    lonlat_vals
  )
  
  return(plot_input)
  
}

## (General) UPDATES THE SELECTED VALUE OF A GROUP OF LINKED RADIO BUTTONS
##           selected_value = the value to be selected
##           inputIds = a list of input IDs for the radio buttons to be updated

updateRadioButtonsGroup <- function(selected_value,
                                    inputIds) {
  session <- getDefaultReactiveDomain()
  lapply(inputIds, function(inputId) {
    updateRadioButtons(
      session = session,
      inputId = inputId,
      label = NULL,
      selected = selected_value
    )
  })
}

#### Plot Features Functions #### 

# USEFUL CODE for adding/taking away data:
# df <- df[-nrow(df),]

# USEFUL CODE for implementation in shiny:
# point_shapes_numeric = sapply(point_shapes,switch,
#                              "circle" = 16,
#                              "triangle" = 17,
#                              "square" = 15)

## (Plot Features) CREATE SD RATIO DATA - creates SD ratio data for the current 
##                 year/season/region selected
##                 data_input = custom_sd_data() (which can also be pp data)
##                 tab = "general" or "composites"
##                 year_range = year range or year set

create_sdratio_data = function(data_input,
                               data_ID,
                               tab,
                               variable,
                               subset_lon_IDs,
                               subset_lat_IDs,
                               month_range,
                               year_range){
  
  # Change data_ID to identify data as preprocessed but not preloaded:
  if (data_ID[1]==1){ data_ID[1]=2 } 
  
  # Lat/lon subset:
  SD_data1 = create_latlon_subset(data_input,data_ID,subset_lon_IDs, subset_lat_IDs)  
  # Yearly subset:
  if (tab == "general"){
    SD_data2 = create_yearly_subset(SD_data1, data_ID, year_range, month_range)
  } else {
    SD_data2 = create_yearly_subset_composite(SD_data1, data_ID, year_range, month_range)
  }
  
  return(SD_data2)
}


## (Plot Features) CREATE STATISTICAL HIGHLIGHTS DATA - creates a dataframe for
##                 adding dots to an anomaly map to mark points which match a certain criteria
##                 stat_highlight = "None","% sign match", "SD ratio"
##                 data_input = any subset_to_anomaly ModE-RA data
##                 sd_data = output from create_sdratio_data
##                 tab = "general" or "composites"
##                 add_stat_highlight = TRUE or FALSE
##                 sdratio = any numeric value from 0 to 1
##                 percent = any numeric value from 1 to 100

create_stat_highlights_data = function(data_input,
                                       sd_data,
                                       stat_highlight,
                                       sdratio,
                                       percent,
                                       subset_lon_IDs,
                                       subset_lat_IDs){
  if (stat_highlight != "None"){
    if (stat_highlight == "% sign match"){
      # Create sign_check function
      matching_sign_check = function(anom_data,chosen_p){
        pos = sum(anom_data>0)
        neg = sum(anom_data<0)
        if (pos>neg){
          sign.percent = (pos/(pos+neg))*100
        } else {
          sign.percent = (neg/(pos+neg))*100
        }
        if (sign.percent>chosen_p){
          criteria.match = 1 # set to preferred point size
        } else {
          criteria.match = 0
        }
        return(criteria.match)
      }
      
      # Apply sign_check function across input data
      criteria_vals = c(apply(data_input, c(1:2),matching_sign_check,percent))
    }
    
    else if (stat_highlight == "SD ratio"){
      # Mean data:
      SD_data3 = apply(sd_data,c(1,2),mean)
      
      # SD ratio check:
      sd_ratio_check = function(sd_data,chosen_sdr){
        if (sd_data > chosen_sdr){
          criteria.match = 0
        } else {
          criteria.match = 1
        }
        return(criteria.match)
      }
      
      # Apply ratio check function across SD ratio data
      criteria_vals = c(apply(SD_data3,c(1,2),sd_ratio_check,sdratio))
    }
    
    # Create vectors of x and y values
    x = lon[subset_lon_IDs]
    y = lat[subset_lat_IDs]
    
    x_vals = c(array(rep(x,length(y)),dim = c(length(x),length(y)))) 
    y_vals = c(t(array(y,dim = c(length(y),length(x)))))
    
    # Combine into dataframe
    S_H_data = data.frame(x_vals,y_vals,criteria_vals)  
    
  }
  
  else {
    S_H_data = data.frame()
  }
  
  return(S_H_data)
}


## (Plot Features) CREATE NEW HIGHLIGHTS DATA - creates a dataframe for new custom
##                 highlights to add to the main highlights_data
##              highlight_x_values = a vector - c(x1,x2) - for the left/right edge
##              highlight_y_values = a vector - c(y1,y2) - for the bottom/top edge
##              highlight_color = a single character string giving highlight color
##              highlight_type = "Fill","Box","Hatched"
##              show_highlight_on_key = TRUE or FALSE (FALSE by default)
##              highlight_label = a label for the highlight on the key ("") by default)

create_new_highlights_data = function(highlight_x_values,
                                      highlight_y_values,
                                      highlight_color,
                                      highlight_type,
                                      show_highlight_on_key,
                                      highlight_label) {
  
  x1 = highlight_x_values[1]
  x2 = highlight_x_values[2]
  y1 = highlight_y_values[1]
  y2 = highlight_y_values[2]
  
  color = highlight_color
  type = highlight_type
  key_show = show_highlight_on_key
  label = highlight_label
  
  # Combine into a dataframe
  new_h_data = data.frame(x1,x2,y1,y2,color,type,key_show,label)
  
  return(new_h_data)
}


## (Plot Features) CREATE NEW LINES DATA - creates a dataframe of new lines
##                                         to add to the main lines_data
##              line_orientaton = "Horizontal" or "Vertical"
##              line_locations = a CHARACTER string of locations to plot the lines,
##                                 seperated by commas (e.g. "1823,1824,1828" or "1.9,2.3"
##              line_color = a single character string giving highlight color
##              line_type = "solid" or "dashed"
##              show_line_on_key = TRUE or FALSE (FALSE by default)
##              line_label = a label for the line on the key ("") by default)

create_new_lines_data = function(line_orientation,
                                 line_locations,
                                 line_color,
                                 line_type,
                                 show_line_on_key,
                                 line_label){
  
  # Create location coordinates from string
  location = as.numeric(unlist(strsplit(line_locations,",")))
  
  # Repeat other values to match location length
  orientation = rep(line_orientation,length(location))
  color = rep(line_color,length(location))
  type = rep(line_type,length(location))
  key_show = rep(show_line_on_key,length(location))
  label = rep(line_label,length(location))
  
  # Combine into a dataframe
  new_l_data = data.frame(orientation,location,color,type,key_show,label)
  
  return(new_l_data)
}


## (Plot Features) CREATE NEW POINTS DATA - creates a dataframe of data on the new
##                 points to add to the main points_data 
##                point_x/y_values = a single lon/x/lat/y value or character string 
##                                   with several seperated by commas
##                point_label = a single point label
##                point_shape = single value for shape IDs (circle = 16,
##                          triangle = 17, square = 15)
##                point_color = a single character string giving point color
##                point_size = a single point size (sizes 0 -10)

create_new_points_data = function(point_x_values,
                                  point_y_values,
                                  point_label,
                                  point_shape,
                                  point_color,
                                  point_size) {
  # Create x/y values from strings
  x_value = as.numeric(unlist(strsplit(point_x_values, ",")))
  y_value = as.numeric(unlist(strsplit(point_y_values, ",")))
  # Repeat other values to match x/y length
  label = rep(point_label, length(x_value))
  shape = rep(point_shape, length(x_value))
  color = rep(point_color, length(x_value))
  size = rep(point_size, length(x_value))
  # Combine into a dataframe
  new_p_data = data.frame(x_value, y_value, label, shape, color, size)

  
  return(new_p_data)
  
}


## (Plot Features) ADD CORRELATION TIMESERIES - replots both correlation timeseries 
##                                              over other features and adds moving
##                                              average (if selected)
##                 data_input1/2 = output from add_stats_to_TS_datatable for v1/v2

add_correlation_timeseries = function(data_input1,
                                      data_input2,
                                      variable1,
                                      variable2,
                                      correlation_titles){
  
  # Set up variables for plotting
  x = data_input1$Year
  y1 = data_input1[,2]
  y2 = data_input2[,2]
  
  cnames = colnames(data_input1)
  
  v_col1 = correlation_titles$V1_color
  v_col2 = correlation_titles$V2_color
  
  # Save original graphical parameters and increase the plot margins
  old.par = par(mar = c(0, 0, 0, 0))
  par(mar = c(5, 4, 4, 4) + 0.25)
  
  # Needed to merge the plots
  par(new = TRUE)
  
  # Plot variable 1
  
  plot(x,y1,type = "l", col = v_col1, lwd=2, xaxs="i", axes = FALSE, bty = "n", xlab = "", ylab = "")
  if ("Moving_Average" %in% cnames){
    lines(x,data_input1$Moving_Average,lwd = 3.5,col = "black")
    lines(x,data_input1$Moving_Average,lwd = 2,col = v_col1)
  }
  
  # Needed to merge the plots
  par(new = TRUE)
  
  # Plot variable 2
  plot(x,y2,type = "l", col = v_col2, lwd=2, xaxs="i", axes = FALSE, bty = "n", xlab = "", ylab = "")
  if ("Moving_Average" %in% cnames){
    lines(x,data_input2$Moving_Average,lwd = 3.5,col = "black")
    lines(x,data_input2$Moving_Average,lwd = 2,col = v_col2)
  }
  # Reset original graphical parameters
  par(old.par)
  
}





## (Plot Features) ADD SHAPE FILE LAYERS TO STANDARD PLOTS
##                  zipFile = input to the shpFile
##                  plotOrder = reactive Value to store the plot Order
##                  pickerInput = Layer Picker Input
##                  reorderSelect = Modal Button
##                  reorderAfter = Modal Button
##                  input = Colour Input

# Define a function to extract shapefile contents and update plot order (Anomaly)
updatePlotOrder <- function(zipFile,
                            plotOrder,
                            pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "anomaly_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Define a function to extract shapefile contents and update plot order (Composite)
updatePlotOrder2 <- function(zipFile,
                             plotOrder,
                             pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "composite_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Define a function to extract shapefile contents and update plot order (Correlation)
updatePlotOrder3 <- function(zipFile,
                             plotOrder,
                             pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "correlation_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Define a function to extract shapefile contents and update plot order (Regression Coefficient)
updatePlotOrder_reg_coeff <- function(zipFile,
                                       plotOrder,
                                       pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "reg_coeff_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Define a function to extract shapefile contents and update plot order (Regression P-Value)
updatePlotOrder_reg_pval <- function(zipFile,
                                       plotOrder,
                                       pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "reg_pval_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Define a function to extract shapefile contents and update plot order (Regression Residual)
updatePlotOrder_reg_res <- function(zipFile,
                                     plotOrder,
                                     pickerInput) {
  # Create a unique temporary directory for this function
  temp_dir <- tempfile(pattern = "reg_res_")
  dir.create(temp_dir)
  
  # Unzip the shapefile
  unzip(zipFile, exdir = temp_dir)
  
  # Find shapefiles in the temporary directory
  shpFiles <- list.files(temp_dir, pattern = ".shp$", full.names = TRUE)
  
  # Update the plot order reactive value
  plotOrder(shpFiles)
  
  # Update picker input choices
  updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(shpFiles)))
}

# Function to generate color picker UI dynamically (Anomaly)
createColorPickers <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers)
}

# Function to generate color picker UI dynamically (Composite)
createColorPickers2 <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers2 <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour2_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers2)
}

# Function to generate color picker UI dynamically (Correlation)
createColorPickers3 <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers3 <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour3_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers3)
}

# Function to generate color picker UI dynamically (Reg. Coefficient)
createColorPickers4a <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers4a <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour4a_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers4a)
}

# Function to generate color picker UI dynamically (Reg. P-Value)
createColorPickers4b <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers4b <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour4b_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers4b)
}

# Function to generate color picker UI dynamically (Reg. Residual)
createColorPickers4c <- function(plotOrder, shpFile) {
  req(shpFile)
  # Get the list of shapefiles from the reactive value
  shp_files <- plotOrder
  
  # Create color pickers for each shapefile
  colorpickers4c <- lapply(shp_files, function(file) {
    file_name <- tools::file_path_sans_ext(basename(file))
    colourpicker::colourInput(inputId = paste0("shp_colour4c_", file_name), 
                              label   = paste("Border Color for", file_name),
                              value = "black", # default color for the border
                              showColour = "background",
                              allowTransparent = TRUE,
                              palette = "square")
  })
  
  # Combine color pickers into a tag list
  do.call(tagList, colorpickers4c)
}

#Create reorder modal
createReorderModal <- function(plotOrder, shpFile) {
  req(shpFile)
  # Create the modal dialog
  showModal(
    modalDialog(
      selectizeInput("reorderSelect", "Select Shapefile to Move", choices = basename(plotOrder), multiple = FALSE),
      selectizeInput("reorderAfter", "Move After", choices = basename(plotOrder), multiple = FALSE),
      footer = tagList(
        actionButton("reorderConfirm", "Move"),
        modalButton("Cancel")
      )
    ))
}

#Reorder shape file
reorder_shapefiles <- function(plotOrder,
                               reorderSelect,
                               reorderAfter,
                               pickerInput) {
  
  new_order <- plotOrder()
  file_to_move_basename <- reorderSelect
  move_after_basename <- reorderAfter
  
  # Check if file_to_move_basename and move_after_basename are the same
  if (file_to_move_basename != move_after_basename) {
    # Retrieve full paths
    file_to_move <- new_order[grep(file_to_move_basename, new_order)]
    move_after <- new_order[grep(move_after_basename, new_order)]
    
    if (length(file_to_move) > 0) {  # Ensure file_to_move is found in new_order
      new_order <- new_order[new_order != file_to_move]
      if (length(move_after) > 0)  # Ensure move_after is found in new_order
        insert_index <- match(move_after, new_order) + 1
      else
        insert_index <- 1
      new_order <- c(new_order[seq_len(insert_index - 1)], file_to_move, new_order[seq(insert_index, length(new_order))])
      plotOrder(new_order)
      updatePickerInput(inputId = pickerInput, choices = tools::file_path_sans_ext(basename(new_order)))
      removeModal()
    }
  } else {
    # If file_to_move_basename and move_after_basename are the same, do nothing
    # Or you can add any specific handling for this case
    message("file_to_move_basename and move_after_basename are the same.")
  }
}

## (Plot Features - Annual Cycles) CREATE NEW POINTS DATA - creates a dataframe of 
##             points to be added to the main points_data for annual cycle plots.
##
## point_x_values  = a character string or comma-separated vector of dates in YYYY-MM-DD format (e.g., "2000-06-01")
## point_y_values  = numeric values for y (or comma-separated string)
## point_label     = a label to show on the plot (and optionally in legend)
## point_shape     = point shape ID (circle = 16, triangle = 17, square = 15)
## point_color     = a color string (e.g., "red", "#009900")
## point_size      = point size (numeric, usually between 4 and 20)

create_new_points_data_ac <- function(point_x_values,
                                      point_y_values,
                                      point_label,
                                      point_shape,
                                      point_color,
                                      point_size) {
  x_value <- as.Date(unlist(strsplit(point_x_values, ",")))
  y_value <- as.numeric(unlist(strsplit(point_y_values, ",")))
  
  label <- rep(point_label, length(x_value))
  shape <- rep(point_shape, length(x_value))
  color <- rep(point_color, length(x_value))
  size  <- rep(point_size, length(x_value))
  
  new_p_data <- data.frame(x_value, y_value, label, shape, color, size)
  
  return(new_p_data)
}


## (Plot Features - Annual Cycles) CREATE NEW LINES DATA - creates a dataframe of 
##             custom lines to be added to the main lines_data for annual cycle plots.
##
## line_orientation     = "Horizontal" or "Vertical"
## line_locations       = a CHARACTER string of positions (comma-separated), 
##                        dates (e.g., "2000-06-01") for vertical lines, numerics for horizontal
## line_color           = a character string for color (e.g., "black", "#FF00FF")
## line_type            = line style: "solid", "dashed", etc.
## show_line_on_key     = TRUE or FALSE (whether to include in legend)
## line_label           = legend label for this line (optional)

create_new_lines_data_ac <- function(line_orientation,
                                     line_locations,
                                     line_color,
                                     line_type,
                                     show_line_on_key,
                                     line_label) {
  locations_raw <- unlist(strsplit(line_locations, ","))
  
  location <- if (line_orientation == "Vertical") {
    as.Date(locations_raw)
  } else {
    as.numeric(locations_raw)
  }
  
  orientation <- rep(line_orientation, length(location))
  color       <- rep(line_color, length(location))
  type        <- rep(line_type, length(location))
  key_show    <- rep(show_line_on_key, length(location))
  label       <- rep(line_label, length(location))
  
  new_l_data <- data.frame(orientation, location, color, type, key_show, label)
  
  return(new_l_data)
}


## (Plot Features - Annual Cycles) CREATE NEW HIGHLIGHTS DATA - creates a dataframe of 
##             fill or box highlights for annual cycle plots, where the x-axis is date-based.
##
## highlight_x_values     = numeric month values (e.g., c(7, 9) for July to September)
## highlight_y_values     = y-range values (e.g., c(-1, 3))
## highlight_color        = a character string giving fill or border color
## highlight_type         = "Fill" or "Box"
## show_highlight_on_key  = TRUE or FALSE (default = FALSE)
## highlight_label        = optional label for legend

create_new_highlights_data_ac <- function(highlight_x_values,
                                          highlight_y_values,
                                          highlight_color,
                                          highlight_type,
                                          show_highlight_on_key,
                                          highlight_label) {
  x1 <- as.Date(paste0("2000-", highlight_x_values[1], "-01"))
  x2 <- as.Date(paste0("2000-", highlight_x_values[2], "-01"))
  y1 <- highlight_y_values[1]
  y2 <- highlight_y_values[2]
  
  new_h_data <- data.frame(
    x1 = x1,
    x2 = x2,
    y1 = y1,
    y2 = y2,
    color = highlight_color,
    type = highlight_type,
    key_show = show_highlight_on_key,
    label = highlight_label
  )
  
  return(new_h_data)
}


#### Composite Functions ####

## (Composite) Read user year data and convert into a year_set vector
##             data_input_manual = a string of years (e.g. "1455,1532,1782")
##             data_input_filepath = filepath to an excel or csv document listing
##                                   years to be composited
##                                   (assumes column DOES NOT have a header)

read_composite_data = function(data_input_manual,
                               data_input_filepath,
                               year_input_mode){
  
  # Create year_set vector from manual or uploaded years
  if(year_input_mode == "Manual"){
    year_set = as.integer(unlist(strsplit(data_input_manual,",")))
    # Check if file is excel or csv
  } else if (is.null(data_input_filepath)){
    year_set = c(1815,1816)
  } else if (grepl(".csv",data_input_filepath, fixed = TRUE)==TRUE){
    year_set = read.csv(data_input_filepath)[[1]]
  } else {
    year_set = read_excel(data_input_filepath)[[1]]
  }
  
  # Check for header and remove
  if (is.character(year_set[1])){
    year_set = as.numeric(year_set[-1])
  }
  
  # Cut years outside the range of ModE-RA
  year_set = subset(year_set,year_set>=1422 & year_set<=2008)
  
  return(year_set)
}

## (Composite) Calculate yearly subset given a set of years 
##             data_input = any create_latlon_subset data
##             year_set = set of years to be composited (format c(1422,1457,...))
##                        as generated by read_composite_data  

create_yearly_subset_composite = function(data_input,
                                          data_ID,
                                          year_set,
                                          month_range){
  
  # Check for preprocessed subset
  if (data_ID[1] != 0){
    year_IDs = year_set-1420 
    data_subset = data_input[,,year_IDs]
  } 
  # or calculate from data_input
  else {
    dim_data = dim(data_input)
    years = year_set
    
    data_subset = array(NA,dim=c(dim_data[1],dim_data[2], length(years)))
    
    for (i in 1:length(years)){
      Y = years[i]
      M1 = ((12*(Y-1421))+month_range[1]) ; M2 = ((12*(Y-1421))+month_range[2]) 
      data_subset[,,i] = apply(data_input[,,M1:M2],c(1:2),mean)
    }
  }
  
  return(data_subset)
}


## (Composite) Calculate composite anomalies compared to x years before
##             data_input = create_yearly_subset_composite data
##             ref_data = corresponding create_latlon_subset data that yearly_subset
##                        was generated from
##             baseline_years_before = number of years before to calculate each anomaly
##                                     w.r.t. (i.e 5 for a mean of the 5 preceding years)

convert_composite_to_anomalies = function(data_input,
                                          ref_data,
                                          data_ID,
                                          year_set,
                                          month_range,
                                          baseline_year_before){
  
  # Remove years where year_set - baseline_years_before < 1422
  subset_year_IDs = which(year_set-baseline_year_before >= 1422)
  subset_year_set = year_set[subset_year_IDs]
  subset_data_input = data_input[,,subset_year_IDs]
  
  # Create empty array for all baseline values 
  dim_data = dim(subset_data_input)
  baseline_array = array(NA,dim=c(dim_data[1],dim_data[2], length(subset_year_set)))
  
  # Use PP data to calculate baselines
  if (data_ID[1]!=0){
    for (i in 1:length(subset_year_set)){
      year_list = c()
      for (j in 1:baseline_year_before){ # Note: years_before COULD be a chosen range (i.e.10-20 years before)
        Y_ID = (subset_year_set[i]-j)-1421
        year_list = c(year_list,Y_ID)
      }
      baseline_array[,,i] = apply(ref_data[,,year_list],c(1:2),mean)
    }  
  }
  # Calculate baselines from scratch
  else {
    for (i in 1:length(subset_year_set)){
      month_list = c()
      for (j in 1:baseline_year_before){ # Note: years_before COULD be a chosen range (i.e.10-20 years before)
        Y = subset_year_set[i]-j
        M1 = ((12*(Y-1421))+month_range[1]) ; M2 = ((12*(Y-1421))+month_range[2]) 
        month_list = c(month_list,M1:M2)
      }
      baseline_array[,,i] = apply(ref_data[,,month_list],c(1:2),mean)
    }
  }
  
  anomaly_data = subset_data_input-baseline_array
  
  return(anomaly_data)
}

## (Composite) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR PLOT
##             data input = Input form Plot Customization

generate_metadata_comp <- function(axis_mode2,
                                   axis_input2,
                                   hide_axis2,
                                   title_mode2,
                                   title1_input2,
                                   title2_input2, 
                                   custom_statistic2,
                                   percentage_sign_match2,
                                   sd_ratio2,
                                   hide_borders2) {
  
  # Adjust axis_input based on axis_mode
  if (axis_mode2 == "Automatic") {
    axis_input2 <- NA
  } else if (length(axis_input2) == 2) {
    axis_input2 <- paste(axis_input2, collapse = ",")
  }
  
  # Create the metadata data frame with explicit column names
  meta_input2 <- data.frame(
    axis_mode2, 
    axis_input2, 
    hide_axis2, 
    title_mode2, 
    title1_input2, 
    title2_input2,
    custom_statistic2,
    percentage_sign_match2,
    sd_ratio2, 
    hide_borders2
  )
  
  return(meta_input2)
}

## (Composite) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR TS
##             data input = Input form Plot Customization

generate_metadata_ts_comp <- function(title_mode_ts2,
                                      title1_input_ts2,
                                      show_key_ts2,
                                      key_position_ts2,
                                      show_ref_ts2,
                                      custom_percentile_ts2,
                                      percentile_ts2) {
  
  
  # Create the metadata data frame with explicit column names
  meta_input_ts2 <- data.frame(
    title_mode_ts2, 
    title1_input_ts2, 
    show_key_ts2, 
    key_position_ts2, 
    show_ref_ts2, 
    custom_percentile_ts2,
    percentile_ts2 
  )
  
  return(meta_input_ts2)
}


## (Composite) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##             data input = Generation plot inputs from side bar

generate_metadata_plot_comp <- function(dataset2,
                                        variable2,
                                        range_years2,
                                        season_sel2,
                                        range_months2,
                                        ref_period2,
                                        select_sg_ref2,
                                        sg_ref2,
                                        prior_years2,
                                        range_years2a,
                                        lon_range2,
                                        lat_range2,
                                        lonlat_vals2) {
  
  #Generate dataframe from plot inputs
  plot_input2 <- data.frame(
    dataset2, #selectInput
    variable2, #selectInput
    range_years2, #textInput
    season_sel2, #radioButtons
    range_months2, #radioButtons
    ref_period2, #numericRangeInput
    select_sg_ref2, #checkboxInput
    sg_ref2, #numericInput
    prior_years2, #numericInput
    range_years2a, #textInput
    lon_range2, #numericInput
    lat_range2, #numericInput
    lonlat_vals2 #VALUE
  )
  
  return(plot_input2)
  
}


#### Reg/Cor Functions ####

## (Regression/Correlation) LOAD USER DATA
##                          data_input_filepath = filepath to an excel or csv document
##                                                col1 = years, col2 = variable 
##                                                headers = TRUE

read_regcomp_data = function(data_input_filepath) {
  # Read in user data
  if (grepl(".csv", data_input_filepath, fixed = TRUE) == TRUE) {
    user_data = read.csv(data_input_filepath)
  } else {
    user_data = read_excel(data_input_filepath)
  }
  
  user_data = replace(user_data, user_data == -999.9, NA)
  
  print(summary(user_data)) ### REMOVE
  
  return(user_data)
}

## (Regression/Correlation) EXTRACT SHARED YEAR RANGE from user/modE-RA data,which can 
##                          be used to set min,max and value of year_range input
##                          - returns a vector with c(year_range1,year_range2,
##                            year_range_min,year_range_max)
##                          variable_source = "ModE-RA" or "User Data"
##                          variable_data_filepath = "" by default
##                          variable1_lag = number of lagged years for variable 1
##                          variable2_lag = number of lagged years for variable 2

extract_year_range = function(variable1_source,
                              variable2_source,
                              variable1_data_filepath,
                              variable2_data_filepath,
                              variable1_lag = 0,
                              variable2_lag = 0) {
  # Set initial values of V1_min/max and V2_min/max to ModE-RA defaults
  V1_min = 1422
  V1_max = 2008
  V2_min = 1422
  V2_max = 2008
  
  # Set V1_min/max from user data
  if (variable1_source == "User Data" &
      !is.null(variable1_data_filepath)) {
    if (grepl(".xls", variable1_data_filepath, fixed = TRUE) == TRUE) {
      years = read_excel(variable1_data_filepath, range = cell_cols("A"))
      V1_min = min(years)
      V1_max = max(years)
    }
    else if (grepl(".csv", variable1_data_filepath, fixed = TRUE) == TRUE) {
      years = read.csv(variable1_data_filepath)[, 1]
      V1_min = min(years)
      V1_max = max(years)
    }
  }
  
  # Set V2_min/max from user data
  if (variable2_source == "User Data" &
      !is.null(variable2_data_filepath)) {
    if (grepl(".xls", variable2_data_filepath, fixed = TRUE) == TRUE) {
      years = read_excel(variable2_data_filepath, range = cell_cols("A"))
      V2_min = min(years)
      V2_max = max(years)
    }
    else if (grepl(".csv", variable2_data_filepath, fixed = TRUE) == TRUE) {
      years = read.csv(variable2_data_filepath)[, 1]
      V2_min = min(years)
      V2_max = max(years)
    }
  }
  
  # Adjust V_min/max for lag years
  V1_min_adjusted = V1_min - variable1_lag
  V1_max_adjusted = V1_max - variable1_lag
  V2_min_adjusted = V2_min - variable2_lag
  V2_max_adjusted = V2_max - variable2_lag
  
  # Find shared year range
  YR_min = max(c(V1_min_adjusted, V2_min_adjusted))
  YR_max = min(c(V1_max_adjusted, V2_max_adjusted))
  
  return(c(YR_min, YR_max, V1_min, V1_max, V2_min, V2_max))
}  


## (Regression/Correlation) CREATE USER DATA SUBSET - cuts user data to year_range
##                          and chosen variable , adjusts years based on lag and
##                          replaces missing values with NA
##                      data_input = as created by read_regcomp_data
##                      variable = as selected from user data headings (a single string
##                                 for correlation, or multiple strings for regression)
##                      year_range = as selected by the user (from the range of years 
##                                   generated by extract_year_range) 
##                      lag = number of years user data has been lagged by

create_user_data_subset = function(data_input,
                                   variable,
                                   year_range,
                                   lag = 0) {
  lagged_year_range = year_range + lag
  UD_ss_year_range = subset(data_input,
                            data_input[, 1] >= lagged_year_range[1] &
                              data_input[, 1] <= lagged_year_range[2])
  UD_ss_variable = UD_ss_year_range[, variable]
  UD_ss_year = UD_ss_year_range[, 1] - lag
  
  UD_ss = data.frame(UD_ss_year, UD_ss_variable)
  colnames(UD_ss) = c("Year", variable)
  
  # Replace missing values an text with NAs
  UD_ss[, 2] = as.numeric(UD_ss[, 2])
  
  return(UD_ss)
}


## (Regression/Correlation) EXTRACT SHARED LONLAT VALUES - Find shared lonlat values for
##                          v1 and v2 that will be used for the map plot

extract_shared_lonlat = function(variable1_type,
                                 variable2_type,
                                 variable1_lon_range,
                                 variable1_lat_range,
                                 variable2_lon_range,
                                 variable2_lat_range){
  
  # If variable 1 is a timeseries:
  if (variable1_type == "Timeseries"){
    shared_lon_range = variable2_lon_range
    shared_lat_range = variable2_lat_range
  } else if (variable2_type == "Timeseries"){
    shared_lon_range = variable1_lon_range
    shared_lat_range = variable1_lat_range
  } else{
    shared_lon_range = c(max(c(variable1_lon_range[1],variable2_lon_range[1])),
                         min(c(variable1_lon_range[2],variable2_lon_range[2])))
    shared_lat_range = c(max(c(variable1_lat_range[1],variable2_lat_range[1])),
                         min(c(variable1_lat_range[2],variable2_lat_range[2])))
  }
  
  shared_lonlat = c(shared_lon_range,shared_lat_range)
  
  return(shared_lonlat)
}


#### Correlation Functions  ####

## Special Input required:
## variable1/2_type = "Timeseries" or "Field" ("Timeseries" by default)
##                    Choice appears, and selection is updated to "Field" IF
##                    variable is ModE-RA AND length(subset_lon & subset_lat) > 2 
##                    (i.e. NOT a single point)


## (Correlation) PLOT USER TIMESERIES
##               data_input = user_data_subset
##               color = a string giving the colour of the timeseries
##                        "darkorange2" for V1 or "saddlebrown" for V2


plot_user_timeseries = function(data_input,
                                color) {
  # Calculate y statistics
  y = data_input[, 2]
  y_range = range(data_input[, 2])

  # Test data for normality
  p_value = shapiro.test(data_input[, 2])[[2]]
  if (p_value > 0.05) {
    y_sd = sd(data_input[, 2])
  } else {
    y_sd = NA
  }

  #Plot
  plot(
    data_input$Year,
    y,
    type = "l",
    col = color,
    lwd = 2,
    xaxs = "i",
    xlab = "Year",
    ylab = colnames(data_input)[2]
  )

  title(
    paste(
      "Range = ",
      signif(y_range[1], 3),
      ":",
      signif(y_range[2], 3),
      "   SD = ",
      signif(y_sd, 3),
      sep = ""
    ),
    cex.main = 1,
    font.main = 1,
    adj = 1,
    line = 0.5
  )
}


## (Correlation) GENERATE CORRELATION TITLES - creates a dataframe of V1_axis_label,
##                                             V2_axis_label, V1_color,V2_color,
##                                             TS_title, Map_title,file_title
##             variable_source = "ModE-RA" or "User Data"
##             variable = user or ModE-RA variable name
##             variable_type = "Timeseries" or "Field"
##             variable_mode = "Absolute" or "Anomaly"
##             method = "pearson" or "spearman" ("pearson" by default)

generate_correlation_titles = function(variable1_source,
                                       variable2_source,
                                       variable1_dataset,
                                       variable2_dataset,
                                       variable1,
                                       variable2,
                                       variable1_type,
                                       variable2_type,
                                       variable1_mode,
                                       variable2_mode,
                                       variable1_month_range,
                                       variable2_month_range,
                                       variable1_lon_range,
                                       variable2_lon_range,
                                       variable1_lat_range,
                                       variable2_lat_range,
                                       year_range,
                                       method,
                                       map_title_mode,
                                       ts_title_mode,
                                       map_custom_title,
                                       map_custom_subtitle,
                                       ts_custom_title,
                                       title_size) {
  
  # Set values for variable 1:
  if (variable1_source=="User Data"){
    V1_axis_label = variable1
    V1_color = "darkorange2"
    V1_TS_title = variable1
    V1_map_title = variable1
    V1_file_title = variable1
    
    # If V1 = ModE-RA
  } else {
    # Generate ME title months and extension
    title_months1 = generate_title_months(variable1_month_range)
    if (variable1_mode == "Absolute"){
      variable1_mode = ""
    }
    # Generate units & color scheme for TS plots
    if (variable1 == "Temperature"){
      V1_color = "red3" ; V1_unit = "[\u00B0C]"
    }
    else if (variable1 == "Precipitation"){
      V1_color = "turquoise4" ; V1_unit = "[mm/month]"
    }
    else if (variable1 == "SLP"){
      V1_color = "purple4" ; V1_unit = "[hPa]"
    }
    else if (variable1 == "Z500"){
      V1_color = "green4" ; V1_unit = "[m]"
    }
    # Generate lon/lat addition
    if (variable1_lon_range[1]==variable1_lon_range[2]) {
      V1_lon_title = paste(variable1_lon_range[1],"\u00B0E",sep = "")
    } else {
      V1_lon_title = paste(variable1_lon_range[1],":",variable1_lon_range[2],"\u00B0E", sep = "")
    }
    if (variable1_lat_range[1]==variable1_lat_range[2]){
      V1_lat_title = paste(variable1_lat_range[1],"\u00B0N",sep = "")
    } else {
      V1_lat_title = paste(variable1_lat_range[1],":",variable1_lat_range[2],"\u00B0N", sep = "")
    }
    V1_lonlat = paste("[",V1_lon_title,", ",V1_lat_title,"]",sep = "")
    
    # Generate titles
    V1_axis_label = paste(title_months1,variable1,variable1_mode,V1_unit)
    V1_TS_title = paste(variable1_dataset,title_months1,variable1,variable1_mode,V1_lonlat)
    if (variable1_type == "Timeseries"){
      V1_Map_title = paste(variable1_dataset,title_months1,variable1,variable1_mode,V1_lonlat)
    } else {
      V1_Map_title = paste(variable1_dataset,title_months1,variable1,variable1_mode)
    }
    V1_file_title = paste(variable1_dataset,title_months1,variable1,variable1_mode)
  }
  
  # Set values for variable 2:
  if (variable2_source=="User Data"){
    V2_axis_label = variable2
    V2_color = "saddlebrown"
    V2_TS_title = variable2
    V2_Map_title = variable2
    V2_file_title = variable2
    # If V2 = ModE-RA
  } else {
    # Generate ME title months and extension
    title_months2 = generate_title_months(variable2_month_range)
    if (variable2_mode == "Absolute"){
      variable2_mode = ""
    }
    # Generate units & color scheme
    if (variable2 == "Temperature"){
      V2_color = "red3" ; V2_unit = "[\u00B0C]"
    }
    else if (variable2 == "Precipitation"){
      V2_color = "turquoise4" ; V2_unit = "[mm/month]"
    }
    else if (variable2 == "SLP"){
      V2_color = "purple4" ; V2_unit = "[hPa]"
    }
    else if (variable2 == "Z500"){
      V2_color = "green4" ; V2_unit = "[m]"
    }
    # Generate lon/lat addition
    if (variable2_lon_range[1]==variable2_lon_range[2]) {
      V2_lon_title = paste(variable2_lon_range[1],"\u00B0E",sep = "")
    } else {
      V2_lon_title = paste(variable2_lon_range[1],":",variable2_lon_range[2],"\u00B0E", sep = "")
    }
    if (variable2_lat_range[1]==variable2_lat_range[2]){
      V2_lat_title = paste(variable2_lat_range[1],"\u00B0N",sep = "")
    } else {
      V2_lat_title = paste(variable2_lat_range[1],":",variable2_lat_range[2],"\u00B0N", sep = "")
    }
    V2_lonlat = paste("[",V2_lon_title,", ",V2_lat_title,"]",sep = "")
    
    # Generate titles
    V2_axis_label = paste(title_months2,variable2,variable2_mode,V2_unit)
    V2_TS_title = paste(variable2_dataset,title_months2,variable2,variable2_mode,V2_lonlat)
    if (variable2_type == "Timeseries"){
      V2_Map_title = paste(variable2_dataset,title_months2,variable2,variable2_mode,V2_lonlat)
    } else {
      V2_Map_title = paste(variable2_dataset,title_months2,variable2,variable2_mode)
    }
    V2_file_title = paste(variable2_dataset,title_months2,variable2,variable2_mode)
  }
  
  # Edit colors and titles if v1 and v2 are the same
  if (variable1 == variable2 & variable1_source !="User Data" & variable2_source !="User Data"){
    if (variable1 == "Temperature"){
      V1_color = "red4" ; V2_color = "red2"
    }
    else if (variable1 == "Precipitation"){
      V1_color = "turquoise4" ; V2_color = "turquoise2"
    }
    else if (variable1 == "SLP"){
      V1_color = "purple4" ; V2_color = "purple2"
    }
    else if (variable1 == "Z500"){
      V1_color = "green4" ; V2_color = "green2"
    }  
    
    V1_axis_label = paste(V1_axis_label,";",V1_lonlat)
    V2_axis_label = paste(V2_axis_label,";",V2_lonlat)
  }
  
  # Generate combined titles:
  if (ts_title_mode == "Custom"){
    ts_title = ts_custom_title
  } else {
    ts_title = paste(V1_TS_title,"&",V2_TS_title)
  }
  
  map_title <- ifelse(map_title_mode == "Custom" & map_custom_title != "", map_custom_title, "Correlation coefficient")
  map_subtitle <- ifelse(map_title_mode == "Custom" & map_custom_subtitle != "", map_custom_subtitle, paste(V1_TS_title,"&",V2_TS_title))
  
  # Generate download titles
  tf0 = paste("Corr",V1_file_title,"&",V2_file_title)
  tf1 = gsub("[[:punct:]]", "", tf0)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')

  # Title font size
  map_title_size = ifelse(map_title_mode == "Custom", title_size, 18)
  ts_title_size = title_size
  
  cor_titles = data.frame(
    map_title,
    map_subtitle,
    ts_title,
    file_title,
    map_title_size,
    ts_title_size,
    V1_axis_label,
    V2_axis_label,
    V1_color,
    V2_color
  )
  
  return(cor_titles)
}


## (Correlation) PLOT COMBINED TIMESERIES
##               variable_data = either user_data_subset
##                               or ModE-RA timeseries_datatable
##               correlation_titles = as generated by generate_correlation_titles function                 

plot_combined_timeseries = function(variable1_data,
                                    variable2_data,
                                    correlation_titles){
  
  # Set up variables for plotting
  x = variable1_data[,1]
  y1 = variable1_data[,2]
  y2 = variable2_data[,2]
  
  # Save original graphical parameters and increase the plot margins
  old.par = par(mar = c(0, 0, 0, 0))
  par(mar = c(5, 4, 4, 4) + 0.25)
  
  # Plot variable 1
  plot(x,y1, type = "l", col = correlation_titles$V1_color, lwd = 2, xaxs="i",
       xlab = "",ylab = correlation_titles$V1_axis_label,col.axis = correlation_titles$V1_color,
       col.lab = correlation_titles$V1_color )
  axis(1)
  mtext("Year", side = 1, line = 3)
  
  # Needed to merge the plots
  par(new = TRUE)
  
  # Plot variable 2
  plot(x,y2,type = "l", col = correlation_titles$V2_color, lwd = 2, xaxs="i",
       axes = FALSE, bty = "n", xlab = "", ylab = "")
  axis(4,col.axis = correlation_titles$V2_color)
  mtext(correlation_titles$V2_axis_label, side = 4, line = 3, col = correlation_titles$V2_color)
  
  # Reset original graphical parameters
  par(old.par)
  
  # Add main title
  title(correlation_titles$TS_title, font.main= 1, adj=0, line = 0.5)
}


## (Correlation) CORRELATE TWO TIMESERIES 
##               variable_data = either user_data_subset
##                               or ModE-RA timeseries_datatable
##               method = "pearson" or "spearman" ("pearson" by default)

correlate_timeseries = function(variable1_data,
                                variable2_data,
                                method) {
  r = cor.test(variable1_data[, 2],
               variable2_data[, 2],
               method = method,
               use = "complete.obs")
  return (r)
}


## (Correlation) GENERATE CORRELATION MAP DATA creates correlation map data (x,y,z) from
##               either a timeseries and a field or two fields (NOT two timeseries!)
##               variable_data = either user_data_subset
##                               or ModE-RA timeseries_datatable
##                               or ModE-RA yearly_subset/anomalies data 
##               method = "pearson" or "spearman" ("pearson" by default)
##               Note: uses the subset_lat/lon functions

generate_correlation_map_data = function(variable1_data,
                                         variable2_data,
                                         method,
                                         variable1_type,
                                         variable2_type,
                                         variable1_lon_range,
                                         variable2_lon_range,
                                         variable1_lat_range,
                                         variable2_lat_range) {
  
  
  # Generate subset lon/lat IDs
  subset_lon_IDs1 = create_subset_lon_IDs(variable1_lon_range)
  subset_lon_IDs2 = create_subset_lon_IDs(variable2_lon_range)
  subset_lat_IDs1 = create_subset_lat_IDs(variable1_lat_range)
  subset_lat_IDs2 = create_subset_lat_IDs(variable2_lat_range)
  
  # Define correlation method:
  my_cor = function(a,b){cor(a,b,method=method,use = "complete.obs")}
  
  # If variable 1 is a timeseries:
  if (variable1_type == "Timeseries"){
    x = lon[subset_lon_IDs2]
    y = rev(lat[subset_lat_IDs2])
    plotfield = apply(variable2_data,c(1,2),my_cor,variable1_data[,2])
    z = plotfield[,rev(1:length(subset_lat_IDs2))]
  }
  # If variable 2 is a timeseries:
  else if (variable2_type == "Timeseries"){
    x = lon[subset_lon_IDs1]
    y = rev(lat[subset_lat_IDs1])
    plotfield = apply(variable1_data,c(1,2),my_cor,variable2_data[,2])
    z = plotfield[,rev(1:length(subset_lat_IDs1))]
  }
  # If variable 1 & 2 are fields
  else {
    # Find shared lon/lat
    shared_lon_IDs = intersect(subset_lon_IDs1,subset_lon_IDs2)
    shared_lat_IDs = intersect(subset_lat_IDs1,subset_lat_IDs2)
    # Cut data to new shared lon/lat
    cut_variable1_data = variable1_data[match(shared_lon_IDs,subset_lon_IDs1),
                                        match(shared_lat_IDs,subset_lat_IDs1),]
    cut_variable2_data = variable2_data[match(shared_lon_IDs,subset_lon_IDs2),
                                        match(shared_lat_IDs,subset_lat_IDs2),]
    # Set up x, y and z for plotting
    x = lon[shared_lon_IDs]
    y = rev(lat[shared_lat_IDs])
    plotfield = array(NA,dim = dim(cut_variable1_data[,,1]))
    # Cycle through all gridpoints, correlating the two timeseries for each
    for (i in 1:dim(cut_variable1_data)[1]){
      for (j in 1:dim(cut_variable1_data)[2]){
        plotfield[i,j] = my_cor(cut_variable1_data[i,j,],cut_variable2_data[i,j,])
      }
    }
    z = plotfield[,rev(1:length(shared_lat_IDs))]
  }
  
  # Combine x, y and z into a dataframe
  xyz = list(x,y,z)

  return(xyz)
}

## (Correlation) GENERATE CORRELATION MAP DATATABLE - creates a correlation map 
##               datatable for display from the correlation_map_data
##               data_input = correlation_map_data

generate_correlation_map_datatable = function(data_input){
  
  # Extract x,y,z
  x = data_input[[1]]
  y = data_input[[2]]
  z = data_input[[3]]  
  
  # Transpose and rotate z
  
  zt = t(z)[rev(1:length(y)),]
  
  # Add degree symbols and cardinal directions for longitude and latitude
  x_labels = ifelse(x >= 0,
                    paste(x, "\u00B0E", sep = ""),
                    paste(abs(x), "\u00B0W", sep = ""))
  y_labels = ifelse(y >= 0,
                    paste(round(y, digits = 3), "\u00B0N", sep = ""),
                    paste(abs(round(y, digits = 3)), "\u00B0S", sep = ""))
  
  # Apply labels to correlation map data
  colnames(zt) = x_labels
  rownames(zt) = y_labels  
  
  return(zt)
}

## (Correlation) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR PLOT
##               data input = Input form Plot Customization

generate_metadata_corr <- function(axis_mode3,
                                   axis_input3,
                                   hide_axis3,
                                   title_mode3,
                                   title1_input3,
                                   hide_borders3,
                                   cor_method_map3) {
  
  # Adjust axis_input3 based on axis_mode3
  if (axis_mode3 == "Automatic") {
    axis_input3 <- NA
  } else if (length(axis_input3) == 2) {
    axis_input3 <- paste(axis_input3, collapse = ",")
  }
  
  # Create the metadata data frame with explicit column names
  meta_input3 <- data.frame(
    axis_mode3, #radioButtons
    axis_input3, #numericRangeInput
    hide_axis3, #checkboxInput
    title_mode3, #radioButtons
    title1_input3, #textInput
    hide_borders3, #checkboxInput
    cor_method_map3 #radioButtons
  )
  
  return(meta_input3)
}

## (Correlation) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR TS
##               data input = Input form Plot Customization

generate_metadata_ts_corr <- function(title_mode_ts3,
                                      title1_input_ts3,
                                      show_key_ts3,
                                      key_position_ts3,
                                      custom_average_ts3,
                                      year_moving_ts3,
                                      cor_method_ts3) {
  
  # Create the metadata data frame with explicit column names
  meta_input_ts3 <- data.frame(
    title_mode_ts3, #radioButtons
    title1_input_ts3, #textInput
    show_key_ts3, #checkboxInput
    key_position_ts3, #radioButtons
    custom_average_ts3, #checkboxInput
    year_moving_ts3, #numericInput
    cor_method_ts3 #radioButtons
  )
  
  return(meta_input_ts3)
}


## (Correlation) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##               data input = Generation plot inputs from side bar

generate_metadata_plot_corr <- function(dataset,
                                        variable,
                                        type,
                                        mode,
                                        season_sel,
                                        range_months,
                                        ref_period,
                                        select_sg_ref,
                                        sg_ref,
                                        lon_range,
                                        lat_range,
                                        lonlat_vals) {
  
  #Generate dataframe from plot inputs
  plot_input3 <- data.frame(
    dataset, #selectInput
    variable, #selectInput
    type, #radioButtons
    mode, #radioButtons
    season_sel, #radioButtons
    range_months, #sliderTextInput
    ref_period, #numericRangeInput
    select_sg_ref, #checkboxInput
    sg_ref, #numericInput
    lon_range, #numericRangeInput
    lat_range, #numericRangeInput
    lonlat_vals #VALUES
  )
  
  return(plot_input3)
}

## (Correlation) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##               data input = Generation plot inputs from side bar

generate_metadata_y_range_corr <- function(range_years3) {
  
  #Generate dataframe from plot inputs
  metadata_yr3 <- data.frame(
    range_years3 #numericRangeInput
  )
  
  return(metadata_yr3)
}

#### Regression Functions ####

## (Regression) CREATE MODE-RA TIMESERIES DATA creates timeseries data for single/
##              multiple ModE-RA variables to be used as independent variables
##              Note: Uses the GENERAL functions to create data
##              variables = name/names of the modE-RA variable 

create_ME_timeseries_data = function(dataset,
                                     variables,
                                     subset_lon_IDs,
                                     subset_lat_IDs,
                                     mode,
                                     month_range,
                                     year_range,
                                     baseline_range){
  
  # Create year column
  Year = year_range[1]:year_range[2]
  MEts_data = data.frame(Year)
  
  # Precalculations for weighting yearly means
  latlon_weights_reduced = latlon_weights[subset_lat_IDs,subset_lon_IDs]
  weight_function = function(df,llwr){df_weighted = (df*llwr)/sum(llwr)}
  
  # Cycle through each variable
  for (i in variables){
    
    # Generate data_ID for new variable
    data_ref = generate_data_ID(dataset,i,month_range)
    
    # Access variable base data (if pp data not available)
    if (data_ref[1]==0){
      data1 = load_ModE_data(dataset,i)
    } else if (data_ref[1]==2){
      data1 = load_preprocessed_data(data_ref)
    } else {
      data1 = NA
    }
    # Generate latlon subset data
    data2 =  create_latlon_subset(data1, data_ref, subset_lon_IDs, subset_lat_IDs)
    # Generate yearly subset data
    data3 = create_yearly_subset(data2, data_ref, year_range, month_range)
    # Generate reference data 
    refd = create_yearly_subset(data2, data_ref, baseline_range, month_range)
    data4 = apply(refd,c(1:2),mean)
    # Generate anomalies data
    if (mode == "Absolute"){ # TBC
      data5 = data3
    } else {
      data5 = convert_subset_to_anomalies(data3,data4)
    }
    
    # Weight yearly means
    data_weighted = apply(data5,c(3),weight_function, t(latlon_weights_reduced))
    
    # Create TS data
    variable_ts_data = data.frame(apply(data_weighted,c(2),sum)) 
    
    # Add to MEts timeseries dataframe
    MEts_data = data.frame(MEts_data,variable_ts_data)
  }
  
  # Name columns
  colnames(MEts_data) = c("Year",variables)
  
  #if (variable == "Residuals"){
  # Weight yearly means
  #data_weighted = apply(data_input,c(1),weight_function, t(latlon_weights_reduced))
  
  # Create TS data
  #ts_data = data.frame(apply(data_weighted,c(2),sum))
  #} 
  
  return(MEts_data)
}


## (Regression) GENERATE REGRESSION TITLES - creates a dataframe of regression titles
##              ind/dep_variable = name/s of ind/dep variables
##              independent_variable_number = number in "user_independent_variables" 
##                                            of the variable to be plotted
##                                            (set to 1 as default)
##              ind/dep_mode =ModE-RA" or "User Data"  
##              ME_independent_mode/d = ind/dep ModE-Ra data mode ("Absolute" or "Anomaly")
##              subset_lon/lat_IDs = subset_lon/lat_IDs for dependent variable
##              month_range_i/d = ind/dep ModE-RA month range

generate_regression_titles = function(independent_source,
                                      dependent_source,
                                      dataset_i,
                                      dataset_d,
                                      modERA_dependent_variable,
                                      mode_i,
                                      mode_d,
                                      month_range_i,
                                      month_range_d,
                                      lon_range_i,
                                      lon_range_d,
                                      lat_range_i,
                                      lat_range_d,
                                      year_range,
                                      year_selected,
                                      independent_variables,
                                      dependent_variable,
                                      iv_number_coeff,
                                      iv_number_pvals,
                                      map_title_mode,
                                      map_custom_title,
                                      map_custom_subtitle,
                                      title_size=18){
  
  # Create Independent variable titles
  if (independent_source == "User Data"){
    title_months_i = ""
    title_mode_i = ""
    title_lonlat_i = ""
  } else {
    # Generate title months
    title_months_i = paste(dataset_i," ",generate_title_months(month_range_i)," ",sep = "")
    
    # Generate title mode addition
    if (mode_i == "Absolute"){
      title_mode_i = ""
    } else {
      title_mode_i = "Anomaly"
    }
    
    # Generate lon/lat addition
    if (lon_range_i[1]==lon_range_i[2]) {
      lon_title = paste(lon_range_i[1],"\u00B0E",sep = "")
    } else {
      lon_title = paste(lon_range_i[1],":",lon_range_i[2],"\u00B0E", sep = "")
    }
    
    if (lat_range_i[1]==lat_range_i[2]) {
      lat_title = paste(lat_range_i[1],"\u00B0E",sep = "")
    } else {
      lat_title = paste(lat_range_i[1],":",lat_range_i[2],"\u00B0N", sep = "")
    }
    
    title_lonlat_i = paste(" [",lon_title,", ",lat_title,"]",sep = "")
  }
  
  # Create Dependent variable titles
  if (dependent_source == "User Data"){
    title_months_d = ""
    title_mode_d = ""
    title_lonlat_d = ""
    color_d = "darkorange2"
    unit_d = ""
  } else {
    # Generate title months
    title_months_d = paste(dataset_d," ",generate_title_months(month_range_d)," ",sep = "")
    
    # Generate title mode addition
    if (mode_d == "Absolute"){
      title_mode_d = ""
    } else {
      title_mode_d = " Anomaly"
    }
    
    # Generate lon/lat addition
    if (lon_range_d[1]==lon_range_d[2]) {
      lon_title = paste(lon_range_d[1],"\u00B0E",sep = "")
    } else {
      lon_title = paste(lon_range_d[1],":",lon_range_d[2],"\u00B0E", sep = "")
    }
    
    if (lat_range_d[1]==lat_range_d[2]) {
      lat_title = paste(lat_range_d[1],"\u00B0E",sep = "")
    } else {
      lat_title = paste(lat_range_d[1],":",lat_range_d[2],"\u00B0N", sep = "")
    }
    
    title_lonlat_d = paste(" [",lon_title,", ",lat_title,"]",sep = "")
    
    # Generate timeseries color & unit
    if (modERA_dependent_variable == "Temperature"){
      color_d = "red3" ; unit_d = "[\u00B0C]"
    } else if (modERA_dependent_variable == "Precipitation"){
      color_d = "turquoise4" ; unit_d = "[mm/month]"
    } else if (modERA_dependent_variable == "SLP"){
      color_d = "purple4" ; unit_d = "[hPa]"
    } else if (modERA_dependent_variable == "Z500"){
      color_d = "green4" ; unit_d = "[m]"
    }
  }
  
  # Create year range title
  title_year_range = paste(year_range[1],"-",year_range[2],sep = "")
  
  # Generate regression map titles
  map_title_coeff <- ifelse(map_title_mode == "Custom" & map_custom_title != "", map_custom_title, "Regression Coefficients")
  map_title_pvals <- ifelse(map_title_mode == "Custom" & map_custom_title != "", map_custom_title, "Regression P Values")
  map_title_res <- ifelse(map_title_mode == "Custom" & map_custom_title != "", map_custom_title, "Regression Residuals")
  
  map_subtitle_coeff <- ifelse(map_title_mode == "Custom" & map_custom_subtitle != "", map_custom_subtitle,paste(
    "Independent variable:", title_months_i, independent_variables[iv_number_coeff],
    title_mode_i, title_lonlat_i, "\nDependent variable:",
    title_months_d, dependent_variable, title_mode_d,
    "\nTime range:", title_year_range
  ))
  
  map_subtitle_pvals <- ifelse(map_title_mode == "Custom" & map_custom_subtitle != "", map_custom_subtitle, paste(
    "Independent variable:", title_months_i, independent_variables[iv_number_pvals],
    title_mode_i, "\nDependent variable:",
    title_months_d, dependent_variable, title_mode_d,
    "\nTime range:", title_year_range
  ))
  
  map_subtitle_res <- ifelse(map_title_mode == "Custom" & map_custom_subtitle != "", map_custom_subtitle, paste(
    "Independent variables:", title_months_i, paste(independent_variables, collapse = " ; "),
    title_mode_i, title_lonlat_i, "\nDependent variable:",
    title_months_d, dependent_variable, title_mode_d,
    "\nYear:", year_selected
  ))
  
  # Adapt title size
  map_title_size_coeff <- ifelse(map_title_mode == "Custom", title_size, 18)
  map_title_size_pvals <- ifelse(map_title_mode == "Custom", title_size, 18)
  map_title_size_res <- ifelse(map_title_mode == "Custom", title_size, 18)
  
  # Generate download titles
  tf0 = paste("Reg",title_months_i,"ind. var.", ">", title_months_d, modERA_dependent_variable)
  tf1 = gsub("[[:punct:]]", "", tf0)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Title font size
  map_title_size = title_size
  
  # Combine all titles into a dataframe
  titles_df = data.frame(
    title_months_i,
    title_mode_i,
    title_lonlat_i,
    title_months_d,
    title_mode_d,
    title_lonlat_d,
    color_d,
    unit_d,
    title_year_range,
    file_title,
    map_title_coeff,
    map_title_pvals,
    map_title_res,
    map_subtitle_coeff,
    map_subtitle_pvals,
    map_subtitle_res,
    map_title_size_coeff,
    map_title_size_pvals,
    map_title_size_res
  )
  
  return(titles_df)
}

generate_regression_titles_ts = function(independent_source,
                                         dependent_source,
                                         dataset_i,
                                         dataset_d,
                                         modERA_dependent_variable,
                                         mode_i,
                                         mode_d,
                                         month_range_i,
                                         month_range_d,
                                         lon_range_i,
                                         lon_range_d,
                                         lat_range_i,
                                         lat_range_d,
                                         year_range,
                                         year_selected,
                                         independent_variables,
                                         dependent_variable,
                                         iv_number_coeff,
                                         iv_number_pvals,
                                         map_title_mode,
                                         map_custom_title,
                                         map_custom_subtitle,
                                         title_size = 18
){
  
  # Create Independent variable titles
  if (independent_source == "User Data"){
    title_months_i = ""
    title_mode_i = ""
    title_lonlat_i = ""
  } else {
    # Generate title months
    title_months_i = paste(dataset_i," ",generate_title_months(month_range_i)," ",sep = "")
    
    # Generate title mode addition
    if (mode_i == "Absolute"){
      title_mode_i = ""
    } else {
      title_mode_i = "Anomaly"
    }
    
    # Generate lon/lat addition
    if (lon_range_i[1]==lon_range_i[2]) {
      lon_title = paste(lon_range_i[1],"\u00B0E",sep = "")
    } else {
      lon_title = paste(lon_range_i[1],":",lon_range_i[2],"\u00B0E", sep = "")
    }
    
    if (lat_range_i[1]==lat_range_i[2]) {
      lat_title = paste(lat_range_i[1],"\u00B0E",sep = "")
    } else {
      lat_title = paste(lat_range_i[1],":",lat_range_i[2],"\u00B0N", sep = "")
    }
    
    title_lonlat_i = paste(" [",lon_title,", ",lat_title,"]",sep = "")
  }
  
  # Create Dependent variable titles
  if (dependent_source == "User Data"){
    title_months_d = ""
    title_mode_d = ""
    title_lonlat_d = ""
    color_d = "darkorange2"
    unit_d = ""
  } else {
    # Generate title months
    title_months_d = paste(dataset_d," ",generate_title_months(month_range_d)," ",sep = "")
    
    # Generate title mode addition
    if (mode_d == "Absolute"){
      title_mode_d = ""
    } else {
      title_mode_d = " Anomaly"
    }
    
    # Generate lon/lat addition
    if (lon_range_d[1]==lon_range_d[2]) {
      lon_title = paste(lon_range_d[1],"\u00B0E",sep = "")
    } else {
      lon_title = paste(lon_range_d[1],":",lon_range_d[2],"\u00B0E", sep = "")
    }
    
    if (lat_range_d[1]==lat_range_d[2]) {
      lat_title = paste(lat_range_d[1],"\u00B0E",sep = "")
    } else {
      lat_title = paste(lat_range_d[1],":",lat_range_d[2],"\u00B0N", sep = "")
    }
    
    title_lonlat_d = paste(" [",lon_title,", ",lat_title,"]",sep = "")
    
    # Generate timeseries color & unit
    if (modERA_dependent_variable == "Temperature"){
      color_d = "red3" ; unit_d = "[\u00B0C]"
    } else if (modERA_dependent_variable == "Precipitation"){
      color_d = "turquoise4" ; unit_d = "[mm/month]"
    } else if (modERA_dependent_variable == "SLP"){
      color_d = "purple4" ; unit_d = "[hPa]"
    } else if (modERA_dependent_variable == "Z500"){
      color_d = "green4" ; unit_d = "[m]"
    }
  }
  
  # Create year range title
  title_year_range = paste(year_range[1],"-",year_range[2],sep = "")
  
  # Generate regression map titles for coefficients
  map_subtitle_coeff = paste("Independent variable: ", title_months_i, independent_variables[iv_number_coeff],
                             " ", title_mode_i, title_lonlat_i, "\nDependent variable: ",
                             title_months_d, dependent_variable,
                             title_mode_d, "\nTime range:", title_year_range, sep = "")
  
  # Generate regression map titles for p-values
  map_subtitle_pvals = paste("Independent variable: ", title_months_i, independent_variables[iv_number_pvals],
                             " ", title_mode_i, "\nDependent variable: ",
                             title_months_d, dependent_variable,
                             title_mode_d, "\nTime range:", title_year_range, sep = "")
  
  # Generate regression map titles for residuals
  title_variables_i = paste(independent_variables, collapse = " ; ")
  map_subtitle_res = paste("Independent variables: ", title_months_i, title_variables_i,
                           " ", title_mode_i, title_lonlat_i, "\nDependent variable: ",
                           title_months_d, dependent_variable,
                           title_mode_d, "\nYear:", year_selected, sep = "")

  # Generate download titles
  tf0 = paste("Reg",title_months_i,"ind. var.", ">", title_months_d, modERA_dependent_variable)
  tf1 = gsub("[[:punct:]]", "", tf0)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Generate TS titles
  ts_axis = paste(dependent_variable,unit_d)
  
  if (map_title_mode == "Custom") {
    ts_title = map_custom_title
    ts_subtitle = map_custom_subtitle
  } else {
    ts_title = "Regression Timeseries"
    ts_subtitle = paste("Independent variables: ", title_months_i, title_variables_i,
                        " ", title_mode_i, title_lonlat_i, "\nDependent variable: ",
                        title_months_d, dependent_variable,
                        title_mode_d, sep = "")
  }
  
  ts_title_size = 18
  
  # Combine all titles into a dataframe
  titles_df = data.frame(
    title_months_i,
    title_mode_i,
    title_lonlat_i,
    title_months_d,
    title_mode_d,
    title_lonlat_d,
    color_d,
    unit_d,
    title_year_range,
    file_title,
    map_subtitle_coeff,
    map_subtitle_pvals,
    map_subtitle_res,
    ts_axis,
    ts_title,
    ts_subtitle,
    ts_title_size
  )
  
  return(titles_df)
}

## (Regression) CALCULATE SUMMARY DATA
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = Mod-Era create_timeseries_datatable for ONE variable
##              independent_variables = selected independent variables user or ModE-Ra
##                                      as a list,e.g. (c("CO2.ppm.","TSI.w.m2."))

create_regression_summary_data = function(independent_variable_data,
                                          dependent_variable_data,
                                          independent_variables) {
  x = as.matrix(independent_variable_data[, independent_variables])
  y = as.matrix(dependent_variable_data[, 2])
  regression_data = lm(y ~ x, na.action = na.exclude)
  return(regression_data)
}


## (Regression) Calculate regression coefficients for mapping (the first dimension
##              is the number in user_variables of each variable)
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = any yearly ModE-RA data (absolute or anomaly)

create_regression_coeff_data = function(independent_variable_data,
                                        dependent_variable_data,
                                        independent_variables){
  reg_coeffs <- apply(dependent_variable_data, c(1:2), function(fy,fx) lm(fy~fx)$coef,as.matrix(independent_variable_data[,independent_variables]))[-1,,]
  # Note that [-1,,] removes the intercepts from the coef data 
  return(reg_coeffs)
}


## (Regression) Calculate regression p values for mapping (the first dimension
##              is the number in user_variables of each variable)
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = any yearly ModE-RA data (absolute or anomaly)

create_regression_pvalue_data = function(independent_variable_data,
                                         dependent_variable_data,
                                         independent_variables){
  # Define lmp function
  lmp <- function (fy,fx) {
    f1 <- lm(fy~fx)
    f2 <- summary.lm(f1)$coefficients[,4]
    return(f2)
  }
  
  reg_pvalues = apply(dependent_variable_data, c(1:2),lmp,as.matrix(independent_variable_data[,independent_variables]))[-1,,]
  # Note that [-1,,] removes the intercepts from the pvalue data 
  return(reg_pvalues)
}


## (Regression) Calculate regression residuals for mapping and TS (only needed 
##              for ModE-RA = dependent variable)
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = any yearly ModE-RA data (absolute or anomaly)

create_regression_residuals = function(independent_variable_data,
                                       dependent_variable_data,
                                       independent_variables){
  reg_residuals <- apply(dependent_variable_data, c(1:2), function(fy,fx) lm(fy~fx)$residuals,as.matrix(independent_variable_data[,independent_variables]))
  return(reg_residuals)
}


## (REGRESSION) CREATE REGRESSION MAP DATATABLE
##              data_input = 2D data that was plotted for coeffs, pvalue or residuals

create_regression_map_datatable = function(data_input,
                                           subset_lon_IDs,
                                           subset_lat_IDs){
  
  # find x,y & z values
  x = lon[subset_lon_IDs]
  y = lat[subset_lat_IDs]
  z = data_input
  
  # Transpose
  map_data =t(z)
  
  # Add degree symbols and cardinal directions for longitude and latitude
  x_labels = ifelse(x >= 0,
                    paste(x, "\u00B0E", sep = ""),
                    paste(abs(x), "\u00B0W", sep = ""))
  y_labels = ifelse(y >= 0,
                    paste(round(y, digits = 3), "\u00B0N", sep = ""),
                    paste(abs(round(y, digits = 3)), "\u00B0S", sep = ""))
  
  # Apply labels to map data
  colnames(map_data) = x_labels
  rownames(map_data) = y_labels
  
  return(map_data)
}


## (Regression) CREATE REGRESSION TIMESERIES DATATABLE including Original, Trend & Residual
##              dependent_variable_data = original Mod-Era create_timeseries_datatable
##                                        for the dependent variable
##              summary_data = create_regression_summary_data
##              residuals_data = as created by create_regression_residuals
##              regression_titles = as created by generate_regression_titles

create_regression_timeseries_datatable = function(dependent_variable_data,
                                                  summary_data,
                                                  regression_titles){
  
  # Extract original timeseries
  years = dependent_variable_data$Year
  original_ts = signif(dependent_variable_data[,2],digits = 3)
  
  # Exract residuals timeseries
  residuals_ts = signif(summary_data$residuals,digits = 3)  
  
  # Create trend timeseries
  trend_ts = signif((original_ts - residuals_ts),digits = 3) 
  
  # Create dataframe
  regression_ts_df = data.frame(years,original_ts,trend_ts,residuals_ts)
  colnames(regression_ts_df) = c("Year",paste(c("Original","Trend","Residuals"),regression_titles$unit_d))
  
  return(regression_ts_df)                               
}

## (Regression) PLOT REGRESSION TIMESERIES plots either original and trend timeseries
##              OR residuals timeseries
##              data_input = regression_timeseries_datatable 
##              plot_type = "original_trend" or "residuals"

# plot_regression_timeseries = function(data_input,plot_type,regression_titles,
#                                       independent_variables,dependent_variable){
#   
#   # Generate title & axis label
#   title_variables_i = paste(independent_variables,collapse = " ; ")
#   title_main = paste("Regression Timeseries. ",
#                      regression_titles$title_months_i,title_variables_i,
#                      regression_titles$title_mode_i,regression_titles$title_lonlat_i," -> ",
#                      regression_titles$title_months_d,dependent_variable,
#                      regression_titles$title_mode_d,regression_titles$title_lonlat_d,
#                      sep = "")
#   title_axis = paste(dependent_variable,regression_titles$unit_d)
#   
#   # Plot original_trend timeseries
#   if (plot_type == "original_trend"){
#     plot(data_input[,1],data_input[,2],col = regression_titles$color_d, type = "l", xaxs="i",
#          xlab = "Year", ylab = title_axis,lwd = 1.5)
#     lines(data_input[,1],data_input[,3],lwd = 1.5)
#     title(title_main, cex.main = 1.5,   font.main= 1, adj=0)
#     legend('bottomright',legend=c("Original", "Trend"),
#            col=c(regression_titles$color_d,"black"),lty = c(1,1),lwd=c(1.5,1.5))
#   } 
#   # Plot residuals timeseries
#   else {
#     plot(data_input[,1],data_input[,4],col = regression_titles$color_d, type = "l", xaxs="i",
#          xlab = "Year", ylab = title_axis, lty = 2, lwd = 1.5)
#     title(title_main, cex.main = 1.5,   font.main= 1, adj=0)
#     legend('bottomright',legend=c("Residual"),
#            col=c(regression_titles$color_d),lty = c(2),lwd=c(1.5))
#   }
# }


#### Annual cycles Functions ----

## (Annual cycles) Annual cycles starter data - Bern,1815  
monthly_ts_starter_data = function(){
  Dataset = "ModE-RA"
  Years = "1815" ; Variable = "Temperature" ; Unit = "\u00B0C"
  Jan = -3.17 ; Feb = 2.84 ; Mar = 5.3
  Apr = 6.97 ; May = 11.3 ; Jun = 13.92
  Jul = 17.11 ; Aug = 17.01 ; Sep = 14.07 
  Oct = 8.46 ; Nov = 0.87 ; Dec = -1.33
  Coordinates = "7.5\u00B0E, 47\u00B0N"
  Mode = "Absolute"
  Ref = NA
  Type = "Individual years"
  
  Bern_data = data.frame(Dataset,Years,Variable,Unit,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec,
                         Coordinates,Mode,Ref,Type)
  return(Bern_data)
}


## (Annual cycles) CREATE ANNUAL CYCLES DATA - creates a data.frame where each row is one 
##              year (or an averaged period) of monthly data. 
##              Uses create_subset_lat/lon_IDs functions
##              data_input = custom_data()
##              years = either one year "1483", a set of years "1483,1812"
##                      or a range of years "1483-1489"
##              type = "Average" or "Individual years"

create_monthly_TS_data = function(data_input,
                                  dataset,
                                  variable,
                                  years,
                                  lon_range,
                                  lat_range,
                                  mode,
                                  type,
                                  baseline_range){
  
  # read in and interpret "years"
  if (grepl(",",years)){
    year_vector = as.integer(unlist(strsplit(years,",")))
  } else if (grepl("-",years)){
    yr_range = as.integer(unlist(strsplit(years,"-")))
    year_vector = yr_range[1]:yr_range[2]  
  } else {
    year_vector = as.integer(years)
  }
  
  # Find subset lat/lon IDs and cut data to lat/lon subset
  lon_IDs = create_subset_lon_IDs(lon_range)
  lat_IDs = create_subset_lat_IDs(lat_range)
  
  data_subset = data_input[lon_IDs,lat_IDs,]
  
  # Create monthly data for each year and add to dataframe
  year_df = data.frame()
  
  for (Y in year_vector){
    year_data = c()
    for (M in 1:12){
      month_ID = ((12*(Y-1421))+M)
      month_data = mean(data_subset[,,month_ID])
      year_data = c(year_data,month_data)
    }
    year_df = rbind(year_df,year_data)
  }
  
  # Calculate reference data (if required) and remove from year_data
  if (mode == "Anomaly"){
    
    if (length(baseline_range)<3){
      ref_years = baseline_range[1]:baseline_range[2]
      ref_df = data.frame()
    } else {
      ref_years = baseline_range
    }
    
    for (Y in ref_years){
      year_data = c()
      for (M in 1:12){
        month_ID = ((12*(Y-1421))+M)
        month_data = mean(data_subset[,,month_ID])
        year_data = c(year_data,month_data)
      }
      ref_df = rbind(ref_df,year_data)
    }
    
    ref_df = as.data.frame(lapply(ref_df,mean))
    year_df = sweep(year_df,2,as.matrix(ref_df)[1,]) 
  }
  
  # Round and add colnames to year_df
  year_df = round(year_df,digits = 2)
  colnames(year_df) = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
  
  # Generate Years column and if type = average, average all years
  if (type == "Average"){
    year_df = as.data.frame(lapply(year_df,mean))
    Years = years
  } else {
    Years = as.character(year_vector)
  } 
  
  # Generate dataset column
  Dataset = rep(dataset,length(Years))
  
  # Generate Variable column
  Variable = rep(variable,length(Years))
  
  # Generate Units column
  if (variable == "Temperature"){
    v_unit = "\u00B0C"
  } else if (variable == "Precipitation"){
    v_unit = "mm/month"
  } else if (variable == "SLP"){
    v_unit = "hPa"
  } else if (variable == "Z500"){
    v_unit = "m"
  } 
  Unit = rep(v_unit,length(Years))
  
  # Generate Coordinates column
  # Lon labels
  if (lon_range[1] == lon_range[2]){
    lon_addition = paste0(lon_range[1],"\u00B0E")
  } else {
    lon_addition = paste0(lon_range[1],":",lon_range[2],"\u00B0E")
  }
  # Lat labels
  if (lat_range[1] == lat_range[2]){
    lat_addition = paste0(lat_range[1],"\u00B0N")
  } else {
    lat_addition = paste0(lat_range[1],":",lat_range[2],"\u00B0N")
  }
  
  coordinate_label = paste0(lon_addition,", ",lat_addition)
  Coordinates = rep(coordinate_label,length(Years))  
  
  # Generate Mode and Type columns
  Mode = rep(mode,length(Years))
  Type = rep(type,length(Years))
  
  # Generate Ref column
  if (mode == "Anomaly"){
    if (baseline_range[1] == baseline_range[2]){
      ref = baseline_range[1]
    } else {
      ref = paste0(baseline_range[1],"-",baseline_range[2])
    }
  } else {
    ref = NA
  }
  
  Ref = rep(ref,length(Years))
  
  # Combine Columns to create dataframe  
  combined_df = data.frame(Dataset,Years,Variable,Unit,year_df,Coordinates,Mode,Ref,Type)
  
  return(combined_df)
}



#' PLOT MONTHLY TIMESERIES 
#' 
#' @param data data.frame. The main monthly time series data table.
#' @param titles Character vector. Contains ts_title and ts_title_size
#' @param show_key Logical. TRUE or FALSE, whether to show a key.
#' @param key_position Character. Position of the key: "top", "bottom", "left", "right", "none".
#' @param highlights data.frame. Data frame containing highlight information.
#' @param lines data.frame. Data frame containing line information.
#' @param points data.frame. Data frame containing point information.
#' @return A ggplot object.

plot_monthly_timeseries <- function(data = NA,
                                    titles = NA,
                                    show_key = NA,
                                    key_position = NA,
                                    highlights = NA,
                                    lines = NA,
                                    points = NA) {
  
  # Create empty dataframes for Lines, Points, Fills and boxes  
  lines_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(lines_data) = c("ID","label","x","y","lcolor","ltype","lwidth","key_show")
  
  points_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x","y","pcolor","pshape","psize","key_show")
  
  fills_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x1","x2","y1","y2","fill","key_show")
  
  boxes_data = data.frame(matrix(ncol = 8, nrow = 0))
  colnames(points_data) = c("ID","label","x1","x2","y1","y2","bcolor","key_show")
  
  # Set up inital row IDs
  lID = 1 ; pID = 1 ; fID = 1 ; bID = 1
  
  # Generate colors
  if (nrow(data) < 3) {
    color_set = brewer.pal(3, "Dark2")
  } else if (nrow(data) < 13) {
    color_set = brewer.pal(nrow(data), "Dark2")
  } else {
    color_set = colorRampPalette(brewer.pal(12, "Dark2"))(nrow(data))
  }
  
  # Convert data to plotting format
  for (i in 1:nrow(data)){
    year_data = data[i,]
    
    # Create variables
    if (year_data$Type == "Average"){
      lwidth = 1.5
    } else {
      lwidth = 1
    }
    
    x = as.Date(c())
    for (j in 5:16){
      x = c(x,as.Date(paste0("2000-",j-4,"-01")))
    }
    
    new_line = data.frame(
      ID = lID,
      label = paste0(year_data$Dataset," ",year_data$Years," [",year_data$Coordinates,"]"),
      x = x,
      y = as.numeric(year_data[,5:16]),
      lcolor = color_set[i],
      ltype = "solid",
      lwidth = lwidth,
      key_show = TRUE
    )
    lines_data = rbind(lines_data,new_line)
    lID = lID+1
  }
  
  # Extract ylimits from data
  y_min = min(lines_data$y) ; y_max = max(lines_data$y)
  y_range = y_max-y_min
  y_Min = y_min-(0.1*y_range) ; y_Max = y_max+(0.1*y_range)
  
  # Add a vertical white line to set axis limits 
  new_line = data.frame(
    ID = lID,
    label = NA,
    x = as.Date("2000-01-01"),
    y = c(y_Min,y_Max),
    lcolor = "white",
    ltype = "solid",
    lwidth = 1,
    key_show = FALSE
  )
  lines_data = rbind(lines_data,new_line)
  lID = lID+1
  
  # Add custom lines to data:
  if (!is.null(lines) && nrow(lines) > 0) {
    
    for (i in 1:nrow(lines)) {
      line_data <- lines[i, ]
      
      if (line_data$orientation == "Vertical"){
        x_line = line_data$location
        y_line = c(y_Min,y_Max)
      } else { # Orientation == "Horizontal"
        x_line = c(as.Date("2000-01-01"),as.Date("2000-12-01"))
        y_line = line_data$location
      }
      
      new_line = data.frame(
        ID = lID,
        label = line_data$label,
        x = x_line,
        y = y_line,
        lcolor = line_data$color,
        ltype = line_data$type,
        lwidth = 1,
        key_show = line_data$key_show
      )
      lines_data = rbind(lines_data,new_line)
      lID = lID+1
    }
  }
  
  # Add custom points to data:
  if (!is.null(points) && nrow(points) > 0) {
    
    for (i in 1:nrow(points)) {
      point_data <- points[i, ]
      
      new_point = data.frame(
        ID = pID,
        label = point_data$label,
        x = point_data$x_value,
        y = point_data$y_value,
        pcolor = point_data$color,
        pshape = point_data$shape,
        psize = point_data$size,
        key_show = FALSE
      )
      points_data = rbind(points_data,new_point)
      pID = pID+1
    }
  }
  
  # Add custom highlights to data:
  if (!is.null(highlights) && nrow(highlights) > 0) {
    
    if(any(highlights$type == "Fill")) {
      fills <- subset(highlights, type == "Fill")
      
      for (i in 1:nrow(fills)) {
        fill_data <- fills[i, ]
        
        new_fill = data.frame(
          ID = fID,
          label = fill_data$label,
          x1 = fill_data$x1,
          x2 = fill_data$x2,
          y1 = fill_data$y1,
          y2 = fill_data$y2,
          fill = fill_data$color,
          key_show = fill_data$key_show
        )
        fills_data = rbind(fills_data,new_fill)
        fID = fID+1
      }
    }
    
    if(any(highlights$type == "Box")) {
      boxes <- subset(highlights, type == "Box")
      
      for (i in 1:nrow(boxes)) {
        box_data <- boxes[i, ]
        
        new_box = data.frame(
          ID = bID,
          label = box_data$label,
          x1 = box_data$x1,
          x2 = box_data$x2,
          y1 = box_data$y1,
          y2 = box_data$y2,
          bcolor = box_data$color,
          key_show = box_data$key_show
        )
        boxes_data = rbind(boxes_data,new_box)
        bID = bID+1
      }
    }
    
  }
  
  # Plot data 
  p = ggplot()
  
  # Plot fills
  if (nrow(fills_data>0)){
    
    #Plot
    for (i in 1:(fID-1)){
      fill_data = subset(fills_data, ID == i)
      # Convert x values to dates
      fill_data$x1 = as.Date(fill_data$x1)
      fill_data$x2 = as.Date(fill_data$x2)
      
      if (fill_data$key_show){ # Show on legend
        p = p +  geom_rect(
          data = fill_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, fill = label),
          alpha = 0.5,
          inherit.aes = FALSE
        ) 
      } else { # Don't show on legend
        p = p +  geom_rect(
          data = fill_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2),
          fill = fill_data$fill,
          alpha = 0.5,
          inherit.aes = FALSE
        )  
      }
    }
    
    # Add legend
    fills_legend = unique(subset(fills_data, key_show == TRUE)[,c("ID","label","fill")])
    if (!is.null(fills_legend) && nrow(fills_legend)>0){
      p = p + scale_fill_manual(values = setNames(fills_legend$fill,fills_legend$label))
    }
  }
  
  # Plot lines
  if (nrow(lines_data>0)){
    
    #Plot
    for (i in 1:(lID-1)){
      line_data = subset(lines_data, ID == i)
      
      if (line_data$key_show[1]){ # Show on legend
        p = p + geom_line(
          data = line_data,
          aes(x = x, y = y, linetype = label),
          linewidth = line_data$lwidth[1],
          color = line_data$lcolor[1]
        ) 
      } else { # Don't show on legend
        p = p + geom_line(
          data = line_data,
          aes(x = x, y = y),
          linetype = line_data$ltype[1],
          linewidth = line_data$lwidth[1],
          color = line_data$lcolor[1]
        ) 
      }
    }
    
    # Add legend
    lines_legend = unique(subset(lines_data, key_show == TRUE)[,c("ID","label","ltype")])
    if (!is.null(lines_legend) && nrow(lines_legend)>0){
      p = p + scale_linetype_manual(values = setNames(lines_legend$ltype,lines_legend$label))
    }
  }
  
  # Plot Boxes
  if (nrow(boxes_data>0)){
    
    #Plot
    for (i in 1:(bID-1)){
      box_data = subset(boxes_data, ID == i)
      # Convert x values to dates
      box_data$x1 = as.Date(box_data$x1)
      box_data$x2 = as.Date(box_data$x2)
      
      if (box_data$key_show){ # Show on legend
        p = p +  geom_rect(
          data = box_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2, color = label),
          fill = "white", alpha = 0, linewidth = 1,
          inherit.aes = FALSE
        ) 
      } else { # Don't show on legend
        p = p +  geom_rect(
          data = box_data,
          aes(xmin = x1, xmax = x2, ymin = y1, ymax = y2),
          color = box_data$bcolor,
          fill = "white", alpha = 0, linewidth = 1,
          inherit.aes = FALSE
        )  
      }
    }
    
    # Add legend
    boxes_legend = unique(subset(boxes_data, key_show == TRUE)[,c("ID","label","bcolor")])
    if (!is.null(boxes_legend) && nrow(boxes_legend)>0){
      p = p + scale_color_manual(values = setNames(boxes_legend$bcolor,boxes_legend$label))
    }
  }
  
  # Plot points
  if (nrow(points_data)>0){
    
    for (i in 1:nrow(points_data)){
      point_data = points_data[i,]
      # Convert points_data x value to date
      point_data$x = as.Date(point_data$x)
      
      if (point_data$key_show){ # Show on legend
        p = p + geom_point(
          data = point_data,
          aes(x = x, y = y, shape = label),
          size = point_data$psize,
          color = point_data$pcolor
        ) 
      } else { # Don't show on legend
        p = p + geom_point(
          data = point_data,
          aes(x = x, y = y),
          shape = point_data$pshape,
          size = point_data$psize,
          color = point_data$pcolor
        )
      }  
      
      # Add labels
      p <- p + geom_text(
        data = point_data,
        aes(x = x, y = y, label = label),
        vjust = -1.5,   # vertical adjustment
        hjust = 0.5,  # horizontal adjustment
        size = 5,     # text size
        color = "black"  # or any color you want
      )
    }
    
    # Add legend
    points_legend = unique(subset(points_data, key_show == TRUE)[,c("ID","label","pshape")])
    if (!is.null(points_legend) && nrow(points_legend)>0){
      p = p + scale_shape_manual(values = setNames(points_legend$pshape,points_legend$label))
    }
  }
  
  # Add theme
  p <- p + theme_bw(base_size = 18)
  
  # Add title and subtitle if provided
  if (!is.null(titles)) {
    p <- p + labs(x = "Month", y = paste0(data$Variable[1]," [",data$Unit[1],"]"))
    
    if (titles$ts_title != " ") {
      p <- p + ggtitle(titles$ts_title)
    }
    if (!is.na(titles$ts_subtitle)) {
      p <- p + labs(subtitle = titles$ts_subtitle) 
    }
    p <- p + theme(
      plot.title = element_text(size = titles$ts_title_size, face = "bold"),
      plot.subtitle = element_text(size = titles$ts_title_size / 1.3, face = "plain"),
      axis.text=element_text(size = titles$ts_title_size / 1.6),
    )
  } 
  
  # Set legend groupings
  p <- p + guides(
    fill = guide_legend(title = NULL, order = 3),
    color = guide_legend(title = NULL, order = 4),
    linetype = guide_legend(title = "Legend", order = 1),
    shape = guide_legend(title = NULL, order = 2)
  )
  
  # Set legend visibility and position
  if (show_key) {
    p <- p + theme(legend.position = key_position)  # Apply the position from `key_position`
  } else {
    p <- p + theme(legend.position = "none")  # Remove the legend if `show_key == FALSE`
  }

  # Remove whitespace & label months
  p <- p +   scale_x_date(
    date_labels = "%b",    # Three-letter month labels
    date_breaks = "1 month",
    expand = c(0, 0)
  )
  p = p + scale_y_continuous(limits = c(y_Min,y_Max),expand = c(0, 0))
  
  # Return the final plot
  return(p)
}


# Helper function to to generate month label
generate_month_label <- function(range) {
  if (range[1] == 1 && range[2] == 12) {
    "Annual"
  } else {
    month_letters <- c("D", "J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D")
    paste(month_letters[(range[1]:range[2]) + 1], collapse = "")
  }
}

#### SEA Functions ----

## (SEA) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##       data input = Generation plot inputs from side bar

generate_metadata_sea_plot  <- function(dataset,
                                        variable,
                                        statistic,
                                        season_sel,
                                        range_months,
                                        ref_period,
                                        select_sg_ref,
                                        sg_ref,
                                        lon_range,
                                        lat_range,
                                        lonlat_vals) {
  
  #Generate dataframe from plot inputs
  plot_input6 <- data.frame(
    dataset, #selectInput
    variable, #selectInput
    statistic, #selectInput
    season_sel, #radioButtons
    range_months, #sliderTextInput
    ref_period, #numericRangeInput
    select_sg_ref, #checkboxInput
    sg_ref, #numericInput
    lon_range, #numericRangeInput
    lat_range, #numericRangeInput
    lonlat_vals #VALUES
  )
  
  return(plot_input6)
}

## (SEA) GENERATE METADATA FROM INPUTS FOR PLOT GENERATION
##       data input = Generation plot inputs from side bar

generate_metadata_sea_side_plot  <- function(lag_years,
                                             event_years) {
  
  #Generate dataframe from plot inputs
  plot_input6b <- data.frame(
    lag_years, #numericRangeInput
    event_years #textInput
  )
  
  return(plot_input6b)
}

## (SEA) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR TS
##       data input = Input form Plot Customization

generate_metadata_sea_ts <- function(title_mode_6,
                                     title1_input_6,
                                     y_label_6,
                                     show_observations_6,
                                     show_pvalues_6,
                                     show_ticks_6,
                                     show_key_6,
                                     sample_size_6,
                                     show_means_6,
                                     show_confidence_bands_6) {
  
  # Create the metadata data frame with explicit column names
  meta_input_sea_ts <- data.frame(
    title_mode_6, #radioButtons
    title1_input_6, #textInput
    y_label_6, #textInput
    show_observations_6, #checkboxInput
    show_pvalues_6, #checkboxInput
    show_ticks_6, #checkboxInput
    show_key_6, #checkboxInput
    sample_size_6, #numericInput
    show_means_6, #checkboxInput
    show_confidence_bands_6 #radioButtons
  )
  
  return(meta_input_sea_ts)
}


## (SEA) SET AXIS VALUES IN CUSTOMIZATION
##       data input = Input from SEA_datatable()

set_sea_axis_values <- function(data_input) {
  min_val <- min(data_input, na.rm = TRUE)
  max_val <- max(data_input, na.rm = TRUE)
  range_val <- max_val - min_val
  padded <- c(min_val - 0.05 * range_val, max_val + 0.05 * range_val)
  return(signif(padded, digits = 3))
}