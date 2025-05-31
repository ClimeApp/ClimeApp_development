#### Setup script for ClimeApp ####
# Sets up user environment and loads required libraries as well as preprocessed data


#### User Preparation ----

Sys.info()[["user"]]

## Working Directory
# Define a function to set up user configurations
setup_user_environment <- function() {
  
  # Define user-specific settings
  user_configs <- list(
    
    # Nik
    nbartlome = list(
      setwd = "C:/Users/nbartlome/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp",
      lib_path = "C:/Users/nbartlome/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp/library"
    ),
    
    nikla = list(
      setwd = "C:/Users/nikla/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp",
      lib_path = "C:/Users/nikla/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp/library"
    ),
    
    Niklaus_Emanuel = list(
      setwd = "C:/Users/Niklaus Emanuel/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp",
      lib_path = "C:/Users/Niklaus Emanuel/OneDrive/1_Universit\u00E4t/4_PhD/10_R with R/Shiny R/ClimeApp_all/ClimeApp/library"
    ),
    
    # Richard
    Richard = list(
      setwd = "C:/Users/Richard/OneDrive/ClimeApp_all/ClimeApp",
      lib_path = "library"
    ),
    rw22z389 = list(
      setwd = "C:/Users/rw22z389/OneDrive/ClimeApp_all/ClimeApp",
      lib_path = "C:/Users/rw22z389/OneDrive/ClimeApp_all/ClimeApp/library"
    ),
    
    # Noémie
    noemi = list(
      setwd = "C:/Users/noemi/OneDrive/ClimeApp_all-noemie-hp/ClimeApp/",
      lib_path = "C:/Users/noemi/OneDrive/ClimeApp_all/ClimeApp/library"
    ),
    nw22d367 = list(
      setwd = "C:/Users/nw22d367/OneDrive/ClimeApp_all/ClimeApp/",
      lib_path = "C:/Users/nw22d367/OneDrive/ClimeApp_all/ClimeApp/library"
    ),
    
    # Tanja
    falasca = list(
      setwd = "C:/Users/falasca/OneDrive/ClimeApp_all/ClimeApp/",
      lib_path = "C:/Users/falasca/OneDrive/ClimeApp_all/ClimeApp/library"
    ),
    tanja = list(
      setwd = "C:/Users/tanja/OneDrive/ClimeApp_all 1/ClimeApp/",
      lib_path = "C:/Users/tanja/OneDrive/ClimeApp_all/ClimeApp/library"
    )
  )
  # Get the current username
  current_user <- Sys.info()[["user"]]
  if (!is.null(user_configs[[current_user]])) {
    user_config <- user_configs[[current_user]]
    setwd(user_config$setwd)
    .libPaths(user_config$lib_path)
    message("Working directory and library path set for user: ", current_user)
  } else {
    stop("User configuration not found. Please check the user setup.")
  }
}
setup_user_environment()

#### Packages ----

# Load only REQUIRED functions/libraries:
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
library(shinylive)
library(ggplot2)
library(sf)
library(shinylogs)
library(shinycssloaders)
library(profvis)
library(openxlsx) #Don't Change order!
library(xlsx)
library(leaflet)
library(htmltools)
library(mapdata)
library(dplyr)
library(plotly)  # Load plotly library for interactivity
library(terra)
library(tidyterra)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggpattern)
library(viridis)
library(markdown)
library(ncdf4,include.only = c("nc_close", "nc_create", "nc_open", "ncatt_put", "ncdim_def","ncvar_def", "ncvar_get", "ncvar_put"))
library(shinyWidgets,include.only = c("numericRangeInput", "pickerInput", "sliderTextInput", "updateNumericRangeInput", 
                                      "updatePickerInput", "updateSliderTextInput"))
library(RColorBrewer,include.only = "brewer.pal")
library(shinyjs,include.only =  c("colourInput", "removeClass", "show", "addClass", "delay", 
                                  "hidden", "hide", "runjs", "toggle", "useShinyjs"))
