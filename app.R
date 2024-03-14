### ClimeApp_beta ###

# Source for helpers ----
source("helpers.R")

# Define UI ----

ui <- navbarPage(id = "nav1",
          ## Configs for navbarPage: theme, images (Header and Footer) ----
          title = div(style = "display: inline;",
                      uiOutput("logo_output", inline = TRUE),
                      uiOutput("logo_output2", inline = TRUE),
                      "(v1.0)",
                      #Preparation to use Tracking ShinyJS and CSS
                      shinyjs::useShinyjs(),
                      use_tracking()
                      ),
          footer = div(class = "navbar-footer",
                       style = "display: inline;",
                       img(src = 'pics/oeschger_logo_rgb.jpg', id = "ClimeApp3", height = "100px", width = "100px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/LOGO_ERC-FLAG_EU_.jpg', id = "ClimeApp4", height = "100px", width = "141px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/WBF_SBFI_EU_Frameworkprogramme_E_RGB_pos_quer.jpg', id = "ClimeApp5", height = "100px", width = "349px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       img(src = 'pics/SNF_Logo_Logo.png', id = "ClimeApp6", height = "75px", width = "560px", style = "margin-top: 20px; margin-bottom: 20px;"),
                       # Navbar properties
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
                      '),
                      tags$script(
                       HTML('
                        $(document).ready(function() {
                          // Add event listener to detect when the collapsible menu is toggled
                          $(".navbar-toggle").click(function() {
                            $(".navbar").toggleClass("collapsed-menu");
                          });
                        });
                      ')),
                      ),
                       # No Red Error messages
                       tags$style(type="text/css",
                                  ".shiny-output-error { visibility: hidden; }",
                                  ".shiny-output-error:before { visibility: hidden; }"
                       )
                       ),
          theme = my_theme,
          position = c("fixed-top"),
          windowTitle = "ClimeApp (v1.0)",
          collapsible = TRUE,

# Welcome START ----                             
  tabPanel("Welcome", value = "tab0",
        includeCSS("www/custom.css"),
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
            h5(helpText("Franke, J., Veronika, V., Hand, R., Samakinwa, E., Burgdorf, A.M., Lundstad, E., Brugnara, Y., H\u00F6vel, L. and Br\u00F6nnimann, S., 2023")),
            
            
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
              h5(helpText("Z500 = 500 hPa geopotential height [m]"))
            ),
            
            column(width = 12, br()),
            
            column(width = 12,
                   
                   h5(strong("User information:", style = "color: #094030;")),
                   h5(helpText("To receive additional information for certain options, click question mark icons of UI elements, e.g. Anomalies")),
                   h5(helpText("Additional features and subordinate options are initially hidden but can be made visible by clicking or ticking the respective elements.")),
                   h5(helpText("ClimeApp updates instantly when inputs are changed or new values are selected. Customizations have to be added manually.")),
                   h5(helpText("Wait until the loading symbol is gone or the new plot is rendered befor changing further values."))
            )

          ), width = 12),
          
          br(),
          
            ### Second side bar ----
            
            sidebarPanel(fluidRow(
              h4(helpText("For feedback and suggestions on ClimeApp, please contact:")), br(),
              h4("Mail to the ClimeApp team:", a("climeapp.hist@unibe.ch", href = "mailto:climeapp.hist@unibe.ch"), style = "color: #094030;"),
              column(width = 12, br()),
              h4(helpText("For queries relating to the ModE-RA data, please contact:")),
              h4("Mail to J\u00F6rg Franke:", a("franke@giub.unibe.ch", href = "mailto:franke@giub.unibe.ch"), style = "color: #094030;")
              
            ), width = 12),
          
            br(),
          
            ### Third side bar ----
            sidebarPanel(fluidRow(
              h4(helpText("An offline version ClimeApp for Windows - CLIMEAPP DESKTOP - is available to download here:")), br(),
              column(width = 12,
                downloadButton("climeapp_desktop_download",
                               label = "Download ClimeApp Desktop")
              ),
              h5(helpText("System Requirements: Download = 5.84 Gb. Full Installation = 11.6 Gb."))
            ), width = 12)
          ## Sidebar Panels END ---- 
          )),
          ## Main panel START ----
          mainPanel(
            ### Tabs Start ----
            tabsetPanel(id = "tabset0",
            #### Tab Welcome ----
            tabPanel("Welcome",
            tags$img(src = 'pics/welcome_map.jpg', id = "welcome_map", class = "responsive-img"),
            h4("For more information on ModE-RA please see:", style = "color: #094030;"),
            h5(helpText(a("ModE-RA - a global monthly paleo-reanalysis of the modern era 1421 to 2008", href = "https://doi.org/10.1038/s41597-023-02733-8"), br(), a("ModE-RAclim - a version of the ModE-RA reanalysis with climatological prior for sensitivity studies", href = "https://www.wdc-climate.de/ui/entry?acronym=ModE-RAc"), br(),  a("ModE-Sim – a medium-sized atmospheric general circulation model (AGCM) ensemble to study climate variability during the modern era (1420 to 2009)", href = "https://gmd.copernicus.org/articles/16/4853/2023/"), br(), "[Place Holder for link to: ClimeApp technical paper (in progress)]")),
            h4("To cite, please reference:", style = "color: #094030;"),
            h5(helpText("[Place Holder: ClimeApp technical paper (in progress)]")),
            h5(helpText("V. Valler, J. Franke, Y. Brugnara, E. Samakinwa, R. Hand, E. Lundstad, A.-M. Burgdorf, L. Lipfert, A. R. Friedman, S. Br\u00F6nnimann: ModE-RA: a global monthly paleo-reanalysis of the modern era 1421 to 2008. Scientific Data 11 (2024).")),
            h5(helpText("R. Hand, E. Samakinwa, L. Lipfert, and S. Br\u00F6nnimann: ModE-Sim – a medium-sized atmospheric general circulation model (AGCM) ensemble to study climate variability during the modern era (1420 to 2009). GMD 16 (2023).")),
            h6(helpText("PALAEO-RA: H2020/ERC grant number 787574")),
            h6(helpText("DEBTS: SNSF grant number PZ00P1_201953")),
            h6(helpText("VolCOPE: SERI contract number MB22.00030")),
            ),
            #### Tab ModE data ----
            tabPanel("ModE data",
                     br(), br(), 
                     helpText(a("ModE-RA (ensemble members and statistics)", href = "https://doi.org/10.26050/WDCC/ModE-RA_s14203-18501"), "and", a("ModE-RAclim (ensemble statistics)", href = "https://doi.org/10.26050/WDCC/ModE-RAc_s14203-18501"), "are uploaded to NOAA and to the World Data Center for Climate (WDCC) at Deutsches Klimarechenzentrum in Hamburg, Germany. The two climate reconstructions are in NetCDF4 format; the NetCDF4 files cover the whole period per variable. Ensemble statistics include the mean (monthly anomalies with respect to the period 1901 to 2000), maximum, minimum and spread in terms of one standard deviation from the ensemble mean. The observation feedback archive files are available in tsv format (one file per 6 months), which contain all relevant information of the input data, how the input data were processed, and useful feedback information from the DA system.", a("A detailed list of all information", href = "https://www.wdc-climate.de/ui/entry?acronym=ModE-RA_info"), "stored in the feedback archive has been published with the dataset."),
                     br(), br(), 
                     helpText("The ModE-RA paleo-reanalysis is identical to the ModE-Sim simulations in areas far away from any assimilated observations, especially at the beginning of the reconstruction period. With time, more and more observations are available, suggesting that the reconstruction becomes more skillful. Therefore, the users first should ensure how reliable the paleo-reanalysis is for a given region and time period. This can be achieved by looking at the ensemble spread and the differences between ModE-Sim and ModE-RA. Among the reconstructed variables, the ones with observational input data are the most realistically estimated. We encourage the users to make use of the ensemble members and not only the ensemble mean."), 
                     br(), br(), 
                     helpText("ModE-Sim was generated in two phases (1420–1850 and 1850–2009) with different boundary conditions. In the earlier period, ModE-RA is based on ModE-Sim Set 1420-3, and in the later period on ModE-Sim Set 1850-1. ModE-RA is not split into the two periods of the ModE-Sim prior because the assimilated observational time series lead to a smooth transition between the two periods of the ModE-Sim sets."),
                     br(), br(), 
                     helpText("ModE-RA was generated by transforming both model simulations and observations to 71-year running anomalies. Hence, users should be aware that the centennial-scale variability is the model response to forcings. Therefore, we see great potential for future research, particularly in terms of intra-annual to multi-decadal variability. We provide monthly anomalies with respect to the 1901 to 2000 climatology and the model climatology for the 1901 to 2000 period. Be aware that the model climatology includes model biases. Therefore, we recommend using anomalies instead of absolute values."),
                     br(), br(), 
                     helpText("Furthermore, because of the employed setup, unrealistic values (such as negative precipitation) can occur if absolute values are generated by adding back a climatology. This is especially an issue in arid regions where monthly precipitation is not normally distributed. Precipitation is consistent in the periods of 1421–1800 and 1900–2009 when the observational network is quite stable, but in the 19th century, when many of the observation time series start, a trend is introduced in some arid land regions and tropical oceans. Hence, in the case of the reconstructed precipitation fields, the early and late period should be looked at separately."),
                     br(), br(),
                     helpText("ModE-RAclim should be seen as a sensitivity study and is only a side product of the project. ModE-RAclim does not contain centennial scale climate variability. For most users, the main product ModE-RA therefore should be used for regular studies on past climate. The main differences between ModE-RAclim and ModE-RA are on the model side: ModE-RAclim uses 100 randomly picked years from ModE-Sim as a priori state. Thereby, stationarity in the covariance structure is assumed, and the externally-forced signal in the model simulations is eliminated. In combination with ModE-Sim and ModE-RA it can be used to distinguish the forced and unforced parts of climate variability seen in ModE-RA."),
                     br(), br(),
                     helpText("ModE-RA makes use of several data compilations and assimilates various direct and indirect sources of past climate compared to 20CRv3. Hence, if monthly resolution is sufficient for the planned study, ModE-RA may have higher quality already from 1850 backwards to analyze past climate changes and can be viewed as the backward extension of 20CRv3."),
                     br(), br(),
                     h6(helpText("(Cf. ModE-RA paper", a("Usage notes.", href = "https://www.nature.com/articles/s41597-023-02733-8#Sec13"),")")),
                     ),
            #### Tab ClimeApp funtions ----
            tabPanel("ClimeApp functions",

                     br(), br(),
                     h5(strong("Anomalies:", style = "color: #094030;")),
                     helpText("The anomaly map function shows the spatial distribution of climate anomalies averaged over a user-selected year range and month range. For example, June, July, August (JJA), 1501 to 1600 if your focus is boreal summer in the 16th century. The anomalies are created from 3 data products:"),
                     br(),
                     tags$ol(
                       tags$li(em("Annual Means"), "– a timeseries of annual means for each point on the map, created by averaging absolute ModE values across the selected month range."),
                       tags$li(em("Reference Means"), "– a single reference mean for each point on the map, created by averaging annual means across a chosen reference year range."),
                       tags$li(em("Annual Anomalies"), "– a timeseries of annual anomalies for each point on the map, created by subtracting the", em("reference means"), "from the", em("annual means."))
                     ),
                     helpText("The final anomalies shown are the time-averaged annual anomalies. These are plotted using the base R plotting functions along with the coastlines and borders from the", em("maps"), "package.  The anomaly timeseries is generated by averaging the annual anomalies for each year. See Appendix 2. for the specific calculations behind each data product."),
                     br(),
                     helpText("For reference, the calculations behind each data product are as follows:"),
                     br(),
                     helpText("The", em("annual mean"), "for a single year and single point on the map is given by the equation"),
                     br(), withMathJax("$$Annual \\ Mean = \\overline{Absolute \\ Values \\ (M)}$$"), br(),
                     helpText("where \\(\\ (M) \\) is the selected month range."),
                     br(), br(),
                     helpText("The", em("reference mean"), "for a single year and point is given by"),
                     br(), withMathJax("$$ Reference \\ Mean = \\overline{Annual \\ Means \\ (Y_{\t{ref}})}$$"), br(),
                     helpText("where \\(\\ Y_{\t{ref}} \\) is the selected reference year range."),
                     br(), br(),
                     helpText("The", em("annual anomaly"), "for a single year and point is given by:"),
                     br(), withMathJax("$$ Annual \\ Anomaly = Annual \\ Mean - Reference \\ Mean$$"),
                     br(), br(),
                     helpText("Note that in the case of ModE-RAclim, the base data is already in anomaly format, so anomalies are merely calculated by subtracting time-averaged anomalies from each other."),
                     br(), br(),
                     helpText("The anomalies presented on the anomaly map and in the anomaly map data are given by"),
                     br(), withMathJax("$$ Anomaly \\ (map) = \\overline{Annual \\ Means \\ (Y)} - \\ Reference \\ Mean = \\overline{Annual \\ Anomalies \\ (Y)}$$"), br(),
                     helpText("where \\(Y \\) is the selected year range."),
                     br(), br(),
                     helpText("Anomalies presented on the timeseries map and timeseries data are given by"),
                     br(), withMathJax("$$ Anomaly \\ (timeseries) = \\ (Annual \\ Means \\ (Lon, \\ Lat)) - \\ (Reference \\ Means \\ (Lon, \\ Lat)) = \\ (Annual \\ Anomalies \\ (Lon, \\ Lat))$$"), br(),
                     helpText("where", em("Lon"), "and", em("Lat"), "are the selected longitude and latitude range."),
                     
                     tags$hr(),
                     
                     br(), br(), 
                     h5(strong("Composites:", style = "color: #094030;")),
                     helpText("ClimeApp’s composite maps show the time-averaged anomalies for a set of non-consecutive years, which can be entered or uploaded by the user. The anomaly reference period can be a fixed set of consecutive years, a custom set of non-consecutive years or an individual reference period generated for each year based on the X (a number of years chosen by the user) years prior. Calculations and plotting are performed in the same way as for anomalies, except for anomalies compared to X years prior (XYP):"),
                     br(),
                     tags$ol(
                       tags$li(em("XYP Reference Means"), "– a set of reference means for each point on the map, one for each user-selected year. Calculated by averaging the X preceding", em("annual means.")),
                       tags$li(em("XYP Annual Anomalies"), "– a set of annual anomalies for each point on the map. Created by subtracting the corresponding", em("reference mean"), "from each", em("annual mean.")),
                       ),
                     helpText("To give an indication of the consistency of anomalies over the set of years in the composite, ClimeApp contains a ‘% sign match’ statistical tool. This marks regions where the", em("annual anomalies"), "that form the composite agree in their sign more often than a user-defined threshold, given in percent. For example, for a composite of five years, with anomalies of -1°C, -5°C, 1°C, 15°C and -3°C, the displayed mean would be a positive 1.4°C, but only 40% of the years would match this, since 3 are in fact negative."),
                     
                     tags$hr(),
                     
                     br(), br(), 
                     h5(strong("Correlation:", style = "color: #094030;")),
                     helpText("The correlation function allows users to generate a map of correlation coefficients, comparing either ModE variables or user-uploaded timeseries. 
                              Using the", em("cor()"), "function from the", em("stats"), "R package (R Core Team, 2022), it can employ either the Pearson or Spearman’s Ranks correlation method. 
                              If both variables are in ‘field’ format, i.e. gridded map data, it performs a timeseries correlation of the", em("annual means"), " for each point on the map with the corresponding", em("annual means"), " for the second variable. 
                              If one variable is a timeseries however, it correlates each set of", em("annual means"), " with the same timeseries. 
                              In addition to the map, ClimeApp also produces a correlation timeseries, showing an annual timeseries of both variables (spatially averaged in the case of ModE variables) and a single correlation coefficient and p-value, calculated from those timeseries. 
                              The p-value shows the probability that the correlation was produced by random chance rather than an actual relationship between the variables. 
                              p < 0.05 is generally recommended for drawing legitimate conclusions."),

                     tags$hr(),
                     
                     br(), br(), 
                     h5(strong("Regression:", style = "color: #094030;")),
                     helpText("In ClimeApp, regression operates in a similar way to correlation, performing a multiple linear regression analysis on a set of", em("annual means"), ". Using", em("lm()"), "from the", em("stats"), "R package, one or more independent variable timeseries are fitted to the dependent variable timeseries for each point on the map according to the model"),
                     br(), withMathJax("$$ V_{\t{Dependent}} = \\beta_1 V_{\t{Independent \\ 1}} + \\beta_2 V_{\t{Independent \\ 2}} + ... + \\ Residual$$"), br(),
                     helpText("where β is the coefficient and α is the intercept. ClimeApp then plots the spatial average of the dependent variable \\(\\ \\beta_1 V_{\t{Independent \\ 1}} + \\beta_2 V_{\t{Independent \\ 2}} + ... \\) and residual as a timeseries. Provided the dependent variable is a field, maps of the coefficients for each independent variable can be produced, as can maps of the p-values and residuals for each year."),
                     tags$hr(),
                     
                     br(), br(), 
                     h5(strong("Annual Cycles:", style = "color: #094030;")),
                     helpText("This function shows the spatially averaged monthly ModE values over a given year or set of years. In the case of a set of years, these can be presented individually or as an average."),
                     tags$hr(),
                     
                     br(), br(),
                     h5(strong("Source Analysis and Further Statistical Functions:", style = "color: #094030;")),
                     helpText("The accuracy of ModE-RA is dependent on the availability and reliability of observations to constrain the model ensemble of ModE-Sim. To capture this, ClimeApp includes tools for visualizing the sources used to create ModE-RA and ModE-RAclim and the standard deviation (SD) ratio of the ModE-RA and ModE-Sim ensembles. The ModE-RA sources are presented as a semi-annual map showing the data points assimilated for each half-year, grouped by type and variable. This allows the user to see where proxy, documentary or instrumental observations were integrated into the reconstruction and any gaps in the data. The SD ratio meanwhile, is the standard deviation of the ModE-Sim ensemble divided by the standard deviation of ModE-RA after the assimilation of observations:"),
                     br(), withMathJax("$$ SD \\ ratio = \\frac{\\sigma_{ModE-RA \\ Ensemble}}{\\sigma_{ModE-SIM \\ Ensemble}}$$"), 
                     helpText("This gives a value between 0 and 1 for each month and grid point, with 1 showing no constraint (i.e. the ModE-RA output is the same as that of ModE-Sim and entirely generated from the models) and lower values showing increasing constraint by observations, meaning there are either more observations or that they are more ‘trusted’ by the reconstruction. The temporal mean of the SD ratio can be presented in ClimeApp as a contour map or grid-point overlay on the anomaly maps."),
                     br(), 
                     helpText("On timeseries plots, users have the option to add percentiles and moving averages. The moving averages are calculated using a rolling mean of timeseries values over a number of years selected by the user (default 11). To generate the percentiles, a Shapiro-Wilk test (Shapiro and Wilk, 1965) is first conducted on the timeseries data. If the data is normally distributed, which is rare for ModE timeseries, then percentiles are calculated from the mean and standard deviation of the timeseries using the", em("qnorm()"), "function from the", em("stats"), "package. If the distribution is non-normal, ClimeApp instead finds the value corresponding to the quantile matching the users selection (i.e. for the 0.95 percentile, it returns values that 5% of all values are above/below), using the", em("quantile()"), "function from the stats package."),
                     
            ),
            #### Tab Version History ----
            tabPanel("Version history",
                     br(), br(),
                     h5(strong("v1.0 (11.03.2024)", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Download / Upload option for metadata"),
                       tags$li("Information panel for ClimeApp functions"),
                       tags$li("Helptext as popovers for UI elements"),
                     ),
                     br(),
                     h5(strong("Beta v0.6 (15.02.2024)", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Improved UI (i.e. Hide/Show country borders, Rearranged download sections"),
                       tags$li("Switch to Annual Cycle when a single year is selected"),
                       tags$li("Download ModE-RA source data as table"),
                       tags$li("Loading symbols during plot generation"),
                     ),
                     br(),
                     h5(strong("Beta v0.5 (22.12.2023)", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Download NetCDF files"),
                       tags$li("Version History"),
                     ),
                     br(),  
                     h5(strong("Beta v0.4", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Select single years")
                     ),
                     br(), 
                     h5(strong("Beta v0.3", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Timeseries customization"),
                       tags$li("Percentiles, maps & statistics based on model constraint change"),
                       tags$li("Reference line option in timeseries")
                     ),
                     br(), 
                     h5(strong("Beta v0.2 (10.11.2023)", style = "color: #094030;")),
                     tags$ul(
                       tags$li("Use ModE-Sim and ModE-RAclim data"),
                       tags$li("Create annual cycles method"),
                       tags$li("View ModE-RA sources"),
                       tags$li("Download ModE-RA sources maps as image"),
                       tags$li("Upload User data for correlation and regression"),
                       tags$li("Reference maps with absolute values, Reference values, and SD ratio for Anomalies and Composites")
                     ),
                     br(),  
                     h5(strong("Beta", style = "color: #094030;")),
                     tags$ul(
                       tags$li("First running version online"),
                       tags$li("Use ModE-RA data with four variables:  Temperature, Precipitation, Sea level pressure, Pressure at 500 hPa geopotential height"),
                       tags$li("Calculate Anomalies, Composites, Correlations and Regressions (coefficien, p values residuals) as maps and timeseries"),
                       tags$li("Customize maps and timeseries (title, labelling, add custom points and highlights, statistics)"),
                       tags$li("Download maps and timeseries plots as images"),
                       tags$li("Download map and timeseries data in xlsx or csv format")
                     ),
            ),

            ### Tabs END ----
            )            
          ## Main Panel END ----
          )
# Welcome END ----  
       )),
# Average & anomaly START ----                             
  tabPanel("Anomalies", value = "tab1",
                shinyjs::useShinyjs(),
                sidebarLayout(
      
                ## Sidebar Panels START ----          
                sidebarPanel(verticalLayout(
                
                    ### First Sidebar panel (Variable and dataset selection) ----
                    sidebarPanel(fluidRow(
                    #Method Title and Pop Over
                    anomalies_summary_popover("pop_anomalies"),
                      
                    br(),
          
                    #Short description of the selection options        
                    h4("Select dataset and variable", style = "color: #094030;", dataset_variable_popover("pop_anomalies_datvar")),

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
                    
                    ), width = 12), br(),
                    
                    ### Second Sidebar panel (Time selection) ----
                    sidebarPanel(fluidRow(
                      
                    #Short description of the temporal selection        
                    h4("Select a year range, season and reference period", style = "color: #094030;",year_season_ref_popover("pop_anomalies_time")),
            
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
                                   label     = "Select the reference year:",
                                   value     = NA,
                                   min       = 1422,
                                   max       = 2008)),
    
                    ), width = 12), br(),
            
                    ### Third sidebar panel (Location selection) ----
                    sidebarPanel(fluidRow(
              
                    #Short description of the Coord. Sidebar        
                    h4("Set geographical area", style = "color: #094030;"),
                    h5(helpText("Select a continent, enter coordinates manually or draw a box on the plot")),
                    
                     column(width = 12, fluidRow(
                       
                     br(), br(),   
                       
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
                       
                     br(), br(),   
                       
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
                    
                    #Enter Coordinates
                    column(12,
                        actionButton(inputId = "button_coord",
                                     label = "Update coordinates",
                                     width = "200px"),
                    ),
                        
                    ), width = 12)
                ## Sidebar Panels END ----
                )),

                ## Main Panel START ----
                mainPanel(tabsetPanel(id = "tabset1",
                
                    ### Map plot START ----   
                    tabPanel("Map", 
                             withSpinner(ui_element = plotOutput("map", height = "auto", dblclick = "map_dblclick1", brush = brushOpts(id = "map_brush1",resetOnNew = TRUE)), 
                                         image = spinner_image,
                                         image.width = spinner_width,
                                         image.height = spinner_height),
                             
                             uiOutput("vices", inline = TRUE),
                             uiOutput("dev_team", inline = TRUE),
                             uiOutput("ruebli", inline = TRUE),
                      
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,
                             h4("Customize your map", style = "color: #094030;",map_customization_popover("pop_anomalies_cusmap")),  
                            
                             checkboxInput(inputId = "custom_map",
                                           label   = "Map customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                                         div(id = "hidden_custom_maps",
          
                             radioButtons(inputId  = "axis_mode",
                                          label    = "Axis customization:",
                                          choices  = c("Automatic","Fixed"),
                                          selected = "Automatic" , inline = TRUE),
                             
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
                                       placeholder = "Custom title"))),
                             
                             br(),
                             
                             checkboxInput(inputId = "hide_borders",
                                           label   = "Show country borders",
                                           value   = TRUE),
                             
                             )),
                         ),
                      
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,
                             h4("Custom features", style = "color: #094030;",map_features_popover("pop_anomalies_mapfeat")),
                             
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
                                   h4(helpText("Add custom points",map_points_popover("pop_anomalies_mappoint"))),
                                   
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
                                   h4(helpText("Add custom highlights",map_highlights_popover("pop_anomalies_maphl"))),
                                   
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
                             h4("Custom statistics", style = "color: #094030;",map_statistics_popover("pop_anomalies_mapstat")),
                             
                             checkboxInput(inputId = "enable_custom_statistics",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             
                               div(id = "hidden_custom_statistics",
                                   h4(helpText("Choose custom statistic:",map_choose_statistic_popover("pop_anomalies_choosestat"))),
                                   
                                   radioButtons(inputId      = "custom_statistic",
                                                label        = NULL,
                                                inline       = TRUE,
                                                choices      = c("None","SD ratio")),
                                   
                                   div(id = "hidden_SD_ratio",  
                                       numericInput(inputId = "sd_ratio",
                                                    label  = "SD ratio < ",
                                                    value  = 0.2,
                                                    min    = 0,
                                                    max    = 1,
                                                    step   = 0.1)
                                   ),
                              ),
                      ),
                    
                      #### Customization panels END ----
                      ),
                      
                      #### Downloads ----
                      h4("Downloads", style = "color: #094030;",downloads_popover("pop_anomalies_map_downloads")),
                      checkboxInput(inputId = "download_options",
                                    label   = "Enable download options",
                                    value   = FALSE),
                      
                      shinyjs::hidden(div(id = "hidden_download",
                      # Download map 
                        h4(helpText("Map")),
                        fluidRow(
                          column(2, radioButtons(inputId = "file_type_map", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                          column(3, downloadButton(outputId = "download_map", label = "Download map")),
                        ),
                        
                      # Upload Meta data
                        h4(helpText("Metadata")),
                        fluidRow(
                          column(3, downloadButton(outputId = "download_metadata", label = "Download metadata")),
                          column(4, fileInput(inputId= "upload_metadata", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                          column(2, actionButton(inputId = "update_metadata", label = "Update upload inputs")),
                        ),
                      )),
                      
                      #### Abs/Ref Map plot START ----
                      h4("Reference map", style = "color: #094030;",reference_map_popover("pop_anomalies_refmap")), 
                      
                      radioButtons(inputId  = "ref_map_mode",
                                   label    = NULL,
                                   choices  = c("None", "Absolute Values","Reference Values","SD Ratio"),
                                   selected = "None" , inline = TRUE),
                      
                      withSpinner(ui_element = plotOutput("ref_map", height = "auto"), 
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
      
                      #### Download ref. map ----
                      shinyjs::hidden(div(id ="hidden_sec_map_download",
                                          h4("Download reference map", style = "color: #094030;"),
                                          fluidRow(
                                            column(2, radioButtons(inputId = "file_type_map_sec", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                            column(3, downloadButton(outputId = "download_map_sec", label = "Download reference map"))
                                          ),
                      )),

                    ### Map plot END ----
                    ),
            
          
                    ### TS plot START ----
                    tabPanel("Timeseries", 
                             withSpinner(ui_element = plotOutput("timeseries", click = "ts_click1",dblclick = "ts_dblclick1",brush = brushOpts(id = "ts_brush1",resetOnNew = TRUE)),
                                         image = spinner_image,
                                         image.width = spinner_width,
                                         image.height = spinner_height),
                      #### Customization panels START ----       
                      fluidRow(
                      #### Timeseries customization ----
                      column(width = 4,
                             h4("Customize your timeseries", style = "color: #094030;",timeseries_customization_popover("pop_anomalies_custime")),  
                              
                             checkboxInput(inputId = "custom_ts",
                                            label   = "Timeseries customization",
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
                            h4("Custom features", style = "color: #094030;",timeseries_features_popover("pop_anomalies_timefeat")),
                            
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
                                    h4(helpText("Add custom points",timeseries_points_popover("pop_anomalies_timepoint"))),
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
                                    h4(helpText("Add custom highlights", timeseries_highlights_popover("pop_anomalies_timehl"))),
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
                                                  label   = "Show on key",
                                                  value   = FALSE),
                                    
                                    hidden(
                                    textInput(inputId = "highlight_label_ts", 
                                              label   = "Label:",
                                              value   = "")),
                                    
                                    
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
                                    h4(helpText("Add custom lines",timeseries_lines_popover("pop_anomalies_timelines"))),
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
                                                  label   = "Show on key",
                                                  value   = FALSE),
                                    
                                    hidden(
                                    textInput(inputId = "line_label_ts", 
                                              label   = "Label:",
                                              value   = "")),
                                    
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
                              h4("Custom statistics", style = "color: #094030;",timeseries_statistics_popover("pop_anomalies_timestats")),
                              
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
                                  
                                  #radioButtons(inputId   = "year_position_ts",
                                  #             label     = "Position for each year:"  ,
                                   #            choices   = c("before", "on", "after"),
                                    #           selected  = "on",
                                     #          inline    = TRUE)
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
                      #### Downloads TS ----
                       h4("Downloads", style = "color: #094030;",downloads_popover("pop_anomalies_ts_downloads")),
                       checkboxInput(inputId = "download_options_ts",
                                     label   = "Enable download options",
                                     value   = FALSE),
                       
                       shinyjs::hidden(div(id = "hidden_download_ts",
                      # Download TS
                         h4(helpText("Timeseries")),
                         fluidRow(
                           column(2, radioButtons(inputId = "file_type_timeseries", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                           column(3, downloadButton(outputId = "download_timeseries", label = "Download timeseries"))
                         ),
                       
                      # Upload Meta data 
                       h4(helpText("Metadata")),
                       fluidRow(
                         column(3, downloadButton(outputId = "download_metadata_ts", label = "Download metadata")),
                         column(4, fileInput(inputId= "upload_metadata_ts", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                         column(2, actionButton(inputId = "update_metadata_ts", label = "Update upload inputs")),
                       ),
                      )),
                     
                    ### TS plot END ----       
                             ),

                    ### Other plots ----
                    tabPanel("Map data",
                             
                             #Download
                             br(), h4("Download", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_map_data", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_map_data", label = "Download map data"))
                             ),
                             
                             br(), 
                             withSpinner(ui_element = tableOutput("data1"),
                                         image = spinner_image,
                                         image.width = spinner_width,
                                         image.height = spinner_height)),
                    
                    tabPanel("Timeseries data",
                             
                             # Download
                             br(),  h4("Download", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_timeseries_data", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_timeseries_data", label = "Download timeseries data"))
                             ),
                             
                             br(), column(width = 3, 
                                         withSpinner(ui_element = dataTableOutput("data2"),
                                                     image = spinner_image,
                                                     image.width = spinner_width,
                                                     image.height = spinner_height))),                                      
                    
                    tabPanel("Download NETcdf data",
                             br(), h4("Download NETcdf with one or more variable", style = "color: #094030;", netcdf_popover("pop_anomalies_netcdf")),
                             #NETcdf download pickerInput checkboxGroupInput
                             column(3, pickerInput(inputId = "netcdf_variables", label = "Choose one or multiple variables:", choices = NULL, selected = NULL, inline = TRUE, multiple = TRUE,)),
                             column(3, downloadButton(outputId = "download_netcdf", label = "Download NETcdf"))),
                    
                    ### Feedback archive documentation (FAD) ----
                    tabPanel("ModE-RA sources", br(),
                             fluidRow(
                               column(width=5,                               
                                # Title & help pop up
                                MEsource_popover("pop_anomalies_mesource"),
  
                                 # Year entry
                                 numericInput(
                                  inputId  = "fad_year_a",
                                  label   =  "Year",
                                  value = 1422,
                                  min = 1422,
                                  max = 2008)
                                ),
                             ),

                             h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                             
                             div(id = "fad_map_a",
                             splitLayout(withSpinner(ui_element = plotOutput("fad_winter_map_a",
                                                                              brush = brushOpts(
                                                                                id = "brush_fad1a",
                                                                                resetOnNew = TRUE
                                                                              )), 
                                                     image = spinner_image,
                                                     image.width = spinner_width,
                                                     image.height = spinner_height),

                                         plotOutput("fad_zoom_winter_a")
                                         )),
                             
                             div(id = "fad_map_b",
                             splitLayout(withSpinner(ui_element = plotOutput("fad_summer_map_a",
                                                                             brush = brushOpts(
                                                                               id = "brush_fad1b",
                                                                               resetOnNew = TRUE
                                                                             )), 
                                                     image = spinner_image,
                                                     image.width = spinner_width,
                                                     image.height = spinner_height),
                               
                                         plotOutput("fad_zoom_summer_a")
                                         )),
                             
                             #Download
                             h4("Download maps", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_modera_source_a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_fad_wa", label = "Download Oct. - Mar.")),
                               column(2, radioButtons(inputId = "file_type_modera_source_b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_fad_sa", label = "Download Apr. - Sep."))
                             ),
                             
                             h4("Download data", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_data_modera_source_a", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_data_fad_wa", label = "Download Oct. - Mar.")),
                               column(2, radioButtons(inputId = "file_type_data_modera_source_b", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_data_fad_sa", label = "Download Apr. - Sep."))
                             ),
                    ),
                ## Main Panel END ----
                ), width = 8),
# Average & anomaly END ----  
        )),

# Composites START----      
  tabPanel("Composites", value = "tab2",
        shinyjs::useShinyjs(),
        sidebarLayout(
                 ## Sidebar Panels START ----
                 sidebarPanel(verticalLayout(
                   
                    ### First Sidebar panel (Variable and dataset selection) ----
                    sidebarPanel(fluidRow(
                      #Method Title and Pop Over
                      composites_summary_popover("pop_composites"),
                      
                      br(),
                     
                     #Short description of the Panel Composites        
                     h4("Select dataset and variable for composite anomalies", style = "color: #094030;",dataset_variable_popover("pop_composites_datvar")),
                     
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
                     
                    ), width = 12), br(),
                    
                    ### Second Sidebar panel (Time selection) ----
                    sidebarPanel(fluidRow(
                      
                      #Short description of the temporal selection        
                      h4("Select years, season and reference period", style = "color: #094030;", year_season_ref_popover("pop_composites_time")),
                     
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
                                  label    = "Select type of reference period:",
                                  choices  = c("Fixed reference","Custom reference", "X years prior"),
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
                     
                     ), width = 12), br(),
                   
                    ### Third sidebar panel (Location selection) ----
                     sidebarPanel(fluidRow(
                     
                     #Short description of the Coord. Sidebar        
                     h4("Set geographical area", style = "color: #094030;"),
                     h5(helpText("Select a continent, enter coordinates manually or draw a box on the plot")),
                     
                     column(width = 12, fluidRow(
                       
                       br(), br(),
                       
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
                       
                       br(), br(),
                       
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
                     column(12,
                     actionButton(inputId = "button_coord2",
                                  label = "Update coordinates",
                                  width = "200px"),
                     ),
                    
                     ), width = 12)
                 ## Sidebar Panels END ----
                 )),
                 
                 ## Main Panel START ----
                 mainPanel(tabsetPanel(id = "tabset2",
                    ### Map plot START ----
                     tabPanel("Map", br(),
                              h4(textOutput("text_years2"), style = "color: #094030;"),
                              textOutput("years2"),
                     shinyjs::hidden(div(id = "custom_anomaly_years2",
                              h4(textOutput("text_custom_years2"), style = "color: #094030;"),
                              textOutput("custom_years2")
                     )),
                     
                     withSpinner(ui_element = plotOutput("map2",height = "auto", dblclick = "map_dblclick2", brush = brushOpts(id = "map_brush2",resetOnNew = TRUE)),
                                 image = spinner_image,
                                 image.width = spinner_width,
                                 image.height = spinner_height),         
                              
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,
                             
                      h4("Customize your map", style = "color: #094030;", map_customization_popover("pop_composites_cusmap")),  
 
                      checkboxInput(inputId = "custom_map2",
                                    label   = "Map customization",
                                    value   = FALSE),
                      
                      shinyjs::hidden(
                      div(id = "hidden_custom_maps2",
                            
                            radioButtons(inputId  = "axis_mode2",
                                         label    = "Axis customization:",
                                         choices  = c("Automatic","Fixed"),
                                         selected = "Automatic" , inline = TRUE),
                            
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
                                            placeholder = "Custom title"))),
                          
                          br(),
                          
                          checkboxInput(inputId = "hide_borders2",
                                        label   = "Show country borders",
                                        value   = TRUE),
                          
                        )),
                      ),
                    
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,

                             h4("Custom features", style = "color: #094030;",map_features_popover("pop_composites_mapfeat")),
                             
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

                                       h4(helpText("Add custom points",map_points_popover("pop_composites_mappoint"))),

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

                                       h4(helpText("Add custom highlights",map_highlights_popover("pop_composites_maphl"))),
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

                             h4("Custom statistics", style = "color: #094030;",map_statistics_popover("pop_composites_mapstat")),
                             
                             checkboxInput(inputId = "enable_custom_statistics2",
                                           label   = "Enable custom statistics",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_statistics2",

                                   h4(helpText("Choose custom statistic:",map_choose_statistic_popover("pop_composites_choosestat"))),
                                   
                                   radioButtons(inputId      = "custom_statistic2",
                                                label        = NULL,
                                                inline       = TRUE,
                                                choices      = c("None","SD ratio","% sign match")),
                                   
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
                                                    max    = 1,
                                                    step = 0.1)
                                   ),
                                   
                               )),
                      ),
                      #### Customization panels END ----
                      ),
                      
                     #### Downloads ----
                     h4("Downloads", style = "color: #094030;",downloads_popover("pop_composites_map_downloads")),
                     checkboxInput(inputId = "download_options2",
                                   label   = "Enable download options",
                                   value   = FALSE),
                     
                     shinyjs::hidden(div(id = "hidden_download2",
                      # Download map
                       h4(helpText("Map")),
                       fluidRow(
                         column(2, radioButtons(inputId = "file_type_map2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                         column(3, downloadButton(outputId = "download_map2", label = "Download map"))
                       ),
                     
                       # Upload Meta data
                       h4(helpText("Metadata",)),
                       fluidRow(
                         column(3, downloadButton(outputId = "download_metadata2", label = "Download metadata")),
                         column(4, fileInput(inputId= "upload_metadata2", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                         column(2, actionButton(inputId = "update_metadata2", label = "Update upload inputs")),
                       ),
                     )),
                     
                     #### Abs/Ref Map plot START ----
                     h4("Reference map", style = "color: #094030;",reference_map_popover("pop_composites_refmap")), 
                     
                     radioButtons(inputId  = "ref_map_mode2",
                                  label    = NULL,
                                  choices  = c("None", "Absolute Values","Reference Values","SD Ratio"),
                                  selected = "None" , inline = TRUE),
                     
                     withSpinner(ui_element = plotOutput("ref_map2", height = "auto"),
                                 image = spinner_image,
                                 image.width = spinner_width,
                                 image.height = spinner_height),
                     
                     #### Download ref. map ----
                     shinyjs::hidden(div(id ="hidden_sec_map_download2",
                                         h4("Download reference map", style = "color: #094030;"),
                                         fluidRow(
                                           column(2, radioButtons(inputId = "file_type_map_sec2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                           column(3, downloadButton(outputId = "download_map_sec2", label = "Download reference map"))
                                         ),
                     )),
                     
                    ### Map plot END ----  
                      ),
             
                    ### Composite TS plot START ----
                   tabPanel("Timeseries", br(),
                            h4(textOutput("text_years2b"), style = "color: #094030;"),
                            textOutput("years2b"),
                            shinyjs::hidden(div(id = "custom_anomaly_years2b",
                                                h4(textOutput("text_custom_years2b"), style = "color: #094030;"),
                                                textOutput("custom_years2b")
                            )),
                            withSpinner(ui_element = plotOutput("timeseries2", click = "ts_click2", dblclick = "ts_dblclick2", brush = brushOpts(id = "ts_brush2",resetOnNew = TRUE)),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                      
                      #### Customization panels START ----       
                      fluidRow(
                        
                      #### Timeseries customization ----
                      column(width = 4,
                             h4("Customize your timeseries", style = "color: #094030;", timeseries_customization_popover("pop_composites_custime")),
                             
                             checkboxInput(inputId = "custom_ts2",
                                           label   = "Timeseries customization",
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
                             h4("Custom features", style = "color: #094030;", timeseries_features_popover("pop_composites_timefeat")),
                             
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

                                         h4(helpText("Add custom points",timeseries_points_popover("pop_composites_timepoint"))),
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

                                         h4(helpText("Add custom highlights",timeseries_highlights_popover("pop_composites_timehl"))),
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
                                                       label   = "Show on key",
                                                       value   = FALSE),
                                         
                                         hidden(
                                         textInput(inputId = "highlight_label_ts2", 
                                                   label   = "Label:",
                                                   value   = "")),
                                         
                                         
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

                                         h4(helpText("Add custom lines", timeseries_lines_popover("pop_composites_timelines"))),
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
                                                       label   = "Show on key",
                                                       value   = FALSE),
                                         
                                         hidden(
                                         textInput(inputId = "line_label_ts2", 
                                                   label   = "Label:",
                                                   value   = "")),
                                         
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
                             
                             h4("Custom statistics", style = "color: #094030;", timeseries_statistics_popover("pop_composites_timestats")),
                             
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
                      
                      #### Downloads TS ----
                      h4("Downloads", style = "color: #094030;",downloads_popover("pop_composites_ts_downloads")),
                      checkboxInput(inputId = "download_options_ts2",
                                    label   = "Enable download options",
                                    value   = FALSE),
                      
                      shinyjs::hidden(div(id = "hidden_download_ts2",
             
                      # Downloads
                         h4(helpText("Timeseries")),
                         fluidRow(
                           column(2, radioButtons(inputId = "file_type_timeseries2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                           column(3, downloadButton(outputId = "download_timeseries2", label = "Download timeseries"))
                         ),
                      
                      #Upload Meta data
                         h4(helpText("Metadata")),
                         fluidRow(
                           column(3, downloadButton(outputId = "download_metadata_ts2", label = "Download metadata")),
                           column(4, fileInput(inputId= "upload_metadata_ts2", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                           column(2, actionButton(inputId = "update_metadata_ts2", label = "Update upload inputs")),
                         ),
                      )),
                    ### Composite TS plot END ----
                    ),
                   
                    ### Other plots ----
                    tabPanel("Map data",
                             
                             #Download
                             br(), h4("Download", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_map_data2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_map_data2", label = "Download map data"))
                             ),
                             
                             br(), withSpinner(ui_element = tableOutput("data3"),
                                                           image = spinner_image,
                                                           image.width = spinner_width,
                                                           image.height = spinner_height)),
                    tabPanel("Timeseries data",
                             
                             br(),  h4("Download", style = "color: #094030;"),
                             fluidRow(
                               column(2, radioButtons(inputId = "file_type_timeseries_data2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                               column(3, downloadButton(outputId = "download_timeseries_data2", label = "Download timeseries data"))
                             ),
                             
                             br(), column(width = 3, 
                                          withSpinner(ui_element = dataTableOutput("data4"),
                                                      image = spinner_image,
                                                      image.width = spinner_width,
                                                      image.height = spinner_height))),
                    
                    ### Feedback archive documentation (FAD) ----
                   tabPanel("ModE-RA sources", br(),
                            fluidRow(
                              column(width=5,                               
                                     # Title & help pop up
                                     MEsource_popover("pop_composite_mesource"),
                                     
                                     # Year entry
                                     numericInput(
                                       inputId  = "fad_year_a2",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)
                              ),
                            ),

                            h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                            
                            div(id = "fad_map_a2",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_winter_map_a2",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1a2",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),

                                  plotOutput("fad_zoom_winter_a2")
                                )),
                            
                            div(id = "fad_map_b2",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_summer_map_a2",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1b2",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_summer_a2")
                                )),
                            
                            #Download
                            h4("Downloads", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_modera_source_a2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_fad_wa2", label = "Download Oct. - Mar.")),
                              column(2, radioButtons(inputId = "file_type_modera_source_b2", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_fad_sa2", label = "Download Apr. - Sep."))
                            ),
                            
                            h4("Download data", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_data_modera_source_a2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_data_fad_wa2", label = "Download Oct. - Mar.")),
                              column(2, radioButtons(inputId = "file_type_data_modera_source_b2", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_data_fad_sa2", label = "Download Apr. - Sep."))
                            ),
                   ),
                   
                ## Main Panel END ----
                ), width = 8),
# Composites END ----           
        )),

# Correlation START ----
  tabPanel("Correlation", value = "tab3",
          shinyjs::useShinyjs(),
          sidebarLayout(
               ## Sidebar Panels START ----          
               sidebarPanel(verticalLayout(
                 
                   ### First Sidebar panel (Variable 1) ----
                   sidebarPanel(fluidRow(
                     #Method Title and Pop Over
                     correlation_summary_popover("pop_correlation"),
                     br(),
   
                    h4("Variable 1", style = "color: #094030;",correlation_variable_popover("pop_correlation_variable1")),
                   
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
                             label = "Upload timeseries data in .csv or .xlsx format:",
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
                   fluidRow(
                   selectInput(inputId  = "dataset_selected_v1",
                               label    = "Choose a dataset:",
                               choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                               selected = "ModE-RA"),

                   #Choose a variable (Mod-ERA) 
                   selectInput(inputId  = "ME_variable_v1",
                               label    = "Choose a variable to plot:",
                               choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                               selected = "Temperature")),
                   )),
                   
                   shinyjs::hidden(
                   div(id = "hidden_modera_variable_v1",
                   #Choose how to use ME data: As a timeseries or field  
                   radioButtons(inputId  = "type_v1",
                                label    = "Choose how to use ModE-RA data:",
                                choices  = c("Field", "Timeseries"),
                                selected = "Timeseries" ,
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
                     
                     br(), br(),
                     
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
                     
                     br(), br(),
                     
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
                     
                     numericRangeInput(inputId    = "range_years3",
                                       label     = "Select the range of years (1422-2008):",
                                       value     = c(1900,2008),
                                       separator = " to ",
                                       min       = 1422,
                                       max       = 2008),

                   ), width = 12),
                   
                   br(),
                   
                   ### Third Sidebar panel (Variable 2) ----
                   
                   sidebarPanel(fluidRow(
                     #Short description of the General Panel        
                     h4("Variable 2", style = "color: #094030;",correlation_variable_popover("pop_correlation_variable2")),
                     
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
                               label = "Upload timeseries data in .csv or .xlsx format:",
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
                     fluidRow(
                     selectInput(inputId  = "dataset_selected_v2",
                                 label    = "Choose a dataset:",
                                 choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                                 selected = "ModE-RA"),

                     #Choose a variable (Mod-ERA) 
                     selectInput(inputId  = "ME_variable_v2",
                                 label    = "Choose a variable to plot:",
                                 choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                                 selected = "Temperature")),
                     )),
                     
                     shinyjs::hidden(
                     div(id = "hidden_modera_variable_v2",
                     #Choose how to use ME data: As a timeseries or field  
                     radioButtons(inputId  = "type_v2",
                                  label    = "Choose how to use the ModE-RA data:",
                                  choices  = c("Field","Timeseries"),
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
                             
                             br(), br(),
                             
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
                             
                             br(), br(),
                             
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
                 
               ## Main Panel START ----
               mainPanel(tabsetPanel(id = "tabset3",
                   ### v1, v2 plot: ----
                   tabPanel("Variables", br(),
                            h4("Variable 1", style = "color: #094030;"),
                            withSpinner(ui_element = plotOutput("plot_v1", height = "auto"),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                            h4("Variable 2", style = "color: #094030;"),
                            withSpinner(ui_element = plotOutput("plot_v2", height = "auto"),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height)),
                   
                   ### Shared TS plot: START ----
                   tabPanel("Timeseries", br(),
                            
                            correlation_timeseries_popover("pop_correlation_timeseries"),
                            
                            br(),
                            
                            #Choose a correlation method
                            radioButtons(inputId  = "cor_method_ts",
                               label    = "Choose a correlation method:",
                               choices  = c("pearson", "spearman"),
                               selected = "pearson" , inline = TRUE),
                              

                            textOutput("correlation_r_value"),
                            textOutput("correlation_p_value"),
                            withSpinner(ui_element = plotOutput("correlation_ts",click = "ts_click3", dblclick = "ts_dblclick3", brush = brushOpts(id = "ts_brush3",resetOnNew = TRUE)),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                            
                      #### Customization panels START ----       
                      fluidRow(
                        
                      #### Timeseries customization ----
                      column(width = 4,
                             h4("Customize your timeseries", style = "color: #094030;",timeseries_customization_popover("pop_correlation_custime")),  

                             checkboxInput(inputId = "custom_ts3",
                                           label   = "Timeseries customization",
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
                             h4("Custom features", style = "color: #094030;",timeseries_features_popover("pop_correlation_timefeat")),
                             
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

                                         h4(helpText("Add custom points",timeseries_points_popover("pop_correlation_timepoint"))),
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

                                         h4(helpText("Add custom highlights",timeseries_highlights_popover("pop_correlation_timehl"))),
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
                                                       label   = "Show on key",
                                                       value   = FALSE),
                                         
                                         hidden(
                                         textInput(inputId = "highlight_label_ts3", 
                                                   label   = "Label:",
                                                   value   = "")),
                                         
                                         
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

                                         h4(helpText("Add custom lines",timeseries_lines_popover("pop_correlation_timelines"))),
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
                                                       label   = "Show on key",
                                                       value   = FALSE),
                                         
                                         hidden(
                                         textInput(inputId = "line_label_ts3", 
                                                   label   = "Label:",
                                                   value   = "")),
                                         
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

                             h4("Custom statistics", style = "color: #094030;", timeseries_statistics_popover("pop_correlation_timestats")),
                             
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
                                         
                                         #radioButtons(inputId   = "year_position_ts3",
                                          #            label     = "Position for each year:"  ,
                                           #           choices   = c("before", "on", "after"),
                                            #          selected  = "on",
                                             #         inline    = TRUE)
                                     )),
                                   
                               )),
                      ),
                      
                      #### Customization panels END ----
                      ),
                      
                      #### Downloads TS ----
                      h4("Downloads", style = "color: #094030;",downloads_popover("pop_correlation_ts_downloads")),
                      checkboxInput(inputId = "download_options_ts3",
                                    label   = "Enable download options",
                                    value   = FALSE),
                      
                      shinyjs::hidden(div(id = "hidden_download_ts3",
                    
                      # Downloads 
                        h4(helpText("Timeseries")),
                        fluidRow(
                          column(2, radioButtons(inputId = "file_type_timeseries3", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                          column(3, downloadButton(outputId = "download_timeseries3", label = "Download timeseries"))
                        ),
                    
                      # Upload Meta data 
                        h4(helpText("Metadata")),
                        fluidRow(
                          column(3, downloadButton(outputId = "download_metadata_ts3", label = "Download metadata")),
                          column(4, fileInput(inputId= "upload_metadata_ts3", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                          column(2, actionButton(inputId = "update_metadata_ts3", label = "Update upload inputs")),
                        ),
                      )),
                    
                   ### Shared TS plot: End ----          
                  ),
                   
                   ### Map plot: START ----
                   tabPanel("Correlation map", value = "corr_map_tab", br(),
                            
                            correlation_map_popover("pop_correlation_map"),
                            
                            br(),
                            
                            #Choose a correlation method 
                            radioButtons(inputId  = "cor_method_map",
                                         label    = "Choose a correlation method:",
                                         choices  = c("pearson", "spearman"),
                                         selected = "pearson" , inline = TRUE),
                            withSpinner(ui_element = plotOutput("correlation_map", height = "auto", dblclick = "map_dblclick3", brush = brushOpts(id = "map_brush3",resetOnNew = TRUE)),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                      #### Customization panels START ----       
                      fluidRow(
                      #### Map customization ----       
                      column(width = 4,

                             h4("Customize your map", style = "color: #094030;",map_customization_popover("pop_correlation_cusmap")),  
                             
                             checkboxInput(inputId = "custom_map3",
                                           label   = "Map customization",
                                           value   = FALSE),
                             
                             shinyjs::hidden(
                               div(id = "hidden_custom_maps3",
                                   
                                   radioButtons(inputId  = "axis_mode3",
                                                label    = "Axis customization:",
                                                choices  = c("Automatic","Fixed"),
                                                selected = "Automatic" , inline = TRUE),
                                   
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
                                                   placeholder = "Custom title"))),
                                   
                                   br(),
                                   
                                   checkboxInput(inputId = "hide_borders3",
                                                 label   = "Show country borders",
                                                 value   = TRUE),
                                   
                               )),
                      ),
                      
                      #### Add Custom features (points and highlights) ----                        
                      column(width = 4,

                             h4("Custom features", style = "color: #094030;",map_features_popover("pop_correlation_mapfeat")),
                             
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

                                         h4(helpText("Add custom points",map_points_popover("pop_correlation_mappoint"))),
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

                                         h4(helpText("Add custom highlights",map_highlights_popover("pop_correlation_maphl"))),
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
                             #h4("Custom statistics", style = "color: #094030;"),
                             
                             #checkboxInput(inputId = "enable_custom_statistics3",
                            #               label   = "Enable custom statistics",
                            #               value   = FALSE),
                            # 
                             #shinyjs::hidden(
                              # div(id = "hidden_custom_statistics3",
                               #    h4(helpText("Choose custom statistic:")),
                                   
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
                    
                      #### Downloads ----
                      h4("Downloads", style = "color: #094030;",downloads_popover("pop_correlation_map_downloads")),
                      checkboxInput(inputId = "download_options3",
                                    label   = "Enable download options",
                                    value   = FALSE),
                      
                      shinyjs::hidden(div(id = "hidden_download3",
                    
                      # Download map
                        h4(helpText("Map")),
                        fluidRow(
                          column(2, radioButtons(inputId = "file_type_map3", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                          column(3, downloadButton(outputId = "download_map3", label = "Download map"))
                        ),
                    
                      # Upload Meta data 
                        h4(helpText("Metadata")),
                        fluidRow(
                          column(3, downloadButton(outputId = "download_metadata3", label = "Download metadata")),
                          column(4, fileInput(inputId= "upload_metadata3", label = NULL, buttonLabel = "Upload metadata", width = "300px", accept = ".xlsx")),
                          column(2, actionButton(inputId = "update_metadata3", label = "Update upload inputs")),
                        ),
                      )),
                    
                   ### Map plot: END ----        
                            ),
                   
                   ### Other plots ----
                   tabPanel("Timeseries data", 
                            
                            #Download
                            br(),  h4("Download", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_timeseries_data3", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_timeseries_data3", label = "Download timeseries data"))
                            ),
                            
                            br(), column(width = 3, 
                                         withSpinner(ui_element = dataTableOutput("correlation_ts_data"),
                                                     image = spinner_image,
                                                     image.width = spinner_width,
                                                     image.height = spinner_height))),
                   tabPanel("Correlation map data", value = "corr_map_data_tab",
                            
                            #Download
                            br(), h4("Download", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_map_data3", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_map_data3", label = "Download map data"))
                            ),
                            
                            br(), withSpinner(ui_element = tableOutput("correlation_map_data"),
                                                          image = spinner_image,
                                                          image.width = spinner_width,
                                                          image.height = spinner_height)),
             
                   ### Feedback archive documentation (FAD) ----
                   tabPanel("ModE-RA sources", br(),
                            
                            # Title & help pop up 
                            MEsource_popover("pop_correlation_mesource"),

                            shinyjs::hidden(
                            div(id = "hidden_v1_fad",
                            fluidRow(
                              h4("Variable 1", style = "color: #094030;"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a3a",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              ),
                            
                            div(id = "fad_map_a3a",
                                h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_winter_map_a3a",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1a3a",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_winter_a3a")
                                )),
                            
                            div(id = "fad_map_b3a",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_summer_map_a3a",
                                                                                brush = brushOpts(
                                                                                  id = "brush_fad1b3a",
                                                                                  resetOnNew = TRUE
                                                                                )),
                                               image = spinner_image,
                                               image.width = spinner_width,
                                               image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_summer_a3a")
                                )),

                            )),
                            
                            shinyjs::hidden(
                              div(id = "hidden_v1_fad_download",
                                  h4("Downloads", style = "color: #094030;"),
                                  fluidRow(
                                    column(2, radioButtons(inputId = "file_type_modera_source_a3a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_fad_wa3a", label = "Download Oct. - Mar.")),
                                    column(2, radioButtons(inputId = "file_type_modera_source_b3a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_fad_sa3a", label = "Download Apr. - Sep.")),
                                  ),
                                  
                                  h4("Download data", style = "color: #094030;"),
                                  fluidRow(
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_a3a", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_wa3a", label = "Download Oct. - Mar.")),
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_b3a", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_sa3a", label = "Download Apr. - Sep."))
                                  ),
                                  
                              )),
                            
                            br(),
                            shinyjs::hidden(
                            div(id = "hidden_v2_fad",
                            fluidRow(
                              h4("Variable 2", style = "color: #094030;"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a3b",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                              ),
  
                            div(id = "fad_map_a3b",
                                h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_winter_map_a3b",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1a3b",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_winter_a3b")
                                )),
                            
                            div(id = "fad_map_b3b",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_summer_map_a3b",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1b3b",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_summer_a3b")
                                )),
                            
                            shinyjs::hidden(
                              div(id = "hidden_v2_fad_download",
                                  h4("Downloads", style = "color: #094030;"),
                                  fluidRow(
                                    column(2,radioButtons(inputId = "file_type_modera_source_a3b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3,downloadButton(outputId = "download_fad_wa3b", label = "Download Oct. - Mar.")),
                                    column(2,radioButtons(inputId = "file_type_modera_source_b3b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3,downloadButton(outputId = "download_fad_sa3b", label = "Download Apr. - Sep.")),
                                  ),
                                  
                                  h4("Download data", style = "color: #094030;"),
                                  fluidRow(
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_a3b", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_wa3b", label = "Download Oct. - Mar.")),
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_b3b", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_sa3b", label = "Download Apr. - Sep."))
                                  ),
                                  
                              )),

                            )),
                   ),
             
               ## Main Panel END ----
               ), width = 8)
               
# Correlation END ----  
          )),

# Regression START ----
  tabPanel("Regression", value = "tab4",
         shinyjs::useShinyjs(),
         sidebarLayout(
           ## Sidebar Panels START ----          
           sidebarPanel(verticalLayout(
             ### First Sidebar panel (Independent variable) ----
             sidebarPanel(fluidRow(
               
               #Method Title and Pop Over
               regression_summary_popover("pop_regression"),
               
               br(),
               
               #Short description of the General Panel        
               h4("Independent variable", style = "color: #094030;",regression_variable_popover("pop_regression_independentvariable")),
               
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
                               label = "Upload timeseries data in .csv or .xlsx format:",
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
               fluidRow(
               selectInput(inputId  = "dataset_selected_iv",
                           label    = "Choose a dataset:",
                           choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                           selected = "ModE-RA"),
               
               #Choose a variable (Mod-ERA) 
               pickerInput(inputId  = "ME_variable_iv",
                           label    = "Choose one or multiple variables:",
                           choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                           selected = "Temperature",
                           multiple = TRUE)),
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
                             
                             br(), br(),
                             
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
                             
                             br(), br(),
                             
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
               numericRangeInput(inputId    = "range_years4",
                                 label     = "Select the range of years (1422-2008):",
                                 value     = c(1900,2000),
                                 separator = " to ",
                                 min       = 1422,
                                 max       = 2008),

             ), width = 12),
             
             br(),
             
             ### Third Sidebar panel (Dependent variable) ----
             
             sidebarPanel(fluidRow(
               #Short description of the General Panel        
               h4("Dependent variable", style = "color: #094030;",regression_variable_popover("pop_regression_dependentvariable")),

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
                               label = "Upload timeseries data in .csv or .xlsx format:",
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
                 fluidRow(
                 selectInput(inputId  = "dataset_selected_dv",
                             label    = "Choose a dataset:",
                             choices  = c("ModE-RA", "ModE-Sim","ModE-RAclim"),
                             selected = "ModE-RA"),
                 
                 #Choose a variable (Mod-ERA) 
                 selectInput(inputId  = "ME_variable_dv",
                             label    = "Choose a variable to plot:",
                             choices  = c("Temperature", "Precipitation", "SLP", "Z500"),
                             selected = "Temperature")),
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
                             
                             br(), br(),
                             
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
                             
                             br(), br(),
                             
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
           ## Main Panel START ----
           mainPanel(tabsetPanel(id = "tabset4",
             ### Independent / dependent variable ----
             tabPanel("Variables", br(),
                      h4("Independent variable", style = "color: #094030;"),
                      withSpinner(ui_element = plotOutput("plot_iv", height = "auto"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      h4("Dependent variable", style = "color: #094030;"),
                      withSpinner(ui_element = plotOutput("plot_dv", height = "auto"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
             ),
             
             ### Regression timeseries and summary----
             tabPanel("Regression timeseries",
                      br(),
                      regression_timeseries_popover("pop_regression_timeseries"),
                      
                      withSpinner(ui_element = plotOutput("plot_reg_ts1"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      withSpinner(ui_element = plotOutput("plot_reg_ts2"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      br(),
                      div(id = "reg1",
                          fluidRow(
                            h4("Downloads", style = "color: #094030;"), 
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
                                   h4("Statistical summary", style = "color: #094030;"),
                                   downloadButton(outputId = "download_reg_sum_txt", label = "Download ")),
                          )), br(), 
                      splitLayout(
                        column(width = 4,
                               withSpinner(ui_element = dataTableOutput("data_reg_ts"),
                                           image = spinner_image,
                                           image.width = spinner_width,
                                           image.height = spinner_height)),
                              verticalLayout(       
                              h4("Statistical summary", style = "color: #094030;"),
                              withSpinner(ui_element = verbatimTextOutput("regression_summary_data"),
                                          image = spinner_image,
                                          image.width = spinner_width,
                                          image.height = spinner_height)
                              )
                      )
             ),
             
             ### Regression coefficients ----
             tabPanel("Regression coefficients", 
                      br(),
                      regression_coefficient_popover("pop_regression_coefficients"),
                      
                      selectInput(inputId  = "coeff_variable",
                                  label    = "Choose a variable:",
                                  choices  = NULL,
                                  selected = NULL),
                      withSpinner(ui_element = plotOutput("plot_reg_coeff", height = "auto", brush = brushOpts(id = "map_brush4_coeff",resetOnNew = TRUE)),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      br(),
                      div(id = "reg2",
                          fluidRow(
                            h4("Downloads", style = "color: #094030;"),
                            column(2, radioButtons(inputId = "reg_coe_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_coe_plot", label = "Download map")), 
                            
                            column(2, radioButtons(inputId = "reg_coe_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_coe_plot_data", label = "Download data")),
                          )), br(),
                      withSpinner(ui_element = tableOutput("data_reg_coeff"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height)
             ),
             
             ### Regression pvalues ----
             tabPanel("Regression p values",
                      br(),
                      regression_pvalue_popover("pop_regression_pvalues"),
                      
                      selectInput(inputId  = "pvalue_variable",
                                  label    = "Choose a variable:",
                                  choices  = NULL,
                                  selected = NULL),
                      withSpinner(ui_element = plotOutput("plot_reg_pval", height = "auto",brush = brushOpts(id = "map_brush4_pvalue",resetOnNew = TRUE)),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      br(),
                      div(id = "reg3",
                          fluidRow(
                            h4("Downloads", style = "color: #094030;"),  
                            column(2, radioButtons(inputId = "reg_pval_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_pval_plot", label = "Download map")), 
                            
                            column(2,radioButtons(inputId = "reg_pval_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_pval_plot_data", label = "Download data")),
                          )), br(),
                      withSpinner(ui_element = tableOutput("data_reg_pval"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height)
             ),
             
             ### Regression residuals ----
             tabPanel("Regression residuals",
                      br(),
                      regression_residuals_popover("pop_regression_residuals"),
                      
                      fluidRow(
                        column(width=4,
                               numericInput(
                                 inputId  = "reg_resi_year",
                                 label   =  "Year",
                                 value = 2008,
                                 min = 1422,
                                 max = 2008)),
                      ),
                      withSpinner(ui_element = plotOutput("plot_reg_resi", height = "auto",brush = brushOpts(id = "map_brush4_resi",resetOnNew = TRUE)),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                      br(),
                      div(id = "reg4",
                          fluidRow(
                            h4("Downloads", style = "color: #094030;"),   
                            column(2, radioButtons(inputId = "reg_res_plot_type", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_res_plot", label = "Download map")), 
                            
                            column(2,radioButtons(inputId = "reg_res_plot_data_type", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                            column(3, downloadButton(outputId = "download_reg_res_plot_data", label = "Download data")),
                          )), br(),
                      withSpinner(ui_element = tableOutput("data_reg_resi"),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height)
             ),

             ### Feedback archive documentation (FAD) ----
             tabPanel("ModE-RA sources", br(),
                      # Title & help pop up
                      MEsource_popover("pop_regression_mesource"),
                      
                      shinyjs::hidden(
                        div(id = "hidden_iv_fad",
                            fluidRow(
                              h4("Independent variable", style = "color: #094030;"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a4a",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                            ),
                            
                            div(id = "fad_map_a4a",
                                h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                                splitLayout(
                                  withSpinner(ui_element =plotOutput("fad_winter_map_a4a",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1a4a",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_winter_a4a")
                                )),
                            
                            div(id = "fad_map_b4a",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_summer_map_a4a",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1b4a",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                            plotOutput("fad_zoom_summer_a4a")
                                )),
                        )),
                      
                      #Downloads
                      shinyjs::hidden(
                        div(id = "hidden_iv_fad_download",
                            h4("Downloads", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_modera_source_a4a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_fad_wa4a", label = "Download Oct. - Mar.")),
                              column(2, radioButtons(inputId = "file_type_modera_source_b4a", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_fad_sa4a", label = "Download Apr. - Sep.")),
                            ),
                            
                            h4("Download data", style = "color: #094030;"),
                            fluidRow(
                              column(2, radioButtons(inputId = "file_type_data_modera_source_a4a", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_data_fad_wa4a", label = "Download Oct. - Mar.")),
                              column(2, radioButtons(inputId = "file_type_data_modera_source_b4a", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                              column(3, downloadButton(outputId = "download_data_fad_sa4a", label = "Download Apr. - Sep."))
                            ),
                            
                        )),
                      
                      br(),
                      shinyjs::hidden(
                        div(id = "hidden_dv_fad",
                            fluidRow(
                              h4("Dependent variable", style = "color: #094030;"),
                              column(width=4,
                                     numericInput(
                                       inputId  = "fad_year_a4b",
                                       label   =  "Year",
                                       value = 1422,
                                       min = 1422,
                                       max = 2008)),
                            ),
                            
                            div(id = "fad_map_a4b",
                                h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_winter_map_a4b",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1a4b",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_winter_a4b")
                                )),
                            
                            div(id = "fad_map_b4b",
                                splitLayout(
                                  withSpinner(ui_element = plotOutput("fad_summer_map_a4b",
                                                                      brush = brushOpts(
                                                                        id = "brush_fad1b4b",
                                                                        resetOnNew = TRUE
                                                                      )),
                                              image = spinner_image,
                                              image.width = spinner_width,
                                              image.height = spinner_height),
                                  
                                  plotOutput("fad_zoom_summer_a4b")
                                )),
                            
                            #Downloads
                            shinyjs::hidden(
                              div(id = "hidden_dv_fad_download",
                                  h4("Downloads", style = "color: #094030;"),
                                  fluidRow(
                                    column(2,radioButtons(inputId = "file_type_modera_source_a4b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3,downloadButton(outputId = "download_fad_wa4b", label = "Download Oct. - Mar.")),
                                    column(2,radioButtons(inputId = "file_type_modera_source_b4b", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                                    column(3,downloadButton(outputId = "download_fad_sa4b", label = "Download Apr. - Sep.")),
                                  ),
                                  
                                  h4("Download data", style = "color: #094030;"),
                                  fluidRow(
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_a4b", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_wa4b", label = "Download Oct. - Mar.")),
                                    column(2, radioButtons(inputId = "file_type_data_modera_source_b4b", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                                    column(3, downloadButton(outputId = "download_data_fad_sa4b", label = "Download Apr. - Sep."))
                                  ),
                                  
                              )),

                        )),
             ),
             
           ## Main Panel END ----
           ), width = 8)

# Regression END ----
         )),

# Annual cycles START ----                             
  tabPanel("Annual Cycles", value = "tab5",
         shinyjs::useShinyjs(),
         sidebarLayout(
           
           ## Sidebar Panels START ----          
           sidebarPanel(verticalLayout(
             
             ### First Sidebar panel (Variable and time selection) ----
             sidebarPanel(fluidRow(
               
               #Method Title and Pop Over
               annualcycles_summary_popover("pop_annualcycles"),
               br(),
               
               #Short description of the General Panel        
               h4("Set annual cycle data", style = "color: #094030;",annualcycles_data_popover("pop_annualcycles_data")),
               
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
               h4("Set geographical area",annualcycles_region_popover("pop_annualcycles_region")),
               h5(helpText("Select a continent, enter coordinates manually or search for a point location", style = "color: #094030;")),
               
               shinyjs::hidden(div(id = "hidden_region_input",               
               #Short description of the Coord. Sidebar        
               
               column(width = 12, fluidRow(
                 
                 br(), br(),
                 
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
                 
                 br(), br(),
                 
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
               
               )),
               
               #Custom location
               checkboxInput(inputId = "custom_features5",
                             label   = "Switch to point location input",
                             value   = FALSE),
               
               shinyjs::hidden(div(id = "hidden_custom_points5",
                   h6(helpText("Enter location/coordinates")),
                   
                   textInput(inputId = "location5", 
                             label   = "Enter a point location:",
                             value   = NULL,
                             placeholder = "e.g. Bern"),
                   
                   actionButton(inputId = "search5",
                                label   = "Search"),
                   
                   shinyjs::hidden(div(id = "inv_location5",
                                       h6(helpText("Invalid location"))
                   )),
                   
                   column(width = 12, offset = 0,
                          column(width = 6,
                                 textInput(inputId = "point_location_x5", 
                                           label   = "Point longitude:",
                                           value   = "")
                          ),
                          column(width = 6,
                                 textInput(inputId = "point_location_y5", 
                                           label   = "Point latitude:",
                                           value   = "")
                          )),
                   
                   br(), br(),
                   
               )),
               
               
               column(width = 12, fluidRow(
                 
               br(), br(),
               
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
           mainPanel(tabsetPanel(id = "tabset5",
             
             ### TS plot START ----
             tabPanel("Timeseries", 
                      withSpinner(ui_element = plotOutput("timeseries5", click = "ts_click5",dblclick = "ts_dblclick5",brush = brushOpts(id = "ts_brush5",resetOnNew = TRUE)),
                                  image = spinner_image,
                                  image.width = spinner_width,
                                  image.height = spinner_height),
                     
                        #### Customization panels START ----       
                        fluidRow(
                        #### Timeseries customization ----
                        column(width = 4,
                               h4("Customize your timeseries", style = "color: #094030;",timeseries_customization_popover("pop_annualcycles_custime")),  
                               
                               checkboxInput(inputId = "custom_ts5",
                                             label   = "Timeseries customization",
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
                               h4("Custom features", style = "color: #094030;",timeseries_features_popover("pop_annualcycles_timefeat")),

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
                                           h4(helpText("Add custom points",timeseries_points_popover("pop_annualcycles_timepoint"))),
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
                                           h4(helpText("Add custom highlights",timeseries_highlights_popover("pop_annualcycles_timehl"))),
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
                                                         label   = "Show on key",
                                                         value   = FALSE),
                                           
                                           hidden(
                                           textInput(inputId = "highlight_label_ts5", 
                                                     label   = "Label:",
                                                     value   = "")),
                                           
                                           
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
                                           h4(helpText("Add custom lines",timeseries_lines_popover("pop_annualcycles_timelines"))),
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
                                                         label   = "Show on key",
                                                         value   = FALSE),
                                           
                                           hidden(
                                           textInput(inputId = "line_label_ts5", 
                                                     label   = "Label:",
                                                     value   = "")),
                                           
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
                               # h4("Custom statistics", style = "color: #094030;"),
                               
                               #checkboxInput(inputId = "enable_custom_statistics_ts",
                               #             label   = "Enable custom statistics",
                               #            value   = FALSE),
                               
                        ),
                        
                        #### Customization panels END ----
                      ),
                      
                        #### Downloads ----
                        h4("Download", style = "color: #094030;"),
                        fluidRow(
                          column(2, radioButtons(inputId = "file_type_timeseries5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                          column(3, downloadButton(outputId = "download_timeseries5", label = "Download timeseries"))
                        ),
                      
             ### TS plot END ----       
             ),
             
             ### TS data ----
             tabPanel("Timeseries data", br(),
                      
                      h4("Download", style = "color: #094030;"),
                      fluidRow(
                        column(2, radioButtons(inputId = "file_type_timeseries_data5", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                        column(3, downloadButton(outputId = "download_timeseries_data5", label = "Download timeseries data"))
                      ),
                      br(),
                      
                      column(width = 3, dataTableOutput("data5"))),
             
             ### Feedback archive documentation (FAD) ----
             tabPanel("ModE-RA sources", br(),
                      fluidRow(
                        
                        # Year 1
                        column(width=4,
                               # Title & help pop up
                               MEsource_popover("pop_anncyc_mesource"),
                               
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
                      

                      
                      h4("Draw a box on the left map to use zoom function", style = "color: #094030;"),
                      
                      div(id = "fad_map_a5",
                          splitLayout(
                            withSpinner(ui_element = plotOutput("fad_winter_map_a5",
                                                                brush = brushOpts(
                                                                  id = "brush_fad1a5",
                                                                  resetOnNew = TRUE
                                                                )),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                            
                            plotOutput("fad_zoom_winter_a5")
                          )),
                      
                      div(id = "fad_map_b5",
                          splitLayout(
                            withSpinner(ui_element = plotOutput("fad_summer_map_a5",
                                                                brush = brushOpts(
                                                                  id = "brush_fad1b5",
                                                                  resetOnNew = TRUE
                                                                )),
                                        image = spinner_image,
                                        image.width = spinner_width,
                                        image.height = spinner_height),
                            
                                      plotOutput("fad_zoom_summer_a5")
                          )),
                      
                      h4("Downloads", style = "color: #094030;"),
                      
                      fluidRow(
                        column(2, radioButtons(inputId = "file_type_modera_source_a5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                        column(3, downloadButton(outputId = "download_fad_wa5", label = "Download Oct. - Mar.")),
                        column(2, radioButtons(inputId = "file_type_modera_source_b5", label = "Choose file type:", choices = c("png", "jpeg", "pdf"), selected = "png", inline = TRUE)),
                        column(3, downloadButton(outputId = "download_fad_sa5", label = "Download Apr. - Sep.")),
                      ),
                      
                      h4("Download data", style = "color: #094030;"),
                      fluidRow(
                        column(2, radioButtons(inputId = "file_type_data_modera_source_a5", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                        column(3, downloadButton(outputId = "download_data_fad_wa5", label = "Download Oct. - Mar.")),
                        column(2, radioButtons(inputId = "file_type_data_modera_source_b5", label = "Choose file type:", choices = c("csv", "xlsx"), selected = "csv", inline = TRUE)),
                        column(3, downloadButton(outputId = "download_data_fad_sa5", label = "Download Apr. - Sep."))
                      ),
             ),

             ## Main Panel END ----
           ), width = 8),
# Annual cycles END ---- 
         )),

# END ----
)


     
# Define server logic ----
server <- function(input, output, session) {
  
  # ClimeApp Desktop Download ----
  output$climeapp_desktop_download <- downloadHandler(
    filename = function() {"ClimeApp Desktop Installer.zip"},
    content = function(file) {
      file.copy("ClimeApp Desktop Installer.zip",file)
    }
  )
  
  # Set up custom data and SDratio reactive variables ----
  custom_data = reactiveVal()
  custom_data_ID = reactiveVal(c(NA,NA,NA,NA)) # data_ID for current custom data
  
  custom_data2 = reactiveVal()                 # custom data 2 is only used for variable 2 in correlation
  custom_data_ID2 = reactiveVal(c(NA,NA,NA,NA)) 
  
  SDratio_data = reactiveVal()
  SDratio_data_ID = reactiveVal(c(NA,NA,NA,NA)) # data_ID for current SD data
  
  #Preparations in the Server (Hidden options) ----
  track_usage(storage_mode = store_json(path = "logs/"))
  
  #Easter Eggs
  
  # Get the current month and day
  current_month_day <- format(Sys.Date(), "%m-%d")
  
  # Default logo
  logo_src <- 'pics/Logo_ClimeApp_Weiss_Font1.png'
  logo_id <- "ClimeApp"
  logo_height <- "75px"
  logo_width <- "110px"
  logo_style <- "margin-right: 5px; display: inline"
  
  # Check for special occasions
  if (current_month_day >= "01-01" && current_month_day <= "01-03") {
    # New Year Egg
    logo_src <- 'pics/Clim-year.png'
    logo_id <- "Clim-year"
    logo_width <- "142px"
  } else if ((current_month_day >= "03-22" && current_month_day <= "04-09") ||
             (current_month_day >= "04-11" && current_month_day <= "04-25")) {
    # Easter Egg
    logo_src <- 'pics/Clim-ster.png'
    logo_id <- "Clim-ster"
    logo_width <- "142px"
  } else if (current_month_day >= "04-10" && current_month_day <= "04-10") {
    # International Volcano Day Egg
    logo_src <- 'pics/Clim-vol.png'
    logo_id <- "Clim-vol"
    logo_width <- "142px"
  } else if (current_month_day >= "05-02" && current_month_day <= "05-02") {
    # Harry Potter Egg
    logo_src <- 'pics/Clim-bledore.png'
    logo_id <- "Clim-bledore"
    logo_width <- "142px"
  } else if (current_month_day >= "05-04" && current_month_day <= "05-04") {
    # May the Fourth Egg
    logo_src <- 'pics/Clim-wars.png'
    logo_id <- "Clim-wars"
    logo_width <- "142px"
  } else if (current_month_day >= "05-15" && current_month_day <= "05-15") {
    # World Climate Day Egg
    logo_src <- 'pics/Clim-day.png'
    logo_id <- "Clim-day"
    logo_width <- "142px"
  } else if (current_month_day >= "09-22" && current_month_day <= "09-22") {
    # Lord of The Rings Day Egg
    logo_src <- 'pics/Clim-lord.png'
    logo_id <- "Clim-lord"
    logo_width <- "142px"
  } else if (current_month_day >= "10-15" && current_month_day <= "11-02") {
    # Halloween Egg
    logo_src <- 'pics/Clim-ween.png'
    logo_id <- "Clim-ween"
    logo_width <- "142px"
  } else if (current_month_day >= "12-01" && current_month_day <= "12-31") {
    # Christmas Egg
    logo_src <- 'pics/Clim-mas.png'
    logo_id <- "Clim-mas"
    logo_width <- "142px"
  }
  
  
  # Render the logo
  output$logo_output <- renderUI({
    img(src = logo_src, id = logo_id, height = logo_height, width = logo_width, style = logo_style)
  })
  
  # Logo 2
  logo2_src <- 'pics/Font_ClimeApp_Vers2_weiss.png'
  logo2_id <- "ClimeAppText"
  logo2_height <- "75px"
  logo2_width <- "98px"
  logo2_style <- "margin-right: 5px; display: inline; margin-left: -10px; display: inline"
  
  output$logo_output2 <- renderUI({
    if (logo_id != "ClimeApp") {
      img(src = logo2_src, id = logo2_id, height = logo2_height, width = logo2_width, style = logo2_style)
    }
  })
  
  output$vices <- renderUI({
    if (input$location == "VICES") {
      img(src = 'pics/no_image.jpg', id = "img_vices", height = "450", width = "600", style = "display: block; margin: 0 auto;")
    } else {
      NULL
    }
  })
  
  output$dev_team <- renderUI({
    if (input$title1_input == "ClimeApp") {
      img(src = 'pics/zero_image.jpg', id = "img_dev_team", height = "450", width = "600", style = "display: block; margin: 0 auto;")
    } else {
      NULL
    }
  })
  
  output$ruebli <- renderUI({
    if (input$title2_input == "Rüebli") {
      img(src = 'pics/zero_ruebli.jpg', id = "img_miau", height = "600", width = "338", style = "display: block; margin: 0 auto;")
    } else {
      NULL
    }
  })
  
  # Add logic to toggle the visibility of the specific tabPanel (Correlation Map) based on radio button values ("Timeseries")
  observe({
    if (input$type_v1 == "Timeseries" && input$type_v2 == "Timeseries") {
      shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_tab\']").parent();

      // Hide the tabPanel
      tabPanelToHide.hide();
    ')
      shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_data_tab\']").parent();

      // Hide the tabPanel
      tabPanelToHide.hide();
    ')
      
    } else if (input$type_v1 == "Field" && input$type_v2 == "Field") {
      # Get the range values
      range_lon_v1 <- input$range_longitude_v1
      range_lat_v1 <- input$range_latitude_v1
      range_lon_v2 <- input$range_longitude_v2
      range_lat_v2 <- input$range_latitude_v2
      
      # Check for overlap
      overlap_lon <- !(range_lon_v1[2] < range_lon_v2[1] || range_lon_v1[1] > range_lon_v2[2])
      overlap_lat <- !(range_lat_v1[2] < range_lat_v2[1] || range_lat_v1[1] > range_lat_v2[2])
      
      # Return the result
      if (overlap_lon && overlap_lat) {
        shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_tab\']").parent();

      // Show the tabPanel
      tabPanelToHide.show();
    ')
        shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_data_tab\']").parent();

      // Show the tabPanel
      tabPanelToHide.show();
    ')
        
      } else {
        shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_tab\']").parent();

      // Hide the tabPanel
      tabPanelToHide.hide();
    ')
        
        shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToHide = $("#tabset3 a[data-value=\'corr_map_data_tab\']").parent();

      // Hide the tabPanel
      tabPanelToHide.hide();
    ')
      }
    } else if ((input$type_v1 == "Field" && input$type_v2 == "Timeseries") || (input$type_v1 == "Timeseries" && input$type_v2 == "Field")) {
      shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToShow = $("#tabset3 a[data-value=\'corr_map_tab\']").parent();

      // Show the tabPanel
      tabPanelToShow.show();
    ')
      shinyjs::runjs('
      // Get the tabPanel element by ID
      var tabPanelToShow = $("#tabset3 a[data-value=\'corr_map_data_tab\']").parent();

      // Show the tabPanel
      tabPanelToShow.show();
    ')
    }
  })
  
  #Hiding, showing, enabling/disenabling certain inputs
    #Sidebars General and Composite
    
    observe({shinyjs::toggle(id = "optional2a",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Fixed reference",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2b",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "X years prior",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2c",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2 == "Manual",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2d",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2 == "Upload",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2e",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$upload_file2),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected2 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2f",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2g",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2a == "Manual",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2h",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enter_upload2a == "Upload",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional2i",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$upload_file2a),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_sec_map_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_map_mode != "None",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_sec_map_download2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_map_mode2 != "None",
                    asis = FALSE)})
   
    #Customization
    ##General Maps
    
    observe({shinyjs::toggle(id = "hidden_custom_maps",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_axis",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode == "Fixed",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_statistics",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_SD_ratio",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic == "SD ratio",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options == TRUE,
                    asis = FALSE)})
    
    ## General TS
    
    observe({shinyjs::toggle(id = "hidden_custom_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_key_position_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_statistics_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_moving_average_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_percentile_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_percentile_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_moving_percentile_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts == TRUE,
                    asis = FALSE)})

    observe({shinyjs::toggle(id = "hidden_custom_features_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_line_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts == "Line",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options_ts == TRUE,
                    asis = FALSE)})

    ## Composites Maps
    
    observe({shinyjs::toggle(id = "hidden_custom_maps2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_axis2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode2 == "Fixed",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode2 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature2 == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature2 == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_statistics2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_sign_match2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic2 == "% sign match",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_SD_ratio2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_statistic2 == "SD ratio",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "custom_anomaly_years2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options2 == TRUE,
                    asis = FALSE)})
    
    ## Composites TS
    
    observe({shinyjs::toggle(id = "hidden_custom_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts2 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_key_position_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_statistics_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_percentile_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_percentile_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_line_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts2 == "Line",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "custom_anomaly_years2b",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected2 == "Custom reference",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options_ts2 == TRUE,
                    asis = FALSE)})
    
    ## Correlation Maps
    
    observe({shinyjs::toggle(id = "hidden_custom_maps3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_map3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_axis3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$axis_mode3 == "Fixed",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode3 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature3 == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature3 == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options3 == TRUE,
                    asis = FALSE)})
    
    ## Correlation TS
    
    observe({shinyjs::toggle(id = "hidden_custom_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts3 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_key_position_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_statistics_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$enable_custom_statistics_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_moving_average_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_average_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_line_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts3 == "Line",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_download_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$download_options_ts3 == TRUE,
                    asis = FALSE)})
    
    # Correlation
    
    ##Sidebar V1
    
    observe({shinyjs::toggle(id = "upload_forcings_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "upload_example_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_v1),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_user_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_me_dataset_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_modera_variable_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_v1 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_v1 == "Anomaly",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_continents_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_v1 == "Continents",
                    asis = FALSE)})
    
    ##Sidebar V2
    
    observe({shinyjs::toggle(id = "upload_forcings_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "upload_example_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_v2),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_user_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_me_dataset_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)})

    observe({shinyjs::toggle(id = "hidden_modera_variable_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_v2 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_v2 == "Anomaly",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_continents_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_v2 == "Continents",
                    asis = FALSE)})
    
    #Correlation (Main Panel)
    
    observe({shinyjs::toggle(id = "hidden_v1_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_v1_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v1 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_v2_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_v2_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_v2 == "ModE-",
                    asis = FALSE)})
    
    # Regression
    
    ##Sidebar IV
    
    observe({shinyjs::toggle(id = "upload_forcings_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "upload_example_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_iv),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_user_variable_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_me_variable_dataset_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_modera_variable_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_iv == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_iv == "Anomaly",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_continents_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_iv == "Continents",
                    asis = FALSE)})
    
    ##Sidebar DV
    
    observe({shinyjs::toggle(id = "upload_forcings_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "upload_example_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = is.null(input$user_file_dv),
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_user_variable_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "User Data",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_me_variable_dataset_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_modera_variable_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "season_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$season_selected_dv == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "optional_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected_dv == "Anomaly",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_continents_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$coordinates_type_dv == "Continents",
                    asis = FALSE)})
    
    ##Regression (Main Panel)
    
    observe({shinyjs::toggle(id = "hidden_iv_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_iv_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_iv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_dv_fad_download",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_dv_fad",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$source_dv == "ModE-",
                    asis = FALSE)})
    
    # Annual cycles
    
    observe({shinyjs::toggle(id = "optional5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$mode_selected5 == "Anomaly",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_ts5 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_title_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$title_mode_ts5 == "Custom",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_key_position_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_key_ts5 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_features_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features_ts5 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Point",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_highlights_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Highlight",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_line_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$feature_ts5 == "Line",
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_region_input",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features5 == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "hidden_custom_points5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$custom_features5 == TRUE,
                    asis = FALSE)})
    
    #Toggle Single Year UI (hide/show UI elements based on conditions)
    
    observe({shinyjs::toggle(id = "range_years_sg",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "range_years",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$single_year == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_sg",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_sg2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year2 == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_sg_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v1 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_v1",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v1 == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_sg_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_v2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_v2 == FALSE,
                    asis = FALSE)})

    observe({shinyjs::toggle(id = "ref_period_sg_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_iv == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_iv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_iv == FALSE,
                    asis = FALSE)})
 
    observe({shinyjs::toggle(id = "ref_period_sg_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_dv == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_dv",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year_dv == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period_sg5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year5 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "ref_period5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$ref_single_year5 == FALSE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "highlight_label_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_highlight_on_legend_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "highlight_label_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_highlight_on_legend_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "highlight_label_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_highlight_on_legend_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "highlight_label_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_highlight_on_legend_ts5 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "line_label_ts",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_line_on_legend_ts == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "line_label_ts2",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_line_on_legend_ts2 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "line_label_ts3",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_line_on_legend_ts3 == TRUE,
                    asis = FALSE)})
    
    observe({shinyjs::toggle(id = "line_label_ts5",
                    anim = TRUE,
                    animType = "slide",
                    time = 0.5,
                    selector = NULL,
                    condition = input$show_line_on_legend_ts5 == TRUE,
                    asis = FALSE)})
 
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
      if (input$axis_mode == "Automatic"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode == "Fixed" & is.null(input$axis_input)){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input",
          value = set_axis_values(map_data(), "Anomaly"))
      }
    })
    
    #Set NetCDF Variable
    observeEvent(input$variable_selected, {
      
      choices  = c("Temperature", "Precipitation", "SLP", "Z500")
      
      updatePickerInput(
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
          choices  = c("None", "Reference Values"),
          selected = "None" , inline = TRUE)
      } else if (input$dataset_selected == "ModE-Sim"){
        updateRadioButtons(
          inputId = "ref_map_mode",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Values"),
          selected = "None" , inline = TRUE)
      } else {
        updateRadioButtons(
          inputId = "ref_map_mode",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Values","SD Ratio"),
          selected = "None" , inline = TRUE)
      }
    })
    
    
    ### Interactivity ----
    
    # Input geo-coded locations
    
    observeEvent(input$search, {
      location <- input$location
      if (!is.null(location) && nchar(location) > 0) {
        location_encoded <- URLencode(location)
        result <- geocode_OSM(location_encoded)
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
    
    # timeseries Points
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
    
    # timeseries Highlights
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
    
    # timeseries Lines
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
    
    ### Generate Metadata for map customization ----
    
    #Download Plot data
    metadata_input <- reactive({
      
      metadata = generate_metadata(input$axis_mode,
                                   input$axis_input,
                                   input$hide_axis,
                                   input$title_mode,
                                   input$title1_input,
                                   input$title2_input,
                                   input$custom_statistic,
                                   input$sd_ratio,
                                   input$hide_borders)
      
      return(metadata)  
    })
    
    plot_gen_input <- reactive({
      
      plot_gen = generate_metadata_plot(input$dataset_selected,
                                        input$variable_selected,
                                        input$range_years,
                                        input$single_year,
                                        input$range_years_sg,
                                        input$season_selected,
                                        input$range_months,
                                        input$ref_period,
                                        input$ref_single_year,
                                        input$ref_period_sg,
                                        input$range_longitude,
                                        input$range_latitude,
                                        lonlat_vals())
      
      return(plot_gen)
    })
    
    output$download_metadata <- downloadHandler(
      filename = function() {"metadata.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map")
        openxlsx::addWorksheet(wb, "custom_points")
        openxlsx::addWorksheet(wb, "custom_highlights")
        openxlsx::addWorksheet(wb, "plot_gen")
        openxlsx::writeData(wb, "custom_map", metadata_input())
        openxlsx::writeData(wb, "custom_points", map_points_data())
        openxlsx::writeData(wb, "custom_highlights", map_highlights_data())
        openxlsx::writeData(wb, "plot_gen", plot_gen_input())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload plot data

    process_uploaded_file <- function() {
      metadata <- openxlsx::read.xlsx(input$upload_metadata$datapath, sheet = "custom_map")
      
      # Update inputs based on metadata sheet custom_map
      updateRadioButtons(session = getDefaultReactiveDomain(), "axis_mode", selected = metadata[1, "axis_mode"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "axis_input", value = metadata[1:2, "axis_input"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_axis", value = metadata[1, "hide_axis"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode", selected = metadata[1, "title_mode"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input", value = metadata[1, "title1_input"])
      updateTextInput(session = getDefaultReactiveDomain(), "title2_input", value = metadata[1, "title2_input"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "custom_statistic", selected = metadata[1, "custom_statistic"])
      updateNumericInput(session = getDefaultReactiveDomain(), "sd_ratio", value = metadata[1, "sd_ratio"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_borders", value = metadata[1, "hide_borders"])
      
      # Read metadata from "custom_points" sheet
      metadata_points <- openxlsx::read.xlsx(input$upload_metadata$datapath, sheet = "custom_points")
      
      # Update map points data if metadata_points is not empty
      if (!is.null(metadata_points) && nrow(metadata_points) > 0) {
        map_points_data(metadata_points)
      }
      
      # Read metadata from "custom_highlights" sheet
      metadata_highlights <- openxlsx::read.xlsx(input$upload_metadata$datapath, sheet = "custom_highlights")
      
      # Update map highlights data if metadata_highlights is not empty
      if (!is.null(metadata_highlights) && nrow(metadata_highlights) > 0) {
        map_highlights_data(metadata_highlights)
      }
      
      # Update plot generation
      plot_data <- openxlsx::read.xlsx(input$upload_metadata$datapath, sheet = "plot_gen")
      
      # Update inputs based on metadata sheet plot_gen
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected", selected = plot_data[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected", selected = plot_data[1, "variable"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_years", value = plot_data[1:2, "range_years"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "single_year", value = plot_data[1, "select_sg_year"])
      updateNumericInput(session = getDefaultReactiveDomain(), "range_years_sg", value = plot_data[1, "sg_year"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected", selected = plot_data[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months", selected = plot_data[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period", value = plot_data[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year", value = plot_data[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg", value = plot_data[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude", value = plot_data[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude", value = plot_data[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals(plot_data[1:4, "lonlat_vals"])
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata, {
      req(input$upload_metadata)
      file_path <- input$upload_metadata$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
    })
    
    #Download TS data
    metadata_input_ts <- reactive({
      
      metadata_ts = generate_metadata_ts(input$title_mode_ts,
                                         input$title1_input_ts,
                                         input$show_key_ts,
                                         input$key_position_ts,
                                         input$show_ref_ts,
                                         input$custom_average_ts,
                                         input$year_moving_ts,
                                         input$percentile_ts,
                                         input$moving_percentile_ts)
      
      return(metadata_ts)  
    })
    
    output$download_metadata_ts <- downloadHandler(
      filename = function() {"metadata_ts.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map_ts")
        openxlsx::addWorksheet(wb, "custom_points_ts")
        openxlsx::addWorksheet(wb, "custom_highlights_ts")
        openxlsx::addWorksheet(wb, "custom_lines_ts")
        openxlsx::addWorksheet(wb, "plot_gen")
        openxlsx::writeData(wb, "custom_map_ts", metadata_input_ts())
        openxlsx::writeData(wb, "custom_points_ts", ts_points_data())
        openxlsx::writeData(wb, "custom_highlights_ts", ts_highlights_data())
        openxlsx::writeData(wb, "custom_lines_ts", ts_lines_data())
        openxlsx::writeData(wb, "plot_gen", plot_gen_input())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload TS data
    process_uploaded_file_ts <- function() {
      metadata_ts <- openxlsx::read.xlsx(input$upload_metadata_ts$datapath, sheet = "custom_map_ts")
      
      # Update inputs based on metadata_ts sheet custom_map_ts
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode_ts", selected = metadata_ts[1, "title_mode_ts"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input_ts", value = metadata_ts[1, "title1_input_ts"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "show_key_ts", value = metadata_ts[1, "show_key_ts"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "key_position_ts", selected = metadata_ts[1, "key_position_ts"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "show_ref_ts", value = metadata_ts[1, "show_ref_ts"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "custom_average_ts", value = metadata_ts[1, "custom_average_ts"])
      updateNumericInput(session = getDefaultReactiveDomain(), "year_moving_ts", value = metadata_ts[1, "year_moving_ts"])
      updateCheckboxGroupInput(session = getDefaultReactiveDomain(), "percentile_ts", selected = metadata_ts[1, "percentile_ts"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "moving_percentile_ts", value = metadata_ts[1, "moving_percentile_ts"])
      
      # Read metadata from "custom_points_ts" sheet
      metadata_points_ts <- openxlsx::read.xlsx(input$upload_metadata_ts$datapath, sheet = "custom_points_ts")
      
      # Update map points data if metadata_points_ts is not empty
      if (!is.null(metadata_points_ts) && nrow(metadata_points_ts) > 0) {
        ts_points_data(metadata_points_ts)
      }
      
      # Read metadata from "custom_highlights_ts" sheet
      metadata_highlights_ts <- openxlsx::read.xlsx(input$upload_metadata_ts$datapath, sheet = "custom_highlights_ts")
      
      # Update map highlights data if metadata_highlights_ts is not empty
      if (!is.null(metadata_highlights_ts) && nrow(metadata_highlights_ts) > 0) {
        ts_highlights_data(metadata_highlights_ts)
      }
      
      # Read metadata from "custom_lines_ts" sheet
      metadata_lines_ts <- openxlsx::read.xlsx(input$upload_metadata_ts$datapath, sheet = "custom_lines_ts")
      
      # Update map lines data if metadata_lines_ts is not empty
      if (!is.null(metadata_lines_ts) && nrow(metadata_lines_ts) > 0) {
        ts_lines_data(metadata_lines_ts)
      }
      
      # Update plot generation
      plot_data <- openxlsx::read.xlsx(input$upload_metadata_ts$datapath, sheet = "plot_gen")
      
      # Update inputs based on metadata sheet plot_gen
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected", selected = plot_data[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected", selected = plot_data[1, "variable"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_years", value = plot_data[1:2, "range_years"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "single_year", value = plot_data[1, "select_sg_year"])
      updateNumericInput(session = getDefaultReactiveDomain(), "range_years_sg", value = plot_data[1, "sg_year"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected", selected = plot_data[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months", selected = plot_data[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period", value = plot_data[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year", value = plot_data[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg", value = plot_data[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude", value = plot_data[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude", value = plot_data[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals(plot_data[1:4, "lonlat_vals"])
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata_ts, {
      req(input$upload_metadata_ts)
      file_path <- input$upload_metadata_ts$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map_ts") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file_ts()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
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
      if (input$axis_mode2 == "Automatic"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input2",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode2 == "Fixed" & is.null(input$axis_input2)){
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
          choices  = c("None", "Reference Values"),
          selected = "None" , inline = TRUE)
      } else if (input$dataset_selected2 == "ModE-Sim"){
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Values"),
          selected = "None" , inline = TRUE)
      } else {
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Values", "SD Ratio"),
          selected = "None" , inline = TRUE)
      }
    })
    
    observe({
      if(input$mode_selected2 == "X years prior"){
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values", "SD Ratio"),
          selected = "None" , inline = TRUE)
      } else {
        updateRadioButtons(
          inputId = "ref_map_mode2",
          label    = NULL,
          choices  = c("None", "Absolute Values","Reference Values", "SD Ratio"),
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
        location_encoded2 <- URLencode(location2)
        result <- geocode_OSM(location_encoded2)
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
    
    # timeseries Points
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
    
    # timeseries Highlights
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
    
    # timeseries Lines
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
    
    ### Generate Metadata for map customization ----
    
    #Download Plot data 
    metadata_input2 <- reactive({
      
      metadata2 = generate_metadata_comp(input$axis_mode2,
                                         input$axis_input2,
                                         input$hide_axis2,
                                         input$title_mode2,
                                         input$title1_input2,
                                         input$title2_input2,
                                         input$custom_statistic2,
                                         input$percentage_sign_match2,
                                         input$sd_ratio2,
                                         input$hide_borders2)
      
      return(metadata2)  
    })
    
    plot_gen_input2 <- reactive({
      
      plot_gen2 = generate_metadata_plot_comp(input$dataset_selected2,
                                              input$variable_selected2,
                                              input$range_years2,
                                              input$season_selected2,
                                              input$range_months2,
                                              input$ref_period2,
                                              input$ref_single_year2,
                                              input$ref_period_sg2,
                                              input$prior_years2,
                                              input$range_years2a,
                                              input$range_longitude2,
                                              input$range_latitude2,
                                              lonlat_vals2())
      
      return(plot_gen2)
    })
    
    output$download_metadata2 <- downloadHandler(
      filename = function() {"metadata_comp.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map2")
        openxlsx::addWorksheet(wb, "custom_points2")
        openxlsx::addWorksheet(wb, "custom_highlights2")
        openxlsx::addWorksheet(wb, "plot_gen2")
        openxlsx::writeData(wb, "custom_map2", metadata_input2())
        openxlsx::writeData(wb, "custom_points2", map_points_data2())
        openxlsx::writeData(wb, "custom_highlights2", map_highlights_data2())
        openxlsx::writeData(wb, "plot_gen2", plot_gen_input2())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload plot data
    
    process_uploaded_file2 <- function() {
      metadata2 <- openxlsx::read.xlsx(input$upload_metadata2$datapath, sheet = "custom_map2")
      
      # Update inputs based on metadata2 sheet custom_map2
      updateRadioButtons(session = getDefaultReactiveDomain(), "axis_mode2", selected = metadata2[1, "axis_mode2"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "axis_input2", value = metadata2[1:2, "axis_input2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_axis2", value = metadata2[1, "hide_axis2"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode2", selected = metadata2[1, "title_mode2"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input2", value = metadata2[1, "title1_input2"])
      updateTextInput(session = getDefaultReactiveDomain(), "title2_input2", value = metadata2[1, "title2_input2"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "custom_statistic2", selected = metadata2[1, "custom_statistic2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "percentage_sign_match2", value = metadata2[1, "percentage_sign_match2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "sd_ratio2", value = metadata2[1, "sd_ratio2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_borders2", value = metadata2[1, "hide_borders2"])
      
      # Read metadata from "custom_points2" sheet
      metadata_points2 <- openxlsx::read.xlsx(input$upload_metadata2$datapath, sheet = "custom_points2")
      
      # Update map points data if metadata_points2 is not empty
      if (!is.null(metadata_points2) && nrow(metadata_points2) > 0) {
        map_points_data2(metadata_points2)
      }
      
      # Read metadata2 from "custom_highlights2" sheet
      metadata_highlights2 <- openxlsx::read.xlsx(input$upload_metadata2$datapath, sheet = "custom_highlights2")
      
      # Update map highlights data if metadata_highlights2 is not empty
      if (!is.null(metadata_highlights2) && nrow(metadata_highlights2) > 0) {
        map_highlights_data2(metadata_highlights2)
      }
      
      # Update plot generation
      plot_data2 <- openxlsx::read.xlsx(input$upload_metadata2$datapath, sheet = "plot_gen2")
      
      # Update inputs based on metadata2 sheet plot_gen2
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected2", selected = plot_data2[1, "dataset2"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected2", selected = plot_data2[1, "variable2"])
      updateTextInput(session = getDefaultReactiveDomain(), "range_years2", value = plot_data2[1, "range_years2"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected2", selected = plot_data2[1, "season_sel2"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months2", selected = plot_data2[1:2, "range_months2"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period2", value = plot_data2[1:2, "ref_period2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year2", value = plot_data2[1, "select_sg_ref2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg2", value = plot_data2[1, "sg_ref2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "prior_years2", value = plot_data2[1, "prior_years2"])
      updateTextInput(session = getDefaultReactiveDomain(), "range_years2a", value = plot_data2[1, "range_years2a"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude2", value = plot_data2[1:2, "lon_range2"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude2", value = plot_data2[1:2, "lat_range2"])
      # Update Lon Lat Vals
      lonlat_vals2(plot_data2[1:4, "lonlat_vals2"])
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata2, {
      req(input$upload_metadata2)
      file_path <- input$upload_metadata2$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map2") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file2()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
    })
    
    #Download TS data
    metadata_input_ts2 <- reactive({
      
      metadata_ts2 = generate_metadata_ts_comp(input$title_mode_ts2,
                                               input$title1_input_ts2,
                                               input$show_key_ts2,
                                               input$key_position_ts2,
                                               input$show_ref_ts2,
                                               input$custom_percentile_ts2,
                                               input$percentile_ts2)
      
      return(metadata_ts2)  
    })
    
    output$download_metadata_ts2 <- downloadHandler(
      filename = function() {"metadata_ts2.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map_ts2")
        openxlsx::addWorksheet(wb, "custom_points_ts2")
        openxlsx::addWorksheet(wb, "custom_highlights_ts2")
        openxlsx::addWorksheet(wb, "custom_lines_ts2")
        openxlsx::addWorksheet(wb, "plot_gen2")
        openxlsx::writeData(wb, "custom_map_ts2", metadata_input_ts2())
        openxlsx::writeData(wb, "custom_points_ts2", ts_points_data2())
        openxlsx::writeData(wb, "custom_highlights_ts2", ts_highlights_data2())
        openxlsx::writeData(wb, "custom_lines_ts2", ts_lines_data2())
        openxlsx::writeData(wb, "plot_gen2", plot_gen_input2())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload TS data
    process_uploaded_file_ts2 <- function() {
      metadata_ts2 <- openxlsx::read.xlsx(input$upload_metadata_ts2$datapath, sheet = "custom_map_ts2")
      
      # Update inputs based on metadata_ts2 sheet custom_map_ts2
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode_ts2", selected = metadata_ts2[1, "title_mode_ts2"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input_ts2", value = metadata_ts2[1, "title1_input_ts2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "show_key_ts2", value = metadata_ts2[1, "show_key_ts2"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "key_position_t2", selected = metadata_ts2[1, "key_position_ts2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "show_ref_ts2", value = metadata_ts2[1, "show_ref_ts2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "custom_percentile_ts2", value = metadata_ts2[1, "custom_percentile_ts2"])
      updateCheckboxGroupInput(session = getDefaultReactiveDomain(), "percentile_ts2", selected = metadata_ts2[1, "percentile_ts2"])

      # Read metadata from "custom_points_ts2" sheet
      metadata_points_ts2 <- openxlsx::read.xlsx(input$upload_metadata_ts2$datapath, sheet = "custom_points_ts2")
      
      # Update map points data if metadata_points_ts2 is not empty
      if (!is.null(metadata_points_ts2) && nrow(metadata_points_ts2) > 0) {
        ts_points_data2(metadata_points_ts2)
      }
      
      # Read metadata from "custom_highlights_ts2" sheet
      metadata_highlights_ts2 <- openxlsx::read.xlsx(input$upload_metadata_ts2$datapath, sheet = "custom_highlights_ts2")
      
      # Update map highlights data if metadata_highlights_ts2 is not empty
      if (!is.null(metadata_highlights_ts2) && nrow(metadata_highlights_ts2) > 0) {
        ts_highlights_data2(metadata_highlights_ts2)
      }
      
      # Read metadata from "custom_lines_ts2" sheet
      metadata_lines_ts2 <- openxlsx::read.xlsx(input$upload_metadata_ts2$datapath, sheet = "custom_lines_ts2")
      
      # Update map lines data if metadata_lines_ts2 is not empty
      if (!is.null(metadata_lines_ts2) && nrow(metadata_lines_ts2) > 0) {
        ts_lines_data2(metadata_lines_ts2)
      }
      
      # Update plot generation
      plot_data2 <- openxlsx::read.xlsx(input$upload_metadata2$datapath, sheet = "plot_gen2")
      
      # Update inputs based on metadata2 sheet plot_gen2
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected2", selected = plot_data2[1, "dataset2"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected2", selected = plot_data2[1, "variable2"])
      updateTextInput(session = getDefaultReactiveDomain(), "range_years2", value = plot_data2$range_years2)
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected2", selected = plot_data2[1, "season_sel2"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months2", selected = plot_data2[1:2, "range_months2"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period2", value = plot_data2[1:2, "ref_period2"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year2", value = plot_data2[1, "select_sg_ref2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg2", value = plot_data2[1, "sg_ref2"])
      updateNumericInput(session = getDefaultReactiveDomain(), "prior_years2", value = plot_data2[1, "prior_years2"])
      updateTextInput(session = getDefaultReactiveDomain(), "range_years2a", value = plot_data2$range_years2a)
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude2", value = plot_data2[1:2, "lon_range2"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude2", value = plot_data2[1:2, "lat_range2"])
      # Update Lon Lat Vals
      lonlat_vals2(plot_data2[1:4, "lonlat_vals2"])
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata_ts2, {
      req(input$upload_metadata_ts2)
      file_path <- input$upload_metadata_ts2$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map_ts2") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file_ts2()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
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
    
    # timeseries/Field updater
    observe({
      selected_type_v1 = input$type_v1
      
      # Check if source is user data OR map area is very small
      if ((input$source_v1 == "User Data") | (((input$range_longitude_v1[2]-input$range_longitude_v1[1])<4) & ((input$range_latitude_v1[2]-input$range_latitude_v1[1]<4)))){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v1",
          label = NULL,
          choices = c("Timeseries"),
          selected =  "Timeseries")
        
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v1",
          label = NULL,
          choices  = c( "Field","Timeseries"),
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
          choices = c("Timeseries"),
          selected =  "Timeseries")
        
      } else {
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "type_v2",
          label = NULL,
          choices  = c( "Field","Timeseries"),
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
      if (input$axis_mode3 == "Automatic"){
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "axis_input3",
          value = c(NA,NA))
      }
    })
    
    observe({
      if (input$axis_mode3 == "Fixed" & is.null(input$axis_input3)){
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
        location_encoded3 <- URLencode(location3)
        result <- geocode_OSM(location_encoded3)
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
    
    # timeseries Points
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
    
    # timeseries Highlights
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
    
    # timeseries Lines
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
    
    ### Generate Metadata for map customization ----
    
    #Download Plot data 
    metadata_input3 <- reactive({
      
      metadata3 = generate_metadata_corr(input$axis_mode3,
                                         input$axis_input3,
                                         input$hide_axis3,
                                         input$title_mode3,
                                         input$title1_input3,
                                         input$hide_borders3,
                                         input$cor_method_map)
      
      return(metadata3)  
    })
    
    plot_gen_input_v1 <- reactive({
      
      plot_gen_v1 = generate_metadata_plot_corr(input$dataset_selected_v1,
                                                input$ME_variable_v1,
                                                input$type_v1,
                                                input$mode_selected_v1,
                                                input$season_selected_v1,
                                                input$range_months_v1,
                                                input$ref_period_v1,
                                                input$ref_single_year_v1,
                                                input$ref_period_sg_v1,
                                                input$range_longitude_v1,
                                                input$range_latitude_v1,
                                                lonlat_vals_v1())
      
      return(plot_gen_v1)
    })
    
    plot_gen_input_v2 <- reactive({
      
      plot_gen_v2 = generate_metadata_plot_corr(input$dataset_selected_v2,
                                                input$ME_variable_v2,
                                                input$type_v2,
                                                input$mode_selected_v2,
                                                input$season_selected_v2,
                                                input$range_months_v2,
                                                input$ref_period_v2,
                                                input$ref_single_year_v2,
                                                input$ref_period_sg_v2,
                                                input$range_longitude_v2,
                                                input$range_latitude_v2,
                                                lonlat_vals_v2())
      
      return(plot_gen_v2)
    })
    
    metadata_yr3 <- reactive({
      
      year_range3 = generate_metadata_y_range_corr(input$range_years3)
      
      return(year_range3)
    })
    
    output$download_metadata3 <- downloadHandler(
      filename = function() {"metadata_corr.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map3")
        openxlsx::addWorksheet(wb, "custom_points3")
        openxlsx::addWorksheet(wb, "custom_highlights3")
        openxlsx::addWorksheet(wb, "plot_gen_v1")
        openxlsx::addWorksheet(wb, "plot_gen_v2")
        openxlsx::addWorksheet(wb, "plot_gen_3")
        openxlsx::writeData(wb, "custom_map3", metadata_input3())
        openxlsx::writeData(wb, "custom_points3", map_points_data3())
        openxlsx::writeData(wb, "custom_highlights3", map_highlights_data3())
        openxlsx::writeData(wb, "plot_gen_v1", plot_gen_input_v1())
        openxlsx::writeData(wb, "plot_gen_v2", plot_gen_input_v2())
        openxlsx::writeData(wb, "plot_gen_3", metadata_yr3())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload plot data
    
    process_uploaded_file3 <- function() {
      metadata3 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "custom_map3")
      
      # Update inputs based on metadata3 sheet custom_map3
      updateRadioButtons(session = getDefaultReactiveDomain(), "axis_mode3", selected = metadata3[1, "axis_mode3"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "axis_input3", value = metadata3[1:2, "axis_input3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_axis3", value = metadata3[1, "hide_axis3"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode3", selected = metadata3[1, "title_mode3"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input3", value = metadata3[1, "title1_input3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_borders3", value = metadata3[1, "hide_borders3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "cor_method_map", value = metadata3[1, "cor_method_map3"])
      
      # Read metadata from "custom_points3" sheet
      metadata_points3 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "custom_points3")
      
      # Update map points data if metadata_points3 is not empty
      if (!is.null(metadata_points3) && nrow(metadata_points3) > 0) {
        map_points_data3(metadata_points3)
      }
      
      # Read metadata3 from "custom_highlights3" sheet
      metadata_highlights3 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "custom_highlights3")
      
      # Update map highlights data if metadata_highlights3 is not empty
      if (!is.null(metadata_highlights3) && nrow(metadata_highlights3) > 0) {
        map_highlights_data3(metadata_highlights3)
      }
      
      # Update plot generation
      plot_data_v1 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_v1")
      
      # Update inputs based on plot_data_v1 sheet plot_gen_v1
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected_v1", selected = plot_data_v1[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected_v1", selected = plot_data_v1[1, "variable"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "type_v1", selected = plot_data_v1[1, "type"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "mode_selected_v1", selected = plot_data_v1[1, "mode"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected_v1", selected = plot_data_v1[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months_v1", selected = plot_data_v1[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period_v1", value = plot_data_v1[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year_v1", value = plot_data_v1[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg_v1", value = plot_data_v1[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude_v1", value = plot_data_v1[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude_v1", value = plot_data_v1[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals_v1(plot_data_v1[1:4, "lonlat_vals"])
      
      # Update plot generation
      plot_data_v2 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_v2")
      
      # Update inputs based on plot_data_v1 sheet plot_gen_v2
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected_v2", selected = plot_data_v2[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected_v2", selected = plot_data_v2[1, "variable"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "type_v2", selected = plot_data_v2[1, "type"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "mode_selected_v2", selected = plot_data_v2[1, "mode"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected_v2", selected = plot_data_v2[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months_v2", selected = plot_data_v2[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period_v2", value = plot_data_v2[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year_v2", value = plot_data_v2[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg_v2", value = plot_data_v2[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude_v2", value = plot_data_v2[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude_v2", value = plot_data_v2[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals_v2(plot_data_v2[1:4, "lonlat_vals"])
      
      # Update plot generation
      plot_gen_3 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_3")
      
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_years3", value = plot_gen_3[1:2, "range_years3"])
      
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata3, {
      req(input$upload_metadata3)
      file_path <- input$upload_metadata3$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map3") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file3()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
    })
    
    #Download TS data
    metadata_input_ts3 <- reactive({
      
      metadata_ts3 = generate_metadata_ts_corr(input$title_mode_ts3,
                                               input$title1_input_ts3,
                                               input$show_key_ts3,
                                               input$key_position_ts3,
                                               input$custom_average_ts3,
                                               input$year_moving_ts3,
                                               input$cor_method_ts)
      
      return(metadata_ts3)  
    })
    
    output$download_metadata_ts3 <- downloadHandler(
      filename = function() {"metadata_ts3.xlsx"},
      content  = function(file) {
        wb <- openxlsx::createWorkbook()
        openxlsx::addWorksheet(wb, "custom_map_ts3")
        openxlsx::addWorksheet(wb, "custom_points_ts3")
        openxlsx::addWorksheet(wb, "custom_highlights_ts3")
        openxlsx::addWorksheet(wb, "custom_lines_ts3")
        openxlsx::addWorksheet(wb, "plot_gen_v1")
        openxlsx::addWorksheet(wb, "plot_gen_v2")
        openxlsx::addWorksheet(wb, "plot_gen_3")
        openxlsx::writeData(wb, "custom_map_ts3", metadata_input_ts3())
        openxlsx::writeData(wb, "custom_points_ts3", ts_points_data3())
        openxlsx::writeData(wb, "custom_highlights_ts3", ts_highlights_data3())
        openxlsx::writeData(wb, "custom_lines_ts3", ts_lines_data3())
        openxlsx::writeData(wb, "plot_gen_v1", plot_gen_input_v1())
        openxlsx::writeData(wb, "plot_gen_v2", plot_gen_input_v2())
        openxlsx::writeData(wb, "plot_gen_3", metadata_yr3())
        openxlsx::saveWorkbook(wb, file)
      }
    )
    
    #Upload TS data
    process_uploaded_file_ts3 <- function() {
      metadata_ts3 <- openxlsx::read.xlsx(input$upload_metadata_ts3$datapath, sheet = "custom_map_ts3")
      
      # Update inputs based on metadata_ts3 sheet custom_map_ts3
      updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode_ts3", selected = metadata_ts3[1, "title_mode_ts3"])
      updateTextInput(session = getDefaultReactiveDomain(), "title1_input_ts3", value = metadata_ts3[1, "title1_input_ts3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "show_key_ts3", value = metadata_ts3[1, "show_key_ts3"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "key_position_t3", selected = metadata_ts3[1, "key_position_ts3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "custom_average_ts3", value = metadata_ts3[1, "custom_percentile_ts3"])
      updateNumericInput(session = getDefaultReactiveDomain(), "year_moving_ts3", value = metadata_ts3[1, "year_moving_ts3"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "cor_method_ts", value = metadata_ts3[1, "cor_method_ts3"])
      
      # Read metadata from "custom_points_ts3" sheet
      metadata_points_ts3 <- openxlsx::read.xlsx(input$upload_metadata_ts3$datapath, sheet = "custom_points_ts3")
      
      # Update map points data if metadata_points_ts3 is not empty
      if (!is.null(metadata_points_ts3) && nrow(metadata_points_ts3) > 0) {
        ts_points_data3(metadata_points_ts3)
      }
      
      # Read metadata from "custom_highlights_ts3" sheet
      metadata_highlights_ts3 <- openxlsx::read.xlsx(input$upload_metadata_ts3$datapath, sheet = "custom_highlights_ts3")
      
      # Update map highlights data if metadata_highlights_ts3 is not empty
      if (!is.null(metadata_highlights_ts3) && nrow(metadata_highlights_ts3) > 0) {
        ts_highlights_data3(metadata_highlights_ts3)
      }
      
      # Read metadata from "custom_lines_ts3" sheet
      metadata_lines_ts3 <- openxlsx::read.xlsx(input$upload_metadata_ts3$datapath, sheet = "custom_lines_ts3")
      
      # Update map lines data if metadata_lines_ts3 is not empty
      if (!is.null(metadata_lines_ts3) && nrow(metadata_lines_ts3) > 0) {
        ts_lines_data3(metadata_lines_ts3)
      }
      
      # Update plot generation
      plot_data_v1 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_v1")
      
      # Update inputs based on plot_data_v1 sheet plot_gen_v1
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected_v1", selected = plot_data_v1[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected_v1", selected = plot_data_v1[1, "variable"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "type_v1", selected = plot_data_v1[1, "type"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "mode_selected_v1", selected = plot_data_v1[1, "mode"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected_v1", selected = plot_data_v1[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months_v1", selected = plot_data_v1[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period_v1", value = plot_data_v1[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year_v1", value = plot_data_v1[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg_v1", value = plot_data_v1[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude_v1", value = plot_data_v1[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude_v1", value = plot_data_v1[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals_v1(plot_data_v1[1:4, "lonlat_vals"])
      
      # Update plot generation
      plot_data_v2 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_v2")
      
      # Update inputs based on plot_data_v1 sheet plot_gen_v2
      updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected_v2", selected = plot_data_v2[1, "dataset"])
      updateSelectInput(session = getDefaultReactiveDomain(), "variable_selected_v2", selected = plot_data_v2[1, "variable"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "type_v2", selected = plot_data_v2[1, "type"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "mode_selected_v2", selected = plot_data_v2[1, "mode"])
      updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected_v2", selected = plot_data_v2[1, "season_sel"])
      updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months_v2", selected = plot_data_v2[1:2, "range_months"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period_v2", value = plot_data_v2[1:2, "ref_period"])
      updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year_v2", value = plot_data_v2[1, "select_sg_ref"])
      updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg_v2", value = plot_data_v2[1, "sg_ref"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude_v2", value = plot_data_v2[1:2, "lon_range"])
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude_v2", value = plot_data_v2[1:2, "lat_range"])
      # Update Lon Lat Vals
      lonlat_vals_v2(plot_data_v2[1:4, "lonlat_vals"])
      
      # Update plot generation
      plot_gen_3 <- openxlsx::read.xlsx(input$upload_metadata3$datapath, sheet = "plot_gen_3")
      
      updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_years3", value = plot_gen_3[1:2, "range_years3"])
      
    }
    
    
    # Event handler for upload button
    observeEvent(input$update_metadata_ts3, {
      req(input$upload_metadata_ts3)
      file_path <- input$upload_metadata_ts3$datapath
      
      # Read the first sheet name from the uploaded Excel file
      first_sheet_name <- tryCatch({
        available_sheets <- getSheetNames(file_path)
        available_sheets[[1]]
      }, error = function(e) {
        NULL
      })
      
      # Check if the correct first sheet name is present
      if (!is.null(first_sheet_name) && first_sheet_name == "custom_map_ts3") {
        # Correct first sheet name is present, proceed with processing the file
        process_uploaded_file_ts3()
      } else {
        # Incorrect or missing first sheet name, show an error message
        showModal(modalDialog(
          title = "Error",
          easyClose = TRUE,
          size = "s",
          "Please upload the correct Metadata!"
        ))
      }
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
    
    
  ## ANNUAL CYCLES observe, update & interactive controls----
    ### Initialise and update timeseries dataframe ----
    
    # Add in initial data
    monthly_ts_data = reactiveVal(monthly_ts_starter_data())
    # Set tracker to 1 (if tracker is 1, the first line, aka the starter data, gets replaced)
    monthly_ts_tracker = reactiveVal(1)
    
    # Add new data and update related inputs
    observeEvent(input$add_monthly_ts, {
      
      # Generate data ID
      monthly_ts_data_ID = generate_data_ID(input$dataset_selected5,input$variable_selected5,c(NA,NA))
      
      # Update custom_data if required
      if (!identical(custom_data_ID()[2:3],monthly_ts_data_ID[2:3])){ # ....i.e. changed variable or dataset
        custom_data(load_ModE_data(input$dataset_selected5,input$variable_selected5)) # load new custom data
        custom_data_ID(monthly_ts_data_ID) # update custom data ID
      }

      # Replace starter data if tracker = 1
      if (monthly_ts_tracker() == 1){
        monthly_ts_data(create_monthly_TS_data(custom_data(),input$dataset_selected5,input$variable_selected5,
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
        new_rows = create_monthly_TS_data(custom_data(),input$dataset_selected5,input$variable_selected5,
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
    
    #Update Coordinates if Location is selected
    
    # Input geo-coded locations
    observeEvent(input$search5, {
      location5 <- input$location5
      if (!is.null(location5) && nchar(location5) > 0) {
        location_encoded5 <- URLencode(location5)
        result <- geocode_OSM(location_encoded5)
        if (!is.null(result$coords)) {
          longitude5 <- result$coords[1]
          latitude5 <- result$coords[2]
          updateTextInput(session, "point_location_x5", value = as.character(longitude5))
          updateTextInput(session, "point_location_y5", value = as.character(latitude5))
          shinyjs::hide(id = "inv_location5")  # Hide the "Invalid location" message
        } else {
          shinyjs::show(id = "inv_location5")  # Show the "Invalid location" message
        }
      } else {
        shinyjs::hide(id = "inv_location5")  # Hide the "Invalid location" message when no input
      }
    })
    
    # Transfer single lat/lon over to lat/lon range inputs
    observe({
      if(input$custom_features5){
        
        single_x = as.numeric(input$point_location_x5)
        single_y = as.numeric(input$point_location_y5)
        
        if(!is.na(single_x)){
          updateNumericRangeInput(inputId = "range_longitude5",
                        session = getDefaultReactiveDomain(),
                        label = NULL,
                        value = c(single_x, single_x))
        }
        
        if(!is.na(single_y)){
          updateNumericRangeInput(inputId = "range_latitude5",
                                  session = getDefaultReactiveDomain(),
                                  label = NULL,
                                  value = c(single_y, single_y))
        }
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
    
    # timeseries Points
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
    
    # timeseries Highlights
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
    
    # timeseries Lines
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
    
    #Generating data ID - c(pre-processed data?,dataset,variable,season)
    data_id <- reactive({
      
      dat_id = generate_data_ID(input$dataset_selected,input$variable_selected, month_range())
      
      return(dat_id)
    })
    
    # Update custom_data if required
    observeEvent(data_id(),{
      if (data_id()[1] == 0){ # Only updates when new custom data is required...
        if (!identical(custom_data_ID()[2:3],data_id()[2:3])){ # ....i.e. changed variable or dataset
          custom_data(load_ModE_data(input$dataset_selected,input$variable_selected)) # load new custom data
          custom_data_ID(data_id()) # update custom data ID
        }
      }
    })
    
    # Update SD ratio data when required
    observe({
      if((input$ref_map_mode == "SD Ratio")|(input$custom_statistic == "SD ratio")){
        if (input$nav1 == "tab1"){ # check current tab
          if (!identical(SDratio_data_ID()[3],data_id()[3])){ # check to see if currently loaded variable is the same
            SDratio_data(load_ModE_data("SD Ratio",input$variable_selected)) # load new SD data
            SDratio_data_ID(data_id()) # update custom data ID
          } 
        }
      }
    })
    
    # Processed SD data
    SDratio_subset = reactive({
      
      req(((input$ref_map_mode == "SD Ratio")|(input$custom_statistic == "SD ratio")))
      
      new_SD_data = create_sdratio_data(SDratio_data(),"general",input$variable_selected,subset_lons(),subset_lats(),
                                        month_range(),input$range_years)
      return(new_SD_data)
    })
    
    #Geographic Subset
    data_output1 <- reactive({
      
      #Geographic Subset Function
      processed_data  <- create_latlon_subset(custom_data(), data_id(), subset_lons(), subset_lats())                
      
      return(processed_data)
    })
    
    #Creating yearly subset
    data_output2 <- reactive({
      #Creating a reduced time range  
      processed_data2 <- create_yearly_subset(data_output1(), data_id(), input$range_years, month_range())              
      
      return(processed_data2)  
    })
    
    # Create reference yearly subset & convert to mean
    data_output3 <- reactive({
      # Create annual reference data
      ref1 <- create_yearly_subset(data_output1(), data_id(), input$ref_period, month_range())   
      ref2 = apply(ref1,c(1:2),mean)
      
      return(ref2)  
    })
    
    #Converting absolutes to anomalies
    data_output4 <- reactive({
      
      processed_data4 <- convert_subset_to_anomalies(data_output2(), data_output3())
      
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
      
      my_stats = create_stat_highlights_data(data_output4(),SDratio_subset(),
                                             input$custom_statistic,input$sd_ratio,
                                             NA,subset_lons(),subset_lats())
      
      return(my_stats)
    })
    
    #Plotting the Data (Maps)
    map_data <- function(){create_map_datatable(data_output4(), subset_lons(), subset_lats())}
    
    output$data1 <- renderTable({map_data()}, rownames = TRUE)
    
    #Plotting the Map
    map_dimensions <- reactive({
      
      m_d = generate_map_dimensions(subset_lons(), subset_lats(), session$clientData$output_map_width, input$dimension[2], input$hide_axis)
      
      return(m_d)  
    })
    
    map_plot <- function(){plot_default_map(map_data(), input$variable_selected, "Anomaly", plot_titles(), input$axis_input, input$hide_axis, map_points_data(), map_highlights_data(),map_statistics(),input$hide_borders)}
    
    output$map <- renderPlot({map_plot()},width = function(){map_dimensions()[1]},height = function(){map_dimensions()[2]})
    # code line below sets height as a function of the ratio of lat/lon 
    
    
    #Ref/Absolute/SD ratio Map
    ref_map_data <- function(){
      if (input$ref_map_mode == "Absolute Values"){
        create_map_datatable(data_output2(), subset_lons(), subset_lats())
      } else if (input$ref_map_mode == "Reference Values"){
        create_map_datatable(data_output3(), subset_lons(), subset_lats())
      } else if (input$ref_map_mode == "SD Ratio"){
        create_map_datatable(SDratio_subset(), subset_lons(), subset_lats())
      }
    }    
    
    ref_map_titles = reactive({
      if (input$ref_map_mode == "Absolute Values"){
        rm_title <- generate_titles("general",input$dataset_selected, input$variable_selected, "Absolute", input$title_mode,input$title_mode_ts,
                                    month_range(), input$range_years, NA, NA,lonlat_vals()[1:2],lonlat_vals()[3:4],
                                    input$title1_input, input$title2_input,input$title1_input_ts)
      } else if (input$ref_map_mode == "Reference Values"){
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
      if (input$ref_map_mode == "Absolute Values" | input$ref_map_mode == "Reference Values" ){
        plot_default_map(ref_map_data(), input$variable_selected, "Absolute", ref_map_titles(), NULL, FALSE, data.frame(), data.frame(),data.frame(),input$hide_borders)
      } else if(input$ref_map_mode == "SD Ratio"){
        plot_default_map(ref_map_data(), "SD Ratio", "Absolute", ref_map_titles(), c(0,1), FALSE, data.frame(), data.frame(),data.frame(),input$hide_borders)
      }
    }
    
    output$ref_map <- renderPlot({
      if (input$ref_map_mode == "None") {
        ref_map_plot_data <- NULL
      } else {
        ref_map_plot_data <- ref_map_plot()
      }
      ref_map_plot_data
    }, 
    width = function() {
      if (input$ref_map_mode == "None") {
        20
      } else {
        map_dimensions()[1]
      }
    }, 
    height = function() {
      if (input$ref_map_mode == "None") {
        10
      } else {
        map_dimensions()[2]
      }
    })
    

    #Plotting the data (timeseries)
    timeseries_data <- reactive({
      #Plot normal timeseries if year range is > 1 year
      if (input$range_years[1] != input$range_years[2]){
        ts_data1 <- create_timeseries_datatable(data_output4(), input$range_years, "range", subset_lons(), subset_lats())
        
        ts_data2 = add_stats_to_TS_datatable(ts_data1,input$custom_average_ts,input$year_moving_ts,
                                             "center",input$custom_percentile_ts,input$percentile_ts,input$moving_percentile_ts)
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
    
    #Plotting the timeseries
    timeseries_plot <- function(){
      #Plot normal timeseries if year range is > 1 year
      if (input$range_years[1] != input$range_years[2]){
        # Generate NA or reference mean
        if(input$show_ref_ts == TRUE){
          ref_ts = signif(mean(data_output3()),3)
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
    
    #Data ModE-RA sources
    fad_wa_data <- function() {

      download_feedback_data(input$fad_year_a, "winter", lonlat_vals()[1:2], lonlat_vals()[3:4])}
    fad_sa_data <- function() {

      download_feedback_data(input$fad_year_a, "summer", lonlat_vals()[1:2], lonlat_vals()[3:4])}
    
    
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
    
    output$download_map_data        <- downloadHandler(filename = function() {paste(plot_titles()$file_title, "-mapdata.", input$file_type_map_data, sep = "")},
                                                        content = function(file) {
                                                          if (input$file_type_map_data == "csv"){
                                                            map_data_new <- rewrite_maptable(map_data(), subset_lons(), subset_lats())
                                                            colnames(map_data_new) <- NULL
                                                            
                                                            write.csv(map_data_new, file,
                                                                      row.names = FALSE)
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
                                                                      fileEncoding = "latin1")
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
    
    output$download_data_fad_wa       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a, "-modera_source_data.",input$file_type_data_modera_source_a, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_data_modera_source_a == "csv"){
                                                              write.csv(fad_wa_data(), file,
                                                                        row.names = FALSE)
                                                            } else {
                                                              write.xlsx(fad_wa_data(), file,
                                                                         col.names = TRUE,
                                                                         row.names = FALSE)
                                                            }})
    
    output$download_data_fad_sa      <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a, "-modera_source_data.",input$file_type_data_modera_source_b, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_data_modera_source_b == "csv"){
                                                            write.csv(fad_sa_data(), file,
                                                                      row.names = FALSE)
                                                          } else {
                                                            write.xlsx(fad_sa_data(), file,
                                                                       col.names = TRUE,
                                                                       row.names = FALSE)
                                                          }})
    
    output$download_netcdf             <- downloadHandler(filename = function() {paste(plot_titles()$netcdf_title, ".nc", sep = "")},
                                                          content  = function(file) {
                                                            netcdf_ID = sample(1:1000000,1)
                                                            generate_custom_netcdf (data_output4(), "general",input$dataset_selected,netcdf_ID, input$variable_selected, input$netcdf_variables, "Anomaly", subset_lons(), subset_lats(), month_range(), input$range_years, input$ref_period, NA)
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
    
    data_id_2 <- reactive({
      
      dat_id2 = generate_data_ID(input$dataset_selected2,input$variable_selected2, month_range_2())
      
      return(dat_id2)
    })      
    
    # Update custom_data if required
    observeEvent(data_id_2(),{
      if (data_id_2()[1] == 0){ # Only updates when new custom data is required...
        if (!identical(custom_data_ID()[2:3],data_id_2()[2:3])){ # ....i.e. changed variable or dataset
          custom_data(load_ModE_data(input$dataset_selected2,input$variable_selected2)) # load new custom data
          custom_data_ID(data_id_2()) # update custom data ID
        }
      }
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
    
    # Update SD ratio data when required
    observe({
      if((input$ref_map_mode2 == "SD Ratio")|(input$custom_statistic2 == "SD ratio")){
        if (input$nav1 == "tab2"){ # check current tab
          if (!identical(SDratio_data_ID()[3],data_id_2()[3])){ # check to see if currently loaded variable is the same
            SDratio_data(load_ModE_data("SD Ratio",input$variable_selected2)) # load new SD data
            SDratio_data_ID(data_id_2()) # update custom data ID
          } 
        }
      }
    })
    
    # Processed SD data
    SDratio_subset_2 = reactive({
      
      req(((input$ref_map_mode2 == "SD Ratio")|(input$custom_statistic2 == "SD ratio")))
      
      new_SD_data2 = create_sdratio_data(SDratio_data(),"composites",input$variable_selected2,
                                         subset_lons_2(),subset_lats_2(),month_range_2(),year_set_comp())
      return(new_SD_data2)
    })
    
    
    #Geographic Subset
    data_output1_2 <- reactive({
      
      #Geographic Subset Function
      processed_data_2  <- create_latlon_subset(custom_data(), data_id_2(), subset_lons_2(), subset_lats_2())                
      
      return(processed_data_2)
    })
    
    #Creating yearly subset for Composites
    data_output2_2 <- reactive({
      
      #Creating a reduced time range
      processed_data2_2 <- create_yearly_subset_composite(data_output1_2(), data_id_2(), year_set_comp(), month_range_2())              
      
      return(processed_data2_2)  
    })
    
    # Create composite reference yearly subset & convert to mean
    data_output3_2 = reactive({
      
      if (input$mode_selected2 == "Fixed reference"){
        ref_2 <- create_yearly_subset(data_output1_2(), data_id_2(), input$ref_period2, month_range_2())   
        processed_data3_2 <- apply(ref_2,c(1:2),mean)
      } else if (input$mode_selected2 == "Custom reference") {
        ref_2 <- create_yearly_subset_composite(data_output1_2(), data_id_2(), year_set_comp_ref(), month_range_2()) 
        processed_data3_2 <- apply(ref_2,c(1:2),mean)
      } else {
        processed_data3_2 <- NA
      }
      
      return(processed_data3_2)
    })
    
    #Converting Composite to anomalies either fixed/custom period or X years prior 
    data_output4_2 <- reactive({
      if (input$mode_selected2 == "X years prior"){
        processed_data4_2 <- convert_composite_to_anomalies(data_output2_2(), data_output1_2(), data_id_2(), year_set_comp(), month_range_2(), input$prior_years2)
      } else {
        processed_data4_2 <- convert_subset_to_anomalies(data_output2_2(), data_output3_2())
      }
      
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
      
      my_stats = create_stat_highlights_data(data_output4_2(),SDratio_subset_2(),
                                             input$custom_statistic2,input$sd_ratio2,
                                             input$percentage_sign_match2,
                                             subset_lons_2(),subset_lats_2())
      
      return(my_stats)
    })
    
    #Plotting the Data (Maps)
    map_data_2 <- function(){create_map_datatable(data_output4_2(), subset_lons_2(), subset_lats_2())}
    
    output$data3 <- renderTable({map_data_2()}, rownames = TRUE)
    
    #Plotting the Map
    map_dimensions_2 <- reactive({
      
      m_d_2 = generate_map_dimensions(subset_lons_2(), subset_lats_2(), session$clientData$output_map2_width, input$dimension[2]*0.85, input$hide_axis2)
      
      return(m_d_2)
    })
    
    map_plot_2 <- function(){plot_default_map(map_data_2(), input$variable_selected2, input$mode_selected2, plot_titles_2(), input$axis_input2, input$hide_axis2, map_points_data2(), map_highlights_data2(),map_statistics_2(),input$hide_borders2)}
    
    output$map2 <- renderPlot({map_plot_2()},width = function(){map_dimensions_2()[1]},height = function(){map_dimensions_2()[2]})
    # code line below sets height as a function of the ratio of lat/lon 
    
    
    #Ref/Absolute Map
    ref_map_data_2 <- function(){
      if (input$ref_map_mode2 == "Absolute Values"){
        create_map_datatable(data_output2_2(), subset_lons_2(), subset_lats_2())
      } else if (input$ref_map_mode2 == "Reference Values"){
        create_map_datatable(data_output3_2(), subset_lons_2(), subset_lats_2())
      } else if (input$ref_map_mode2 == "SD Ratio"){
        create_map_datatable(SDratio_subset_2(), subset_lons_2(), subset_lats_2())
      }
    }    
    
    ref_map_titles_2 = reactive({
      if (input$ref_map_mode2 == "Absolute Values"){
        rm_title2 <- generate_titles("composites",input$dataset_selected2, input$variable_selected2, "Absolute", input$title_mode2,input$title_mode_ts2,
                                     month_range_2(), year_set_comp(), NA, NA,lonlat_vals2()[1:2],lonlat_vals2()[3:4],
                                     input$title1_input2, input$title2_input2,input$title1_input_ts2)
      } else if (input$ref_map_mode2 == "Reference Values"){
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
      if (input$ref_map_mode2 == "Absolute Values" | input$ref_map_mode2 == "Reference Values" ){
        plot_default_map(ref_map_data_2(), input$variable_selected2, "Absolute", ref_map_titles_2(), NULL, FALSE, data.frame(), data.frame(),data.frame(),input$hide_borders2)
      } else if (input$ref_map_mode2 == "SD Ratio"){
        plot_default_map(ref_map_data_2(), "SD Ratio", "Absolute", ref_map_titles_2(), c(0,1), FALSE, data.frame(), data.frame(),data.frame(),input$hide_borders2)
      }
    }
    
    output$ref_map2 <- renderPlot({
      if (input$ref_map_mode2 == "None") {
        ref_map_plot_data2 <- NULL
      } else {
        ref_map_plot_data2 <- ref_map_plot_2()
      }
      ref_map_plot_data2
    }, 
    width = function() {
      if (input$ref_map_mode2 == "None") {
        20
      } else {
        map_dimensions_2()[1]
      }
    }, 
    height = function() {
      if (input$ref_map_mode2 == "None") {
        10
      } else {
        map_dimensions_2()[2]
      }
    })
    
    
    #Plotting the data (timeseries)
    timeseries_data_2 <- reactive({
      #Plot normal timeseries if year set is > 1 year
      if (length(year_set_comp()) > 1){    
        ts_data1 <- create_timeseries_datatable(data_output4_2(), year_set_comp(), "set", subset_lons_2(), subset_lats_2())
        
        ts_data2 = add_stats_to_TS_datatable(ts_data1,FALSE,NA,NA,input$custom_percentile_ts2,
                                             input$percentile_ts2,FALSE)
      } 
      # Plot monthly TS if year range = 1 year
      else {
        ts_data1 = load_ModE_data(input$dataset_selected2,input$variable_selected2)
        
        # Generate ref years
        if (input$mode_selected2 == "Fixed reference"){
          ref_years = input$ref_period2
        } else if (input$mode_selected2 == "X years prior"){
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
    
    #Plotting the timeseries
    timeseries_plot_2 <- function(){
      #Plot normal timeseries if year set is > 1 year
      if (length(year_set_comp()) > 1){  
        # Generate NA or reference mean
        if(input$show_ref_ts2 == TRUE){
          ref_ts2 = signif(mean(data_output3_2()),3)
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
    
    #Data ModE-RA sources
    fad_wa_data2 <- function() {
      
      download_feedback_data(input$fad_year_a2, "winter", lonlat_vals2()[1:2], lonlat_vals2()[3:4])}
    fad_sa_data2 <- function() {
      
      download_feedback_data(input$fad_year_a2, "summer", lonlat_vals2()[1:2], lonlat_vals2()[3:4])}
    

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
                                                            map_data_new_2 <- rewrite_maptable(map_data_2(), subset_lons_2(), subset_lats_2())
                                                            colnames(map_data_new_2) <- NULL
                                                            
                                                            write.csv(map_data_new_2, file,
                                                                      row.names = FALSE)
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
                                                                       fileEncoding = "latin1")
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
    
    output$download_data_fad_wa2       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a2, "-modera_source_data.",input$file_type_data_modera_source_a2, sep = "")},
                                                         content  = function(file) {
                                                           if (input$file_type_data_modera_source_a2 == "csv"){
                                                             write.csv(fad_wa_data2(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_wa_data2(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})
    
    output$download_data_fad_sa2     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a2, "-modera_source_data.",input$file_type_data_modera_source_b2, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_data_modera_source_b2 == "csv"){
                                                           write.csv(fad_sa_data2(), file,
                                                                     row.names = FALSE)
                                                         } else {
                                                           write.xlsx(fad_sa_data2(), file,
                                                                      col.names = TRUE,
                                                                      row.names = FALSE)
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
    data_id_v1 <- reactive({
      dat_id_v1 = generate_data_ID(input$dataset_selected_v1,input$ME_variable_v1, month_range_v1())
      return(dat_id_v1)
    })
    
    # Update custom_data if required
    observeEvent(data_id_v1(),{
      if (data_id_v1()[1] == 0){ # Only updates when new custom data is required...
        if (!identical(custom_data_ID()[2:3],data_id_v1()[2:3])){ # ....i.e. changed variable or dataset
          custom_data(load_ModE_data(input$dataset_selected_v1,input$ME_variable_v1)) # load new custom data
          custom_data_ID(data_id_v1()) # update custom data ID
        }
      }
    })
    
    #Geographic Subset
    data_output1_v1 <- reactive({ 
      processed_data_v1  <- create_latlon_subset(custom_data(), data_id_v1(), subset_lons_v1(), subset_lats_v1())                
      return(processed_data_v1)
    })
    
    #Creating yearly subset
    data_output2_v1 <- reactive({ 
      processed_data2_v1 <- create_yearly_subset(data_output1_v1(), data_id_v1(), input$range_years3, month_range_v1())              
      return(processed_data2_v1)  
    })
    
    # Create reference subset & average over time
    data_output3_v1 <- reactive({ 
      ref_v1 <- create_yearly_subset(data_output1_v1(), data_id_v1(), input$ref_period_v1, month_range_v1())
      processed_data3_v1 = apply(ref_v1,c(1:2),mean)
      return(processed_data3_v1)  
    })
    
    #Converting absolutes to anomalies
    data_output4_v1 <- reactive({
      if (input$mode_selected_v1 == "Absolute"){
        processed_data4_v1 <- data_output2_v1()
      } else {
        processed_data4_v1 <- convert_subset_to_anomalies(data_output2_v1(), data_output3_v1())
      }
      return(processed_data4_v1)
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
    map_data_v1 <- function(){create_map_datatable(data_output4_v1(), subset_lons_v1(), subset_lats_v1())}
    
    ME_map_plot_v1 <- function(){plot_default_map(map_data_v1(), input$ME_variable_v1, input$mode_selected_v1, plot_titles_v1(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame(),TRUE)}
    
    # Generate timeseries data & plotting function
    timeseries_data_v1 <- reactive({
      ts_data1_v1 <- create_timeseries_datatable(data_output4_v1(), input$range_years3, "range", subset_lons_v1(), subset_lats_v1())
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
    data_id_v2 <- reactive({
      dat_id_v2 = generate_data_ID(input$dataset_selected_v2,input$ME_variable_v2, month_range_v2())
      return(dat_id_v2)
    })
    
    # Update custom_data if required
    observeEvent(data_id_v2(),{
      if (data_id_v2()[1] == 0){ # Only updates when new custom data is required...
        if (!identical(custom_data_ID2()[2:3],data_id_v2()[2:3])){ # ....i.e. changed variable or dataset
          custom_data2(load_ModE_data(input$dataset_selected_v2,input$ME_variable_v2)) # load new custom data
          custom_data_ID2(data_id_v2()) # update custom data ID
        }
      }
    })
    
    #Geographic Subset
    data_output1_v2 <- reactive({ 
      processed_data_v2  <- create_latlon_subset(custom_data2(), data_id_v2(), subset_lons_v2(), subset_lats_v2())                
      return(processed_data_v2)
    })
    
    #Creating yearly subset
    data_output2_v2 <- reactive({ 
      processed_data2_v2 <- create_yearly_subset(data_output1_v2(), data_id_v2(), input$range_years3, month_range_v2())              
      return(processed_data2_v2)  
    })
    
    # Create reference subset & average over time
    data_output3_v2 <- reactive({ 
      ref_v2 <- create_yearly_subset(data_output1_v2(), data_id_v2(), input$ref_period_v2, month_range_v2())
      processed_data3_v2 = apply(ref_v2,c(1:2),mean)
      return(processed_data3_v2)  
    })
    
    #Converting absolutes to anomalies
    data_output4_v2 <- reactive({
      if (input$mode_selected_v2 == "Absolute"){
        processed_data4_v2 <- data_output2_v2()
      } else {
        processed_data4_v2 <- convert_subset_to_anomalies(data_output2_v2(), data_output3_v2())
      }
      return(processed_data4_v2)
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
    map_data_v2 <- function(){create_map_datatable(data_output4_v2(), subset_lons_v2(), subset_lats_v2())}
    
    ME_map_plot_v2 <- function(){plot_default_map(map_data_v2(), input$ME_variable_v2, input$mode_selected_v2, plot_titles_v2(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame(),TRUE)}
    
    # Generate timeseries data & plotting function
    timeseries_data_v2 <- reactive({
      ts_data1_v2 <- create_timeseries_datatable(data_output4_v2(), input$range_years3, "range", subset_lons_v2(), subset_lats_v2())
      return(ts_data1_v2)
    })
    
    ME_timeseries_plot_v2 = function(){plot_default_timeseries(timeseries_data_v2(),"general",input$ME_variable_v2,plot_titles_v2(),"Default",NA)}
    
    
    ### Plot v1/v2 plots
    
    # Generate plot dimensions
    plot_dimensions_v1 <- reactive({
      if (input$type_v1 == "Timeseries"){
        map_dims_v1 = c(session$clientData$output_plot_v1_width,400)
      } else {
        map_dims_v1 = generate_map_dimensions(subset_lons_v1(), subset_lats_v1(), session$clientData$output_plot_v1_width, (input$dimension[2]), FALSE)
      }
      return(map_dims_v1)  
    })
    
    plot_dimensions_v2 <- reactive({
      if (input$type_v2 == "Timeseries"){
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
      } else if (input$type_v1 == "Timeseries"){
        ME_timeseries_plot_v1()
      } else{
        ME_map_plot_v1()
      }
    },width = function(){plot_dimensions_v1()[1]},height = function(){plot_dimensions_v1()[2]})  
    
    
    output$plot_v2 <- renderPlot({
      if (input$source_v2 == "User Data"){
        plot_user_timeseries(user_subset_v2(),"saddlebrown")
      } else if (input$type_v2 == "Timeseries"){
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
      tsds_v1 = add_stats_to_TS_datatable(tsd_v1,input$custom_average_ts3,input$year_moving_ts3,
                                          "center",FALSE,NA,FALSE)
      
      return(tsds_v1)
    })
    
    ts_data_v2 = reactive({
      if (input$source_v2 == "ModE-"){
        tsd_v2 = timeseries_data_v2()
      } else {
        tsd_v2 = user_subset_v2()
      } 
      
      # Add moving averages (if chosen)
      tsds_v2 = add_stats_to_TS_datatable(tsd_v2,input$custom_average_ts3,input$year_moving_ts3,
                                          "center",FALSE,NA,FALSE)
      
      return(tsds_v2)
    })
    
    # Correlate timeseries
    correlation_stats = reactive({
      c_st = correlate_timeseries(ts_data_v1(),ts_data_v2(),input$cor_method_ts)
      
      return(c_st)
    })
    
    # Plot
    output$correlation_r_value = renderText({paste("Timeseries correlation coefficient: r =",signif(correlation_stats()$estimate,digits =3), sep = "")})
    output$correlation_p_value = renderText({paste("Timeseries correlation p-value: p =",signif(correlation_stats()$p.value,digits =3), sep = "")})    
    
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
        cmd_v1 = data_output4_v1()
      } else if (input$source_v1 == "User Data"){
        cmd_v1 = user_subset_v1()
      } else {
        cmd_v1 = timeseries_data_v1()
      } 
    })
    
    correlation_map_data_v2 = reactive({
      if (input$type_v2 == "Field"){
        cmd_v2 = data_output4_v2()
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
                             input$hide_axis3,map_points_data3(),map_highlights_data3(),data.frame(),input$hide_borders3)
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
    
    #Data ModE-RA sources
    fad_wa_data3a <- function() {
      
      download_feedback_data(input$fad_year_a3a, "winter", lonlat_vals_v1()[1:2], lonlat_vals_v1()[3:4])}
    fad_sa_data3a <- function() {
      
      download_feedback_data(input$fad_year_a3a, "summer", lonlat_vals_v1()[1:2], lonlat_vals_v1()[3:4])}
    
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
    
    #Data ModE-RA sources
    fad_wa_data3b <- function() {
      
      download_feedback_data(input$fad_year_a3b, "winter", lonlat_vals_v2()[1:2], lonlat_vals_v2()[3:4])}
    fad_sa_data3b <- function() {
      
      download_feedback_data(input$fad_year_a3b, "summer", lonlat_vals_v2()[1:2], lonlat_vals_v2()[3:4])}
    
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
                                                                         fileEncoding = "latin1")
                                                             } else {
                                                               write.xlsx(correlation_ts_datatable(), file,
                                                                          row.names = FALSE,
                                                                          col.names = TRUE)
                                                             }}) 
      
      output$download_map_data3        <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title, "-mapdata.",input$file_type_map_data3, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_map_data3 == "csv"){
                                                              map_data_new_3 <- rewrite_maptable(correlation_map_datatable(),NA,NA)
                                                              colnames(map_data_new_3) <- NULL
                                                              
                                                              write.csv(map_data_new_3, file,
                                                                        row.names = FALSE)
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
      
      output$download_data_fad_wa3a       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a3a, "-modera_source_data.",input$file_type_data_modera_source_a3a, sep = "")},
                                                            content  = function(file) {
                                                              if (input$file_type_data_modera_source_a3a == "csv"){
                                                                write.csv(fad_wa_data3a(), file,
                                                                          row.names = FALSE)
                                                              } else {
                                                                write.xlsx(fad_wa_data3a(), file,
                                                                           col.names = TRUE,
                                                                           row.names = FALSE)
                                                              }})
      
      output$download_data_fad_sa3a     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a3a, "-modera_source_data.",input$file_type_data_modera_source_b3a, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_data_modera_source_b3a == "csv"){
                                                              write.csv(fad_sa_data3a(), file,
                                                                        row.names = FALSE)
                                                            } else {
                                                              write.xlsx(fad_sa_data3a(), file,
                                                                         col.names = TRUE,
                                                                         row.names = FALSE)
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
      
      output$download_data_fad_wa3b       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a3b, "-modera_source_data.",input$file_type_data_modera_source_a3b, sep = "")},
                                                             content  = function(file) {
                                                               if (input$file_type_data_modera_source_a3b == "csv"){
                                                                 write.csv(fad_wa_data3b(), file,
                                                                           row.names = FALSE)
                                                               } else {
                                                                 write.xlsx(fad_wa_data3b(), file,
                                                                            col.names = TRUE,
                                                                            row.names = FALSE)
                                                               }})
      
      output$download_data_fad_sa3b     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a3b, "-modera_source_data.",input$file_type_data_modera_source_b3b, sep = "")},
                                                           content  = function(file) {
                                                             if (input$file_type_data_modera_source_b3b == "csv"){
                                                               write.csv(fad_sa_data3b(), file,
                                                                         row.names = FALSE)
                                                             } else {
                                                               write.xlsx(fad_sa_data3b(), file,
                                                                          col.names = TRUE,
                                                                          row.names = FALSE)
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
    data_id_dv <- reactive({
      dat_id_dv = generate_data_ID(input$dataset_selected_dv,input$ME_variable_dv, month_range_dv())
      return(dat_id_dv)
    })
    
    # Update custom_data if required
    observeEvent(data_id_dv(),{
      if (data_id_dv()[1] == 0){ # Only updates when new custom data is required...
        if (!identical(custom_data_ID()[2:3],data_id_dv()[2:3])){ # ....i.e. changed variable or dataset
          custom_data(load_ModE_data(input$dataset_selected_dv,input$ME_variable_dv)) # load new custom data
          custom_data_ID(data_id_dv()) # update custom data ID
        }
      }
    })
    
    #Geographic Subset
    data_output1_dv <- reactive({ 
      processed_data_dv  <- create_latlon_subset(custom_data(), data_id_dv(), subset_lons_dv(), subset_lats_dv())                
      return(processed_data_dv)
    })
    
    #Creating yearly subset
    data_output2_dv <- reactive({ 
      processed_data2_dv <- create_yearly_subset(data_output1_dv(), data_id_dv(), input$range_years4, month_range_dv())              
      return(processed_data2_dv)  
    })
    
    # Create reference subset & average over time
    data_output3_dv <- reactive({ 
      ref_dv <- create_yearly_subset(data_output1_dv(), data_id_dv(), input$ref_period_dv, month_range_dv())
      processed_data3_dv = apply(ref_dv,c(1:2),mean)
      return(processed_data3_dv)  
    })
    
    #Converting absolutes to anomalies
    data_output4_dv <- reactive({
      if (input$mode_selected_dv == "Absolute"){
        processed_data4_dv <- data_output2_dv()
      } else {
        processed_data4_dv <- convert_subset_to_anomalies(data_output2_dv(), data_output3_dv())
      }
      return(processed_data4_dv)
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
    map_data_dv <- function(){create_map_datatable(data_output4_dv(), subset_lons_dv(), subset_lats_dv())}
    
    ME_map_plot_dv <- function(){plot_default_map(map_data_dv(), input$ME_variable_dv, input$mode_selected_dv, plot_titles_dv(), c(NULL,NULL),FALSE, data.frame(), data.frame(),data.frame(),TRUE)}
    
    # Generate timeseries data & plotting function for iv
    ME_ts_data_iv <- reactive({
      me_tsd_iv = create_ME_timeseries_data(input$dataset_selected_dv,input$ME_variable_iv,subset_lons_iv(),subset_lats_iv(),
                                            input$mode_selected_iv,month_range_iv(),input$range_years4,
                                            input$ref_period_iv)
      return(me_tsd_iv)
    })
    
    
    ME_timeseries_plot_iv = function(){plot_default_timeseries(ME_ts_data_iv(),"general",input$ME_variable_iv[1],plot_titles_iv(),"Default",NA)}
    
    # Generate Timeseries data for dv
    timeseries_data_dv <- reactive({
      ts_data1_dv <- create_timeseries_datatable(data_output4_dv(), input$range_years4, "range", subset_lons_dv(), subset_lats_dv())
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
      
      reg_cd = create_regression_coeff_data(ts_data_iv(), data_output4_dv(), variables_iv())
      
      return(reg_cd)
    })
    
    reg_coef_1 = function(){
      req(input$coeff_variable)
      plot_regression_coefficients(regression_coeff_data(),variables_iv(),match(input$coeff_variable,variables_iv()),
                                   variable_dv(),plot_titles_reg(),subset_lons_dv(),subset_lats_dv(),TRUE)
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
      rpvd = create_regression_pvalue_data(ts_data_iv(), data_output4_dv(), variables_iv())
      
      return(rpvd)
    })
    
    reg_pval_1 = function(){
      req(input$pvalue_variable)
      plot_regression_pvalues(regression_pvalue_data(),variables_iv(),match(input$pvalue_variable,variables_iv()),
                              variable_dv(),plot_titles_reg(),subset_lons_dv(),subset_lats_dv(),TRUE)
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
      rresd = create_regression_residuals(ts_data_iv(), data_output4_dv(), variables_iv())
      
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
                                subset_lons_dv(),subset_lats_dv(),TRUE)
      
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
    
    #Data ModE-RA sources
    fad_wa_data4a <- function() {
      
      download_feedback_data(input$fad_year_a4a, "winter", lonlat_vals_iv()[1:2], lonlat_vals_iv()[3:4])}
    fad_sa_data4a <- function() {
      
      download_feedback_data(input$fad_year_a4a, "summer", lonlat_vals_iv()[1:2], lonlat_vals_iv()[3:4])}
    
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
    
    #Data ModE-RA sources
    fad_wa_data4b <- function() {
      
      download_feedback_data(input$fad_year_a4b, "winter", lonlat_vals_dv()[1:2], lonlat_vals_dv()[3:4])}
    fad_sa_data4b <- function() {
      
      download_feedback_data(input$fad_year_a4b, "summer", lonlat_vals_dv()[1:2], lonlat_vals_dv()[3:4])}
    
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
                                                                       fileEncoding = "latin1")
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
                                                                    map_data_new_4a <- rewrite_maptable(reg_coef_2(),NA,NA)
                                                                    colnames(map_data_new_4a) <- NULL
                                                                    
                                                                    write.csv(map_data_new_4a, file,
                                                                              row.names = FALSE)
                                                                  } else {
                                                                    write.xlsx(rewrite_maptable(reg_coef_2(),NA,NA), file,
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
                                                                    map_data_new_4b <- rewrite_maptable(reg_pval_2(),NA,NA)
                                                                    colnames(map_data_new_4b) <- NULL
                                                                    
                                                                    write.csv(map_data_new_4b, file,
                                                                              row.names = FALSE)
                                                                  } else {
                                                                    write.xlsx(rewrite_maptable(reg_pval_2(),NA,NA), file,
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
                                                                    map_data_new_4c <- rewrite_maptable(reg_res_2(),NA,NA)
                                                                    colnames(map_data_new_4c) <- NULL
                                                                    
                                                                    write.csv(map_data_new_4c, file,
                                                                              row.names = FALSE)
                                                                  } else {
                                                                    write.xlsx(rewrite_maptable(reg_res_2(),NA,NA), file,
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
    
    output$download_data_fad_wa4a       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a4a, "-modera_source_data.",input$file_type_data_modera_source_a4a, sep = "")},
                                                           content  = function(file) {
                                                             if (input$file_type_data_modera_source_a4a == "csv"){
                                                               write.csv(fad_wa_data4a(), file,
                                                                         row.names = FALSE)
                                                             } else {
                                                               write.xlsx(fad_wa_data4a(), file,
                                                                          col.names = TRUE,
                                                                          row.names = FALSE)
                                                             }})
    
    output$download_data_fad_sa4a     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a4a, "-modera_source_data.",input$file_type_data_modera_source_b4a, sep = "")},
                                                         content  = function(file) {
                                                           if (input$file_type_data_modera_source_b4a == "csv"){
                                                             write.csv(fad_sa_data4a(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_sa_data4a(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
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
    
    output$download_data_fad_wa4b       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a4b, "-modera_source_data.",input$file_type_data_modera_source_a4b, sep = "")},
                                                           content  = function(file) {
                                                             if (input$file_type_data_modera_source_a4b == "csv"){
                                                               write.csv(fad_wa_data4b(), file,
                                                                         row.names = FALSE)
                                                             } else {
                                                               write.xlsx(fad_wa_data4b(), file,
                                                                          col.names = TRUE,
                                                                          row.names = FALSE)
                                                             }})
    
    output$download_data_fad_sa4b     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a4b, "-modera_source_data.",input$file_type_data_modera_source_b4b, sep = "")},
                                                         content  = function(file) {
                                                           if (input$file_type_data_modera_source_b4b == "csv"){
                                                             write.csv(fad_sa_data4b(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_sa_data4b(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})

    
  ## ANNUAL CYCLES data processing and plotting ----
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
    
    #Data ModE-RA sources
    fad_wa_data5 <- function() {
      
      download_feedback_data(input$fad_year_a5, "winter", input$fad_longitude_a5, input$fad_latitude_a5)}
    fad_sa_data5 <- function() {
      
      download_feedback_data(input$fad_year_a5, "summer", input$fad_longitude_a5, input$fad_latitude_a5)}
    
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
    
    ### Downloading Annual cycles data ----
    
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
                                                                      fileEncoding = "latin1")
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
    
    output$download_data_fad_wa5       <- downloadHandler(filename = function(){paste("Assimilated Observations_winter_",input$fad_year_a5, "-modera_source_data.",input$file_type_data_modera_source_a5, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_data_modera_source_a5 == "csv"){
                                                              write.csv(fad_wa_data5(), file,
                                                                        row.names = FALSE)
                                                            } else {
                                                              write.xlsx(fad_wa_data5(), file,
                                                                         col.names = TRUE,
                                                                         row.names = FALSE)
                                                            }})
    
    output$download_data_fad_sa5     <- downloadHandler(filename = function(){paste("Assimilated Observations_summer_",input$fad_year_a5, "-modera_source_data.",input$file_type_data_modera_source_b5, sep = "")},
                                                        content  = function(file) {
                                                          if (input$file_type_data_modera_source_b5 == "csv"){
                                                            write.csv(fad_sa_data5(), file,
                                                                      row.names = FALSE)
                                                          } else {
                                                            write.xlsx(fad_sa_data5(), file,
                                                                       col.names = TRUE,
                                                                       row.names = FALSE)
                                                          }})
    
  ## Concerning all modes (mainly updating Ui) ----
    
    #Updates Values outside of min / max (numericInput)
    
    updateNumericInputRange <- function(inputId, minValue, maxValue) {
      observe({
        input_values <- input[[inputId]]
        
        delay(3000, {
          if (is.null(input_values) || is.na(input_values)) {         
          } else if (!is.numeric(input_values)) {
            updateNumericInput(inputId = inputId, value = minValue)
          } else {
            update_value <- function(val) {
              if (val < minValue) {
                updateNumericInput(inputId = inputId, value = minValue)
              } else if (val > maxValue) {
                updateNumericInput(inputId = inputId, value = maxValue)
              }
            }
            
            update_value(input_values)
          }
        })
      })
    }
    
    # Call the function for each input
    updateNumericInputRange("point_size", 1, 10)
    updateNumericInputRange("point_size2", 1, 10)
    updateNumericInputRange("point_size3", 1, 10)
    updateNumericInputRange("point_size_ts", 1, 10)
    updateNumericInputRange("point_size_ts2", 1, 10)
    updateNumericInputRange("point_size_ts3", 1, 10)
    updateNumericInputRange("percentage_sign_match", 1, 100)
    updateNumericInputRange("percentage_sign_match2", 1, 100)
    updateNumericInputRange("hidden_SD_ratio", 0, 1)
    updateNumericInputRange("hidden_SD_ratio2", 0, 1)
    updateNumericInputRange("year_moving_ts", 3, 30)
    updateNumericInputRange("year_moving_ts3", 3, 30)
    updateNumericInputRange("prior_years2", 1, 50)
    
    
    updateNumericInputRange <- function(inputId, minValue, maxValue) {
      observe({
        input_values <- input[[inputId]]
        
        delay(3000, {
          if (is.null(input_values) || is.na(input_values)) {         
          } else if (!is.numeric(input_values)) {
            updateNumericInput(inputId = inputId, value = 1422)
          } else {
            update_value <- function(val) {
              if (nchar(as.integer(input_values)) > 3){
                if (val < minValue) {
                  updateNumericInput(inputId = inputId, value = minValue)
                } else if (val > maxValue) {
                  updateNumericInput(inputId = inputId, value = maxValue)
                }
              }
            }
            
            update_value(input_values)
          }
        })
      })
    }
    
    # Call the function for each input
    updateNumericInputRange("fad_year_a", 1422, 2008)
    updateNumericInputRange("fad_year_a2", 1422, 2008)
    updateNumericInputRange("fad_year_a3a", 1422, 2008)
    updateNumericInputRange("fad_year_a3b", 1422, 2008)
    updateNumericInputRange("fad_year_a4a", 1422, 2008)
    updateNumericInputRange("fad_year_a4b", 1422, 2008)
    updateNumericInputRange("fad_year_a5", 1422, 2008)
    updateNumericInputRange("reg_resi_year", 1422, 2008)
    updateNumericInputRange("range_years_sg", 1422, 2008)
    updateNumericInputRange("ref_period_sg", 1422, 2008)
    updateNumericInputRange("ref_period_sg2", 1422, 2008)
    updateNumericInputRange("ref_period_sg_v1", 1422, 2008)
    updateNumericInputRange("ref_period_sg_v2", 1422, 2008)
    updateNumericInputRange("ref_period_sg_iv", 1422, 2008)
    updateNumericInputRange("ref_period_sg_dv", 1422, 2008)
    updateNumericInputRange("ref_period_sg5", 1422, 2008)

    #Updates Values outside of min / max (numericRangeInput)
    
    observe({
      input_ids <- c("range_years", "range_years3", "range_years4", "ref_period", "ref_period2", "ref_period_v1", "ref_period_v2", "ref_period_iv", "ref_period_dv", "ref_period5")
      
      for (input_id in input_ids) {
        range_values <- input[[input_id]]
        
        update_values <- function(left, right) {
          if (!is.numeric(left) || is.na(left) || left < 1422) {
            updateNumericRangeInput(inputId = input_id, value = c(1422, range_values[2]))
          } else if (left > 2008) {
            updateNumericRangeInput(inputId = input_id, value = c(1422, range_values[2]))
          }
          
          if (!is.numeric(right) || is.na(right) || right < 1422) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 2008))
          } else if (right > 2008) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 2008))
          }
        }
        
        update_values(range_values[1], range_values[2])
      }
    })

    observe({
      input_ids <- c("range_longitude", "range_longitude2", "range_longitude_v1", "range_longitude_v2", "range_longitude_iv", "range_longitude_dv", "range_longitude5", "fad_longitude_a5")
      
      for (input_id in input_ids) {
        range_values <- input[[input_id]]
        
        update_values <- function(left, right) {
          if (!is.numeric(left) || is.na(left) || left < -180) {
            updateNumericRangeInput(inputId = input_id, value = c(-180, range_values[2]))
          } else if (left > 180) {
            updateNumericRangeInput(inputId = input_id, value = c(-180, range_values[2]))
          }
          
          if (!is.numeric(right) || is.na(right) || right < -180) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 180))
          } else if (right > 180) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 180))
          }
        }
        
        update_values(range_values[1], range_values[2])
      }
    })
    
    observe({
      input_ids <- c("range_latitude", "range_latitude_v1", "range_latitude_v2", "range_latitude_iv", "range_latitude_dv", "range_latitude5", "fad_latitude_a5")
      
      for (input_id in input_ids) {
        range_values <- input[[input_id]]
        
        update_values <- function(left, right) {
          if (!is.numeric(left) || is.na(left) || left < -90) {
            updateNumericRangeInput(inputId = input_id, value = c(-90, range_values[2]))
          } else if (left > 90) {
            updateNumericRangeInput(inputId = input_id, value = c(-90, range_values[2]))
          }
          
          if (!is.numeric(right) || is.na(right) || right < -90) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 90))
          } else if (right > 90) {
            updateNumericRangeInput(inputId = input_id, value = c(range_values[1], 90))
          }
        }
        
        update_values(range_values[1], range_values[2])
      }
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
      if (!is.na(input$ref_period_sg5)) {
        updateNumericRangeInput(
          inputId = "ref_period5",
          value   = c(input$ref_period_sg5, input$ref_period_sg5)
        )
      }
    })
    
    # Stop App on end of session
     # session$onSessionEnded(function() {
     #   stopApp()
     # })

}

# Run the app ----
app <- shinyApp(ui = ui, server = server)
# Run the app normally
  #runApp(app)
# Run the app with profiling
  #profvis({runApp(app)})


  
  