#### Preparation ####

## Working Directory

#Nik:
#Laptop: nikla, UniPC: nbartlome, Zuhause: Niklaus Emanuel
#setwd("C:/Users/nbartlome/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp")

#Richard:
#Laptop/desktop:
#setwd("C:/Users/Richard/OneDrive/ClimeApp_all/ClimeApp")
#setwd("C:/Users/rw22z389/OneDrive/ClimeApp_all/ClimeApp")

#Noémie
#setwd("C:/Users/nw22d367/OneDrive/ClimeApp_all/ClimeApp/")
#setwd("C:/Users/noemi/OneDrive/ClimeApp_all/ClimeApp/") #private laptop

## Packages

# Set library path for Offline Version
assign(".lib.loc", "library", envir = environment(.libPaths))
#assign(".lib.loc", "C:/Users/noemi/OneDrive/ClimeApp_all/ClimeApp/library", envir = environment(.libPaths))

#WD and Packages
library(shiny)
library(ncdf4)
library(maps)
library(shinyWidgets)
library(RColorBrewer)
library(shinyjs)
library(bslib)
library(readxl)
library(DT)
library(zoo)
library(colourpicker)
#library(tmaptools)  ** do we need this? **
library(ggplot2)
library(sf)
library(shinylogs)
library(shinycssloaders)
library(profvis)
library(openxlsx) #Don't Change order!
library(xlsx)
#new libraries for leaflet
library(leaflet)
library(htmltools)
library(mapdata)
library(dplyr)
library(plotly)  # Load plotly library for interactivity
library(terra)
library(tidyterra)
library(rnaturalearth)
library(rnaturalearthdata)


# Set library path for Live Version
# lib_path <- "/home/climeapp/R/x86_64-pc-linux-gnu-library/4.4"
# #WD and Packages
# library(shiny, lib.loc = lib_path)
# library(ncdf4, lib.loc = lib_path)
# library(maps, lib.loc = lib_path)
# library(shinyWidgets)
# library(RColorBrewer, lib.loc = lib_path)
# library(shinyjs, lib.loc = lib_path)
# library(bslib)
# library(readxl, lib.loc = lib_path)
# library(DT, lib.loc = lib_path)
# library(zoo, lib.loc = lib_path)
# library(colourpicker, lib.loc = lib_path)
# library(tmaptools, lib.loc = lib_path)
# library(ggplot2, lib.loc = lib_path)
# library(sf, lib.loc = lib_path)
# library(shinylogs, lib.loc = lib_path)
# library(shinycssloaders, lib.loc = lib_path)
# library(profvis, lib.loc = lib_path)
# library(openxlsx, lib.loc = lib_path) #Don't Change order!
# library(xlsx, lib.loc = lib_path)
# #new libraries for leaflet
# library(leaflet, lib.loc = lib_path)
# library(htmltools)
# library(dplyr, lib.loc = lib_path)
# library(plotly, lib.loc = lib_path)  # Load plotly library for interactivity
# library(terra, lib.loc = lib_path)
# library(rnaturalearth, lib.loc = lib_path)
# library(rnaturlaearthdata, lib.loc = lib_path)

# Source for images
addResourcePath(prefix = 'pics', directoryPath = "www")

# Choosing theme and making colouring changes
my_theme <- bs_theme(version = 5, bootswatch = "united", primary = "#094030")

# Choosing theme and making colouring changes
my_theme <- bs_theme(version = 5, bootswatch = "united", primary = "#094030")

# Colour palette and variable names for ModE-RA source leaflet
  type_list <- c("bivalve_proxy", "coral_proxy", "documentary_proxy", "glacier_ice_proxy", "ice_proxy", "instrumental_data", "lake_sediment_proxy", "other_proxy", "speleothem_proxy", "tree_proxy")
  type_names <-c("Bivalve", "Coral", "Documentary", "Glacier ice", "Ice", "Instrumental", "Lake sediment", "Other", "Speleothem", "Tree")
  named_types <- setNames(type_names, type_list)
  # Create a Factor Palette with Paul Tol's Muted Colour List for Colour Blind People
  pal_type <- colorFactor(c('#AA4499', '#CC6677', '#44AA99', '#332288', '#88CCEE', '#882255', '#DDCC77', '#bbbbbb', '#999933', '#117733'), type_list)
  
  variable_list <- c("sea_level_pressure", "no_of_rainy_days", "pressure", "precipitation", "temperature", "historical_proxy", "natural_proxy")
  variable_names <- c("Sea level pressure", "No. of rainy days", "Pressure", "Precipitation", "Temperature", "Historical proxy", "Natural proxy")
  named_variables <- setNames(variable_names, variable_list)

# Spinner configurations
spinner_image = "pics/ClimeApp_Loading_V2.gif"
spinner_width = 310
spinner_height = 200

# Load pre-processed data
annual_temp_nc = nc_open("data/ModE-RA/year/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_temp2_abs_1421-2008_year.nc")
DJF_temp_nc = nc_open("data/ModE-RA/djf/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_temp2_abs_1421-2008_djf.nc")
MAM_temp_nc = nc_open("data/ModE-RA/mam/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_temp2_abs_1421-2008_mam.nc")
JJA_temp_nc = nc_open("data/ModE-RA/jja/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_temp2_abs_1421-2008_jja.nc")
SON_temp_nc = nc_open("data/ModE-RA/son/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_temp2_abs_1421-2008_son.nc")

annual_prec_nc = nc_open("data/ModE-RA/year/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_totprec_abs_1421-2008_year.nc")
DJF_prec_nc = nc_open("data/ModE-RA/djf/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_totprec_abs_1421-2008_djf.nc")
MAM_prec_nc = nc_open("data/ModE-RA/mam/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_totprec_abs_1421-2008_mam.nc")
JJA_prec_nc = nc_open("data/ModE-RA/jja/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_totprec_abs_1421-2008_jja.nc")
SON_prec_nc = nc_open("data/ModE-RA/son/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_totprec_abs_1421-2008_son.nc")

annual_slp_nc = nc_open("data/ModE-RA/year/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_slp_abs_1421-2008_year.nc")
DJF_slp_nc = nc_open("data/ModE-RA/djf/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_slp_abs_1421-2008_djf.nc")
MAM_slp_nc = nc_open("data/ModE-RA/mam/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_slp_abs_1421-2008_mam.nc")
JJA_slp_nc = nc_open("data/ModE-RA/jja/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_slp_abs_1421-2008_jja.nc")
SON_slp_nc = nc_open("data/ModE-RA/son/ModE-RA_lowres_20mem_Set_1420-3_1850-1_ensmean_slp_abs_1421-2008_son.nc")

## Create dataframe of preprocessed yearly variables
## - pp_data[[season]][[variable]] where
##   season IDs: 1=DJF, 2=MAM, 3=JJA, 4=SON, 5=annual)  
##   variable IDs: 1=temp, 2=prec, 3=SLP, 4=Z500)

pp_data = list(vector("list", 4),vector("list", 4),vector("list", 4),vector("list", 4),vector("list", 4))

pp_data[[5]][[1]] = ncvar_get(annual_temp_nc,varid="temp2")-273.15
pp_data[[5]][[2]] = ncvar_get(annual_prec_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month
pp_data[[5]][[3]] = ncvar_get(annual_slp_nc,varid="slp")/100
#pp_data[[5]][[4]] = ncvar_get(annual_nc,varid="geopotential_height")

pp_data[[1]][[1]] = ncvar_get(DJF_temp_nc,varid="temp2")-273.15
pp_data[[1]][[2]] = ncvar_get(DJF_prec_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month
pp_data[[1]][[3]] = ncvar_get(DJF_slp_nc,varid="slp")/100
#pp_data[[1]][[4]] = ncvar_get(DJF_nc,varid="geopotential_height")

pp_data[[2]][[1]] = ncvar_get(MAM_temp_nc,varid="temp2")-273.15
pp_data[[2]][[2]] = ncvar_get(MAM_prec_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month
pp_data[[2]][[3]] = ncvar_get(MAM_slp_nc,varid="slp")/100
#pp_data[[2]][[4]] = ncvar_get(MAM_nc,varid="geopotential_height")

pp_data[[3]][[1]] = ncvar_get(JJA_temp_nc,varid="temp2")-273.15
pp_data[[3]][[2]] = ncvar_get(JJA_prec_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month
pp_data[[3]][[3]] = ncvar_get(JJA_slp_nc,varid="slp")/100
#pp_data[[3]][[4]] = ncvar_get(JJA_nc,varid="geopotential_height")

pp_data[[4]][[1]] = ncvar_get(SON_temp_nc,varid="temp2")-273.15
pp_data[[4]][[2]] = ncvar_get(SON_prec_nc,varid="totprec")*2629756.8 # Multiply by 30.437*24*60*60 to convert Kg m-2 s-2 to get mm/month
pp_data[[4]][[3]] = ncvar_get(SON_slp_nc,varid="slp")/100
#pp_data[[4]][[4]] = ncvar_get(SON_nc,varid="geopotential_height")

# Extract list of longitudes/latitudes
lon = annual_temp_nc$dim[[3]]$vals
lat = annual_temp_nc$dim[[4]]$vals

## Close pre-processed netCDF files
nc_close(annual_temp_nc)
nc_close(DJF_temp_nc)
nc_close(MAM_temp_nc)
nc_close(JJA_temp_nc)
nc_close(SON_temp_nc)

nc_close(annual_prec_nc)
nc_close(DJF_prec_nc)
nc_close(MAM_prec_nc)
nc_close(JJA_prec_nc)
nc_close(SON_prec_nc)

nc_close(annual_slp_nc)
nc_close(DJF_slp_nc)
nc_close(MAM_slp_nc)
nc_close(JJA_slp_nc)
nc_close(SON_slp_nc)

## Create dataframe of continent lon/lats and Set initial latlon values
Europe = c(-30,40,30,75) 
Asia = c(25,170,5,80)
Australasia = c(90,180,-55,20)
Africa = c(-25,55,-40,40)
N_America = c(-175,-10,5,85)
S_America = c(-90,-30,-60,15)

continent_lonlat_values = data.frame(Europe,Asia,Australasia,Africa,N_America,S_America)
row.names(continent_lonlat_values) = c("lon_min","lon_max","lat_min","lat_max")

random_map = sample(1:6,1)

initial_lon_values = continent_lonlat_values[1:2,random_map]
initial_lat_values = continent_lonlat_values[3:4,random_map]

## Load grid square weights for calculating means
latlon_weights = as.matrix(read.csv("data/latlon_weights.csv"))

# Load shapefiles for maps (rnaturalearth)
coast <- st_read("data/geodata_maps/coast.shp")
countries <- st_read("data/geodata_maps/countries.shp")
oceans <- st_read("data/geodata_maps/oceans.shp")
land <- st_read("data/geodata_maps/land.shp")

#### Popovers ####

## ANOMALIES SUMMARY
## popover_IDs = pop_anomalies

anomalies_summary_popover = function(popover_ID){
  popover(
    h3(HTML("Anomalies <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "margin-left: 11px;"),
    "Anomalies show how a selected time period differs from a reference time period:",em("Anomalies = Absolute Values – Reference Values"),br(),br(),
    "The",em("Map"),"shows the average anomaly across all years in the range of years.",br(),br(),
    "The",em("Timeseries"),"shows the average anomaly across your selected geographic area for each year in the range of years.",br(),br(),  
    "See",em("ClimeApp functions"),"tab on the Welcome page for more information.",
    title = "What are anomalies?",
    id = popover_ID,
    placement = "right",
  ) 
}

## DATASET & VARIABLE
## popover_IDs = pop_anomalies_datvar, pop_composites_datvar

dataset_variable_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Select between the three ModE datasets:", br(), 
    "- ModE-RA – the full reanalysis (recommended)", br(),
    "- ModE-Sim – an ensemble of bounded climate models", br(),
    "- ModE-RAclim – ModE-RA without centennial-scale variability or forcings",br(),br(),
    "And select a climate variable:",br(),
    "- Temperature - air temperature at 2m [°C]",br(),
    "- Precipitation - total monthly precipitation [mm/m]",br(),
    "- SLP - sea level pressure [hPa]",br(),
    "- Z500 - pressure at 500 hPa geopotential height [m]",br(),br(),
    "See",em("ModE data"),"tab on the Welcome page for more information.",
    id = popover_ID,
    placement = "right",
  )
}

## YEAR, SEASON & REFERENCE PERIOD
## popover_IDs = pop_anomalies_time, pop_composites_time

year_season_ref_popover = function(popover_ID){
  # Anomalies popover
  if (popover_ID == "pop_anomalies_time"){
      popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Enter a",em("range of years"),"and a",em("range of months."),"ClimeApp will then calculate an average over these months for each year in the year range. You can view the absolute values for your selection by selecting",em("Absolute Values"),"under the Reference map selection below the main map.",br(),br(),
      "Then choose the",em("reference period"),"you would like to use for your anomalies. ClimeApp will then subtract the average over this reference period from the average for each year in the year range. You can view the absolute means for your reference period by selecting",em("Reference Values"),"under the",em("Reference map"),"selection below the main map.",
      id = popover_ID,
      placement = "right",
      )     
  } else {
  # Composites popover
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Enter or upload a",em("list of years"),"and a",em("range of months."),"ClimeApp will then calculate an average over these months for each year in the year list. You can view the absolute values for your selection by selecting",em("Absolute Values"),"under the Reference map selection below the main map.",br(),br(),
      "Then choose the",em("reference period"),"you would like to use for your composite. You can select from three types of reference period: A",em("Fixed reference,"),"averaged over a range of consecutive years; a",em("Custom reference,"),"averaged over a set of non-consecutive years; or an",em("X years prior"),"reference period, which will generate a separate reference for each year in the composite, based on the",em("X"),"years preceding that year. ClimeApp will then subtract the average over this reference period (or periods) from the average for each year in the",em("list of years."),"You can view the absolute means for your reference period by selecting",em("Reference Values"),"under the",em("Reference map"),"selection below the main map.",
      id = popover_ID,
      placement = "right",
    )     
  }
}

## MAP CUSTOMIZATION 
## popover_IDs = pop_anomalies_cusmap, pop_composites_cusmap, pop_correlation_cusmap

map_customization_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Edit the titles, axes and borders displayed on your map.",br(),br(),
    "You can view and adjust the limits of the map colour axis by selecting",em("Fixed"),"under",em("Axis customization."),"These limits will stay fixed even after a plot has been changed. Select",em("Automatic"),"to allow the axis to adjust automatically again.",
    id = popover_ID,
    placement = "right",
  )
}