library(bslib,include.only = c("bs_theme", "popover"))
library(readxl,include.only = c("read_excel", "cell_cols") )
library(DT,include.only = c("dataTableOutput", "renderDataTable"))
library(zoo,include.only = "rollmean", "na.approx" )
library(colourpicker,include.only = "colourInput" )
library(tmaptools,include.only = "geocode_OSM" )
library(ggplot2,include.only = c("map_data", "aes", "after_stat", "aes_string", "annotate", 
                                 "coord_sf", "element_rect", "element_text", "geom_hline", "geom_line", 
                                 "geom_point", "geom_polygon", "geom_rect", "geom_sf", "geom_text", 
                                 "geom_vline", "ggplot", "ggtitle", "guide_colorbar", "guide_legend", 
                                 "guides", "labs", "position_nudge", "scale_color_manual", "scale_colour_manual", 
                                 "scale_fill_stepsn", "scale_linetype_manual", "scale_shape_manual", "scale_x_continuous", 
                                 "scale_y_continuous", "theme", "theme_bw", "theme_classic", "theme_minimal", 
                                 "unit") )
library(sf,include.only = c("st_as_sf", "st_set_crs", "st_crs", "st_geometry_type", "st_read", 
                            "st_transform") )
library(shinycssloaders,include.only = "withSpinner" )
library(openxlsx,include.only =  c("createWorkbook", "read.xlsx", "saveWorkbook", "write.xlsx", 
                                   "addWorksheet", "getSheetNames", "writeData")) #Don't Change order!
library(xlsx,include.only = c("createWorkbook", "read.xlsx", "saveWorkbook", "write.xlsx"))

library(leaflet,include.only =  c("colorFactor","leafletOutput","renderLeaflet","leafletProxy","addCircleMarkers",
                                  "addControl","addLayersControl","addLegend","addProviderTiles","addTiles","clearControls",
                                  "clearMarkers","layersControlOptions","leaflet","setView","providers"))
library(htmltools,include.only = c("a", "br", "div", "em", "h1", "h4", "h5", "h6", "hr", "HTML", 
                                   "img", "includeCSS", "span", "strong", "tagList", "h3"))
library(dplyr,include.only =c("select", "intersect", "arrange", "distinct", "filter", "add_row", 
                              "all_of", "case_when","%>%"))
library(plotly,include.only = c("select", "plotlyOutput", "renderPlotly", "style", "arrange", 
                                "distinct", "filter", "ggplotly") )  # Load plotly library for interactivity
library(terra) #, include.only = "rast", "writeRaster", "ext", "crs") 
library(tidyterra,include.only = c("select", "aes", "after_stat", "arrange", "distinct", "filter", 
                                   "geom_spatraster_contour_filled")  )
# library(rnaturalearth) # for water bodies
# library(rnaturalearthdata) # for water bodies
library(viridis,include.only = "viridis" )

# SEA Loading
library(dplR)
library(burnr)

#### Design ----

# Source for images
addResourcePath(prefix = 'pics', directoryPath = "www")

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
spinner_image = "pics/ClimeApp_Loading_V3.gif"
spinner_width = 310
spinner_height = 200

#### Preprocseeing ----

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

## Create dataframe of centuries and set initial year values
C15 = c(1422,1500)
C16 = c(1500,1600)
C17 = c(1600,1700)
C18 = c(1700,1800)
C19 = c(1800,1900)
C20 = c(1900,2000)

century_years = data.frame(C15,C16,C17,C18,C19,C20)
row.names(century_years) = c("year_min","year_max")

random_century = sample(1:6,1)

initial_year_values = century_years[,random_century]

## Load grid square weights for calculating means
latlon_weights = as.matrix(read.csv("data/latlon_weights.csv"))

# Load shapefiles for maps (rnaturalearth)
coast <- st_read("data/geodata_maps/coast.shp")
countries <- st_read("data/geodata_maps/countries.shp")
oceans <- st_read("data/geodata_maps/oceans.shp")
land <- st_read("data/geodata_maps/land.shp")

