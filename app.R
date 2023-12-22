### ClimeApp_beta ###

# Source for helpers ----
source("helpers.R")


# Define UI ----

ui <- navbarPage(id = "nav1",
          ## Configs for navbarPage: theme, images (Header and Footer) ----
          title = div(style = "display: inline;",
                      img(src = 'pics/Logo_ClimeApp_V2_210623.png', id = "ClimeApp", height = "75px", width = "75px", style = "margin-right: -10px"),
                      img(src = 'pics/Font_ClimeApp_Vers3_weiss.png', id = "ClimeApp2", height = "75px", width = "225px", style = "align-left: -10px"), "(Beta v0.4)",
                      ),
          footer = div(class = "navbar-footer",
                       style = "display: inline;",
                       img(src = 'pics/oeschger_logo_rgb.jpg', id = "ClimeApp3", height = "100px", width = "100px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/LOGO_ERC-FLAG_EU_.jpg', id = "ClimeApp4", height = "100px", width = "141px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/WBF_SBFI_EU_Frameworkprogramme_E_RGB_pos_quer.jpg', id = "ClimeApp5", height = "100px", width = "349px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/SNF_Logo_Logo.png', id = "ClimeApp6", height = "75px", width = "560px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       tags$style(HTML(".navbar-footer {margin-top: 20px; margin-bottom: 20px;}")),
                       # Navbar properties
                       tags$style(HTML(".navbar { height: 75px !important; }")),
                       tags$style(type="text/css", "body {padding-top: 90px;}"),
                       # Window dimensions
                       tags$head(tags$script('
                          var dimension = [0, 0];
                          $(document).on("shiny:connected", function(e) {
                              dimension[0] = window.innerWidth;
                              dimension[1] = window.innerHeight;
                              Shiny.onInputChange("dimension", dimension);
                          });
                          $(window).resize(function(e) {
                              dimension[0] = window.innerWidth;
                              dimension[1] = window.innerHeight;
                              Shiny.onInputChange("dimension", dimension);
                          });
                      ')),
                       # No Red Error messages
                       tags$style(type="text/css",
                                  ".shiny-output-error { visibility: hidden; }",
                                  ".shiny-output-error:before { visibility: hidden; }"
                       ),
                       #Highlighted Buttons
                       tags$style(HTML("
                          .green-background {
                            color: #d9b166;
                            background-color: #094030 !important;
                          }
                          
                          .green-background:hover {
                            color: #d9b166 !important;
                          }
                          
                          .green-background:focus {
                            background-color: #094030 !important;
                            color: #d9b166 !important;
                          }
                          ")),
                       ),
          theme = my_theme,
          position = c("fixed-top"),

# Welcome START ----                             
      tabPanel("Welcome", id = "tab0",
        shinyjs::useShinyjs(),
        includeCSS("www/custom.css"),
        use_tracking(),
        sidebarLayout(
                         
          ## Sidebar Panels START ----          
          sidebarPanel(verticalLayout(
            ### First Side bar ----
            sidebarPanel(fluidRow(
                         
            #Short description of the General Panel        
            h1("Welcome to ClimeApp", style = "color: #094030;"),
            br(),
            h4(em(helpText("Created by Niklaus Bartlome & Richard Warren."))),
            h4(em(helpText("Co-developped by No\u00E9mie Wellinger."))),
            br(),
            h4("Data processing tool for the state-of-the-art ModE-RA Global Climate Reanalysis", style = "color: #094030;"),
            h5(helpText("Franke, J., Veronika, V., Hand, R., Samakinwa, E., Burgdorf, A.M., Lundstad, E., Brugnara, Y., H\u00F6vel, L. and Br\u00F6nnimann, 2023")),
            
            
            column(width = 12,
            fluidRow(
              column(width = 6, h5(strong("Date range:", style = "color: #094030;"))),
              column(width = 6, h5(helpText("1422 to 2008 AD"))),
              column(width = 6, h5(strong("Geographic range:", style = "color: #094030;"))),
              column(width = 6, h5(helpText("Global"))),
              column(width = 6, h5(strong("Resolution:", style = "color: #094030;"))),
              column(width = 6, h5(helpText("Longitude = 1.875\u00B0")),
              h5(helpText("Latitude = 1.865\u00B0")))
            )),
            column(width = 12,
            
              h5(strong("Variables:", style = "color: #094030;")),
              h5(helpText("Temperature = Air temperature at 2m [\u00B0C]")),
              h5(helpText("Precipitation = Total monthly precipitation [mm]")),
              h5(helpText("SLP = Sea level pressure [hPa]")),
              h5(helpText("Z500 = Pressure at 500 hPa geopotential height [hPa]"))
            ),
            column(width = 12, br(), br()),
            
          ), width = 12),
          
          br(),
          
            ### Second side bar ----
            
            sidebarPanel(fluidRow(
              h4(helpText("For feedback and suggestions on ClimeApp, please contact:")), br(),
              h4("Mail to the ClimeApp team:", a("climeapp.hist@unibe.ch", href = "mailto:climeapp.hist@unibe.ch"), style = "color: #094030;"),
              column(width = 12, br()),
              h4(helpText("For queries relating to the ModE-RA data, please contact:")),
              h4("Mail to J\u00F6rg Franke:", a("franke@giub.unibe.ch", href = "mailto:franke@giub.unibe.ch"), style = "color: #094030;")
              
            ), width = 12)
          ## Sidebar Panels END ---- 
          )),
          ## Main panel START ----
          mainPanel(
            ### Tabs Start ----
            tabsetPanel(
            #### Tab Welcome ----
            tabPanel("Welcome",
                     tags$head(tags$style(HTML(".responsive-img {
                                                max-width: 100%;
                                                height: auto;
                                              }
                                            "))),
            tags$img(src = 'pics/welcome_map.jpg', id = "welcome_map", class = "responsive-img"),
            h4(helpText("For more information on ModE-RA please see:")),
            h4(helpText(a("ModE-RAclim - A version of the ModE-RA reanalysis with climatological prior for sensitivity studies", href = "https://www.wdc-climate.de/ui/entry?acronym=ModE-RAc"), ", [Place Holder for link to: ModE-RA paper & ClimeApp technical paper (in progress)]")),
            h4(helpText("To cite, please reference:")),
            h4(helpText("[Place Holder: ClimeApp technical paper (in progress)]")),
            h4(helpText("V. Valler, J. Franke, Y. Brugnara, E. Samakinwa, R. Hand, E. Lundstad, A.-M. Burgdorf, L. Lipfert, A. R. Friedman, S. Br\u00F6nnimann (in review): ModE-RA - a global monthly paleo-reanalysis of the modern era (1421-2008). Scientific Data.")),
            h6(helpText("PALAEO-RA: H2020/ERC grant number 787574")),
            h6(helpText("DEBTS: SNFS grant number PZ00P1_201953")),
            h6(helpText("VolCOPE: SERI contract number MB22.00030")),
            ),
            #### Tab Usage Notes ----
            tabPanel("Usage notes",
                     br(), br(), 
                     helpText("The ModE-RA paleo-reanalysis is identical to the ModE-Sim simulations in areas far away from any assimilated observations, especially at the beginning of the reconstruction period. With time more and more observations are available, suggesting that the reconstruction becomes more skillful. Therefore, the users first should ensure how reliable the paleo-reanalysis is for a given region and time period. This can be achieved by looking at the ensemble spread and the differences between ModE-Sim and ModE-RA. Among the reconstructed variables, the ones with observational input data are the most realistically estimated. We encourage the users to make use of the ensemble members and not only the ensemble mean."),
                     br(), br(), 
                     helpText("ModE-Sim was generated in two phases (1420-1850 and 1850-2008) with different boundary conditions. In the earlier period ModE-RA is based on ModE-Sim Set 1420-3 and in the later period on ModE-Sim Set 1850-1. ModE-RA is not split into the two periods of the ModE-Sim prior, because the assimilated observational time series lead to a smooth transition between the two periods of the ModE-Sim sets."), 
                     br(), br(), 
                     helpText("ModE-RA was generated by transforming both model simulations and observations to 71-year running anomalies. Hence, users should be aware that the centennial-scale variability is the model response to forcings. Therefore, we see the high potential of the dataset in revealing something new about intra-annual to multi-decadal variability of the climate system. We provide monthly anomalies with respect to the 1901 to 2008 climatology and the model climatology for the 1901 to 2008 period. Be aware that the model climatology includes model biases. Therefore, we recommend using anomalies instead of the absolute values."),
                     br(), br(), 
                     helpText("Furthermore, because of the employed setup, unrealistic values (such as negative precipitation) can occur if absolute values are generated by adding back a climatology. This is especially an issue in arid regions where monthly precipitation is not normally distributed. Precipitation is consistent in the periods of 1421-1800 and 1900-2008, when the observational network is quite stable, but in the 19th century, which is the start of many observations, a negative trend is introduced (Fig.~S1). Hence, in the case of the reconstructed precipitation fields the early and late period should be looked at separately."),
                     br(), br(), 
                     helpText("ModE-RAclim should be seen as a sensitivity study and is only a side product of the project. ModE-RAclim does not contain centennial scale climate variability. For most users, the main product ModE-RA therefore should be used for regular studies on past climate. The main differences between ModE-RAclim and ModE-RA are on the model side: ModE-RAclim uses 100 randomly-picked years from ModE-Sim as a priori state. Thereby stationarity in the covariance structure is assumed and the externally-forced signal in the model simulations is eliminated. In combination with ModE-Sim and ModE-RA it can be used to distinguish the forced and unforced parts of climate variability seen in ModE-RA."),
                     br(), br(),
                     helpText("ModE-RA makes use of several data compilations and assimilates various direct and indirect sources of past climate compared to 20CRv3. Hence, if monthly resolution is sufficient for the planned study, ModE-RA may have higher quality already from 1850 backwards to analyze past climate changes and can be viewed as the backward extension of 20CRv3."),
            ),
            #### Tab Version History ----
            tabPanel("Version history",
                     br(), br(), 
                     h4(helpText("Beta v0.5 (22.12.2023)")),
                     h6(helpText("- Download NetCDF files")),
                     h6(helpText("- Version History")),
                     br(), br(), 
                     h4(helpText("Beta v0.4")),
                     h6(helpText("- Select single years")),
                     br(), br(), 
                     h4(helpText("Beta v0.3")),
                     h6(helpText("- Time series customization")),
                     h6(helpText("- Percentiles, maps & statistics based on model constraint change")),
                     h6(helpText("- Reference line option in timeseries")),
                     br(), br(), 
                     h4(helpText("Beta v0.2 (10.11.2023)")),
                     h6(helpText("- Use ModE-Sim and ModE-RAclim data")),
                     h6(helpText("- Create monthly time series")),
                     h6(helpText("- View ModE-RA sources")),
                     h6(helpText("- Download ModE-RA sources maps as image")),
                     h6(helpText("- Upload User data for correlation and regression")),
                     h6(helpText("- Reference maps with absolute values, reference period, and SD ratio for Anomalies and Composites")),
                     br(), br(), 
                     h4(helpText("Beta")),
                     h6(helpText("- First running version online")),
                     h6(helpText("- Use ModE-RA data with four variables:  Temperature, Precipitation, Sea level pressure, Pressure at 500 hPa geopotential height")),
                     h6(helpText("- Calculate Anomalies, Composites, Correlations and Regressions (coefficien, p values residuals) as maps and timeseries")),
                     h6(helpText("- Customize maps and timeseries (title, labelling, add custom points and highlights, statistics)")),
                     h6(helpText("- Download maps and timeseries plots as images")),
                     h6(helpText("- Download map and timeseries data in xlsx or csv format"))
            ),

            ### Tabs END ----
            )            
          ## Main Panel END ----
          )
# Welcome END ----  
       )),
# Average & anomaly START ----                             
      tabPanel("Anomalies", id = "tab1",
                shinyjs::useShinyjs(),
                sidebarLayout(
      
                ## Sidebar Panels START ----          
                sidebarPanel(verticalLayout(
                
                    ### First Sidebar panel (Variable and time selection) ----
                    sidebarPanel(fluidRow(
          
                    #Short description of the General Panel        
                    h4(helpText("Plot average anomalies for a selected time period")),
                    
                    #Choose one of three datasets (Select)                
                    selectInput(inputId  = "dataset_selected",
                                label    = "Choose a dataset:",
                                choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                                selected = "ModE-RA"),
                    
                    #Choose one of four variable (Select)                
                    selectInput(inputId  = "variable_selected",
                                label    = "Choose a variable to plot:",
                                choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                                selected = "Temperature"),
            
                    #Choose your year of interest        
                    hidden(
                    numericRangeInput(inputId    = "range_years",
                                       label     = "Select the range of years (1422-2008):",
                                       value     = c(1422,2008),
                                       separator = " to ",
                                       min       = 1422,
                                       max       = 2008)),
                    
                    #Choose single year
                    column(12,
                    checkboxInput(inputId = "single_year",
                                  label   = "Select single year",
                                  value   = FALSE)),
                    
                    
                    hidden(
                    numericInput(inputId   = "range_years_sg",
                                 label     = "Select the single year:",
                                 value     = NA,
                                 min       = 1422,
                                 max       = 2008)),
            
                    #Choose Season, Year or Months
                    radioButtons(inputId  = "season_selected",
                                label    = "Select the range of months:",
                                choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                selected = "Annual" , inline = TRUE),
    
                    #Choose your range of months (Slider)
                    shinyjs::hidden(
                    div(id = "season",
                                    sliderTextInput(inputId = "range_months",
                                              label = "Select custom months:",
                                              choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                              #Initially selected = 1 year (annual mean)
                                              selected = c("January", "December")),
                    )),      
                            
                    #Choose reference period
                    hidden(
                    numericRangeInput(inputId = "ref_period",
                                      label      = "Select the reference period:",
                                      value      = c(1961,1990),
                                      separator  = " to ",
                                      min        = 1422,
                                       max        = 2008)),
                    
                    #Choose single ref year
                    column(12,
                           checkboxInput(inputId = "ref_single_year",
                                         label   = "Select single year",
                                         value   = FALSE)),
                    
                    
                    hidden(
                      numericInput(inputId   = "ref_period_sg",
                                   label     = "Select the single year:",
                                   value     = NA,
                                   min       = 1422,
                                   max       = 2008)),
    
                    ), width = 12), br(),
            
                    ### Second sidebar panel (Location selection) ----
                    sidebarPanel(fluidRow(
              
                    #Short description of the Coord. Sidebar        
                    h4(helpText("Set geographical area")),
                    h5(helpText("Select a continent, enter coordinates manually or draw a box on the plot")),
                    
                     column(width = 12, fluidRow(      
                     #Global Button
                     actionButton(inputId = "button_global",
                                  label = "Global",
                                  width = "100px"),
                     
                     br(), br(),

                     #Europe Button
                     actionButton(inputId = "button_europe",
                                  label = "Europe",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #Asia Button
                     actionButton(inputId = "button_asia",
                                  label = "Asia",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #Oceania Button
                     actionButton(inputId = "button_oceania",
                                  label = "Oceania",
                                  width = "110px"),
                     
                     )),
                    
                     column(width = 12, br()),
                     
                     column(width = 12, fluidRow(
                     
                     #Africa Button
                     actionButton(inputId = "button_africa",
                                  label = "Africa",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #North America Button
                     actionButton(inputId = "button_n_america",
                                  label = "North America",
                                  width = "150px"),
                     
                     br(), br(),
                     
                     #South America Button
                     actionButton(inputId = "button_s_america",
                                  label = "South America",
                                  width = "150px")
                     )),
                    
                    column(width = 12, br()),
                      
                    #Choose Longitude and Latitude Range          
                    numericRangeInput(inputId = "range_longitude",
                                      label = "Longitude range (-180 to 180):",
                                      value = initial_lon_values,
                                      separator = " to ",
                                      min = -180,
                                      max = 180),
                        
                        
                    #Choose Longitude and Latitude Range          
                    numericRangeInput(inputId = "range_latitude",
                                      label = "Latitude range (-90 to 90):",
                                      value = initial_lat_values,
                                      separator = " to ",
                                      min = -90,
                                      max = 90),
                    
                    br(), br(),
                        
                    #Enter Coordinates
                        actionButton(inputId = "button_coord",
                                     label = "Update coordinates",
                                     width = "200px"),
                        
                        ), width = 12)
                    
                ## Sidebar Panels END ----
                )),

                ## Main Panel START ----
                mainPanel(tabsetPanel(
                
                    ### Map plot START ----   
                    tabPanel("Map", plotOutput("map", height = "auto", dblclick = "map_dblclick1", brush = brushOpts(id = "map_brush1",resetOnNew = TRUE)),
                      
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,
                             h4(helpText("Customize your map")),  
                            
                             checkboxInput(inputId = "custom_map",
                                           label   = "Map customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                                         div(id = "hidden_custom_maps",
          
                             radioButtons(inputId  = "axis_mode",
                                          label    = "Axis customization:",
                                          choices  = c("Default", "Custom"),
                                          selected = "Default" , inline = TRUE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_axis",
                             
                             numericRangeInput(inputId    = "axis_input",
                                               label      = "Set your axis values:",
                                               value      = c(NULL, NULL),
                                               separator  = " to ",
                                               min        = -Inf,
                                               max        = Inf))),
                             
                             checkboxInput(inputId = "hide_axis",
                                           label   = "Hide axis completely",
                                           value   = FALSE),
                             
                             br(),
                             
                             radioButtons(inputId  = "title_mode",
                                          label    = "Title customization:",
                                          choices  = c("Default", "Custom"),
                                          selected = "Default" , inline = TRUE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_title",
                             
                             textInput(inputId     = "title1_input",
                                       label       = "Custom map title:", 
                                       value       = NA,
                                       width       = NULL,
                                       placeholder = "Custom title"),
                             
                             textInput(inputId     = "title2_input",
                                       label       = "Custom map subtitle (e.g. Ref-Period)",
                                       value       = NA,
                                       width       = NULL,
                                       placeholder = "Custom title")))
                             )),
                         ),
                      
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,
                             h4(helpText("Custom features")),
                             
                             checkboxInput(inputId = "custom_features",
                                           label   = "Enable custom features",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_features",
                                   radioButtons(inputId      = "feature",
                                                label        = "Select a feature type:",
                                                inline       = TRUE,
                                                choices      = c("Point", "Highlight")),
                               
                               #Custom Points
                               div(id = "hidden_custom_points",
                                   h5(helpText("Add custom points")),
                                   h6(helpText("Enter location/coordinates or double click on map")),
                                   
                                   textInput(inputId = "location", 
                                             label   = "Enter a location:",
                                             value   = NULL,
                                             placeholder = "e.g. Bern"),
                                   
                                   
                                   
                                   actionButton(inputId = "search",
                                                label   = "Search"),
                                   
                                   
                                   shinyjs::hidden(div(id = "inv_location",
                                                       h6(helpText("Invalid location"))
                                   )),
                                   
                                   textInput(inputId = "point_label", 
                                             label   = "Point label:",
                                             value   = ""),
                                     
                                   column(width = 12, offset = 0,
                                          column(width = 6,
                                                 textInput(inputId = "point_location_x", 
                                                           label   = "Point longitude:",
                                                           value   = "")
                                          ),
                                          column(width = 6,
                                                 textInput(inputId = "point_location_y", 
                                                           label   = "Point latitude:",
                                                           value   = "")
                                          )),
              
                                   
                                   radioButtons(inputId      = "point_shape",
                                                label        = "Point shape:",
                                                inline       = TRUE,
                                                choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                   
                                   colourInput(inputId = "point_colour", 
                                               label   = "Point colour:",
                                               showColour = "background",
                                               palette = "limited"),                          
                                   
                                   
                                   numericInput(inputId = "point_size",
                                                label   = "Point size:",
                                                value   = 1,
                                                min     = 1,
                                                max     = 10),
                                   
                                   column(width = 12,
                                          
                                          actionButton(inputId = "add_point",
                                                       label = "Add point"),
                                          br(), br(), br(),
                                          actionButton(inputId = "remove_last_point",
                                                       label = "Remove last point"),
                                          actionButton(inputId = "remove_all_points",
                                                       label = "Remove all points")),
                               ),
                               
                               #Custom Highlights
                               div(id = "hidden_custom_highlights",
                                   h5(helpText("Add custom highlights")),
                                   h6(helpText("Enter coordinate or draw a box on map")),
                                   
                                   numericRangeInput(inputId = "highlight_x_values",
                                                     label  = "Longitude:",
                                                     value  = "",
                                                     min    = -180,
                                                     max    = 180),
                                   
                                   numericRangeInput(inputId = "highlight_y_values",
                                                      label  = "Latitude:",
                                                      value  = "",
                                                      min    = -90,
                                                      max    = 90),
                                   
                                   colourInput(inputId = "highlight_colour", 
                                               label   = "Highlight colour:",
                                               showColour = "background",
                                               palette = "limited"),
                                   
                                   radioButtons(inputId      = "highlight_type",
                                                label        = "Type for highlight:",
                                                inline       = TRUE,
                                                choiceNames  = c("Box \u25FB", "Hatched \u25A8"),
                                                choiceValues = c("Box","Hatched")),
                                   
              
                                   column(width = 12,
                                          actionButton(inputId = "add_highlight",
                                                       label = "Add highlight"),
                                          br(), br(), br(),
                                          actionButton(inputId = "remove_last_highlight",
                                                       label = "Remove last highlight"),
                                          actionButton(inputId = "remove_all_highlights",
                                                       label = "Remove all highlights")),
                                  
                               ))
                      )),
                      
                      #### Custom statistics ----
                      column(width = 4,
                             h4(helpText("Custom statistics")),
                             
                             checkboxInput(inputId = "enable_custom_statistics",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             
                               div(id = "hidden_custom_statistics",
                                   h5(helpText("Choose custom statistic:")),
                                   
                                   radioButtons(inputId      = "custom_statistic",
                                                label        = NULL,
                                                inline       = TRUE,
                                                choices      = c("SD ratio", "% sign match")),
                             
                                   div(id = "hidden_sign_match",  
                                       numericInput(inputId = "percentage_sign_match",
                                                  label  = "% of years in range with matching sign:",
                                                  value  = 90,
                                                  min    = 1,
                                                  max    = 100)
                                   ),
                                   
                                   div(id = "hidden_SD_ratio",  
                                       numericInput(inputId = "sd_ratio",
                                                    label  = "SD ratio < ",
                                                    value  = 0.2,
                                                    min    = 0,
                                                    max    = 1)
                                   ),
                              ),
                      ),
                    
                      #### Customization panels END ----
                      ),
                      #### Abs/Ref Map plot START ----
                      h4(helpText("Reference map")), 
                      
                      radioButtons(inputId  = "ref_map_mode",
                                   label    = NULL,
                                   choices  = c("None", "Absolute Values","Reference Period","SD Ratio"),
                                   selected = "None" , inline = TRUE),
                      
                      plotOutput("ref_map", height = "auto")

                    ### Map plot END ----
                    ),
            
          
                    ### TS plot START ----
                    tabPanel("Time series", plotOutput("timeseries", click = "ts_click1",dblclick = "ts_dblclick1",brush = brushOpts(id = "ts_brush1",resetOnNew = TRUE)),
                      #### Customization panels START ----       
                      fluidRow(
                      #### Time series customization ----
                      column(width = 4,
                             h4(helpText("Customize your time series")),  
                              
                             checkboxInput(inputId = "custom_ts",
                                            label   = "Time series customization",
                                            value   = FALSE),
                              
                             shinyjs::hidden( 
                             div(id = "hidden_custom_ts",
                                 radioButtons(inputId  = "title_mode_ts",
                                              label    = "Title customization:",
                                              choices  = c("Default", "Custom"),
                                              selected = "Default" ,
                                              inline = TRUE),
                                  
                                 shinyjs::hidden( 
                                 div(id = "hidden_custom_title_ts",
                                      
                                     textInput(inputId     = "title1_input_ts",
                                               label       = "Custom map title:", 
                                               value       = NA,
                                               width       = NULL,
                                               placeholder = "Custom title")
                                 )),
                                  
                                 checkboxInput(inputId = "show_key_ts",
                                               label   = "Show key",
                                               value   = FALSE),
                                 
                                 shinyjs::hidden(
                                 div(id = "hidden_key_position_ts",
                                 radioButtons(inputId  = "key_position_ts",
                                              label    = "Key position:",
                                              choiceNames  = c("top left", "top right","bottom left","bottom right"),
                                              choiceValues = c("topleft", "topright","bottomleft","bottomright"),
                                              selected = "topright" ,
                                              inline = TRUE))),
                                 
                                 checkboxInput(inputId = "show_ref_ts",
                                               label   = "Show reference",
                                               value   = FALSE),
                              )),    
                       ),

                      #### Add Custom features (points, highlights, lines) ----                        
                      column(width = 4,
                            h4(helpText("Custom features")),
                            
                            checkboxInput(inputId = "custom_features_ts",
                                          label   = "Enable custom features",
                                          value   = FALSE),
                            
                            shinyjs::hidden(
                            div(id = "hidden_custom_features_ts",
                                radioButtons(inputId      = "feature_ts",
                                             label        = "Select a feature type:",
                                             inline       = TRUE,
                                             choices      = c("Point", "Highlight", "Line")),
                                
                                #Custom Points
                                shinyjs::hidden(
                                div(id = "hidden_custom_points_ts",
                                    h5(helpText("Add custom points")),
                                    h6(helpText("Enter position manually or click on plot")),
                                    
                                    textInput(inputId = "point_label_ts", 
                                              label   = "Point label:",
                                              value   = ""),
                                    
                                    column(width = 12, offset = 0,
                                           column(width = 6,
                                                  textInput(inputId = "point_location_x_ts", 
                                                            label   = "Point x position:",
                                                            value   = "")
                                           ),
                                           column(width = 6,
                                                  textInput(inputId = "point_location_y_ts", 
                                                            label   = "Point y position:",
                                                            value   = "")
                                           )),
                                    
                                    
                                    radioButtons(inputId      = "point_shape_ts",
                                                 label        = "Point shape:",
                                                 inline       = TRUE,
                                                 choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                    
                                    colourInput(inputId = "point_colour_ts", 
                                                label   = "Point colour:",
                                                showColour = "background",
                                                palette = "limited"),                        
                                    
                                    
                                    numericInput(inputId = "point_size_ts",
                                                 label   = "Point size",
                                                 value   = 1,
                                                 min     = 1,
                                                 max     = 10),
                                    
                                    column(width = 12,
                                           
                                           actionButton(inputId = "add_point_ts",
                                                        label = "Add point"),
                                           br(), br(), br(),
                                           actionButton(inputId = "remove_last_point_ts",
                                                        label = "Remove last point"),
                                           actionButton(inputId = "remove_all_points_ts",
                                                        label = "Remove all points")),
                                )),
                                
                                #Custom highlights
                                shinyjs::hidden(
                                div(id = "hidden_custom_highlights_ts",
                                    h5(helpText("Add custom highlights")),
                                    h6(helpText("Enter values manually or draw a box on plot")),
                                    
                                    numericRangeInput(inputId = "highlight_x_values_ts",
                                                      label  = "X values:",
                                                      value  = "",
                                                      min    = -180,
                                                      max    = 180),
                                    
                                    numericRangeInput(inputId = "highlight_y_values_ts",
                                                      label  = "Y values:",
                                                      value  = "",
                                                      min    = -90,
                                                      max    = 90),
                                    
                                    colourInput(inputId = "highlight_colour_ts", 
                                                label   = "Highlight colour:",
                                                showColour = "background",
                                                palette = "limited"),
                                    
                                    radioButtons(inputId      = "highlight_type_ts",
                                                 label        = "Type for highlight:",
                                                 inline       = TRUE,
                                                 choiceNames  = c("Fill \u25FC", "Box \u25FB", "Hatched \u25A8"),
                                                 choiceValues = c("Fill","Box","Hatched")),
                                    
                                    checkboxInput(inputId = "show_highlight_on_legend_ts",
                                                  label   = "Show on legend",
                                                  value   = FALSE),
                                    
                                    textInput(inputId = "highlight_label_ts", 
                                              label   = "Label:",
                                              value   = ""),
                                    
                                    
                                    column(width = 12,
                                           actionButton(inputId = "add_highlight_ts",
                                                        label = "Add highlight"),
                                           br(), br(), br(),
                                           actionButton(inputId = "remove_last_highlight_ts",
                                                        label = "Remove last highlight"),
                                           actionButton(inputId = "remove_all_highlights_ts",
                                                        label = "Remove all highlights")),
                                    
                                )),
                                
                                #Custom lines
                                shinyjs::hidden(
                                div(id = "hidden_custom_line_ts",
                                    h5(helpText("Add custom lines")),
                                    h6(helpText("Enter position manually or click on plot, double click to change orientation")),
                                    
                                    radioButtons(inputId      = "line_orientation_ts",
                                                 label        = "Orientation:",
                                                 inline       = TRUE,
                                                 choices      = c("Vertical", "Horizontal")),
                                    
                                    textInput(inputId = "line_position_ts", 
                                              label   = "Position:",
                                              value   = "",
                                              placeholder = "1830, 1832"),
                                    
                                    colourInput(inputId = "line_colour_ts", 
                                                label   = "Line colour:",
                                                showColour = "background",
                                                palette = "limited"),
                                    
                                    radioButtons(inputId      = "line_type_ts",
                                                 label        = "Type:",
                                                 inline       = TRUE,
                                                 choices = c("solid", "dashed")),
                                    
                                    checkboxInput(inputId = "show_line_on_legend_ts",
                                                  label   = "Show on legend",
                                                  value   = FALSE),
                                    
                                    textInput(inputId = "line_label_ts", 
                                              label   = "Label:",
                                              value   = ""),
                                    
                                    column(width = 12,
                                           actionButton(inputId = "add_line_ts",
                                                        label = "Add line"),
                                           br(), br(), br(),
                                           actionButton(inputId = "remove_last_line_ts",
                                                        label = "Remove last line"),
                                           actionButton(inputId = "remove_all_lines_ts",
                                                        label = "Remove all lines")
                                    )
                                ))
                            ))),
                             
                      #### Custom statistics ----
                      column(width = 4,
                              h4(helpText("Custom statistics")),
                              
                              checkboxInput(inputId = "enable_custom_statistics_ts",
                                            label   = "Enable custom statistics",
                                            value   = FALSE),
                              
                              shinyjs::hidden(
                              div(id = "hidden_custom_statistics_ts",
                                  
                                  checkboxInput(inputId = "custom_average_ts",
                                                label = "Add a moving average",
                                                value = FALSE),
                              
                              shinyjs::hidden(
                              div(id = "hidden_moving_average_ts",  
                                  numericInput(inputId = "year_moving_ts",
                                               label  = "Year moving average, centred:",
                                               value  = 11,
                                               min    = 3,
                                               max    = 30),
                                  
                                  radioButtons(inputId   = "year_position_ts",
                                               label     = "Position for each year:"  ,
                                               choices   = c("before", "on", "after"),
                                               selected  = "on",
                                               inline    = TRUE)
                              )),
                                 
                                  checkboxInput(inputId = "custom_percentile_ts",
                                                label   = "Add percentiles",
                                                value   = FALSE),
                              
                              shinyjs::hidden(
                              div(id = "hidden_percentile_ts",
                                  checkboxGroupInput(inputId   = "percentile_ts",
                                                    label    = NULL,
                                                    choices  = c("0.9", "0.95", "0.99"),
                                                    selected = "0.99",
                                                    inline   = TRUE),
                                  
                                  shinyjs::hidden(
                                  div(id = "hidden_moving_percentile_ts",
                                  checkboxInput(inputId = "moving_percentile_ts",
                                                label   = "Use moving average for percentile",
                                                value   = FALSE)))
                                  
                            ))
                            )),
                      ),
                      
                      #### Customization panels END ----
                     ),
                    ### TS plot END ----       
                             ),

                    ### Other plots ----
                    tabPanel("Map data", br(), tableOutput("data1")),
                    tabPanel("Time series data", br(), column(width = 3, dataTableOutput("data2"))),
                    
                    ### Feedback archive documentation (FAD) ----
                    tabPanel("ModE-RA sources", br(),
                             fluidRow(
                               
                               column(width=4,
                                      numericInput(
                                        inputId  = "fad_year_a",
                                        label   =  "Year",
                                        value = 1422,
                                        min = 1422,
                                        max = 2008)),
                               h4(helpText("Draw a box on the left map to use zoom function")),
                             ),
                             
                             div(id = "fad_map_a",
                             splitLayout(
                                         plotOutput("fad_winter_map_a",
                                                     brush = brushOpts(
                                                       id = "brush_fad1a",
                                                       resetOnNew = TRUE
                                                     )),

                                         plotOutput("fad_zoom_winter_a")
                                         )),

                             div(id = "fad_map_b",
                             splitLayout(plotOutput("fad_summer_map_a",
                                                    brush = brushOpts(
                                                      id = "brush_fad1b",
                                                      resetOnNew = TRUE
                                                    )),
                                         plotOutput("fad_zoom_summer_a")
                                         )),
                    ),
                    
                    
                    ### Downloads ----
                    tabPanel("Downloads",
                    verticalLayout(br(),
                          fluidRow(
                            column(width = 3,
                                   h3(helpText("Primary map download")),
                                   radioButtons(inputId = "file_type_map", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                   downloadButton(outputId = "download_map", label = "Download")),
                            shinyjs::hidden(div(id ="hidden_sec_map_download",
                            column(width = 3,
                                   h3(helpText("Secondary map download")),
                                   radioButtons(inputId = "file_type_map_sec", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                   downloadButton(outputId = "download_map_sec", label = "Download")),
                            )),
                            ),
                            br(),
                          h3(helpText("Time series download")),
                             radioButtons(inputId = "file_type_timeseries", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                             downloadButton(outputId = "download_timeseries", label = "Download"), br(),
                          h3(helpText("Map data download")),
                             radioButtons(inputId = "file_type_map_data", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                             downloadButton(outputId = "download_map_data", label = "Download"), br(),
                          h3(helpText("Time series data download")),
                             radioButtons(inputId = "file_type_timeseries_data", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                             downloadButton(outputId = "download_timeseries_data", label = "Download")), br(),
                          h3(helpText("ModE-RA sources download")),
                          fluidRow(
                            column(width = 3,
                                   radioButtons(inputId = "file_type_modera_source_a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                   downloadButton(outputId = "download_fad_wa", label = "Download Oct. - Mar")),
                            column(width = 3,
                                   radioButtons(inputId = "file_type_modera_source_b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                   downloadButton(outputId = "download_fad_sa", label = "Download Apr. - Sept")),
                          ),
                          br(),
                          h3(helpText("NetCDF download")),
                             checkboxGroupInput(inputId = "netcdf_variables", label = "Choose your variables:", selected = NULL, inline = TRUE),
                             downloadButton(outputId = "download_netcdf", label = "Download")
                            )
        
                ## Main Panel END ----
                ), width = 8),
# Average & anomaly END ----  
        )),
        
# Composites START----      
        tabPanel("Composites", id = "tab2",
        shinyjs::useShinyjs(),
        sidebarLayout(
                 ## Sidebar Panels START ----
                 sidebarPanel(verticalLayout(
                   
                    ### First Sidebar panel (Variable and time selection) ----
                    sidebarPanel(fluidRow( 
                     
                     #Short description of the Panel Composites        
                     h4(helpText("Plot composite anomalies for a set of years")),
                     
                     #Choose one of three datasets (Select)                
                     selectInput(inputId  = "dataset_selected2",
                                 label    = "Choose a dataset:",
                                 choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                                 selected = "ModE-RA"),
                     
                     #Choose one of four variable (Select)                
                     selectInput(inputId  = "variable_selected2",
                                 label    = "Choose a variable to plot:",
                                 choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                                 selected = "Temperature"),
                     
                     #Type in your year of interest OR upload a file
                     radioButtons(inputId  = "enter_upload2",
                                  label    = "Choose how to enter composite years:",
                                  choices  = c("Manual", "Upload"),
                                  selected = "Manual" , inline = TRUE),
                     
                     shinyjs::hidden(div(id = "optional2c",
                                         textInput(inputId    = "range_years2",
                                                   label     = "Enter your list of years, separated by commas:",
                                                   value     = "1815, 1816",
                                                   placeholder = "1815"))),
                     
                     shinyjs::hidden(div(id = "optional2d",
                                         fileInput(inputId = "upload_file2",
                                                   label = "Upload a list of years in .csv or .xlsx format:",
                                                   multiple = FALSE,
                                                   accept = c(".csv", ".xlsx", ".xls"),
                                                   width = NULL,
                                                   buttonLabel = "Browse your folders",
                                                   placeholder = "No file selected"),
                                         
                                         shinyjs::hidden(div(id = "optional2e",
                                            img(src = 'pics/composite_user_example.jpg', id = "comp_user_example", height = "150px", width = "75px"),
                                            ))
                                         )
                                     ),
                    
                     #Choose Season, Year or Months
                     radioButtons(inputId  = "season_selected2",
                                  label    = "Select the range of months:",
                                  choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                  selected = "Annual" , inline = TRUE),

                     #Choose your range of months (Slider)
                     shinyjs::hidden(
                       div(id = "season2",
                           sliderTextInput(inputId = "range_months2",
                                           label = "Select custom months:",
                                           choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                           #Initially selected = 1 year (annual mean)
                                           selected = c("January", "December")),
                       )),      
                     
                     #Choose a Mode: Absolute, Fixed Anomaly or Anomalies compared to X years prior
                     radioButtons(inputId  = "mode_selected2",
                                  label    = "Select anomaly method:",
                                  choices  = c("Fixed reference","Custom reference", "Compared to X years prior"),
                                  selected = "Fixed reference" , inline = TRUE),

                     #Choose reference period for either Fixed Anomaly or enter X years (1-50) for Anomalies compared to X years prior (Hidden objects)      
                     shinyjs::hidden(
                       div(id = "optional2a",
                           hidden(
                           numericRangeInput(inputId = "ref_period2",
                                             label      = "Reference period:",
                                             value      = c(1961,1990),
                                             separator  = " to ",
                                             min        = 1422,
                                             max        = 2008)),
                       
                       #Choose single ref year
                       column(12,
                              checkboxInput(inputId = "ref_single_year2",
                                            label   = "Select single year",
                                            value   = FALSE)),
                       
                       
                       hidden(
                         numericInput(inputId   = "ref_period_sg2",
                                      label     = "Select the single year:",
                                      value     = NA,
                                      min       = 1422,
                                      max       = 2008)),
                       )),

                     shinyjs::hidden(
                       div(id = "optional2b",
                           numericInput(inputId = "prior_years2",
                                        label      = "X (number of years prior to composite years - max 50):",
                                        value      = 10,
                                        min        = 1,
                                        max        = 50))),
                     
                     #Reference period as list of years (manual or upload)
                     shinyjs::hidden(div(id = "optional2f",
                                         radioButtons(inputId  = "enter_upload2a",
                                                      label    = "Choose how to enter reference years:",
                                                      choices  = c("Manual", "Upload"),
                                                      selected = "Manual" , inline = TRUE),
                     
                     shinyjs::hidden(div(id = "optional2g",
                                         textInput(inputId    = "range_years2a",
                                                   label     = "Enter your list of years, separated by commas:",
                                                   value     = "1641, 1642",
                                                   placeholder = "1641"))),
                     
                     shinyjs::hidden(div(id = "optional2h",
                                         fileInput(inputId = "upload_file2a",
                                                   label = "Upload a list of years in .csv or .xlsx format:",
                                                   multiple = FALSE,
                                                   accept = c(".csv", ".xlsx", ".xls"),
                                                   width = NULL,
                                                   buttonLabel = "Browse your folders",
                                                   placeholder = "No file selected"),
                                         
                                         shinyjs::hidden(div(id = "optional2i",
                                                             img(src = 'pics/composite_user_example.jpg', id = "comp_user_example_2", height = "150px", width = "75px"),
                                         ))
                     )),
                       )),
                     
                     ), width = 12),
                     
                     br(),
                   
                    ### Second sidebar panel (Location selection) ----
                     sidebarPanel(fluidRow(
                     
                     #Short description of the Coord. Sidebar        
                     h4(helpText("Set geographical area")),
                     h5(helpText("Select a continent, enter coordinates manually or draw a box on the plot")),
                     
                     column(width = 12, fluidRow(      
                       #Global Button
                       actionButton(inputId = "button_global2",
                                    label = "Global",
                                    width = "100px"),
                       
                       br(), br(),
                       
                       #Europe Button
                       actionButton(inputId = "button_europe2",
                                    label = "Europe",
                                    width = "100px"),
                       
                       br(), br(),
                       
                       #Asia Button
                       actionButton(inputId = "button_asia2",
                                    label = "Asia",
                                    width = "100px"),
                       
                       br(), br(),
                       
                       #Oceania Button
                       actionButton(inputId = "button_oceania2",
                                    label = "Oceania",
                                    width = "110px"),
                       
                     )),
                     
                     column(width = 12, br()),
                     
                     column(width = 12, fluidRow(
                       
                       #Africa Button
                       actionButton(inputId = "button_africa2",
                                    label = "Africa",
                                    width = "100px"),
                       
                       br(), br(),
                       
                       #North America Button
                       actionButton(inputId = "button_n_america2",
                                    label = "North America",
                                    width = "150px"),
                       
                       br(), br(),
                       
                       #South America Button
                       actionButton(inputId = "button_s_america2",
                                    label = "South America",
                                    width = "150px")
                     )),
                     
                     column(width = 12, br()),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_longitude2",
                                       label = "Longitude range (-180 to 180):",
                                       value = initial_lon_values,
                                       separator = " to ",
                                       min = -180,
                                       max = 180),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_latitude2",
                                       label = "Latitude range (-90 to 90):",
                                       value = initial_lat_values,
                                       separator = " to ",
                                       min = -90,
                                       max = 90),
                     
                     br(), br(),
                     
                     #Enter Coordinates
                     actionButton(inputId = "button_coord2",
                                  label = "Update coordinates",
                                  width = "200px"),
                    
                     ), width = 12)
                 ## Sidebar Panels END ----
                 )),
                 
                 ## Main Panel START ----
                 mainPanel(tabsetPanel(
                    ### Map plot START ----
                     tabPanel("Map", br(),
                              h4(textOutput("text_years2")),
                              textOutput("years2"),
                     shinyjs::hidden(div(id = "custom_anomaly_years2",
                              h4(textOutput("text_custom_years2")),
                              textOutput("custom_years2")
                     )),
                              plotOutput("map2",height = "auto", dblclick = "map_dblclick2", brush = brushOpts(id = "map_brush2",resetOnNew = TRUE)),
                              
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,
                      h4(helpText("Customize your map")),  
                      
                      checkboxInput(inputId = "custom_map2",
                                    label   = "Map customization",
                                    value   = FALSE),
                      
                      shinyjs::hidden(
                      div(id = "hidden_custom_maps2",
                            
                            radioButtons(inputId  = "axis_mode2",
                                         label    = "Axis customization:",
                                         choices  = c("Default", "Custom"),
                                         selected = "Default" , inline = TRUE),
                            
                            shinyjs::hidden(
                            div(id = "hidden_custom_axis2",
                                  
                                  numericRangeInput(inputId    = "axis_input2",
                                                    label      = "Set your axis values:",
                                                    value      = c(NULL, NULL),
                                                    separator  = " to ",
                                                    min        = -Inf,
                                                    max        = Inf))),
                            
                            checkboxInput(inputId = "hide_axis2",
                                          label   = "Hide axis completely",
                                          value   = FALSE),
                            
                            br(),
                            
                            radioButtons(inputId  = "title_mode2",
                                         label    = "Title customization:",
                                         choices  = c("Default", "Custom"),
                                         selected = "Default" , inline = TRUE),
                            
                            shinyjs::hidden(
                              div(id = "hidden_custom_title2",
                                  
                                  textInput(inputId     = "title1_input2",
                                            label       = "Custom map title:", 
                                            value       = NA,
                                            width       = NULL,
                                            placeholder = "Custom title"),
                                  
                                  textInput(inputId     = "title2_input2",
                                            label       = "Custom map subtitle (e.g. Ref-Period):",
                                            value       = NA,
                                            width       = NULL,
                                            placeholder = "Custom title")))
                        )),
                      ),
                    
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,
                             h4(helpText("Custom features")),
                             
                             checkboxInput(inputId = "custom_features2",
                                           label   = "Enable custom features",
                                           value   = FALSE),
                             
                               shinyjs::hidden(
                               div(id = "hidden_custom_features2",
                                   radioButtons(inputId      = "feature2",
                                                label        = "Select a feature type:",
                                                inline       = TRUE,
                                                choices      = c("Point", "Highlight")),
                                   
                                   #Custom Points
                                   shinyjs::hidden(
                                   div(id = "hidden_custom_points2",
                                       h5(helpText("Add custom points")),
                                       h6(helpText("Enter location/coordinates or double click on map")),
                                       
                                       textInput(inputId = "location2", 
                                                 label   = "Enter a location:",
                                                 value   = NULL,
                                                 placeholder = "e.g. Bern"),
                                       
                                       actionButton(inputId = "search2",
                                                    label   = "Search"),
                                       
                                       
                                       shinyjs::hidden(div(id = "inv_location2",
                                                           h6(helpText("Invalid location"))
                                       )),
                                       
                                       textInput(inputId = "point_label2", 
                                                 label   = "Point label:",
                                                 value   = ""),
                                       
                                       column(width = 12, offset = 0,
                                              column(width = 6,
                                                     textInput(inputId = "point_location_x2", 
                                                               label   = "Point longitude:",
                                                               value   = "")
                                              ),
                                              column(width = 6,
                                                     textInput(inputId = "point_location_y2", 
                                                               label   = "Point latitude:",
                                                               value   = "")
                                              )),

                                       radioButtons(inputId      = "point_shape2",
                                                    label        = "Point shape:",
                                                    inline       = TRUE,
                                                    choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                       
                                       colourInput(inputId = "point_colour2", 
                                                   label   = "Point colour:",
                                                   showColour = "background",
                                                   palette = "limited"),                       
                                       
                                       
                                       numericInput(inputId = "point_size2",
                                                    label   = "Point size:",
                                                    value   = 1,
                                                    min     = 1,
                                                    max     = 10),
                                       
                                       column(width = 12,
                                              
                                              actionButton(inputId = "add_point2",
                                                           label = "Add point"),
                                              br(), br(), br(),
                                              actionButton(inputId = "remove_last_point2",
                                                           label = "Remove last point"),
                                              actionButton(inputId = "remove_all_points2",
                                                           label = "Remove all points")),
                                   )),
                                   
                                   #Custom Highlights
                                   shinyjs::hidden(
                                   div(id = "hidden_custom_highlights2",
                                       h5(helpText("Add custom highlights")),
                                       h6(helpText("Enter coordinate or draw a box on map")),
                                       
                                       numericRangeInput(inputId = "highlight_x_values2",
                                                         label  = "Longitude:",
                                                         value  = "",
                                                         min    = -180,
                                                         max    = 180),
                                       
                                       numericRangeInput(inputId = "highlight_y_values2",
                                                         label  = "Latitude:",
                                                         value  = "",
                                                         min    = -90,
                                                         max    = 90),
                                       
                                       colourInput(inputId = "highlight_colour2", 
                                                   label   = "Highlight colour:",
                                                   showColour = "background",
                                                   palette = "limited"),
                                       
                                       radioButtons(inputId      = "highlight_type2",
                                                    label        = "Type for highlight:",
                                                    inline       = TRUE,
                                                    choiceNames  = c("Box \u25FB", "Hatched \u25A8"),
                                                    choiceValues = c("Box","Hatched")),
                  
                                       
                                       column(width = 12,
                                              actionButton(inputId = "add_highlight2",
                                                           label = "Add highlight"),
                                              br(), br(), br(),
                                              actionButton(inputId = "remove_last_highlight2",
                                                           label = "Remove last highlight"),
                                              actionButton(inputId = "remove_all_highlights2",
                                                           label = "Remove all highlights")),
                                   )),
                               )),
                      ),
                      
                      #### Custom statistics ----
                      column(width = 4,
                             h4(helpText("Custom statistics")),
                             
                             checkboxInput(inputId = "enable_custom_statistics2",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                             div(id = "hidden_custom_statistics2",
                                 h5(helpText("Choose custom statistic:")),
                                 
                                 radioButtons(inputId      = "custom_statistic2",
                                              label        = NULL,
                                              inline       = TRUE,
                                              choices      = c("SD ratio","% sign match")),
                            
                               div(id = "hidden_sign_match2",  
                                   numericInput(inputId = "percentage_sign_match2",
                                                label  = "% of years in range with matching sign:",
                                                value  = 90,
                                                min    = 1,
                                                max    = 100)
                                   ),
                               
                               div(id = "hidden_SD_ratio2",  
                                   numericInput(inputId = "sd_ratio2",
                                                label  = "SD ratio < ",
                                                value  = 0.2,
                                                min    = 0,
                                                max    = 1)
                               ),
                               
                             )),
                      ),
                      #### Customization panels END ----
                      ),
                     #### Abs/Ref Map plot START ----
                     h4(helpText("Reference map")), 
                     
                     radioButtons(inputId  = "ref_map_mode2",
                                  label    = NULL,
                                  choices  = c("None", "Absolute Values","Reference Period","SD Ratio"),
                                  selected = "None" , inline = TRUE),
                     
                     plotOutput("ref_map2", height = "auto")
                     
                    ### Map plot END ----  
                      ),
             
                    ### Composite TS plot START ----
                   tabPanel("Time series", br(),
                            h4(textOutput("text_years2b")),
                            textOutput("years2b"),
                            shinyjs::hidden(div(id = "custom_anomaly_years2b",
                                                h4(textOutput("text_custom_years2b")),
                                                textOutput("custom_years2b")
                            )),
                            plotOutput("timeseries2", click = "ts_click2", dblclick = "ts_dblclick2", brush = brushOpts(id = "ts_brush2",resetOnNew = TRUE)),
                      
                      #### Customization panels START ----       
                      fluidRow(
                        
                      #### Time series customization ----
                      column(width = 4,
                             h4(helpText("Customize your time series")),  
                             
                             checkboxInput(inputId = "custom_ts2",
                                           label   = "Time series customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden( 
                               div(id = "hidden_custom_ts2",
                                   radioButtons(inputId  = "title_mode_ts2",
                                                label    = "Title customization:",
                                                choices  = c("Default", "Custom"),
                                                selected = "Default" ,
                                                inline = TRUE),
                                   
                                   shinyjs::hidden( 
                                     div(id = "hidden_custom_title_ts2",
                                         
                                         textInput(inputId     = "title1_input_ts2",
                                                   label       = "Custom map title:", 
                                                   value       = NA,
                                                   width       = NULL,
                                                   placeholder = "Custom title")
                                     )),
                                   
                                   checkboxInput(inputId = "show_key_ts2",
                                                 label   = "Show key",
                                                 value   = FALSE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_key_position_ts2",
                                         radioButtons(inputId  = "key_position_ts2",
                                                      label    = "Key position:",
                                                      choiceNames  = c("top left", "top right","bottom left","bottom right"),
                                                      choiceValues = c("topleft", "topright","bottomleft","bottomright"),
                                                      selected = "topright" ,
                                                      inline = TRUE))),
                                   
                                   checkboxInput(inputId = "show_ref_ts2",
                                                 label   = "Show reference",
                                                 value   = FALSE),
                               )),    
                      ),
                      
                      #### Add Custom features (points, highlights, lines) ----                        
                      column(width = 4,
                             h4(helpText("Custom features")),
                             
                             checkboxInput(inputId = "custom_features_ts2",
                                           label   = "Enable custom features",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_features_ts2",
                                   radioButtons(inputId      = "feature_ts2",
                                                label        = "Select a feature type:",
                                                inline       = TRUE,
                                                choices      = c("Point", "Highlight", "Line")),
                                   
                                   #Custom Points
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_points_ts2",
                                         h5(helpText("Add custom points")),
                                         h6(helpText("Enter position manually or click on plot")),
                                         
                                         textInput(inputId = "point_label_ts2", 
                                                   label   = "Point label:",
                                                   value   = ""),
                                         
                                         column(width = 12, offset = 0,
                                                column(width = 6,
                                                       textInput(inputId = "point_location_x_ts2", 
                                                                 label   = "Point x position:",
                                                                 value   = "")
                                                ),
                                                column(width = 6,
                                                       textInput(inputId = "point_location_y_ts2", 
                                                                 label   = "Point y position:",
                                                                 value   = "")
                                                )),
                                         
                                         
                                         radioButtons(inputId      = "point_shape_ts2",
                                                      label        = "Point shape:",
                                                      inline       = TRUE,
                                                      choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                         
                                         colourInput(inputId = "point_colour_ts2", 
                                                     label   = "Point colour:",
                                                     showColour = "background",
                                                     palette = "limited"),                        
                                         
                                         
                                         numericInput(inputId = "point_size_ts2",
                                                      label   = "Point size",
                                                      value   = 1,
                                                      min     = 1,
                                                      max     = 10),
                                         
                                         column(width = 12,
                                                
                                                actionButton(inputId = "add_point_ts2",
                                                             label = "Add point"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_point_ts2",
                                                             label = "Remove last point"),
                                                actionButton(inputId = "remove_all_points_ts2",
                                                             label = "Remove all points")),
                                     )),
                                   
                                   #Custom highlights
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_highlights_ts2",
                                         h5(helpText("Add custom highlights")),
                                         h6(helpText("Enter values manually or draw a box on plot")),
                                         
                                         numericRangeInput(inputId = "highlight_x_values_ts2",
                                                           label  = "X values:",
                                                           value  = "",
                                                           min    = -180,
                                                           max    = 180),
                                         
                                         numericRangeInput(inputId = "highlight_y_values_ts2",
                                                           label  = "Y values:",
                                                           value  = "",
                                                           min    = -90,
                                                           max    = 90),
                                         
                                         colourInput(inputId = "highlight_colour_ts2", 
                                                     label   = "Highlight colour:",
                                                     showColour = "background",
                                                     palette = "limited"),
                                         
                                         radioButtons(inputId      = "highlight_type_ts2",
                                                      label        = "Type for highlight:",
                                                      inline       = TRUE,
                                                      choiceNames  = c("Fill \u25FC", "Box \u25FB", "Hatched \u25A8"),
                                                      choiceValues = c("Fill","Box","Hatched")),
                                         
                                         checkboxInput(inputId = "show_highlight_on_legend_ts2",
                                                       label   = "Show on legend",
                                                       value   = FALSE),
                                         
                                         textInput(inputId = "highlight_label_ts2", 
                                                   label   = "Label:",
                                                   value   = ""),
                                         
                                         
                                         column(width = 12,
                                                actionButton(inputId = "add_highlight_ts2",
                                                             label = "Add highlight"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_highlight_ts2",
                                                             label = "Remove last highlight"),
                                                actionButton(inputId = "remove_all_highlights_ts2",
                                                             label = "Remove all highlights")),
                                         
                                     )),
                                   
                                   #Custom lines
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_line_ts2",
                                         h5(helpText("Add custom lines")),
                                         h6(helpText("Enter position manually or click on plot, double click to change orientation")),
                                         
                                         radioButtons(inputId      = "line_orientation_ts2",
                                                      label        = "Orientation:",
                                                      inline       = TRUE,
                                                      choices      = c("Vertical", "Horizontal")),
                                         
                                         textInput(inputId = "line_position_ts2", 
                                                   label   = "Position:",
                                                   value   = "",
                                                   placeholder = "1830, 1832"),
                                         
                                         colourInput(inputId = "line_colour_ts2", 
                                                     label   = "Line colour:",
                                                     showColour = "background",
                                                     palette = "limited"),
                                         
                                         radioButtons(inputId      = "line_type_ts2",
                                                      label        = "Type:",
                                                      inline       = TRUE,
                                                      choices = c("solid", "dashed")),
                                         
                                         checkboxInput(inputId = "show_line_on_legend_ts2",
                                                       label   = "Show on legend",
                                                       value   = FALSE),
                                         
                                         textInput(inputId = "line_label_ts2", 
                                                   label   = "Label:",
                                                   value   = ""),
                                         
                                         column(width = 12,
                                                actionButton(inputId = "add_line_ts2",
                                                             label = "Add line"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_line_ts2",
                                                             label = "Remove last line"),
                                                actionButton(inputId = "remove_all_lines_ts2",
                                                             label = "Remove all lines")
                                         )
                                     ))
                               ))),
                      
                      #### Custom statistics ----
                      column(width = 4,
                             h4(helpText("Custom statistics")),
                             
                             checkboxInput(inputId = "enable_custom_statistics_ts2",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_statistics_ts2",
                                   
                                   checkboxInput(inputId = "custom_percentile_ts2",
                                                 label   = "Add percentiles",
                                                 value   = FALSE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_percentile_ts2",
                                         checkboxGroupInput(inputId   = "percentile_ts2",
                                                      label    = NULL,
                                                      choices  = c("0.9", "0.95", "0.99"),
                                                      selected = "0.99",
                                                      inline   = TRUE),
                                     ))
                               )),
                      ),
                      
                      #### Customization panels END ----
             ),
                    ### Composite TS plot END ----
                    ),
                   
                    ### Other plots ----
                    tabPanel("Map data", br(), tableOutput("data3")),
                    tabPanel("Time series data", br(), column(width = 3, dataTableOutput("data4"))),
                    
                    ### Feedback archive documentation (FAD) ----
                   tabPanel("ModE-RA sources", br(),
                            fluidRow(
                              
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a2",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              h4(helpText("Draw a box on the left map to use zoom function")),
                            ),
                            
                            div(id = "fad_map_a2",
                                splitLayout(
                                  plotOutput("fad_winter_map_a2",
                                             brush = brushOpts(
                                               id = "brush_fad1a2",
                                               resetOnNew = TRUE
                                             )),
                                  
                                  plotOutput("fad_zoom_winter_a2")
                                )),
                            
                            div(id = "fad_map_b2",
                                splitLayout(plotOutput("fad_summer_map_a2",
                                                       brush = brushOpts(
                                                         id = "brush_fad1b2",
                                                         resetOnNew = TRUE
                                                       )),
                                            plotOutput("fad_zoom_summer_a2")
                                )),
                   ),
                   
                    ### Downloads ----
                    tabPanel("Downloads",
                            verticalLayout(br(),
                                   fluidRow(
                                     column(width = 3,
                                            h3(helpText("Primary map download")),
                                            radioButtons(inputId = "file_type_map2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                            downloadButton(outputId = "download_map2", label = "Download")),
                                            shinyjs::hidden(div(id = "hidden_sec_map_download2",
                                            column(width = 3,
                                                   h3(helpText("Secondary map download")),
                                                   radioButtons(inputId = "file_type_map_sec2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                   downloadButton(outputId = "download_map_sec2", label = "Download")),
                                            )),
                                            ),
                                            br(),
                                    h3(helpText("Time series download")),
                                           radioButtons(inputId = "file_type_timeseries2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                           downloadButton(outputId = "download_timeseries2", label = "Download"), br(),
                                    h3(helpText("Map data download")),
                                           radioButtons(inputId = "file_type_map_data2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                           downloadButton(outputId = "download_map_data2", label = "Download"), br(),
                                    h3(helpText("Time series data download")),
                                           radioButtons(inputId = "file_type_timeseries_data2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                           downloadButton(outputId = "download_timeseries_data2", label = "Download")), br(),
                                    h3(helpText("ModE-RA sources download")),
                                    fluidRow(
                                      column(width = 3,
                                             radioButtons(inputId = "file_type_modera_source_a2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                             downloadButton(outputId = "download_fad_wa2", label = "Download Oct. - Mar")),
                                      column(width = 3,
                                             radioButtons(inputId = "file_type_modera_source_b2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                             downloadButton(outputId = "download_fad_sa2", label = "Download Apr. - Sept")),
                                    ),
                   ),
                   
                ## Main Panel END ----
                ), width = 8),
# Composites END ----           
        )),

# Correlation START ----
          tabPanel("Correlation", id = "tab3",
          shinyjs::useShinyjs(),
          sidebarLayout(
               ## Sidebar Panels START ----          
               sidebarPanel(verticalLayout(
                 
                   ### First Sidebar panel (Variable 1) ----
                   sidebarPanel(fluidRow(
                   
                   #Short description of the General Panel        
                   h4(helpText("Variable 1")),
                   
                   #Choose a data source: ME or USer 
                   radioButtons(inputId  = "source_v1",
                                label    = "Choose a data source:",
                                choices  = c("ModE-", "User Data"),
                                selected = "ModE-" ,
                                inline = TRUE),
                  
                   # Upload user data
                   shinyjs::hidden(
                   div(id = "upload_forcings_v1",   
                   fileInput(inputId = "user_file_v1",
                             label = "Upload time series data in .csv or .xlsx format:",
                             multiple = FALSE,
                             accept = c(".csv", ".xlsx", ".xls"),
                             width = NULL,
                             buttonLabel = "Browse your folders",
                             placeholder = "No file selected"),
                   
                   div(id = "upload_example_v1",
                   img(src = 'pics/regcor_user_example.jpg', id = "cor_user_example_v1", height = "150px", width = "150px"))
                   )),
                   
                   #Choose a variable (USER)
                   shinyjs::hidden(
                   div(id = "hidden_user_variable_v1",
                   selectInput(inputId  = "user_variable_v1",
                               label    = "Choose a variable:",
                               choices  = NULL,
                               selected = NULL),
                   )),
                   
                   #Choose one of three datasets (Select)
                   shinyjs::hidden(
                   div(id = "hidden_me_dataset_variable_v1",
                   selectInput(inputId  = "dataset_selected_v1",
                               label    = "Choose a dataset:",
                               choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                               selected = "ModE-RA"),

                   #Choose a variable (Mod-ERA) 
                   selectInput(inputId  = "ME_variable_v1",
                               label    = "Choose a variable:",
                               choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                               selected = "Temperature"),
                   )),
                   
                   shinyjs::hidden(
                   div(id = "hidden_modera_variable_v1",
                   #Choose how to use ME data: As a time series or field  
                   radioButtons(inputId  = "type_v1",
                                label    = "Choose how to use ModE-RA data:",
                                choices  = c( "Field", "Time series"),
                                selected = "Time series" ,
                                inline = TRUE),
                   
                   #Choose a Mode: Absolute or Anomaly 
                   radioButtons(inputId  = "mode_selected_v1",
                                label    = "Choose a mode:",
                                choices  = c("Anomaly", "Absolute"),
                                selected = "Anomaly" ,
                                inline = TRUE),
                   
                   #Choose Season, Year or Months
                   radioButtons(inputId  = "season_selected_v1",
                                label    = "Select the range of months:",
                                choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                selected = "Annual" ,
                                inline = TRUE),
                   
                   #Choose your range of months (Slider)
                   shinyjs::hidden(
                     div(id = "season_v1",
                         sliderTextInput(inputId = "range_months_v1",
                                         label = "Select custom months:",
                                         choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                         #Initially selected = 1 year (annual mean)
                                         selected = c("January", "December")),
                     )), 
                   
                   #Choose reference period if Anomaly values are chosen (Hidden object)      
                   shinyjs::hidden(
                     div(id = "optional_v1",
                         hidden(
                         numericRangeInput(inputId = "ref_period_v1",
                                           label      = "Reference period:",
                                           value      = c(1961,1990),
                                           separator  = " to ",
                                           min        = 1422,
                                           max        = 2008)),
                         
                         #Choose single ref year
                         column(12,
                                checkboxInput(inputId = "ref_single_year_v1",
                                              label   = "Select single year",
                                              value   = FALSE)),
                         
                         
                         hidden(
                           numericInput(inputId   = "ref_period_sg_v1",
                                        label     = "Select the single year:",
                                        value     = NA,
                                        min       = 1422,
                                        max       = 2008)),
                         
                         )),
                   
                   #Choose Coordinates input 
                   radioButtons(inputId  = "coordinates_type_v1",
                                label    = "Choose input of coordinates:",
                                choices  = c("Manual", "Continents"),
                                selected = "Manual" ,
                                inline = TRUE),
                   
                   shinyjs::hidden(
                   div(id = "hidden_continents_v1",
                   column(width = 12, fluidRow(      
                     #Global Button
                     actionButton(inputId = "button_global_v1",
                                  label = "Global",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #Europe Button
                     actionButton(inputId = "button_europe_v1",
                                  label = "Europe",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #Asia Button
                     actionButton(inputId = "button_asia_v1",
                                  label = "Asia",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #Oceania Button
                     actionButton(inputId = "button_oceania_v1",
                                  label = "Oceania",
                                  width = "110px"),
                     
                   )),
                   
                   column(width = 12, br()),
                   
                   column(width = 12, fluidRow(
                     
                     #Africa Button
                     actionButton(inputId = "button_africa_v1",
                                  label = "Africa",
                                  width = "100px"),
                     
                     br(), br(),
                     
                     #North America Button
                     actionButton(inputId = "button_n_america_v1",
                                  label = "North America",
                                  width = "150px"),
                     
                     br(), br(),
                     
                     #South America Button
                     actionButton(inputId = "button_s_america_v1",
                                  label = "South America",
                                  width = "150px")
                   )),
                   
                   column(width = 12, br()),
                   
                   )),
                   
                   #Choose Longitude and Latitude Range          
                   numericRangeInput(inputId = "range_longitude_v1",
                                     label = "Longitude range (-180 to 180):",
                                     value = c(4,12),
                                     separator = " to ",
                                     min = -180,
                                     max = 180),
            
                   #Choose Longitude and Latitude Range          
                   numericRangeInput(inputId = "range_latitude_v1",
                                     label = "Latitude range (-90 to 90):",
                                     value = c(43,50),
                                     separator = " to ",
                                     min = -90,
                                     max = 90),
                   
                   #Enter Coordinates
                   actionButton(inputId = "button_coord_v1",
                                label = "Update coordinates",
                                width = "200px"),
                   
                   )),
                   
                   
                 ), width = 12),
                 
                 br(),
                 
                   ### Second Sidebar panel (Year range) ----
                   
                   sidebarPanel(fluidRow(
                     #Choose your year of interest
                     hidden(
                     numericRangeInput(inputId    = "range_years3",
                                       label     = "Select the range of years (1422-2008):",
                                       value     = c(1900,2008),
                                       separator = " to ",
                                       min       = 1422,
                                       max       = 2008)),
                     
                     #Choose single year
                     column(12,
                            checkboxInput(inputId = "single_year3",
                                          label   = "Select single year",
                                          value   = FALSE)),
                     
                     
                     hidden(
                       numericInput(inputId   = "range_years_sg3",
                                    label     = "Select the single year:",
                                    value     = NA,
                                    min       = 1422,
                                    max       = 2008)),
                     
                   ), width = 12),
                   
                   br(),
                   
                   ### Third Sidebar panel (Variable 2) ----
                   
                   sidebarPanel(fluidRow(
                     #Short description of the General Panel        
                     h4(helpText("Variable 2")),
                     
                     #Choose a data source: ME or USer 
                     radioButtons(inputId  = "source_v2",
                                  label    = "Choose a data source:",
                                  choices  = c("ModE-", "User Data"),
                                  selected = "ModE-" ,
                                  inline = TRUE),
                     
                     # Upload user data
                     shinyjs::hidden(
                     div(id = "upload_forcings_v2", 
                     fileInput(inputId = "user_file_v2",
                               label = "Upload time series data in .csv or .xlsx format:",
                               multiple = FALSE,
                               accept = c(".csv", ".xlsx", ".xls"),
                               width = NULL,
                               buttonLabel = "Browse your folders",
                               placeholder = "No file selected"),
                     
                     div(id = "upload_example_v2",
                     img(src = 'pics/regcor_user_example.jpg', id = "cor_user_example_v2", height = "150px", width = "150px")),
                     )),
                     
                     #Choose a variable (USER)
                     shinyjs::hidden(
                       div(id = "hidden_user_variable_v2",
                           selectInput(inputId  = "user_variable_v2",
                                       label    = "Choose a variable:",
                                       choices  = NULL,
                                       selected = NULL),
                       )),
                     
                     #Choose one of three datasets (Select)
                     shinyjs::hidden(
                     div(id = "hidden_me_dataset_variable_v2",
                     selectInput(inputId  = "dataset_selected_v2",
                                 label    = "Choose a dataset:",
                                 choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                                 selected = "ModE-RA"),

                     #Choose a variable (Mod-ERA) 
                     selectInput(inputId  = "ME_variable_v2",
                                 label    = "Choose a variable:",
                                 choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                                 selected = "Temperature"),
                     )),
                     
                     shinyjs::hidden(
                     div(id = "hidden_modera_variable_v2",
                     #Choose how to use ME data: As a time series or field  
                     radioButtons(inputId  = "type_v2",
                                  label    = "Choose how to use the ModE-RA data:",
                                  choices  = c( "Field","Time series"),
                                  selected = "Field" ,
                                  inline = TRUE),
                     
                     #Choose a Mode: Absolute or Anomaly 
                     radioButtons(inputId  = "mode_selected_v2",
                                  label    = "Choose a mode:",
                                  choices  = c("Anomaly", "Absolute"),
                                  selected = "Anomaly" ,
                                  inline = TRUE),
                     
                     #Choose Season, Year or Months
                     radioButtons(inputId  = "season_selected_v2",
                                  label    = "Select the range of months:",
                                  choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                  selected = "Annual" ,
                                  inline = TRUE),
                     
                     #Choose your range of months (Slider)
                     shinyjs::hidden(
                       div(id = "season_v2",
                           sliderTextInput(inputId = "range_months_v2",
                                           label = "Select custom months:",
                                           choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                           #Initially selected = 1 year (annual mean)
                                           selected = c("January", "December")),
                       )), 
                     
                     #Choose reference period if Anomaly values are chosen (Hidden object)      
                     shinyjs::hidden(
                       div(id = "optional_v2",
                           hidden(
                           numericRangeInput(inputId = "ref_period_v2",
                                             label      = "Reference period:",
                                             value      = c(1961,1990),
                                             separator  = " to ",
                                             min        = 1422,
                                             max        = 2008)),
                           
                           #Choose single ref year
                           column(12,
                                  checkboxInput(inputId = "ref_single_year_v2",
                                                label   = "Select single year",
                                                value   = FALSE)),
                           
                           
                           hidden(
                             numericInput(inputId   = "ref_period_sg_v2",
                                          label     = "Select the single year:",
                                          value     = NA,
                                          min       = 1422,
                                          max       = 2008)),
                           
                           
                           )),
                     
                     #Choose Coordinates input 
                     radioButtons(inputId  = "coordinates_type_v2",
                                  label    = "Choose input of coordinates:",
                                  choices  = c("Manual", "Continents"),
                                  selected = "Manual" ,
                                  inline = TRUE),
                     
                     shinyjs::hidden(
                       div(id = "hidden_continents_v2",
                           column(width = 12, fluidRow(      
                             #Global Button
                             actionButton(inputId = "button_global_v2",
                                          label = "Global",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Europe Button
                             actionButton(inputId = "button_europe_v2",
                                          label = "Europe",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Asia Button
                             actionButton(inputId = "button_asia_v2",
                                          label = "Asia",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Oceania Button
                             actionButton(inputId = "button_oceania_v2",
                                          label = "Oceania",
                                          width = "110px"),
                             
                           )),
                           
                           column(width = 12, br()),
                           
                           column(width = 12, fluidRow(
                             
                             #Africa Button
                             actionButton(inputId = "button_africa_v2",
                                          label = "Africa",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #North America Button
                             actionButton(inputId = "button_n_america_v2",
                                          label = "North America",
                                          width = "150px"),
                             
                             br(), br(),
                             
                             #South America Button
                             actionButton(inputId = "button_s_america_v2",
                                          label = "South America",
                                          width = "150px")
                           )),
                           
                           column(width = 12, br()),
                           
                       )),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_longitude_v2",
                                       label = "Longitude range (-180 to 180):",
                                       value = initial_lon_values,
                                       separator = " to ",
                                       min = -180,
                                       max = 180),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_latitude_v2",
                                       label = "Latitude range (-90 to 90):",
                                       value = initial_lat_values,
                                       separator = " to ",
                                       min = -90,
                                       max = 90),
                     
                     #Enter Coordinates
                     actionButton(inputId = "button_coord_v2",
                                  label = "Update coordinates",
                                  width = "200px"),
                     )),
                     
                   ), width = 12)
                 
               ## Sidebar Panels END ----
               )),
                 
               ## Main Panel START ---- ----
               mainPanel(tabsetPanel(
                   ### v1, v2 plot: ----
                   tabPanel("Variables", br(),
                            h4("Variable 1"),
                            plotOutput("plot_v1", height = "auto"),
                            h4("Variable 2"),
                            plotOutput("plot_v2", height = "auto")),
                   
                   ### Shared TS plot: START ----
                   tabPanel("Time series", br(),
                            #Choose a correlation method 
                            radioButtons(inputId  = "cor_method_ts",
                                         label    = "Choose a correlation method:",
                                         choices  = c("pearson", "spearman"),
                                         selected = "pearson" , inline = TRUE),
                            textOutput("correlation_r_value"),
                            plotOutput("correlation_ts",click = "ts_click3", dblclick = "ts_dblclick3", brush = brushOpts(id = "ts_brush3",resetOnNew = TRUE)),
                            
                      #### Customization panels START ----       
                      fluidRow(
                        
                      #### Time series customization ----
                      column(width = 4,
                             h4(helpText("Customize your time series")),  
                             
                             checkboxInput(inputId = "custom_ts3",
                                           label   = "Time series customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden( 
                               div(id = "hidden_custom_ts3",
                                   radioButtons(inputId  = "title_mode_ts3",
                                                label    = "Title customization:",
                                                choices  = c("Default", "Custom"),
                                                selected = "Default" ,
                                                inline = TRUE),
                                   
                                   shinyjs::hidden( 
                                     div(id = "hidden_custom_title_ts3",
                                         
                                         textInput(inputId     = "title1_input_ts3",
                                                   label       = "Custom plot title:", 
                                                   value       = NA,
                                                   width       = NULL,
                                                   placeholder = "Custom title")
                                     )),
                                   
                                   checkboxInput(inputId = "show_key_ts3",
                                                 label   = "Show key",
                                                 value   = FALSE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_key_position_ts3",
                                         radioButtons(inputId  = "key_position_ts3",
                                                      label    = "Key position:",
                                                      choiceNames  = c("top left", "top right","bottom left","bottom right"),
                                                      choiceValues = c("topleft", "topright","bottomleft","bottomright"),
                                                      selected = "topright" ,
                                                      inline = TRUE))),
                               )),    
                      ),
                      
                      #### Add Custom features (points, highlights, lines) ----                        
                      column(width = 4,
                             h4(helpText("Custom features")),
                             
                             checkboxInput(inputId = "custom_features_ts3",
                                           label   = "Enable custom features",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_features_ts3",
                                   radioButtons(inputId      = "feature_ts3",
                                                label        = "Select a feature type:",
                                                inline       = TRUE,
                                                choices      = c("Point", "Highlight", "Line")),
                                   
                                   #Custom Points
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_points_ts3",
                                         h5(helpText("Add custom points")),
                                         h6(helpText("Enter position manually or click on plot")),
                                         
                                         textInput(inputId = "point_label_ts3", 
                                                   label   = "Point label:",
                                                   value   = ""),
                                         
                                         column(width = 12, offset = 0,
                                                column(width = 6,
                                                       textInput(inputId = "point_location_x_ts3", 
                                                                 label   = "Point x position:",
                                                                 value   = "")
                                                ),
                                                column(width = 6,
                                                       textInput(inputId = "point_location_y_ts3", 
                                                                 label   = "Point y position:",
                                                                 value   = "")
                                                )),
                                         
                                         
                                         radioButtons(inputId      = "point_shape_ts3",
                                                      label        = "Point shape:",
                                                      inline       = TRUE,
                                                      choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                         
                                         colourInput(inputId = "point_colour_ts3", 
                                                     label   = "Point colour:",
                                                     showColour = "background",
                                                     palette = "limited"),                        
                                         
                                         
                                         numericInput(inputId = "point_size_ts3",
                                                      label   = "Point size",
                                                      value   = 1,
                                                      min     = 1,
                                                      max     = 10),
                                         
                                         column(width = 12,
                                                
                                                actionButton(inputId = "add_point_ts3",
                                                             label = "Add point"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_point_ts3",
                                                             label = "Remove last point"),
                                                actionButton(inputId = "remove_all_points_ts3",
                                                             label = "Remove all points")),
                                     )),
                                   
                                   #Custom highlights
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_highlights_ts3",
                                         h5(helpText("Add custom highlights")),
                                         h6(helpText("Enter values manually or draw a box on plot")),
                                         
                                         numericRangeInput(inputId = "highlight_x_values_ts3",
                                                           label  = "X values:",
                                                           value  = "",
                                                           min    = -180,
                                                           max    = 180),
                                         
                                         numericRangeInput(inputId = "highlight_y_values_ts3",
                                                           label  = "Y values:",
                                                           value  = "",
                                                           min    = -90,
                                                           max    = 90),
                                         
                                         colourInput(inputId = "highlight_colour_ts3", 
                                                     label   = "Highlight colour:",
                                                     showColour = "background",
                                                     palette = "limited"),
                                         
                                         radioButtons(inputId      = "highlight_type_ts3",
                                                      label        = "Type for highlight:",
                                                      inline       = TRUE,
                                                      choiceNames  = c("Fill \u25FC", "Box \u25FB", "Hatched \u25A8"),
                                                      choiceValues = c("Fill","Box","Hatched")),
                                         
                                         checkboxInput(inputId = "show_highlight_on_legend_ts3",
                                                       label   = "Show on legend",
                                                       value   = FALSE),
                                         
                                         textInput(inputId = "highlight_label_ts3", 
                                                   label   = "Label:",
                                                   value   = ""),
                                         
                                         
                                         column(width = 12,
                                                actionButton(inputId = "add_highlight_ts3",
                                                             label = "Add highlight"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_highlight_ts3",
                                                             label = "Remove last highlight"),
                                                actionButton(inputId = "remove_all_highlights_ts3",
                                                             label = "Remove all highlights")),
                                         
                                     )),
                                   
                                   #Custom lines
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_line_ts3",
                                         h5(helpText("Add custom lines")),
                                         h6(helpText("Enter position manually or click on plot, double click to change orientation")),
                                         
                                         radioButtons(inputId      = "line_orientation_ts3",
                                                      label        = "Orientation:",
                                                      inline       = TRUE,
                                                      choices      = c("Vertical", "Horizontal")),
                                         
                                         textInput(inputId = "line_position_ts3", 
                                                   label   = "Position:",
                                                   value   = "",
                                                   placeholder = "1830, 1832"),
                                         
                                         colourInput(inputId = "line_colour_ts3", 
                                                     label   = "Line colour:",
                                                     showColour = "background",
                                                     palette = "limited"),
                                         
                                         radioButtons(inputId      = "line_type_ts3",
                                                      label        = "Type:",
                                                      inline       = TRUE,
                                                      choices = c("solid", "dashed")),
                                         
                                         checkboxInput(inputId = "show_line_on_legend_ts3",
                                                       label   = "Show on legend",
                                                       value   = FALSE),
                                         
                                         textInput(inputId = "line_label_ts3", 
                                                   label   = "Label:",
                                                   value   = ""),
                                         
                                         column(width = 12,
                                                actionButton(inputId = "add_line_ts3",
                                                             label = "Add line"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_line_ts3",
                                                             label = "Remove last line"),
                                                actionButton(inputId = "remove_all_lines_ts3",
                                                             label = "Remove all lines")
                                         )
                                     ))
                               ))),
                      
                      #### Custom statistics ----
                      column(width = 4,
                             h4(helpText("Custom statistics")),
                             
                             checkboxInput(inputId = "enable_custom_statistics_ts3",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_statistics_ts3",
                                   
                                   checkboxInput(inputId = "custom_average_ts3",
                                                 label = "Add a moving averages",
                                                 value = FALSE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_moving_average_ts3",  
                                         numericInput(inputId = "year_moving_ts3",
                                                      label  = "Year moving average, centred:",
                                                      value  = 11,
                                                      min    = 3,
                                                      max    = 30),
                                         
                                         radioButtons(inputId   = "year_position_ts3",
                                                      label     = "Position for each year:"  ,
                                                      choices   = c("before", "on", "after"),
                                                      selected  = "on",
                                                      inline    = TRUE)
                                     )),
                                   
                               )),
                      ),
                      
                      #### Customization panels END ----
                    ),         
                    
                   ### Shared TS plot: End ----          
                  ),
                   
                   ### Map plot: START ----
                   tabPanel("Correlation map", br(),
                            #Choose a correlation method 
                            radioButtons(inputId  = "cor_method_map",
                                         label    = "Choose a correlation method:",
                                         choices  = c("pearson", "spearman"),
                                         selected = "pearson" , inline = TRUE),
                            plotOutput("correlation_map", height = "auto", dblclick = "map_dblclick3", brush = brushOpts(id = "map_brush3",resetOnNew = TRUE)),
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,
                             h4(helpText("Customize your map")),  
                             
                             checkboxInput(inputId = "custom_map3",
                                           label   = "Map customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_maps3",
                                   
                                   radioButtons(inputId  = "axis_mode3",
                                                label    = "Axis customization:",
                                                choices  = c("Default", "Custom"),
                                                selected = "Default" , inline = TRUE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_axis3",
                                         
                                         numericRangeInput(inputId    = "axis_input3",
                                                           label      = "Set your axis values:",
                                                           value      = c(NULL, NULL),
                                                           separator  = " to ",
                                                           min        = -Inf,
                                                           max        = Inf))),
                                   
                                   checkboxInput(inputId = "hide_axis3",
                                                 label   = "Hide axis completely",
                                                 value   = FALSE),
                                   
                                   br(),
                                   
                                   radioButtons(inputId  = "title_mode3",
                                                label    = "Title customization:",
                                                choices  = c("Default", "Custom"),
                                                selected = "Default" , inline = TRUE),
                                   
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_title3",
                                         
                                         textInput(inputId     = "title1_input3",
                                                   label       = "Custom map title:", 
                                                   value       = NA,
                                                   width       = NULL,
                                                   placeholder = "Custom title")))
                               )),
                      ),
                      
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,
                             h4(helpText("Custom features")),
                             
                             checkboxInput(inputId = "custom_features3",
                                           label   = "Enable custom features",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_features3",
                                   radioButtons(inputId      = "feature3",
                                                label        = "Select a feature type:",
                                                inline       = TRUE,
                                                choices      = c("Point", "Highlight")),
                                   
                                   #Custom Points
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_points3",
                                         h5(helpText("Add custom points")),
                                         h6(helpText("Enter location/coordinates or double click on map")),
                                         
                                         textInput(inputId = "location3", 
                                                   label   = "Enter a location:",
                                                   value   = NULL,
                                                   placeholder = "e.g. Bern"),
                                         
                                         actionButton(inputId = "search3",
                                                      label   = "Search"),
                                         
                                         
                                         shinyjs::hidden(div(id = "inv_location3",
                                                             h6(helpText("Invalid location"))
                                         )),
                                         
                                         textInput(inputId = "point_label3", 
                                                   label   = "Point label:",
                                                   value   = ""),
                                         
                                         column(width = 12, offset = 0,
                                                column(width = 6,
                                                       textInput(inputId = "point_location_x3", 
                                                                 label   = "Point longitude:",
                                                                 value   = "")
                                                ),
                                                column(width = 6,
                                                       textInput(inputId = "point_location_y3", 
                                                                 label   = "Point latitude:",
                                                                 value   = "")
                                                )),
                                         
                                         radioButtons(inputId      = "point_shape3",
                                                      label        = "Point shape:",
                                                      inline       = TRUE,
                                                      choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                         
                                         colourInput(inputId = "point_colour3", 
                                                     label   = "Point colour:",
                                                     showColour = "background",
                                                     palette = "limited"),                       
                                         
                                         
                                         numericInput(inputId = "point_size3",
                                                      label   = "Point size:",
                                                      value   = 1,
                                                      min     = 1,
                                                      max     = 10),
                                         
                                         column(width = 12,
                                                
                                                actionButton(inputId = "add_point3",
                                                             label = "Add point"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_point3",
                                                             label = "Remove last point"),
                                                actionButton(inputId = "remove_all_points3",
                                                             label = "Remove all points")),
                                     )),
                                   
                                   #Custom Highlights
                                   shinyjs::hidden(
                                     div(id = "hidden_custom_highlights3",
                                         h5(helpText("Add custom highlights")),
                                         h6(helpText("Enter coordinate or draw a box on map")),
                                         
                                         numericRangeInput(inputId = "highlight_x_values3",
                                                           label  = "Longitude:",
                                                           value  = "",
                                                           min    = -180,
                                                           max    = 180),
                                         
                                         numericRangeInput(inputId = "highlight_y_values3",
                                                           label  = "Latitude:",
                                                           value  = "",
                                                           min    = -90,
                                                           max    = 90),
                                         
                                         colourInput(inputId = "highlight_colour3", 
                                                     label   = "Highlight colour:",
                                                     showColour = "background",
                                                     palette = "limited"),
                                         
                                         radioButtons(inputId      = "highlight_type3",
                                                      label        = "Type for highlight:",
                                                      inline       = TRUE,
                                                      choiceNames  = c("Box \u25FB", "Hatched \u25A8"),
                                                      choiceValues = c("Box","Hatched")),
                                         
                                         
                                         column(width = 12,
                                                actionButton(inputId = "add_highlight3",
                                                             label = "Add highlight"),
                                                br(), br(), br(),
                                                actionButton(inputId = "remove_last_highlight3",
                                                             label = "Remove last highlight"),
                                                actionButton(inputId = "remove_all_highlights3",
                                                             label = "Remove all highlights")),
                                     )),
                               )),
                      ),
                      
                      #### Custom statistics ----
                      column(width = 4#,
                             #h4(helpText("Custom statistics")),
                             
                             #checkboxInput(inputId = "enable_custom_statistics3",
                            #               label   = "Enable custom statistics",
                            #               value   = FALSE),
                            # 
                             #shinyjs::hidden(
                              # div(id = "hidden_custom_statistics3",
                               #    h5(helpText("Choose custom statistic:")),
                                   
                                #   radioButtons(inputId      = "custom_statistic3",
                                 #               label        = NULL,
                                  #              inline       = TRUE,
                                   #             choices      = c("% sign match")),
                                   
                                  # div(id = "hidden_sign_match3",  
                                   #    numericInput(inputId = "percentage_sign_match3",
                                    #                label  = "% of years with matching sign:",
                                     #               value  = 90,
                                      #              min    = 1,
                                       #             max    = 100)
                              #     ),
                              # )),
                      ),
                      #### Customization panels END ----
                    ),      
                    
                   ### Map plot: END ----        
                            ),
                   
                   ### Other plots ----
                   tabPanel("Time series data", br(), column(width = 3, dataTableOutput("correlation_ts_data"))),
                   tabPanel("Correlation map data",br(), tableOutput("correlation_map_data")),
             
                   ### Feedback archive documentation (FAD) ----
                   tabPanel("ModE-RA sources", br(),
                            shinyjs::hidden(
                            div(id = "hidden_v1_fad",
                            fluidRow(
                              h4("Variable 1"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a3a",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              h4(helpText("Draw a box on the left map to use zoom function")),
                            ),
                            
                            div(id = "fad_map_a3a",
                                splitLayout(
                                  plotOutput("fad_winter_map_a3a",
                                             brush = brushOpts(
                                               id = "brush_fad1a3a",
                                               resetOnNew = TRUE
                                             )),
                                  
                                  plotOutput("fad_zoom_winter_a3a")
                                )),
                            
                            div(id = "fad_map_b3a",
                                splitLayout(plotOutput("fad_summer_map_a3a",
                                                       brush = brushOpts(
                                                         id = "brush_fad1b3a",
                                                         resetOnNew = TRUE
                                                       )),
                                            plotOutput("fad_zoom_summer_a3a")
                                )),

                            )),
                            
                            br(),
                            shinyjs::hidden(
                            div(id = "hidden_v2_fad",
                            fluidRow(
                              h4("Variable 2"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a3b",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              h4(helpText("Draw a box on the left map to use zoom function")),
                            ),
                            
                            div(id = "fad_map_a3b",
                                splitLayout(
                                  plotOutput("fad_winter_map_a3b",
                                             brush = brushOpts(
                                               id = "brush_fad1a3b",
                                               resetOnNew = TRUE
                                             )),
                                  
                                  plotOutput("fad_zoom_winter_a3b")
                                )),
                            
                            div(id = "fad_map_b3b",
                                splitLayout(plotOutput("fad_summer_map_a3b",
                                                       brush = brushOpts(
                                                         id = "brush_fad1b3b",
                                                         resetOnNew = TRUE
                                                       )),
                                            plotOutput("fad_zoom_summer_a3b")
                                )),

                            )),
                   ),
             
                   ### Downloads ----
                   tabPanel("Downloads",
                            verticalLayout(br(),
                                           h3(helpText("Time series download")),
                                           radioButtons(inputId = "file_type_timeseries3", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                           downloadButton(outputId = "download_timeseries3", label = "Download"), br(),
                                           h3(helpText("Correlation map download")),
                                           radioButtons(inputId = "file_type_map3", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                           downloadButton(outputId = "download_map3", label = "Download"), br(),
                                           h3(helpText("Time series data download")),
                                           radioButtons(inputId = "file_type_timeseries_data3", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                           downloadButton(outputId = "download_timeseries_data3", label = "Download"), br(),
                                           h3(helpText("Correlation map data download")),
                                           radioButtons(inputId = "file_type_map_data3", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                           downloadButton(outputId = "download_map_data3", label = "Download")), br(),
                                            h3(helpText("ModE-RA sources download")),
                                            shinyjs::hidden(
                                              div(id = "hidden_v1_fad_download",
                                            fluidRow(
                                              h4("Variable 1"),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_a3a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_wa3a", label = "Download Oct. - Mar")),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_b3a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_sa3a", label = "Download Apr. - Sept")),
                                            ))),
                                            br(),
                                            shinyjs::hidden(
                                              div(id = "hidden_v2_fad_download",
                                            fluidRow(
                                              h4("Variable 2"),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_a3b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_wa3b", label = "Download Oct. - Mar")),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_b3b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_sa3b", label = "Download Apr. - Sept")),
                                            ))),
                   )

               ## Main Panel END ----
               ), width = 8)
               
# Correlation END ----  
          )),

# Regression START ----
tabPanel("Regression", id = "tab4",
         shinyjs::useShinyjs(),
         sidebarLayout(
           ## Sidebar Panels START ----          
           sidebarPanel(verticalLayout(
             ### First Sidebar panel (Independent variable) ----
             sidebarPanel(fluidRow(
               
               #Short description of the General Panel        
               h4(helpText("Independent variable")),
               
               #Choose a data source: ME or USer 
               radioButtons(inputId  = "source_iv",
                            label    = "Choose a data source:",
                            choices  = c("ModE-", "User Data"),
                            selected = "ModE-" ,
                            inline = TRUE),
               
               # Upload user data
               shinyjs::hidden(
                 div(id = "upload_forcings_iv",   
                     fileInput(inputId = "user_file_iv",
                               label = "Upload time series data in .csv or .xlsx format:",
                               multiple = FALSE,
                               accept = c(".csv", ".xlsx", ".xls"),
                               width = NULL,
                               buttonLabel = "Browse your folders",
                               placeholder = "No file selected"),
                     
                     div(id = "upload_example_iv",
                         img(src = 'pics/regcor_user_example.jpg', id = "reg_user_example_iv", height = "150px", width = "150px"))
                 )),
               
               #Choose a variable (USER)
               shinyjs::hidden(
                 div(id = "hidden_user_variable_iv",
                    pickerInput(inputId  = "user_variable_iv",
                                 label    = "Choose a variable:",
                                 choices  = NULL,
                                 selected = NULL,
                                 multiple = TRUE),
                 )),
               
               #Choose one of three datasets (Select) 
               shinyjs::hidden(
               div(id = "hidden_me_variable_dataset_iv",
               selectInput(inputId  = "dataset_selected_iv",
                           label    = "Choose a dataset:",
                           choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                           selected = "ModE-RA"),
               
               #Choose a variable (Mod-ERA) 
               pickerInput(inputId  = "ME_variable_iv",
                           label    = "Choose one or multiple variables:",
                           choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                           selected = "Temperature",
                           multiple = TRUE),
               )),
               
               shinyjs::hidden(
                 div(id = "hidden_modera_variable_iv",
                     
                     #Choose a Mode: Absolute or Anomaly 
                     radioButtons(inputId  = "mode_selected_iv",
                                  label    = "Choose a mode:",
                                  choices  = c("Anomaly", "Absolute"),
                                  selected = "Anomaly" ,
                                  inline = TRUE),
                     
                     #Choose Season, Year or Months
                     radioButtons(inputId  = "season_selected_iv",
                                  label    = "Select the range of months:",
                                  choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                  selected = "Annual" ,
                                  inline = TRUE),
                     
                     #Choose your range of months (Slider)
                     shinyjs::hidden(
                       div(id = "season_iv",
                           sliderTextInput(inputId = "range_months_iv",
                                           label = "Select custom months:",
                                           choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                           #Initially selected = 1 year (annual mean)
                                           selected = c("January", "December")),
                       )), 
                     
                     #Choose reference period if Anomaly values are chosen (Hidden object)      
                     shinyjs::hidden(
                       div(id = "optional_iv",
                           hidden(
                           numericRangeInput(inputId = "ref_period_iv",
                                             label      = "Reference period:",
                                             value      = c(1961,1990),
                                             separator  = " to ",
                                             min        = 1422,
                                             max        = 2008)),
                           
                           #Choose single ref year
                           column(12,
                                  checkboxInput(inputId = "ref_single_year_iv",
                                                label   = "Select single year",
                                                value   = FALSE)),
                           
                           
                           hidden(
                             numericInput(inputId   = "ref_period_sg_iv",
                                          label     = "Select the single year:",
                                          value     = NA,
                                          min       = 1422,
                                          max       = 2008)),
                           
                       )),
                     
                     #Choose Coordinates input 
                     radioButtons(inputId  = "coordinates_type_iv",
                                  label    = "Choose input of coordinates:",
                                  choices  = c("Manual", "Continents"),
                                  selected = "Manual" ,
                                  inline = TRUE),
                     
                     shinyjs::hidden(
                       div(id = "hidden_continents_iv",
                           column(width = 12, fluidRow(      
                             #Global Button
                             actionButton(inputId = "button_global_iv",
                                          label = "Global",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Europe Button
                             actionButton(inputId = "button_europe_iv",
                                          label = "Europe",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Asia Button
                             actionButton(inputId = "button_asia_iv",
                                          label = "Asia",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Oceania Button
                             actionButton(inputId = "button_oceania_iv",
                                          label = "Oceania",
                                          width = "110px"),
                             
                           )),
                           
                           column(width = 12, br()),
                           
                           column(width = 12, fluidRow(
                             
                             #Africa Button
                             actionButton(inputId = "button_africa_iv",
                                          label = "Africa",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #North America Button
                             actionButton(inputId = "button_n_america_iv",
                                          label = "North America",
                                          width = "150px"),
                             
                             br(), br(),
                             
                             #South America Button
                             actionButton(inputId = "button_s_america_iv",
                                          label = "South America",
                                          width = "150px")
                           )),
                           
                           column(width = 12, br()),
                           
                       )),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_longitude_iv",
                                       label = "Longitude range (-180 to 180):",
                                       value = c(4,12),
                                       separator = " to ",
                                       min = -180,
                                       max = 180),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_latitude_iv",
                                       label = "Latitude range (-90 to 90):",
                                       value = c(43,50),
                                       separator = " to ",
                                       min = -90,
                                       max = 90),
                     
                     #Enter Coordinates
                     actionButton(inputId = "button_coord_iv",
                                  label = "Update coordinates",
                                  width = "200px"),
                     
                 )),
               
               
             ), width = 12),
             
             br(),
             
             ### Second Sidebar panel (Year range) ----
             
             sidebarPanel(fluidRow(
               #Choose your year of interest   
               hidden(
               numericRangeInput(inputId    = "range_years4",
                                 label     = "Select the range of years (1422-2008):",
                                 value     = c(1900,2000),
                                 separator = " to ",
                                 min       = 1422,
                                 max       = 2008)),
               
               #Choose single year
               column(12,
                      checkboxInput(inputId = "single_year4",
                                    label   = "Select single year",
                                    value   = FALSE)),
               
               
               hidden(
                 numericInput(inputId   = "range_years_sg4",
                              label     = "Select the single year:",
                              value     = NA,
                              min       = 1422,
                              max       = 2008)),
               
             ), width = 12),
             
             br(),
             
             ### Third Sidebar panel (Dependent variable) ----
             
             sidebarPanel(fluidRow(
               #Short description of the General Panel        
               h4(helpText("Dependent variable")),
               
               #Choose a data source: ME or USer 
               radioButtons(inputId  = "source_dv",
                            label    = "Choose a data source:",
                            choices  = c("ModE-", "User Data"),
                            selected = "ModE-" ,
                            inline = TRUE),

               # Upload user data
               shinyjs::hidden(
                 div(id = "upload_forcings_dv", 
                     fileInput(inputId = "user_file_dv",
                               label = "Upload time series data in .csv or .xlsx format:",
                               multiple = FALSE,
                               accept = c(".csv", ".xlsx", ".xls"),
                               width = NULL,
                               buttonLabel = "Browse your folders",
                               placeholder = "No file selected"),
                     
                     div(id = "upload_example_dv",
                         img(src = 'pics/regcor_user_example.jpg', id = "reg_user_example_dv", height = "150px", width = "150px")),
                 )),
               
               #Choose a variable (USER)
               shinyjs::hidden(
                 div(id = "hidden_user_variable_dv",
                     selectInput(inputId  = "user_variable_dv",
                                 label    = "Choose a variable:",
                                 choices  = NULL,
                                 selected = NULL),
                 )),
               

               shinyjs::hidden(
               div(id = "hidden_me_variable_dataset_dv",
                     
                 #Choose one of three datasets (Select)                
                 selectInput(inputId  = "dataset_selected_dv",
                             label    = "Choose a dataset:",
                             choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                             selected = "ModE-RA"),
                 
                 #Choose a variable (Mod-ERA) 
                 selectInput(inputId  = "ME_variable_dv",
                             label    = "Choose a variable:",
                             choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                             selected = "Temperature"),
                 )),
               
               shinyjs::hidden(
                 div(id = "hidden_modera_variable_dv",
                     
                     #Choose a Mode: Absolute or Anomaly 
                     radioButtons(inputId  = "mode_selected_dv",
                                  label    = "Choose a mode:",
                                  choices  = c("Anomaly", "Absolute"),
                                  selected = "Anomaly" ,
                                  inline = TRUE),
                     
                     #Choose Season, Year or Months
                     radioButtons(inputId  = "season_selected_dv",
                                  label    = "Select the range of months:",
                                  choices  = c("Annual", "DJF", "MAM", "JJA", "SON", "Custom"),
                                  selected = "Annual" ,
                                  inline = TRUE),
                     
                     #Choose your range of months (Slider)
                     shinyjs::hidden(
                       div(id = "season_dv",
                           sliderTextInput(inputId = "range_months_dv",
                                           label = "Select custom months:",
                                           choices = c("December (prev.)", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"),
                                           #Initially selected = 1 year (annual mean)
                                           selected = c("January", "December")),
                       )), 
                     
                     #Choose reference period if Anomaly values are chosen (Hidden object)      
                     shinyjs::hidden(
                       div(id = "optional_dv",
                           
                           hidden(
                           numericRangeInput(inputId = "ref_period_dv",
                                             label      = "Reference period:",
                                             value      = c(1961,1990),
                                             separator  = " to ",
                                             min        = 1422,
                                             max        = 2008)),
                           
                           #Choose single ref year
                           column(12,
                                  checkboxInput(inputId = "ref_single_year_dv",
                                                label   = "Select single year",
                                                value   = FALSE)),
                           
                           
                           hidden(
                             numericInput(inputId   = "ref_period_sg_dv",
                                          label     = "Select the single year:",
                                          value     = NA,
                                          min       = 1422,
                                          max       = 2008)),
                           
                           )),
                     
                     #Choose Coordinates input 
                     radioButtons(inputId  = "coordinates_type_dv",
                                  label    = "Choose input of coordinates:",
                                  choices  = c("Manual", "Continents"),
                                  selected = "Manual" ,
                                  inline = TRUE),
                     
                     shinyjs::hidden(
                       div(id = "hidden_continents_dv",
                           column(width = 12, fluidRow(      
                             #Global Button
                             actionButton(inputId = "button_global_dv",
                                          label = "Global",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Europe Button
                             actionButton(inputId = "button_europe_dv",
                                          label = "Europe",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Asia Button
                             actionButton(inputId = "button_asia_dv",
                                          label = "Asia",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #Oceania Button
                             actionButton(inputId = "button_oceania_dv",
                                          label = "Oceania",
                                          width = "110px"),
                             
                           )),
                           
                           column(width = 12, br()),
                           
                           column(width = 12, fluidRow(
                             
                             #Africa Button
                             actionButton(inputId = "button_africa_dv",
                                          label = "Africa",
                                          width = "100px"),
                             
                             br(), br(),
                             
                             #North America Button
                             actionButton(inputId = "button_n_america_dv",
                                          label = "North America",
                                          width = "150px"),
                             
                             br(), br(),
                             
                             #South America Button
                             actionButton(inputId = "button_s_america_dv",
                                          label = "South America",
                                          width = "150px")
                           )),
                           
                           column(width = 12, br()),
                           
                       )),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_longitude_dv",
                                       label = "Longitude range (-180 to 180):",
                                       value = initial_lon_values,
                                       separator = " to ",
                                       min = -180,
                                       max = 180),
                     
                     #Choose Longitude and Latitude Range          
                     numericRangeInput(inputId = "range_latitude_dv",
                                       label = "Latitude range (-90 to 90):",
                                       value = initial_lat_values,
                                       separator = " to ",
                                       min = -90,
                                       max = 90),
                     
                     #Enter Coordinates
                     actionButton(inputId = "button_coord_dv",
                                  label = "Update coordinates",
                                  width = "200px"),
                 )),
               
             ), width = 12)
             
           ## Sidebar Panels END ----
           )),
           ## Main Panel START ---- ----
           mainPanel(tabsetPanel(
             ### Independent / dependent variable ----
             tabPanel("Variables", br(),
                      h4("Independent variable"),
                      plotOutput("plot_iv", height = "auto"),
                      h4("Dependent variable"),
                      plotOutput("plot_dv", height = "auto")
             ),
             
             ### Regression time series and summary----
             tabPanel("Regression time series",
                      plotOutput("plot_reg_ts1"),
                      plotOutput("plot_reg_ts2"),
                      br(),
                      splitLayout(
                        column(width = 4,
                               dataTableOutput("data_reg_ts")),
                              verticalLayout(       
                              h4("Statistical summary"),
                              verbatimTextOutput("regression_summary_data")
                              )
                      )
             ),
             
             ### Regression coefficient ----
             tabPanel("Regression coefficient", br(),
                      selectInput(inputId  = "coeff_variable",
                                  label    = "Choose a variable:",
                                  choices  = NULL,
                                  selected = NULL),
                      plotOutput("plot_reg_coeff", height = "auto", brush = brushOpts(id = "map_brush4_coeff",resetOnNew = TRUE)),
                      br(),
                      tableOutput("data_reg_coeff")
             ),
             
             ### Regression pvalues ----
             tabPanel("Regression pvalues", br(),
                      selectInput(inputId  = "pvalue_variable",
                                  label    = "Choose a variable:",
                                  choices  = NULL,
                                  selected = NULL),
                      plotOutput("plot_reg_pval", height = "auto",brush = brushOpts(id = "map_brush4_pvalue",resetOnNew = TRUE)),
                      br(),
                      tableOutput("data_reg_pval")
             ),
             
             ### Regression residuals ----
             tabPanel("Regression residuals", br(),
                      fluidRow(
                        column(width=4,
                               numericInput(
                                 inputId  = "reg_resi_year",
                                 label   =  "Year",
                                 value = 2008,
                                 min = 1422,
                                 max = 2008)),
                      ),
                      plotOutput("plot_reg_resi", height = "auto",brush = brushOpts(id = "map_brush4_resi",resetOnNew = TRUE)),
                      br(),
                      tableOutput("data_reg_resi")
             ),

             ### Feedback archive documentation (FAD) ----
             tabPanel("ModE-RA sources", br(),
                      shinyjs::hidden(
                        div(id = "hidden_iv_fad",
                            fluidRow(
                              h4("Independent variable"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a4a",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              h4(helpText("Draw a box on the left map to use zoom function")),
                            ),
                            
                            div(id = "fad_map_a4a",
                                splitLayout(
                                  plotOutput("fad_winter_map_a4a",
                                             brush = brushOpts(
                                               id = "brush_fad1a4a",
                                               resetOnNew = TRUE
                                             )),
                                  
                                  plotOutput("fad_zoom_winter_a4a")
                                )),
                            
                            div(id = "fad_map_b4a",
                                splitLayout(plotOutput("fad_summer_map_a4a",
                                                       brush = brushOpts(
                                                         id = "brush_fad1b4a",
                                                         resetOnNew = TRUE
                                                       )),
                                            plotOutput("fad_zoom_summer_a4a")
                                )),
                        )),
                      
                      br(),
                      shinyjs::hidden(
                        div(id = "hidden_dv_fad",
                            fluidRow(
                              h4("Dependent variable"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a4b",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              h4(helpText("Draw a box on the left map to use zoom function")),
                            ),
                            
                            div(id = "fad_map_a4b",
                                splitLayout(
                                  plotOutput("fad_winter_map_a4b",
                                             brush = brushOpts(
                                               id = "brush_fad1a4b",
                                               resetOnNew = TRUE
                                             )),
                                  
                                  plotOutput("fad_zoom_winter_a4b")
                                )),
                            
                            div(id = "fad_map_b4b",
                                splitLayout(plotOutput("fad_summer_map_a4b",
                                                       brush = brushOpts(
                                                         id = "brush_fad1b4b",
                                                         resetOnNew = TRUE
                                                       )),
                                            plotOutput("fad_zoom_summer_a4b")
                                )),

                        )),
             ),
             
             ### Downloads ----
             tabPanel("Downloads",
                      verticalLayout(br(),
                                     
                                     div(id = "reg1",
                                         fluidRow(
                                           h3(helpText("Regression time series")), 
                                           column(width = 3,
                                                  radioButtons(inputId = "reg_ts_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                  downloadButton(outputId = "download_reg_ts_plot", label = "Download plot 1")),
                                           
                                           column(width = 3,
                                                  radioButtons(inputId = "reg_ts2_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                  downloadButton(outputId = "download_reg_ts2_plot", label = "Download plot 2")), 
                                           
                                           column(width = 3,
                                                  radioButtons(inputId = "reg_ts_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                                  downloadButton(outputId = "download_reg_ts_plot_data", label = "Download data")),
                                           
                                           column(width = 3,
                                                  h4("Statistical summary"),
                                                  downloadButton(outputId = "download_reg_sum_txt", label = "Download ")),
                                         )), br(),   

                                     div(id = "reg2",
                                     fluidRow(
                                     h3(helpText("Regression coefficient download")),
                                     column(width = 3, 
                                     radioButtons(inputId = "reg_coe_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                     downloadButton(outputId = "download_reg_coe_plot", label = "Download map")), 
                                     
                                     column(width = 3,
                                     radioButtons(inputId = "reg_coe_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                     downloadButton(outputId = "download_reg_coe_plot_data", label = "Download data")),
                                     )), br(),
                                     

                                     div(id = "reg3",
                                     fluidRow(
                                     h3(helpText("Regression pvalues download")),  
                                     column(width = 3,
                                     radioButtons(inputId = "reg_pval_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                     downloadButton(outputId = "download_reg_pval_plot", label = "Download map")), 
                                     
                                     column(width = 3,
                                            radioButtons(inputId = "reg_pval_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                            downloadButton(outputId = "download_reg_pval_plot_data", label = "Download data")),
                                     )), br(),
                                     

                                     div(id = "reg4",
                                     fluidRow(
                                     h3(helpText("Regression residuals download")),   
                                     column(width = 3,
                                     radioButtons(inputId = "reg_res_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                     downloadButton(outputId = "download_reg_res_plot", label = "Download map")), 
                                     
                                     column(width = 3,
                                            radioButtons(inputId = "reg_res_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                            downloadButton(outputId = "download_reg_res_plot_data", label = "Download data")),
                                     )), br(),
                                     ),
                                     
                                     h3(helpText("ModE-RA sources download")),
                                      shinyjs::hidden(
                                        div(id = "hidden_iv_fad_download",
                                            fluidRow(
                                              h4("Independent variable"),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_a4a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_wa4a", label = "Download Oct. - Mar")),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_b4a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_sa4a", label = "Download Apr. - Sept")),
                                            ))),
                                      br(),
                                      shinyjs::hidden(
                                        div(id = "hidden_dv_fad_download",
                                            fluidRow(
                                              h4("Dependent variable"),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_a4b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_wa4b", label = "Download Oct. - Mar")),
                                              column(width = 3,
                                                     radioButtons(inputId = "file_type_modera_source_b4b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                                     downloadButton(outputId = "download_fad_sa4b", label = "Download Apr. - Sept")),
                                            ))),
             )
             
           ## Main Panel END ----
           ), width = 8)

# Regression END ----
         )),


# Monthly timeseries START ----                             
tabPanel("Monthly Timeseries", id = "tab5",
         shinyjs::useShinyjs(),
         sidebarLayout(
           
           ## Sidebar Panels START ----          
           sidebarPanel(verticalLayout(
             
             ### First Sidebar panel (Variable and time selection) ----
             sidebarPanel(fluidRow(
               
               #Short description of the General Panel        
               h4(helpText("Creating monthly timeseries")),
               
               #Choose one of three datasets (Select)                
               selectInput(inputId  = "dataset_selected5",
                           label    = "Choose a dataset:",
                           choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                           selected = "ModE-RA"),
               
               #Choose one of four variable (Select)                
               selectInput(inputId  = "variable_selected5",
                           label    = "Choose a variable to plot:",
                           choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                           selected = "Temperature"),
               
               #Choose a Mode: Absolute or Anomaly 
               radioButtons(inputId  = "mode_selected5",
                            label    = "Choose a mode:",
                            choices  = c("Anomaly","Absolute"),
                            selected = "Anomaly" , inline = TRUE),
               
               #Choose your year of interest        
               textInput(inputId    = "range_years5",
                         label      = "Enter a year, list of years or range of years:",
                         value     = "1815",
                         placeholder = "1815 or 1815, 1816 or 1815-1817"),
               
               #Choose reference period if Anomaly values are chosen (Hidden object)      
               shinyjs::hidden(
                 div(id = "optional5",
                     hidden(
                     numericRangeInput(inputId = "ref_period5",
                                       label      = "Reference period:",
                                       value      = c(1961,1990),
                                       separator  = " to ",
                                       min        = 1422,
                                       max        = 2000)),
                     
                     #Choose single ref year
                     column(12,
                            checkboxInput(inputId = "ref_single_year5",
                                          label   = "Select single year",
                                          value   = FALSE)),
                     
                     
                     hidden(
                       numericInput(inputId   = "ref_period_sg5",
                                    label     = "Select the single year:",
                                    value     = NA,
                                    min       = 1422,
                                    max       = 2008)),
                 )),
               
               #Choose a Type of plot: Average or Individual years
               radioButtons(inputId  = "type_selected5",
                            label    = "Plot years as:",
                            choices  = c("Individual years","Average"),
                            selected = "Individual years" , inline = TRUE),
               
             ), width = 12), br(),
             
             ### Second sidebar panel (Location selection) ----
             sidebarPanel(fluidRow(
               
               #Short description of the Coord. Sidebar        
               h4(helpText("Choose a map or enter coordinates manually")),
               
               
               column(width = 12, fluidRow(      
                 #Global Button
                 actionButton(inputId = "button_global5",
                              label = "Global",
                              width = "100px"),
                 
                 br(), br(),
                 
                 #Europe Button
                 actionButton(inputId = "button_europe5",
                              label = "Europe",
                              width = "100px"),
                 
                 br(), br(),
                 
                 #Asia Button
                 actionButton(inputId = "button_asia5",
                              label = "Asia",
                              width = "100px"),
                 
                 br(), br(),
                 
                 #Oceania Button
                 actionButton(inputId = "button_oceania5",
                              label = "Oceania",
                              width = "110px"),
                 
               )),
               
               column(width = 12, br()),
               
               column(width = 12, fluidRow(
                 
                 #Africa Button
                 actionButton(inputId = "button_africa5",
                              label = "Africa",
                              width = "100px"),
                 
                 br(), br(),
                 
                 #North America Button
                 actionButton(inputId = "button_n_america5",
                              label = "North America",
                              width = "150px"),
                 
                 br(), br(),
                 
                 #South America Button
                 actionButton(inputId = "button_s_america5",
                              label = "South America",
                              width = "150px")
               )),
               
               column(width = 12, br()),
               
               #Choose Longitude and Latitude Range          
               numericRangeInput(inputId = "range_longitude5",
                                 label = "Longitude range (-180/180):",
                                 value = initial_lon_values,
                                 separator = " to ",
                                 min = -180,
                                 max = 180),
               
               
               #Choose Longitude and Latitude Range          
               numericRangeInput(inputId = "range_latitude5",
                                 label = "Latitude range (-90/90):",
                                 value = initial_lat_values,
                                 separator = " to ",
                                 min = -90,
                                 max = 90),
               
               # #Enter Coordinates
               # actionButton(inputId = "button_coord5",
               #              label = "Update coordinates",
               #              width = "200px"),
               # 
               # br(), br(),
               
               column(width = 12, fluidRow(
               
               #Add timeseries to graph
               actionButton(inputId = "add_monthly_ts",
                            label = "Add to graph",
                            width = "150px"),
               
               br(), br(),
               
               #Remove last timeseries
               actionButton(inputId = "remove_last_monthly_ts",
                            label = "Remove last TS",
                            width = "150px"),
               
               br(), br(),
               
               #Remove all timeseries
               actionButton(inputId = "remove_all_monthly_ts",
                            label = "Remove all TS",
                            width = "150px"),
               
               )),
               
             ), width = 12),
             
             ## Sidebar Panels END ----
           )),
           
           ## Main Panel START ----
           mainPanel(tabsetPanel(
             
             ### TS plot START ----
             tabPanel("Time series", plotOutput("timeseries5", click = "ts_click5",dblclick = "ts_dblclick5",brush = brushOpts(id = "ts_brush5",resetOnNew = TRUE)),
                      #### Customization panels START ----       
                      fluidRow(
                        #### Time series customization ----
                        column(width = 4,
                               h4(helpText("Customize your time series")),  
                               
                               checkboxInput(inputId = "custom_ts5",
                                             label   = "Time series customization",
                                             value   = FALSE),
                               
                               shinyjs::hidden( 
                                 div(id = "hidden_custom_ts5",
                                     radioButtons(inputId  = "title_mode_ts5",
                                                  label    = "Title customization:",
                                                  choices  = c("Default", "Custom"),
                                                  selected = "Default" ,
                                                  inline = TRUE),
                                     
                                     shinyjs::hidden( 
                                       div(id = "hidden_custom_title_ts5",
                                           
                                           textInput(inputId     = "title1_input_ts5",
                                                     label       = "Custom map title:", 
                                                     value       = NA,
                                                     width       = NULL,
                                                     placeholder = "Custom title")
                                       )),
                                     
                                     radioButtons(inputId  = "main_key_position_ts5",
                                                  label    = "Key position:",
                                                  choiceNames  = c("top left", "top right","bottom left","bottom right"),
                                                  choiceValues = c("topleft", "topright","bottomleft","bottomright"),
                                                  selected = "topright" ,
                                                  inline = TRUE),
                                     
                                     checkboxInput(inputId = "show_key_ts5",
                                                   label   = "Show feature key",
                                                   value   = FALSE),
                                     
                                     shinyjs::hidden(
                                       div(id = "hidden_key_position_ts5",
                                           radioButtons(inputId  = "key_position_ts5",
                                                        label    = "Feature key position:",
                                                        choiceNames  = c("top left", "bottom left","bottom right"),
                                                        choiceValues = c("topleft","bottomleft","bottomright"),
                                                        selected = "topleft" ,
                                                        inline = TRUE))),
                                     
                                     
                                 )),    
                        ),
                        
                        #### Add Custom features (points, highlights, lines) ----                        
                        column(width = 4,
                               h4(helpText("Custom features")),

                               checkboxInput(inputId = "custom_features_ts5",
                                             label   = "Enable custom features",
                                             value   = FALSE),
                                  
                               shinyjs::hidden(
                                 div(id = "hidden_custom_features_ts5",
                                     radioButtons(inputId      = "feature_ts5",
                                                  label        = "Select a feature type:",
                                                  inline       = TRUE,
                                                  choices      = c("Point", "Highlight", "Line")),
                                     
                                     #Custom Points
                                     shinyjs::hidden(
                                       div(id = "hidden_custom_points_ts5",
                                           h5(helpText("Add custom points")),
                                           h6(helpText("Enter position manually or click on plot")),
                                           
                                           textInput(inputId = "point_label_ts5", 
                                                     label   = "Point label:",
                                                     value   = ""),
                                           
                                           column(width = 12, offset = 0,
                                                  column(width = 6,
                                                         textInput(inputId = "point_location_x_ts5", 
                                                                   label   = "Point x position:",
                                                                   value   = "")
                                                  ),
                                                  column(width = 6,
                                                         textInput(inputId = "point_location_y_ts5", 
                                                                   label   = "Point y position:",
                                                                   value   = "")
                                                  )),
                                           
                                           
                                           radioButtons(inputId      = "point_shape_ts5",
                                                        label        = "Point shape:",
                                                        inline       = TRUE,
                                                        choices      = c("\u25CF", "\u25B2", "\u25A0")),
                                           
                                           colourInput(inputId = "point_colour_ts5", 
                                                       label   = "Point colour:",
                                                       showColour = "background",
                                                       palette = "limited"),                        
                                           
                                           
                                           numericInput(inputId = "point_size_ts5",
                                                        label   = "Point size",
                                                        value   = 1,
                                                        min     = 1,
                                                        max     = 10),
                                           
                                           column(width = 12,
                                                  
                                                  actionButton(inputId = "add_point_ts5",
                                                               label = "Add point"),
                                                  br(), br(), br(),
                                                  actionButton(inputId = "remove_last_point_ts5",
                                                               label = "Remove last point"),
                                                  actionButton(inputId = "remove_all_points_ts5",
                                                               label = "Remove all points")),
                                       )),
                                     
                                     #Custom highlights
                                     shinyjs::hidden(
                                       div(id = "hidden_custom_highlights_ts5",
                                           h5(helpText("Add custom highlights")),
                                           h6(helpText("Enter values manually or draw a box on plot")),
                                           
                                           numericRangeInput(inputId = "highlight_x_values_ts5",
                                                             label  = "X values:",
                                                             value  = "",
                                                             min    = -180,
                                                             max    = 180),
                                           
                                           numericRangeInput(inputId = "highlight_y_values_ts5",
                                                             label  = "Y values:",
                                                             value  = "",
                                                             min    = -90,
                                                             max    = 90),
                                           
                                           colourInput(inputId = "highlight_colour_ts5", 
                                                       label   = "Highlight colour:",
                                                       showColour = "background",
                                                       palette = "limited"),
                                           
                                           radioButtons(inputId      = "highlight_type_ts5",
                                                        label        = "Type for highlight:",
                                                        inline       = TRUE,
                                                        choiceNames  = c("Fill \u25FC", "Box \u25FB", "Hatched \u25A8"),
                                                        choiceValues = c("Fill","Box","Hatched")),
                                           
                                           checkboxInput(inputId = "show_highlight_on_legend_ts5",
                                                         label   = "Show on legend",
                                                         value   = FALSE),
                                           
                                           textInput(inputId = "highlight_label_ts5", 
                                                     label   = "Label:",
                                                     value   = ""),
                                           
                                           
                                           column(width = 12,
                                                  actionButton(inputId = "add_highlight_ts5",
                                                               label = "Add highlight"),
                                                  br(), br(), br(),
                                                  actionButton(inputId = "remove_last_highlight_ts5",
                                                               label = "Remove last highlight"),
                                                  actionButton(inputId = "remove_all_highlights_ts5",
                                                               label = "Remove all highlights")),
                                       )),
                                     
                                     #Custom lines
                                     shinyjs::hidden(
                                       div(id = "hidden_custom_line_ts5",
                                           h5(helpText("Add custom lines")),
                                           h6(helpText("Enter position manually or click on plot, double click to change orientation")),
                                           
                                           radioButtons(inputId      = "line_orientation_ts5",
                                                        label        = "Orientation:",
                                                        inline       = TRUE,
                                                        choices      = c("Vertical", "Horizontal")),
                                           
                                           textInput(inputId = "line_position_ts5", 
                                                     label   = "Position:",
                                                     value   = "",
                                                     placeholder = "1830, 1832"),
                                           
                                           colourInput(inputId = "line_colour_ts5", 
                                                       label   = "Line colour:",
                                                       showColour = "background",
                                                       palette = "limited"),
                                           
                                           radioButtons(inputId      = "line_type_ts5",
                                                        label        = "Type:",
                                                        inline       = TRUE,
                                                        choices = c("solid", "dashed")),
                                           
                                           checkboxInput(inputId = "show_line_on_legend_ts5",
                                                         label   = "Show on legend",
                                                         value   = FALSE),
                                           
                                           textInput(inputId = "line_label_ts5", 
                                                     label   = "Label:",
                                                     value   = ""),
                                           
                                           column(width = 12,
                                                  actionButton(inputId = "add_line_ts5",
                                                               label = "Add line"),
                                                  br(), br(), br(),
                                                  actionButton(inputId = "remove_last_line_ts5",
                                                               label = "Remove last line"),
                                                  actionButton(inputId = "remove_all_lines_ts5",
                                                               label = "Remove all lines")
                                           )
                                       ))
                                 ))),
                        
                        #### Custom statistics ----
                        column(width = 4,
                               # h4(helpText("Custom statistics")),
                               
                               #checkboxInput(inputId = "enable_custom_statistics_ts",
                               #             label   = "Enable custom statistics",
                               #            value   = FALSE),
                               
                        ),
                        
                        #### Customization panels END ----
                      ),
                      ### TS plot END ----       
             ),
             
             ### TS data ----
             tabPanel("Time series data", br(),
                      
                      column(width = 3, dataTableOutput("data5"))),
             
             
             ### Feedback archive documentation (FAD) ----
             tabPanel("ModE-RA sources", br(),
                      fluidRow(
                        
                        # Year 1
                        column(width=4,
                               numericInput(
                                 inputId  = "fad_year_a5",
                                 label   =  "Year",
                                 value = 1422,
                                 min = 1422,
                                 max = 2000)),
                        # Longitude 1
                        column(width=4,
                               numericRangeInput(inputId = "fad_longitude_a5",
                                                 label = "Longitude range (-180/180):",
                                                 value = c(4,12),
                                                 separator = " to ",
                                                 min = -180,
                                                 max = 180)),
                        # Latitude 1
                        column(width=4,
                               numericRangeInput(inputId = "fad_latitude_a5",
                                                 label = "Latitude range (-90/90):",
                                                 value = c(43,50),
                                                 separator = " to ",
                                                 min = -90,
                                                 max = 90)),
                      ),
                      
                      h4(helpText("Draw a box on the left map to use zoom function")),
                      
                      div(id = "fad_map_a5",
                          splitLayout(
                            plotOutput("fad_winter_map_a5",
                                       brush = brushOpts(
                                         id = "brush_fad1a5",
                                         resetOnNew = TRUE
                                       )),
                            
                            plotOutput("fad_zoom_winter_a5")
                          )),
                      
                      div(id = "fad_map_b5",
                          splitLayout(plotOutput("fad_summer_map_a5",
                                                 brush = brushOpts(
                                                   id = "brush_fad1b5",
                                                   resetOnNew = TRUE
                                                 )),
                                      plotOutput("fad_zoom_summer_a5")
                          )),
                      
             ),
             
             ### Downloads ---- 
             tabPanel("Downloads",
                      verticalLayout(br(),
                                     h3(helpText("Time series download")),
                                     radioButtons(inputId = "file_type_timeseries5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                     downloadButton(outputId = "download_timeseries5", label = "Download"), br(),
                                     h3(helpText("Time series data download")),
                                     radioButtons(inputId = "file_type_timeseries_data5", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE),
                                     downloadButton(outputId = "download_timeseries_data5", label = "Download")), br(),
                                      fluidRow(
                                        column(width = 3,
                                               radioButtons(inputId = "file_type_modera_source_a5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                               downloadButton(outputId = "download_fad_wa5", label = "Download Oct. - Mar")),
                                        column(width = 3,
                                               radioButtons(inputId = "file_type_modera_source_b5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE),
                                               downloadButton(outputId = "download_fad_sa5", label = "Download Apr. - Sept")),
                                      ),
             )
             
             ## Main Panel END ----
           ), width = 8),
           # Monthly timeseries END ----  
         )),

# END ----
)


     
# Define server logic ----
server <- function(input, output, session) {
  #Preparations in the Server (Hidden options) ----
  track_usage(storage_mode = store_rds(path = "logs/"))
  #Hiding, showing, enabling/disenabling certain inputs
  observe({

    #Sidebars General and Composite
    
    shinyjs::toggle(id = "optional2a",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Fixed reference",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2b",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Compared to X years prior",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2c",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2 == "Manual",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2d",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2 == "Upload",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2e",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$upload_file2),
                    asis = FALSE)
    
    shinyjs::toggle(id = "season",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "season2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected2 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2f",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2g",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2a == "Manual",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2h",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2a == "Upload",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional2i",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$upload_file2a),
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_sec_map_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_map_mode != "None",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_sec_map_download2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_map_mode2 != "None",
                    asis = FALSE)
   
    #Customization
    ##General Maps
    
    shinyjs::toggle(id = "hidden_custom_maps",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_axis",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_statistics",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_sign_match",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic == "% sign match",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_SD_ratio",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic == "SD ratio",
                    asis = FALSE)
    
    ## General TS
    
    shinyjs::toggle(id = "hidden_custom_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_key_position_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_statistics_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_moving_average_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_percentile_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_percentile_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_moving_percentile_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts == TRUE,
                    asis = FALSE)

    shinyjs::toggle(id = "hidden_custom_features_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_line_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Line",
                    asis = FALSE)

    ## Composites Maps
    
    shinyjs::toggle(id = "hidden_custom_maps2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_axis2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode2 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode2 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature2 == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature2 == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_statistics2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_sign_match2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic2 == "% sign match",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_SD_ratio2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic2 == "SD ratio",
                    asis = FALSE)
    
    shinyjs::toggle(id = "custom_anomaly_years2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)
    
    ## Composites TS
    
    shinyjs::toggle(id = "hidden_custom_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts2 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_key_position_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_statistics_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_percentile_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_percentile_ts2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_line_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Line",
                    asis = FALSE)
    
    shinyjs::toggle(id = "custom_anomaly_years2b",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)
    
    ## Correlation Maps
    
    shinyjs::toggle(id = "hidden_custom_maps3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_axis3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode3 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode3 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature3 == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature3 == "Highlight",
                    asis = FALSE)
    
    ## Correlation TS
    
    shinyjs::toggle(id = "hidden_custom_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts3 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_key_position_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_statistics_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_moving_average_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_line_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Line",
                    asis = FALSE)
    
    # Correlation
    
    ##Sidebar V1
    
    shinyjs::toggle(id = "upload_forcings_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "upload_example_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_v1),
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_user_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_me_dataset_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_modera_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "season_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_v1 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_v1 == "Anomaly",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_continents_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_v1 == "Continents",
                    asis = FALSE)
    
    ##Sidebar V2
    
    shinyjs::toggle(id = "upload_forcings_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "upload_example_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_v2),
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_user_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_me_dataset_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)

    shinyjs::toggle(id = "hidden_modera_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "season_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_v2 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_v2 == "Anomaly",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_continents_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_v2 == "Continents",
                    asis = FALSE)
    
    #Correlation (Main Panel)
    
    shinyjs::toggle(id = "hidden_v1_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_v1_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_v2_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_v2_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)
    
    # Regression
    
    ##Sidebar IV
    
    shinyjs::toggle(id = "upload_forcings_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "upload_example_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_iv),
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_user_variable_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_me_variable_dataset_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_modera_variable_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "season_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_iv == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_iv == "Anomaly",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_continents_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_iv == "Continents",
                    asis = FALSE)
    
    ##Sidebar DV
    
    shinyjs::toggle(id = "upload_forcings_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "upload_example_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_dv),
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_user_variable_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "User Data",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_me_variable_dataset_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_modera_variable_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "season_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_dv == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "optional_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_dv == "Anomaly",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_continents_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_dv == "Continents",
                    asis = FALSE)
    
    ##Regression (Main Panel)
    
    shinyjs::toggle(id = "hidden_iv_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_iv_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_dv_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_dv_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)
    
    # Monthly TS
    
    shinyjs::toggle(id = "optional5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected5 == "Anomaly",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts5 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_title_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts5 == "Custom",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_key_position_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts5 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_features_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts5 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_points_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Point",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_highlights_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Highlight",
                    asis = FALSE)
    
    shinyjs::toggle(id = "hidden_custom_line_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Line",
                    asis = FALSE)
    
    #Toggle Single Year UI
    
    shinyjs::toggle(id = "range_years_sg",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "range_years",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year2 == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v1 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v1 == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v2 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v2 == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "range_years_sg3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year3 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "range_years3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year3 == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_iv == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_iv == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "range_years_sg4",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year4 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "range_years4",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year4 == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_dv == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_dv == FALSE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period_sg5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year5 == TRUE,
                    asis = FALSE)
    
    shinyjs::toggle(id = "ref_period5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year5 == FALSE,
                    asis = FALSE)
    
    
  
  })
  
  ## GENERAL observe, update & interactive controls ----
  
    ### Input updaters ----
    
    # Set iniital lon/lat values on startup
    lonlat_vals = reactiveVal(c(initial_lon_values,initial_lat_values))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals(c(-30,40,30,75))
    })
    
      observeEvent(input$button_asia, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord, {
      lonlat_vals(c(input$range_longitude,input$range_latitude))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude[1] == -180 && input$range_longitude[2] == 180 &&
          input$range_latitude[1] == -90 && input$range_latitude[2] == 90) {
        addClass("button_global", "green-background")
      } else {
        removeClass("button_global", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == -30 && input$range_longitude[2] == 40 &&
          input$range_latitude[1] == 30 && input$range_latitude[2] == 75) {
        addClass("button_europe", "green-background")
      } else {
        removeClass("button_europe", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == 25 && input$range_longitude[2] == 170 &&
          input$range_latitude[1] == 5 && input$range_latitude[2] == 80) {
        addClass("button_asia", "green-background")
      } else {
        removeClass("button_asia", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == 90 && input$range_longitude[2] == 180 &&
          input$range_latitude[1] == -55 && input$range_latitude[2] == 20) {
        addClass("button_oceania", "green-background")
      } else {
        removeClass("button_oceania", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == -25 && input$range_longitude[2] == 55 &&
          input$range_latitude[1] == -40 && input$range_latitude[2] == 40) {
        addClass("button_africa", "green-background")
      } else {
        removeClass("button_africa", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == -175 && input$range_longitude[2] == -10 &&
          input$range_latitude[1] == 5 && input$range_latitude[2] == 85) {
        addClass("button_n_america", "green-background")
      } else {
        removeClass("button_n_america", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude[1] == -90 && input$range_longitude[2] == -30 &&
          input$range_latitude[1] == -60 && input$range_latitude[2] == 15) {
        addClass("button_s_america", "green-background")
      } else {
        removeClass("button_s_america", "green-background")
      }
    })

    #Month Range Updater
    observe({
      if (input$season_selected == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    

    
    # Axis values updater 
    observe({
      if (input$axis_mode == "Default"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode == "Custom" & is.null(input$axis_input)){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input",
          value = set_axis_values(map_data(), "Anomaly"))
      }
    })
    
    #Set NetCDF Variable
    observeEvent(input$variable_selected, {
      
      choices  = c("Temperature", "Precipitation", "SLP", "Z500")
      
      updateCheckboxGroupInput(
        session, "netcdf_variables",
        choices = choices,
        selected = input$variable_selected
      )
    })
    
    #Update Reference Map
    observe({
      if (input$dataset_selected == "ModE-RAclim"){
        updateRadioButtons(
          inputId = "ref_map_mode",
          label    = NULL,
          choices  = c("None", "Reference Period"),
          selected = "None" , inline = TRUE)
      } else if (input$dataset_selected == "ModE-Sim"){
        updateRadioButtons(
          inputId = "ref_map_mode",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Period"),
          selected = "None" , inline = TRUE)
      } else {
        updateRadioButtons(
          inputId = "ref_map_mode",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Period","SD Ratio"),
          selected = "None" , inline = TRUE)
      }
    })
    
    #Show Absolute Warning
    observe({
      if (input$ref_map_mode == "Absolute Values"){
        showModal(
          # Add modal dialog for warning message
          modalDialog(
            title = "Information",
            "Unrealistic values (such as negative precipitation) can occur if absolute values are used! Cf. “Usage Notes”",
            easyClose = TRUE,
            footer = tagList(modalButton("OK"))
          ))}
    })
    
    ### Interactivity ----
    
    # Input geo-coded locations
    
    observeEvent(input$search, {
      location <- input$location
      if (!is.null(location) && nchar(location) > 0) {
        result <- geocode_OSM(location)
        if (!is.null(result$coords)) {
          longitude <- result$coords[1]
          latitude <- result$coords[2]
          updateTextInput(session, "point_location_x", value = as.character(longitude))
          updateTextInput(session, "point_location_y", value = as.character(latitude))
          shinyjs::hide(id = "inv_location")  # Hide the "Invalid location" message
        } else {
          shinyjs::show(id = "inv_location")  # Show the "Invalid location" message
        }
      } else {
        shinyjs::hide(id = "inv_location")  # Hide the "Invalid location" message when no input
      }
    })
    
    # Map coordinates/highlights setter
    observeEvent(input$map_brush1,{
  
      # Convert x values
      x_brush1_1 = (input$map_brush1[[1]]*1.14) - (0.14*lonlat_vals()[1])
      x_brush1_2 = (input$map_brush1[[2]]*1.14) - (0.14*lonlat_vals()[1])
      
      if (input$custom_features == FALSE){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_longitude",
          label = NULL,
          value = round(c(x_brush1_1,x_brush1_2), digits = 2))
  
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_latitude",
          label = NULL,
          value = round(c(input$map_brush1[[3]],input$map_brush1[[4]]), digits = 2))
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "feature",
          label = NULL,
          selected = "Highlight")
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values",
          label = NULL,
          value = round(c(x_brush1_1,x_brush1_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values",
          label = NULL,
          value = round(c(input$map_brush1[[3]],input$map_brush1[[4]]), digits = 2))
      }
    })
    
    # Map custom points selector
    observeEvent(input$map_dblclick1,{
      
      # Convert x values
      x_dblclick1 = (input$map_dblclick1$x*1.14) - (0.14*lonlat_vals()[1])
      
      updateCheckboxInput(
        session = getDefaultReactiveDomain(),
        inputId = "custom_features",
        label = NULL,
        value = TRUE)
      
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature",
        label = NULL,
        selected = "Point")
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_x",
        label = NULL,
        value = as.character(round(x_dblclick1, digits = 2))
      )
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_y",
        label = NULL,
        value = as.character(round(input$map_dblclick1$y, digits = 2))
      )
    })
    
    # TS point/line setter
    observeEvent(input$ts_click1,{
      if (input$custom_features_ts == TRUE){
        if (input$feature_ts == "Point"){
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_x_ts",
            label = NULL,
            value = as.character(round(input$ts_click1$x, digits = 2))
          )
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_y_ts",
            label = NULL,
            value = as.character(round(input$ts_click1$y, digits = 2))
          )
        } 
        else if (input$feature_ts == "Line"){
          updateRadioButtons(
            session = getDefaultReactiveDomain(),
            inputId = "line_orientation_ts",
            label = NULL,
            selected = "Vertical")
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "line_position_ts",
            label = NULL,
            value = as.character(round(input$ts_click1$x, digits = 2))
          )
        }
      }
    })
    
    observeEvent(input$ts_dblclick1,{
      if (input$custom_features_ts == TRUE & input$feature_ts == "Line"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "line_orientation_ts",
          label = NULL,
          selected = "Horizontal")
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "line_position_ts",
          label = NULL,
          value = as.character(round(input$ts_dblclick1$y, digits = 2))
        )
      }
    })
    
    # TS highlight setter
    observeEvent(input$ts_brush1,{
      if (input$custom_features_ts == TRUE & input$feature_ts == "Highlight"){
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values_ts",
          label = NULL,
          value = round(c(input$ts_brush1[[1]],input$ts_brush1[[2]]), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values_ts",
          label = NULL,
          value = round(c(input$ts_brush1[[3]],input$ts_brush1[[4]]), digits = 2))
      }
    })
    
    
    ### Initialise and update custom points lines highlights ----
    
    map_points_data = reactiveVal(data.frame())
    map_highlights_data = reactiveVal(data.frame())
    
    ts_points_data = reactiveVal(data.frame())
    ts_highlights_data = reactiveVal(data.frame())
    ts_lines_data = reactiveVal(data.frame())
    
    # Map Points
    observeEvent(input$add_point, {
      map_points_data(rbind(map_points_data(),
                            create_new_points_data(input$point_location_x,input$point_location_y,
                                                   input$point_label,input$point_shape,
                                                   input$point_colour,input$point_size)))
    })  
    
    observeEvent(input$remove_last_point, {
      map_points_data(map_points_data()[-nrow(map_points_data()),])
    })
    
    observeEvent(input$remove_all_points, {
      map_points_data(data.frame())
    })
    
    # Map Highlights
    observeEvent(input$add_highlight, {
      map_highlights_data(rbind(map_highlights_data(),
                                create_new_highlights_data(input$highlight_x_values,input$highlight_y_values,
                                                           input$highlight_colour,input$highlight_type,NA,NA)))
    })  
    
    observeEvent(input$remove_last_highlight, {
      map_highlights_data(map_highlights_data()[-nrow(map_highlights_data()),])
    })
    
    observeEvent(input$remove_all_highlights, {
      map_highlights_data(data.frame())
    })
    
    # time series Points
    observeEvent(input$add_point_ts, {
      ts_points_data(rbind(ts_points_data(),
                           create_new_points_data(input$point_location_x_ts,input$point_location_y_ts,
                                                  input$point_label_ts,input$point_shape_ts,
                                                  input$point_colour_ts,input$point_size_ts)))
    })  
    
    observeEvent(input$remove_last_point_ts, {
      ts_points_data(ts_points_data()[-nrow(ts_points_data()),])
    })
    
    observeEvent(input$remove_all_points_ts, {
      ts_points_data(data.frame())
    })
    
    # time series Highlights
    observeEvent(input$add_highlight_ts, {
      ts_highlights_data(rbind(ts_highlights_data(),
                               create_new_highlights_data(input$highlight_x_values_ts,input$highlight_y_values_ts,
                                                          input$highlight_colour_ts,input$highlight_type_ts,
                                                          input$show_highlight_on_legend_ts,input$highlight_label_ts)))
    })  
    
    observeEvent(input$remove_last_highlight_ts, {
      ts_highlights_data(ts_highlights_data()[-nrow(ts_highlights_data()),])
    })
    
    observeEvent(input$remove_all_highlights_ts, {
      ts_highlights_data(data.frame())
    })
    
    # time series Lines
    observeEvent(input$add_line_ts, {
      ts_lines_data(rbind(ts_lines_data(),
                          create_new_lines_data(input$line_orientation_ts,input$line_position_ts,
                                                input$line_colour_ts,input$line_type_ts,
                                                input$show_line_on_legend_ts,input$line_label_ts)))
    })  
    
    observeEvent(input$remove_last_line_ts, {
      ts_lines_data(ts_lines_data()[-nrow(ts_lines_data()),])
    })
    
    observeEvent(input$remove_all_lines_ts, {
      ts_lines_data(data.frame())
    })
    
    
  ## COMPOSITES observe, update & interactive controls ----
  
    ### Input updaters ----
    
    # Set iniital lon/lat values on startup
    lonlat_vals2 = reactiveVal(c(initial_lon_values,initial_lat_values))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global2,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals2(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals2(c(-30,40,30,75))
    })
    
    observeEvent(input$button_asia2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals2(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals2(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals2(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals2(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals2(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord2, {
      lonlat_vals2(c(input$range_longitude2,input$range_latitude2))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude2[1] == -180 && input$range_longitude2[2] == 180 &&
          input$range_latitude2[1] == -90 && input$range_latitude2[2] == 90) {
        addClass("button_global2", "green-background")
      } else {
        removeClass("button_global2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == -30 && input$range_longitude2[2] == 40 &&
          input$range_latitude2[1] == 30 && input$range_latitude2[2] == 75) {
        addClass("button_europe2", "green-background")
      } else {
        removeClass("button_europe2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == 25 && input$range_longitude2[2] == 170 &&
          input$range_latitude2[1] == 5 && input$range_latitude2[2] == 80) {
        addClass("button_asia2", "green-background")
      } else {
        removeClass("button_asia2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == 90 && input$range_longitude2[2] == 180 &&
          input$range_latitude2[1] == -55 && input$range_latitude2[2] == 20) {
        addClass("button_oceania2", "green-background")
      } else {
        removeClass("button_oceania2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == -25 && input$range_longitude2[2] == 55 &&
          input$range_latitude2[1] == -40 && input$range_latitude2[2] == 40) {
        addClass("button_africa2", "green-background")
      } else {
        removeClass("button_africa2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == -175 && input$range_longitude2[2] == -10 &&
          input$range_latitude2[1] == 5 && input$range_latitude2[2] == 85) {
        addClass("button_n_america2", "green-background")
      } else {
        removeClass("button_n_america2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude2[1] == -90 && input$range_longitude2[2] == -30 &&
          input$range_latitude2[1] == -60 && input$range_latitude2[2] == 15) {
        addClass("button_s_america2", "green-background")
      } else {
        removeClass("button_s_america2", "green-background")
      }
    })
    
    #Month Range Updater
    observe({
      if (input$season_selected2 == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months2",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected2 == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months2",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected2 == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months2",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected2 == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months2",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected2 == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months2",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    
    # Composite Axis values updater 
    observe({
      if (input$axis_mode2 == "Default"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input2",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode2 == "Custom" & is.null(input$axis_input2)){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input2",
          value = set_axis_values(map_data_2(), input$mode_selected2))
      }
    })
    
    #Update Reference Map
    observe({
      if (input$dataset_selected2 == "ModE-RAclim"){
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Reference Period"),
          selected = "None" , inline = TRUE)
      } else if (input$dataset_selected2 == "ModE-Sim"){
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Period"),
          selected = "None" , inline = TRUE)
      } else {
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Period", "SD Ratio"),
          selected = "None" , inline = TRUE)
      }
    })
    
    
    #Show Absolute Warning
    observe({
      if (input$ref_map_mode2 == "Absolute Values"){
        showModal(
          # Add modal dialog for warning message
          modalDialog(
            title = "Information",
            "Unrealistic values (such as negative precipitation) can occur if absolute values are used! Cf. “Usage Notes”",
            easyClose = TRUE,
            footer = tagList(modalButton("OK"))
          ))}
    })
    
    
    ### Interactivity ----
    
    # Input geo-coded locations
    
    observeEvent(input$search2, {
      location2 <- input$location2
      if (!is.null(location2) && nchar(location2) > 0) {
        result <- geocode_OSM(location2)
        if (!is.null(result$coords)) {
          longitude2 <- result$coords[1]
          latitude2 <- result$coords[2]
          updateTextInput(session, "point_location_x2", value = as.character(longitude2))
          updateTextInput(session, "point_location_y2", value = as.character(latitude2))
          shinyjs::hide(id = "inv_location2")  # Hide the "Invalid location" message
        } else {
          shinyjs::show(id = "inv_location2")  # Show the "Invalid location" message
        }
      } else {
        shinyjs::hide(id = "inv_location2")  # Hide the "Invalid location" message when no input
      }
    })
    
    # Map coordinates/highlights setter
    observeEvent(input$map_brush2,{
      
      # Convert x values
      x_brush2_1 = (input$map_brush2[[1]]*1.14) - (0.14*lonlat_vals2()[1])
      x_brush2_2 = (input$map_brush2[[2]]*1.14) - (0.14*lonlat_vals2()[1])
      
      if (input$custom_features2 == FALSE){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_longitude2",
          label = NULL,
          value = round(c(x_brush2_1,x_brush2_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_latitude2",
          label = NULL,
          value = round(c(input$map_brush2[[3]],input$map_brush2[[4]]), digits = 2))
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "feature2",
          label = NULL,
          selected = "Highlight")
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values2",
          label = NULL,
          value = round(c(x_brush2_1,x_brush2_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values2",
          label = NULL,
          value = round(c(input$map_brush2[[3]],input$map_brush2[[4]]), digits = 2))
      }
    })
    
    # Map custom points selector
    observeEvent(input$map_dblclick2,{
      
      # Convert x values
      x_dblclick2 = (input$map_dblclick2$x*1.14) - (0.14*lonlat_vals2()[1])
      
      updateCheckboxInput(
        session = getDefaultReactiveDomain(),
        inputId = "custom_features2",
        label = NULL,
        value = TRUE)
      
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature2",
        label = NULL,
        selected = "Point")
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_x2",
        label = NULL,
        value = as.character(round(x_dblclick2, digits = 2))
      )
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_y2",
        label = NULL,
        value = as.character(round(input$map_dblclick2$y, digits = 2))
      )
    })
    
    # TS point/line setter
    observeEvent(input$ts_click2,{
      if (input$custom_features_ts2 == TRUE){
        if (input$feature_ts2 == "Point"){
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_x_ts2",
            label = NULL,
            value = as.character(round(input$ts_click2$x, digits = 2))
          )
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_y_ts2",
            label = NULL,
            value = as.character(round(input$ts_click2$y, digits = 2))
          )
        } 
        else if (input$feature_ts2 == "Line"){
          updateRadioButtons(
            session = getDefaultReactiveDomain(),
            inputId = "line_orientation_ts2",
            label = NULL,
            selected = "Vertical")
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "line_position_ts2",
            label = NULL,
            value = as.character(round(input$ts_click2$x, digits = 2))
          )
        }
      }
    })
    
    observeEvent(input$ts_dblclick2,{
      if (input$custom_features_ts2 == TRUE & input$feature_ts2 == "Line"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "line_orientation_ts2",
          label = NULL,
          selected = "Horizontal")
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "line_position_ts2",
          label = NULL,
          value = as.character(round(input$ts_dblclick2$y, digits = 2))
        )
      }
    })
    
    # TS highlight setter
    observeEvent(input$ts_brush2,{
      if (input$custom_features_ts2 == TRUE & input$feature_ts2 == "Highlight"){
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values_ts2",
          label = NULL,
          value = round(c(input$ts_brush2[[1]],input$ts_brush2[[2]]), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values_ts2",
          label = NULL,
          value = round(c(input$ts_brush2[[3]],input$ts_brush2[[4]]), digits = 2))
      }
    })
    
    
    ### Initialise and update custom points lines highlights ----
    
    map_points_data2 = reactiveVal(data.frame())
    map_highlights_data2 = reactiveVal(data.frame())
    
    ts_points_data2 = reactiveVal(data.frame())
    ts_highlights_data2 = reactiveVal(data.frame())
    ts_lines_data2 = reactiveVal(data.frame())
    
    # Map Points
    observeEvent(input$add_point2, {
      map_points_data2(rbind(map_points_data2(),
                             create_new_points_data(input$point_location_x2,input$point_location_y2,
                                                    input$point_label2,input$point_shape2,
                                                    input$point_colour2,input$point_size2)))
    })  
    
    observeEvent(input$remove_last_point2, {
      map_points_data2(map_points_data2()[-nrow(map_points_data2()),])
    })
    
    observeEvent(input$remove_all_points2, {
      map_points_data2(data.frame())
    })
    
    # Map Highlights
    observeEvent(input$add_highlight2, {
      map_highlights_data2(rbind(map_highlights_data2(),
                                 create_new_highlights_data(input$highlight_x_values2,input$highlight_y_values2,
                                                            input$highlight_colour2,input$highlight_type2,NA,NA)))
    })  
    
    observeEvent(input$remove_last_highlight2, {
      map_highlights_data2(map_highlights_data2()[-nrow(map_highlights_data2()),])
    })
    
    observeEvent(input$remove_all_highlights2, {
      map_highlights_data2(data.frame())
    })
    
    # time series Points
    observeEvent(input$add_point_ts2, {
      ts_points_data2(rbind(ts_points_data2(),
                            create_new_points_data(input$point_location_x_ts2,input$point_location_y_ts2,
                                                   input$point_label_ts2,input$point_shape_ts2,
                                                   input$point_colour_ts2,input$point_size_ts2)))
    })  
    
    observeEvent(input$remove_last_point_ts2, {
      ts_points_data2(ts_points_data2()[-nrow(ts_points_data2()),])
    })
    
    observeEvent(input$remove_all_points_ts2, {
      ts_points_data2(data.frame())
    })
    
    # time series Highlights
    observeEvent(input$add_highlight_ts2, {
      ts_highlights_data2(rbind(ts_highlights_data2(),
                                create_new_highlights_data(input$highlight_x_values_ts2,input$highlight_y_values_ts2,
                                                           input$highlight_colour_ts2,input$highlight_type_ts2,
                                                           input$show_highlight_on_legend_ts2,input$highlight_label_ts2)))
    })  
    
    observeEvent(input$remove_last_highlight_ts2, {
      ts_highlights_data2(ts_highlights_data2()[-nrow(ts_highlights_data2()),])
    })
    
    observeEvent(input$remove_all_highlights_ts2, {
      ts_highlights_data2(data.frame())
    })
    
    # time series Lines
    observeEvent(input$add_line_ts2, {
      ts_lines_data2(rbind(ts_lines_data2(),
                           create_new_lines_data(input$line_orientation_ts2,input$line_position_ts2,
                                                 input$line_colour_ts2,input$line_type_ts2,
                                                 input$show_line_on_legend_ts2,input$line_label_ts2)))
    })  
    
    observeEvent(input$remove_last_line_ts2, {
      ts_lines_data2(ts_lines_data2()[-nrow(ts_lines_data2()),])
    })
    
    observeEvent(input$remove_all_lines_ts2, {
      ts_lines_data2(data.frame())
    })
    
    
  ## CORRELATION observe, update & interactive controls ----
  
    ### Input updaters ----
    
    # Update variable selection
    observe({
      req(user_data_v1())
      
      if (input$source_v1 == "User Data"){
        updateSelectInput(
          session = getDefaultReactiveDomain(),
          inputId = "user_variable_v1",
          choices = names(user_data_v1())[-1])
      }
    })
    
    observe({
      req(user_data_v2())
      
      if (input$source_v2 == "User Data"){
        updateSelectInput(
          session = getDefaultReactiveDomain(),
          inputId = "user_variable_v2",
          choices = names(user_data_v2())[-1])
      }
    })
    
    # time series/Field updater
    observe({
      selected_type_v1 = input$type_v1
      
      # Check if source is user data OR map area is very small
      if ((input$source_v1 == "User Data") | (((input$range_longitude_v1[2]-input$range_longitude_v1[1])<4) & ((input$range_latitude_v1[2]-input$range_latitude_v1[1]<4)))){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v1",
          label = NULL,
          choices = c("Time series"),
          selected =  "Time series")
        
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v1",
          label = NULL,
          choices  = c( "Field","Time series"),
          selected = selected_type_v1,
          inline = TRUE)
      }
    })    
    
    observe({
      selected_type_v2 = input$type_v2
      
      # Check if source is user data OR map area is very small
      if ((input$source_v2 == "User Data") | (((input$range_longitude_v2[2]-input$range_longitude_v2[1])<4) & ((input$range_latitude_v2[2]-input$range_latitude_v2[1]<4)))){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v2",
          label = NULL,
          choices = c("Time series"),
          selected =  "Time series")
        
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v2",
          label = NULL,
          choices  = c( "Field","Time series"),
          selected = selected_type_v2,
          inline = TRUE)
      }
    })     
    
    # Mode Updater (based on dataset0)
    observe({
      if (input$dataset_selected_v1 == "ModE-RAclim"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_v1",
          label = NULL,
          choices = c("Anomaly"),
          selected =  "Anomaly")
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_v1",
          label = NULL,
          choices = c("Anomaly","Absolute"))
      }
    })
    
    observe({
      if (input$dataset_selected_v2 == "ModE-RAclim"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_v2",
          label = NULL,
          choices = c("Anomaly"),
          selected =  "Anomaly")
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_v2",
          label = NULL,
          choices = c("Anomaly","Absolute"))
      }
    })
    
    #Month Range Updater
    observe({
      if (input$season_selected_v1 == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v1",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected_v1 == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v1",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected_v1 == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v1",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected_v1 == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v1",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected_v1 == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v1",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    
    observe({
      if (input$season_selected_v2 == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v2",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected_v2 == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v2",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected_v2 == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v2",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected_v2 == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v2",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected_v2 == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_v2",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    
    # Update year range
    observeEvent(year_range_cor(),{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_years3",
        label = paste("Select the range of years (",year_range_cor()[3],"-",year_range_cor()[4],")",sep = ""),
        value = year_range_cor()[1:2]
      )
    })
    
    # Set iniital lon/lat values and update on button press
    lonlat_vals_v1 = reactiveVal(c(4,12,43,50))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global_v1,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals_v1(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals_v1(c(-30,40,30,75))
    })
    
    observeEvent(input$button_asia_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals_v1(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals_v1(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals_v1(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals_v1(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america_v1, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals_v1(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord_v1, {
      lonlat_vals_v1(c(input$range_longitude_v1,input$range_latitude_v1))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude_v1[1] == -180 && input$range_longitude_v1[2] == 180 &&
          input$range_latitude_v1[1] == -90 && input$range_latitude_v1[2] == 90) {
        addClass("button_global_v1", "green-background")
      } else {
        removeClass("button_global_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == -30 && input$range_longitude_v1[2] == 40 &&
          input$range_latitude_v1[1] == 30 && input$range_latitude_v1[2] == 75) {
        addClass("button_europe_v1", "green-background")
      } else {
        removeClass("button_europe_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == 25 && input$range_longitude_v1[2] == 170 &&
          input$range_latitude_v1[1] == 5 && input$range_latitude_v1[2] == 80) {
        addClass("button_asia_v1", "green-background")
      } else {
        removeClass("button_asia_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == 90 && input$range_longitude_v1[2] == 180 &&
          input$range_latitude_v1[1] == -55 && input$range_latitude_v1[2] == 20) {
        addClass("button_oceania_v1", "green-background")
      } else {
        removeClass("button_oceania_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == -25 && input$range_longitude_v1[2] == 55 &&
          input$range_latitude_v1[1] == -40 && input$range_latitude_v1[2] == 40) {
        addClass("button_africa_v1", "green-background")
      } else {
        removeClass("button_africa_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == -175 && input$range_longitude_v1[2] == -10 &&
          input$range_latitude_v1[1] == 5 && input$range_latitude_v1[2] == 85) {
        addClass("button_n_america_v1", "green-background")
      } else {
        removeClass("button_n_america_v1", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v1[1] == -90 && input$range_longitude_v1[2] == -30 &&
          input$range_latitude_v1[1] == -60 && input$range_latitude_v1[2] == 15) {
        addClass("button_s_america_v1", "green-background")
      } else {
        removeClass("button_s_america_v1", "green-background")
      }
    })
    
    # Set iniital lon/lat values and update on button press
    lonlat_vals_v2 = reactiveVal(c(initial_lon_values,initial_lat_values))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global_v2,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals_v2(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals_v2(c(-30,40,30,75))
    })
    
    observeEvent(input$button_asia_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals_v2(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals_v2(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals_v2(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals_v2(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america_v2, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals_v2(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord_v2, {
      lonlat_vals_v2(c(input$range_longitude_v2,input$range_latitude_v2))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude_v2[1] == -180 && input$range_longitude_v2[2] == 180 &&
          input$range_latitude_v2[1] == -90 && input$range_latitude_v2[2] == 90) {
        addClass("button_global_v2", "green-background")
      } else {
        removeClass("button_global_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == -30 && input$range_longitude_v2[2] == 40 &&
          input$range_latitude_v2[1] == 30 && input$range_latitude_v2[2] == 75) {
        addClass("button_europe_v2", "green-background")
      } else {
        removeClass("button_europe_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == 25 && input$range_longitude_v2[2] == 170 &&
          input$range_latitude_v2[1] == 5 && input$range_latitude_v2[2] == 80) {
        addClass("button_asia_v2", "green-background")
      } else {
        removeClass("button_asia_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == 90 && input$range_longitude_v2[2] == 180 &&
          input$range_latitude_v2[1] == -55 && input$range_latitude_v2[2] == 20) {
        addClass("button_oceania_v2", "green-background")
      } else {
        removeClass("button_oceania_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == -25 && input$range_longitude_v2[2] == 55 &&
          input$range_latitude_v2[1] == -40 && input$range_latitude_v2[2] == 40) {
        addClass("button_africa_v2", "green-background")
      } else {
        removeClass("button_africa_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == -175 && input$range_longitude_v2[2] == -10 &&
          input$range_latitude_v2[1] == 5 && input$range_latitude_v2[2] == 85) {
        addClass("button_n_america_v2", "green-background")
      } else {
        removeClass("button_n_america_v2", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_v2[1] == -90 && input$range_longitude_v2[2] == -30 &&
          input$range_latitude_v2[1] == -60 && input$range_latitude_v2[2] == 15) {
        addClass("button_s_america_v2", "green-background")
      } else {
        removeClass("button_s_america_v2", "green-background")
      }
    })
    
    # Correlation axis values updater 
    observe({
      if (input$axis_mode3 == "Default"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input3",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode3 == "Custom" & is.null(input$axis_input3)){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input3",
          value = set_axis_values(correlation_map_data()[[3]], "Anomaly"))
      }
    })
    
    # Update ts/map correlation method
    observeEvent(input$cor_method_ts,{
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "cor_method_map",
        label = NULL,
        selected = input$cor_method_ts)
    })
    
    observeEvent(input$cor_method_map,{
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "cor_method_ts",
        label = NULL,
        selected = input$cor_method_map)
    })
    
    ### Interactivity ----
    
    # Input geo-coded locations
    
    observeEvent(input$search3, {
      location3 <- input$location3
      if (!is.null(location3) && nchar(location3) > 0) {
        result <- geocode_OSM(location3)
        if (!is.null(result$coords)) {
          longitude3 <- result$coords[1]
          latitude3 <- result$coords[2]
          updateTextInput(session, "point_location_x3", value = as.character(longitude3))
          updateTextInput(session, "point_location_y3", value = as.character(latitude3))
          shinyjs::hide(id = "inv_location3")  # Hide the "Invalid location" message
        } else {
          shinyjs::show(id = "inv_location3")  # Show the "Invalid location" message
        }
      } else {
        shinyjs::hide(id = "inv_location3")  # Hide the "Invalid location" message when no input
      }
    })
    
    # Map coordinates/highlights setter
    observeEvent(input$map_brush3,{
      
      # Convert x values
      x_brush3_1 = (input$map_brush3[[1]]*1.14) - (0.14*lonlat_vals3()[1])
      x_brush3_2 = (input$map_brush3[[2]]*1.14) - (0.14*lonlat_vals3()[1])
      
      if (input$custom_features3 == FALSE){
        
        if (input$type_v1 == "Field"){
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_longitude_v1",
            label = NULL,
            value = round(c(x_brush3_1,x_brush3_2), digits = 2))
          
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_latitude_v1",
            label = NULL,
            value = round(c(input$map_brush3[[3]],input$map_brush3[[4]]), digits = 2))
        }
        
        if (input$type_v2 == "Field"){
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_longitude_v2",
            label = NULL,
            value = round(c(x_brush3_1,x_brush3_2), digits = 2))
          
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_latitude_v2",
            label = NULL,
            value = round(c(input$map_brush3[[3]],input$map_brush3[[4]]), digits = 2))
        }
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "feature3",
          label = NULL,
          selected = "Highlight")
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values3",
          label = NULL,
          value = round(c(x_brush3_1,x_brush3_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values3",
          label = NULL,
          value = round(c(input$map_brush3[[3]],input$map_brush3[[4]]), digits = 2))
      }
    })
    
    # Map custom points selector
    observeEvent(input$map_dblclick3,{
      
      # Convert x values
      x_dblclick3 = (input$map_dblclick3$x*1.14) - (0.14*lonlat_vals3()[1])
      
      updateCheckboxInput(
        session = getDefaultReactiveDomain(),
        inputId = "custom_features3",
        label = NULL,
        value = TRUE)
      
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature3",
        label = NULL,
        selected = "Point")
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_x3",
        label = NULL,
        value = as.character(round(x_dblclick3, digits = 2))
      )
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "point_location_y3",
        label = NULL,
        value = as.character(round(input$map_dblclick3$y, digits = 2))
      )
    })
    
    # TS point/line setter
    observeEvent(input$ts_click3,{
      if (input$custom_features_ts3 == TRUE){
        if (input$feature_ts3 == "Point"){
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_x_ts3",
            label = NULL,
            value = as.character(round(input$ts_click3$x, digits = 2))
          )
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_y_ts3",
            label = NULL,
            value = as.character(round(input$ts_click3$y, digits = 2))
          )
        } 
        else if (input$feature_ts3 == "Line"){
          updateRadioButtons(
            session = getDefaultReactiveDomain(),
            inputId = "line_orientation_ts3",
            label = NULL,
            selected = "Vertical")
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "line_position_ts3",
            label = NULL,
            value = as.character(round(input$ts_click3$x, digits = 2))
          )
        }
      }
    })
    
    observeEvent(input$ts_dblclick3,{
      if (input$custom_features_ts3 == TRUE & input$feature_ts3 == "Line"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "line_orientation_ts3",
          label = NULL,
          selected = "Horizontal")
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "line_position_ts3",
          label = NULL,
          value = as.character(round(input$ts_dblclick3$y, digits = 2))
        )
      }
    })
    
    # TS highlight setter
    observeEvent(input$ts_brush3,{
      if (input$custom_features_ts3 == TRUE & input$feature_ts3 == "Highlight"){
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values_ts3",
          label = NULL,
          value = round(c(input$ts_brush3[[1]],input$ts_brush3[[2]]), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values_ts3",
          label = NULL,
          value = round(c(input$ts_brush3[[3]],input$ts_brush3[[4]]), digits = 2))
      }
    })
    
    
    ### Initialise and update custom points lines highlights ----
    
    map_points_data3 = reactiveVal(data.frame())
    map_highlights_data3 = reactiveVal(data.frame())
    
    ts_points_data3 = reactiveVal(data.frame())
    ts_highlights_data3 = reactiveVal(data.frame())
    ts_lines_data3 = reactiveVal(data.frame())
    
    # Map Points
    observeEvent(input$add_point3, {
      map_points_data3(rbind(map_points_data3(),
                             create_new_points_data(input$point_location_x3,input$point_location_y3,
                                                    input$point_label3,input$point_shape3,
                                                    input$point_colour3,input$point_size3)))
    })  
    
    observeEvent(input$remove_last_point3, {
      map_points_data3(map_points_data3()[-nrow(map_points_data3()),])
    })
    
    observeEvent(input$remove_all_points3, {
      map_points_data3(data.frame())
    })
    
    # Map Highlights
    observeEvent(input$add_highlight3, {
      map_highlights_data3(rbind(map_highlights_data3(),
                                 create_new_highlights_data(input$highlight_x_values3,input$highlight_y_values3,
                                                            input$highlight_colour3,input$highlight_type3,NA,NA)))
    })  
    
    observeEvent(input$remove_last_highlight3, {
      map_highlights_data3(map_highlights_data3()[-nrow(map_highlights_data3()),])
    })
    
    observeEvent(input$remove_all_highlights3, {
      map_highlights_data3(data.frame())
    })
    
    # time series Points
    observeEvent(input$add_point_ts3, {
      ts_points_data3(rbind(ts_points_data3(),
                            create_new_points_data(input$point_location_x_ts3,input$point_location_y_ts3,
                                                   input$point_label_ts3,input$point_shape_ts3,
                                                   input$point_colour_ts3,input$point_size_ts3)))
    })  
    
    observeEvent(input$remove_last_point_ts3, {
      ts_points_data3(ts_points_data3()[-nrow(ts_points_data3()),])
    })
    
    observeEvent(input$remove_all_points_ts3, {
      ts_points_data3(data.frame())
    })
    
    # time series Highlights
    observeEvent(input$add_highlight_ts3, {
      ts_highlights_data3(rbind(ts_highlights_data3(),
                                create_new_highlights_data(input$highlight_x_values_ts3,input$highlight_y_values_ts3,
                                                           input$highlight_colour_ts3,input$highlight_type_ts3,
                                                           input$show_highlight_on_legend_ts3,input$highlight_label_ts3)))
    })  
    
    observeEvent(input$remove_last_highlight_ts3, {
      ts_highlights_data3(ts_highlights_data3()[-nrow(ts_highlights_data3()),])
    })
    
    observeEvent(input$remove_all_highlights_ts3, {
      ts_highlights_data3(data.frame())
    })
    
    # time series Lines
    observeEvent(input$add_line_ts3, {
      ts_lines_data3(rbind(ts_lines_data3(),
                           create_new_lines_data(input$line_orientation_ts3,input$line_position_ts3,
                                                 input$line_colour_ts3,input$line_type_ts3,
                                                 input$show_line_on_legend_ts3,input$line_label_ts3)))
    })  
    
    observeEvent(input$remove_last_line_ts3, {
      ts_lines_data3(ts_lines_data3()[-nrow(ts_lines_data3()),])
    })
    
    observeEvent(input$remove_all_lines_ts3, {
      ts_lines_data3(data.frame())
    })
    
  ## REGRESSION observe, update & interactive controls ----
    
    ### Input updaters ----
    
    # Update variable selection
    observe({
      
      req(user_data_iv())
      
      if (input$source_iv == "User Data"){
        
        user_vs = names(user_data_iv())[-1]
        
        updatePickerInput(
          session = getDefaultReactiveDomain(),
          inputId = "user_variable_iv",
          selected = user_vs[1],
          choices = user_vs)
      }
    })
    
    observe({
      req(user_data_dv())
      
      if (input$source_dv == "User Data"){
        updateSelectInput(
          session = getDefaultReactiveDomain(),
          inputId = "user_variable_dv",
          choices = names(user_data_dv())[-1])
      }
    })
    
    # Mode Updater (based on dataset0)
    observe({
      if (input$dataset_selected_iv == "ModE-RAclim"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_iv",
          label = NULL,
          choices = c("Anomaly"),
          selected =  "Anomaly")
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_iv",
          label = NULL,
          choices = c("Anomaly","Absolute"))
      }
    })
    
    observe({
      if (input$dataset_selected_dv == "ModE-RAclim"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_dv",
          label = NULL,
          choices = c("Anomaly"),
          selected =  "Anomaly")
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected_dv",
          label = NULL,
          choices = c("Anomaly","Absolute"))
      }
    })
    
    # Coeff/pvalue variable selection updater
    observeEvent(variables_iv(),{
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "coeff_variable",
        choices = variables_iv())
      
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "pvalue_variable",
        choices = variables_iv())
    })
    
    # Residuals year updater
    observeEvent(input$range_years4,{
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "reg_resi_year",
        value = input$range_years4[1],
        min = input$range_years4[1],
        max = input$range_years4[2]
      )
    })
    
    #Month Range Updater
    observe({
      if (input$season_selected_iv == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_iv",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected_iv == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_iv",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected_iv == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_iv",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected_iv == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_iv",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected_iv == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_iv",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    
    observe({
      if (input$season_selected_dv == "Annual"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_dv",
          label = NULL,
          selected = c("January", "December"))
      }
    })
    
    observe({
      if (input$season_selected_dv == "DJF"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_dv",
          label = NULL,
          selected = c("December (prev.)", "February"))
      }
    })
    
    observe({
      if (input$season_selected_dv == "MAM"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_dv",
          label = NULL,
          selected = c("March", "May"))
      }
    })
    
    observe({
      if (input$season_selected_dv == "JJA"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_dv",
          label = NULL,
          selected = c("June", "August"))
      }
    })
    
    observe({
      if (input$season_selected_dv == "SON"){
        updateSliderTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_months_dv",
          label = NULL,
          selected = c("September", "November"))
      }
    })
    
    # Update year range
    observeEvent(year_range_reg(),{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_years4",
        label = paste("Select the range of years (",year_range_reg()[3],"-",year_range_reg()[4],")",sep = ""),
        value = year_range_reg()[1:2]
      )
    })
    
    # Set iniital lon/lat values and update on button press
    lonlat_vals_iv = reactiveVal(c(4,12,43,50))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global_iv,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals_iv(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals_iv(c(-30,40,30,75))
    })
    
    observeEvent(input$button_asia_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals_iv(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals_iv(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals_iv(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals_iv(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america_iv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals_iv(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord_iv, {
      lonlat_vals_iv(c(input$range_longitude_iv,input$range_latitude_iv))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude_iv[1] == -180 && input$range_longitude_iv[2] == 180 &&
          input$range_latitude_iv[1] == -90 && input$range_latitude_iv[2] == 90) {
        addClass("button_global_iv", "green-background")
      } else {
        removeClass("button_global_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == -30 && input$range_longitude_iv[2] == 40 &&
          input$range_latitude_iv[1] == 30 && input$range_latitude_iv[2] == 75) {
        addClass("button_europe_iv", "green-background")
      } else {
        removeClass("button_europe_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == 25 && input$range_longitude_iv[2] == 170 &&
          input$range_latitude_iv[1] == 5 && input$range_latitude_iv[2] == 80) {
        addClass("button_asia_iv", "green-background")
      } else {
        removeClass("button_asia_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == 90 && input$range_longitude_iv[2] == 180 &&
          input$range_latitude_iv[1] == -55 && input$range_latitude_iv[2] == 20) {
        addClass("button_oceania_iv", "green-background")
      } else {
        removeClass("button_oceania_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == -25 && input$range_longitude_iv[2] == 55 &&
          input$range_latitude_iv[1] == -40 && input$range_latitude_iv[2] == 40) {
        addClass("button_africa_iv", "green-background")
      } else {
        removeClass("button_africa_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == -175 && input$range_longitude_iv[2] == -10 &&
          input$range_latitude_iv[1] == 5 && input$range_latitude_iv[2] == 85) {
        addClass("button_n_america_iv", "green-background")
      } else {
        removeClass("button_n_america_iv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_iv[1] == -90 && input$range_longitude_iv[2] == -30 &&
          input$range_latitude_iv[1] == -60 && input$range_latitude_iv[2] == 15) {
        addClass("button_s_america_iv", "green-background")
      } else {
        removeClass("button_s_america_iv", "green-background")
      }
    })
    
    # Set iniital lon/lat values and update on button press
    lonlat_vals_dv = reactiveVal(c(initial_lon_values,initial_lat_values))
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global_dv,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(-90,90))
      
      lonlat_vals_dv(c(-180,180,-90,90))
    }) 
    
    observeEvent(input$button_europe_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(30,75))
      
      lonlat_vals_dv(c(-30,40,30,75))
    })
    
    observeEvent(input$button_asia_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(5,80))
      
      lonlat_vals_dv(c(25,170,5,80))
    })
    
    observeEvent(input$button_oceania_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(-55,20))
      
      lonlat_vals_dv(c(90,180,-55,20))
    })
    
    observeEvent(input$button_africa_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(-40,40))
      
      lonlat_vals_dv(c(-25,55,-40,40))
    })
    
    observeEvent(input$button_n_america_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(5,85))
      
      lonlat_vals_dv(c(-175,-10,5,85))
    })
    
    observeEvent(input$button_s_america_dv, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = c(-60,15))
      
      lonlat_vals_dv(c(-90,-30,-60,15))
    })
    
    observeEvent(input$button_coord_dv, {
      lonlat_vals_dv(c(input$range_longitude_dv,input$range_latitude_dv))        
    })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude_dv[1] == -180 && input$range_longitude_dv[2] == 180 &&
          input$range_latitude_dv[1] == -90 && input$range_latitude_dv[2] == 90) {
        addClass("button_global_dv", "green-background")
      } else {
        removeClass("button_global_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == -30 && input$range_longitude_dv[2] == 40 &&
          input$range_latitude_dv[1] == 30 && input$range_latitude_dv[2] == 75) {
        addClass("button_europe_dv", "green-background")
      } else {
        removeClass("button_europe_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == 25 && input$range_longitude_dv[2] == 170 &&
          input$range_latitude_dv[1] == 5 && input$range_latitude_dv[2] == 80) {
        addClass("button_asia_dv", "green-background")
      } else {
        removeClass("button_asia_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == 90 && input$range_longitude_dv[2] == 180 &&
          input$range_latitude_dv[1] == -55 && input$range_latitude_dv[2] == 20) {
        addClass("button_oceania_dv", "green-background")
      } else {
        removeClass("button_oceania_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == -25 && input$range_longitude_dv[2] == 55 &&
          input$range_latitude_dv[1] == -40 && input$range_latitude_dv[2] == 40) {
        addClass("button_africa_dv", "green-background")
      } else {
        removeClass("button_africa_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == -175 && input$range_longitude_dv[2] == -10 &&
          input$range_latitude_dv[1] == 5 && input$range_latitude_dv[2] == 85) {
        addClass("button_n_america_dv", "green-background")
      } else {
        removeClass("button_n_america_dv", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude_dv[1] == -90 && input$range_longitude_dv[2] == -30 &&
          input$range_latitude_dv[1] == -60 && input$range_latitude_dv[2] == 15) {
        addClass("button_s_america_dv", "green-background")
      } else {
        removeClass("button_s_america_dv", "green-background")
      }
    })
    
    ### Interactivity ----
    
    # Map coordinates setter
    observeEvent(input$map_brush4_coeff,{
      
      # Convert x values
      x_brush1_1 = (input$map_brush4_coeff[[1]]*1.14) - (0.14*input$range_longitude_dv[1])
      x_brush1_2 = (input$map_brush4_coeff[[2]]*1.14) - (0.14*input$range_longitude_dv[1])
      
      if (input$source_dv == "ModE-"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_longitude_dv",
          label = NULL,
          value = round(c(x_brush1_1,x_brush1_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_latitude_dv",
          label = NULL,
          value = round(c(input$map_brush4_coeff[[3]],input$map_brush4_coeff[[4]]), digits = 2))
      }
    })
    
    observeEvent(input$map_brush4_pvalue,{
      
      # Convert x values
      x_brush1_1 = (input$map_brush4_pvalue[[1]]*1.14) - (0.14*input$range_longitude_dv[1])
      x_brush1_2 = (input$map_brush4_pvalue[[2]]*1.14) - (0.14*input$range_longitude_dv[1])
      
      if (input$source_dv == "ModE-"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_longitude_dv",
          label = NULL,
          value = round(c(x_brush1_1,x_brush1_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_latitude_dv",
          label = NULL,
          value = round(c(input$map_brush4_pvalue[[3]],input$map_brush4_pvalue[[4]]), digits = 2))
      }
    })
    
    observeEvent(input$map_brush4_resi,{
      
      # Convert x values
      x_brush1_1 = (input$map_brush4_resi[[1]]*1.14) - (0.14*input$range_longitude_dv[1])
      x_brush1_2 = (input$map_brush4_resi[[2]]*1.14) - (0.14*input$range_longitude_dv[1])
      
      if (input$source_dv == "ModE-"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_longitude_dv",
          label = NULL,
          value = round(c(x_brush1_1,x_brush1_2), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_latitude_dv",
          label = NULL,
          value = round(c(input$map_brush4_resi[[3]],input$map_brush4_resi[[4]]), digits = 2))
      }
    })
    
    
  ## MONTHLY TIMESERIES observe, update & interactive controls----
    ### Initialise and update timeseries dataframe ----
    
    # Add in initial data
    monthly_ts_data = reactiveVal(monthly_ts_starter_data())
    # Set tracker to 1 (if tracker is 1, the first line, aka the starter data, gets replaced)
    monthly_ts_tracker = reactiveVal(1)
    
    # Add new data and update related inputs
    observeEvent(input$add_monthly_ts, {
      
      #Combining Shiny Input with ModeRa Data
      data_full <-  load_ModE_data(input$dataset_selected5,input$variable_selected5)
      
      # Replace starter data if tracker = 1
      if (monthly_ts_tracker() == 1){
        monthly_ts_data(create_monthly_TS_data(data_full,input$dataset_selected5,input$variable_selected5,
                                               input$range_years5,input$range_longitude5,
                                               input$range_latitude5,input$mode_selected5,
                                               input$type_selected5,input$ref_period5))
        
        # Limit variable choice to only that already chosen:
        updateSelectInput(
          session = getDefaultReactiveDomain(),
          inputId  = "variable_selected5",
          choices  = monthly_ts_data()[1,3], # Sets choices to only the Variable already selected
          selected = monthly_ts_data()[1,3])
        
        # update tracker
        monthly_ts_tracker(monthly_ts_tracker()+1)
      } 
      # Otherwise, add to dataframe
      else {
        new_rows = create_monthly_TS_data(data_full,input$dataset_selected5,input$variable_selected5,
                                               input$range_years5,input$range_longitude5,
                                               input$range_latitude5,input$mode_selected5,
                                               input$type_selected5,input$ref_period5)
        
        updated_monthly_ts_data = rbind(monthly_ts_data(),new_rows)
        
        monthly_ts_data(updated_monthly_ts_data)
      }
      
    })  
    
    # Remove last ts
    observeEvent(input$remove_last_monthly_ts, {
      monthly_ts_data(monthly_ts_data()[-nrow(monthly_ts_data()),])
      
      # If dataframe is empty, allow all variable choices and replot starter data
      if (dim(monthly_ts_data())[1] == 0){
        updateSelectInput(
          session = getDefaultReactiveDomain(),
          inputId  = "variable_selected5",
          choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
          selected = "Temperature")
        
        monthly_ts_data(monthly_ts_starter_data())
        
        # update tracker
        monthly_ts_tracker(1)
      } 
    })
    
    # Remove all ts
    observeEvent(input$remove_all_monthly_ts, {
      monthly_ts_data(data.frame())
      
      # allow all variable choices and replot starter data
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId  = "variable_selected5",
        choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
        selected = "Temperature")
      
      monthly_ts_data(monthly_ts_starter_data())  
      
      # update tracker
      monthly_ts_tracker(1)
      
    })
    
    
    ### Input updaters ----
    
    # Mode Updater (based on dataset0)
    observe({
      if (input$dataset_selected5 == "ModE-RAclim"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected5",
          label = NULL,
          choices = c("Anomaly"),
          selected =  "Anomaly")
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "mode_selected5",
          label = NULL,
          choices = c("Anomaly","Absolute"))
      }
    })
    
    # Continent buttons - updates range inputs and lonlat_values
    observeEvent(input$button_global5,{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(-180,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(-90,90))
    }) 
    
    observeEvent(input$button_europe5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(-30,40))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(30,75))
    })
    
    observeEvent(input$button_asia5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(25,170))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(5,80))
    })
    
    observeEvent(input$button_oceania5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(90,180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(-55,20))
    })
    
    observeEvent(input$button_africa5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(-25,55))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(-40,40))
    })
    
    observeEvent(input$button_n_america5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(-175,-10))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(5,85))
    })
    
    observeEvent(input$button_s_america5, {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude5",
        label = NULL,
        value = c(-90,-30))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude5",
        label = NULL,
        value = c(-60,15))
    })
    
    # observeEvent(input$button_coord5, {
    #   lonlat_vals5(c(input$range_longitude5,input$range_latitude5))        
    # })
    
    #Make continental buttons stay highlighted
    observe({
      if (input$range_longitude5[1] == -180 && input$range_longitude5[2] == 180 &&
          input$range_latitude5[1] == -90 && input$range_latitude5[2] == 90) {
        addClass("button_global5", "green-background")
      } else {
        removeClass("button_global5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == -30 && input$range_longitude5[2] == 40 &&
          input$range_latitude5[1] == 30 && input$range_latitude5[2] == 75) {
        addClass("button_europe5", "green-background")
      } else {
        removeClass("button_europe5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == 25 && input$range_longitude5[2] == 170 &&
          input$range_latitude5[1] == 5 && input$range_latitude5[2] == 80) {
        addClass("button_asia5", "green-background")
      } else {
        removeClass("button_asia5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == 90 && input$range_longitude5[2] == 180 &&
          input$range_latitude5[1] == -55 && input$range_latitude5[2] == 20) {
        addClass("button_oceania5", "green-background")
      } else {
        removeClass("button_oceania5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == -25 && input$range_longitude5[2] == 55 &&
          input$range_latitude5[1] == -40 && input$range_latitude5[2] == 40) {
        addClass("button_africa5", "green-background")
      } else {
        removeClass("button_africa5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == -175 && input$range_longitude5[2] == -10 &&
          input$range_latitude5[1] == 5 && input$range_latitude5[2] == 85) {
        addClass("button_n_america5", "green-background")
      } else {
        removeClass("button_n_america5", "green-background")
      }
    })
    
    observe({
      if (input$range_longitude5[1] == -90 && input$range_longitude5[2] == -30 &&
          input$range_latitude5[1] == -60 && input$range_latitude5[2] == 15) {
        addClass("button_s_america5", "green-background")
      } else {
        removeClass("button_s_america5", "green-background")
      }
    })
    
    
    ### Interactivity ----
    
    # TS point/line setter
    observeEvent(input$ts_click5,{
      if (input$custom_features_ts5 == TRUE){
        if (input$feature_ts5 == "Point"){
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_x_ts5",
            label = NULL,
            value = as.character(round(input$ts_click5$x, digits = 2))
          )
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "point_location_y_ts5",
            label = NULL,
            value = as.character(round(input$ts_click5$y, digits = 2))
          )
        } 
        else if (input$feature_ts5 == "Line"){
          updateRadioButtons(
            session = getDefaultReactiveDomain(),
            inputId = "line_orientation_ts5",
            label = NULL,
            selected = "Vertical")
          
          updateTextInput(
            session = getDefaultReactiveDomain(),
            inputId = "line_position_ts5",
            label = NULL,
            value = as.character(round(input$ts_click5$x, digits = 2))
          )
        }
      }
    })
    
    observeEvent(input$ts_dblclick5,{
      if (input$custom_features_ts5 == TRUE & input$feature_ts5 == "Line"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "line_orientation_ts5",
          label = NULL,
          selected = "Horizontal")
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "line_position_ts5",
          label = NULL,
          value = as.character(round(input$ts_dblclick5$y, digits = 2))
        )
      }
    })
    
    # TS highlight setter
    observeEvent(input$ts_brush5,{
      if (input$custom_features_ts5 == TRUE & input$feature_ts5 == "Highlight"){
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_x_values_ts5",
          label = NULL,
          value = round(c(input$ts_brush5[[1]],input$ts_brush5[[2]]), digits = 2))
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "highlight_y_values_ts5",
          label = NULL,
          value = round(c(input$ts_brush5[[3]],input$ts_brush5[[4]]), digits = 2))
      }
    })
    
    ### Initialise and update custom points lines highlights ----
    
    ts_points_data5 = reactiveVal(data.frame())
    ts_highlights_data5 = reactiveVal(data.frame())
    ts_lines_data5 = reactiveVal(data.frame())
    
    # time series Points
    observeEvent(input$add_point_ts5, {
      ts_points_data5(rbind(ts_points_data5(),
                            create_new_points_data(input$point_location_x_ts5,input$point_location_y_ts5,
                                                   input$point_label_ts5,input$point_shape_ts5,
                                                   input$point_colour_ts5,input$point_size_ts5)))
    })  
    
    observeEvent(input$remove_last_point_ts5, {
      ts_points_data5(ts_points_data5()[-nrow(ts_points_data5()),])
    })
    
    observeEvent(input$remove_all_points_ts5, {
      ts_points_data5(data.frame())
    })
    
    # time series Highlights
    observeEvent(input$add_highlight_ts5, {
      ts_highlights_data5(rbind(ts_highlights_data5(),
                                create_new_highlights_data(input$highlight_x_values_ts5,input$highlight_y_values_ts5,
                                                           input$highlight_colour_ts5,input$highlight_type_ts5,
                                                           input$show_highlight_on_legend_ts5,input$highlight_label_ts5)))
    })  
    
    observeEvent(input$remove_last_highlight_ts5, {
      ts_highlights_data5(ts_highlights_data5()[-nrow(ts_highlights_data5()),])
    })
    
    observeEvent(input$remove_all_highlights_ts5, {
      ts_highlights_data5(data.frame())
    })
    
    # time series Lines
    observeEvent(input$add_line_ts5, {
      ts_lines_data5(rbind(ts_lines_data5(),
                           create_new_lines_data(input$line_orientation_ts5,input$line_position_ts5,
                                                 input$line_colour_ts5,input$line_type_ts5,
                                                 input$show_line_on_legend_ts5,input$line_label_ts5)))
    })  
    
    observeEvent(input$remove_last_line_ts5, {
      ts_lines_data5(ts_lines_data5()[-nrow(ts_lines_data5()),])
    })
    
    observeEvent(input$remove_all_lines_ts5, {
      ts_lines_data5(data.frame())
    })
    
  #Processing and Plotting ----
  ## GENERAL data processing and plotting ----  
  #Preparation
  
  month_range <- reactive({
    #Creating Numeric Vector for Month Range
    mr = create_month_range(input$range_months) #Between 0-12  
    
    return(mr)
  })
  
  subset_lons <- eventReactive(lonlat_vals(), {
    
    slons = create_subset_lon_IDs(lonlat_vals()[1:2]) 
    
    return(slons)
  })
  
  subset_lats <- eventReactive(lonlat_vals(), {
    
    slats = create_subset_lat_IDs(lonlat_vals()[3:4]) 
    
    return(slats)
  })
  
  pp_id <- reactive({
    
    #Generating Pre Processed Data
    ppid = generate_pp_data_ID(input$dataset_selected,input$variable_selected, month_range())
    
    return(ppid)
  })
  
  #Geographic Subset
  data_output1 <- reactive({
    
    #Combining Shiny Input with ModeRa Data
    data_input <-   load_ModE_data(input$dataset_selected,input$variable_selected)
    
    #Geographic Subset Function
    processed_data  <- create_latlon_subset(data_input, pp_id(), subset_lons(), subset_lats())                
    
    return(processed_data)
  })
  
  #Creating yearly subset
  data_output2 <- reactive({
    #Creating a reduced time range  
    processed_data2 <- create_yearly_subset(data_output1(), pp_id(), input$range_years, month_range())              
    
    return(processed_data2)  
  })
  
  #Converting absolutes to anomalies
  data_output3 <- reactive({
    
    processed_data3 <- convert_subset_to_anomalies(data_output2(), data_output1(), pp_id(), month_range(), input$ref_period)
  
    return(processed_data3)
  })
  
  # Calculating Ref data for plotting
  data_output4 <- reactive({
    
    processed_data4 <- data_output2()-data_output3()
    
    return(processed_data4)
  })
  
  #Map customization (statistics and map titles)
  
  plot_titles <- reactive({
    
    my_title <- generate_titles("general",input$dataset_selected, input$variable_selected, "Anomaly", input$title_mode,input$title_mode_ts,
                                 month_range(), input$range_years, input$ref_period, NA,lonlat_vals()[1:2],lonlat_vals()[3:4],
                                 input$title1_input, input$title2_input,input$title1_input_ts)
    
    return(my_title)
  })
  
  map_statistics = reactive({
    
    my_stats = create_stat_highlights_data(data_output3(),"general",input$enable_custom_statistics,
                                           input$custom_statistic,input$sd_ratio,
                                           input$percentage_sign_match,input$variable_selected,
                                           subset_lons(),subset_lats(),month_range(),input$range_years)
    
    return(my_stats)
  })
  
  #Plotting the Data (Maps)
  map_data <- function(){create_map_datatable(data_output3(), subset_lons(), subset_lats())}
  
  output$data1 <- renderTable({map_data()}, rownames = TRUE)
  
  #Plotting the Map
  map_dimensions <- reactive({
    
    m_d = generate_map_dimensions(subset_lons(), subset_lats(), session$clientData$output_map_width, input$dimension[2], input$hide_axis)
  
    return(m_d)  
  })
  
  map_plot <- function(){plot_default_map(map_data(), input$variable_selected, "Anomaly", plot_titles(), input$axis_input, input$hide_axis, map_points_data(), map_highlights_data(),map_statistics())}
  
  output$map <- renderPlot({map_plot()},width = function(){map_dimensions()[1]},height = function(){map_dimensions()[2]})
  # code line below sets height as a function of the ratio of lat/lon 
  
  
  #Ref/Absolute/SD ratio Map
  ref_map_data <- function(){
    if (input$ref_map_mode == "Absolute Values"){
      create_map_datatable(data_output2(), subset_lons(), subset_lats())
    } else if (input$ref_map_mode == "Reference Period"){
      create_map_datatable(data_output4(), subset_lons(), subset_lats())
    } else if (input$ref_map_mode == "SD Ratio"){
      # Generate SD data for a single year
      SD_data0 = load_ModE_data("SD Ratio",input$variable_selected)
      
      ## SD Data is going to need to be preprocessed
      
      # Lat/lon subset:
      SD_data1 = create_latlon_subset(SD_data0, c(NA,NA), subset_lons(), subset_lats())  
      # Yearly subset:
      SD_data2 = create_yearly_subset(SD_data1, c(NA,NA), input$range_years, month_range())
      # Map data:
      SD_map_data = create_map_datatable(SD_data2, subset_lons(), subset_lats())
      
      return(SD_map_data)
    }
  }    
  
  ref_map_titles = reactive({
    if (input$ref_map_mode == "Absolute Values"){
      rm_title <- generate_titles("general",input$dataset_selected, input$variable_selected, "Absolute", input$title_mode,input$title_mode_ts,
                                  month_range(), input$range_years, NA, NA,lonlat_vals()[1:2],lonlat_vals()[3:4],
                                  input$title1_input, input$title2_input,input$title1_input_ts)
    } else if (input$ref_map_mode == "Reference Period"){
      rm_title <- generate_titles("general",input$dataset_selected, input$variable_selected, "Absolute", input$title_mode,input$title_mode_ts,
                                  month_range(), input$ref_period, NA, NA,lonlat_vals()[1:2],lonlat_vals()[3:4],
                                  input$title1_input, input$title2_input,input$title1_input_ts)
    } else if (input$ref_map_mode == "SD Ratio"){
      rm_title <- generate_titles("sdratio",input$dataset_selected, input$variable_selected, "Absolute", input$title_mode,input$title_mode_ts,
                                  month_range(), input$range_years, NA, NA,lonlat_vals()[1:2],lonlat_vals()[3:4],
                                  input$title1_input, input$title2_input,input$title1_input_ts)
    }
  })  
  
  ref_map_plot <- function(){
    if (input$ref_map_mode == "Absolute Values" | input$ref_map_mode == "Reference Period" ){
      plot_default_map(ref_map_data(), input$variable_selected, "Absolute", ref_map_titles(), NULL, FALSE, data.frame(), data.frame(),data.frame())
    } else if(input$ref_map_mode == "SD Ratio"){
      plot_default_map(ref_map_data(), "SD Ratio", "Absolute", ref_map_titles(), c(0,1), FALSE, data.frame(), data.frame(),data.frame())
    }
  }
  
  output$ref_map <- renderPlot({ref_map_plot()},width = function(){map_dimensions()[1]},height = function(){map_dimensions()[2]})
  
  
  #Plotting the data (time series)
  timeseries_data <- reactive({
    #Plot normal timeseries if year range is > 1 year
    if (input$range_years[1] != input$range_years[2]){
      ts_data1 <- create_timeseries_datatable(data_output3(), input$range_years, "range", subset_lons(), subset_lats())
      
      MA_alignment = switch(input$year_position_ts,
                            "before" = "left",
                            "on" = "center",
                            "after" = "right")
      
      ts_data2 = add_stats_to_TS_datatable(ts_data1,input$custom_average_ts,input$year_moving_ts,
                                           MA_alignment,input$custom_percentile_ts,input$percentile_ts,input$moving_percentile_ts)
    } 
    # Plot monthly TS if year range = 1 year
    else {
      ts_data1 = load_ModE_data(input$dataset_selected,input$variable_selected)
      
      ts_data2 = create_monthly_TS_data(ts_data1,input$dataset_selected,input$variable_selected,
                             input$range_years[1],input$range_longitude,
                             input$range_latitude,"Anomaly",
                             "Individual years",input$ref_period)
    }
    return(ts_data2)
  })
  
  timeseries_data_output = reactive({
    if (input$range_years[1] != input$range_years[2]){
      output_ts_table = rewrite_tstable(timeseries_data(),input$variable_selected)
    } else {
      output_ts_table = timeseries_data()
    }
    return(output_ts_table) 
  })
  
  output$data2 <- renderDataTable({timeseries_data_output()}, rownames = FALSE, options = list(
    autoWidth = TRUE, 
    searching = FALSE,
    paging = TRUE,
    pagingType = "numbers"
  ))
  
  #Plotting the time series
  timeseries_plot <- function(){
    #Plot normal timeseries if year range is > 1 year
    if (input$range_years[1] != input$range_years[2]){
      # Generate NA or reference mean
      if(input$show_ref_ts == TRUE){
        ref_ts = signif(mean(data_output4()),3)
      } else {
        ref_ts = NA
      }
      
      plot_default_timeseries(timeseries_data(),"general",input$variable_selected,plot_titles(),input$title_mode_ts,ref_ts)
      add_highlighted_areas(ts_highlights_data())
      add_percentiles(timeseries_data())
      add_custom_lines(ts_lines_data())
      add_timeseries(timeseries_data(),"general",input$variable_selected)
      add_boxes(ts_highlights_data())
      add_custom_points(ts_points_data())
      if (input$show_key_ts == TRUE){
        add_TS_key(input$key_position_ts,ts_highlights_data(),ts_lines_data(),input$variable_selected,month_range(),
                   input$custom_average_ts,input$year_moving_ts,input$custom_percentile_ts,input$percentile_ts,NA,NA,TRUE)
      }
    } 
    # Plot monthly TS if year range = 1 year
    else {
      plot_monthly_timeseries(timeseries_data(),plot_titles()$ts_title,"Custom","topright","base")
      add_highlighted_areas(ts_highlights_data())
      add_custom_lines(ts_lines_data())
      plot_monthly_timeseries(timeseries_data(),plot_titles()$ts_title,"Custom","topright","lines")
      add_boxes(ts_highlights_data())
      add_custom_points(ts_points_data())
      if (input$show_key_ts == TRUE){
        add_TS_key(input$key_position_ts,ts_highlights_data(),ts_lines_data(),input$variable_selected,month_range(),
                   input$custom_average_ts,input$year_moving_ts,input$custom_percentile_ts,input$percentile_ts,NA,NA,TRUE)
      }
    }
  }
  
  output$timeseries <- renderPlot({timeseries_plot()}, height = 400)
  
    ### ModE-RA sources ----
    #ModE-RA sources
    
    ranges  <- reactiveValues(x = NULL, y = NULL)
    ranges2 <- reactiveValues(x = NULL, y = NULL)
  
    fad_wa <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a, "winter", lonlat_vals()[1:2], lonlat_vals()[3:4], labs)}
    fad_sa <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a, "summer", lonlat_vals()[1:2], lonlat_vals()[3:4], labs)}
    
    # Upper map (Original)
    output$fad_winter_map_a <- renderPlot({
      if ((month_range()[1] >= 4) && (month_range()[2] <= 9)) {
        plot_data <- fad_sa(labs = TRUE)
      } else {
        plot_data <- fad_wa(labs = TRUE)
      }
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Upper map (Zoom)
    output$fad_zoom_winter_a <- renderPlot({
      if ((month_range()[1] >= 4) && (month_range()[2] <= 9)) {
        plot_data <- fad_sa(labs = FALSE)
      } else {
        plot_data <- fad_wa(labs = FALSE)
      }
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges$x, ylim = ranges$y, crs = st_crs(4326))
      
      plot_data
    })
      
    
    # Lower map (Original)
    output$fad_summer_map_a <- renderPlot({
      if ((month_range()[1] >= 4 && month_range()[2] <= 9) | (month_range()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa(labs = TRUE)  
      } 
    
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Lower map (Zoom)
    output$fad_zoom_summer_a <- renderPlot({
      if ((month_range()[1] >= 4 && month_range()[2] <= 9) || (month_range()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa(labs = FALSE)
      }
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges2$x, ylim = ranges2$y, crs = st_crs(4326))
      
      plot_data
    })
    

    #Update Modera source year input and Brushes when Double Click happens
    
    observeEvent(input$range_years[1], {
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_a",
        value = input$range_years[1])
    })
    
    observe({
      brush <- input$brush_fad1a
      if (!is.null(brush)) {
        ranges$x <- c(brush$xmin, brush$xmax)
        ranges$y <- c(brush$ymin, brush$ymax)

      } else {
        ranges$x <- lonlat_vals()[1:2]
        ranges$y <- lonlat_vals()[3:4]
      }
    })
    
    observe({
      brush_b <- input$brush_fad1b
      if (!is.null(brush_b)) {
        ranges2$x <- c(brush_b$xmin, brush_b$xmax)
        ranges2$y <- c(brush_b$ymin, brush_b$ymax)

      } else {
        ranges2$x <- lonlat_vals()[1:2]
        ranges2$y <- lonlat_vals()[3:4]
      }
    })
    
    ### Downloads ----
    #Downloading General data
    output$download_map             <- downloadHandler(filename = function(){paste(plot_titles()$file_title,"-map.",input$file_type_map, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_map == "png"){
                                                           png(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200)  
                                                           map_plot() 
                                                           dev.off()
                                                         } else if (input$file_type_map == "jpeg"){
                                                           jpeg(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200) 
                                                           map_plot() 
                                                           dev.off()
                                                         } else {
                                                           pdf(file, width = map_dimensions()[3]/200 , height = map_dimensions()[4]/200) 
                                                           map_plot()
                                                           dev.off()
                                                         }})
    
    output$download_map_sec         <- downloadHandler(filename = function(){paste(plot_titles()$file_title,"-sec_map.",input$file_type_map, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_map == "png"){
                                                           png(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200)  
                                                           ref_map_plot() 
                                                           dev.off()
                                                         } else if (input$file_type_map == "jpeg"){
                                                           jpeg(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200) 
                                                           ref_map_plot() 
                                                           dev.off()
                                                         } else {
                                                           pdf(file, width = map_dimensions()[3]/200 , height = map_dimensions()[4]/200) 
                                                           ref_map_plot()
                                                           dev.off()
                                                         }})
    
    output$download_timeseries      <- downloadHandler(filename = function(){paste(plot_titles()$file_title,"-ts.",input$file_type_timeseries, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries == "png"){
                                                           png(file, width = 3000, height = 1285, res = 200) 
                                                           timeseries_plot() 
                                                           dev.off()
                                                         } else if (input$file_type_timeseries == "jpeg"){
                                                           jpeg(file, width = 3000, height = 1285, res = 200) 
                                                           timeseries_plot() 
                                                           dev.off()
                                                         } else {
                                                           pdf(file, width = 14, height = 6) 
                                                           timeseries_plot()
                                                           dev.off()
                                                         }}) 
    
    output$download_map_data        <- downloadHandler(filename = function(){paste(plot_titles()$file_title, "-mapdata.",input$file_type_map_data, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_map_data == "csv"){
                                                           write.csv(rewrite_maptable(map_data(), subset_lons(), subset_lats()), file,
                                                                     row.names = FALSE,
                                                                     col.names = FALSE)
                                                         } else {
                                                           write.xlsx(rewrite_maptable(map_data(), subset_lons(), subset_lats()), file,
                                                                      row.names = FALSE,
                                                                      col.names = FALSE)
                                                         }})
    
    output$download_timeseries_data  <- downloadHandler(filename = function(){paste(plot_titles()$file_title, "-tsdata.",input$file_type_timeseries_data, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_timeseries_data == "csv"){
                                                            write.csv(timeseries_data_output(), file,
                                                                      row.names = FALSE,
                                                                      col.names = TRUE)
                                                          } else {
                                                            write.xlsx(timeseries_data_output(), file,
                                                                       row.names = FALSE,
                                                                       col.names = TRUE)
                                                          }})
    
    output$download_fad_sa             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a, "-modera_source.",input$file_type_modera_source_b, sep = "")},
                                                          content  = function(file) {
                                                            
                                                            mmd = generate_map_dimensions(subset_lons(), subset_lats(), session$clientData$output_fad_winter_map_a_width, input$dimension[2], FALSE)
                                                            if (input$file_type_modera_source_b == "png"){
                                                              png(file, width = mmd[3] , height = mmd[4], res = 400)  
                                                              print(fad_sa(labs = TRUE))
                                                              dev.off()
                                                            } else if (input$file_type_modera_source_b == "jpeg"){
                                                              jpeg(file, width = mmd[3] , height = mmd[4], res = 400) 
                                                              print(fad_sa(labs = TRUE)) 
                                                              dev.off()
                                                            } else {
                                                              pdf(file, width = mmd[3]/400 , height = mmd[4]/400) 
                                                              print(fad_sa(labs = TRUE))
                                                              dev.off()
                                                            }})

    output$download_fad_wa             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a, "-modera_source.",input$file_type_modera_source_a, sep = "")},
                                                          content  = function(file) {
                                                            
                                                            mmd = generate_map_dimensions(subset_lons(), subset_lats(), session$clientData$output_fad_winter_map_a_width, input$dimension[2], FALSE)
                                                            
                                                            if (input$file_type_modera_source_a == "png"){
                                                              png(file, width = mmd[3] , height = mmd[4], res = 400)  
                                                              print(fad_wa(labs = TRUE))
                                                              dev.off()
                                                            } else if (input$file_type_modera_source_a == "jpeg"){
                                                              jpeg(file, width = mmd[3] , height = mmd[4], res = 400) 
                                                              print(fad_wa(labs = TRUE)) 
                                                              dev.off()
                                                            } else {
                                                              pdf(file, width = mmd[3]/400 , height = mmd[4]/400) 
                                                              print(fad_wa(labs = TRUE))
                                                              dev.off()
                                                            }})
    
    output$download_netcdf             <- downloadHandler(filename = function() {paste(plot_titles()$netcdf_title, ".nc", sep = "")},
                                                          content  = function(file) {
                                                            netcdf_ID = sample(1:1000000,1)
                                                            generate_custom_netcdf (data_output3(), "general",input$dataset_selected,netcdf_ID, input$variable_selected, input$netcdf_variables, "Anomaly", subset_lons(), subset_lats(), month_range(), input$range_years, input$ref_period, NA)
                                                            file.copy(paste("user_ncdf/netcdf_",netcdf_ID,".nc", sep=""),file)
                                                            file.remove(paste("user_ncdf/netcdf_",netcdf_ID,".nc", sep=""))
                                                          })
 
  ## COMPOSITE data processing and plotting ----      
  
  ##Preparation
  
  month_range_2 <- reactive({
    #Creating Numeric Vector for Month Range
    mr2 = create_month_range(input$range_months2) #Between 0-12  
    
    return(mr2)
  })
  
  subset_lons_2 <- eventReactive(lonlat_vals2(), {
    
    slons2 = create_subset_lon_IDs(lonlat_vals2()[1:2]) 
    
    return(slons2)
  })
  
  subset_lats_2 <- eventReactive(lonlat_vals2(), {
    
    slats2 = create_subset_lat_IDs(lonlat_vals2()[3:4]) 
    
    return(slats2)
  })
  
  pp_id_2 <- reactive({
    
    ppid2 = generate_pp_data_ID(input$dataset_selected2,input$variable_selected2, month_range_2())
    
    return(ppid2)
  })      
  
  year_set_comp <- reactive({
    
    #Creating a year set for composite
    ysc = read_composite_data(input$range_years2, input$upload_file2$datapath, input$enter_upload2)
    
    return(ysc)
  })
  
  #List of custom anomaly years (from read Composite) as reference data
  
  year_set_comp_ref <- reactive({
    
    yscr = read_composite_data(input$range_years2a, input$upload_file2a$datapath, input$enter_upload2a)
      
    return(yscr)  
    
  })
  
  #Geographic Subset
  data_output1_2 <- reactive({
    
    #Combining Shiny Input with ModeRa Data
    data_input_2 <-   load_ModE_data(input$dataset_selected2,input$variable_selected2)
    
    #Geographic Subset Function
    processed_data_2  <- create_latlon_subset(data_input_2, pp_id_2(), subset_lons_2(), subset_lats_2())                
    
    return(processed_data_2)
  })
  
  #Creating yearly subset for Composites
  data_output2_2 <- reactive({
    
    #Creating a reduced time range
    processed_data2_2 <- create_yearly_subset_composite(data_output1_2(), pp_id_2(), year_set_comp(), month_range_2())              
    
    return(processed_data2_2)  
  })
  
  #Converting Composite to anomalies either fixed period or X years prior or list of years
  data_output3_2 <- reactive({
    
    #Calculate two ways of anomalies (if selected)
    if (input$mode_selected2 == "Fixed reference"){
      processed_data3_2 <- convert_subset_to_anomalies(data_output2_2(), data_output1_2(), pp_id_2(), month_range_2(), input$ref_period2)
    } else if (input$mode_selected2 == "Compared to X years prior"){
      processed_data3_2 <- convert_composite_to_anomalies(data_output2_2(), data_output1_2(), pp_id_2(), year_set_comp(), month_range_2(), input$prior_years2)
    } else {
      processed_data3_2 <- convert_subset_to_anomalies(data_output2_2(), data_output1_2(), pp_id_2(), month_range_2(), year_set_comp_ref())
    }

    return(processed_data3_2)
  })

  # Calculating Ref data for plotting
  data_output4_2 <- reactive({
    
    processed_data4_2 <- data_output2_2()-data_output3_2()
    
    return(processed_data4_2)
  })
    
  #Map customization (statistics and map titles)
  
  plot_titles_2 <- reactive({
    
    my_title <- generate_titles ("composites", input$dataset_selected2, input$variable_selected2, input$mode_selected2, input$title_mode2,input$title_mode_ts2,
                                 month_range_2(), input$range_years2, input$ref_period2, input$prior_years2,lonlat_vals2()[1:2],lonlat_vals2()[3:4],
                                 input$title1_input2, input$title2_input2,input$title1_input_ts2)
    
    return(my_title)
  })
  
  
  map_statistics_2 = reactive({
    
    my_stats = create_stat_highlights_data(data_output3_2(),"composites",input$enable_custom_statistics2,
                                           input$custom_statistic2,input$sd_ratio2,
                                           input$percentage_sign_match2,input$variable_selected2,
                                           subset_lons_2(),subset_lats_2(),month_range_2(),year_set_comp())
    
    return(my_stats)
  })
  
  #Plotting the Data (Maps)
  map_data_2 <- function(){create_map_datatable(data_output3_2(), subset_lons_2(), subset_lats_2())}
  
  output$data3 <- renderTable({map_data_2()}, rownames = TRUE)
  
  #Plotting the Map
  map_dimensions_2 <- reactive({
    
    m_d_2 = generate_map_dimensions(subset_lons_2(), subset_lats_2(), session$clientData$output_map2_width, input$dimension[2]*0.85, input$hide_axis2)
    
    return(m_d_2)
  })
  
  map_plot_2 <- function(){plot_default_map(map_data_2(), input$variable_selected2, input$mode_selected2, plot_titles_2(), input$axis_input2, input$hide_axis2, map_points_data2(), map_highlights_data2(),map_statistics_2())}
  
  output$map2 <- renderPlot({map_plot_2()},width = function(){map_dimensions_2()[1]},height = function(){map_dimensions_2()[2]})
  # code line below sets height as a function of the ratio of lat/lon 
  
  
  #Ref/Absolute Map
  ref_map_data_2 <- function(){
    if (input$ref_map_mode2 == "Absolute Values"){
      create_map_datatable(data_output2_2(), subset_lons_2(), subset_lats_2())
    } else if (input$ref_map_mode2 == "Reference Period"){
      create_map_datatable(data_output4_2(), subset_lons_2(), subset_lats_2())
    } else if (input$ref_map_mode2 == "SD Ratio"){
      # Generate SD data for a single year
      SD_data0_2 = load_ModE_data("SD Ratio",input$variable_selected2)
      
      ## SD Data is going to need to be preprocessed
      
      # Lat/lon subset:
      SD_data1_2 = create_latlon_subset(SD_data0_2, c(NA,NA), subset_lons_2(), subset_lats_2())  
      # Yearly subset:
      SD_data2_2 = create_yearly_subset_composite(SD_data1_2, c(NA,NA), year_set_comp(), month_range_2())
      # Map data:
      SD_map_data_2 = create_map_datatable(SD_data2_2, subset_lons_2(), subset_lats_2())
      
      return(SD_map_data_2)
    }
  }    
  
  ref_map_titles_2 = reactive({
    if (input$ref_map_mode2 == "Absolute Values"){
      rm_title2 <- generate_titles("composites",input$dataset_selected2, input$variable_selected2, "Absolute", input$title_mode2,input$title_mode_ts2,
                                  month_range_2(), year_set_comp(), NA, NA,lonlat_vals2()[1:2],lonlat_vals2()[3:4],
                                  input$title1_input2, input$title2_input2,input$title1_input_ts2)
    } else if (input$ref_map_mode2 == "Reference Period"){
      rm_title2 <- generate_titles("reference",input$dataset_selected2, input$variable_selected2, "Absolute", input$title_mode2,input$title_mode_ts2,
                                  month_range_2(), year_set_comp_ref(), NA, NA,lonlat_vals2()[1:2],lonlat_vals2()[3:4],
                                  input$title1_input2, input$title2_input2,input$title1_input_ts2)
    } else if (input$ref_map_mode2 == "SD Ratio"){
      rm_title2 <- generate_titles("sdratio",input$dataset_selected2, input$variable_selected2, "Absolute", input$title_mode2,input$title_mode_ts2,
                                  month_range_2(), c(NA,NA), NA, NA,lonlat_vals2()[1:2],lonlat_vals2()[3:4],
                                  input$title1_input2, input$title2_input2,input$title1_input_ts2)
    }
  })  
  
  ref_map_plot_2 <- function(){
    if (input$ref_map_mode2 == "Absolute Values" | input$ref_map_mode2 == "Reference Period" ){
      plot_default_map(ref_map_data_2(), input$variable_selected2, "Absolute", ref_map_titles_2(), NULL, FALSE, data.frame(), data.frame(),data.frame())
    } else if (input$ref_map_mode2 == "SD Ratio"){
      plot_default_map(ref_map_data_2(), "SD Ratio", "Absolute", ref_map_titles_2(), c(0,1), FALSE, data.frame(), data.frame(),data.frame())
    }
  }
  
  output$ref_map2 <- renderPlot({ref_map_plot_2()},width = function(){map_dimensions_2()[1]},height = function(){map_dimensions_2()[2]})
  
  
  #Plotting the data (time series)
  timeseries_data_2 <- reactive({
    #Plot normal timeseries if year set is > 1 year
    if (length(year_set_comp()) > 1){    
      ts_data1 <- create_timeseries_datatable(data_output3_2(), year_set_comp(), "set", subset_lons_2(), subset_lats_2())
      
      ts_data2 = add_stats_to_TS_datatable(ts_data1,FALSE,NA,NA,input$custom_percentile_ts2,
                                           input$percentile_ts2,FALSE)
    } 
    # Plot monthly TS if year range = 1 year
    else {
      ts_data1 = load_ModE_data(input$dataset_selected2,input$variable_selected2)
      
      # Generate ref years
      if (input$mode_selected2 == "Fixed reference"){
        ref_years = input$ref_period2
      } else if (input$mode_selected2 == "Compared to X years prior"){
        ref_years = c((year_set_comp()-input$prior_years2),year_set_comp()-1)
      } else {
        ref_years = year_set_comp_ref()
      }
      
      ts_data2 = create_monthly_TS_data(ts_data1,input$dataset_selected2,input$variable_selected2,
                                        year_set_comp(),input$range_longitude2,
                                        input$range_latitude2,"Anomaly",
                                        "Individual years",ref_years)
    }
    return(ts_data2)
  })
  
  timeseries_data_output_2 = reactive({
    if (length(year_set_comp()) > 1){ 
      output_ts_table = rewrite_tstable(timeseries_data_2(),input$variable_selected2)
    } else {
      output_ts_table = timeseries_data_2()
    }
    return(output_ts_table) 
  })
  
  output$data4 <- renderDataTable({timeseries_data_output_2()}, rownames = FALSE, options = list(
    autoWidth = TRUE, 
    searching = FALSE,
    paging = TRUE,
    pagingType = "numbers"
  ))
  
  #Plotting the time series
  timeseries_plot_2 <- function(){
    #Plot normal timeseries if year set is > 1 year
    if (length(year_set_comp()) > 1){  
      # Generate NA or reference mean
      if(input$show_ref_ts2 == TRUE){
        ref_ts2 = signif(mean(data_output4_2()),3)
      } else {
        ref_ts2 = NA
      }
  
      plot_default_timeseries(timeseries_data_2(),"composites",input$variable_selected2,plot_titles_2(),input$title_mode_ts2,ref_ts2)
      add_highlighted_areas(ts_highlights_data2())
      add_percentiles(timeseries_data_2())
      add_custom_lines(ts_lines_data2())
      add_timeseries(timeseries_data_2(),"composites",input$variable_selected2)
      add_boxes(ts_highlights_data2())
      add_custom_points(ts_points_data2())
      if (input$show_key_ts2 == TRUE){
        add_TS_key(input$key_position_ts2,ts_highlights_data2(),ts_lines_data2(),input$variable_selected2,month_range_2(),
                   FALSE,NA,input$custom_percentile_ts2,input$percentile_ts2,NA,NA,TRUE)
      }
    }
    # Plot monthly TS if year range = 1 year
    else {
      plot_monthly_timeseries(timeseries_data_2(),plot_titles_2()$ts_title,"Custom","topright","base")
      add_highlighted_areas(ts_highlights_data2())
      add_custom_lines(ts_lines_data2())
      plot_monthly_timeseries(timeseries_data_2(),plot_titles_2()$ts_title,"Custom","topright","lines")
      add_boxes(ts_highlights_data2())
      add_custom_points(ts_points_data2())
      if (input$show_key_ts2 == TRUE){
        add_TS_key(input$key_position_ts2,ts_highlights_data2(),ts_lines_data2(),input$variable_selected2,month_range_2(),
                   FALSE,NA,input$custom_percentile_ts2,input$percentile_ts2,NA,NA,TRUE)
      }
    }
  }
  
  output$timeseries2 <- renderPlot({timeseries_plot_2()}, height = 400)
  
  #List of chosen composite years (upload or manual) to plot
  output$text_years2 <- renderText("Chosen composite years:")
  output$years2 <- renderText({year_set_comp()})
  output$text_years2b <- renderText("Chosen composite years:")
  output$years2b <- renderText({year_set_comp()})
  
  output$text_custom_years2  <- renderText("Chosen reference years:")
  output$custom_years2       <- renderText({year_set_comp_ref()})
  output$text_custom_years2b <- renderText("Chosen reference years:")
  output$custom_years2b      <- renderText({year_set_comp_ref()})

    ### ModE-RA sources ----
    
  ranges_2  <- reactiveValues(x = NULL, y = NULL)
  ranges2_2 <- reactiveValues(x = NULL, y = NULL)
  
  fad_wa2 <- function(labs) {
    labs = labs
    plot_modera_sources(input$fad_year_a2, "winter", lonlat_vals2()[1:2], lonlat_vals2()[3:4], labs)}
  fad_sa2 <- function(labs) {
    labs = labs
    plot_modera_sources(input$fad_year_a2, "summer", lonlat_vals2()[1:2], lonlat_vals2()[3:4], labs)}
  
  # Upper map (Original)
  output$fad_winter_map_a2 <- renderPlot({
    if ((month_range_2()[1] >= 4) && (month_range_2()[2] <= 9)) {
      plot_data <- fad_sa2(labs = TRUE)
    } else {
      plot_data <- fad_wa2(labs = TRUE)
    }
    
    # Render the "Original Map" with no fixed aspect ratio
    plot_data
  })
  
  # Upper map (Zoom)
  output$fad_zoom_winter_a2 <- renderPlot({
    if ((month_range_2()[1] >= 4) && (month_range_2()[2] <= 9)) {
      plot_data <- fad_sa2(labs = FALSE)
    } else {
      plot_data <- fad_wa2(labs = FALSE)
    }
    
    # Apply coord_sf to the entire map with adjusted limits
    plot_data <- plot_data + coord_sf(xlim = ranges_2$x, ylim = ranges_2$y, crs = st_crs(4326))
    
    plot_data
  })
  
  # Lower map (Original)
  output$fad_summer_map_a2 <- renderPlot({
    if ((month_range_2()[1] >= 4 && month_range_2()[2] <= 9) | (month_range_2()[2] <= 3)) {
      NULL
    } else {
      plot_data <- fad_sa2(labs = TRUE)  
    } 
    
    # Render the "Original Map" with no fixed aspect ratio
    plot_data
  })
  
  # Lower map (Zoom)
  output$fad_zoom_summer_a2 <- renderPlot({
    if ((month_range_2()[1] >= 4 && month_range_2()[2] <= 9) || (month_range_2()[2] <= 3)) {
      NULL
    } else {
      plot_data <- fad_sa2(labs = FALSE)
    }
    
    # Apply coord_sf to the entire map with adjusted limits
    plot_data <- plot_data + coord_sf(xlim = ranges2_2$x, ylim = ranges2_2$y, crs = st_crs(4326))
    
    plot_data
  })
  
    #Update Modera source year input and Update Brush Input
    
    first_value <- reactive({
      fv <- head(year_set_comp(), n = 1)
      return(fv)
    })
    
    last_value <- reactive({
      lv <- max(year_set_comp(), n = 1)
      return(lv)
    })
    
    observeEvent(first_value(), {
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_a2",
        value = first_value()
      )
    })
    
    observeEvent(last_value(), {
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_b2",
        value = last_value()
      )
    })
    
    observe({
      brush2 <- input$brush_fad1a2
      if (!is.null(brush2)) {
        ranges_2$x <- c(brush2$xmin, brush2$xmax)
        ranges_2$y <- c(brush2$ymin, brush2$ymax)
        
      } else {
        ranges_2$x <- lonlat_vals2()[1:2]
        ranges_2$y <- lonlat_vals2()[3:4]
      }
    })
    
    observe({
      brush_b2 <- input$brush_fad1b2
      if (!is.null(brush_b2)) {
        ranges2_2$x <- c(brush_b2$xmin, brush_b2$xmax)
        ranges2_2$y <- c(brush_b2$ymin, brush_b2$ymax)
        
      } else {
        ranges2_2$x <- lonlat_vals2()[1:2]
        ranges2_2$y <- lonlat_vals2()[3:4]
      }
    })
    

    ### Downloads ----
    #Downloading General data
    output$download_map2             <- downloadHandler(filename = function(){paste(plot_titles_2()$file_title,"-map.",input$file_type_map2, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_map2 == "png"){
                                                            png(file, width = map_dimensions_2()[3] , height = map_dimensions_2()[4], res = 200) 
                                                            map_plot_2() 
                                                            dev.off()
                                                          } else if (input$file_type_map2 == "jpeg"){
                                                            jpeg(file, width = map_dimensions_2()[3] , height = map_dimensions_2()[4], res = 200) 
                                                            map_plot_2() 
                                                            dev.off()
                                                          } else {
                                                            pdf(file, width = map_dimensions_2()[3]/200 , height = map_dimensions_2()[4]/200) 
                                                            map_plot_2()
                                                            dev.off()
                                                          }})
    
    output$download_map_sec2         <- downloadHandler(filename = function(){paste(plot_titles()$file_title,"-sec_map.",input$file_type_map, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_map == "png"){
                                                           png(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200)  
                                                           ref_map_plot_2() 
                                                           dev.off()
                                                         } else if (input$file_type_map == "jpeg"){
                                                           jpeg(file, width = map_dimensions()[3] , height = map_dimensions()[4], res = 200) 
                                                           ref_map_plot_2() 
                                                           dev.off()
                                                         } else {
                                                           pdf(file, width = map_dimensions()[3]/200 , height = map_dimensions()[4]/200) 
                                                           ref_map_plot_2()
                                                           dev.off()
                                                         }})
    
    output$download_timeseries2      <- downloadHandler(filename = function(){paste(plot_titles_2()$file_title,"-ts.",input$file_type_timeseries2, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_timeseries2 == "png"){
                                                            png(file, width = 3000, height = 1285, res = 200) 
                                                            timeseries_plot_2() 
                                                            dev.off()
                                                          } else if (input$file_type_timeseries2 == "jpeg"){
                                                            jpeg(file, width = 3000, height = 1285, res = 200) 
                                                            timeseries_plot_2() 
                                                            dev.off()
                                                          } else {
                                                            pdf(file, width = 14, height = 6) 
                                                            timeseries_plot_2()
                                                            dev.off()
                                                          }}) 
    
    output$download_map_data2        <- downloadHandler(filename = function(){paste(plot_titles_2()$file_title, "-mapdata.",input$file_type_map_data2, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_map_data2 == "csv"){
                                                            write.csv(rewrite_maptable(map_data_2(), subset_lons_2(), subset_lats_2()), file,
                                                                      row.names = FALSE,
                                                                      col.names = FALSE)
                                                          } else {
                                                            write.xlsx(rewrite_maptable(map_data_2(), subset_lons_2(), subset_lats_2()), file,
                                                                       row.names = FALSE,
                                                                       col.names = FALSE)
                                                          }})
    
    output$download_timeseries_data2  <- downloadHandler(filename = function(){paste(plot_titles_2()$file_title, "-tsdata.",input$file_type_timeseries_data2, sep = "")},
                                                         content  = function(file) {
                                                           if (input$file_type_timeseries_data2 == "csv"){
                                                             write.csv(timeseries_data_output_2(), file,
                                                                       row.names = FALSE,
                                                                       col.names = TRUE)
                                                           } else {
                                                             write.xlsx(timeseries_data_output_2(), file,
                                                                        row.names = FALSE,
                                                                        col.names = TRUE)
                                                           }})
    
    output$download_fad_sa2             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a2, "-modera_source.",input$file_type_modera_source_b2, sep = "")},
                                                           content  = function(file) {
                                                             
                                                             mmd2 = generate_map_dimensions(subset_lons_2(), subset_lats_2(), session$clientData$output_fad_winter_map_a2_width, input$dimension[2], FALSE)
                                                             
                                                             if (input$file_type_modera_source_b2 == "png"){
                                                               png(file, width = mmd2[3] , height = mmd2[4], res = 400)  
                                                               print(fad_sa2(labs = TRUE))
                                                               dev.off()
                                                             } else if (input$file_type_modera_source_b2 == "jpeg"){
                                                               jpeg(file, width = mmd2[3] , height = mmd2[4], res = 400) 
                                                               print(fad_sa2(labs = TRUE)) 
                                                               dev.off()
                                                             } else {
                                                               pdf(file, width = mmd2[3]/400 , height = mmd2[4]/400) 
                                                               print(fad_sa2(labs = TRUE))
                                                               dev.off()
                                                             }})
    
    output$download_fad_wa2             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a2, "-modera_source.",input$file_type_modera_source_a2, sep = "")},
                                                           content  = function(file) {
                                                             
                                                             mmd2 = generate_map_dimensions(subset_lons_2(), subset_lats_2(), session$clientData$output_fad_winter_map_a2_width, input$dimension[2], FALSE)
                                                             
                                                             if (input$file_type_modera_source_a2 == "png"){
                                                               png(file, width = mmd2[3] , height = mmd2[4], res = 400)  
                                                               print(fad_wa2(labs = TRUE))
                                                               dev.off()
                                                             } else if (input$file_type_modera_source_a2 == "jpeg"){
                                                               jpeg(file, width = mmd2[3] , height = mmd2[4], res = 400) 
                                                               print(fad_wa2(labs = TRUE)) 
                                                               dev.off()
                                                             } else {
                                                               pdf(file, width = mmd2[3]/400 , height = mmd2[4]/400) 
                                                               print(fad_wa2(labs = TRUE))
                                                               dev.off()
                                                             }})
    
 
  ## CORRELATION data processing and plotting ----
    
    # Find shared lonlat
    
    lonlat_vals3 = reactive({
      extract_shared_lonlat(input$type_v1,input$type_v2,input$range_longitude_v1,
                            input$range_latitude_v1,input$range_longitude_v2,
                            input$range_latitude_v2)
    })

    
    ### Variable 1 and 2 ----
    ### User data processing
    
    # Load in user data for variable 1
    user_data_v1 = reactive({
      
      req(input$user_file_v1)
      
      if (input$source_v1 == "User Data"){
        new_data1 = read_regcomp_data(input$user_file_v1$datapath)   
        return(new_data1)
      }
      else{
        return(NULL)
      }
    })
    
    # Load in user data for variable 2
    user_data_v2 = reactive({
      
      req(input$user_file_v2)
      
      if (input$source_v2 == "User Data"){
        new_data2 = read_regcomp_data(input$user_file_v2$datapath)  
        return(new_data2)
      }
      else{
        return(NULL)
      }
    })
    
    # Subset v1 data to year_range and chosen variable
    user_subset_v1 = reactive({

      req(user_data_v1(),input$user_variable_v1)

      usr_ss1 = create_user_data_subset(user_data_v1(),input$user_variable_v1,input$range_years3)

      return(usr_ss1)
    })

    # Subset v2 data to year_range and chosen variable
    user_subset_v2 = reactive({

      req(user_data_v2(),input$user_variable_v2)

      usr_ss2 = create_user_data_subset(user_data_v2(),input$user_variable_v2,input$range_years3)

      return(usr_ss2)
    })

    year_range_cor = reactive({
      
      result <- tryCatch(
        {
          return(extract_year_range(input$source_v1,input$source_v2,input$user_file_v1$datapath,input$user_file_v2$datapath))
          return(yrc)
        },
        error = function(e) {
          showModal(
            # Add modal dialog for warning message
            modalDialog(
              title = "Error",
              "There was an error in processing your uploaded data. 
                  \nPlease check if the file has the correct format.",
              easyClose = FALSE,
              footer = tagList(modalButton("OK"))
            ))
          return(NULL)
        }
      )
      return(result)
    })  
    
    ### Generate ModE-RA data   
    
    # for Variable 1:
    
    # Calculate Month range
    month_range_v1 <- reactive({
      mr_v1 = create_month_range(input$range_months_v1) #Between 0-12  
      return(mr_v1)
    })
    
    # Subset lon/lats
    subset_lons_v1 <- eventReactive(lonlat_vals_v1(), {
      slons_v1 = create_subset_lon_IDs(lonlat_vals_v1()[1:2]) 
      return(slons_v1)
    })
    
    subset_lats_v1 <- eventReactive(lonlat_vals_v1(), {
      slats_v1 = create_subset_lat_IDs(lonlat_vals_v1()[3:4]) 
      return(slats_v1)
    })
    
    # Generate pp ID
    pp_id_v1 <- reactive({
      ppid_v1 = generate_pp_data_ID(input$dataset_selected_v1,input$ME_variable_v1, month_range_v1())
      return(ppid_v1)
    })
    
    #Geographic Subset
    data_output1_v1 <- reactive({ 
      data_input_v1 <-   load_ModE_data(input$dataset_selected_v1,input$ME_variable_v1)
      processed_data_v1  <- create_latlon_subset(data_input_v1, pp_id_v1(), subset_lons_v1(), subset_lats_v1())                
      return(processed_data_v1)
    })
    
    #Creating yearly subset
    data_output2_v1 <- reactive({ 
      processed_data2_v1 <- create_yearly_subset(data_output1_v1(), pp_id_v1(), input$range_years3, month_range_v1())              
      return(processed_data2_v1)  
    })
    
    #Converting absolutes to anomalies
    data_output3_v1 <- reactive({
      if (input$mode_selected_v1 == "Absolute"){
        processed_data3_v1 <- data_output2_v1()
      } else {
        processed_data3_v1 <- convert_subset_to_anomalies(data_output2_v1(), data_output1_v1(), pp_id_v1(), month_range_v1(), input$ref_period_v1)
      }
      return(processed_data3_v1)
    })
    
    #Map titles
    plot_titles_v1 <- reactive({
      my_title_v1 <- generate_titles ("general", input$dataset_selected_v1, input$ME_variable_v1, input$mode_selected_v1,
                                      "Default","Default", month_range_v1(),input$range_years3,
                                      input$ref_period_v1, NA,lonlat_vals_v1()[1:2],lonlat_vals_v1()[3:4],
                                      NA, NA, NA)
      return(my_title_v1)
    }) 
    
    # Generate Map data & plotting function
    map_data_v1 <- function(){create_map_datatable(data_output3_v1(), subset_lons_v1(), subset_lats_v1())}
    
    ME_map_plot_v1 <- function(){plot_default_map(map_data_v1(), input$ME_variable_v1, input$mode_selected_v1, plot_titles_v1(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame())}
    
    # Generate timeseries data & plotting function
    timeseries_data_v1 <- reactive({
      ts_data1_v1 <- create_timeseries_datatable(data_output3_v1(), input$range_years3, "range", subset_lons_v1(), subset_lats_v1())
      return(ts_data1_v1)
    })
    
    ME_timeseries_plot_v1 = function(){plot_default_timeseries(timeseries_data_v1(),"general",input$ME_variable_v1,plot_titles_v1(),"Default",NA)}
    
    
    # for Variable 2:
    
    # Calculate Month range
    month_range_v2 <- reactive({
      mr_v2 = create_month_range(input$range_months_v2) #Between 0-12  
      return(mr_v2)
    })
    
    # Subset lon/lats
    subset_lons_v2 <- eventReactive(lonlat_vals_v2(), {
      slons_v2 = create_subset_lon_IDs(lonlat_vals_v2()[1:2]) 
      return(slons_v2)
    })
    
    subset_lats_v2 <- eventReactive(lonlat_vals_v2(), {
      slats_v2 = create_subset_lat_IDs(lonlat_vals_v2()[3:4]) 
      return(slats_v2)
    })
    
    # Generate pp ID
    pp_id_v2 <- reactive({
      ppid_v2 = generate_pp_data_ID(input$dataset_selected_v2,input$ME_variable_v2, month_range_v2())
      return(ppid_v2)
    })
    
    #Geographic Subset
    data_output1_v2 <- reactive({ 
      data_input_v2 <- load_ModE_data(input$dataset_selected_v2,input$ME_variable_v2)
      processed_data_v2  <- create_latlon_subset(data_input_v2, pp_id_v2(), subset_lons_v2(), subset_lats_v2())                
      return(processed_data_v2)
    })
    
    #Creating yearly subset
    data_output2_v2 <- reactive({ 
      processed_data2_v2 <- create_yearly_subset(data_output1_v2(), pp_id_v2(), input$range_years3, month_range_v2())              
      return(processed_data2_v2)  
    })
    
    #Converting absolutes to anomalies
    data_output3_v2 <- reactive({
      if (input$mode_selected_v2 == "Absolute"){
        processed_data3_v2 <- data_output2_v2()
      } else {
        processed_data3_v2 <- convert_subset_to_anomalies(data_output2_v2(), data_output1_v2(), pp_id_v2(), month_range_v2(), input$ref_period_v2)
      }
      return(processed_data3_v2)
    })
    
    #Map titles
    plot_titles_v2 <- reactive({
      my_title_v2 <- generate_titles ("general", input$dataset_selected_v2,input$ME_variable_v2, input$mode_selected_v2,
                                      "Default","Default", month_range_v2(),input$range_years3,
                                      input$ref_period_v2, NA,lonlat_vals_v2()[1:2],lonlat_vals_v2()[3:4],
                                      NA, NA, NA)
      return(my_title_v2)
    }) 
    
    # Generate Map data & plotting function
    map_data_v2 <- function(){create_map_datatable(data_output3_v2(), subset_lons_v2(), subset_lats_v2())}
    
    ME_map_plot_v2 <- function(){plot_default_map(map_data_v2(), input$ME_variable_v2, input$mode_selected_v2, plot_titles_v2(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame())}
    
    # Generate time series data & plotting function
    timeseries_data_v2 <- reactive({
      ts_data1_v2 <- create_timeseries_datatable(data_output3_v2(), input$range_years3, "range", subset_lons_v2(), subset_lats_v2())
      return(ts_data1_v2)
    })
    
    ME_timeseries_plot_v2 = function(){plot_default_timeseries(timeseries_data_v2(),"general",input$ME_variable_v2,plot_titles_v2(),"Default",NA)}
    
    
    ### Plot v1/v2 plots
    
    # Generate plot dimensions
    plot_dimensions_v1 <- reactive({
      if (input$type_v1 == "Time series"){
        map_dims_v1 = c(session$clientData$output_plot_v1_width,400)
      } else {
        map_dims_v1 = generate_map_dimensions(subset_lons_v1(), subset_lats_v1(), session$clientData$output_plot_v1_width, (input$dimension[2]), FALSE)
      }
      return(map_dims_v1)  
    })
    
    plot_dimensions_v2 <- reactive({
      if (input$type_v2 == "Time series"){
        map_dims_v2 = c(session$clientData$output_plot_v2_width,400)
      } else {
        map_dims_v2 = generate_map_dimensions(subset_lons_v2(), subset_lats_v2(), session$clientData$output_plot_v2_width, (input$dimension[2]), FALSE)
      }
      return(map_dims_v2)  
    })     
    
    # Plot 
    output$plot_v1 <- renderPlot({
      if (input$source_v1 == "User Data"){
        plot_user_timeseries(user_subset_v1(),"darkorange2")
      } else if (input$type_v1 == "Time series"){
        ME_timeseries_plot_v1()
      } else{
        ME_map_plot_v1()
      }
    },width = function(){plot_dimensions_v1()[1]},height = function(){plot_dimensions_v1()[2]})  
    
    
    output$plot_v2 <- renderPlot({
      if (input$source_v2 == "User Data"){
        plot_user_timeseries(user_subset_v2(),"saddlebrown")
      } else if (input$type_v2 == "Time series"){
        ME_timeseries_plot_v2()
      } else{
        ME_map_plot_v2()
      }
    },width = function(){plot_dimensions_v2()[1]},height = function(){plot_dimensions_v2()[2]})  
    
    ### Correlation plots and data ----
    ### Plot shared TS plot
    
    # Generate correlation titles
    plot_titles_cor = reactive({
      
      if (input$source_v1 == "ModE-"){
        variable_v1 = input$ME_variable_v1
      } else {
        variable_v1 = input$user_variable_v1
      }
      
      if (input$source_v2 == "ModE-"){
        variable_v2 = input$ME_variable_v2
      } else {
        variable_v2 = input$user_variable_v2
      }
      
      ptc = generate_correlation_titles(input$source_v1,input$source_v2,input$dataset_selected_v1,
                                        input$dataset_selected_v2,variable_v1,variable_v2,
                                        input$type_v1,input$type_v2,input$mode_selected_v1,input$mode_selected_v2,
                                        month_range_v1(),month_range_v2(),lonlat_vals_v1()[1:2],lonlat_vals_v2()[1:2],
                                        lonlat_vals_v1()[3:4],lonlat_vals_v2()[3:4],input$range_years3,input$cor_method_ts,
                                        input$title_mode3,input$title_mode_ts3,input$title1_input3,input$title1_input_ts3)
      return(ptc)
    }) 
    
    # Select variable timeseries data
    ts_data_v1 = reactive({
      if (input$source_v1 == "ModE-"){
        tsd_v1 = timeseries_data_v1()
      } else {
        tsd_v1 = user_subset_v1()
      }
      
      # Add moving averages (if chosen)
      MA_alignment = switch(input$year_position_ts3,
                            "before" = "left",
                            "on" = "center",
                            "after" = "right")
      
      tsds_v1 = add_stats_to_TS_datatable(tsd_v1,input$custom_average_ts3,input$year_moving_ts3,
                                          MA_alignment,FALSE,NA,FALSE)
      
      return(tsds_v1)
    })
    
    ts_data_v2 = reactive({
      if (input$source_v2 == "ModE-"){
        tsd_v2 = timeseries_data_v2()
      } else {
        tsd_v2 = user_subset_v2()
      } 
      
      # Add moving averages (if chosen)
      MA_alignment = switch(input$year_position_ts3,
                            "before" = "left",
                            "on" = "center",
                            "after" = "right")
      
      tsds_v2 = add_stats_to_TS_datatable(tsd_v2,input$custom_average_ts3,input$year_moving_ts3,
                                          MA_alignment,FALSE,NA,FALSE)
      
      return(tsds_v2)
    })
    
    # Correlate timeseries
    correlation_stats = reactive({
      c_st = correlate_timeseries(ts_data_v1(),ts_data_v2(),input$cor_method_ts)
      
      return(c_st)
    })
    
    # Plot
    output$correlation_r_value = renderText({paste("Timeseries correlation:   r =",signif(correlation_stats()$estimate,digits =3)," p =",signif(correlation_stats()$p.value,digits =3), sep = "")})
    
    corr_ts1 = function(){
      
      if (input$source_v1 == "ModE-"){
        variable_v1 = input$ME_variable_v1
      } else {
        variable_v1 = input$user_variable_v1
      }
      
      if (input$source_v2 == "ModE-"){
        variable_v2 = input$ME_variable_v2
      } else {
        variable_v2 = input$user_variable_v2
      }
      
      plot_combined_timeseries(ts_data_v1(),ts_data_v2(),plot_titles_cor())
      add_highlighted_areas(ts_highlights_data3())
      add_custom_lines(ts_lines_data3())
      add_correlation_timeseries(ts_data_v1(),ts_data_v2(),variable_v1,variable_v2,plot_titles_cor())
      add_boxes(ts_highlights_data3())
      add_custom_points(ts_points_data3())
      if (input$show_key_ts3 == TRUE){
        add_TS_key(input$key_position_ts3,ts_highlights_data3(),ts_lines_data3(),variable_v1,month_range_v1(),
                   input$custom_average_ts3,input$year_moving_ts3,FALSE,NA,variable_v2,month_range_v2(),TRUE)
      }
      
    }
    
    output$correlation_ts = renderPlot({corr_ts1()}, height = 400)
    
    ### Plot correlation map
    
      # Pick out relevant v1/v2 data:
      correlation_map_data_v1 = reactive({
        if (input$type_v1 == "Field"){
          cmd_v1 = data_output3_v1()
        } else if (input$source_v1 == "User Data"){
          cmd_v1 = user_subset_v1()
        } else {
          cmd_v1 = timeseries_data_v1()
        } 
      })
      
      correlation_map_data_v2 = reactive({
        if (input$type_v2 == "Field"){
          cmd_v2 = data_output3_v2()
        } else if (input$source_v2 == "User Data"){
          cmd_v2 = user_subset_v2()
        } else {
          cmd_v2 = timeseries_data_v2()
        } 
      })
      
      # Generate correlation map data
      correlation_map_data = reactive({
        corrmd = generate_correlation_map_data(correlation_map_data_v1(),correlation_map_data_v2(),input$cor_method_map,
                                      input$type_v1,input$type_v2,lonlat_vals_v1()[1:2],lonlat_vals_v2()[1:2],
                                      lonlat_vals_v1()[3:4],lonlat_vals_v2()[3:4])
        return(corrmd)
      })
      
      # Generate plot dimensions
      correlation_map_dimensions <- reactive({
        c_m_d = generate_map_dimensions(correlation_map_data()[[1]], correlation_map_data()[[2]], session$clientData$output_correlation_map_width, input$dimension[2], FALSE)
        
        return(c_m_d)
      })
      
      # Plot
      
      corr_m1 = function(){
        if ((input$type_v1 == "Field") | (input$type_v2 == "Field")){
          plot_correlation_map(correlation_map_data(),plot_titles_cor(),input$axis_input3,
                               input$hide_axis3,map_points_data3(),map_highlights_data3(),data.frame())
        }
      }

      output$correlation_map = renderPlot({corr_m1()},width = function(){correlation_map_dimensions()[1]},height = function(){correlation_map_dimensions()[2]})
      
    ### Data tables & Downloads 
    
      # Create output ts_data
      correlation_ts_datatable = reactive({
        
        if (input$source_v1 == "ModE-"){
          variable_v1 = input$ME_variable_v1
        } else {
          variable_v1 = input$user_variable_v1
        }
        
        if (input$source_v2 == "ModE-"){
          variable_v2 = input$ME_variable_v2
        } else {
          variable_v2 = input$user_variable_v2
        }
        
        # Create v1/v2 datatables
        ctd_v1 = rewrite_tstable(ts_data_v1(),variable_v1)
        ctd_v2 = rewrite_tstable(ts_data_v2(),variable_v2)
        
        # Combine into dataframe
        ctd = data.frame(ctd_v1,ctd_v2[-1])
        
        # Add Var1/2 to names
        colnames(ctd) = c("Year",paste("Var1_",colnames(ctd_v1)[-1], sep = ""),paste("Var2_",colnames(ctd_v2)[-1], sep = ""))
        
        return(ctd)
      })
      
      output$correlation_ts_data = renderDataTable({correlation_ts_datatable()}, rownames = FALSE, options = list(
        autoWidth = TRUE, 
        searching = FALSE,
        paging = TRUE,
        pagingType = "numbers"
      ))
      
      # Create output map data
      correlation_map_datatable = reactive({
        
        corrmada = generate_correlation_map_datatable(correlation_map_data())
        
        return(corrmada)
      })
      
      output$correlation_map_data <- renderTable({correlation_map_datatable()}, rownames = TRUE)
      
    ### ModE-RA sources ----
      #ModE-RA sources Variable 1
      
      ranges_3a  <- reactiveValues(x = NULL, y = NULL)
      ranges2_3a <- reactiveValues(x = NULL, y = NULL)
      
      fad_wa3a <- function(labs) {
        labs = labs
        plot_modera_sources(input$fad_year_a3a, "winter", lonlat_vals_v1()[1:2], lonlat_vals_v1()[3:4], labs)}
      fad_sa3a <- function(labs) {
        labs = labs
        plot_modera_sources(input$fad_year_a3a, "summer", lonlat_vals_v1()[1:2], lonlat_vals_v1()[3:4], labs)}

      # Upper map (Original)
      output$fad_winter_map_a3a <- renderPlot({
        if ((month_range_v1()[1] >= 4) && (month_range_v1()[2] <= 9)) {
          plot_data <- fad_sa3a(labs = TRUE)
        } else {
          plot_data <- fad_wa3a(labs = TRUE)
        }
        
        # Render the "Original Map" with no fixed aspect ratio
        plot_data
      })
      
      # Upper map (Zoom)
      output$fad_zoom_winter_a3a <- renderPlot({
        if ((month_range_v1()[1] >= 4) && (month_range_v1()[2] <= 9)) {
          plot_data <- fad_sa3a(labs = FALSE)
        } else {
          plot_data <- fad_wa3a(labs = FALSE)
        }
        
        # Apply coord_sf to the entire map with adjusted limits
        plot_data <- plot_data + coord_sf(xlim = ranges_3a$x, ylim = ranges_3a$y, crs = st_crs(4326))
        
        plot_data
      })
      
      # Lower map (Original)
      output$fad_summer_map_a3a <- renderPlot({
        if ((month_range_v1()[1] >= 4 && month_range_v1()[2] <= 9) | (month_range_v1()[2] <= 3)) {
          NULL
        } else {
          plot_data <- fad_sa3a(labs = TRUE)  
        } 
        
        # Render the "Original Map" with no fixed aspect ratio
        plot_data
      })
      
      # Lower map (Zoom)
      output$fad_zoom_summer_a3a <- renderPlot({
        if ((month_range_v1()[1] >= 4 && month_range_v1()[2] <= 9) || (month_range_v1()[2] <= 3)) {
          NULL
        } else {
          plot_data <- fad_sa3a(labs = FALSE)
        }
        
        # Apply coord_sf to the entire map with adjusted limits
        plot_data <- plot_data + coord_sf(xlim = ranges2_3a$x, ylim = ranges2_3a$y, crs = st_crs(4326))
        
        plot_data
      })

      #ModE-RA sources Variable 2
      
      ranges_3b  <- reactiveValues(x = NULL, y = NULL)
      ranges2_3b <- reactiveValues(x = NULL, y = NULL)
      
      fad_wa3b <- function(labs) {
        labs = labs
        plot_modera_sources(input$fad_year_a3b, "winter", lonlat_vals_v2()[1:2], lonlat_vals_v2()[3:4], labs)}
      fad_sa3b <- function(labs) {
        labs = labs
        plot_modera_sources(input$fad_year_a3b, "summer", lonlat_vals_v2()[1:2], lonlat_vals_v2()[3:4], labs)}

      # Upper map (Original)
      output$fad_winter_map_a3b <- renderPlot({
        if ((month_range_v2()[1] >= 4) && (month_range_v2()[2] <= 9)) {
          plot_data <- fad_sa3b(labs = TRUE)
        } else {
          plot_data <- fad_wa3b(labs = TRUE)
        }
        
        # Render the "Original Map" with no fixed aspect ratio
        plot_data
      })
      
      # Upper map (Zoom)
      output$fad_zoom_winter_a3b <- renderPlot({
        if ((month_range_v2()[1] >= 4) && (month_range_v2()[2] <= 9)) {
          plot_data <- fad_sa3b(labs = FALSE)
        } else {
          plot_data <- fad_wa3b(labs = FALSE)
        }
        
        # Apply coord_sf to the entire map with adjusted limits
        plot_data <- plot_data + coord_sf(xlim = ranges_3b$x, ylim = ranges_3b$y, crs = st_crs(4326))
        
        plot_data
      })
      
      # Lower map (Original)
      output$fad_summer_map_a3b <- renderPlot({
        if ((month_range_v2()[1] >= 4 && month_range_v2()[2] <= 9) | (month_range_v2()[2] <= 3)) {
          NULL
        } else {
          plot_data <- fad_sa3b(labs = TRUE)  
        } 
        
        # Render the "Original Map" with no fixed aspect ratio
        plot_data
      })
      
      # Lower map (Zoom)
      output$fad_zoom_summer_a3b <- renderPlot({
        if ((month_range_v2()[1] >= 4 && month_range_v2()[2] <= 9) || (month_range_v2()[2] <= 3)) {
          NULL
        } else {
          plot_data <- fad_sa3b(labs = FALSE)
        }

        # Apply coord_sf to the entire map with adjusted limits
        plot_data <- plot_data + coord_sf(xlim = ranges2_3b$x, ylim = ranges2_3b$y, crs = st_crs(4326))
        
        plot_data
      })
                  
      #Update Modera source year input and update brushes
      
      observeEvent(input$range_years3[1], {
        updateNumericInput(
          session = getDefaultReactiveDomain(),
          inputId = "fad_year_a3a",
          value = input$range_years3[1])
      })
      
      observeEvent(input$range_years3[1], {
        updateNumericInput(
          session = getDefaultReactiveDomain(),
          inputId = "fad_year_a3b",
          value = input$range_years3[1])
      })
      
      observe({
        brush_v1a <- input$brush_fad1a3a
        if (!is.null(brush_v1a)) {
          ranges_3a$x <- c(brush_v1a$xmin, brush_v1a$xmax)
          ranges_3a$y <- c(brush_v1a$ymin, brush_v1a$ymax)
          
        } else {
          ranges_3a$x <- lonlat_vals_v1()[1:2]
          ranges_3a$y <- lonlat_vals_v1()[3:4]
        }
      })
      
      observe({
        brush_v1a2 <- input$brush_fad1b3a
        if (!is.null(brush_v1a2)) {
          ranges2_3a$x <- c(brush_v1a2$xmin, brush_v1a2$xmax)
          ranges2_3a$y <- c(brush_v1a2$ymin, brush_v1a2$ymax)
          
        } else {
          ranges2_3a$x <- lonlat_vals_v1()[1:2]
          ranges2_3a$y <- lonlat_vals_v1()[3:4]
        }
      })
      
      observe({
        brush_v2a <- input$brush_fad1a3b
        if (!is.null(brush_v2a)) {
          ranges_3b$x <- c(brush_v2a$xmin, brush_v2a$xmax)
          ranges_3b$y <- c(brush_v2a$ymin, brush_v2a$ymax)
          
        } else {
          ranges_3b$x <- lonlat_vals_v2()[1:2]
          ranges_3b$y <- lonlat_vals_v2()[3:4]
        }
      })
      
      observe({
        brush_v2a2 <- input$brush_fad1b3b
        if (!is.null(brush_v2a2)) {
          ranges2_3b$x <- c(brush_v2a2$xmin, brush_v2a2$xmax)
          ranges2_3b$y <- c(brush_v2a2$ymin, brush_v2a2$ymax)
          
        } else {
          ranges2_3b$x <- lonlat_vals_v2()[1:2]
          ranges2_3b$y <- lonlat_vals_v2()[3:4]
        }
      })

    ### Downloads ----
      # Downloads
      
      output$download_timeseries3      <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title,"-ts.",input$file_type_timeseries3, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_timeseries3 == "png"){
                                                              png(file, width = 3000, height = 1285, res = 200) 
                                                              corr_ts1()  
                                                              dev.off()
                                                            } else if (input$file_type_timeseries3 == "jpeg"){
                                                              jpeg(file, width = 3000, height = 1285, res = 200) 
                                                              corr_ts1()
                                                              dev.off()
                                                            } else {
                                                              pdf(file, width = 14, height = 6) 
                                                              corr_ts1()
                                                              dev.off()
                                                            }}) 
      
      output$download_map3             <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title,"-map.",input$file_type_map3, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_map3 == "png"){
                                                              png(file, width = correlation_map_dimensions()[3] , height = correlation_map_dimensions()[4], res = 200)  
                                                              corr_m1()
                                                              dev.off()
                                                            } else if (input$file_type_map3 == "jpeg"){
                                                              jpeg(file, width = correlation_map_dimensions()[3] , height = correlation_map_dimensions()[4], res = 200) 
                                                              corr_m1() 
                                                              dev.off()
                                                            } else {
                                                              pdf(file, width = correlation_mapdimensions()[3]/200 , height = correlation_map_dimensions()[4]/200) 
                                                              corr_m1()
                                                              dev.off()
                                                            }})
      
      output$download_timeseries_data3  <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title, "-tsdata.",input$file_type_timeseries_data3, sep = "")},
                                                           content  = function(file) {
                                                             if (input$file_type_timeseries_data3 == "csv"){
                                                               write.csv(correlation_ts_datatable(), file,
                                                                         row.names = FALSE,
                                                                         col.names = TRUE)
                                                             } else {
                                                               write.xlsx(correlation_ts_datatable(), file,
                                                                          row.names = FALSE,
                                                                          col.names = TRUE)
                                                             }}) 
      
      output$download_map_data3        <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title, "-mapdata.",input$file_type_map_data3, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_map_data3 == "csv"){
                                                              write.csv(rewrite_maptable(correlation_map_datatable(),NA,NA), file,
                                                                        row.names = FALSE,
                                                                        col.names = FALSE)
                                                            } else {
                                                              write.xlsx(rewrite_maptable(correlation_map_datatable(),NA,NA), file,
                                                                         row.names = FALSE,
                                                                         col.names = FALSE)
                                                            }})
      
      ## ModE-RA sources Variable 1
      
      output$download_fad_sa3a             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a3a, "-modera_source.",input$file_type_modera_source_b3a, sep = "")},
                                                              content  = function(file) {
                                                                
                                                                mmd3a = generate_map_dimensions(subset_lons_v1(), subset_lats_v1(), session$clientData$output_fad_winter_map_a3a_width, input$dimension[2], FALSE)
                                                                
                                                                if (input$file_type_modera_source_b3a == "png"){
                                                                  png(file, width = mmd3a[3] , height = mmd3a[4], res = 400)  
                                                                  print(fad_sa3a(labs = TRUE))
                                                                  dev.off()
                                                                } else if (input$file_type_modera_source_b3a == "jpeg"){
                                                                  jpeg(file, width = mmd3a[3] , height = mmd3a[4], res = 400) 
                                                                  print(fad_sa3a(labs = TRUE)) 
                                                                  dev.off()
                                                                } else {
                                                                  pdf(file, width = mmd3a[3]/400 , height = mmd3a[4]/400) 
                                                                  print(fad_sa3a(labs = TRUE))
                                                                  dev.off()
                                                                }})
      
      output$download_fad_wa3a             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a3a, "-modera_source.",input$file_type_modera_source_a3a, sep = "")},
                                                              content  = function(file) {
                                                                
                                                                mmd3a = generate_map_dimensions(subset_lons_v1(), subset_lats_v1(), session$clientData$output_fad_winter_map_a3a_width, input$dimension[2], FALSE)
                                                                
                                                                if (input$file_type_modera_source_a3a == "png"){
                                                                  png(file, width = mmd3a[3] , height = mmd3a[4], res = 400)  
                                                                  print(fad_wa3a(labs = TRUE))
                                                                  dev.off()
                                                                } else if (input$file_type_modera_source_a3a == "jpeg"){
                                                                  jpeg(file, width = mmd3a[3] , height = mmd3a[4], res = 400) 
                                                                  print(fad_wa3a(labs = TRUE)) 
                                                                  dev.off()
                                                                } else {
                                                                  pdf(file, width = mmd3a[3]/400 , height = mmd3a[4]/400) 
                                                                  print(fad_wa3a(labs = TRUE))
                                                                  dev.off()
                                                                }})
      
      ## ModE-RA sources Variable 2
      
      output$download_fad_sa3b             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a3b, "-modera_source.",input$file_type_modera_source_b3b, sep = "")},
                                                              content  = function(file) {
                                                                
                                                                mmd3b = generate_map_dimensions(subset_lons_v2(), subset_lats_v2(), session$clientData$output_fad_winter_map_a3b_width, input$dimension[2], FALSE)
                                                                
                                                                if (input$file_type_modera_source_b3b == "png"){
                                                                  png(file, width = mmd3b[3] , height = mmd3b[4], res = 400)  
                                                                  print(fad_sa3b(labs = TRUE))
                                                                  dev.off()
                                                                } else if (input$file_type_modera_source_b3b == "jpeg"){
                                                                  jpeg(file, width = mmd3b[3] , height = mmd3b[4], res = 400) 
                                                                  print(fad_sa3b(labs = TRUE)) 
                                                                  dev.off()
                                                                } else {
                                                                  pdf(file, width = mmd3b[3]/400 , height = mmd3b[4]/400) 
                                                                  print(fad_sa3b(labs = TRUE))
                                                                  dev.off()
                                                                }})
      
      output$download_fad_wa3b             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a3b, "-modera_source.",input$file_type_modera_source_a3b, sep = "")},
                                                              content  = function(file) {
                                                                
                                                                mmd3b = generate_map_dimensions(subset_lons_v2(), subset_lats_v2(), session$clientData$output_fad_winter_map_a3b_width, input$dimension[2], FALSE)
                                                                
                                                                if (input$file_type_modera_source_a3b == "png"){
                                                                  png(file, width = mmd3b[3] , height = mmd3b[4], res = 400)  
                                                                  print(fad_wa3b(labs = TRUE))
                                                                  dev.off()
                                                                } else if (input$file_type_modera_source_a3b == "jpeg"){
                                                                  jpeg(file, width = mmd3b[3] , height = mmd3b[4], res = 400) 
                                                                  print(fad_wa3b(labs = TRUE)) 
                                                                  dev.off()
                                                                } else {
                                                                  pdf(file, width = mmd3b[3]/400 , height = mmd3b[4]/400) 
                                                                  print(fad_wa3b(labs = TRUE))
                                                                  dev.off()
                                                                }})

 
  ## REGRESSION data processing and plotting ----
    ### Independent and dependent variable ----  
      ### User data processing
      
      # Load in user data for independent variable
      user_data_iv = reactive({
        
        req(input$user_file_iv)
        
        if (input$source_iv == "User Data"){
          new_data1 = read_regcomp_data(input$user_file_iv$datapath)      
          return(new_data1)
        }
        else{
          return(NULL)
        }
      })
      
      # Load in user data for dependent variable
      user_data_dv = reactive({
        
        req(input$user_file_dv)
        
        if (input$source_dv == "User Data"){
          new_data2 = read_regcomp_data(input$user_file_dv$datapath)      
          return(new_data2)
        }
        else{
          return(NULL)
        }
      })
      
      # Subset iv data to year_range and chosen variable
      user_subset_iv = reactive({
        
        req(user_data_iv(),input$user_variable_iv)
        
        usr_ss1 = create_user_data_subset(user_data_iv(),input$user_variable_iv,input$range_years4)
        
        return(usr_ss1)
      }) 
      
      # Subset dv data to year_range and chosen variable
      user_subset_dv = reactive({
        
        req(user_data_dv(),input$user_variable_dv)
        
        usr_ss2 = create_user_data_subset(user_data_dv(),input$user_variable_dv,input$range_years4)
        
        return(usr_ss2)
      }) 
      
      
      year_range_reg = reactive({
        
        result <- tryCatch(
          {
            return(extract_year_range(input$source_iv,input$source_dv,input$user_file_iv$datapath,input$user_file_dv$datapath))
          },
          error = function(e) {
            showModal(
              # Add modal dialog for warning message
              modalDialog(
                title = "Error",
                "There was an error in processing your uploaded data. 
                  \nPlease check if the file has the correct format.",
                easyClose = FALSE,
                footer = tagList(modalButton("OK"))
              ))
            return(NULL)
          }
        )
        return(result)
      }) 
      
      
      ### Generate ModE-RA data   
      
      ## for independent variable:
      
      # Calculate Month range
      month_range_iv <- reactive({
        mr_iv = create_month_range(input$range_months_iv) #Between 0-12  
        return(mr_iv)
      })
      
      # Subset lon/lats
      subset_lons_iv <- eventReactive(lonlat_vals_iv(), {
        slons_iv = create_subset_lon_IDs(lonlat_vals_iv()[1:2]) 
        return(slons_iv)
      })
      
      subset_lats_iv <- eventReactive(lonlat_vals_iv(), {
        slats_iv = create_subset_lat_IDs(lonlat_vals_iv()[3:4]) 
        return(slats_iv)
      })


      
      ## for dependent variable:
      
      # Calculate Month range
      month_range_dv <- reactive({
        mr_dv = create_month_range(input$range_months_dv) #Between 0-12  
        return(mr_dv)
      })
      
      # Subset lon/lats
      subset_lons_dv <- eventReactive(lonlat_vals_dv(), {
        slons_dv = create_subset_lon_IDs(lonlat_vals_dv()[1:2]) 
        return(slons_dv)
      })
      
      subset_lats_dv <- eventReactive(lonlat_vals_dv(), {
        slats_dv = create_subset_lat_IDs(lonlat_vals_dv()[3:4]) 
        return(slats_dv)
      })
      
      # Generate pp ID
      pp_id_dv <- reactive({
        ppid_dv = generate_pp_data_ID(input$dataset_selected_dv,input$ME_variable_dv, month_range_dv())
        return(ppid_dv)
      })
      
      #Geographic Subset
      data_output1_dv <- reactive({ 
        data_input_dv <-   load_ModE_data(input$dataset_selected_dv,input$ME_variable_dv)
        processed_data_dv  <- create_latlon_subset(data_input_dv, pp_id_dv(), subset_lons_dv(), subset_lats_dv())                
        return(processed_data_dv)
      })
      
      #Creating yearly subset
      data_output2_dv <- reactive({ 
        processed_data2_dv <- create_yearly_subset(data_output1_dv(), pp_id_dv(), input$range_years4, month_range_dv())              
        return(processed_data2_dv)  
      })
      
      #Converting absolutes to anomalies
      data_output3_dv <- reactive({
        if (input$mode_selected_dv == "Absolute"){
          processed_data3_dv <- data_output2_dv()
        } else {
          processed_data3_dv <- convert_subset_to_anomalies(data_output2_dv(), data_output1_dv(), pp_id_dv(), month_range_dv(), input$ref_period_dv)
        }
        return(processed_data3_dv)
      })
      
      
      ## ModE-RA map plots and titles:
      
      #Map titles
      plot_titles_dv <- reactive({
        my_title_dv <- generate_titles ("general",input$dataset_selected_dv, input$ME_variable_dv, input$mode_selected_dv,
                                        "Default","Default", month_range_dv(),input$range_years4,
                                        input$ref_period_dv, NA,lonlat_vals_dv()[1:2],lonlat_vals_dv()[3:4],
                                        NA, NA, NA)
        return(my_title_dv)
      }) 
      
      plot_titles_iv <- reactive({
        my_title_iv <- generate_titles ("general",input$dataset_selected_iv, input$ME_variable_iv[1], input$mode_selected_iv,
                                        "Default","Default", month_range_iv(),input$range_years4,
                                        input$ref_period_iv, NA,lonlat_vals_iv()[1:2],lonlat_vals_iv()[3:4],
                                        NA, NA, NA)
        return(my_title_iv)
      }) 
      
      # Generate Map data & plotting function for dv
      map_data_dv <- function(){create_map_datatable(data_output3_dv(), subset_lons_dv(), subset_lats_dv())}
      
      ME_map_plot_dv <- function(){plot_default_map(map_data_dv(), input$ME_variable_dv, input$mode_selected_dv, plot_titles_dv(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame())}
      
      # Generate timeseries data & plotting function for iv
      ME_ts_data_iv <- reactive({
        me_tsd_iv = create_ME_timeseries_data(input$dataset_selected_dv,input$ME_variable_iv,subset_lons_iv(),subset_lats_iv(),
                                  input$mode_selected_iv,month_range_iv(),input$range_years4,
                                  input$ref_period_iv)
        return(me_tsd_iv)
      })
      
      
      ME_timeseries_plot_iv = function(){plot_default_timeseries(ME_ts_data_iv(),"general",input$ME_variable_iv[1],plot_titles_iv(),"Default",NA)}
      
      # Generate time series data for dv
      timeseries_data_dv <- reactive({
        ts_data1_dv <- create_timeseries_datatable(data_output3_dv(), input$range_years4, "range", subset_lons_dv(), subset_lats_dv())
        return(ts_data1_dv)
      })
      
      #ME_timeseries_plot_dv = function(){plot_default_timeseries(timeseries_data_dv(),"general",input$ME_variable_dv,plot_titles_dv(),"Default")}
      
      
      ### Plot iv/dv plots
      
      # Generate plot dimensions
      plot_dimensions_iv <- reactive({
          p_d_iv = map_dims_iv = c(session$clientData$output_plot_iv_width,400)
          
          return(p_d_iv)
      })
      
      plot_dimensions_dv <- reactive({
        if (input$source_dv == "User Data"){
          map_dims_dv = c(session$clientData$output_plot_dv_width,400)
        } else {
          map_dims_dv = generate_map_dimensions(subset_lons_dv(), subset_lats_dv(), session$clientData$output_plot_dv_width, (input$dimension[2]), FALSE)
        }
        return(map_dims_dv)  
      })
      
      # Plot 
      output$plot_iv <- renderPlot({
        if (input$source_iv == "User Data"){
          plot_user_timeseries(user_subset_iv(),"darkorange2")
        } else {
          ME_timeseries_plot_iv()
        } 
      },height = 400)  
      
      output$plot_dv <- renderPlot({
        if (input$source_dv == "User Data"){
          plot_user_timeseries(user_subset_dv(),"saddlebrown")
        } else{
          ME_map_plot_dv()
        }
      },width = function(){plot_dimensions_dv()[1]},height = function(){plot_dimensions_dv()[2]})  
      
    ### Regression plots and data ----
    
    ## Preparation
    
    # Set independent variables:
    variables_iv = reactive({
      if (input$source_iv == "ModE-"){
        v_iv = input$ME_variable_iv
      } else {
        v_iv = input$user_variable_iv
      }
      return(v_iv)
    })
      
    variable_dv = reactive({
      if (input$source_dv == "ModE-"){
        v_dv = input$ME_variable_dv
      } else {
        v_dv = input$user_variable_dv
        }
      return(v_dv)
    })
      
    # Generate regression titles    
    plot_titles_reg = reactive({
      
      ptr = generate_regression_titles(input$source_iv,input$source_dv,
                                       input$dataset_selected_iv,input$dataset_selected_dv,
                                       input$ME_variable_dv,
                                       input$mode_selected_iv, input$mode_selected_dv,
                                  month_range_iv(),month_range_dv(),lonlat_vals_iv()[1:2],
                                  lonlat_vals_dv()[1:2],lonlat_vals_iv()[3:4],
                                  lonlat_vals_dv()[3:4],input$range_years4)
      return(ptr)
    })
    
    # Select variable timeseries data
      ts_data_iv = reactive({
        if (input$source_iv == "ModE-"){
          tsd_iv = ME_ts_data_iv()
        } else {
          tsd_iv = user_subset_iv()
        }  
        return(tsd_iv)
      })
      
      ts_data_dv = reactive({
        if (input$source_dv == "ModE-"){
          tsd_dv = timeseries_data_dv()
        } else {
          tsd_dv = user_subset_dv()
        }  
        return(tsd_dv)
      })
    
    # Generate plot dimension
    plot_dimensions_reg = reactive({
      
      p_d_r = generate_map_dimensions(subset_lons_dv(), subset_lats_dv(), session$clientData$output_plot_dv_width, input$dimension[2], FALSE)
      
      return(p_d_r)
    })
      
    ## Regression Summary data 
    
    regression_summary_data = reactive({
      
      rsd = create_regression_summary_data(ts_data_iv(),ts_data_dv(),variables_iv())
      
      return(rsd)
    })
    
    reg_sd = function(){
      req(regression_summary_data())
      summary(regression_summary_data())}
      
    output$regression_summary_data = renderPrint({reg_sd()})  
    
    ## Regression coefficient plot
    
    regression_coeff_data = reactive({
      
      reg_cd = create_regression_coeff_data(ts_data_iv(), data_output3_dv(), variables_iv())
      
      return(reg_cd)
    })
    
    reg_coef_1 = function(){
      req(input$coeff_variable)
      plot_regression_coefficients(regression_coeff_data(),variables_iv(),match(input$coeff_variable,variables_iv()),
                                   variable_dv(),plot_titles_reg(),subset_lons_dv(),subset_lats_dv())
    }
    
    output$plot_reg_coeff = renderPlot({reg_coef_1()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
    
    reg_coef_2 = function(){
      
      req(input$coeff_variable)
      
      if (length(variables_iv()) == 1){ #  Deals with the 'variable' dimension disappearing
        rcd1 = regression_coeff_data()
      } else{
        rcd1 = regression_coeff_data()[match(input$coeff_variable,variables_iv()),,]
      }
      
      # Transform and add rownames to data
      rcd2 = create_regression_map_datatable(rcd1,subset_lons_dv(),subset_lats_dv())
      
      return (rcd2)
    }
    
    output$data_reg_coeff = renderTable({reg_coef_2()}, rownames = TRUE)
    
    ## Regression pvalue plot
    
    regression_pvalue_data = reactive({
      rpvd = create_regression_pvalue_data(ts_data_iv(), data_output3_dv(), variables_iv())
      
      return(rpvd)
    })
    
    reg_pval_1 = function(){
      req(input$pvalue_variable)
      plot_regression_pvalues(regression_pvalue_data(),variables_iv(),match(input$pvalue_variable,variables_iv()),
                              variable_dv(),plot_titles_reg(),subset_lons_dv(),subset_lats_dv())
    }
    
    output$plot_reg_pval = renderPlot({reg_pval_1()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
    
    reg_pval_2 = function(){
      req(input$pvalue_variable)
      
      if (length(variables_iv()) == 1){ #  Deals with the 'variable' dimension disappearing
        rpd1 = regression_pvalue_data()
      } else{
        rpd1 = regression_pvalue_data()[match(input$pvalue_variable,variables_iv()),,]
      }
      
      # Transform and add rownames to data
      rpd2 = create_regression_map_datatable(rpd1,subset_lons_dv(),subset_lats_dv())
      
      return(rpd2)
    }
    
    output$data_reg_pval = renderTable({reg_pval_2()},rownames = TRUE)
    
    ## Regression residuals plot
    
    regression_residuals_data = reactive({
      rresd = create_regression_residuals(ts_data_iv(), data_output3_dv(), variables_iv())
      
      return(rresd)
    })
    
    # Make sure plot only updates when year is valid
    reg_resi_year_val  = reactiveVal()
    observe({
      if(input$reg_resi_year >= input$range_years4[1] & input$reg_resi_year <= input$range_years4[2]){
        reg_resi_year_val(input$reg_resi_year)
      }
    })
    
    reg_res_1 = function(){
      plot_regression_residuals(regression_residuals_data(),reg_resi_year_val(),input$range_years4,
                                variables_iv(),variable_dv(),plot_titles_reg(),
                                subset_lons_dv(),subset_lats_dv())
      
    }
    
    output$plot_reg_resi = renderPlot({reg_res_1()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
    
    reg_res_2 = function(){
      
      # Find ID of year selected
      year_ID = (reg_resi_year_val()-input$range_years4[1])+1
      rrd1 = regression_residuals_data()[year_ID,,]
      
      # Transform and add rownames to data
      rrd2 = create_regression_map_datatable(rrd1,subset_lons_dv(),subset_lats_dv())
    }
    
    output$data_reg_resi = renderTable({reg_res_2()},rownames = TRUE)
    
      
    ## Regression timeseries plot
    
    regression_ts_data = reactive({
      rtsd = create_regression_timeseries_datatable(ts_data_dv(),regression_summary_data(),
                                             plot_titles_reg())
      return(rtsd)
    })
    
    reg_ts1a = function(){
      plot_regression_timeseries(regression_ts_data(),"original_trend",plot_titles_reg(),
                                 variables_iv(),variable_dv())
    }
    
    output$plot_reg_ts1 = renderPlot({reg_ts1a()},height=400)
    
    reg_ts1b = function(){
      plot_regression_timeseries(regression_ts_data(),"residuals",plot_titles_reg(),
                                 variables_iv(),variable_dv())
    }
    
    output$plot_reg_ts2 = renderPlot({reg_ts1b()},height=400)
    
    output$data_reg_ts= renderDataTable({regression_ts_data()}, rownames = FALSE, options = list(
      autoWidth = TRUE, 
      searching = FALSE,
      paging = TRUE,
      pagingType = "numbers"
    ))
      
    ### ModE-RA sources ----
    #ModE-RA sources independent variable

    ranges_4a  <- reactiveValues(x = NULL, y = NULL)
    ranges2_4a <- reactiveValues(x = NULL, y = NULL)
    
    fad_wa4a <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a4a, "winter", lonlat_vals_iv()[1:2], lonlat_vals_iv()[3:4], labs)}
    fad_sa4a <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a4a, "summer", lonlat_vals_iv()[1:2], lonlat_vals_iv()[3:4], labs)}
    
    # Upper map (Original)
    output$fad_winter_map_a4a <- renderPlot({
      if ((month_range_iv()[1] >= 4) && (month_range_iv()[2] <= 9)) {
        plot_data <- fad_sa4a(labs = TRUE)
      } else {
        plot_data <- fad_wa4a(labs = TRUE)
      }
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Upper map (Zoom)
    output$fad_zoom_winter_a4a <- renderPlot({
      if ((month_range_iv()[1] >= 4) && (month_range_iv()[2] <= 9)) {
        plot_data <- fad_sa4a(labs = FALSE)
      } else {
        plot_data <- fad_wa4a(labs = FALSE)
      }

      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges_4a$x, ylim = ranges_4a$y, crs = st_crs(4326))
      
      plot_data
    })
    
    # Lower map (Original)
    output$fad_summer_map_a4a <- renderPlot({
      if ((month_range_iv()[1] >= 4 && month_range_iv()[2] <= 9) | (month_range_iv()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa4a(labs = TRUE)  
      } 
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Lower map (Zoom)
    output$fad_zoom_summer_a4a <- renderPlot({
      if ((month_range_iv()[1] >= 4 && month_range_iv()[2] <= 9) || (month_range_iv()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa4a(labs = FALSE)
      }

      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges2_4a$x, ylim = ranges2_4a$y, crs = st_crs(4326))
      
      plot_data
    })
    
    #ModE-RA sources dependent variable
    
    ranges_4b  <- reactiveValues(x = NULL, y = NULL)
    ranges2_4b <- reactiveValues(x = NULL, y = NULL)
    
    fad_wa4b <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a4b, "winter", lonlat_vals_dv()[1:2], lonlat_vals_dv()[3:4], labs)}
    fad_sa4b <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a4b, "summer", lonlat_vals_dv()[1:2], lonlat_vals_dv()[3:4], labs)}
    
    # Upper map (Original)
    output$fad_winter_map_a4b <- renderPlot({
      if ((month_range_dv()[1] >= 4) && (month_range_dv()[2] <= 9)) {
        plot_data <- fad_sa4b(labs = TRUE)
      } else {
        plot_data <- fad_wa4b(labs = TRUE)
      }
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Upper map (Zoom)
    output$fad_zoom_winter_a4b <- renderPlot({
      if ((month_range_dv()[1] >= 4) && (month_range_dv()[2] <= 9)) {
        plot_data <- fad_sa4b(labs = FALSE)
      } else {
        plot_data <- fad_wa4b(labs = FALSE)
      }
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges_4b$x, ylim = ranges_4b$y, crs = st_crs(4326))
      
      plot_data
    })
    
    # Lower map (Original)
    output$fad_summer_map_a4b <- renderPlot({
      if ((month_range_dv()[1] >= 4 && month_range_dv()[2] <= 9) | (month_range_dv()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa4b(labs = TRUE)  
      } 
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Lower map (Zoom)
    output$fad_zoom_summer_a4b <- renderPlot({
      if ((month_range_dv()[1] >= 4 && month_range_dv()[2] <= 9) || (month_range_dv()[2] <= 3)) {
        NULL
      } else {
        plot_data <- fad_sa4b(labs = FALSE)
      }
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges2_4b$x, ylim = ranges2_4b$y, crs = st_crs(4326))
      
      plot_data
    })
    
    #Update Modera source year input and update brushes
    
    observeEvent(input$range_years3[1], {
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_a4a",
        value = input$range_years3[1])
    })
    
    observeEvent(input$range_years3[1], {
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_a4b",
        value = input$range_years3[1])
    })
    
    observe({
      brush_iva <- input$brush_fad1a4a
      if (!is.null(brush_iva)) {
        ranges_4a$x <- c(brush_iva$xmin, brush_iva$xmax)
        ranges_4a$y <- c(brush_iva$ymin, brush_iva$ymax)
        
      } else {
        ranges_4a$x <- lonlat_vals_iv()[1:2]
        ranges_4a$y <- lonlat_vals_iv()[3:4]
      }
    })
    
    observe({
      brush_iva2 <- input$brush_fad1b4a
      if (!is.null(brush_iva2)) {
        ranges2_4a$x <- c(brush_iva2$xmin, brush_iva2$xmax)
        ranges2_4a$y <- c(brush_iva2$ymin, brush_iva2$ymax)
        
      } else {
        ranges2_4a$x <- lonlat_vals_iv()[1:2]
        ranges2_4a$y <- lonlat_vals_iv()[3:4]
      }
    })
    
    observe({
      brush_dva <- input$brush_fad1a4b
      if (!is.null(brush_dva)) {
        ranges_4b$x <- c(brush_dva$xmin, brush_dva$xmax)
        ranges_4b$y <- c(brush_dva$ymin, brush_dva$ymax)
        
      } else {
        ranges_4b$x <- lonlat_vals_dv()[1:2]
        ranges_4b$y <- lonlat_vals_dv()[3:4]
      }
    })
    
    observe({
      brush_dva2 <- input$brush_fad1b4b
      if (!is.null(brush_dva2)) {
        ranges2_4b$x <- c(brush_dva2$xmin, brush_dva2$xmax)
        ranges2_4b$y <- c(brush_dva2$ymin, brush_dva2$ymax)
        
      } else {
        ranges2_4b$x <- lonlat_vals_dv()[1:2]
        ranges2_4b$y <- lonlat_vals_dv()[3:4]
      }
    })
    
    ### Downloads ----
    #Downloads
    
    output$download_reg_ts_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-ts.",input$reg_ts_plot_type, sep = "")},
                                                        content  = function(file) {
                                                          if (input$reg_ts_plot_type == "png"){
                                                            png(file, width = 3000, height = 1285, res = 200) 
                                                            reg_ts1a()  
                                                            dev.off()
                                                          } else if (input$reg_ts_plot_type == "jpeg"){
                                                            jpeg(file, width = 3000, height = 1285, res = 200) 
                                                            reg_ts1a()
                                                            dev.off()
                                                          } else {
                                                            pdf(file, width = 14, height = 6) 
                                                            reg_ts1a()
                                                            dev.off()
                                                          }})
    
    output$download_reg_ts2_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-ts.",input$reg_ts2_plot_type, sep = "")},
                                                         content  = function(file) {
                                                           if (input$reg_ts2_plot_type == "png"){
                                                             png(file, width = 3000, height = 1285, res = 200) 
                                                             reg_ts1b()  
                                                             dev.off()
                                                           } else if (input$reg_ts2_plot_type == "jpeg"){
                                                             jpeg(file, width = 3000, height = 1285, res = 200) 
                                                             reg_ts1b()
                                                             dev.off()
                                                           } else {
                                                             pdf(file, width = 14, height = 6) 
                                                             reg_ts1b()
                                                             dev.off()
                                                           }})
    
    output$download_reg_ts_plot_data  <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-tsdata.",input$reg_ts_plot_data_type, sep = "")},
                                                         content  = function(file) {
                                                           if (input$reg_ts_plot_data_type == "csv"){
                                                             write.csv(regression_ts_data(), file,
                                                                       row.names = FALSE,
                                                                       col.names = TRUE)
                                                           } else {
                                                             write.xlsx(regression_ts_data(), file,
                                                                        row.names = FALSE,
                                                                        col.names = TRUE)
                                                           }})                                                        
    
    
    output$download_reg_sum_txt <- downloadHandler(filename = function() {"statistical_summary.txt"},
                                                   content = function(file) {
                                                      capture <- capture.output({
                                                                  reg_sd()
                                                                    })
                                                                    writeLines(capture, file)
                                                                  }
                                                                )
    
    
    output$download_reg_coe_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-map.",input$reg_coe_plot_type, sep = "")},
                                                        content  = function(file) {
                                                          if (input$reg_coe_plot_type == "png"){
                                                            png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200)  
                                                            reg_coef_1()
                                                            dev.off()
                                                          } else if (input$reg_coe_plot_type == "jpeg"){
                                                            jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200) 
                                                            reg_coef_1() 
                                                            dev.off()
                                                          } else {
                                                            pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200) 
                                                            reg_coef_1()
                                                            dev.off()
                                                          }})
    
    output$download_reg_coe_plot_data        <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_coe_plot_data_type, sep = "")},
                                                        content  = function(file) {
                                                          if (input$reg_coe_plot_data_type == "csv"){
                                                            write.csv(reg_coef_2(), file,
                                                                      row.names = FALSE,
                                                                      col.names = FALSE)
                                                          } else {
                                                            write.xlsx(reg_coef_2(), file,
                                                                       row.names = FALSE,
                                                                       col.names = FALSE)
                                                          }})
    
    output$download_reg_pval_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-map.",input$reg_pval_plot_type, sep = "")},
                                                         content  = function(file) {
                                                           if (input$reg_pval_plot_type == "png"){
                                                             png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200)  
                                                             reg_pval_1()
                                                             dev.off()
                                                           } else if (input$reg_pval_plot_type == "jpeg"){
                                                             jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200) 
                                                             reg_pval_1() 
                                                             dev.off()
                                                           } else {
                                                             pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200) 
                                                             reg_pval_1()
                                                             dev.off()
                                                           }})
    
    output$download_reg_pval_plot_data       <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_pval_plot_data_type, sep = "")},
                                                                content  = function(file) {
                                                                  if (input$reg_pval_plot_data_type == "csv"){
                                                                    write.csv(reg_pval_2(), file,
                                                                              row.names = FALSE,
                                                                              col.names = FALSE)
                                                                  } else {
                                                                    write.xlsx(reg_pval_2(), file,
                                                                               row.names = FALSE,
                                                                               col.names = FALSE)
                                                                  }})
    
    output$download_reg_res_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-map.",input$reg_res_plot_type, sep = "")},
                                                          content  = function(file) {
                                                            if (input$reg_res_plot_type == "png"){
                                                              png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200)  
                                                              reg_res_1()
                                                              dev.off()
                                                            } else if (input$reg_res_plot_type == "jpeg"){
                                                              jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200) 
                                                              reg_res_1() 
                                                              dev.off()
                                                            } else {
                                                              pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200) 
                                                              reg_res_1()
                                                              dev.off()
                                                            }})
    
    output$download_reg_res_plot_data        <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_res_plot_data_type, sep = "")},
                                                                content  = function(file) {
                                                                  if (input$reg_res_plot_data_type == "csv"){
                                                                    write.csv(reg_res_2(), file,
                                                                              row.names = FALSE,
                                                                              col.names = FALSE)
                                                                  } else {
                                                                    write.xlsx(reg_res_2(), file,
                                                                               row.names = FALSE,
                                                                               col.names = FALSE)
                                                                  }})
    

    ## ModE-RA sources independent Variable #
    
    output$download_fad_sa4a             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a4a, "-modera_source.",input$file_type_modera_source_b4a, sep = "")},
                                                            content  = function(file) {
                                                              
                                                              mmd4a = generate_map_dimensions(subset_lons_iv(), subset_lats_iv(), session$clientData$output_fad_winter_map_a4a_width, input$dimension[2], FALSE)
                                                              
                                                              if (input$file_type_modera_source_b4a == "png"){
                                                                png(file, width = mmd4a[3] , height = mmd4a[4], res = 400)  
                                                                print(fad_sa4a(labs = TRUE))
                                                                dev.off()
                                                              } else if (input$file_type_modera_source_b4a == "jpeg"){
                                                                jpeg(file, width = mmd4a[3] , height = mmd4a[4], res = 400) 
                                                                print(fad_sa4a(labs = TRUE)) 
                                                                dev.off()
                                                              } else {
                                                                pdf(file, width = mmd4a[3]/400 , height = mmd4a[4]/400) 
                                                                print(fad_sa4a(labs = TRUE))
                                                                dev.off()
                                                              }})
    
    output$download_fad_wa4a             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a4a, "-modera_source.",input$file_type_modera_source_a4a, sep = "")},
                                                            content  = function(file) {
                                                              
                                                              mmd4a = generate_map_dimensions(subset_lons_iv(), subset_lats_iv(), session$clientData$output_fad_winter_map_a4a_width, input$dimension[2], FALSE)
                                                              
                                                              if (input$file_type_modera_source_a4a == "png"){
                                                                png(file, width = mmd4a[3] , height = mmd4a[4], res = 400)  
                                                                print(fad_wa4a(labs = TRUE))
                                                                dev.off()
                                                              } else if (input$file_type_modera_source_a4a == "jpeg"){
                                                                jpeg(file, width = mmd4a[3] , height = mmd4a[4], res = 400) 
                                                                print(fad_wa4a(labs = TRUE)) 
                                                                dev.off()
                                                              } else {
                                                                pdf(file, width = mmd4a[3]/400 , height = mmd4a[4]/400) 
                                                                print(fad_wa4a(labs = TRUE))
                                                                dev.off()
                                                              }})
    
    ## ModE-RA sources dependent Variable
    
    output$download_fad_sa4b             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a4b, "-modera_source.",input$file_type_modera_source_b4b, sep = "")},
                                                            content  = function(file) {
                                                              
                                                              mmd4b = generate_map_dimensions(subset_lons_dv(), subset_lats_dv(), session$clientData$output_fad_winter_map_a4b_width, input$dimension[2], FALSE)
                                                              
                                                              if (input$file_type_modera_source_b4b == "png"){
                                                                png(file, width = mmd4b[3] , height = mmd4b[4], res = 400)  
                                                                print(fad_sa4b(labs = TRUE))
                                                                dev.off()
                                                              } else if (input$file_type_modera_source_b4b == "jpeg"){
                                                                jpeg(file, width = mmd4b[3] , height = mmd4b[4], res = 400) 
                                                                print(fad_sa4b(labs = TRUE)) 
                                                                dev.off()
                                                              } else {
                                                                pdf(file, width = mmd4b[3]/400 , height = mmd4b[4]/400) 
                                                                print(fad_sa4b(labs = TRUE))
                                                                dev.off()
                                                              }})
    
    output$download_fad_wa4b             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a4b, "-modera_source.",input$file_type_modera_source_a4b, sep = "")},
                                                            content  = function(file) {
                                                              
                                                              mmd4b = generate_map_dimensions(subset_lons_dv(), subset_lats_dv(), session$clientData$output_fad_winter_map_a4b_width, input$dimension[2], FALSE)
                                                              
                                                              if (input$file_type_modera_source_a4b == "png"){
                                                                png(file, width = mmd4b[3] , height = mmd4b[4], res = 400)  
                                                                print(fad_wa4b(labs = TRUE))
                                                                dev.off()
                                                              } else if (input$file_type_modera_source_a4b == "jpeg"){
                                                                jpeg(file, width = mmd4b[3] , height = mmd4b[4], res = 400) 
                                                                print(fad_wa4b(labs = TRUE)) 
                                                                dev.off()
                                                              } else {
                                                                pdf(file, width = mmd4b[3]/400 , height = mmd4b[4]/400) 
                                                                print(fad_wa4b(labs = TRUE))
                                                                dev.off()
                                                              }})

    
  ## MONTHLY TS data processing and plotting ----
    ### Plot timeseries & data ----
    
    # Plot Timeseries
    monthly_ts_plot = reactive({
      plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5,"base")
      add_highlighted_areas(ts_highlights_data5())
      add_custom_lines(ts_lines_data5())
      plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5,"lines")
      add_boxes(ts_highlights_data5())
      add_custom_points(ts_points_data5())
      if (input$show_key_ts5 == TRUE){
        add_TS_key(input$key_position_ts5,ts_highlights_data5(),ts_lines_data5(),input$variable_selected5,c(1,2),
                   FALSE,NA,FALSE,NA,NA,NA,FALSE)
      }
    })
    
    output$timeseries5 <- renderPlot({monthly_ts_plot()}, height = 400)
    
    # Show variable, unit and data
    
    output$data5 = renderDataTable({monthly_ts_data()}, rownames = FALSE, options = list(
      autoWidth = TRUE, 
      searching = FALSE,
      paging = TRUE,
      pagingType = "numbers"
    ))
    
    
    
    
    # Close Server    
    
    ### ModE-RA sources ----
    
    ranges5  <- reactiveValues(x = NULL, y = NULL)
    ranges5_2 <- reactiveValues(x = NULL, y = NULL)
    
    fad_wa5 <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a5, "winter",input$fad_longitude_a5,input$fad_latitude_a5,labs)}
    fad_sa5 <- function(labs) {
      labs = labs
      plot_modera_sources(input$fad_year_a5, "summer", input$fad_longitude_a5,input$fad_latitude_a5,labs)}
    
    # Upper map (Original)
    output$fad_winter_map_a5 <- renderPlot({
      
      plot_data <- fad_wa5(labs = TRUE)
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Upper map (Zoom)
    output$fad_zoom_winter_a5 <- renderPlot({
      plot_data <- fad_wa5(labs = FALSE)
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges5$x, ylim = ranges5$y, crs = st_crs(4326))
      
      plot_data
    })
    
    # Lower map (Original)
    output$fad_summer_map_a5 <- renderPlot({

      plot_data <- fad_sa5(labs = TRUE)  
      
      # Render the "Original Map" with no fixed aspect ratio
      plot_data
    })
    
    # Lower map (Zoom)
    output$fad_zoom_summer_a5 <- renderPlot({

      plot_data <- fad_sa5(labs = FALSE)
      
      # Apply coord_sf to the entire map with adjusted limits
      plot_data <- plot_data + coord_sf(xlim = ranges5_2$x, ylim = ranges5_2$y, crs = st_crs(4326))
      
      plot_data
    })
    
    
    #Update Modera source year input and Brushes when Double Click happens
    
    observe({
      brush <- input$brush_fad1a5
      if (!is.null(brush)) {
        ranges5$x <- c(brush$xmin, brush$xmax)
        ranges5$y <- c(brush$ymin, brush$ymax)
        
      } else {
        ranges5$x <- input$fad_longitude_a5
        ranges5$y <- input$fad_latitude_a5
      }
    })
    
    observe({
      brush_b <- input$brush_fad1b5
      if (!is.null(brush_b)) {
        ranges5_2$x <- c(brush_b$xmin, brush_b$xmax)
        ranges5_2$y <- c(brush_b$ymin, brush_b$ymax)
        
      } else {
        ranges5_2$x <- input$fad_longitude_a5
        ranges5_2$y <- input$fad_latitude_a5
      }
    })
    
    
    # Update Modera source year & latlon input
    
    # Get last year monthly_ts_data
    last_year = reactive({
      
      # Get last years
      last_yrs = as.character(tail(monthly_ts_data(),n=1)[2])
      
      # Extract last year date
      if (grepl(",",last_yrs)){
        last_yr = max(as.integer(unlist(strsplit(last_yrs,","))))
      } else if (grepl("-",last_yrs)){
        last_yr = as.integer(unlist(strsplit(last_yrs,"-")))[2]
      } else {
        last_yr = as.integer(last_yrs)
      }
      
      return(last_yr)
    })
    
    # Get last coordinates from monthly_ts_data
    last_coordinates = reactive({
      
      # Get last coords and split into lat,lon
      last_coords = unlist(strsplit(as.character(tail(monthly_ts_data(),n=1)[17]),","))
      
      # Extract lon
      if (grepl(":",last_coords[1])){
        last_lons = gsub("[^0-9.-]", "", unlist(strsplit(last_coords[1],":")))
      } else {
        last_lons = rep(gsub("[^0-9.-]", "", last_coords[1]),2)
      }
      
      # Extract lat
      if (grepl(":",last_coords[2])){
        last_lats = gsub("[^0-9.-]", "", unlist(strsplit(last_coords[2],":")))
      } else {
        last_lats = rep(gsub("[^0-9.-]", "", last_coords[2]),2)
      }
      
      last_coord = c(last_lons,last_lats)
      
      return(last_coord)
    })
    
    # Update ME source year
    observeEvent(last_year(),{
      updateNumericInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_year_a5",
        value = last_year())
    })
    
    # Update ME source coordinates
    observeEvent(last_coordinates(),{
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_longitude_a5",
        label = NULL,
        value = last_coordinates()[1:2])
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_latitude_a5",
        label = NULL,
        value = last_coordinates()[3:4])
    })
    
    ### Downloading Monthly TS data ----
    
    output$download_timeseries5      <- downloadHandler(filename = function(){paste("monthly-ts.",input$file_type_timeseries5, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries5 == "png"){
                                                           png(file, width = 3000, height = 1285, res = 200) 
                                                           plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5)
                                                           dev.off()
                                                         } else if (input$file_type_timeseries5 == "jpeg"){
                                                           jpeg(file, width = 3000, height = 1285, res = 200) 
                                                           plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5)
                                                           dev.off()
                                                         } else {
                                                           pdf(file, width = 14, height = 6) 
                                                           plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5)
                                                           dev.off()
                                                         }}) 
  
    
    output$download_timeseries_data5  <- downloadHandler(filename = function(){paste("monthly-tsdata.",input$file_type_timeseries_data5, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_timeseries_data5 == "csv"){
                                                            write.csv(monthly_ts_data(), file,
                                                                      row.names = FALSE,
                                                                      col.names = TRUE)
                                                          } else {
                                                            write.xlsx(monthly_ts_data(), file,
                                                                       row.names = FALSE,
                                                                       col.names = TRUE)
                                                          }})
    
    output$download_fad_sa5             <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a5, "-modera_source.",input$file_type_modera_source_b5, sep = "")},
                                                           content  = function(file) {
                                                             
                                                             mmd5 = generate_map_dimensions(create_subset_lon_IDs(input$fad_longitude_a5),create_subset_lat_IDs(input$fad_latitude_a5), session$clientData$output_fad_winter_map_a5_width, input$dimension[2], FALSE)
                                                             
                                                             if (input$file_type_modera_source_b5 == "png"){
                                                               png(file, width = mmd5[3] , height = mmd5[4], res = 400)  
                                                               print(fad_sa5(labs = TRUE))
                                                               dev.off()
                                                             } else if (input$file_type_modera_source_b5 == "jpeg"){
                                                               jpeg(file, width = mmd5[3] , height = mmd5[4], res = 400) 
                                                               print(fad_sa5(labs = TRUE)) 
                                                               dev.off()
                                                             } else {
                                                               pdf(file, width = mmd5[3]/400 , height = mmd5[4]/400) 
                                                               print(fad_sa5(labs = TRUE))
                                                               dev.off()
                                                             }})
    
    output$download_fad_wa5             <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a5, "-modera_source.",input$file_type_modera_source_a5, sep = "")},
                                                           content  = function(file) {
                                                             
                                                             mmd5 = generate_map_dimensions(create_subset_lon_IDs(input$fad_longitude_a5),create_subset_lat_IDs(input$fad_latitude_a5), session$clientData$output_fad_winter_map_a5_width, input$dimension[2], FALSE)
                                                             
                                                             if (input$file_type_modera_source_a5 == "png"){
                                                               png(file, width = mmd5[3] , height = mmd5[4], res = 400)  
                                                               print(fad_wa5(labs = TRUE))
                                                               dev.off()
                                                             } else if (input$file_type_modera_source_a5 == "jpeg"){
                                                               jpeg(file, width = mmd5[3] , height = mmd5[4], res = 400) 
                                                               print(fad_wa5(labs = TRUE)) 
                                                               dev.off()
                                                             } else {
                                                               pdf(file, width = mmd5[3]/400 , height = mmd5[4]/400) 
                                                               print(fad_wa5(labs = TRUE))
                                                               dev.off()
                                                             }})
  ## Conercning all modes (mainly updating Ui) ----
    
    #Updates Values outside of min / max (numericInput)
    observe({
      input_values <- input$point_size
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$point_size2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size2", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size2", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size2", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$point_size3
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size3", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size3", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size3", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$point_size_ts
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size_ts", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size_ts", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size_ts", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$point_size_ts2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size_ts2", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size_ts2", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size_ts2", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$point_size_ts3
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "point_size_ts3", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "point_size_ts3", value = 1)
            } else if (val > 10) {
              updateNumericInput(inputId = "point_size_ts3", value = 10)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$percentage_sign_match
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "percentage_sign_match", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "percentage_sign_match", value = 1)
            } else if (val > 100) {
              updateNumericInput(inputId = "percentage_sign_match", value = 100)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$percentage_sign_match2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "percentage_sign_match2", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "percentage_sign_match2", value = 1)
            } else if (val > 100) {
              updateNumericInput(inputId = "percentage_sign_match2", value = 100)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$percentage_sign_match2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "percentage_sign_match2", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "percentage_sign_match2", value = 1)
            } else if (val > 100) {
              updateNumericInput(inputId = "percentage_sign_match2", value = 100)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$hidden_SD_ratio
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "hidden_SD_ratio", value = 0)
        } else {
          update_value <- function(val) {
            if (val < 0) {
              updateNumericInput(inputId = "hidden_SD_ratio", value = 0)
            } else if (val > 1) {
              updateNumericInput(inputId = "hidden_SD_ratio", value = 1)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$hidden_SD_ratio2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "hidden_SD_ratio2", value = 0)
        } else {
          update_value <- function(val) {
            if (val < 0) {
              updateNumericInput(inputId = "hidden_SD_ratio2", value = 0)
            } else if (val > 1) {
              updateNumericInput(inputId = "hidden_SD_ratio2", value = 1)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$year_moving_ts
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "year_moving_ts", value = 3)
        } else {
          update_value <- function(val) {
            if (val < 3) {
              updateNumericInput(inputId = "year_moving_ts", value = 3)
            } else if (val > 30) {
              updateNumericInput(inputId = "year_moving_ts", value = 30)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$year_moving_ts3
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "year_moving_ts3", value = 3)
        } else {
          update_value <- function(val) {
            if (val < 3) {
              updateNumericInput(inputId = "year_moving_ts3", value = 3)
            } else if (val > 30) {
              updateNumericInput(inputId = "year_moving_ts3", value = 30)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a2", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a2", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a2", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a3a
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a3a", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a3a", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a3a", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a3b
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a3b", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a3b", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a3b", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a4a
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a4a", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a4a", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a4a", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a4b
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a4b", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a4b", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a4b", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$fad_year_a5
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "fad_year_a5", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "fad_year_a5", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "fad_year_a5", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$prior_years2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "prior_years2", value = 1)
        } else {
          update_value <- function(val) {
            if (val < 1) {
              updateNumericInput(inputId = "prior_years2", value = 1)
            } else if (val > 50) {
              updateNumericInput(inputId = "prior_years2", value = 50)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$reg_resi_year
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "reg_resi_year", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "reg_resi_year", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "reg_resi_year", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$range_years_sg
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "range_years_sg", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "range_years_sg", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "range_years_sg", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg2", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg2", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg2", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg_v1
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg_v1", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg_v1", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg_v1", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$range_years_sg3
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "range_years_sg3", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "range_years_sg3", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "range_years_sg3", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    
    observe({
      input_values <- input$ref_period_sg_v2
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg_v2", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg_v2", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg_v2", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg_iv
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg_iv", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg_iv", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg_iv", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$range_years_sg4
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "range_years_sg4", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "range_years_sg4", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "range_years_sg4", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg_dv
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg_dv", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg_dv", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg_dv", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    observe({
      input_values <- input$ref_period_sg5
      
      delay(1000, {
        if (!is.numeric(input_values)) {
          updateNumericInput(inputId = "ref_period_sg5", value = 1422)
        } else {
          update_value <- function(val) {
            if (val < 1422) {
              updateNumericInput(inputId = "ref_period_sg5", value = 1422)
            } else if (val > 2008) {
              updateNumericInput(inputId = "ref_period_sg5", value = 2008)
            }
          }
          
          update_value(input_values)
        }
      })
    })
    
    #Updates Values outside of min / max (numericRangeInput)
    
    observe({
      range_values <- input$range_years
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "range_years", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "range_years", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "range_years", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "range_years", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_years3
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "range_years3", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "range_years3", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "range_years3", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "range_years3", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_years4
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "range_years4", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "range_years4", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "range_years4", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "range_years4", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period2", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period2", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period2", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period2", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period_v1
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period_v1", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period_v1", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period_v1", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period_v1", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period_v2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period_v2", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period_v2", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period_v2", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period_v2", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period_iv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period_iv", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period_iv", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period_iv", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period_iv", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period_dv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period_dv", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period_dv", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period_dv", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period_dv", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$ref_period5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < 1422) {
          updateNumericRangeInput(inputId = "ref_period5", value = c(1422, range_values[2]))
        } else if (left > 2008) {
          updateNumericRangeInput(inputId = "ref_period5", value = c(1422, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < 1422) {
          updateNumericRangeInput(inputId = "ref_period5", value = c(range_values[1], 2008))
        } else if (right > 2008) {
          updateNumericRangeInput(inputId = "ref_period5", value = c(range_values[1], 2008))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude2", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude2", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude2", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude2", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude_v1
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude_v1", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude_v1", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude_v1", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude_v1", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude_v2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude_v2", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude_v2", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude_v2", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude_v2", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude_iv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude_iv", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude_iv", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude_iv", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude_iv", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude_dv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude_dv", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude_dv", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude_dv", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude_dv", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_longitude5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "range_longitude5", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "range_longitude5", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "range_longitude5", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "range_longitude5", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude_v1
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude_v1", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude_v1", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude_v1", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude_v1", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude_v2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude_v2", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude_v2", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude_v2", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude_v2", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude_iv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude_iv", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude_iv", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude_iv", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude_iv", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude_dv
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude_dv", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude_dv", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude_dv", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude_dv", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$range_latitude5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "range_latitude5", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "range_latitude5", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "range_latitude5", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "range_latitude5", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values_ts
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values2", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values_ts2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts2", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts2", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts2", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts2", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values_ts3
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts3", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts3", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts3", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts3", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values3
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values3", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values3", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values3", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values3", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_x_values_ts5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts5", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts5", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts5", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "highlight_x_values_ts5", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values2", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values2", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values2", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values2", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values3
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values3", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values3", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values3", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values3", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values_ts
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values_ts2
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts2", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts2", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts2", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts2", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values_ts3
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts3", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts3", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts3", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts3", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$highlight_y_values_ts5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts5", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts5", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts5", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "highlight_y_values_ts5", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$fad_latitude_a5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -90) {
          updateNumericRangeInput(inputId = "fad_latitude_a5", value = c(-90, range_values[2]))
        } else if (left > 90) {
          updateNumericRangeInput(inputId = "fad_latitude_a5", value = c(-90, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -90) {
          updateNumericRangeInput(inputId = "fad_latitude_a5", value = c(range_values[1], 90))
        } else if (right > 90) {
          updateNumericRangeInput(inputId = "fad_latitude_a5", value = c(range_values[1], 90))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    observe({
      range_values <- input$fad_longitude_a5
      
      update_values <- function(left, right) {
        if (!is.numeric(left) || is.na(left) || left < -180) {
          updateNumericRangeInput(inputId = "fad_longitude_a5", value = c(-180, range_values[2]))
        } else if (left > 180) {
          updateNumericRangeInput(inputId = "fad_longitude_a5", value = c(-180, range_values[2]))
        }
        
        if (!is.numeric(right) || is.na(right) || right < -180) {
          updateNumericRangeInput(inputId = "fad_longitude_a5", value = c(range_values[1], 180))
        } else if (right > 180) {
          updateNumericRangeInput(inputId = "fad_longitude_a5", value = c(range_values[1], 180))
        }
      }
      
      update_values(range_values[1], range_values[2])
    })
    
    #Single Year inputs update
    observe({
      if (!is.na(input$range_years_sg)) {
        updateNumericRangeInput(
          inputId = "range_years",
          value   = c(input$range_years_sg, input$range_years_sg)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg)) {
        updateNumericRangeInput(
          inputId = "ref_period",
          value   = c(input$ref_period_sg, input$ref_period_sg)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg2)) {
        updateNumericRangeInput(
          inputId = "ref_period2",
          value   = c(input$ref_period_sg2, input$ref_period_sg2)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg_v1)) {
        updateNumericRangeInput(
          inputId = "ref_period_v1",
          value   = c(input$ref_period_sg_v1, input$ref_period_sg_v1)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg_v2)) {
        updateNumericRangeInput(
          inputId = "ref_period_v2",
          value   = c(input$ref_period_sg_v2, input$ref_period_sg_v2)
        )
      }
    })
    
    observe({
      if (!is.na(input$range_years_sg3)) {
        updateNumericRangeInput(
          inputId = "range_years3",
          value   = c(input$range_years_sg3, input$range_years_sg3)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg_iv)) {
        updateNumericRangeInput(
          inputId = "ref_period_iv",
          value   = c(input$ref_period_sg_iv, input$ref_period_sg_iv)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg_dv)) {
        updateNumericRangeInput(
          inputId = "ref_period_dv",
          value   = c(input$ref_period_sg_dv, input$ref_period_sg_dv)
        )
      }
    })
    
    observe({
      if (!is.na(input$range_years_sg4)) {
        updateNumericRangeInput(
          inputId = "range_years4",
          value   = c(input$range_years_sg4, input$range_years_sg4)
        )
      }
    })
    
    observe({
      if (!is.na(input$ref_period_sg5)) {
        updateNumericRangeInput(
          inputId = "ref_period5",
          value   = c(input$ref_period_sg5, input$ref_period_sg5)
        )
      }
    })
    
    
}

# Run the app ----
shinyApp(ui = ui, server = server)