## MAP CUSTOMIZATION LAYERS
## popover_IDs = pop_anomalies_layers, pop_composites_layers, pop_correlation_layers

map_customization_layers_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Show or hide modern country border by ticking the checkbox or upload your own",em("GeoPackage-Layer"),"using the upload button.",br(),br(),
    "Layers can be selected individually, their outline separately coloured and even reordered.",br(),
    "You can upload one or several shape files, compressed in a zip file, to add your own",em("shapes, borders, rivers, cities"),"on top of the global map. The shape file(s) (.shp) must have all dependencies (.shx, .dbf, .prj etc.) inside the zip. Accepted shapes are",em("polygons, points and lines."),
    id = popover_ID,
    placement = "right",
  )
}

## CUSTOM MAP FEATURES
## popover_IDs = pop_anomalies_mapfeat, pop_composites_mapfeat, pop_correlation_mapfeat

map_features_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Add labelled points or rectangular highlights (a box or a hashed area) to your map.",
    id = popover_ID,
    placement = "right",
  )    
}

## CUSTOM MAP POINTS 
## popover_IDs = pop_anomalies_mappoint, pop_composites_mappoint, pop_correlation_mappoint

map_points_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "To add a point, double click on the map or search for location. This will automatically set the",em("Point longitude"),"and",em("Point latitude"),"(enter multiple values here, separated by commas if you want to plot multiple points simultaneously). Then type a",em("Point label"),"(if required) and choose a",em("Point shape, Point colour"),"and",em("Point size."),"Finally, click",em("Add point"),"to add your point to the map.",br(),br(), 
    "Points can be removed from the map using the",em("Remove last point"),"and",em("Remove all points"),"buttons.",
    id = popover_ID,
    placement = "right",
  )
}

## CUSTOM MAP HIGHLIGHTS
## popover_IDs = pop_anomalies_maphl, pop_composites_maphl, pop_correlation_maphl

map_highlights_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "To add a highlight, draw a box on the map or manually enter a",em("Longitude"),"and",em("Latitude"),"range. Then select a",em("Highlight colour"),"and",em("Highlight type"),"and click",em("Add highlight"),"to add your highlight to the map.",br(),br(),
    "Highlights can be removed from the map using the",em("Remove last highlight"),"and",em("Remove all highlights"),"buttons.",
    id = popover_ID,
    placement = "right",
  )  
}

## MAP STATISTICS
## popover_IDs = pop_anomalies_mapstat, pop_composites_mapstat

map_statistics_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Add stipples to the map to show where data points match a certain criteria.",
    id = popover_ID,
    placement = "right",
  )
}

## MAP CHOOSES STATISTIC 
## popover_IDs = pop_anomalies_choosestat, pop_composites_choosestat

map_choose_statistic_popover = function(popover_ID){
  # Anomalies popover
  if (popover_ID == "pop_anomalies_choosestat"){
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "The",em("SD ratio"),"option will show points on the map where the SD ratio (averaged over your selected years) is less than a chosen value. The SD ratio shows the extent to which the climate models used to construct ModE-RA were constrained by observations. An SD ratio of 1 shows no constraint (i.e. the ModE-RA output is entirely generated from the models) and lower values show increasing constraint, meaning there are either more observations or that they are more ‘trusted’ by the reconstruction.",br(),br(),
      "See",em("ClimeApp functions"),"tab on the Welcome page for more information.",
      id = popover_ID,
      placement = "right",
    ) 
  } else {
  # Composites popover
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "The",em("SD ratio"),"option will show points on the map where the SD ratio (averaged over your selected years) is less than a chosen value. The SD ratio shows the extent to which the climate models used to construct ModE-RA were constrained by observations. An SD ratio of 1 shows no constraint (i.e. the ModE-RA output is entirely generated from the models) and lower values show increasing constraint, meaning there are either more observations or that they are more ‘trusted’ by the reconstruction.",br(),br(),
      em("% sign match"),"will show points on the map where the yearly anomalies that form the composite agree in their sign more often than the selected threshold. This gives an indication of the consistency of anomalies over the composite. Example: A composite of five years, with anomalies of -1°C, -5°C, 1°C, 15°C and -3°C, would display positive average anomaly. However, there would only be a 40% sign match since three of the years in fact have a negative.", br(),br(),
      "See",em("ClimeApp functions"),"tab on the Welcome page for more information.",
      id = popover_ID,
      placement = "right",
    ) 
  }

}

## DOWNLOADS
## popover_IDs = pop_anomalies_map_downloads,pop_anomalies_ts_downloads, pop_composites_map_downloads, pop_composites_ts_downloads,
##               pop_correlation_map_downloads, pop_correlation_ts_downloads

downloads_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Download your plot as a PNG, JPEG or PDF file.",br(),br(),
    "Use",em("Download metadata"),"to download all currently selected options (data and customization) as metadata. This can be used for reference or to quickly regenerate your current plot in a future session.", br(),br(),
    em("Upload metadata"),"from a previous session and click",em("Update upload inputs"),"to restore all ClimeApp options to those from the metadata. Note that metadata must be restored to the same tab (i.e.",em("Anomalies"),").", br(),br(),
    "Metadata is downloaded in .xlsx format.", 
    id = popover_ID,
    placement = "right",
  ) 
}

## REFERENCE MAP
## popover_IDs = pop_anomalies_refmap, pop_composites_refmap

reference_map_popover = function(popover_ID){
  # Anomalies popover
  if (popover_ID == "pop_anomalies_refmap"){
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Plot and download a reference map for your data.",br(),br(), 
      em("Absolute Values"),"shows the average for your selected month and year range, prior to subtracting the reference values. Note that the reanalysis method makes absolute values potentially unreliable – this is solved by using anomalies.",br(),br(),
      em("Reference Values"),"are the absolute means for your reference period.",br(),br(), 
      em("SD Ratio"),"shows the extent to which the climate models used to construct ModE-RA were constrained by observations. An SD ratio of 1 shows no constraint (i.e. the ModE-RA output is entirely generated from the models) and lower values show increasing constraint, meaning there are either more observations or that they are more ‘trusted’ by the reconstruction.",
      id = popover_ID,
      placement = "right",
    )
  } else {
  # Composites popover
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Plot and download a reference map for your data.",br(),br(), 
      em("Absolute Values"),"shows the average for your selected month range and list of years, prior to subtracting the reference values. Note that the reanalysis method makes absolute values potentially unreliable – this is solved by using anomalies.",br(),br(),
      em("Reference Values"),"are the absolute means for your reference period.",br(),br(), 
      em("SD Ratio"),"shows the extent to which the climate models used to construct ModE-RA were constrained by observations. An SD ratio of 1 shows no constraint (i.e. the ModE-RA output is entirely generated from the models) and lower values show increasing constraint, meaning there are either more observations or that they are more ‘trusted’ by the reconstruction.",
      id = popover_ID,
      placement = "right",
    )
  }
}

## TIMESERIES CUSTOMIZATION
## popover_IDs = pop_anomalies_custime, pop_composites_custime, pop_correlation_custime,pop_annualcycles_custime

timeseries_customization_popover = function(popover_ID){
  if (popover_ID == "pop_correlation_custime"|popover_ID == "pop_annualcycles_custime"){
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Edit the titles of your timeseries and add a features key.",
      id = popover_ID,
      placement = "right",
    )
  } else {
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Edit the titles of your timeseries and add a key or reference line.",br(),br(),
      "The",em("Show reference"),"option adds a line to the timeseries shows the mean for your selected reference period (i.e. the absolute value corresponding to an anomaly of 0).",
      id = popover_ID,
      placement = "right",
    )   
  }
}

## CUSTOM TIMESERIES FEATURES
## popover_IDs = pop_anomalies_timefeat, pop_composites_timefeat, pop_correlation_timefeat, pop_annualcycles_timefeat

timeseries_features_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Add labelled points, rectangular highlights (a boxed, filled or hashed area) and horizontal/vertical lines to your timeseries.",
    id = popover_ID,
    placement = "right",
  )  
}

## TIMESERIES POINTS
## popover_IDs = pop_anomalies_timepoint, pop_composites_timepoint, pop_correlation_timepoint, pop_annualcycles_timepoint

timeseries_points_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "To add a point, click on the timeseries or manually enter an",em("x"),"and",em("y"),"position. Clicking will automatically set the",em("x position"),"and",em("y position"),"(enter multiple values here, separated by commas if you want to plot multiple points simultaneously). Then type a",em("Point label"),"(if required) and choose a",em("Point shape, Point colour"),"and",em("Point size."),"Finally, click",em("Add point"),"to add your point to the timeseries.",br(),br(),
    "Points can be removed from the timeseries using the",em("Remove last point"),"and",em("Remove all points"),"buttons.",
    id = popover_ID,
    placement = "right",
  )  
}

## TIMESERIES HIGHLIGHTS
## popover_IDs = pop_anomalies_timehl, pop_composites_timehl, pop_correlation_timehl, pop_annualcycles_timehl

timeseries_highlights_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "To add a highlight, draw a box on the timeseries or manually enter",em("X"),"and",em("Y"),"values. Then select a",em("Highlight colour"),"and",em("Highlight type"),"and click",em("Add highlight"),"to add your highlight to the timeseries. Select",em("Show on key"),"and type a",em("Label"), "to add your highlight to the key. Remember to select the",em("Show key"),"option under",em("Customize your timeseries"),"to show the key on your plot",br(),br(),
    "Highlights can be removed from the timeseries using the",em("Remove last highlight"),"and",em("Remove all highlights"),"buttons.",
    id = popover_ID,
    placement = "right",
  )  
}

## TIMESERIES LINES
## popover_IDs = pop_anomalies_timelines, pop_composites_timelines, pop_correlation_timelines, pop_annualcycles_timelines

timeseries_lines_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "To add a line, click or double click on the timeseries to set the lines",em("Orientation"),"and",em("Position."),"Single click for a vertical line, double click for a horizontal. Multiple lines can be added simultaneously by entering multiple",em("Position"),"values, separated by commas. Then select a",em("Line colour"),"and",em("Type"),"and click",em("Add line"),"to add your line to the timeseries. Select",em("Show on key"),"and type a",em("Label"), "to add your line to the key. Remember to select the",em("Show key"),"option under",em("Customize your timeseries"),"to show the key on your plot",br(),br(),
    "Lines can be removed from the timeseries using the",em("Remove last line"),"and",em("Remove all lines"),"buttons.",
    id = popover_ID,
    placement = "right",
  )  
}

## TIMESERIES CUSTOM STATISTICS
## popover_IDs = pop_anomalies_timestats, pop_composites_timestats, pop_correlation_timestats

timeseries_statistics_popover = function(popover_ID){
  # Composites popover
  if (popover_ID == "pop_composites_timestats"){
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Add percentiles to your timeseries.",br(),br(),
      "Percentiles show where a percentage of points in the timeseries are above/below a given value. So, for the 0.95 percentile, 95% of points are between the two lines, 2.5% are above the upper line and 2.5% are below the lower line.",
      id = popover_ID,
      placement = "right",
    )  
  } else {
  # All other popovers
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Add moving averages and percentiles to your timeseries.",br(),br(),
      "A moving average shows the mean of a chosen number of years around each point on the timeseries. This is useful for ‘smoothing out’ short term variation.",br(),br(),
      "Percentiles show where a percentage of points in the timeseries are above/below a given value. So, for the 0.95 percentile, 95% of points are between the two lines, 2.5% are above the upper line and 2.5% are below the lower line.",
      id = popover_ID,
      placement = "right",
    )  
  }
}

## NETCDF
## popover_IDs = pop_anomalies_netcdf

netcdf_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Download the full dataset of yearly anomalies for your selected year, month and geographic range. You can include multiple variables in the same NetCDF file by selecting them on the dropdown menu.",
    id = popover_ID,
    placement = "right",
  )  
}

## MODE-RA SOURCES
## popover_IDs = pop_anomalies_mesource, pop_composites_mesource, pop_correlation_mesource, pop_regression_mesource, pop_anncyc_mesource

MEsource_popover = function(popover_ID){
  popover(
    h4(HTML("Plot ModE-RA sources <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 0px;"),
    "This plot shows location, type and variable measured for every source used to create ModE-RA and ModE-RAclim.",br(),br(), 
    "Note that each",em("source"),"may include one or more individual observations or measurements.", br(),br(),
    "The term", em("VARIABLE"),"refers to the value that was directly measured by each source. For example, a historical proxy might refer to a recorded tree flowering date, while a natural proxy, might refer to a measured tree ring width.",br(),br(), 
    "Use the",em("Explore ModE-RA Sources"),"tab or", em("Download Map Data"),"tool for more information on indiviudal sources",
    id = popover_ID,
    placement = "right",
  ) 
}

## COMPOSITES SUMMARY
## popover_IDs = pop_composites

composites_summary_popover = function(popover_ID){
  popover(
    h3(HTML("Composites <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "margin-left: 11px;"),
    "A composite is an average across multiple, non-consecutive years. The composite anomaly displayed is this average, minus the average over your selected",em("Reference period."),br(),br(),
    "The",em("Map"),"shows the average anomaly across all years in your list of years.",br(),br(),
    "The",em("Timeseries"),"shows the average anomaly across your selected geographic area for each year in the list of years.",br(),br(),
    "See",em("ClimeApp functions"),"tab on the Welcome page for more information.",
    title = "What are composites?",
    id = popover_ID,
    placement = "right",
  ) 
}

## CORRELATION SUMMARY
## popover_IDs = pop_correlation

correlation_summary_popover = function(popover_ID){
  popover(
    h3(HTML("Correlation <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "margin-left: 11px;"),
    "Correlation measures the statistical relationship (causal or non-causal) between two variables. This tab allows you to correlate two sets of ModE data, or upload you own data to correlate against the ModE data or correlate two sets of uploaded data.",br(),br(),
    "The", em("Timeseries"),"tab shows the timeseries and timeseries correlation for", em("Variable 1"),"and",em("Variable 2."),br(),br(),
    "The",em("Correlation map"),"shows the correlation between", em("Variable 1"),"and",em("Variable 2")," for each point on the map.",br(),br(),
    "See",em("ClimeApp functions"),"tab on the Welcome page for more information.",
    title = "What is correlation?",
    id = popover_ID,
    placement = "right",
  ) 
}

## CORRELATION VARIABLE
## popover_IDs = pop_correlation_variable1, pop_correlation_variable2

correlation_variable_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Select a ModE",em("dataset, variable, range of months"),"and",em("reference period"),"or upload your own annual user data.",br(),br(),
    "If uploading data, make sure it is yearly data. The variable name should be on the top row of each column and the first column should give the year of each entry, as shown.",br(),br(),
    "If using ModE data, select whether to use it as a",em("Field"),"or",em("Timeseries."),"ClimeApp will only correlate two sets of field data where their geographic areas overlap. Select",em("Timeseries"),"for one variable and",em("Field"),"for the other to have ClimeApp correlate a single timeseries with the timeseries for each point on the",em("Field"),"map.",br(),br(),
    "See",em("ModE data"),"and",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right",
  )  
}

## CORRELATION TIMESERIES
## popover_IDs = pop_correlation_timeseries

correlation_timeseries_popover = function(popover_ID){
  popover(
    h4(HTML("Timeseries Correlation <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "The plot shows your two selected variables plotted as timeseries.",br(),br(),
    "The",em("pearson"),"correlation method measures the linear relationship between the two timeseries, while the",em("spearman"),"correlation method measures the non-linear relationship.",br(),br(), 
    "The",em("r value"),"gives the strength of the correlation, with 1 being a perfect positive correlation, -1 being a perfect negative correlation and 0 showing no correlation.",br(),br(),
    "The",em("p value"),"shows the probability (as a decimal) of this correlation arising due to random chance rather than an actual statistical relationship.",
    id = popover_ID,
    placement = "right",
  ) 
}

## CORRELATION MAP
## popover_IDs = pop_correlation_map

correlation_map_popover = function(popover_ID){
  popover(
    h4(HTML("Correlation Map <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "The map shows the correlation between",em("Variable 1"),"and",em("Variable 2"),"for each point on the map. ",br(),br(),
    "The",em("pearson"),"correlation method measures the linear relationship between",em("Variable 1"),"and",em("Variable 2,"),"while the",em("spearman"),"correlation method measures the non-linear relationship.",br(),br(), 
    "The",em("r value"),"gives the strength of the correlation, with 1 being a perfect positive correlation, -1 being a perfect negative correlation and 0 showing no correlation.",
    id = popover_ID,
    placement = "right",
  ) 
}

## REGRESSION SUMMARY
## popover_IDs = pop_regression

regression_summary_popover = function(popover_ID){
  popover(
    h3(HTML("Regression <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "margin-left: 11px;"),
    "Regression takes one or more independent variables and calculates the linear equation that best links them to the dependent variable. This can be used ‘remove’ the effect of the independent variables, leaving the residual variation in the dependent variable.",br(),br(),
    "The",em("Regression timeseries"),"tab shows the",em("original, trend"),"and",em("residual"),"timeseries for the dependent variable, where",em("original = trend + residual."),"It also shows the statistics for the linear regression equation.",br(),br(),
    "The",em("Regression coefficient, pvalues"),"and",em("residuals"),"tabs show the",em("coefficients, p values"),"and",em("residuals"),"of the regression for each point on the map.",br(),br(),
    "See (?) on the individual tabs and the",em("ClimeApp functions"),"tab on the Welcome page for more information.",
    id = popover_ID,
    title = "What is regression?",
    placement = "right",
  ) 
}

## REGRESSION VARIABLE
## popover_IDs = pop_regression_independentvariable, pop_regression_dependentvariable

regression_variable_popover = function(popover_ID){
  if(popover_ID == "pop_regression_independentvariable"){
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Select a ModE",em("dataset, variable, range of months"),"and",em("reference period"),"or upload your own annual user data.",br(),br(),
      "If uploading data, make sure it is yearly data. The variable name should be on the top row of each column and the first column should give the year of each entry, as shown. You can select multiple variables to perform a multiple linear regression.",br(),br(),
      "ClimeApp will create a timeseries for the independent variable(s) and calculate the regression against a timeseries for the dependent variable. This is done for each point on the map if the dependent is a ModE variable.",br(),br(),
      "See",em("ModE data"),"and",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
      id = popover_ID,
      placement = "right",
    ) 
  } else {
    popover(
      HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
      "Select a ModE",em("dataset, variable, range of months"),"and",em("reference period"),"or upload your own annual user data.",br(),br(),
      "If uploading data, make sure it is yearly data. The variable name should be on the top row of each column and the first column should give the year of each entry, as shown.",br(),br(),
      "ClimeApp will create a timeseries for the independent variable(s) and calculate the regression against a timeseries for the dependent variable. This is done for each point on the map if the dependent is a ModE variable.",br(),br(),
      "See",em("ModE data"),"and",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
      id = popover_ID,
      placement = "right",
    )  
  }
}

## REGRESSION TIMESERIES
## popover_IDs = pop_regression_timeseries

regression_timeseries_popover = function(popover_ID){
  popover(
    h4(HTML("Regression Timeseries <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "Plot 1 shows the",em("original"),"data for the dependent variable and the",em("trend"),"in the dependent variable, as predicted from the linear regression and the independent variable(s).",br(),br(),
    "Plot 2 shows the",em("residual"),"values ( ",em("original – trend"),") for the dependent variable.",br(),br(),
    "The",em("Statistical summary"),"gives the",em("coefficients"),"and",em("intercept"),"for each independent variable as well as a summary of the",em("residuals"),"and further statistical information.",br(),br(),
    "See the",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right"
  )
}

## REGRESSION COEFFICIENT MAP
## popover_IDs = pop_regression_coefficients

regression_coefficient_popover = function(popover_ID){
  popover(
    h4(HTML("Regression Coefficients Map <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "The map shows the",em("coefficients"),"of the independent variable(s) in the linear regression equation, for each point on the map. Use",em("Choose a variable"),"to select which of the independent variables you would like to plot the coefficients for.",br(),br(),
    "The",em("coefficient"),"shows you what the independent variable is being multiplied by in the regression calculation.",br(),br(),
    "See the",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right"
  )
}

## REGRESSION P VALUES MAP
## popover_IDs = pop_regression_pvalues

regression_pvalue_popover = function(popover_ID){
  popover(
    h4(HTML("Regression P Values Map <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "The map shows the",em("p values"),"of the independent variable(s) in the linear regression equation, for each point on the map. Use",em("Choose a variable"),"to select which of the independent variables you would like to plot the p values for.",br(),br(),
    "The",em("p value"),"shows the probability (as a decimal) of the linear regression arising due to random chance rather than an actual statistical relationship.",br(),br(),
    "See the",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right"
  )
}

## REGRESSION RESIDUALS MAP
## popover_IDs = pop_regression_residuals

regression_residuals_popover = function(popover_ID){
  popover(
    h4(HTML("Regression Residuals Map <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "color: #094030; margin-left: 11px;"),
    "The map shows the",em("residual"),"values of the dependent variable, for the selected",em("Year,"),"for each point on the map.",br(),br(),
    "The residual values are the ‘leftover’ variation in the dependent variable, after the",em("trend"),"predicted from the independent variable(s) has been removed:",em("Residual = Original – Trend."),br(),br(),
    "See the",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right"
  )
}

## ANNUAL CYCLES SUMMARY
## popover_IDs = pop_annualcycles

annualcycles_summary_popover = function(popover_ID){
  popover(
    h3(HTML("Annual Cycles <sup><i class='fas fa-question-circle fa-xs'></i></sup>"), style = "margin-left: 11px;"),
    "This tool can be used to plot monthly values of a variable (absolute or anomaly) as an",em("annual cycle"),"for a given year or set of years. Multiple years can be displayed on the same plot, allowing several",em("annual cycles"),"to be compared.",
    title = "What are annual cycles?",
    id = popover_ID,
    placement = "right",
  ) 
}

## ANNUAL CYCLES DATA
## popover_IDs = pop_annualcycles_data

annualcycles_data_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Select a ModE",em("dataset, variable, year/list of years/range of years"),"and",em("reference period."),br(),br(),
    "If entering a",em("list of years,"),"separate each year with a comma (e.g. 1815,1816). If entering a",em("range of years,"),"separate the two years with a dash (e.g. 1815-1820). Multiple years can be plotted as either",em("Individual years,"),"with all years in the list/range plotted as separate lines, or as an",em("Average,"),"which will plot a single line showing the monthly average for all years in the list/range.",br(),br(),
    "See",em("ModE data"),"and",em("ClimeApp functions"),"tabs on the Welcome page for more information.",
    id = popover_ID,
    placement = "right",
  )  
}

## ANNUAL CYCLES REGION
## popover_IDs = pop_annualcycles_region

annualcycles_region_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "Select a geographical area and click",em("Add to graph"),"to add your current selection to the plot as a timeseries. The line will show the monthly average across this area.",br(),br(),
    "Select",em("Switch to point location input"),"to search for or enter a single point rather than an area.",br(),br(),
    "Timeseries can be removed using the",em("Remove last TS"),"and",em("Remove all TS buttons."),
    id = popover_ID,
    placement = "right",
  )  
}

## TOTAL SOURCES AND OBSERVATIONS POPOVER
## popover_IDs = pop_sourcesandobservation
sourcesandobservations_popover = function(popover_ID){
  popover(
    HTML("<i class='fas fa-question-circle fa-2xs'></i></sup>"), style = "color: #094030; margin-left: 11px;",
    "The timeseries below the main map shows the total number of", em("sources"),"that were used to create ModE-RA/ModE-RAclim for each year/half-year.",br(),br(),
    "Note that each",em("source"),"may include one or more individual observations or measurements.", br(),br(),
    "Click names on the legend to add/remove lines from the plot.",
    id = popover_ID,
    placement = "right",
  )
}

#### Internal Functions ####
# (Functions used ONLY by other functions)

## GENERATE TITLE MONTHS
## data input = month_range

generate_title_months = function(MR){
  if (MR[1]==1 & MR[2]==12){
    title_months = "Annual"
  } else {
    month_letters  = c("D","J","F","M","A","M","J","J","A","S","O","N","D")
    title_months = paste(month_letters[(MR[1]:MR[2])+1],collapse = "")
  }
  return(title_months)
}


## ADD POINTS AND HIGHLIGHTS TO MAP - only used by the plot_ ... _map functions
## data input = custom point data, custom highlights data and statistical 
##              highlights data

add_map_points_and_highlights = function(CP_data,CH_data,SH_data){
  
  # Add statistical points to plot
  if (dim(SH_data)[1]>0){
    points(SH_data$x_vals,SH_data$y_vals,cex = (SH_data$criteria_val)*0.5,pch = 20)
  }
  # Add custom points to plot
  if (dim(CP_data)[1]>0){
    points(CP_data$x_value,CP_data$y_value,col = CP_data$color,
           pch = CP_data$shape, cex = CP_data$size)
    text(CP_data$x_value,CP_data$y_value, label = CP_data$label,pos = 1)
  }
  # Add highlights to plot
  if (dim(CH_data)[1]>0){
    for (i in 1:length(CH_data$x1)){
      if (CH_data$type[i] == "Box"){
        my_density = NULL
        my_lwd = 3
        my_col = NA
        my_border = CH_data$color[i]
      } else if (CH_data$type[i] == "Hatched"){
        my_density = 10
        my_lwd = NULL
        my_col = CH_data$color[i] 
        my_border = NA
      }
      rect(CH_data$x1[i],CH_data$y1[i],CH_data$x2[i],CH_data$y2[i],density = my_density,
           lwd = my_lwd, col = my_col, border = my_border)
    }
  }  
}

## ADD POINTS AND HIGHLIGHTS TO GGPLOT MAP
## The same function as add_map_points_and_highlights but for ggplot maps
## plot = a ggplot object
## SH_data = statistical highlights data
## CP_data = custom point data
## CH_data = custom highlights data
add_ggmap_points_and_highlights <- function(plot, CP_data, CH_data, SH_data) {

  # Add statistical points to plot
  if (nrow(SH_data) > 0) {
    plot <- plot + 
      geom_point(data = SH_data, aes(x = x_vals, y = y_vals, size = I(criteria_val * 0.5)), shape = 20)
  }
  
  # Add custom points to plot
  if (nrow(CP_data) > 0) {
    plot <- plot + 
      geom_point(data = CP_data, aes_string(x = "x_value", y = "y_value", color = "color", shape = "shape", size = "size")) +
      geom_text(data = CP_data, aes_string(x = "x_value", y = "y_value", label = "label"), position = position_nudge(y = -0.5))
  }
  
  # Add highlights to plot
  if (nrow(CH_data) > 0) {
    for (i in 1:nrow(CH_data)) {
      if (CH_data$type[i] == "Box") {
        plot <- plot + 
          geom_rect(aes_string(xmin = CH_data$x1[i], xmax = CH_data$x2[i], ymin = CH_data$y1[i], ymax = CH_data$y2[i]),
                    color = CH_data$color[i], fill = NA, size = 1)
      } else if (CH_data$type[i] == "Hatched") {
        plot <- plot + 
          geom_rect(aes_string(xmin = CH_data$x1[i], xmax = CH_data$x2[i], ymin = CH_data$y1[i], ymax = CH_data$y2[i]),
                    color = NA, fill = CH_data$color[i], alpha = 0.5)
      }
    }
  }
  
  return(plot)
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

create_subset_lon_IDs = function(lon_range){
  subset_lon_IDs = which((lon >= lon_range[1]) & (lon <= lon_range[2]))
  if (length(subset_lon_IDs)<=1){
    subset_lon_IDs = which((lon >= lon_range[1]-1.875) & (lon <= lon_range[2]+1.875))
  }
  return(subset_lon_IDs)
}


## (General) Create a subset of latitude IDs for plotting, tables and reading in data

create_subset_lat_IDs = function(lat_range){
  subset_lat_IDs = which((lat >= lat_range[1]) & (lat <= lat_range[2]))
  if (length(subset_lat_IDs)<=1){
    subset_lat_IDs = which((lat >= lat_range[1]-1.849638) & (lat <= lat_range[2]+1.849638))
  }
  return(subset_lat_IDs)
}


## (General) GENERATE MAP DIMENSIONS
##           Creates a vector of dimensions for the on-screen map and downloads: 
##           c(on screen width,on screen height, download width, download height, lon/lat)
##           output_width = session$clientData$output_>>INSERT OUTPUT NAME <<_width
##           output_height = session$clientData$output_>>INSERT OUTPUT NAME <<_height
##           hide_axis = TRUE or FALSE

generate_map_dimensions = function(subset_lon_IDs,subset_lat_IDs,output_width,
                                   output_height, hide_axis){
  
  lon_over_lat = ((length(subset_lon_IDs)-1)*1.875)/((length(subset_lat_IDs)-1)*1.849638)
  
  # Width of left axis + key in pixels
  if (hide_axis == TRUE){
    w_ax = 175
  } else {
    w_ax = 70 # TO CHECK!!!
  }
  # Height of bottom axis + title in pixels
  h_ax = 110
  
  # Set width and height when map is BELOW input tab
  if (output_width<750){
    w = output_width
    h = ((w - w_ax)*(1/lon_over_lat))+h_ax
    
    # Set w/h by height (i.e for a tall map)
  } else if ((output_width/output_height)>lon_over_lat){
    h = output_height*0.8
    w = ((h - h_ax)*(lon_over_lat))+w_ax
    # Deal with too large widths
    if (w>output_width){
      w = output_width*0.75
      h = ((w - w_ax)*(1/lon_over_lat))+h_ax
      # Deal with very tiny widths
    } else if (w<500){w = 500}
    
    # Set w/h by width (i.e.for wide map)
  } else {
    w = output_width*0.9
    h = ((w - w_ax)*(1/lon_over_lat))+h_ax
    # Deal with too large heights
    if (h>output_height){
      h = output_height*0.75
      w = ((h - h_ax)*(lon_over_lat))+w_ax
      # Deal with very tiny heights
    } else if (h<175){h = 175} 
  }
  
  # Generate download dimensions
  total_image_size = 6000000
  m = sqrt(total_image_size/(w*h))
  w_d = m*w
  h_d = m*h
  
  return(c(w,h,w_d,h_d,lon_over_lat))
}


## (General) GENERATE DATA ID
##           Creates a vector with the reference numbers for ModE data:
##           c(pre-processed data? (0 = NO, 1 = yes, preloaded, 2 = yes, not preloaded)
##             ,dataset,variable,season)
##           data_set = "ModE-RA","ModE-Sim","ModE-RAclim" or "SD Ratio"

generate_data_ID = function(dataset,variable,month_range){
  
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

load_ModE_data = function(dataset,variable){
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

create_latlon_subset = function(data_input,data_ID,subset_lon_IDs,subset_lat_IDs){
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

create_yearly_subset = function(data_input,data_ID,year_range,month_range){
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

convert_subset_to_anomalies = function(data_input,ref_data){
  
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
##                                           netcdf_title
##           tab = "general" or "composites", "reference", or "sdratio"
##           dataset = "ModE-RA","ModE-Sim","ModE-RAclim"
##           mode = "Absolute" or "Anomaly" for general tab
##                  "Absolute", "Fixed reference" or ""X years prior"
##                   for composites tab
##           map/ts_title_mode = "Default" or "Custom"
##           year_range,baseline_range,baseline_years_before 
##                = set to NA if not relevant for selected tab
##           map/ts_custom_title1/2 = user entered titles
##           title_size = numeric value for the title font size, default = 18

generate_titles = function(tab,dataset,variable,mode,map_title_mode,ts_title_mode,month_range,
                           year_range,baseline_range,baseline_years_before,lon_range,
                           lat_range,map_custom_title1,map_custom_title2,ts_custom_title,title_size=18){
  
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
  
  # Create Timeseries title 
  if (tab=="composites"){
    ts_title = paste(substr(map_title, 1, nchar(map_title) - 18),
                     " [",lon_range[1],":",lon_range[2],"\u00B0E, ",lat_range[1],":",lat_range[2],"\u00B0N]", sep = "")
  } else {
    ts_title = paste(substr(map_title, 1, nchar(map_title) - 10),
                 " [",lon_range[1],":",lon_range[2],"\u00B0E, ",lat_range[1],":",lat_range[2],"\u00B0N]", sep = "")
  }

  # Create timeseries axis label
  if (variable == "Temperature"){
    v_unit = "[\u00B0C]"
  } else if (variable == "Precipitation"){
    v_unit = "[mm/month]"
  } else if (variable == "SLP"){
    v_unit = "[hPa]"
  } else if (variable == "Z500"){
    v_unit = "[m]"
  }  
  
  if (mode == "Absolute"){
    ts_axis = paste(title_months," Mean ",variable," ",v_unit,sep = "")
  } else {
    ts_axis = paste(title_months," ",variable," Anomaly ",v_unit,sep = "")
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
    ts_title = ts_custom_title
  }
  
  # Create title for filenames
  tf1 = gsub("[[:punct:]]", "", map_title)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Netcdf title
  netcdf_title = gsub(paste(variable),"NCDF-Data",file_title)
  
  # Title font size
  map_title_size = title_size
  ts_title_size = title_size
  
  # Combine into dataframe
  m_titles = data.frame(map_title,map_subtitle,ts_title,ts_axis,file_title,netcdf_title, map_title_size, ts_title_size)
  
  return(m_titles)
}

## (General) SET DEFAULT/CUSTOM AXIS VALUES
##           data_input = same as data_input for mapping function
##           mode = "Absolute" or "Anomalies"

set_axis_values = function(data_input,mode){
  
  if (mode == "Absolute"){
    minmax = c(min(data_input),max(data_input))  
  } else {
    z_max = max(abs(data_input))
    minmax = c(-z_max,z_max)
  }
  
  minmax = signif(minmax,digits = 3)
  
  return(minmax)
}


## (General) DEFAULT MAP PLOTTING FUNCTION - including taking average of dataset
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
##           plot_type = "shp_colour_" or "shp_colour2_" depending on the type of shapefile (?)

# plot_default_map = function(data_input,variable,mode,titles,axis_range, hide_axis,
#                             points_data, highlights_data,stat_highlights_data,c_borders, plotOrder, shpPickers, input, plotType){
# 
#   # Define the prefix for the color pickers based on plotType
#   if (plotType == "shp_colour_") {
#     color_picker_prefix <- "shp_colour_"
#   } else if (plotType == "shp_colour2_") {
#     color_picker_prefix <- "shp_colour2_"
#   }
# 
#   ## Create x, y & z values
#   x_str = colnames(data_input)
#   x = as.numeric(substr(x_str, 1, nchar(x_str) - 1)) # removes degree symbols
# 
#   y_str = rownames(data_input)
#   y = rev(as.numeric(substr(y_str, 1, nchar(y_str) - 1))) # removes degree symbols and reverses y
# 
#   z = t(as.matrix(data_input))[,rev(1:length(y))] #  rearranges z for plotting
# 
# 
#   ## Generate units & color scheme
#   if (variable == "Temperature"){
#     v_col = colorRampPalette(rev(brewer.pal(11,"RdBu"))) ; v_unit = "\u00B0C"
#   }
#   else if (variable == "Precipitation"){
#     v_col = colorRampPalette(brewer.pal(11,"BrBG")) ; v_unit = "mm/mon."
#   }
#   else if (variable == "SLP"){
#     v_col = colorRampPalette(rev(brewer.pal(11,"PRGn"))) ; v_unit = "hPa"
#   }
#   else if (variable == "Z500"){
#     v_col = colorRampPalette(rev(brewer.pal(11,"PRGn"))) ; v_unit = "m"
#   }
#   else if (variable == "SD Ratio"){
#     v_col = colorRampPalette(rev(brewer.pal(9,"Greens"))) ; v_unit = ""
#   }
# 
#   ## Plot with axis
#   if (hide_axis == FALSE){
#     # Plot with default axis
#     if(is.null(axis_range[1])){
# 
#       # Absolute
#       if (mode == "Absolute"){
#         filled.contour(x,y,z, color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
#           axis(1, seq(-170, 180, by = 10))
#           axis(2, seq(-90, 90, by = 10))
#           add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
# 
#           for (file in plotOrder) {
#             file_name <- tools::file_path_sans_ext(basename(file))
#             if (file_name %in% shpPickers) {
#               shape <- st_read(file)
#               shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
# 
#               # Plot based on geometry type
#               geom_type <- st_geometry_type(shape)
#               if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, border = input[[paste0(color_picker_prefix, file_name)]], col = NA)
# 
#               } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]])
# 
#               } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]], pch = 1)
#               }
#             }
#           }
# 
#           },
#           key.title = title(main = v_unit,font.main = 1))
#       }
# 
#       # Anomaly
#       else {
#         z_max = max(abs(z))
# 
#         filled.contour(x,y,z, zlim = c(-z_max,z_max), color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
#           axis(1, seq(-170, 180, by = 10))
#           axis(2, seq(-90, 90, by = 10))
#           add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
# 
#           for (file in plotOrder) {
#             file_name <- tools::file_path_sans_ext(basename(file))
#             if (file_name %in% shpPickers) {
#               shape <- st_read(file)
#               shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
# 
#               # Plot based on geometry type
#               geom_type <- st_geometry_type(shape)
#               if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, border = input[[paste0(color_picker_prefix, file_name)]], col = NA)
# 
#               } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]])
# 
#               } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
#                 plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]], pch = 1)
#               }
#             }
#           }
# 
# 
#           },
#           key.title = title(main = v_unit,font.main = 1))
#       }
#     }
#     # Plot with custom axis
#     else {
#       filled.contour(x,y,z, zlim = axis_range, color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
#         axis(1, seq(-180, 180, by = 10))
#         axis(2, seq(-90, 90, by = 10))
#         add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
# 
#         for (file in plotOrder) {
#           file_name <- tools::file_path_sans_ext(basename(file))
#           if (file_name %in% shpPickers) {
#             shape <- st_read(file)
#             shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
# 
#             # Plot based on geometry type
#             geom_type <- st_geometry_type(shape)
#             if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
#               plot(st_geometry(shape), add = TRUE, border = input[[paste0(color_picker_prefix, file_name)]], col = NA)
# 
#             } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
#               plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]])
# 
#             } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
#               plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]], pch = 1)
#             }
#           }
#         }
# 
#         },
#         key.title = title(main = v_unit,font.main = 1))
#     }
#     # Add title 2
#     title(titles$map_title2, cex.main = 1,   font.main= 1, adj=0.845)
# 
#   }
# 
#   ## Plot without axis
#   else {
#     plot(NA,xlim=range(x),
#          ylim=range(y),xlab="",ylab="",
#          frame=FALSE,axes=F,xaxs="i",yaxs="i")
#     # Plot without default axis
#     if(is.null(axis_range[1])){
#       # Absolute
#       if (mode == "Absolute"){
#         mylevs = pretty(range(z, finite = TRUE),20)
# 
#         .filled.contour(x=x, y=y, z=z,
#                         levels=mylevs,
#                         col=v_col(length(mylevs)-1))
#       }
#       # Anomaly
#       else {
#         z_max = max(abs(z))
# 
#         mylevs = pretty(c(-z_max,z_max),20)
# 
#         .filled.contour(x=x, y=y, z=z,
#                         levels=mylevs,
#                         col=v_col(length(mylevs)-1))
#       }
#     }
#     # Plot without custom axis
#     else {
#       mylevs = pretty((axis_range),20)
# 
#       .filled.contour(x=x, y=y, z=z,
#                       levels=mylevs,
#                       col=v_col(length(mylevs)-1))
#     }
#     # Add world map and side axes
#     plot.axes=map("world",interior=c_borders,add=T)
#     axis(1, seq(-180, 180, by = 10))
#     axis(2, seq(-90, 90, by = 10))
#     axis(3,c(-180, 180), label=FALSE, tcl=0, las=1)
#     axis(4,c(-90, 90), label=FALSE, tcl=0, las=1)
#     add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
# 
#     for (file in plotOrder) {
#       file_name <- tools::file_path_sans_ext(basename(file))
#       if (file_name %in% shpPickers) {
#         shape <- st_read(file)
#         shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
# 
#         # Plot based on geometry type
#         geom_type <- st_geometry_type(shape)
#         if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
#           plot(st_geometry(shape), add = TRUE, border = input[[paste0(color_picker_prefix, file_name)]], col = NA)
# 
#         } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
#           plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]])
# 
#         } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
#           plot(st_geometry(shape), add = TRUE, col = input[[paste0(color_picker_prefix, file_name)]], pch = 1)
#         }
#       }
#     }
# 
#     # Add title 2
#     title(titles$map_title2, cex.main = 1,   font.main= 1, adj=1)
#   }
# 
#   # Add title 1
#   title(titles$map_title1, cex.main = 1.5,   font.main= 1, adj=0)
# 
# }

# Plot map with ggplot2
plot_map <- function(data_input, variable = NULL, mode = NULL,
                     titles = NULL, axis_range = NULL, hide_axis = FALSE, points_data = data.frame(), 
                     highlights_data = data.frame(), stat_highlights_data = data.frame(), c_borders = TRUE, 
                     white_ocean = FALSE, white_land = FALSE, plotOrder = NULL, shpPickers = NULL, 
                     input = NULL, plotType = "default", projection = "UTM (default)", 
                     center_lat = 0, center_lon = 0) {

  # Define color picker prefix for shapefiles
  color_picker_prefix <- ifelse(plotType == "shp_colour_", "shp_colour_", "shp_colour2_")
  
  # Define the color palette and unit based on the variable and mode
  if (mode == "Correlation") {
    v_col <- rev(brewer.pal(11, "PuOr")); v_unit <- "r"  
  } else if (mode == "Regression_coefficients") {
    v_col = rev(brewer.pal(11,"Spectral")); v_unit = "coefficient"
  } else if (mode == "Regression_p_values") {
    v_col = rev(brewer.pal(5,"Greens")); v_unit = "p value"
    v_lev = c(0,0.01,0.05,0.1,0.2,1)
  } else if (mode == "Regression_r_squared") {
    v_col = rev(brewer.pal(11,"Spectral")); v_unit = "r squared"
  }
  else { # if anomalies or absolute values
    if (variable == "Temperature") {
      v_col <- rev(brewer.pal(11, "RdBu")); v_unit <- "\u00B0C"
    } else if (variable == "Precipitation") {
      v_col <- brewer.pal(11, "BrBG"); v_unit <- "mm/mon."
    } else if (variable == "SLP") {
      v_col <- rev(brewer.pal(11, "PRGn")); v_unit <- "hPa"
    } else if (variable == "Z500") {
      v_col <- rev(brewer.pal(11, "PRGn")); v_unit <- "m"
    } else if (variable == "SD Ratio") {
      v_col <- rev(brewer.pal(9, "Greens")); v_unit <- ""
    }
  }
  
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
      fill = guide_colorbar(
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
    p <- p + coord_sf(xlim = c(xmin(data_input), xmax(data_input)), ylim = c(ymin(data_input), ymax(data_input)), expand = FALSE)
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

  # Add point and highlights
  p <- add_ggmap_points_and_highlights(p, points_data, highlights_data, stat_highlights_data)
  
  return(p)
}


## (General) CREATE MAP DATATABLE
##           data_input = yearly_subset or subset_to_anomalies data

create_map_datatable = function(data_input,subset_lon_IDs,subset_lat_IDs){

  # find x,y & z values
  x = lon[subset_lon_IDs]
  y = lat[subset_lat_IDs]

  data_mean = apply(data_input,c(1:2),mean) # finds mean of input data
  z = data_mean[,rev(1:length(y))]

  # Transpose and rotate z
  map_data =t(z)[order(ncol(z):1),]

  colnames(map_data) = paste(x,"\u00B0",sep = "")
  rownames(map_data) = paste(round(y, digits = 3),"\u00B0",sep = "")

  return(map_data)
}


## (General) CREATE BASIC TIMESERIES DATATABLE
##           data_input = same as data_input for create_map_datatable
##           year_input = either year_range or year_set (for composites)
##           year_input_type = "range" (for general) or "set" (for composites)

create_timeseries_datatable = function(data_input,year_input,year_input_type,
                                       subset_lon_IDs,subset_lat_IDs){
  
  # Create years column
  if (year_input_type == "range"){
    Year = year_input[1]:year_input[2]
  } else {
    Year = year_input
  }
  
  # Calculate weighted Mean column
  latlon_weights_reduced = latlon_weights[subset_lat_IDs,subset_lon_IDs]
  weight_function = function(df,llwr){df_weighted = (df*llwr)/sum(llwr)}
  data_weighted = apply(data_input,c(3),weight_function, t(latlon_weights_reduced))
  Mean = apply(data_weighted,c(2),sum)
  
  # create Min and Max columns
  Min = apply(data_input,c(3),min)
  Max = apply(data_input,c(3),max)
  
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

add_stats_to_TS_datatable = function(data_input, add_moving_average,
                                     moving_average_range,moving_average_alignment,
                                     add_percentiles,percentiles,use_MA_percentiles){
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
    
    # Test data for normality
    p_value = shapiro.test(Mean)[[2]]
    
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


## (General) TIMESERIES PLOTTING FUNCTION - sets up graph for plotting (plots actual
##                                          values in white)
##           tab = "general" or "composites"
##           data_input = timeseries_datatable
##           title_mode = "Default" or "Custom"
##           ref = NA or the mean of the reference data

plot_default_timeseries = function(data_input,tab,variable, titles, title_mode, ref){
  
  # Set up variables for plotting
  x = data_input$Year
  y = data_input[,2]
  y_mean = mean(y)
  y_sd = sd(y)
  y_range = range(y)
  
  # Generate units & color scheme
  if (variable == "Temperature"){
    v_col = "red3" ; v_unit = "\u00B0C"
  } else if (variable == "Precipitation"){
    v_col = "turquoise4" ; v_unit = "mm/month"
  } else if (variable == "SLP"){
    v_col = "purple4" ; v_unit = "hPa"
  } else if (variable == "Z500"){
    v_col = "green4" ; v_unit = "m"
  }  
  
  # Plot 
  if (tab == "general"){
    plot(x, y, type = "l", col = v_col, lwd = 2, xaxs="i",
         xlab = "Year", ylab = titles$ts_axis)
  } else {
    plot(x, y, type = "p", col = v_col, xaxs="i",
         xlab = "Year", ylab = titles$ts_axis)
  }
  
  
  # Add titles
  title(titles$ts_title,adj = 0, line = 0.5)
  
  if (title_mode == "Default"){
    title(paste("Mean = ",signif(y_mean,3),v_unit,"  Range = ", signif(y_range[1],3), v_unit,":", signif(y_range[2],3),
                v_unit, "   SD = ",signif(y_sd,3),v_unit,sep=""),
          cex.main = 1,   font.main= 1, adj=1, line = 0.5)
  }
  
  # Add reference line
  if (!is.na(ref)){
    text_x = min(x) + ((range(x)[2]-range(x)[1])/25.5) 
    abline(h = 0, lwd = 1)
    text(text_x,0,labels = paste0(ref,v_unit),pos=3)
  }
}


## (General) REWRITE MAPTABLE - rewrites maptable to get rid of degree symbols 
##                              Set subset_lon/lat to NA for correlation/regression

rewrite_maptable = function(maptable,subset_lon_IDs,subset_lat_IDs){
  
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

rewrite_tstable = function(tstable,variable){
  
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

load_modera_source_data = function(year,season){
  # Load data
  feedback_data = read.csv(paste0("data/feedback_archive_fin/",season,year,".csv"))  
}


## (General) PLOT MODE-RA SOURCES creates a plot of the ModE-RA data sources for
##           a given year and season
##           year = a single user selected or default year
##           season = "summer" or "winter"
##           minmax_lonlat = c(min_lon,max_lon,min_lat,max_lat) ->
##                           c(-180,180,-90,90) for non-zoomed plot

plot_modera_sources = function(ME_source_data,year,season,minmax_lonlat){
  
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

download_feedback_data = function(global_data, lon_range, lat_range) {

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
plot_ts_modera_sources <- function(data, year_column, selected_columns, line_titles, title, x_label, y_label, x_ticks_every, year_range) {
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

generate_custom_netcdf = function(data_input,tab,dataset,ncdf_ID,variable,user_nc_variables,
                                  mode,subset_lon_IDs,subset_lat_IDs,month_range,
                                  year_range,baseline_range,baseline_years_before){
  
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

create_geotiff <- function(map_data, output_file = NULL) {
  
  # Extract lon and lat from column and row names
  x <- as.numeric(gsub("\u00B0", "", colnames(map_data)))
  y <- as.numeric(gsub("\u00B0", "", rownames(map_data)))
  
  # Check if dimensions of the matrix match the lon/lat lengths
  if (ncol(map_data) != length(x) || nrow(map_data) != length(y)) {
    stop("Matrix dimensions do not match the provided longitude/latitude ranges")
  }
  
  r <- rast(as.matrix(map_data))
  ext(r) <- ext(min(x), max(x), min(y), max(y)) # define rater extent
  
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

generate_metadata <- function(axis_mode, axis_input, hide_axis, title_mode, title1_input, title2_input, 
                              custom_statistic, sd_ratio, hide_borders) {
  
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

generate_metadata_ts <- function(title_mode_ts, title1_input_ts, show_key_ts, key_position_ts, show_ref_ts, custom_average_ts, year_moving_ts, percentile_ts, moving_percentile_ts) {
  
  
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

generate_metadata_plot <- function(dataset,variable,range_years,select_sg_year,sg_year,season_sel,range_months,
                                   ref_period,select_sg_ref,sg_ref,lon_range,lat_range,lonlat_vals) {
  
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

updateRadioButtonsGroup <- function(selected_value, inputIds) {
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

create_sdratio_data = function(data_input,data_ID,tab,variable,subset_lon_IDs,subset_lat_IDs,
                               month_range,year_range){
  
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

create_stat_highlights_data = function(data_input,sd_data,stat_highlight,sdratio,
                                       percent,subset_lon_IDs,subset_lat_IDs){
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

create_new_highlights_data = function(highlight_x_values,highlight_y_values,
                                      highlight_color, highlight_type,
                                      show_highlight_on_key,highlight_label){
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

create_new_lines_data = function(line_orientation,line_locations,line_color,
                                 line_type,show_line_on_key,line_label){
  
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

create_new_points_data = function(point_x_values,point_y_values,point_label,
                                  point_shape,point_color,point_size){
  # Create x/y values from strings
  x_value = as.numeric(unlist(strsplit(point_x_values,",")))
  y_value = as.numeric(unlist(strsplit(point_y_values,",")))
  # Repeat other values to match x/y length
  label = rep(point_label,length(x_value))
  shape = rep(point_shape,length(x_value))
  color = rep(point_color,length(x_value))
  size = rep(point_size,length(x_value))
  # Combine into a dataframe
  new_p_data = data.frame(x_value,y_value,label,shape,color,size)
  
  return(new_p_data)
  
}


## (Plot Features) ADD HIGHLIGHTED AREA TO PLOT (fill,box or hatched)
##                 data_input = highlights_data 
##                             (as created by create_new_highlights_data)

add_highlighted_areas = function(data_input){
  
  if (dim(data_input)[1]>0){
    # Cycle through each row in the highlights_data
    for (i in 1:length(data_input$x1)){
      # Set up variables for plotting
      if (data_input$type[i] == "Fill"){
        my_density = NULL
        my_lwd = NULL
        my_col = data_input$color[i] 
        my_border = NA
      } else if (data_input$type[i] == "Box"){
        my_density = NULL
        my_lwd = 3
        my_col = NA
        my_border = data_input$color[i]
      } else if (data_input$type[i] == "Hatched"){
        my_density = 10
        my_lwd = NULL
        my_col = data_input$color[i] 
        my_border = NA
      }
      
      # Add highlights to plot
      rect(data_input$x1[i],data_input$y1[i],data_input$x2[i],data_input$y2[i],density = my_density,
           lwd = my_lwd, col = my_col, border = my_border)
    }
  }
}


## (Plot Features) ADD PERCENTILES TO TS PLOT
##                 data_input = output from add_stats_to_TS_datatable

add_percentiles = function(data_input){
  
  if (dim(data_input)[1]>0){
    # Set up variables for plotting
    x = data_input$Year
    cnames = colnames(data_input)
    
    # Add percentiles (if available)
    if ("Percentile_0.005" %in% cnames){
      lines(x,data_input$Percentile_0.005, lwd=2, col = adjustcolor("firebrick4",alpha.f = 0.7))
    }
    if ("Percentile_0.025" %in% cnames){
      lines(x,data_input$Percentile_0.025, lwd=2, col = adjustcolor("orangered3",alpha.f = 0.7))
    }
    if ("Percentile_0.05" %in% cnames){
      lines(x,data_input$Percentile_0.05, lwd=2, col = adjustcolor("darkgoldenrod3",alpha.f = 0.7))
    }
    if ("Percentile_0.95" %in% cnames){
      lines(x,data_input$Percentile_0.95, lwd=2, col = adjustcolor("darkgoldenrod3",alpha.f = 0.7))
    }
    if ("Percentile_0.975" %in% cnames){
      lines(x,data_input$Percentile_0.975, lwd=2, col = adjustcolor("orangered3",alpha.f = 0.7))
    }
    if ("Percentile_0.995" %in% cnames){
      lines(x,data_input$Percentile_0.995, lwd=2, col = adjustcolor("firebrick4",alpha.f = 0.7))
    }
  }
}


## (Plot Features) ADD CUSTOM LINES TO PLOT
##                 data_input = lines_data
##                              (as created by create_new_lines_data)

add_custom_lines = function(data_input){
  if (dim(data_input)[1]>0){
    # Subset lines into x (vertical) and y (horizontal)
    vlines = subset(data_input,orientation=="Vertical")
    hlines = subset(data_input,orientation=="Horizontal")
    
    # Plot Vertical lines
    abline(v = vlines$location, lwd = 2, lty = vlines$type, col = vlines$color)
    # Plot Horizontal lines
    abline(h = hlines$location, lwd = 2, lty = hlines$type, col = hlines$color)
  }
}


## (Plot Features) ADD TIMESERIES - replots timeseries over other features and
##                                     adds moving average (if selected)
##                 data_input = output from add_stats_to_TS_datatable
##                 tab = "general" or "composite"

add_timeseries = function(data_input,tab,variable){
  
  # Set up variables for plotting
  x = data_input$Year
  y = data_input[,2]
  
  cnames = colnames(data_input)
  
  # Generate color scheme
  if (variable == "Temperature"){
    v_col = "red3"
  } else if (variable == "Precipitation"){
    v_col = "turquoise4"
  } else if (variable == "SLP"){
    v_col = "purple4"
  } else if (variable == "Z500"){
    v_col = "green4"
  }
  
  # Plot 
  if (tab == "general"){
    lines(x,y,col = v_col, lwd = 2)
  } else {
    points(x,y,col = v_col)
  }
  
  
  #Add moving average (if available)
  if ("Moving_Average" %in% cnames){
    lines(x,data_input$Moving_Average,lwd = 3)
  }
}


## (Plot Features) ADD CORRELATION TIMESERIES - replots both correlation timeseries 
##                                              over other features and adds moving
##                                              average (if selected)
##                 data_input1/2 = output from add_stats_to_TS_datatable for v1/v2

add_correlation_timeseries = function(data_input1,data_input2,variable1,variable2,
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


## (Plot Features) ADD BOXES TO TS PLOT - plots only the box highlights from the 
##                 highlights_data dataframe
##                 data_input = highlights_data

add_boxes = function(data_input){
  if (dim(data_input)[1]>0){
    # Create a box subset of the highlights data
    box_data = subset(data_input,data_input$type == "Box")
    
    # Add boxes to plot
    rect(box_data$x1,box_data$y1,box_data$x2,box_data$y2,density = NULL,
         lwd = 3, col = NA, border = box_data$color)
  }
}


## (Plot Features) ADD CUSTOM POINTS TO A TS PLOT - adds custom points to a TS plot
##                 data_input = points_data (as created by create_new_points_data)

add_custom_points = function(data_input){
  if (dim(data_input)[1]>0){  
    points(data_input$x_value,data_input$y_value,col = data_input$color,
           pch = data_input$shape, cex = data_input$size)
    text(data_input$x_value,data_input$y_value, label = data_input$label,pos = 1)
  }
}


## (Plot Features) ADD TS KEY - adds a key to the timeseries with the selected 
##                              variable and moving average, and any lines or
##                              highlights selected to be included in the key
##                 key_position = "topleft", "topright","bottomleft" or "bottomright"
##                 add_moving_average = TRUE or FALSE
##                 moving_average_range = single number (3 to 33)
##                 add_percentiles = TRUE of FALSE
##                 percentiles = a vector of percentile values c(0.9,0.95 or 0.99)
##                 secondary variable = variable name or NA if not used
##                 show_primary_variable = TRUE or FALSE (only false for annual cycles)

add_TS_key = function(key_position,data_highlights,data_lines,variable,month_range,add_moving_average,
                      moving_average_range,add_percentiles,percentiles,secondary_variable,secondary_month_range,
                      show_primary_variable){
  
  ## Generate "variable" legend parameters:
  # label
  if (month_range[1]==1 & month_range[2]==12){
    title_months = "Annual"
  } else {
    month_letters  = c("D","J","F","M","A","M","J","J","A","S","O","N","D")
    title_months = paste(month_letters[(month_range[1]:month_range[2])+1],collapse = "")
  }
  label = paste(title_months,variable)
  # color
  if (variable == "Temperature"){
    color = "red3" 
  } else if (variable == "Precipitation"){
    color = "turquoise4"
  } else if (variable == "SLP"){
    color = "purple4"
  } else if (variable == "Z500"){
    color = "green4"
  } else {
    color = "darkorange2"
    label = variable
  }
  # line parameters
  lwd = 2 ; lty = "solid"
  # box parameters
  fill = NA; density = 0 ; border = "grey90"
  # alignment parameters
  x_intersp = 1.4
  
  # Use parameters to create legend_data dataframe:
  legend_data = data.frame(label,color,lwd,lty,fill,density,border,x_intersp)
  
  
  ## Generate second variable legend parameters:
  # label
  if (!is.na(secondary_variable)){
    if (secondary_month_range[1]==1 & secondary_month_range[2]==12){
      title_months = "Annual"
    } else {
      month_letters  = c("D","J","F","M","A","M","J","J","A","S","O","N","D")
      title_months = paste(month_letters[(secondary_month_range[1]:secondary_month_range[2])+1],collapse = "")
    }
    label = paste(title_months,secondary_variable)
    # color
    if (variable == secondary_variable){
      
      if (secondary_variable == "Temperature"){
        color = "red2" 
      } else if (secondary_variable == "Precipitation"){
        color = "turquoise2"
      } else if (secondary_variable == "SLP"){
        color = "purple2"
      } else if (secondary_variable == "Z500"){
        color = "green2"
      } else {
        color = "saddlebrown"
        label = secondary_variable
      }
      
    } else {
      if (secondary_variable == "Temperature"){
        color = "red3" 
      } else if (secondary_variable == "Precipitation"){
        color = "turquoise4"
      } else if (secondary_variable == "SLP"){
        color = "purple4"
      } else if (secondary_variable == "Z500"){
        color = "green4"
      } else {
        color = "saddlebrown"
        label = secondary_variable
      }
    }
    
    
    # line parameters
    lwd = 2 ; lty = "solid"
    # box parameters
    fill = NA; density = 0 ; border = "grey90"
    # alignment parameters
    x_intersp = 1.4
    
    # Add to legend_data:
    legend_data = rbind(legend_data,list(label,color,lwd,lty,fill,density,border,x_intersp))
  }
  
  
  ## Generate "moving average" legend parameters:
  if (add_moving_average==TRUE){
    label = paste(moving_average_range,"yr Moving Ave.",sep = "")
    color = "black"
    # line parameters
    lwd = 2 ; lty = "solid"
    # box parameters
    fill = NA; density = 0 ; border = "grey90"
    # alignment parameters
    x_intersp = 1.4
    
    # Add to legend_data:
    legend_data = rbind(legend_data,list(label,color,lwd,lty,fill,density,border,x_intersp))
  }  
  
  
  ## Generate "percentile" legend parameters:
  if (add_percentiles==TRUE & length(percentiles)>0){
    for(i in percentiles){
      # Label
      label = paste(i," Percentile")
      # Colors
      if (i==0.99){
        color = adjustcolor("firebrick4",alpha.f = 0.7)
      } else if (i == 0.95){
        color = adjustcolor("orangered3",alpha.f = 0.7)
      } else {
        color = adjustcolor("darkgoldenrod3",alpha.f = 0.7)
      }
      # line parameters
      lwd = 2 ; lty = "solid"
      # box parameters
      fill = NA; density = 0 ; border = "grey90"
      # alignment parameters
      x_intersp = 1.4
      
      # Add to legend_data:
      legend_data = rbind(legend_data,list(label,color,lwd,lty,fill,density,border,x_intersp))
    }
  }
  
  
  ## Create "custom lines" legend parameters
  
  if (dim(data_lines)[1]>0){
    # subset data_lines for line that are to be added to the key AND unique
    data_lines_subset = data.frame()
    
    if (dim(data_lines)[2]>0){
      data_lines_subset = subset(data_lines, select = -c(orientation,location)) # remove unnecessary columns
      data_lines_subset = subset(data_lines_subset,key_show == TRUE) # remove lines not selected for key
      data_lines_subset = data_lines_subset[!duplicated(data_lines_subset),] # remove duplicates
      data_lines_subset = data_lines_subset[order(data_lines_subset$type),] # sort by type
    }
    
    # Extract parameters and add to dataframe
    if (dim(data_lines_subset)[1]>0){
      for (i in 1:dim(data_lines_subset)[1]){
        label = data_lines_subset$label[i]
        color = data_lines_subset$color[i]
        # line parameters
        lwd = 2 ; lty = data_lines_subset$type[i]
        # box parameters
        fill = NA; density = 0 ; border = "grey90"
        # alignment parameters
        x_intersp = 1.4
        
        # Add to legend_data:
        legend_data = rbind(legend_data,list(label,color,lwd,lty,fill,density,border,x_intersp))
      }
    }
  }
  
  ## Create "custom highlights" legend parameters
  if (dim(data_highlights)[1]>0){
    # subset data_highlights for highlights that are to be added to the key AND unique
    data_highlights_subset = data.frame()
    
    if (dim(data_highlights)[2]>0){
      data_highlights_subset = subset(data_highlights, select = -c(x1,x2,y1,y2)) # remove unnecessary columns
      data_highlights_subset = subset(data_highlights_subset,key_show == TRUE) # remove highlights not selected for key
      data_highlights_subset = data_highlights_subset[!duplicated(data_highlights_subset),] # remove duplicates
      data_highlights_subset <- data_highlights_subset[order(data_highlights_subset$type),] # sort by type
    }
    
    # Extract parameters and add to dataframe
    if (dim(data_highlights_subset)[1]>0){
      for (i in 1:dim(data_highlights_subset)[1]){
        label = data_highlights_subset$label[i]
        # line parameters
        color = NA ; lwd = NA ; lty = "None"
        # box parameters
        if (data_highlights_subset$type[i]=="Box"){
          fill = NA; density = 0 ; border = data_highlights_subset$color[i]
        } else if (data_highlights_subset$type[i]=="Fill"){
          fill = data_highlights_subset$color[i] ; density = NA ; border = "grey90"
        } else {
          fill = data_highlights_subset$color[i] ; density = 20 ; border = "grey90"
        }
        # alignment parameters
        x_intersp = 0
        
        # Add to legend_data:
        legend_data = rbind(legend_data,list(label,color,lwd,lty,fill,density,border,x_intersp))
      }
    }
  }
  
  # Remove first line (primary variable) if required
  if (show_primary_variable == FALSE){
    legend_data = legend_data[-1,]
  }
  
  ## Add Key to plot:
  legend(key_position, inset = c(0.008,0.03),
         legend=legend_data$label,
         # Line options
         col = legend_data$color,
         lwd = legend_data$lwd,
         lty = legend_data$lty,
         # Box options
         fill=legend_data$fill,
         density=legend_data$density,
         border = legend_data$border,
         # Align boxes with lines
         x.intersp=legend_data$x_intersp,
         # Draw box round key
         bg = "grey90",
         box.lty = 0
  ) 
  
} 


## (Plot Features) ADD SHAPE FILE LAYERS TO STANDARD PLOTS
##                  zipFile = input to the shpFile
##                  plotOrder = reactive Value to store the plot Order
##                  pickerInput = Layer Picker Input
##                  reorderSelect = Modal Button
##                  reorderAfter = Modal Button
##                  input = Colour Input

# Define a function to extract shapefile contents and update plot order (Anomaly)
updatePlotOrder <- function(zipFile, plotOrder, pickerInput) {
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
updatePlotOrder2 <- function(zipFile, plotOrder, pickerInput) {
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
updatePlotOrder3 <- function(zipFile, plotOrder, pickerInput) {
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
reorder_shapefiles <- function(plotOrder, reorderSelect, reorderAfter, pickerInput) {
  
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

#### Composite Functions ####

## (Composite) Read user year data and convert into a year_set vector
##             data_input_manual = a string of years (e.g. "1455,1532,1782")
##             data_input_filepath = filepath to an excel or csv document listing
##                                   years to be composited
##                                   (assumes column DOES NOT have a header)

read_composite_data = function(data_input_manual,data_input_filepath,year_input_mode){
  
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

create_yearly_subset_composite = function(data_input,data_ID,year_set,month_range){
  
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

convert_composite_to_anomalies = function(data_input,ref_data,data_ID,year_set,month_range,baseline_year_before){
  
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

generate_metadata_comp <- function(axis_mode2, axis_input2, hide_axis2, title_mode2, title1_input2, title2_input2, 
                              custom_statistic2, percentage_sign_match2, sd_ratio2, hide_borders2) {
  
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

generate_metadata_ts_comp <- function(title_mode_ts2, title1_input_ts2, show_key_ts2, key_position_ts2, show_ref_ts2, custom_percentile_ts2, percentile_ts2) {
  
  
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

generate_metadata_plot_comp <- function(dataset2,variable2,range_years2,season_sel2,range_months2,ref_period2,
                                        select_sg_ref2,sg_ref2,prior_years2,range_years2a,lon_range2,lat_range2,lonlat_vals2) {
  
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

read_regcomp_data = function(data_input_filepath){
  
  # Read in user data
  if (grepl(".csv",data_input_filepath, fixed = TRUE)==TRUE){
    user_data = read.csv(data_input_filepath)
  } else {
    user_data = read_excel(data_input_filepath)
  }
  
  user_data = replace(user_data,user_data == -999.9,NA)
  
  return(user_data)
}

## (Regression/Correlation) EXTRACT SHARED YEAR RANGE from user/modE-RA data,which can 
##                          be used to set min,max and value of year_range input
##                          - returns a vector with c(year_range1,year_range2,
##                            year_range_min,year_range_max)
##                          variable_source = "ModE-RA" or "User Data"
##                          variable_data_filepath = "" by default

extract_year_range = function(variable1_source,variable2_source,variable1_data_filepath,variable2_data_filepath){
  
  # Set initial values of V1_min/max and V2_min/max to ModE-RA defaults
  V1_min = 1422 ; V1_max = 2008
  V2_min = 1422 ; V2_max = 2008
  
  # Set V1_min/max from user data
  if (variable1_source == "User Data" & !is.null(variable1_data_filepath)){
    if(grepl(".xls",variable1_data_filepath, fixed = TRUE)==TRUE){
      years = read_excel(variable1_data_filepath, range = cell_cols("A"))
      V1_min = min(years) ; V1_max = max(years)
    }
    else if(grepl(".csv",variable1_data_filepath, fixed = TRUE)==TRUE){
      years = read.csv(variable1_data_filepath)[,1]
      V1_min = min(years) ; V1_max = max(years)
    }
  }
  
  # Set V2_min/max from user data
  if (variable2_source == "User Data"& !is.null(variable2_data_filepath)){
    if(grepl(".xls",variable2_data_filepath, fixed = TRUE)==TRUE){
      years = read_excel(variable2_data_filepath, range = cell_cols("A"))
      V2_min = min(years) ; V2_max = max(years)
    }
    else if(grepl(".csv",variable2_data_filepath, fixed = TRUE)==TRUE){
      years = read.csv(variable2_data_filepath)[,1]
      V2_min = min(years) ; V2_max = max(years)
    }
  }
  
  # Find shared year range
  YR_min = max(c(V1_min,V2_min))
  YR_max = min(c(V1_max,V2_max))
  
  # Set default values
  if (variable1_source == "ModE-" & variable2_source == "ModE-"){
    YR1 = 1900 ; YR2 = 2000
  } else {
    YR1 = YR_min ; YR2 = YR_max
  }  
  
  return(c(YR1,YR2,YR_min,YR_max)) 
}  


## (Regression/Correlation) CREATE USER DATA SUBSET - cuts user data to year_range
##                          and chosen variable and replaces missing values with NA
##                      data_input = as created by read_regcomp_data
##                      variable = as selected from user data headings (a single string
##                                 for correlation, or multiple strings for regression)
##                      year_range = as selected by the user (from the range of years 
##                                   generated by extract_year_range) 

create_user_data_subset = function(data_input,variable,year_range){
  UD_ss_year_range = subset(data_input,data_input[,1]>=year_range[1] & data_input[,1]<=year_range[2])
  UD_ss_variable = UD_ss_year_range[,variable]
  UD_ss_year = UD_ss_year_range[,1]
  
  UD_ss = data.frame(UD_ss_year,UD_ss_variable)
  colnames(UD_ss) = c("Year",variable)
  
  # Replace missing values an text with NAs
  UD_ss[,2] = as.numeric(UD_ss[,2])
  
  return(UD_ss)
}


## (Regression/Correlation) EXTRACT SHARED LONLAT VALUES - Find shared lonlat values for
##                          v1 and v2 that will be used for the map plot

extract_shared_lonlat = function(variable1_type,variable2_type,
                                 variable1_lon_range,variable1_lat_range,
                                 variable2_lon_range,variable2_lat_range){
  
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

plot_user_timeseries = function(data_input,color){
  
  # Calculate y statistics
  y = data_input[,2]
  y_range = range(data_input[,2])
  # Test data for normality
  p_value = shapiro.test(data_input[,2])[[2]]
  if (p_value>0.05){
    y_sd = sd(data_input[,2])
  } else {
    y_sd = NA
  }
  
  #Plot
  plot(data_input$Year, y, type = "l", col = color, lwd = 2, xaxs="i",
       xlab = "Year", ylab = colnames(data_input)[2])
  
  title(paste("Range = ", signif(y_range[1],3),":", signif(y_range[2],3),"   SD = ",
              signif(y_sd,3),sep=""), cex.main = 1,   font.main= 1, adj=1, line = 0.5)
}


## (Correlation) GENERATE CORRELATION TITLES - creates a dataframe of V1_axis_label,
##                                             V2_axis_label, V1_color,V2_color,
##                                             TS_title, Map_title,file_title
##             variable_source = "ModE-RA" or "User Data"
##             variable = user or ModE-RA variable name
##             variable_type = "Timeseries" or "Field"
##             variable_mode = "Absolute" or "Anomaly"
##             method = "pearson" or "spearman" ("pearson" by default)

generate_correlation_titles = function(variable1_source,variable2_source,
                                       variable1_dataset,variable2_dataset,
                                       variable1,variable2,
                                       variable1_type,variable2_type,
                                       variable1_mode,variable2_mode,
                                       variable1_month_range,variable2_month_range,
                                       variable1_lon_range, variable2_lon_range,
                                       variable1_lat_range, variable2_lat_range,
                                       year_range, method,map_title_mode,ts_title_mode,
                                       map_custom_title, map_custom_subtitle, ts_custom_title, title_size){
  
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
    
    V1_axis_label = paste(V1_axis_label,V1_lonlat)
    V2_axis_label = paste(V2_axis_label,V2_lonlat)
  }
  
  # Generate combined titles:
  if (ts_title_mode == "Custom"){
    TS_title = ts_custom_title
  } else {
    TS_title = paste(V1_TS_title,"&",V2_TS_title)
  }
  
  if (map_title_mode == "Custom"){
    map_title = map_custom_title
    map_subtitle = map_custom_subtitle
  } else {
    map_title = "Correlation coefficient"
    map_subtitle = paste("Variable 1:", V1_TS_title,"/nVariable 2:",V2_TS_title)
  }
  
  # Generate download titles
  tf0 = paste("Corr",V1_file_title,"&",V2_file_title)
  tf1 = gsub("[[:punct:]]", "", tf0)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Title font size
  map_title_size = title_size
  ts_title_size = title_size
  
  cor_titles = data.frame(V1_axis_label, V2_axis_label,V1_color,V2_color,TS_title,
                          map_title, map_subtitle, file_title, map_title_size, ts_title_size)
  
  return(cor_titles)
}


## (Correlation) PLOT COMBINED TIMESERIES
##               variable_data = either user_data_subset
##                               or ModE-RA timeseries_datatable
##               correlation_titles = as generated by generate_correlation_titles function                 

plot_combined_timeseries = function(variable1_data,variable2_data,correlation_titles){
  
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

correlate_timeseries = function(variable1_data,variable2_data,method){
  r = cor.test(variable1_data[,2],variable2_data[,2],method = method,use = "complete.obs")
  return (r)
}


## (Correlation) GENERATE CORRELATION MAP DATA creates correlation map data (x,y,z) from
##               either a timeseries and a field or two fields (NOT two timeseries!)
##               variable_data = either user_data_subset
##                               or ModE-RA timeseries_datatable
##                               or ModE-RA yearly_subset/anomalies data 
##               method = "pearson" or "spearman" ("pearson" by default)
##               Note: uses the subset_lat/lon functions

generate_correlation_map_data = function(variable1_data, variable2_data, method,
                                         variable1_type, variable2_type,
                                         variable1_lon_range, variable2_lon_range,
                                         variable1_lat_range, variable2_lat_range){
  
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


## (Correlation) PLOT CORRELATION MAP - should only be run if variable 1 or 2 is 
##               ModE-RA and at least one ModE-RA data is a field
##               data_input = correlation_map_data
##               method = "pearson" or "spearman" ("pearson" by default)
##               points/highlights/stat_highlights_data = as created by the 
##                  create_..._data functions OR and empty dataframe if not 
##                  available/used

plot_correlation_map = function(data_input, correlation_titles,axis_range,
                                hide_axis,points_data, highlights_data,stat_highlights_data,c_borders,plotOrder, shpPickers, input){
  
  # Set up variables
  x = data_input[[1]]
  y = data_input[[2]]
  z = data_input[[3]]
  
  z_max = max(abs(z))
  minmax = c(-z_max,z_max)
  
  # Plot
  v_col = colorRampPalette(rev(brewer.pal(11,"PuOr")))
  
  if (hide_axis == FALSE){
    # Plot with default axis
    if(is.null(axis_range[1])){
      filled.contour(x,y,z, zlim = minmax, color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
        axis(1, seq(-170, 180, by = 10))
        axis(2, seq(-90, 90, by = 10))
        add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
        
        for (file in plotOrder) {
          file_name <- tools::file_path_sans_ext(basename(file))
          if (file_name %in% shpPickers) {
            shape <- st_read(file)
            shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
            
            # Plot based on geometry type
            geom_type <- st_geometry_type(shape)
            if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, border = input[[paste0("shp_colour3_", file_name)]], col = NA)
              
            } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]])
              
            } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]], pch = 1)
            }
          }
        }
        
        },
        key.title = title(main = "r",font.main = 1))
    } 
    # Plot with custom axis
    else {
      filled.contour(x,y,z, zlim = axis_range, color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
        axis(1, seq(-180, 180, by = 10))
        axis(2, seq(-90, 90, by = 10))
        add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
        
        for (file in plotOrder) {
          file_name <- tools::file_path_sans_ext(basename(file))
          if (file_name %in% shpPickers) {
            shape <- st_read(file)
            shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
            
            # Plot based on geometry type
            geom_type <- st_geometry_type(shape)
            if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, border = input[[paste0("shp_colour3_", file_name)]], col = NA)
              
            } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]])
              
            } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
              plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]], pch = 1)
            }
          }
        }
        
        },
        key.title = title(main = "r",font.main = 1))
    }
  }
  
  # Plot without axis
  else {
    plot(NA,xlim=range(x),
         ylim=range(y),xlab="",ylab="",
         frame=FALSE,axes=F,xaxs="i",yaxs="i")
    # Plot without default axis
    if(is.null(axis_range[1])){
      
      mylevs = pretty(minmax,20)
      
      .filled.contour(x=x, y=y, z=z,
                      levels=mylevs,
                      col=v_col(length(mylevs)-1))
    } 
    # Plot without custom axis
    else {
      mylevs = pretty((axis_range),20)
      
      .filled.contour(x=x, y=y, z=z,
                      levels=mylevs,
                      col=v_col(length(mylevs)-1))
    }
    # Add world map and side axes
    plot.axes=map("world",interior=c_borders,add=T)
    axis(1, seq(-180, 180, by = 10))
    axis(2, seq(-90, 90, by = 10))
    axis(3,c(-180, 180), label=FALSE, tcl=0, las=1)
    axis(4,c(-90, 90), label=FALSE, tcl=0, las=1)
    add_map_points_and_highlights(points_data,highlights_data,stat_highlights_data)
    
    for (file in plotOrder) {
      file_name <- tools::file_path_sans_ext(basename(file))
      if (file_name %in% shpPickers) {
        shape <- st_read(file)
        shape <- st_transform(shape, crs = st_crs("+proj=longlat +datum=WGS84"))
        
        # Plot based on geometry type
        geom_type <- st_geometry_type(shape)
        if ("POLYGON" %in% geom_type || "MULTIPOLYGON" %in% geom_type) {
          plot(st_geometry(shape), add = TRUE, border = input[[paste0("shp_colour3_", file_name)]], col = NA)
          
        } else if ("LINESTRING" %in% geom_type || "MULTILINESTRING" %in% geom_type) {
          plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]])
          
        } else if ("POINT" %in% geom_type || "MULTIPOINT" %in% geom_type) {
          plot(st_geometry(shape), add = TRUE, col = input[[paste0("shp_colour3_", file_name)]], pch = 1)
        }
      }
    }
    
  }  
  
  # Add title
  title(correlation_titles$map_title, cex.main = 1.5,   font.main= 1, adj=0)
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
  
  # Add row/col names
  colnames(zt) = paste(x,"\u00B0",sep = "")
  rownames(zt) = paste(round(rev(y), digits = 3),"\u00B0",sep = "")
  
  return(zt)
}

## (Correlation) GENERATE METADATA FROM CUSTOMIZATION INPUTS TO SAVE FOR LATER USE FOR PLOT
##               data input = Input form Plot Customization

generate_metadata_corr <- function(axis_mode3, axis_input3, hide_axis3, title_mode3, title1_input3,
                                   hide_borders3, cor_method_map3) {

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

generate_metadata_ts_corr <- function(title_mode_ts3, title1_input_ts3, show_key_ts3,
                                      key_position_ts3, custom_average_ts3, year_moving_ts3, cor_method_ts3) {

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

generate_metadata_plot_corr <- function(dataset,variable,type,mode,season_sel,range_months,
                                        ref_period,select_sg_ref,sg_ref,lon_range,lat_range,lonlat_vals) {

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

create_ME_timeseries_data = function(dataset,variables,subset_lon_IDs,subset_lat_IDs,
                                     mode,month_range,year_range,baseline_range){
  
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

generate_regression_titles = function(independent_source,dependent_source,
                                      dataset_i,dataset_d,modERA_dependent_variable,
                                      mode_i,mode_d,month_range_i,month_range_d,
                                      lon_range_i,lon_range_d,lat_range_i,lat_range_d,
                                      year_range){
  
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
  
  # Generate download titles
  tf0 = paste("Reg",title_months_i,"ind. var.", ">", title_months_d, modERA_dependent_variable)
  tf1 = gsub("[[:punct:]]", "", tf0)
  tf2 = gsub(" ","-",tf1)
  file_title = iconv(tf2, from = 'UTF-8', to = 'ASCII//TRANSLIT')
  
  # Combine all titles into a dataframe
  titles_df = data.frame(title_months_i,title_mode_i,title_lonlat_i,
                         title_months_d,title_mode_d,title_lonlat_d,
                         color_d,unit_d,title_year_range,file_title)
  
  return(titles_df)
}

## (Regression) CALCULATE SUMMARY DATA
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = Mod-Era create_timeseries_datatable for ONE variable
##              independent_variables = selected independent variables user or ModE-Ra
##                                      as a list,e.g. (c("CO2.ppm.","TSI.w.m2."))

create_regression_summary_data = function(independent_variable_data, dependent_variable_data, independent_variables){
  x = as.matrix(independent_variable_data[,independent_variables])
  y = as.matrix(dependent_variable_data[,2])
  regression_data = lm(y~x)
  return(regression_data)
}


## (Regression) Calculate regression coefficients for mapping (the first dimension
##              is the number in user_variables of each variable)
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = any yearly ModE-RA data (absolute or anomaly)

create_regression_coeff_data = function(independent_variable_data, dependent_variable_data, independent_variables){
  reg_coeffs <- apply(dependent_variable_data, c(1:2), function(fy,fx) lm(fy~fx)$coef,as.matrix(independent_variable_data[,independent_variables]))[-1,,]
  # Note that [-1,,] removes the intercepts from the coef data 
  return(reg_coeffs)
}


## (Regression) Calculate regression p values for mapping (the first dimension
##              is the number in user_variables of each variable)
##              independent_variable_data = timeseries data for one or more variables
##              dependent_variable_data = any yearly ModE-RA data (absolute or anomaly)

create_regression_pvalue_data = function(independent_variable_data, dependent_variable_data, independent_variables){
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

create_regression_residuals = function(independent_variable_data, dependent_variable_data, independent_variables){
  reg_residuals <- apply(dependent_variable_data, c(1:2), function(fy,fx) lm(fy~fx)$residuals,as.matrix(independent_variable_data[,independent_variables]))
  return(reg_residuals)
}


## (REGRESSION) CREATE REGRESSION MAP DATATABLE
##              data_input = 2D data that was plotted for coeffs, pvalue or residuals

create_regression_map_datatable = function(data_input,subset_lon_IDs,subset_lat_IDs){
  
  # find x,y & z values
  x = lon[subset_lon_IDs]
  y = lat[subset_lat_IDs]
  z = data_input
  
  # Transpose
  map_data =t(z)
  
  colnames(map_data) = paste(x,"\u00B0",sep = "")
  rownames(map_data) = paste(round(y, digits = 3),"\u00B0",sep = "")
  
  return(map_data)
}



## (Regression) PLOT COEFFICIENT MAP
##              data_input = regression_coeff_data
##              ind/dep_variable = name/s of ind/dep variables
##              independent_variable_number = number in "user_independent_variables" 
##                                            of the variable to be plotted
##                                            (set to 1 as default)
##              subset_lon/lat_IDs = subset_lon/lat_IDs for dependent variable


plot_regression_coefficients = function(data_input,independent_variables,independent_variable_number,
                                        dependent_variable,regression_titles,
                                        subset_lon_IDs_d,subset_lat_IDs_d,c_borders){
  
  # Create x, y & z values
  x = lon[subset_lon_IDs_d]
  y = rev(lat[subset_lat_IDs_d])
  if (length(independent_variables)==1){ #  Deals with the 'variable' dimension disappearing
    z = data_input[,rev(1:length(y))]  
  } else {
    z = data_input[independent_variable_number,,rev(1:length(y))]
  }
  
  # Generate color scheme
  v_col = colorRampPalette(rev(brewer.pal(11,"Spectral")))
  
  # Generate title
  title_main = paste("Regression Coefficients. ",
                     regression_titles$title_months_i,
                     independent_variables[independent_variable_number]," ",
                     regression_titles$title_mode_i,regression_titles$title_lonlat_i," -> ",
                     regression_titles$title_months_d,dependent_variable,
                     regression_titles$title_mode_d,". ",regression_titles$title_year_range,
                     sep = "")
  
  # Plot
  z_max = max(abs(z))
  
  filled.contour(x,y,z, zlim = c(-z_max,z_max), color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
    axis(1, seq(-180, 180, by = 10))
    axis(2, seq(-90, 90, by = 10)) },
    key.title = title(main = "Coefficients",cex.main = 0.8))
  title(title_main, cex.main = 1.5,   font.main= 1, adj=0)  
}


## (Regression) PLOT P VALUES MAP
##              data_input = regression_pvalue_data
##              independent_variable_number = number in "user_independent_variables" 
##                                            of the variable to be plotted
##              subset_lon/lat_IDs = subset_lon/lat_IDs for dependent variable

plot_regression_pvalues = function(data_input,independent_variables,independent_variable_number,
                                   dependent_variable, regression_titles,
                                   subset_lon_IDs_d,subset_lat_IDs_d,c_borders){
  # Create x, y & z values
  x = lon[subset_lon_IDs_d]
  y = rev(lat[subset_lat_IDs_d])
  if (length(independent_variables)==1){ #  Deals with the 'variable' dimension disappearing
    z = data_input[,rev(1:length(y))]  
  } else {
    z = data_input[independent_variable_number,,rev(1:length(y))]
  }
  
  # Rewrite z values to fit into 5 equally spaced levels (levels = c(1:6))
  rewrite_pvalues = function(i){
    if (0<=i & i<0.01){
      i = 1
    } else if (0.01<=i & i<0.05){
      i = 2
    } else if (0.05<=i & i<0.1){
      i = 3
    } else if (0.1<=i & i<0.2){
      i = 4
    } else {
      i = 5
    }  
  }
  z_rewrite = apply(z,c(1,2),rewrite_pvalues)  
  
  # Generate color scheme and levels
  v_col = rev(brewer.pal(5,"Greens"))
  v_lev = c(0,0.01,0.05,0.1,0.2,1)
  
  # Generate title
  title_main = paste("Regression P Values. ",
                     regression_titles$title_months_i,
                     independent_variables[independent_variable_number]," ",
                     regression_titles$title_mode_i," -> ",
                     regression_titles$title_months_d,dependent_variable,
                     regression_titles$title_mode_d,". ",regression_titles$title_year_range,
                     sep = "")
  
  # Plot
  filled.contour(x,y,z_rewrite, col = v_col,levels = c(1:6), plot.axes={map("world",interior=c_borders,add=T)
    axis(1, seq(-180, 180, by = 10))
    axis(2, seq(-90, 90, by = 10)) },
    key.axes = axis(4,at=c(1:6),labels=v_lev),
    key.title = title(main = "p \nValues",cex.main = 1.2))
  title(title_main, cex.main = 1.5,   font.main= 1, adj=0)  
}


## (Regression) PLOT RESIDUALS MAP for a selected year
##              data_input = regression_residuals_data
##              year_selected = user-selected year to be plotted (any year within the year_range)
##              regression_titles = as created by generate_regression_titles

plot_regression_residuals = function(data_input,year_selected,year_range,
                                     independent_variables,dependent_variable,
                                     regression_titles,subset_lon_IDs_d,subset_lat_IDs_d,c_borders){
  
  # Find ID of year selected
  year_selected_ID = (year_selected-year_range[1])+1
  
  # Create x, y & z values
  x = lon[subset_lon_IDs_d]
  y = rev(lat[subset_lat_IDs_d])
  z = data_input[year_selected_ID,,rev(1:length(y))]
  
  # Generate color scheme
  if (dependent_variable == "Temperature"){
    v_col = colorRampPalette(rev(brewer.pal(11,"RdBu")))
  }
  else if (dependent_variable == "Precipitation"){
    v_col = colorRampPalette(brewer.pal(11,"BrBG"))
  }
  else if (dependent_variable == "SLP"|variable == "Z500"){
    v_col = colorRampPalette(rev(brewer.pal(11,"PRGn")))
  } 
  else {
    v_col = colorRampPalette(brewer.pal(11,"PiYG"))
  }
  
  # Generate title & axis label
  title_variables_i = paste(independent_variables,collapse = " ; ")
  title_main = paste("Regression Residuals. ",
                     regression_titles$title_months_i,title_variables_i," ",
                     regression_titles$title_mode_i,regression_titles$title_lonlat_i," -> ",
                     regression_titles$title_months_d,dependent_variable,
                     regression_titles$title_mode_d,". ",year_selected, sep = "")
  title_axis = paste("Residuals\n",regression_titles$unit_d)
  
  # Plot
  z_max = max(abs(z))
  
  filled.contour(x,y,z, zlim = c(-z_max,z_max), color.palette = v_col, plot.axes={map("world",interior=c_borders,add=T)
    axis(1, seq(-180, 180, by = 10))
    axis(2, seq(-90, 90, by = 10)) },
    key.title = title(main = title_axis,cex.main = 0.95))
  title(title_main, cex.main = 1.5,   font.main= 1, adj=0)
}


## (Regression) CREATE REGRESSION TIMESERIES DATATABLE including Original, Trend & Residual
##              dependent_variable_data = original Mod-Era create_timeseries_datatable
##                                        for the dependent variable
##              summary_data = create_regression_summary_data
##              residuals_data = as created by create_regression_residuals
##              regression_titles = as created by generate_regression_titles

create_regression_timeseries_datatable = function(dependent_variable_data,summary_data,
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

plot_regression_timeseries = function(data_input,plot_type,regression_titles,
                                      independent_variables,dependent_variable){
  
  # Generate title & axis label
  title_variables_i = paste(independent_variables,collapse = " ; ")
  title_main = paste("Regression Timeseries. ",
                     regression_titles$title_months_i,title_variables_i,
                     regression_titles$title_mode_i,regression_titles$title_lonlat_i," -> ",
                     regression_titles$title_months_d,dependent_variable,
                     regression_titles$title_mode_d,regression_titles$title_lonlat_d,
                     sep = "")
  title_axis = paste(dependent_variable,regression_titles$unit_d)
  
  # Plot original_trend timeseries
  if (plot_type == "original_trend"){
    plot(data_input[,1],data_input[,2],col = regression_titles$color_d, type = "l", xaxs="i",
         xlab = "Year", ylab = title_axis,lwd = 1.5)
    lines(data_input[,1],data_input[,3],lwd = 1.5)
    title(title_main, cex.main = 1.5,   font.main= 1, adj=0)
    legend('bottomright',legend=c("Original", "Trend"),
           col=c(regression_titles$color_d,"black"),lty = c(1,1),lwd=c(1.5,1.5))
  } 
  # Plot residuals timeseries
  else {
    plot(data_input[,1],data_input[,4],col = regression_titles$color_d, type = "l", xaxs="i",
         xlab = "Year", ylab = title_axis, lty = 2, lwd = 1.5)
    title(title_main, cex.main = 1.5,   font.main= 1, adj=0)
    legend('bottomright',legend=c("Residual"),
           col=c(regression_titles$color_d),lty = c(2),lwd=c(1.5))
  }
}


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

create_monthly_TS_data = function(data_input,dataset,variable,years,lon_range,lat_range, mode, type, baseline_range){
  
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


## (Annual cycles) PLOT ANNUAL CYCLES DATA - plots annual cycles data or Adds lines to graph
##              data_input = annual cycles data dataframe
##              title_mode = "Default" or "Custom"
##              plot_mode = "base" or "lines" - base plots the default plot, lines just adds lines to existing graph

plot_monthly_timeseries = function(data_input,custom_title,title_mode,key_position,plot_mode){
  
  n_o_rows = length(data_input[,1])
  
  # Generate colors
  if (n_o_rows<3){
    color_set = brewer.pal(3,"Dark2")
  }
  else if (n_o_rows<13){
    color_set = brewer.pal(n_o_rows,"Dark2")
  } else {
    color_set = colorRampPalette(brewer.pal(12,"Dark2"))(n_o_rows)
  }
  
  # Generate line widths
  lwd_set = c()
  
  for (i in 1:n_o_rows){
    if (data_input$Type[i] == "Average"){
      lwd = 3.5
    } else {
      lwd = 2
    }
    lwd_set = c(lwd_set,lwd)
  }  
  if (plot_mode == "base"){ # plot default plot
    # Generate y axis label
    y_label = paste0(data_input$Variable[1]," [",data_input$Unit[1],"]")
    
    # Generate legend labels
    legend_labels = c()
    
    for (i in 1:n_o_rows){
      label = paste0(data_input$Dataset[i]," ",data_input$Years[i]," [",data_input$Coordinates[i],"]")
      legend_labels = c(legend_labels,label)
    }
    
    # Find min/max values
    y_min = min(data_input[,5:16])  
    y_max = max(data_input[,5:16])
    y_space = 0.02*(y_max-y_min)
    
    # Plot
    plot(1:12,data_input[1,5:16],type = "l",col=color_set[1], lwd=lwd_set[1],
         ylim = c((y_min-y_space),(y_max+y_space)),
         xlab = "Month", ylab = y_label, xaxt = "n", xaxs="i")
    axis(1, at = 1:12, labels = c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))
    
    for (i in 2:n_o_rows){
      lines(1:12,data_input[i,5:16],col = color_set[i],lwd = lwd_set[i])
    }
    
    # Add title (if custom is selected)
    if (title_mode == "Custom"){
      title(custom_title,adj = 0)
    }
    
    # Add legend
    legend(key_position, inset = c(0.008,0.03),
           legend=legend_labels,
           # Line options
           col = color_set,
           lwd = lwd_set,
           # Draw box round key
           bg = "grey90",
           box.lty = 0
    ) 
  } 
  else { # Just add lines to plot
    lines(1:12,data_input[1,5:16],type = "l",col=color_set[1], lwd=lwd_set[1])
  }
  
} 

