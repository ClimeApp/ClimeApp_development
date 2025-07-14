# Define server logic ----
server <- function(input, output, session) {
  # ClimeApp Desktop Download ----
  output$climeapp_desktop_download <- downloadHandler(
    filename = function() {"ClimeApp Desktop Installer.zip"},
    content = function(file) {
      file.copy("ClimeApp Desktop Installer.zip",file)
    }
  )
  
  # Set up custom data, preprocessed data and SDratio reactive variables ----
  preprocessed_data_primary = reactiveVal()
  preprocessed_data_id_primary = reactiveVal(c(NA,NA,NA,NA)) # data_ID for current preprocessed data
  
  preprocessed_data_secondary = reactiveVal()
  preprocessed_data_id_secondary = reactiveVal(c(NA,NA,NA,NA)) # data_ID for secodnary preprocessed data
  
  custom_data_primary = reactiveVal()
  custom_data_id_primary = reactiveVal(c(NA,NA,NA,NA)) # data_ID for current custom data
  
  custom_data_secondary = reactiveVal()                 # custom data secondary is only used for variable 2 in correlation
  custom_data_id_secondary = reactiveVal(c(NA,NA,NA,NA)) 
  
  SDratio_data = reactiveVal()
  SDratio_data_id = reactiveVal(c(NA,NA,NA,NA)) # data_ID for current SD data
  
  # Preparations in the Server (Hidden options) ----
  ### Easter Eggs ----
  
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
  } else if ((current_month_day >= "03-22" && current_month_day <= "04-09")
             #omitted the OR (current_month_day >= "04-11" && current_month_day <= "04-25")
  ) {
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
  
  ### Logos ----
  
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
  
  output$keep_calm <- renderUI({
    if (input$title1_input_ts3 == "Keep Calm") {
      img(src = 'pics/KCAUCA.png', id = "img_britannia", height = "514", width = "488", style = "display: block; margin: 0 auto;")
    } else {
      NULL
    }
  })
  
  output$leaves <- renderUI({
    if (input$title1_input3 == "Leaves from the Vine") {
      img(src = 'pics/LeavesFromTheVine.jpg', id = "img_leaves", height = "450", width = "600", style = "display: block; margin: 0 auto;")
    } else {
      NULL
    }
  })
  
  ### Panel Visibility ----
  
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
  
  # Add logic to toggle the visibility of a specific tabPanel (Correlation and Regression Map) based on radio button values ("Choose a data source:")
  observe({
    if (input$source_v1 == "User Data" && input$source_v2 == "User Data") {
      shinyjs::runjs('
        // Get the tabPanel element by ID
        var tabPanelToHide = $("#tabset3 a[data-value=\'corr_fad_tab\']").parent();
  
        // Hide the tabPanel
        tabPanelToHide.hide();
      ')
      
    } else 
      shinyjs::runjs('
        // Get the tabPanel element by ID
        var tabPanelToHide = $("#tabset3 a[data-value=\'corr_fad_tab\']").parent();
  
        // Show the tabPanel
        tabPanelToHide.show();
      ')
  })
  
  observe({
    if (input$source_iv == "User Data" && input$source_dv == "User Data") {
      shinyjs::runjs('
        // Get the tabPanel element by ID
        var tabPanelToHide = $("#tabset4 a[data-value=\'reg_fad_tab\']").parent();
  
        // Hide the tabPanel
        tabPanelToHide.hide();
      ')
      
    } else 
      shinyjs::runjs('
        // Get the tabPanel element by ID
        var tabPanelToHide = $("#tabset4 a[data-value=\'reg_fad_tab\']").parent();
  
        // Show the tabPanel
        tabPanelToHide.show();
      ')
  })
  
  ### Hiding, showing, enabling/unabling certain inputs ----
  ####### Anomalies ----
  
  # Side Bar Panel
  observe({shinyjs::toggle(id = "season",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$season_selected == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_sec_map_download",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$ref_map_mode != "None",
                           asis = FALSE)})
  
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
  
  # Customization
  ### Anomalies Maps
  
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
  
  observe({shinyjs::toggle(id = "hidden_geo_options",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo == TRUE,
                           asis = FALSE)})
  
  
  
  ### Anomalies TS
  
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
  
  observe({shinyjs::toggle(id = "highlight_label_ts",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_highlight_on_legend_ts == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "line_label_ts",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_line_on_legend_ts == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_ts",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_ts == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_xaxis_interval_ts",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_ticks_ts == TRUE,
                           asis = FALSE)})
  
  
  ####### Composite ----
  
  # Side Bar
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
  
  # Main Panel
  observe({shinyjs::toggle(id = "hidden_sec_map_download2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$ref_map_mode2 != "None",
                           asis = FALSE)})
  
  # Customization
  ### Composites Maps
  
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
  
  observe({shinyjs::toggle(id = "hidden_geo_options2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo2 == TRUE,
                           asis = FALSE)})
  
  ### Composites TS
  
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
  
  observe({shinyjs::toggle(id = "highlight_label_ts2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_highlight_on_legend_ts2 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "line_label_ts2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_line_on_legend_ts2 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_ts2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_ts2 == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_xaxis_interval_ts2",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_ticks_ts2 == TRUE,
                           asis = FALSE)})
  
  
  ####### Correlation ----
  
  ###Sidebar V1
  
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
  
  
  
  ###Sidebar V2
  
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
  
  observe({shinyjs::toggle(id = "hidden_sec_map_download3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$ref_map_mode3 != "None",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_ref_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_ref_ts3 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_score_ref_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$add_outliers_ref_ts3 == "z-score",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_trend_sd_ref_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$add_outliers_ref_ts3 == "Trend deviation",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_v1 == "ModE-" && input$source_v2 == "ModE-",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_v1 == "ModE-" && input$source_v2 == "ModE-",
                           asis = FALSE)})
  
  
  
  
  # Customization
  ### Correlation Maps
  
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
  
  observe({shinyjs::toggle(id = "hidden_geo_options3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo3 == TRUE,
                           asis = FALSE)})
  
  ### Correlation TS
  
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
  
  observe({shinyjs::toggle(id = "highlight_label_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_highlight_on_legend_ts3 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "line_label_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_line_on_legend_ts3 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_ts3 == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_xaxis_interval_ts3",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_ticks_ts3 == TRUE,
                           asis = FALSE)})
  
  ####### Regression ----
  
  ###Sidebar IV
  
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
  
  ###Sidebar DV
  
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
  
  ###Regression (Main Panel)
  
  ### Regression TS
  
  observe({shinyjs::toggle(id = "hidden_custom_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_title_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$title_mode_ts4 == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_features_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_features_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_points_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_ts4 == "Point",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_highlights_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_ts4 == "Highlight",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_line_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_ts4 == "Line",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_download_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$download_options_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "highlight_label_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_highlight_on_legend_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "line_label_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_line_on_legend_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_ts4a",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_ts4a == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_ts4b",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_ts4b == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_xaxis_interval_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_ticks_ts4 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta_ts4",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_iv == "ModE-" && input$source_dv == "ModE-",
                           asis = FALSE)})

  ### Regression Maps
  # Hidden Customization and Download Regression Coefficients
  observe({shinyjs::toggle(id = "hidden_custom_map_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_map_reg_coeff == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_reg_coeff == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_title_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$title_mode_reg_coeff == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_features_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_features_reg_coeff == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_points_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_coeff == "Point",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_highlights_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_coeff == "Highlight",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_download_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$download_options_coeff == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_geo_options_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo_reg_coeff == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta_reg_coeff",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_iv == "ModE-" && input$source_dv == "ModE-",
                           asis = FALSE)})
  
  
  # Hidden Customization and Download Regression P-Values
  observe({shinyjs::toggle(id = "hidden_custom_map_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_map_reg_pval == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_reg_pvals",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_reg_pvals == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_title_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$title_mode_reg_pval == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_features_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_features_reg_pval == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_points_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_pval == "Point",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_highlights_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_pval == "Highlight",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_download_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$download_options_pval == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_geo_options_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo_reg_pval == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta_reg_pval",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_iv == "ModE-" && input$source_dv == "ModE-",
                           asis = FALSE)})
  
  
  # Hidden Customization and Download Regression Residuals
  observe({shinyjs::toggle(id = "hidden_custom_maps_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_map_reg_res == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_reg_res == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_title_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$title_mode_reg_res == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_features_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_features_reg_res == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_points_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_res == "Point",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_highlights_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$feature_reg_res == "Highlight",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_geo_options_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_topo_reg_res == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_iv == "ModE-" && input$source_dv == "ModE-",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_download_reg_res",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$download_options_reg_res == TRUE,
                           asis = FALSE)})
  
  
  #Download FAD Plots
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
  
  ####### Annual cycles ----
  
  #Sidebar Panel
  
  observe({shinyjs::toggle(id = "optional5",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$mode_selected5 == "Anomaly",
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
  #Customization
  
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
  
  observe({shinyjs::toggle(id = "highlight_label_ts5",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_highlight_on_legend_ts5 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "line_label_ts5",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_line_on_legend_ts5 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_key_position_ts5",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$show_key_ts5 == TRUE,
                           asis = FALSE)})
  
  ####### SEA ----
  
  ###Sidebar Data
  
  observe({shinyjs::toggle(id = "upload_sea_data_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_sea_6 == "User Data",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "upload_example_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = is.null(input$user_file_6),
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_user_data_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_sea_6 == "User Data",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_me_dataset_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_sea_6 == "ModE-",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_modera_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_sea_6 == "ModE-",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "optional6c",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$enter_upload_6 == "Manual",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "optional6d",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$enter_upload_6 == "Upload",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "optional6e",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = is.null(input$upload_file_6b),
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "season_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$season_selected_6 == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "ref_period_sg_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$ref_single_year_6 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "ref_period_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$ref_single_year_6 == FALSE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_continents_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$coordinates_type_6 == "Continents",
                           asis = FALSE)})
  
  #Customization and Downloads
  
  observe({shinyjs::toggle(id = "hidden_custom_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$custom_6 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_title_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$title_mode_6 == "Custom",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_statistics_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$enable_custom_statistics_6 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_download_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$download_options_6 == TRUE,
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_custom_axis_6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$axis_mode_6 == "Fixed",
                           asis = FALSE)})
  
  observe({shinyjs::toggle(id = "hidden_meta6",
                           anim = TRUE,
                           animType = "slide",
                           time = 0.5,
                           selector = NULL,
                           condition = input$source_sea_6 == "ModE-",
                           asis = FALSE)})
  
  ### ANOMALIES observe, update & interactive controls ----
  
  ####### Input updaters ----
  
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
  
  observeEvent(input$projection, { # also update to global if projection is changed
    if (input$projection != "UTM (default)") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = c(-180, 180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = c(-90, 90))
      lonlat_vals(c(-180, 180, -90, 90))
    }
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

  # Axis values updater MAP
  observe({
    if (input$axis_mode == "Automatic"){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input",
        value = c(NA,NA))
    }
  })
  
  observe({
    if (input$axis_mode == "Fixed" & is.null(input$axis_input)) {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input",
        value = set_axis_values(data_input = final_map_data(), mode = "Anomaly")
      )
    }
  })
  
  # Axis values updater TS
  observe({
    if (input$axis_mode_ts == "Automatic"){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts",
        value = c(NA,NA))
    }
  })
  
  observe({
    if (input$axis_mode_ts == "Fixed" & is.null(input$axis_input_ts)){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts",
        value = set_ts_axis_values(data_input = timeseries_data()$Mean))
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
  
  ####### Interactivity ----
  
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
    
    x_brush_1 = input$map_brush1[[1]]
    x_brush_2 = input$map_brush1[[2]]
    
    if (input$custom_features == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude",
        label = NULL,
        value = round(c(input$map_brush1[[3]], input$map_brush1[[4]]), digits = 2)
      )
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
        value = round(c(x_brush_1, x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values",
        label = NULL,
        value = round(c(input$map_brush1[[3]], input$map_brush1[[4]]), digits = 2)
      )
    }
  })
  
  # Map projection center hidden/show
  observeEvent(input$projection, {
    if (input$projection == "Orthographic") {
      shinyjs::show("hidden_map_center")
    } else {
      shinyjs::hide("hidden_map_center")
    }
  })
  
  observeEvent(input$projection2, {
    if (input$projection2 == "Orthographic") {
      shinyjs::show("hidden_map_center2")
    } else {
      shinyjs::hide("hidden_map_center2")
    }
  })
  
  observeEvent(input$projection3, {
    if (input$projection3 == "Orthographic") {
      shinyjs::show("hidden_map_center3")
    } else {
      shinyjs::hide("hidden_map_center3")
    }
  })

  observeEvent(input$projection_reg_coeff, {
    if (input$projection_reg_coeff == "Orthographic") {
      shinyjs::show("hidden_map_center_reg_coeff")
    } else {
      shinyjs::hide("hidden_map_center_reg_coeff")
    }
  })
  
  observeEvent(input$projection_reg_pval, {
    if (input$projection_reg_pval == "Orthographic") {
      shinyjs::show("hidden_map_center_reg_pval")
    } else {
      shinyjs::hide("hidden_map_center_reg_pval")
    }
  })
  
  observeEvent(input$projection_reg_res, {
    if (input$projection_reg_res == "Orthographic") {
      shinyjs::show("hidden_map_center_reg_res")
    } else {
      shinyjs::hide("hidden_map_center_reg_res")
    }
  })
  
  # Map custom points selector
  observeEvent(input$map_dblclick1,{
    dblclick <- input$map_dblclick1
    
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
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
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
  
  
  
  
  
  
  # REGRESSION TS point/line setter
  observeEvent(input$ts_click4,{
    if (input$custom_features_ts4 == TRUE){
      if (input$feature_ts4 == "Point"){
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "point_location_x_ts4",
          label = NULL,
          value = as.character(round(input$ts_click4$x, digits = 2))
        )
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "point_location_y_ts4",
          label = NULL,
          value = as.character(round(input$ts_click4$y, digits = 2))
        )
      } 
      else if (input$feature_ts4 == "Line"){
        updateRadioButtons(
          session = getDefaultReactiveDomain(),
          inputId = "line_orientation_ts4",
          label = NULL,
          selected = "Vertical")
        
        updateTextInput(
          session = getDefaultReactiveDomain(),
          inputId = "line_position_ts4",
          label = NULL,
          value = as.character(round(input$ts_click4$x, digits = 2))
        )
      }
    }
  })
  
  observeEvent(input$ts_dblclick4,{
    if (input$custom_features_ts4 == TRUE & input$feature_ts4 == "Line"){
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "line_orientation_ts4",
        label = NULL,
        selected = "Horizontal")
      
      updateTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "line_position_ts4",
        label = NULL,
        value = as.character(round(input$ts_dblclick4$y, digits = 2))
      )
    }
  })
  
  # TS highlight setter
  observeEvent(input$ts_brush4,{
    if (input$custom_features_ts4 == TRUE & input$feature_ts4 == "Highlight"){
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_x_values_ts4",
        label = NULL,
        value = round(c(input$ts_brush4[[1]],input$ts_brush4[[2]]), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values_ts4",
        label = NULL,
        value = round(c(input$ts_brush4[[3]],input$ts_brush4[[4]]), digits = 2))
    }
  })
  
  
  ####### Initialise and update custom points lines highlights ----
  
  map_points_data = reactiveVal(data.frame())
  map_highlights_data = reactiveVal(data.frame())
  
  ts_points_data = reactiveVal(data.frame())
  ts_highlights_data = reactiveVal(data.frame())
  ts_lines_data = reactiveVal(data.frame())
  
  # Map Points
  observeEvent(input$add_point, {
    new_points <- create_new_points_data(
      input$point_location_x,
      input$point_location_y,
      input$point_label,
      input$point_shape,
      input$point_colour,
      input$point_size
    )
    
    if (input$projection != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat, input$center_lon),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data(rbind(map_points_data(), new_points))
  })
  
  observeEvent(input$remove_last_point, {
    map_points_data(map_points_data()[-nrow(map_points_data()), ])
  })
  
  observeEvent(input$remove_all_points, {
    map_points_data(data.frame())
  })
  
  # Map Highlights
  observeEvent(input$add_highlight, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values,
      input$highlight_y_values,
      input$highlight_colour,
      input$highlight_type,
      NA,
      NA
    )
    
    if (input$projection != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat, input$center_lon),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data(rbind(map_highlights_data(), new_highlight))
  })
  
  observeEvent(input$remove_last_highlight, {
    map_highlights_data(map_highlights_data()[-nrow(map_highlights_data()), ])
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
    ts_highlights_data(rbind(
      ts_highlights_data(),
      create_new_highlights_data(
        input$highlight_x_values_ts,
        input$highlight_y_values_ts,
        input$highlight_colour_ts,
        input$highlight_type_ts,
        input$show_highlight_on_legend_ts,
        input$highlight_label_ts
      )
    ))
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
  
  ####### Generate Metadata for map customization ----
  
  #Prepare Download MAP
  
  metadata_inputs <- reactive({
    generate_metadata_anomalies(
      
      # Common / input data
      range_years         = input$range_years,
      dataset_selected    = input$dataset_selected,
      range_latitude      = input$range_latitude,
      range_longitude     = input$range_longitude,
      range_months        = input$range_months,
      ref_period_sg       = input$ref_period_sg,
      ref_period          = input$ref_period,
      ref_single_year     = input$ref_single_year,
      season_selected     = input$season_selected,
      variable_selected   = input$variable_selected,
      single_year         = input$single_year,
      range_years_sg      = input$range_years_sg,
      axis_input          = input$axis_input,
      axis_mode           = input$axis_mode,
      
      # Map settings
      center_lat               = input$center_lat,
      center_lon               = input$center_lon,
      custom_map               = input$custom_map,
      custom_topo              = input$custom_topo,
      download_options         = input$download_options,
      file_type_map_sec        = input$file_type_map_sec,
      file_type_map            = input$file_type_map,
      file_type_timeseries     = input$file_type_timeseries,
      hide_axis                = input$hide_axis,
      hide_borders             = input$hide_borders,
      label_lakes              = input$label_lakes,
      label_mountains          = input$label_mountains,
      label_rivers             = input$label_rivers,
      projection               = input$projection,
      ref_map_mode             = input$ref_map_mode,
      sd_ratio                 = input$sd_ratio,
      show_lakes               = input$show_lakes,
      show_mountains           = input$show_mountains,
      show_rivers              = input$show_rivers,
      title_mode               = input$title_mode,
      title_size_input         = input$title_size_input,
      title1_input             = input$title1_input,
      title2_input             = input$title2_input,
      white_land               = input$white_land,
      white_ocean              = input$white_ocean,
      custom_statistic         = input$custom_statistic,
      enable_custom_statistics = input$enable_custom_statistics,
      
      # Time series plot inputs
      axis_input_ts                = NA,
      axis_mode_ts                = NA,
      custom_ts                   = NA,
      download_options_ts         = NA,
      enable_custom_statistics_ts = NA,
      key_position_ts             = NA,
      show_key_ts                 = NA,
      show_ticks_ts               = NA,
      title_mode_ts               = NA,
      title_size_input_ts         = NA,
      title1_input_ts             = NA,
      xaxis_numeric_interval_ts   = NA,
      custom_percentile_ts        = NA,
      percentile_ts               = NA,
      show_ref_ts                 = NA,
      custom_average_ts           = NA,
      moving_percentile_ts        = NA,
      year_moving_ts              = NA,
      
      # Reactive Values
      plotOrder            = character(0),
      availableLayers      = character(0),
      lonlat_vals          = lonlat_vals()
    )
  })
  
  #Download MAP
  output$download_metadata <- downloadHandler(
    filename = function() {"metadata.xlsx"},
    
    content  = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      
      points <- map_points_data()
      if (!is.null(points) && nrow(points) > 0) openxlsx::writeData(wb, "custom_points", points)
      
      highlights <- map_highlights_data()
      if (!is.null(highlights) && nrow(highlights) > 0) openxlsx::writeData(wb, "custom_highlights", highlights)
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload MAP
  observeEvent(input$update_metadata, {
    req(input$upload_metadata)
    
    file_path <- input$upload_metadata$datapath
    file_name <- input$upload_metadata$name
    
    # Check that the uploaded file is named "metadata.xlsx"
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata") {
      
      process_uploaded_metadata(
        file_path           = file_path,
        mode                = "map",
        metadata_sheet      = "custom_meta",
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        rv_plotOrder        = plotOrder,
        rv_availableLayers  = availableLayers,
        rv_lonlat_vals      = lonlat_vals,
        map_points_data     = map_points_data,
        map_highlights_data = map_highlights_data,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  #Prepare Download TS
  metadata_inputs_ts <- reactive({
    generate_metadata_anomalies(
      
      # Common / input data
      range_years         = input$range_years,
      dataset_selected    = input$dataset_selected,
      range_latitude      = input$range_latitude,
      range_longitude     = input$range_longitude,
      range_months        = input$range_months,
      ref_period_sg       = input$ref_period_sg,
      ref_period          = input$ref_period,
      ref_single_year     = input$ref_single_year,
      season_selected     = input$season_selected,
      variable_selected   = input$variable_selected,
      single_year         = input$single_year,
      range_years_sg      = input$range_years_sg,
      axis_input          = input$axis_input,
      axis_mode           = input$axis_mode,
      
      # Map settings
      center_lat               = NA,
      center_lon               = NA,
      custom_map               = NA,
      custom_topo              = NA,
      download_options         = NA,
      file_type_map_sec        = NA,
      file_type_map            = NA,
      hide_axis                = NA,
      hide_borders             = NA,
      label_lakes              = NA,
      label_mountains          = NA,
      label_rivers             = NA,
      projection               = NA,
      ref_map_mode             = NA,
      sd_ratio                 = NA,
      show_lakes               = NA,
      show_mountains           = NA,
      show_rivers              = NA,
      title_mode               = NA,
      title_size_input         = NA,
      title1_input             = NA,
      title2_input             = NA,
      white_land               = NA,
      white_ocean              = NA,
      custom_statistic         = NA,
      enable_custom_statistics = NA,
      
      # Time series plot inputs
      axis_input_ts              = input$axis_input_ts,
      axis_mode_ts               = input$axis_mode_ts,
      custom_ts                  = input$custom_ts,
      download_options_ts        = input$download_options_ts,
      enable_custom_statistics_ts = input$enable_custom_statistics_ts,
      file_type_timeseries       = input$file_type_timeseries,
      key_position_ts            = input$key_position_ts,
      show_key_ts                = input$show_key_ts,
      show_ticks_ts              = input$show_ticks_ts,
      title_mode_ts              = input$title_mode_ts,
      title_size_input_ts        = input$title_size_input_ts,
      title1_input_ts            = input$title1_input_ts,
      xaxis_numeric_interval_ts  = input$xaxis_numeric_interval_ts,
      custom_percentile_ts       = input$custom_percentile_ts,
      percentile_ts              = input$percentile_ts,
      show_ref_ts                = input$show_ref_ts,
      custom_average_ts          = input$custom_average_ts,
      moving_percentile_ts       = input$moving_percentile_ts,
      year_moving_ts             = input$year_moving_ts,
      
      # Reactive Values / DFs
      plotOrder            = NA,
      availableLayers      = NA,
      lonlat_vals          = lonlat_vals()
    )
  })
  
  # Download TS Anomalies Metadata
  output$download_metadata_ts <- downloadHandler(
    filename = function() {"metadata_ts.xlsx"},
    content  = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      openxlsx::addWorksheet(wb, "custom_lines")
      
      meta <- isolate(metadata_inputs_ts())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      
      points     <- ts_points_data()
      if (!is.null(points) && nrow(points) > 0) openxlsx::writeData(wb, "custom_points", points)
      
      highlights <- ts_highlights_data()
      if (!is.null(highlights) && nrow(highlights) > 0) openxlsx::writeData(wb, "custom_highlights", highlights)
      
      lines      <- ts_lines_data()
      if (!is.null(lines) && nrow(lines) > 0) openxlsx::writeData(wb, "custom_lines", lines)
      
      openxlsx::saveWorkbook(wb, file)
    }
  )

  # Upload TS Anomalies Metadata
  observeEvent(input$update_metadata_ts, {
    req(input$upload_metadata_ts)
    
    file_path <- input$upload_metadata_ts$datapath
    file_name <- input$upload_metadata_ts$name  # This gets the original uploaded file name
    
    # Check that the uploaded file name matches expectation
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_ts") {
      
      # Proceed with processing
      process_uploaded_metadata(
        file_path           = file_path,
        mode                = "ts",
        metadata_sheet      = "custom_meta",
        df_ts_points        = "custom_points",
        df_ts_highlights    = "custom_highlights",
        df_ts_lines         = "custom_lines",
        df_map_points       = NULL,
        df_map_highlights   = NULL,
        rv_plotOrder        = NULL,
        rv_availableLayers  = NULL,
        rv_lonlat_vals      = lonlat_vals,
        map_points_data     = NULL,
        map_highlights_data = NULL,
        ts_points_data      = ts_points_data,
        ts_highlights_data  = ts_highlights_data,
        ts_lines_data       = ts_lines_data
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_ts.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  ####### Generate Layer Options for customization ----
  
  ####### Reactive values
  plotOrder <- reactiveVal(character(0))        # full paths
  availableLayers <- reactiveVal(character(0))  # file names
 
  ####### Helper: extract and load shapefiles
  updatePlotOrder <- function(zipFile, plotOrder, availableLayers) {
    temp_dir <- tempfile(pattern = "anomaly_")
    dir.create(temp_dir)
    unzip(zipFile, exdir = temp_dir)
    
    shpFiles <- list.files(temp_dir, pattern = "\\.shp$", full.names = TRUE)
    layer_names <- tools::file_path_sans_ext(basename(shpFiles))
    
    plotOrder(shpFiles)
    availableLayers(layer_names)
  }
  
  ####### Trigger update on file upload
  observeEvent(input$shpFile, {
    req(input$shpFile)
    updatePlotOrder(
      zipFile = input$shpFile$datapath,
      plotOrder = plotOrder,
      availableLayers = availableLayers
    )
  })

  ####### Shape File Renderer
  output$shapefileSelector <- renderUI({
    req(availableLayers())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes",
      label = "Select and order shapefiles (drag & drop)",
      choices = availableLayers()
    )
  })
  
 ####### Dynamic color pickers for selected shapefiles
  output$colorpickers <- renderUI({
    req(input$shapes, input$shapes_order, plotOrder())
    selected_ordered <- input$shapes_order[input$shapes_order %in% input$shapes]
    shp_files <- plotOrder()[match(selected_ordered, tools::file_path_sans_ext(basename(plotOrder())))]
    
    pickers <- lapply(shp_files, function(file) {
      file_name <- tools::file_path_sans_ext(basename(file))
      input_id <- paste0("shp_colour_", file_name)
      last_val <- isolate(input[[input_id]])  # <-- Get the current color if set, otherwise NULL
      colourInput(
        inputId = input_id,
        label   = paste("Border Color for", file_name),
        value   = if (!is.null(last_val)) last_val else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers)
  })
  
  
  ### COMPOSITES observe, update & interactive controls ----
  
  ####### Input updaters ----
  
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
  
  observeEvent(input$projection2, { # also update to global if projection is changed
    if (input$projection2 != "UTM (default)") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = c(-180, 180))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = c(-90, 90))
      lonlat_vals2(c(-180, 180, -90, 90))
    }
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
  
  # Composite Axis values updater MAP
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
        value = set_axis_values(data_input = map_data_2(), mode = input$mode_selected2))
    }
  })
  
  # Composite Axis values updater TS
  observe({
    if (input$axis_mode_ts2 == "Automatic"){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts2",
        value = c(NA,NA))
    }
  })
  
  observe({
    if (input$axis_mode_ts2 == "Fixed" & is.null(input$axis_input_ts2)){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts2",
        value = set_ts_axis_values(data_input = timeseries_data_2()$Mean))
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
  
  
  ####### Interactivity ----
  
  # Input geo-coded locations
  observeEvent(input$search2, {
    location2 <- input$location2
    if (!is.null(location2) && nchar(location2) > 0) {
      location_encoded2 <- URLencode(location2)
      
      projection <- input$projection2
      result <- NULL
      
      if (projection == "UTM (default)") {
        result <- geocode_OSM(location_encoded2)
      } else if (projection == "Robinson") {
        result <- geocode_OSM(location_encoded2, projection = "+proj=robin")
      } else if (projection == "Orthographic") {
        result <- geocode_OSM(location_encoded2,
                              projection = ortho_proj(input$center_lat2, input$center_lon2))
      } else if (projection == "LAEA") {
        result <- geocode_OSM(location_encoded2, projection = laea_proj)
      }
      
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
    
    x_brush_1 = input$map_brush2[[1]]
    x_brush_2 = input$map_brush2[[2]]
    
    if (input$custom_features2 == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude2",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude2",
        label = NULL,
        value = round(c(input$map_brush2[[3]], input$map_brush2[[4]]), digits = 2)
      )
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
        value = round(c(x_brush_1, x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values2",
        label = NULL,
        value = round(c(input$map_brush2[[3]], input$map_brush2[[4]]), digits = 2)
      )
    }
  })
  
  # Map custom points selector
  observeEvent(input$map_dblclick2,{
    dblclick <- input$map_dblclick2
    
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
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y2",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
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
  
  
  ####### Initialise and update custom points lines highlights ----
  map_points_data2 = reactiveVal(data.frame())
  map_highlights_data2 = reactiveVal(data.frame())
  
  ts_points_data2 = reactiveVal(data.frame())
  ts_highlights_data2 = reactiveVal(data.frame())
  ts_lines_data2 = reactiveVal(data.frame())
  
  observeEvent(input$add_point2, {
    new_points <- create_new_points_data(
      input$point_location_x2,
      input$point_location_y2,
      input$point_label2,
      input$point_shape2,
      input$point_colour2,
      input$point_size2
    )
    
    if (input$projection2 != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection2,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat2, input$center_lon2),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data2(rbind(map_points_data2(), new_points))
  })
  
  
  observeEvent(input$remove_last_point2, {
    map_points_data2(map_points_data2()[-nrow(map_points_data2()),])
  })
  
  observeEvent(input$remove_all_points2, {
    map_points_data2(data.frame())
  })
  
  # Map Highlights
  observeEvent(input$add_highlight2, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values2,
      input$highlight_y_values2,
      input$highlight_colour2,
      input$highlight_type2,
      NA,
      NA
    )
    
    print(new_highlight)  # check what coords and columns look like
    
    if (input$projection2 != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection2,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat2, input$center_lon2),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data2(rbind(map_highlights_data2(), new_highlight))
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
    ts_highlights_data2(rbind(
      ts_highlights_data2(),
      create_new_highlights_data(
        input$highlight_x_values_ts2,
        input$highlight_y_values_ts2,
        input$highlight_colour_ts2,
        input$highlight_type_ts2,
        input$show_highlight_on_legend_ts2,
        input$highlight_label_ts2
      )
    ))
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
  
  ####### Generate Metadata for map customization ----
  
  #Prepare Download
  metadata_inputs_composite <- reactive({
    generate_metadata_composite(
      # Shared
      range_years2         = input$range_years2,
      range_years2a        = input$range_years2a,
      dataset_selected2    = input$dataset_selected2,
      range_latitude2      = input$range_latitude2,
      range_longitude2     = input$range_longitude2,
      range_months2        = input$range_months2,
      ref_period_sg2       = input$ref_period_sg2,
      ref_period2          = input$ref_period2,
      ref_single_year2     = input$ref_single_year2,
      season_selected2     = input$season_selected2,
      variable_selected2   = input$variable_selected2,
      enter_upload2        = input$enter_upload2,
      enter_upload2a       = input$enter_upload2a,
      mode_selected2       = input$mode_selected2,
      prior_years2         = input$prior_years2,
      
      # Map settings
      axis_input2               = input$axis_input2,
      axis_mode2                = input$axis_mode2,
      center_lat2               = input$center_lat2,
      center_lon2               = input$center_lon2,
      custom_map2               = input$custom_map2,
      custom_statistic2         = input$custom_statistic2,
      custom_topo2              = input$custom_topo2,
      download_options2         = input$download_options2,
      enable_custom_statistics2 = input$enable_custom_statistics2,
      file_type_map_sec2        = input$file_type_map_sec2,
      file_type_map2            = input$file_type_map2,
      file_type_timeseries2     = input$file_type_timeseries2,
      hide_axis2                = input$hide_axis2,
      hide_borders2             = input$hide_borders2,
      label_lakes2              = input$label_lakes2,
      label_mountains2          = input$label_mountains2,
      label_rivers2             = input$label_rivers2,
      percentage_sign_match2    = input$percentage_sign_match2,
      projection2               = input$projection2,
      ref_map_mode2             = input$ref_map_mode2,
      sd_ratio2                 = input$sd_ratio2,
      show_lakes2               = input$show_lakes2,
      show_mountains2           = input$show_mountains2,
      show_rivers2              = input$show_rivers2,
      title_mode2               = input$title_mode2,
      title_size_input2         = input$title_size_input2,
      title1_input2             = input$title1_input2,
      title2_input2             = input$title2_input2,
      white_land2               = input$white_land2,
      white_ocean2              = input$white_ocean2,
      
      # TS section not needed here
      axis_input_ts2                = NA,
      axis_mode_ts2                = NA,
      custom_percentile_ts2        = NA,
      custom_ts2                   = NA,
      download_options_ts2         = NA,
      enable_custom_statistics_ts2 = NA,
      key_position_ts2             = NA,
      percentile_ts2               = NA,
      show_key_ts2                 = NA,
      show_ref_ts2                 = NA,
      show_ticks_ts2               = NA,
      title_mode_ts2               = NA,
      title_size_input_ts2         = NA,
      title1_input_ts2             = NA,
      xaxis_numeric_interval_ts2   = NA,
      
      # Reac values
      plotOrder            = character(0),
      availableLayers      = character(0),
      lonlat_vals          = lonlat_vals2()
    )
  })
  
  # Download Composite Map Metadata
  output$download_metadata2 <- downloadHandler(
    filename = function() {"metadata_composite.xlsx"},
    content  = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs_composite())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      
      if (nrow(map_points_data2()) > 0) openxlsx::writeData(wb, "custom_points", map_points_data2())
      if (nrow(map_highlights_data2()) > 0) openxlsx::writeData(wb, "custom_highlights", map_highlights_data2())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Composite Map Metadata
  observeEvent(input$update_metadata2, {
    req(input$upload_metadata2)
    
    file_path <- input$upload_metadata2$datapath
    file_name <- input$upload_metadata2$name
    
    # Check that the uploaded file is named "metadata_composite.xlsx"
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_composite") {
      
      process_uploaded_metadata_composite(
        file_path           = file_path,
        metadata_sheet      = "custom_meta",
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        rv_plotOrder        = plotOrder2,
        rv_availableLayers  = availableLayers2,
        rv_lonlat_vals      = lonlat_vals2,
        map_points_data     = map_points_data2,
        map_highlights_data = map_highlights_data2,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_composite.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  
  
  #Prepare TS Download
  metadata_inputs_composite_ts <- reactive({
    generate_metadata_composite(
      # Shared
      range_years2         = input$range_years2,
      range_years2a        = input$range_years2a,
      dataset_selected2    = input$dataset_selected2,
      range_latitude2      = input$range_latitude2,
      range_longitude2     = input$range_longitude2,
      range_months2        = input$range_months2,
      ref_period_sg2       = input$ref_period_sg2,
      ref_period2          = input$ref_period2,
      ref_single_year2     = input$ref_single_year2,
      season_selected2     = input$season_selected2,
      variable_selected2   = input$variable_selected2,
      enter_upload2        = input$enter_upload2,
      enter_upload2a       = input$enter_upload2a,
      mode_selected2       = input$mode_selected2,
      prior_years2         = input$prior_years2,
      
      # Map section not needed here
      axis_input2               = NA,
      axis_mode2                = NA,
      center_lat2               = NA,
      center_lon2               = NA,
      custom_map2               = NA,
      custom_statistic2         = NA,
      custom_topo2              = NA,
      download_options2         = NA,
      enable_custom_statistics2 = NA,
      file_type_map_sec2        = NA,
      file_type_map2            = NA,
      file_type_timeseries2     = NA,
      hide_axis2                = NA,
      hide_borders2             = NA,
      label_lakes2              = NA,
      label_mountains2          = NA,
      label_rivers2             = NA,
      percentage_sign_match2    = NA,
      projection2               = NA,
      ref_map_mode2             = NA,
      sd_ratio2                 = NA,
      show_lakes2               = NA,
      show_mountains2           = NA,
      show_rivers2              = NA,
      title_mode2               = NA,
      title_size_input2         = NA,
      title1_input2             = NA,
      title2_input2             = NA,
      white_land2               = NA,
      white_ocean2              = NA,
      
      # TS inputs
      axis_input_ts2                = input$axis_input_ts2,
      axis_mode_ts2                = input$axis_mode_ts2,
      custom_percentile_ts2        = input$custom_percentile_ts2,
      custom_ts2                   = input$custom_ts2,
      download_options_ts2         = input$download_options_ts2,
      enable_custom_statistics_ts2 = input$enable_custom_statistics_ts2,
      key_position_ts2             = input$key_position_ts2,
      percentile_ts2               = input$percentile_ts2,
      show_key_ts2                 = input$show_key_ts2,
      show_ref_ts2                 = input$show_ref_ts2,
      show_ticks_ts2               = input$show_ticks_ts2,
      title_mode_ts2               = input$title_mode_ts2,
      title_size_input_ts2         = input$title_size_input_ts2,
      title1_input_ts2             = input$title1_input_ts2,
      xaxis_numeric_interval_ts2   = input$xaxis_numeric_interval_ts2,
      
      # Reac values
      plotOrder           = NULL,
      availableLayers     = NULL,
      lonlat_vals         = lonlat_vals2()
    )
  })
  
  # Download Composite TS Metadata
  output$download_metadata_ts2 <- downloadHandler(
    filename = function() {"metadata_composite_ts.xlsx"},
    content  = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      openxlsx::addWorksheet(wb, "custom_lines")
      
      meta <- isolate(metadata_inputs_composite_ts())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      
      if (nrow(ts_points_data2()) > 0) openxlsx::writeData(wb, "custom_points", ts_points_data2())
      if (nrow(ts_highlights_data2()) > 0) openxlsx::writeData(wb, "custom_highlights", ts_highlights_data2())
      if (nrow(ts_lines_data2()) > 0) openxlsx::writeData(wb, "custom_lines", ts_lines_data2())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Composite TS Metadata
  observeEvent(input$update_metadata_ts2, {
    req(input$upload_metadata_ts2)
    
    file_path <- input$upload_metadata_ts2$datapath
    file_name <- input$upload_metadata_ts2$name
    
    # Check that the uploaded file is named "metadata_composite_ts.xlsx"
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_composite_ts") {
      
      process_uploaded_metadata_composite(
        file_path           = file_path,
        metadata_sheet      = "custom_meta",
        df_ts_points        = "custom_points",
        df_ts_highlights    = "custom_highlights",
        df_ts_lines         = "custom_lines",
        df_map_points       = NULL,
        df_map_highlights   = NULL,
        rv_plotOrder        = NULL,
        rv_availableLayers  = NULL,
        rv_lonlat_vals      = lonlat_vals2,
        map_points_data     = NULL,
        map_highlights_data = NULL,
        ts_points_data      = ts_points_data2,
        ts_highlights_data  = ts_highlights_data2,
        ts_lines_data       = ts_lines_data2
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_composite_ts.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  
  ####### Generate Layer Options for customization ----
  
  ### Reactive values
  plotOrder2 <- reactiveVal(character(0))        # full paths
  availableLayers2 <- reactiveVal(character(0))  # file names
  
  # Helper: extract and load shapefiles
  updatePlotOrder2 <- function(zipFile2, plotOrder2, availableLayers2) {
    temp_dir2 <- tempfile(pattern = "composite_")
    dir.create(temp_dir2)
    unzip(zipFile2, exdir = temp_dir2)
    
    shpFiles2 <- list.files(temp_dir2, pattern = "\\.shp$", full.names = TRUE)
    layer_names2 <- tools::file_path_sans_ext(basename(shpFiles2))
    
    plotOrder2(shpFiles2)
    availableLayers2(layer_names2)
  }
  
  # Trigger update on file upload
  observeEvent(input$shpFile2, {
    req(input$shpFile2)
    updatePlotOrder2(
      zipFile2 = input$shpFile2$datapath,
      plotOrder2 = plotOrder2,
      availableLayers2 = availableLayers2
    )
  })
  
  # Shape File Renderer
  output$shapefileSelector2 <- renderUI({
    req(availableLayers2())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes2",
      label = "Select and order shapefiles (drag & drop)",
      choices = availableLayers2()
    )
  })
  
  # Dynamic color pickers for selected shapefiles
  output$colorpickers2 <- renderUI({
    req(input$shapes2, input$shapes2_order, plotOrder2())
    selected_ordered2 <- input$shapes2_order[input$shapes2_order %in% input$shapes2]
    shp_files2 <- plotOrder2()[match(selected_ordered2, tools::file_path_sans_ext(basename(plotOrder2())))]
    
    pickers2 <- lapply(shp_files2, function(file2) {
      file_name2 <- tools::file_path_sans_ext(basename(file2))
      input_id2 <- paste0("shp_colour2_", file_name2)
      last_val2 <- isolate(input[[input_id2]])
      colourInput(
        inputId = input_id2,
        label   = paste("Border Color for", file_name2),
        value   = if (!is.null(last_val2)) last_val2 else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers2)
  })
  
  
  ### CORRELATION observe, update & interactive controls ----
  
  ####### Input updaters ----
  
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
    if ((input$source_v1 == "User Data") |
        (((
          input$range_longitude_v1[2] - input$range_longitude_v1[1]
        ) < 4) &
        ((
          input$range_latitude_v1[2] - input$range_latitude_v1[1] < 4
        )))) {
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "type_v1",
        label = NULL,
        choices = c("Timeseries"),
        selected =  "Timeseries"
      )
      
    } else {
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "type_v1",
        label = NULL,
        choices  = c("Field", "Timeseries"),
        selected = selected_type_v1,
        inline = TRUE
      )
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
  
  # Update correlation year range and check lag is still within limits
  observe({
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "lagyears_v1_cor",
      max = year_range_cor()[4]-input$range_years3[2],
      min = year_range_cor()[3]-input$range_years3[1]
    )
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "lagyears_v2_cor",
      max = year_range_cor()[6]-input$range_years3[2],
      min = year_range_cor()[5]-input$range_years3[1]
    )
  })

  observeEvent({
    input$source_v1
    input$source_v2
    year_range_cor()
  }, {
    req(year_range_cor(), length(year_range_cor()) >= 2)
    
    if (input$source_v1 == "User Data" || input$source_v2 == "User Data") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_years3",
        label = paste("Select the range of years (", year_range_cor()[1], "-", year_range_cor()[2], ")"),
        value = year_range_cor()[1:2]
      )
    }
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
  
  # Update to global if projection is changed
  observeEvent(input$projection_v1, {
    if (input$projection_v1 != "UTM (default)" & (lonlat_vals_v1() != c(-180,180,-90,90) | lonlat_vals_v2 != c(-180,180,-90,90)) & (input$type_v1 == "Field" & input$type_v2 == "Field")) {
      # create a pop up message and with button selection
      showModal(modalDialog(
        title = "Action required",
        "Changing the projection will reset the map area to global. This requires a V1 or V2 to be global. Which do you want to change?",
        footer = tagList(
          actionButton("v1", "V1"),
          actionButton("v1", "V2")
        )
      ))
      
      
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
  
  # Correlation axis values updater Map
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
        value = set_axis_values(data_input = correlation_map_data()[[3]], mode = "Anomaly"))
    }
  })
  
  # Correlation Axis values updater TS
  observe({
    if (input$axis_mode_ts3 == "Automatic"){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts3",
        value = c(NA,NA))
    }
  })
  
  observe({
    if (input$axis_mode_ts3 == "Fixed" & is.null(input$axis_input_ts3)){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts3",
        value = set_ts_axis_values(data_input = timeseries_data_v1()$Mean))
    }
  })
  
  # Update ts/map correlation method
  observeEvent(input$cor_method_ts, {
    updateRadioButtonsGroup(
      input$cor_method_ts,
      c("cor_method_ts", "cor_method_map", "cor_method_map_data")
    )
  })
  
  observeEvent(input$cor_method_map, {
    updateRadioButtonsGroup(
      input$cor_method_map,
      c("cor_method_ts", "cor_method_map", "cor_method_map_data")
    )
  })
  
  observeEvent(input$cor_method_map_data, {
    updateRadioButtonsGroup(
      input$cor_method_map_data,
      c("cor_method_ts", "cor_method_map", "cor_method_map_data")
    )
  })
  
  
  ####### Interactivity ----
  
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
    
    x_brush_1 = input$map_brush3[[1]]
    x_brush_2 = input$map_brush3[[2]]
    y_brush_1 = input$map_brush3[[3]]
    y_brush_2 = input$map_brush3[[4]]
    
    if (input$custom_features3 == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v2",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v2",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_v1",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_v1",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      

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
        value = round(c(x_brush_1, x_brush_2), digits = 2))

      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values3",
        label = NULL,
        value = round(c(input$map_brush3[[3]],input$map_brush3[[4]]), digits = 2))
    }
  })
  
  # Map custom points selector
  observeEvent(input$map_dblclick3,{
    dblclick <- input$map_dblclick3

    
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
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y3",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
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
  
  
  ####### Initialise and update custom points lines highlights ----
  
  map_points_data3 = reactiveVal(data.frame())
  map_highlights_data3 = reactiveVal(data.frame())
  
  ts_points_data3 = reactiveVal(data.frame())
  ts_highlights_data3 = reactiveVal(data.frame())
  ts_lines_data3 = reactiveVal(data.frame())
  
  # Map Points 3
  observeEvent(input$add_point3, {
    new_points <- create_new_points_data(
      input$point_location_x3,
      input$point_location_y3,
      input$point_label3,
      input$point_shape3,
      input$point_colour3,
      input$point_size3
    )
    
    if (input$projection3 != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection3,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat3, input$center_lon3),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data3(rbind(map_points_data3(), new_points))
  })
  
  observeEvent(input$remove_last_point3, {
    map_points_data3(map_points_data3()[-nrow(map_points_data3()), ])
  })
  
  observeEvent(input$remove_all_points3, {
    map_points_data3(data.frame())
  })
  
  # Map Highlights 3
  observeEvent(input$add_highlight3, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values3,
      input$highlight_y_values3,
      input$highlight_colour3,
      input$highlight_type3,
      NA,
      NA
    )
    
    if (input$projection3 != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection3,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat3, input$center_lon3),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data3(rbind(map_highlights_data3(), new_highlight))
  })
  
  observeEvent(input$remove_last_highlight3, {
    map_highlights_data3(map_highlights_data3()[-nrow(map_highlights_data3()), ])
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
  
  ####### Generate Metadata for map customization ----

  # Reactive metadata collector for Correlation Timeseries
  metadata_inputs_correlation_ts <- reactive({
    generate_metadata_correlation(
      # Shared
      range_years3         = input$range_years3,
      dataset_selected_v1  = input$dataset_selected_v1,
      dataset_selected_v2  = input$dataset_selected_v2,
      ME_variable_v1       = input$ME_variable_v1,
      ME_variable_v2       = input$ME_variable_v2,
      coordinates_type_v1  = input$coordinates_type_v1,
      coordinates_type_v2  = input$coordinates_type_v2,
      mode_selected_v1     = input$mode_selected_v1,
      mode_selected_v2     = input$mode_selected_v2,
      season_selected_v1   = input$season_selected_v1,
      season_selected_v2   = input$season_selected_v2,
      range_months_v1      = input$range_months_v1,
      range_months_v2      = input$range_months_v2,
      range_latitude_v1    = input$range_latitude_v1,
      range_latitude_v2    = input$range_latitude_v2,
      range_longitude_v1   = input$range_longitude_v1,
      range_longitude_v2   = input$range_longitude_v2,
      ref_period_sg_v1     = input$ref_period_sg_v1,
      ref_period_sg_v2     = input$ref_period_sg_v2,
      ref_period_v1        = input$ref_period_v1,
      ref_period_v2        = input$ref_period_v2,
      ref_single_year_v1   = input$ref_single_year_v1,
      ref_single_year_v2   = input$ref_single_year_v2,
      source_v1            = input$source_v1,
      source_v2            = input$source_v2,
      type_v1              = input$type_v1,
      type_v2              = input$type_v2,
      lagyears_v1_cor      = input$lagyears_v1_cor,
      lagyears_v2_cor      = input$lagyears_v2_cor,
      
      # Map section NA
      axis_input3                = NA,
      axis_mode3                 = NA,
      center_lat3                = NA,
      center_lon3                = NA,
      custom_map3                = NA,
      custom_topo3               = NA,
      download_options3          = NA,
      file_type_map3             = NA,
      file_type_map_sec3         = NA,
      hide_axis3                 = NA,
      hide_borders3              = NA,
      label_lakes3               = NA,
      label_mountains3           = NA,
      label_rivers3              = NA,
      projection3                = NA,
      ref_map_mode3              = NA,
      cor_method_map             = NA,
      cor_method_map_data        = NA,
      show_lakes3                = NA,
      show_mountains3            = NA,
      show_rivers3               = NA,
      title_mode3                = NA,
      title_size_input3          = NA,
      title1_input3              = NA,
      title2_input3              = NA,
      white_land3                = NA,
      white_ocean3               = NA,
      
      # TS inputs
      axis_input_ts3             = input$axis_input_ts3,
      axis_mode_ts3             = input$axis_mode_ts3,
      cor_method_ts             = input$cor_method_ts,
      custom_ts3                = input$custom_ts3,
      custom_ref_ts3            = input$custom_ref_ts3,
      custom_average_ts3        = input$custom_average_ts3,
      enable_custom_statistics_ts3 = input$enable_custom_statistics_ts3,
      download_options_ts3      = input$download_options_ts3,
      file_type_timeseries3     = input$file_type_timeseries3,
      key_position_ts3          = input$key_position_ts3,
      title_mode_ts3            = input$title_mode_ts3,
      title_size_input_ts3      = input$title_size_input_ts3,
      title1_input_ts3          = input$title1_input_ts3,
      xaxis_numeric_interval_ts3 = input$xaxis_numeric_interval_ts3,
      year_moving_ts3           = input$year_moving_ts3,
      add_outliers_ref_ts3      = input$add_outliers_ref_ts3,
      add_trend_ref_ts3         = input$add_trend_ref_ts3,
      show_key_ts3              = input$show_key_ts3,
      show_key_ref_ts3          = input$show_key_ref_ts3,
      show_ticks_ts3            = input$show_ticks_ts3,
      sd_input_ref_ts3          = input$sd_input_ref_ts3,
      trend_sd_input_ref_ts3    = input$trend_sd_input_ref_ts3,
      
      # Reactive values
      plotOrder       = NULL,
      availableLayers = NULL,
      lonlat_vals_v1 = lonlat_vals_v1(),
      lonlat_vals_v2 = lonlat_vals_v2()
    )
  })
  
  # Download Correlation TS Metadata
  output$download_metadata_ts3 <- downloadHandler(
    filename = function() { "metadata_correlation_ts.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      openxlsx::addWorksheet(wb, "custom_lines")
      
      meta <- isolate(metadata_inputs_correlation_ts())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(ts_points_data3()) > 0) openxlsx::writeData(wb, "custom_points", ts_points_data3())
      if (nrow(ts_highlights_data3()) > 0) openxlsx::writeData(wb, "custom_highlights", ts_highlights_data3())
      if (nrow(ts_lines_data3()) > 0) openxlsx::writeData(wb, "custom_lines", ts_lines_data3())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Correlation TS Metadata
  observeEvent(input$update_metadata_ts3, {
    req(input$upload_metadata_ts3)
    
    file_path <- input$upload_metadata_ts3$datapath
    file_name <- input$upload_metadata_ts3$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_correlation_ts") {
      
      process_uploaded_metadata_correlation(
        file_path           = file_path,
        mode                = "ts",
        metadata_sheet      = "custom_meta",
        df_ts_points        = "custom_points",
        df_ts_highlights    = "custom_highlights",
        df_ts_lines         = "custom_lines",
        df_map_points       = NULL,
        df_map_highlights   = NULL,
        rv_plotOrder        = NULL,
        rv_availableLayers  = NULL,
        rv_lonlat_vals_v1   = lonlat_vals_v1,
        rv_lonlat_vals_v2   = lonlat_vals_v2,
        map_points_data     = NULL,
        map_highlights_data = NULL,
        ts_points_data      = ts_points_data3,
        ts_highlights_data  = ts_highlights_data3,
        ts_lines_data       = ts_lines_data3
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_correlation_ts.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  
  # Reactive metadata collector for Correlation Map
  metadata_inputs_correlation <- reactive({
    generate_metadata_correlation(
      # Shared
      range_years3         = input$range_years3,
      dataset_selected_v1  = input$dataset_selected_v1,
      dataset_selected_v2  = input$dataset_selected_v2,
      ME_variable_v1       = input$ME_variable_v1,
      ME_variable_v2       = input$ME_variable_v2,
      coordinates_type_v1  = input$coordinates_type_v1,
      coordinates_type_v2  = input$coordinates_type_v2,
      mode_selected_v1     = input$mode_selected_v1,
      mode_selected_v2     = input$mode_selected_v2,
      season_selected_v1   = input$season_selected_v1,
      season_selected_v2   = input$season_selected_v2,
      range_months_v1      = input$range_months_v1,
      range_months_v2      = input$range_months_v2,
      range_latitude_v1    = input$range_latitude_v1,
      range_latitude_v2    = input$range_latitude_v2,
      range_longitude_v1   = input$range_longitude_v1,
      range_longitude_v2   = input$range_longitude_v2,
      ref_period_sg_v1     = input$ref_period_sg_v1,
      ref_period_sg_v2     = input$ref_period_sg_v2,
      ref_period_v1        = input$ref_period_v1,
      ref_period_v2        = input$ref_period_v2,
      ref_single_year_v1   = input$ref_single_year_v1,
      ref_single_year_v2   = input$ref_single_year_v2,
      source_v1            = input$source_v1,
      source_v2            = input$source_v2,
      type_v1              = input$type_v1,
      type_v2              = input$type_v2,
      lagyears_v1_cor      = input$lagyears_v1_cor,
      lagyears_v2_cor      = input$lagyears_v2_cor,
      
      # TS section NA
      axis_input_ts3              = NA,
      axis_mode_ts3               = NA,
      cor_method_ts               = NA,
      custom_ts3                  = NA,
      custom_ref_ts3              = NA,
      custom_average_ts3          = NA,
      enable_custom_statistics_ts3 = NA,
      download_options_ts3        = NA,
      file_type_timeseries3       = NA,
      key_position_ts3            = NA,
      title_mode_ts3              = NA,
      title_size_input_ts3        = NA,
      title1_input_ts3            = NA,
      xaxis_numeric_interval_ts3  = NA,
      year_moving_ts3             = NA,
      add_outliers_ref_ts3        = NA,
      add_trend_ref_ts3           = NA,
      show_key_ts3                = NA,
      show_key_ref_ts3            = NA,
      show_ticks_ts3              = NA,
      sd_input_ref_ts3            = NA,
      trend_sd_input_ref_ts3      = NA,
      
      # Map inputs
      axis_input3                 = input$axis_input3,
      axis_mode3                  = input$axis_mode3,
      center_lat3                 = input$center_lat3,
      center_lon3                 = input$center_lon3,
      custom_map3                 = input$custom_map3,
      custom_topo3                = input$custom_topo3,
      download_options3           = input$download_options3,
      file_type_map3              = input$file_type_map3,
      file_type_map_sec3          = input$file_type_map_sec3,
      hide_axis3                  = input$hide_axis3,
      hide_borders3               = input$hide_borders3,
      label_lakes3                = input$label_lakes3,
      label_mountains3            = input$label_mountains3,
      label_rivers3               = input$label_rivers3,
      projection3                 = input$projection3,
      ref_map_mode3               = input$ref_map_mode3,
      cor_method_map              = input$cor_method_map,
      cor_method_map_data         = input$cor_method_map_data,
      show_lakes3                 = input$show_lakes3,
      show_mountains3             = input$show_mountains3,
      show_rivers3                = input$show_rivers3,
      title_mode3                 = input$title_mode3,
      title_size_input3           = input$title_size_input3,
      title1_input3               = input$title1_input3,
      title2_input3               = input$title2_input3,
      white_land3                 = input$white_land3,
      white_ocean3                = input$white_ocean3,
      
      # Reactive values
      plotOrder       = character(0),
      availableLayers = character(0),
      lonlat_vals_v1 = lonlat_vals_v1(),
      lonlat_vals_v2 = lonlat_vals_v2()
    )
  })
  
  # Download Correlation Map Metadata
  output$download_metadata3 <- downloadHandler(
    filename = function() { "metadata_correlation.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs_correlation())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(map_points_data3()) > 0) openxlsx::writeData(wb, "custom_points", map_points_data3())
      if (nrow(map_highlights_data3()) > 0) openxlsx::writeData(wb, "custom_highlights", map_highlights_data3())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Correlation Map Metadata
  observeEvent(input$update_metadata3, {
    req(input$upload_metadata3)
    
    file_path <- input$upload_metadata3$datapath
    file_name <- input$upload_metadata3$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_correlation") {
      
      process_uploaded_metadata_correlation(
        file_path           = file_path,
        mode                = "map",
        metadata_sheet      = "custom_meta",
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        rv_plotOrder        = plotOrder3,
        rv_availableLayers  = availableLayers3,
        rv_lonlat_vals_v1   = lonlat_vals_v1,
        rv_lonlat_vals_v2   = lonlat_vals_v2,
        map_points_data     = map_points_data3,
        map_highlights_data = map_highlights_data3,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_correlation.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  ####### Generate Layer Options for customization ----
  
  # Reactive values
  plotOrder3 <- reactiveVal(character(0))        # full paths
  availableLayers3 <- reactiveVal(character(0))  # file names
  
  # Helper: extract and load shapefiles
  updatePlotOrder3 <- function(zipFile3, plotOrder3, availableLayers3) {
    temp_dir3 <- tempfile(pattern = "correlation_")
    dir.create(temp_dir3)
    unzip(zipFile3, exdir = temp_dir3)
    
    shpFiles3 <- list.files(temp_dir3, pattern = "\\.shp$", full.names = TRUE)
    layer_names3 <- tools::file_path_sans_ext(basename(shpFiles3))
    
    plotOrder3(shpFiles3)
    availableLayers3(layer_names3)
  }
  
  # Trigger update on file upload
  observeEvent(input$shpFile3, {
    req(input$shpFile3)
    updatePlotOrder3(
      zipFile3 = input$shpFile3$datapath,
      plotOrder3 = plotOrder3,
      availableLayers3 = availableLayers3
    )
  })
  
  # Shape File Renderer for correlation set
  output$shapefileSelector3 <- renderUI({
    req(availableLayers3())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes3",
      label = "Select and order shapefiles for Correlation (drag & drop)",
      choices = availableLayers3()
    )
  })
  
  # Dynamic color pickers for selected correlation shapefiles
  output$colorpickers3 <- renderUI({
    req(input$shapes3, input$shapes3_order, plotOrder3())
    selected_ordered3 <- input$shapes3_order[input$shapes3_order %in% input$shapes3]
    shp_files3 <- plotOrder3()[match(selected_ordered3, tools::file_path_sans_ext(basename(plotOrder3())))]
    
    pickers3 <- lapply(shp_files3, function(file3) {
      file_name3 <- tools::file_path_sans_ext(basename(file3))
      input_id3 <- paste0("shp_colour3_", file_name3)
      last_val3 <- isolate(input[[input_id3]])
      colourInput(
        inputId = input_id3,
        label   = paste("Border Color for", file_name3),
        value   = if (!is.null(last_val3)) last_val3 else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers3)
  })
  
  
  ### REGRESSION observe, update & interactive controls ----
  
  ####### Input updaters ----
  
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
  observeEvent({
    input$source_iv
    input$source_dv
    year_range_reg()
  }, {
    req(year_range_reg(), length(year_range_reg()) >= 4)
    
    if (input$source_iv == "User Data" || input$source_dv == "User Data") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_years4",
        label = paste("Select the range of years (", year_range_reg()[3], "-", year_range_reg()[4], ")"),
        value = year_range_reg()[1:2]
      )
    }
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
  
  # Regression Trend Axis values updater TS
  observe({
    if (input$axis_mode_ts4a == "Automatic") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts4a",
        value = c(NA, NA)
      )
    }
  })

  observe({
    if (input$axis_mode_ts4a == "Fixed" && is.null(input$axis_input_ts4a)) {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts4a",
        value = set_ts_axis_values(data_input = regression_ts_data()[,2])  # Original
      )
    }
  })

  # Regression Residual Axis values updater TS
  observe({
    if (input$axis_mode_ts4b == "Automatic") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts4b",
        value = c(NA, NA)
      )
    }
  })

  observe({
    if (input$axis_mode_ts4b == "Fixed" && is.null(input$axis_input_ts4b)) {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_ts4b",
        value = set_ts_axis_values(data_input = regression_ts_data()[,4])  # Residuals
      )
    }
  })
  
  ####### Interactivity ----
  # Map custom points selector regression coefficient
  observeEvent(input$map_dblclick_reg_coeff, {
    dblclick <- input$map_dblclick_reg_coeff
    
    updateCheckboxInput(
      session = getDefaultReactiveDomain(),
      inputId = "custom_features_reg_coeff",
      label = NULL,
      value = TRUE
    )
    
    updateRadioButtons(
      session = getDefaultReactiveDomain(),
      inputId = "feature_reg_coeff",
      label = NULL,
      selected = "Point"
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_x_reg_coeff",
      label = NULL,
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y_reg_coeff",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
    )
  })
  
  # Map coordinates/highlights setter
  observeEvent(input$map_brush_reg_coeff,{
    
    x_brush_1 = input$map_brush_reg_coeff[[1]]
    x_brush_2 = input$map_brush_reg_coeff[[2]]
    y_brush_1 = input$map_brush_reg_coeff[[3]]
    y_brush_2 = input$map_brush_reg_coeff[[4]]
    
    if (input$custom_features_reg_coeff == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
    } else {
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature_reg_coeff",
        label = NULL,
        selected = "Highlight")
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_x_values_reg_coeff",
        label = NULL,
        value = round(c(x_brush_1, x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values_reg_coeff",
        label = NULL,
        value = round(c(input$map_brush_reg_coeff[[3]], input$map_brush_reg_coeff[[4]]), digits = 2)
      )
    }
  })
  
  
  # Map custom points selector regression pvals
  observeEvent(input$map_dblclick_reg_pval, {
    dblclick <- input$map_dblclick_reg_pval
    
    updateCheckboxInput(
      session = getDefaultReactiveDomain(),
      inputId = "custom_features_reg_pval",
      label = NULL,
      value = TRUE
    )
    
    updateRadioButtons(
      session = getDefaultReactiveDomain(),
      inputId = "feature_reg_pval",
      label = NULL,
      selected = "Point"
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_x_reg_pval",
      label = NULL,
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y_reg_pval",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
    )
  })
  
  # Map custom points selector regression residuals
  observeEvent(input$map_dblclick_reg_res, {
    dblclick <- input$map_dblclick_reg_res
    
    updateCheckboxInput(
      session = getDefaultReactiveDomain(),
      inputId = "custom_features_reg_res",
      label = NULL,
      value = TRUE
    )
    
    updateRadioButtons(
      session = getDefaultReactiveDomain(),
      inputId = "feature_reg_res",
      label = NULL,
      selected = "Point"
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_x_reg_res",
      label = NULL,
      value = as.character(round(dblclick$x, digits = 2))
    )
    
    updateTextInput(
      session = getDefaultReactiveDomain(),
      inputId = "point_location_y_reg_res",
      label = NULL,
      value = as.character(round(dblclick$y, digits = 2))
    )
  })
  
  # Map coordinates/highlights setter
  observeEvent(input$map_brush_reg_res,{
    
    x_brush_1 = input$map_brush_reg_res[[1]]
    x_brush_2 = input$map_brush_reg_res[[2]]
    y_brush_1 = input$map_brush_reg_res[[3]]
    y_brush_2 = input$map_brush_reg_res[[4]]
    
    if (input$custom_features_reg_res == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
    } else {
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature_reg_res",
        label = NULL,
        selected = "Highlight")
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_x_values_reg_res",
        label = NULL,
        value = round(c(x_brush_1, x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values_reg_res",
        label = NULL,
        value = round(c(input$map_brush_reg_res[[3]], input$map_brush_reg_res[[4]]), digits = 2)
      )
    }
  })
  
  # Map coordinates/highlights setter
  observeEvent(input$map_brush_reg_pval,{
    
    x_brush_1 = input$map_brush_reg_pval[[1]]
    x_brush_2 = input$map_brush_reg_pval[[2]]
    y_brush_1 = input$map_brush_reg_pval[[3]]
    y_brush_2 = input$map_brush_reg_pval[[4]]
    
    if (input$custom_features_reg_pval == FALSE){
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_dv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_dv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_longitude_iv",
        label = NULL,
        value = round(c(x_brush_1,x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_latitude_iv",
        label = NULL,
        value = round(c(y_brush_1, y_brush_2), digits = 2))
      
    } else {
      updateRadioButtons(
        session = getDefaultReactiveDomain(),
        inputId = "feature_reg_pval",
        label = NULL,
        selected = "Highlight")
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_x_values_reg_pval",
        label = NULL,
        value = round(c(x_brush_1, x_brush_2), digits = 2))
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "highlight_y_values_reg_pval",
        label = NULL,
        value = round(c(input$map_brush_reg_pval[[3]], input$map_brush_reg_pval[[4]]), digits = 2)
      )
    }
  })
  
  
  ####### Initialise and update custom points lines highlights ----
  
  ######### Regression TS (Trend (4a) / Residual (4b))
  
  ts_points_data4a = reactiveVal(data.frame())
  ts_highlights_data4a = reactiveVal(data.frame())
  ts_lines_data4a = reactiveVal(data.frame())
  
  ts_points_data4b = reactiveVal(data.frame())
  ts_highlights_data4b = reactiveVal(data.frame())
  ts_lines_data4b = reactiveVal(data.frame())
  
  # timeseries Points Trend (4a)
  observeEvent(input$add_point_ts4, {
    ts_points_data4a(rbind(ts_points_data4a(),
                          create_new_points_data(input$point_location_x_ts4,input$point_location_y_ts4,
                                                 input$point_label_ts4,input$point_shape_ts4,
                                                 input$point_colour_ts4,input$point_size_ts4)))
  })  
  
  observeEvent(input$remove_last_point_ts4, {
    ts_points_data4a(ts_points_data4a()[-nrow(ts_points_data4a()),])
  })
  
  observeEvent(input$remove_all_points_ts4, {
    ts_points_data4a(data.frame())
  })
  
  # timeseries Points Residual (4b)
  observeEvent(input$add_point_ts4, {
    ts_points_data4b(rbind(ts_points_data4b(),
                          create_new_points_data(input$point_location_x_ts4,input$point_location_y_ts4,
                                                 input$point_label_ts4,input$point_shape_ts4,
                                                 input$point_colour_ts4,input$point_size_ts4)))
  })  
  
  observeEvent(input$remove_last_point_ts4, {
    ts_points_data4b(ts_points_data4b()[-nrow(ts_points_data4b()),])
  })
  
  observeEvent(input$remove_all_points_ts4, {
    ts_points_data4b(data.frame())
  })
  
  
  # timeseries Highlights Trend (4a)
  observeEvent(input$add_highlight_ts4, {
    ts_highlights_data4a(rbind(ts_highlights_data4a(),
                              create_new_highlights_data(input$highlight_x_values_ts4,input$highlight_y_values_ts4,
                                                         input$highlight_colour_ts4,input$highlight_type_ts4,
                                                         input$show_highlight_on_legend_ts4,input$highlight_label_ts4)))
  })  
  
  observeEvent(input$remove_last_highlight_ts4, {
    ts_highlights_data4a(ts_highlights_data4a()[-nrow(ts_highlights_data4a()),])
  })
  
  observeEvent(input$remove_all_highlights_ts4, {
    ts_highlights_data4a(data.frame())
  })
  
  # timeseries Highlights Residual (4b)
  observeEvent(input$add_highlight_ts4, {
    ts_highlights_data4b(rbind(ts_highlights_data4b(),
                              create_new_highlights_data(input$highlight_x_values_ts4,input$highlight_y_values_ts4,
                                                         input$highlight_colour_ts4,input$highlight_type_ts4,
                                                         input$show_highlight_on_legend_ts4,input$highlight_label_ts4)))
  })  
  
  observeEvent(input$remove_last_highlight_ts4, {
    ts_highlights_data4b(ts_highlights_data4b()[-nrow(ts_highlights_data4b()),])
  })
  
  observeEvent(input$remove_all_highlights_ts4, {
    ts_highlights_data4b(data.frame())
  })
  
  # timeseries Lines Trend (4a)
  observeEvent(input$add_line_ts4, {
    ts_lines_data4a(rbind(ts_lines_data4a(),
                         create_new_lines_data(input$line_orientation_ts4,input$line_position_ts4,
                                               input$line_colour_ts4,input$line_type_ts4,
                                               input$show_line_on_legend_ts4,input$line_label_ts4)))
  })  
  
  observeEvent(input$remove_last_line_ts4, {
    ts_lines_data4a(ts_lines_data4a()[-nrow(ts_lines_data4a()),])
  })
  
  observeEvent(input$remove_all_lines_ts4, {
    ts_lines_data4a(data.frame())
  })
  
  # timeseries Lines Residual (4b)
  observeEvent(input$add_line_ts4, {
    ts_lines_data4b(rbind(ts_lines_data4b(),
                         create_new_lines_data(input$line_orientation_ts4,input$line_position_ts4,
                                               input$line_colour_ts4,input$line_type_ts4,
                                               input$show_line_on_legend_ts4,input$line_label_ts4)))
  })  
  
  observeEvent(input$remove_last_line_ts4, {
    ts_lines_data4b(ts_lines_data4b()[-nrow(ts_lines_data4b()),])
  })
  
  observeEvent(input$remove_all_lines_ts4, {
    ts_lines_data4b(data.frame())
  })
  
  ######### Regression Coefficient Map Plot
  
  # Custom Features - Points
  map_points_data_reg_coeff = reactiveVal(data.frame())
  map_highlights_data_reg_coeff = reactiveVal(data.frame())

  # Map Points - Regression Coefficients
  observeEvent(input$add_point_reg_coeff, {
    new_points <- create_new_points_data(
      input$point_location_x_reg_coeff,
      input$point_location_y_reg_coeff,
      input$point_label_reg_coeff,
      input$point_shape_reg_coeff,
      input$point_colour_reg_coeff,
      input$point_size_reg_coeff
    )
    
    if (input$projection_reg_coeff != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection_reg_coeff,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_coeff, input$center_lon_reg_coeff),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data_reg_coeff(rbind(map_points_data_reg_coeff(), new_points))
  })
  
  observeEvent(input$remove_last_point_reg_coeff, {
    map_points_data_reg_coeff(map_points_data_reg_coeff()[-nrow(map_points_data_reg_coeff()), ])
  })
  
  observeEvent(input$remove_all_points_reg_coeff, {
    map_points_data_reg_coeff(data.frame())
  })
  
  # Input geo-coded locations
  observeEvent(input$search_reg_coeff, {
    location_reg_coeff <- input$location_reg_coeff
    if (!is.null(location_reg_coeff) && nchar(location_reg_coeff) > 0) {
      location_encoded_reg_coeff <- URLencode(location_reg_coeff)
      result <- geocode_OSM(location_encoded_reg_coeff)
      if (!is.null(result$coords)) {
        longitude_reg_coeff <- result$coords[1]
        latitude_reg_coeff <- result$coords[2]
        updateTextInput(session, "point_location_x_reg_coeff", value = as.character(longitude_reg_coeff))
        updateTextInput(session, "point_location_y_reg_coeff", value = as.character(latitude_reg_coeff))
        shinyjs::hide(id = "inv_location_reg_coeff")  # Hide the "Invalid location" message
      } else {
        shinyjs::show(id = "inv_location_reg_coeff")  # Show the "Invalid location" message
      }
    } else {
      shinyjs::hide(id = "inv_location_reg_coeff")  # Hide the "Invalid location" message when no input
    }
  })
  
  # Map Highlights - Regression Coefficients
  observeEvent(input$add_highlight_reg_coeff, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values_reg_coeff,
      input$highlight_y_values_reg_coeff,
      input$highlight_colour_reg_coeff,
      input$highlight_type_reg_coeff,
      NA,
      NA
    )
    
    if (input$projection_reg_coeff != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection_reg_coeff,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_coeff, input$center_lon_reg_coeff),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data_reg_coeff(rbind(map_highlights_data_reg_coeff(), new_highlight))
  })
  
  observeEvent(input$remove_last_highlight_reg_coeff, {
    map_highlights_data_reg_coeff(map_highlights_data_reg_coeff()[-nrow(map_highlights_data_reg_coeff()), ])
  })
  
  observeEvent(input$remove_all_highlights_reg_coeff, {
    map_highlights_data_reg_coeff(data.frame())
  })
  
  
  ######### Regression P Value Map Plot
  
  # Custom Features - Points
  map_points_data_reg_pval = reactiveVal(data.frame())
  map_highlights_data_reg_pval = reactiveVal(data.frame())
  
  # Map Points - Regression P-Values
  observeEvent(input$add_point_reg_pval, {
    new_points <- create_new_points_data(
      input$point_location_x_reg_pval,
      input$point_location_y_reg_pval,
      input$point_label_reg_pval,
      input$point_shape_reg_pval,
      input$point_colour_reg_pval,
      input$point_size_reg_pval
    )
    
    if (input$projection_reg_pval != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection_reg_pval,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_pval, input$center_lon_reg_pval),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data_reg_pval(rbind(map_points_data_reg_pval(), new_points))
  })
  
  observeEvent(input$remove_last_point_reg_pval, {
    map_points_data_reg_pval(map_points_data_reg_pval()[-nrow(map_points_data_reg_pval()), ])
  })
  
  observeEvent(input$remove_all_points_reg_pval, {
    map_points_data_reg_pval(data.frame())
  })
  
  # Map Highlights - Regression P-Values
  observeEvent(input$add_highlight_reg_pval, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values_reg_pval,
      input$highlight_y_values_reg_pval,
      input$highlight_colour_reg_pval,
      input$highlight_type_reg_pval,
      NA,
      NA
    )
    
    if (input$projection_reg_pval != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection_reg_pval,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_pval, input$center_lon_reg_pval),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data_reg_pval(rbind(map_highlights_data_reg_pval(), new_highlight))
  })
  
  observeEvent(input$remove_last_highlight_reg_pval, {
    map_highlights_data_reg_pval(map_highlights_data_reg_pval()[-nrow(map_highlights_data_reg_pval()), ])
  })
  
  observeEvent(input$remove_all_highlights_reg_pval, {
    map_highlights_data_reg_pval(data.frame())
  })
  
  
  # Input geo-coded locations
  observeEvent(input$search_reg_pval, {
    location_reg_pval <- input$location_reg_pval
    if (!is.null(location_reg_pval) &&
        nchar(location_reg_pval) > 0) {
      location_encoded_reg_pval <- URLencode(location_reg_pval)
      result <- geocode_OSM(location_encoded_reg_pval)
      if (!is.null(result$coords)) {
        longitude_reg_pval <- result$coords[1]
        latitude_reg_pval <- result$coords[2]
        updateTextInput(session,
                        "point_location_x_reg_pval",
                        value = as.character(longitude_reg_pval))
        updateTextInput(session,
                        "point_location_y_reg_pval",
                        value = as.character(latitude_reg_pval))
        shinyjs::hide(id = "inv_location_reg_pval")  # Hide the "Invalid location" message
      } else {
        shinyjs::show(id = "inv_location_reg_pval")  # Show the "Invalid location" message
      }
    } else {
      shinyjs::hide(id = "inv_location_reg_pval") # Hide the "Invalid location" message when no input
    }
  })
  
  ######### Regression Residual Map Plot
  
  # Custom Features - Points
  map_points_data_reg_res = reactiveVal(data.frame())
  map_highlights_data_reg_res = reactiveVal(data.frame())
  

  # Map Points - Regression Residuals
  observeEvent(input$add_point_reg_res, {
    new_points <- create_new_points_data(
      input$point_location_x_reg_res,
      input$point_location_y_reg_res,
      input$point_label_reg_res,
      input$point_shape_reg_res,
      input$point_colour_reg_res,
      input$point_size_reg_res
    )
    
    if (input$projection_reg_res != "UTM (default)") {
      new_points <- transform_points_df(
        df = new_points,
        xcol = "x_value",
        ycol = "y_value",
        projection_from = switch(
          input$projection_reg_res,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_res, input$center_lon_reg_res),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_points_data_reg_res(rbind(map_points_data_reg_res(), new_points))
  })
  
  observeEvent(input$remove_last_point_reg_res, {
    map_points_data_reg_res(map_points_data_reg_res()[-nrow(map_points_data_reg_res()), ])
  })
  
  observeEvent(input$remove_all_points_reg_res, {
    map_points_data_reg_res(data.frame())
  })
  
  # Input geo-coded locations
  observeEvent(input$search_reg_res, {
    location_reg_res <- input$location_reg_res
    if (!is.null(location_reg_res) && nchar(location_reg_res) > 0) {
      location_encoded_reg_res <- URLencode(location_reg_res)
      result <- geocode_OSM(location_encoded_reg_res)
      if (!is.null(result$coords)) {
        longitude_reg_res <- result$coords[1]
        latitude_reg_res <- result$coords[2]
        updateTextInput(session, "point_location_x_reg_res", value = as.character(longitude_reg_res))
        updateTextInput(session, "point_location_y_reg_res", value = as.character(latitude_reg_res))
        shinyjs::hide(id = "inv_location_reg_res")  # Hide the "Invalid location" message
      } else {
        shinyjs::show(id = "inv_location_reg_res")  # Show the "Invalid location" message
      }}})

  # Map Highlights - Regression Residuals
  observeEvent(input$add_highlight_reg_res, {
    new_highlight <- create_new_highlights_data(
      input$highlight_x_values_reg_res,
      input$highlight_y_values_reg_res,
      input$highlight_colour_reg_res,
      input$highlight_type_reg_res,
      NA,
      NA
    )
    
    if (input$projection_reg_res != "UTM (default)") {
      new_highlight <- transform_box_df(
        df = new_highlight,
        x1col = "x1",
        x2col = "x2",
        y1col = "y1",
        y2col = "y2",
        projection_from = switch(
          input$projection_reg_res,
          "Robinson" = "+proj=robin",
          "Orthographic" = ortho_proj(input$center_lat_reg_res, input$center_lon_reg_res),
          "LAEA" = laea_proj
        ),
        projection_to = "+proj=longlat +datum=WGS84"
      )
    }
    
    map_highlights_data_reg_res(rbind(map_highlights_data_reg_res(), new_highlight))
  })
  
  observeEvent(input$remove_last_highlight_reg_res, {
    map_highlights_data_reg_res(map_highlights_data_reg_res()[-nrow(map_highlights_data_reg_res()), ])
  })
  
  observeEvent(input$remove_all_highlights_reg_res, {
    map_highlights_data_reg_res(data.frame())
  })
  
  
  ####### Generate Metadata for map customization ----
  
  # Reactive metadata collector for Regression TS
  metadata_inputs_regression_ts <- reactive({
    generate_metadata_regression(
      # Shared regression inputs
      range_years4         = input$range_years4,
      dataset_selected_dv  = input$dataset_selected_dv,
      dataset_selected_iv  = input$dataset_selected_iv,
      ME_variable_dv       = input$ME_variable_dv,
      ME_variable_iv       = input$ME_variable_iv,
      coordinates_type_dv  = input$coordinates_type_dv,
      coordinates_type_iv  = input$coordinates_type_iv,
      mode_selected_dv     = input$mode_selected_dv,
      mode_selected_iv     = input$mode_selected_iv,
      season_selected_dv   = input$season_selected_dv,
      season_selected_iv   = input$season_selected_iv,
      range_months_dv      = input$range_months_dv,
      range_months_iv      = input$range_months_iv,
      range_latitude_dv    = input$range_latitude_dv,
      range_longitude_dv   = input$range_longitude_dv,
      range_latitude_iv    = input$range_latitude_iv,
      range_longitude_iv   = input$range_longitude_iv,
      ref_period_sg_dv     = input$ref_period_sg_dv,
      ref_period_sg_iv     = input$ref_period_sg_iv,
      ref_period_dv        = input$ref_period_dv,
      ref_period_iv        = input$ref_period_iv,
      ref_single_year_dv   = input$ref_single_year_dv,
      ref_single_year_iv   = input$ref_single_year_iv,
      source_dv            = input$source_dv,
      source_iv            = input$source_iv,
      
      # Timeseries-specific inputs
      axis_input_ts4a            = input$axis_input_ts4a,
      axis_input_ts4b            = input$axis_input_ts4b,
      axis_mode_ts4a             = input$axis_mode_ts4a,
      axis_mode_ts4b             = input$axis_mode_ts4b,
      custom_ts4                 = input$custom_ts4,
      key_position_ts4           = input$key_position_ts4,
      show_ticks_ts4             = input$show_ticks_ts4,
      title_mode_ts4             = input$title_mode_ts4,
      title_size_input_ts4       = input$title_size_input_ts4,
      title1_input_ts4           = input$title1_input_ts4,
      title2_input_ts4           = input$title2_input_ts4,
      xaxis_numeric_interval_ts4 = input$xaxis_numeric_interval_ts4,
      reg_ts_plot_type           = input$reg_ts_plot_type,
      reg_ts2_plot_type          = input$reg_ts2_plot_type,
      
      # Map = NA
      axis_input_reg       = NA,
      axis_mode_reg        = NA,
      center_lat_reg       = NA,
      center_lon_reg       = NA,
      coeff_variable       = NA,
      custom_topo_reg      = NA,
      download_options     = NA,
      hide_axis_reg        = NA,
      hide_borders_reg     = NA,
      label_lakes_reg      = NA,
      label_mountains_reg  = NA,
      label_rivers_reg     = NA,
      projection_reg       = NA,
      reg_plot_type        = NA,
      show_lakes_reg       = NA,
      show_mountains_reg   = NA,
      show_rivers_reg      = NA,
      title_mode_reg       = NA,
      title_size_input_reg = NA,
      title1_input_reg     = NA,
      title2_input_reg     = NA,
      white_land_reg       = NA,
      white_ocean_reg      = NA,
      reg_resi_year        = NA,
      
      # Reactive values
      plotOrder       = NULL,
      availableLayers = NULL,
      lonlat_vals_iv = lonlat_vals_iv(),
      lonlat_vals_dv = lonlat_vals_dv()
      
    )
  })
  
  # Download Handler for Regression TS Metadata
  output$download_metadata_ts4 <- downloadHandler(
    filename = function() { "metadata_regression_ts.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points_a")
      openxlsx::addWorksheet(wb, "custom_highlights_a")
      openxlsx::addWorksheet(wb, "custom_lines_a")
      openxlsx::addWorksheet(wb, "custom_points_b")
      openxlsx::addWorksheet(wb, "custom_highlights_b")
      openxlsx::addWorksheet(wb, "custom_lines_b")
      
      meta <- isolate(metadata_inputs_regression_ts())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(ts_points_data4a()) > 0) openxlsx::writeData(wb, "custom_points_a", ts_points_data4a())
      if (nrow(ts_highlights_data4a()) > 0) openxlsx::writeData(wb, "custom_highlights_a", ts_highlights_data4a())
      if (nrow(ts_lines_data4a()) > 0) openxlsx::writeData(wb, "custom_lines_a", ts_lines_data4a())
      if (nrow(ts_points_data4b()) > 0) openxlsx::writeData(wb, "custom_points_b", ts_points_data4b())
      if (nrow(ts_highlights_data4b()) > 0) openxlsx::writeData(wb, "custom_highlights_b", ts_highlights_data4b())
      if (nrow(ts_lines_data4b()) > 0) openxlsx::writeData(wb, "custom_lines_b", ts_lines_data4b())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Handler for TS4 Regression with A & B
  observeEvent(input$update_metadata_ts4, {
    req(input$upload_metadata_ts4)
    
    file_path <- input$upload_metadata_ts4$datapath
    file_name <- input$upload_metadata_ts4$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_regression_ts") {
      
      process_uploaded_metadata_regression(
        file_path           = file_path,
        mode                = "ts",
        metadata_sheet      = "custom_meta",
        df_ts_points        = "custom_points_a",
        df_ts_highlights    = "custom_highlights_a",
        df_ts_lines         = "custom_lines_a",
        ts_points_data      = ts_points_data4a,
        ts_highlights_data  = ts_highlights_data4a,
        ts_lines_data       = ts_lines_data4a,
        df_map_points       = NULL,
        df_map_highlights   = NULL,
        map_points_data     = NULL,
        map_highlights_data = NULL,
        rv_plotOrder        = NULL,
        rv_availableLayers  = NULL,
        rv_lonlat_vals_iv   = lonlat_vals_iv,
        rv_lonlat_vals_dv   = lonlat_vals_dv
      )
      
      # Load TS4B manually (not handled inside process_uploaded_metadata_regression)
      df_b_points     <- openxlsx::read.xlsx(file_path, sheet = "custom_points_b")
      df_b_highlights <- openxlsx::read.xlsx(file_path, sheet = "custom_highlights_b")
      df_b_lines      <- openxlsx::read.xlsx(file_path, sheet = "custom_lines_b")
      
      if (!is.null(df_b_points) && nrow(df_b_points) > 0) ts_points_data4b(df_b_points)
      if (!is.null(df_b_highlights) && nrow(df_b_highlights) > 0) ts_highlights_data4b(df_b_highlights)
      if (!is.null(df_b_lines) && nrow(df_b_lines) > 0) ts_lines_data4b(df_b_lines)
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_regression_ts.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  
  # Reactive metadata collector for Regression Coefficient Map
  metadata_inputs_regression_coeff <- reactive({
    generate_metadata_regression(
      # Shared regression inputs
      range_years4         = input$range_years4,
      dataset_selected_dv  = input$dataset_selected_dv,
      dataset_selected_iv  = input$dataset_selected_iv,
      ME_variable_dv       = input$ME_variable_dv,
      ME_variable_iv       = input$ME_variable_iv,
      coordinates_type_dv  = input$coordinates_type_dv,
      coordinates_type_iv  = input$coordinates_type_iv,
      mode_selected_dv     = input$mode_selected_dv,
      mode_selected_iv     = input$mode_selected_iv,
      season_selected_dv   = input$season_selected_dv,
      season_selected_iv   = input$season_selected_iv,
      range_months_dv      = input$range_months_dv,
      range_months_iv      = input$range_months_iv,
      range_latitude_dv    = input$range_latitude_dv,
      range_longitude_dv   = input$range_longitude_dv,
      range_latitude_iv    = input$range_latitude_iv,
      range_longitude_iv   = input$range_longitude_iv,
      ref_period_sg_dv     = input$ref_period_sg_dv,
      ref_period_sg_iv     = input$ref_period_sg_iv,
      ref_period_dv        = input$ref_period_dv,
      ref_period_iv        = input$ref_period_iv,
      ref_single_year_dv   = input$ref_single_year_dv,
      ref_single_year_iv   = input$ref_single_year_iv,
      source_dv            = input$source_dv,
      source_iv            = input$source_iv,
      
      # Timeseries section = NA
      axis_input_ts4a = NA,
      axis_input_ts4b = NA,
      axis_mode_ts4a = NA,
      axis_mode_ts4b = NA,
      custom_ts4 = NA,
      key_position_ts4 = NA,
      show_ticks_ts4 = NA,
      title_mode_ts4 = NA,
      title_size_input_ts4 = NA,
      title1_input_ts4 = NA,
      title2_input_ts4 = NA,
      xaxis_numeric_interval_ts4 = NA,
      reg_ts_plot_type = NA,
      reg_ts2_plot_type = NA,
      
      # Map-specific inputs
      axis_input_reg       = input$axis_input_reg_coeff,
      axis_mode_reg        = input$axis_mode_reg_coeff,
      center_lat_reg       = input$center_lat_reg_coeff,
      center_lon_reg       = input$center_lon_reg_coeff,
      coeff_variable       = input$coeff_variable,
      custom_topo_reg      = input$custom_topo_reg_coeff,
      download_options     = input$download_options_coeff,
      hide_axis_reg        = input$hide_axis_reg_coeff,
      hide_borders_reg     = input$hide_borders_reg_coeff,
      label_lakes_reg      = input$label_lakes_reg_coeff,
      label_mountains_reg  = input$label_mountains_reg_coeff,
      label_rivers_reg     = input$label_rivers_reg_coeff,
      projection_reg       = input$projection_reg_coeff,
      reg_plot_type        = input$reg_coe_plot_type,
      show_lakes_reg       = input$show_lakes_reg_coeff,
      show_mountains_reg   = input$show_mountains_reg_coeff,
      show_rivers_reg      = input$show_rivers_reg_coeff,
      title_mode_reg       = input$title_mode_reg_coeff,
      title_size_input_reg = input$title_size_input_reg_coeff,
      title1_input_reg     = input$title1_input_reg_coeff,
      title2_input_reg     = input$title2_input_reg_coeff,
      white_land_reg       = input$white_land_reg_coeff,
      white_ocean_reg      = input$white_ocean_reg_coeff,
      reg_resi_year        = NA,
      
      # Reactive values
      plotOrder       = character(0),
      availableLayers = character(0),
      lonlat_vals_iv = lonlat_vals_iv(),
      lonlat_vals_dv = lonlat_vals_dv()
    )
  })
  
  # Download Handler for Regression Coefficient Map Metadata
  output$download_metadata_reg_coeff <- downloadHandler(
    filename = function() { "metadata_regression_coeff.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs_regression_coeff())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(map_points_data_reg_coeff()) > 0) openxlsx::writeData(wb, "custom_points", map_points_data_reg_coeff())
      if (nrow(map_highlights_data_reg_coeff()) > 0) openxlsx::writeData(wb, "custom_highlights", map_highlights_data_reg_coeff())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Handler for Regression Coefficient Map Metadata
  observeEvent(input$update_metadata_reg_coeff, {
    req(input$upload_metadata_reg_coeff)
    
    file_path <- input$upload_metadata_reg_coeff$datapath
    file_name <- input$upload_metadata_reg_coeff$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_regression_coeff") {
      
      process_uploaded_metadata_regression(
        file_path           = file_path,
        mode                = "coeff",
        metadata_sheet      = "custom_meta",
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        map_points_data     = map_points_data_reg_coeff,
        map_highlights_data = map_highlights_data_reg_coeff,
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL,
        rv_plotOrder        = plotOrder_reg_coeff,
        rv_availableLayers  = availableLayers_reg_coeff,
        rv_lonlat_vals_iv   = lonlat_vals_iv,
        rv_lonlat_vals_dv   = lonlat_vals_dv
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_regression_coeff.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  # Reactive metadata collector for Regression P-Value Map
  metadata_inputs_regression_pval <- reactive({
    generate_metadata_regression(
      # Shared regression inputs
      range_years4         = input$range_years4,
      dataset_selected_dv  = input$dataset_selected_dv,
      dataset_selected_iv  = input$dataset_selected_iv,
      ME_variable_dv       = input$ME_variable_dv,
      ME_variable_iv       = input$ME_variable_iv,
      coordinates_type_dv  = input$coordinates_type_dv,
      coordinates_type_iv  = input$coordinates_type_iv,
      mode_selected_dv     = input$mode_selected_dv,
      mode_selected_iv     = input$mode_selected_iv,
      season_selected_dv   = input$season_selected_dv,
      season_selected_iv   = input$season_selected_iv,
      range_months_dv      = input$range_months_dv,
      range_months_iv      = input$range_months_iv,
      range_latitude_dv    = input$range_latitude_dv,
      range_longitude_dv   = input$range_longitude_dv,
      range_latitude_iv    = input$range_latitude_iv,
      range_longitude_iv   = input$range_longitude_iv,
      ref_period_sg_dv     = input$ref_period_sg_dv,
      ref_period_sg_iv     = input$ref_period_sg_iv,
      ref_period_dv        = input$ref_period_dv,
      ref_period_iv        = input$ref_period_iv,
      ref_single_year_dv   = input$ref_single_year_dv,
      ref_single_year_iv   = input$ref_single_year_iv,
      source_dv            = input$source_dv,
      source_iv            = input$source_iv,
      
      # Timeseries section = NA
      axis_input_ts4a = NA,
      axis_input_ts4b = NA,
      axis_mode_ts4a = NA,
      axis_mode_ts4b = NA,
      custom_ts4 = NA,
      key_position_ts4 = NA,
      show_ticks_ts4 = NA,
      title_mode_ts4 = NA,
      title_size_input_ts4 = NA,
      title1_input_ts4 = NA,
      title2_input_ts4 = NA,
      xaxis_numeric_interval_ts4 = NA,
      reg_ts_plot_type = NA,
      reg_ts2_plot_type = NA,
      
      # Map-specific inputs
      axis_input_reg       = input$axis_input_reg_pval,
      axis_mode_reg        = input$axis_mode_reg_pval,
      center_lat_reg       = input$center_lat_reg_pval,
      center_lon_reg       = input$center_lon_reg_pval,
      coeff_variable       = input$pvalue_variable,
      custom_topo_reg      = input$custom_topo_reg_pval,
      download_options     = input$download_options_pval,
      hide_axis_reg        = input$hide_axis_reg_pval,
      hide_borders_reg     = input$hide_borders_reg_pval,
      label_lakes_reg      = input$label_lakes_reg_pval,
      label_mountains_reg  = input$label_mountains_reg_pval,
      label_rivers_reg     = input$label_rivers_reg_pval,
      projection_reg       = input$projection_reg_pval,
      reg_plot_type        = input$reg_pval_plot_type,
      show_lakes_reg       = input$show_lakes_reg_pval,
      show_mountains_reg   = input$show_mountains_reg_pval,
      show_rivers_reg      = input$show_rivers_reg_pval,
      title_mode_reg       = input$title_mode_reg_pval,
      title_size_input_reg = input$title_size_input_reg_pval,
      title1_input_reg     = input$title1_input_reg_pval,
      title2_input_reg     = input$title2_input_reg_pval,
      white_land_reg       = input$white_land_reg_pval,
      white_ocean_reg      = input$white_ocean_reg_pval,
      reg_resi_year        = NA,
      
      # Reactive values
      plotOrder       = character(0),
      availableLayers = character(0),
      lonlat_vals_iv = lonlat_vals_iv(),
      lonlat_vals_dv = lonlat_vals_dv()
    )
  })
  
  # Download Handler for Regression P-Value Map Metadata
  output$download_metadata_reg_pval <- downloadHandler(
    filename = function() { "metadata_regression_pval.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs_regression_pval())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(map_points_data_reg_pval()) > 0) openxlsx::writeData(wb, "custom_points", map_points_data_reg_pval())
      if (nrow(map_highlights_data_reg_pval()) > 0) openxlsx::writeData(wb, "custom_highlights", map_highlights_data_reg_pval())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Handler for Regression P-Value Map Metadata
  observeEvent(input$update_metadata_reg_pval, {
    req(input$upload_metadata_reg_pval)
    
    file_path <- input$upload_metadata_reg_pval$datapath
    file_name <- input$upload_metadata_reg_pval$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_regression_pval") {
      
      process_uploaded_metadata_regression(
        file_path           = file_path,
        mode                = "pval",
        metadata_sheet      = "custom_meta",
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        map_points_data     = map_points_data_reg_pval,
        map_highlights_data = map_highlights_data_reg_pval,
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL,
        rv_plotOrder        = plotOrder_reg_pval,
        rv_availableLayers  = availableLayers_reg_pval,
        rv_lonlat_vals_iv   = lonlat_vals_iv,
        rv_lonlat_vals_dv   = lonlat_vals_dv
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_regression_pval.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  # Reactive metadata collector for Regression Residual Map
  metadata_inputs_regression_res <- reactive({
    generate_metadata_regression(
      # Shared regression inputs
      range_years4         = input$range_years4,
      dataset_selected_dv  = input$dataset_selected_dv,
      dataset_selected_iv  = input$dataset_selected_iv,
      ME_variable_dv       = input$ME_variable_dv,
      ME_variable_iv       = input$ME_variable_iv,
      coordinates_type_dv  = input$coordinates_type_dv,
      coordinates_type_iv  = input$coordinates_type_iv,
      mode_selected_dv     = input$mode_selected_dv,
      mode_selected_iv     = input$mode_selected_iv,
      season_selected_dv   = input$season_selected_dv,
      season_selected_iv   = input$season_selected_iv,
      range_months_dv      = input$range_months_dv,
      range_months_iv      = input$range_months_iv,
      range_latitude_dv    = input$range_latitude_dv,
      range_longitude_dv   = input$range_longitude_dv,
      range_latitude_iv    = input$range_latitude_iv,
      range_longitude_iv   = input$range_longitude_iv,
      ref_period_sg_dv     = input$ref_period_sg_dv,
      ref_period_sg_iv     = input$ref_period_sg_iv,
      ref_period_dv        = input$ref_period_dv,
      ref_period_iv        = input$ref_period_iv,
      ref_single_year_dv   = input$ref_single_year_dv,
      ref_single_year_iv   = input$ref_single_year_iv,
      source_dv            = input$source_dv,
      source_iv            = input$source_iv,

      # Timeseries section = NA
      axis_input_ts4a = NA,
      axis_input_ts4b = NA,
      axis_mode_ts4a = NA,
      axis_mode_ts4b = NA,
      custom_ts4 = NA,
      key_position_ts4 = NA,
      show_ticks_ts4 = NA,
      title_mode_ts4 = NA,
      title_size_input_ts4 = NA,
      title1_input_ts4 = NA,
      title2_input_ts4 = NA,
      xaxis_numeric_interval_ts4 = NA,
      reg_ts_plot_type = NA,
      reg_ts2_plot_type = NA,
      
      # Map-specific inputs
      axis_input_reg       = input$axis_input_reg_res,
      axis_mode_reg        = input$axis_mode_reg_res,
      center_lat_reg       = input$center_lat_reg_res,
      center_lon_reg       = input$center_lon_reg_res,
      coeff_variable       = NA,
      custom_topo_reg      = input$custom_topo_reg_res,
      download_options     = input$download_options_reg_res,
      hide_axis_reg        = input$hide_axis_reg_res,
      hide_borders_reg     = input$hide_borders_reg_res,
      label_lakes_reg      = input$label_lakes_reg_res,
      label_mountains_reg  = input$label_mountains_reg_res,
      label_rivers_reg     = input$label_rivers_reg_res,
      projection_reg       = input$projection_reg_res,
      reg_plot_type        = input$reg_res_plot_type,
      show_lakes_reg       = input$show_lakes_reg_res,
      show_mountains_reg   = input$show_mountains_reg_res,
      show_rivers_reg      = input$show_rivers_reg_res,
      title_mode_reg       = input$title_mode_reg_res,
      title_size_input_reg = input$title_size_input_reg_res,
      title1_input_reg     = input$title1_input_reg_res,
      title2_input_reg     = input$title2_input_reg_res,
      white_land_reg       = input$white_land_reg_res,
      white_ocean_reg      = input$white_ocean_reg_res,
      reg_resi_year        = reg_resi_year_val(),
      
      # Reactive values
      plotOrder       = character(0),
      availableLayers = character(0),
      lonlat_vals_iv = lonlat_vals_iv(),
      lonlat_vals_dv = lonlat_vals_dv()
    )
  })
  
  # Download Handler for Regression Residual Map Metadata
  output$download_metadata_reg_res <- downloadHandler(
    filename = function() { "metadata_regression_res.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      
      meta <- isolate(metadata_inputs_regression_res())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(map_points_data_reg_res()) > 0) openxlsx::writeData(wb, "custom_points", map_points_data_reg_res())
      if (nrow(map_highlights_data_reg_res()) > 0) openxlsx::writeData(wb, "custom_highlights", map_highlights_data_reg_res())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # Upload Handler for Regression Residual Map Metadata
  observeEvent(input$update_metadata_reg_res, {
    req(input$upload_metadata_reg_res)
    
    file_path <- input$upload_metadata_reg_res$datapath
    file_name <- input$upload_metadata_reg_res$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_regression_res") {
      
      process_uploaded_metadata_regression(
        file_path           = file_path,
        mode                = "res",
        metadata_sheet      = "custom_meta",
        df_map_points       = "custom_points",
        df_map_highlights   = "custom_highlights",
        map_points_data     = map_points_data_reg_res,
        map_highlights_data = map_highlights_data_reg_res,
        df_ts_points        = NULL,
        df_ts_highlights    = NULL,
        df_ts_lines         = NULL,
        ts_points_data      = NULL,
        ts_highlights_data  = NULL,
        ts_lines_data       = NULL,
        rv_plotOrder        = plotOrder_reg_res,
        rv_availableLayers  = availableLayers_reg_res,
        rv_lonlat_vals_iv   = lonlat_vals_iv,
        rv_lonlat_vals_dv   = lonlat_vals_dv
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_regression_res.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  ####### Generate Layer Options for customization ----
  
  ####### Regression Coefficient
  # Reactive values
  plotOrder_reg_coeff <- reactiveVal(character(0))        # full paths
  availableLayers_reg_coeff <- reactiveVal(character(0))  # file names
  
  # Helper: extract and load shapefiles
  updatePlotOrder_reg_coeff <- function(zipFile, plotOrder, availableLayers) {
    temp_dir <- tempfile(pattern = "reg_coeff_")
    dir.create(temp_dir)
    unzip(zipFile, exdir = temp_dir)
    
    shpFiles <- list.files(temp_dir, pattern = "\\.shp$", full.names = TRUE)
    layer_names <- tools::file_path_sans_ext(basename(shpFiles))
    
    plotOrder(shpFiles)
    availableLayers(layer_names)
  }
  
  # Trigger update on file upload
  observeEvent(input$shpFile_reg_coeff, {
    req(input$shpFile_reg_coeff)
    updatePlotOrder_reg_coeff(
      zipFile = input$shpFile_reg_coeff$datapath,
      plotOrder = plotOrder_reg_coeff,
      availableLayers = availableLayers_reg_coeff
    )
  })
  
  # Shape File Renderer for regression coefficients
  output$shapefileSelector_reg_coeff <- renderUI({
    req(availableLayers_reg_coeff())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes_reg_coeff",
      label = "Select and order shapefiles for Regression Coefficients (drag & drop)",
      choices = availableLayers_reg_coeff()
    )
  })
  
  # Dynamic color pickers for selected regression coefficient shapefiles
  output$colorpickers_reg_coeff <- renderUI({
    req(input$shapes_reg_coeff, input$shapes_reg_coeff_order, plotOrder_reg_coeff())
    selected_ordered <- input$shapes_reg_coeff_order[input$shapes_reg_coeff_order %in% input$shapes_reg_coeff]
    shp_files <- plotOrder_reg_coeff()[match(selected_ordered, tools::file_path_sans_ext(basename(plotOrder_reg_coeff())))]
    
    pickers <- lapply(shp_files, function(file) {
      file_name <- tools::file_path_sans_ext(basename(file))
      input_id <- paste0("shp_colour_reg_coeff_", file_name)
      last_val <- isolate(input[[input_id]])
      colourInput(
        inputId = input_id,
        label   = paste("Border Color for", file_name),
        value   = if (!is.null(last_val)) last_val else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers)
  })
  
  ####### Regression P-Value
  # Reactive values
  plotOrder_reg_pval <- reactiveVal(character(0))        # full paths
  availableLayers_reg_pval <- reactiveVal(character(0))  # file names
  
  # Helper: extract and load shapefiles
  updatePlotOrder_reg_pval <- function(zipFile, plotOrder, availableLayers) {
    temp_dir <- tempfile(pattern = "reg_pval_")
    dir.create(temp_dir)
    unzip(zipFile, exdir = temp_dir)
    
    shpFiles <- list.files(temp_dir, pattern = "\\.shp$", full.names = TRUE)
    layer_names <- tools::file_path_sans_ext(basename(shpFiles))
    
    plotOrder(shpFiles)
    availableLayers(layer_names)
  }
  
  # Trigger update on file upload
  observeEvent(input$shpFile_reg_pval, {
    req(input$shpFile_reg_pval)
    updatePlotOrder_reg_pval(
      zipFile = input$shpFile_reg_pval$datapath,
      plotOrder = plotOrder_reg_pval,
      availableLayers = availableLayers_reg_pval
    )
  })
  
  # Shape File Renderer for regression p-values
  output$shapefileSelector_reg_pval <- renderUI({
    req(availableLayers_reg_pval())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes_reg_pval",
      label = "Select and order shapefiles for Regression p-values (drag & drop)",
      choices = availableLayers_reg_pval()
    )
  })
  
  # Dynamic color pickers for selected regression p-value shapefiles
  output$colorpickers_reg_pval <- renderUI({
    req(input$shapes_reg_pval, input$shapes_reg_pval_order, plotOrder_reg_pval())
    selected_ordered <- input$shapes_reg_pval_order[input$shapes_reg_pval_order %in% input$shapes_reg_pval]
    shp_files <- plotOrder_reg_pval()[match(selected_ordered, tools::file_path_sans_ext(basename(plotOrder_reg_pval())))]
    
    pickers <- lapply(shp_files, function(file) {
      file_name <- tools::file_path_sans_ext(basename(file))
      input_id <- paste0("shp_colour_reg_pval_", file_name)
      last_val <- isolate(input[[input_id]])
      colourInput(
        inputId = input_id,
        label   = paste("Border Color for", file_name),
        value   = if (!is.null(last_val)) last_val else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers)
  })
  
  ####### Regression Residual
  # Reactive values
  plotOrder_reg_res <- reactiveVal(character(0))        # full paths
  availableLayers_reg_res <- reactiveVal(character(0))  # file names
  
  # Helper: extract and load shapefiles
  updatePlotOrder_reg_res <- function(zipFile, plotOrder, availableLayers) {
    temp_dir <- tempfile(pattern = "reg_res_")
    dir.create(temp_dir)
    unzip(zipFile, exdir = temp_dir)
    
    shpFiles <- list.files(temp_dir, pattern = "\\.shp$", full.names = TRUE)
    layer_names <- tools::file_path_sans_ext(basename(shpFiles))
    
    plotOrder(shpFiles)
    availableLayers(layer_names)
  }
  
  # Trigger update on file upload
  observeEvent(input$shpFile_reg_res, {
    req(input$shpFile_reg_res)
    updatePlotOrder_reg_res(
      zipFile = input$shpFile_reg_res$datapath,
      plotOrder = plotOrder_reg_res,
      availableLayers = availableLayers_reg_res
    )
  })
  
  # Shape File Renderer for regression residuals
  output$shapefileSelector_reg_res <- renderUI({
    req(availableLayers_reg_res())
    shinyjqui::sortableCheckboxGroupInput(
      inputId = "shapes_reg_res",
      label = "Select and order shapefiles for Regression Residuals (drag & drop)",
      choices = availableLayers_reg_res()
    )
  })
  
  # Dynamic color pickers for selected regression residual shapefiles
  output$colorpickers_reg_res <- renderUI({
    req(input$shapes_reg_res, input$shapes_reg_res_order, plotOrder_reg_res())
    selected_ordered <- input$shapes_reg_res_order[input$shapes_reg_res_order %in% input$shapes_reg_res]
    shp_files <- plotOrder_reg_res()[match(selected_ordered, tools::file_path_sans_ext(basename(plotOrder_reg_res())))]
    
    pickers <- lapply(shp_files, function(file) {
      file_name <- tools::file_path_sans_ext(basename(file))
      input_id <- paste0("shp_colour_reg_res_", file_name)
      last_val <- isolate(input[[input_id]])
      colourInput(
        inputId = input_id,
        label   = paste("Border Color for", file_name),
        value   = if (!is.null(last_val)) last_val else "black",
        showColour = "background",
        palette = "limited",
        allowTransparent = FALSE
      )
    })
    do.call(tagList, pickers)
  })
  
  
  ### ANNUAL CYCLES observe, update & interactive controls----
  ####### Initialise and update timeseries dataframe ----
  
  # Add in initial data
  monthly_ts_data = reactiveVal(monthly_ts_starter_data())
  # Set tracker to 1 (if tracker is 1, the first line, aka the starter data, gets replaced)
  monthly_ts_tracker = reactiveVal(1)
  
  # Add new data and update related inputs
  observeEvent(input$add_monthly_ts, {
    
    # Generate data ID
    monthly_ts_data_ID = generate_data_ID(
      dataset = input$dataset_selected5,
      variable = input$variable_selected5,
      month_range = c(NA, NA)
    )
    
    # Update custom_data if required
    if (!identical(custom_data_id_primary()[2:3], monthly_ts_data_ID[2:3])) {
      # ....i.e. changed variable or dataset
      custom_data_primary(load_ModE_data(dataset = input$dataset_selected5, variable = input$variable_selected5)) # load new custom data
      custom_data_id_primary(monthly_ts_data_ID) # update custom data ID
    }
    
    # Replace starter data if tracker = 1
    if (monthly_ts_tracker() == 1){
      monthly_ts_data(create_monthly_TS_data(custom_data_primary(),input$dataset_selected5,input$variable_selected5,
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
      new_rows = create_monthly_TS_data(custom_data_primary(),input$dataset_selected5,input$variable_selected5,
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
  
  
  ####### Input updaters ----
  
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
  
  # Set iniital lon/lat values on startup
  lonlat_vals5 = reactiveVal(c(initial_lon_values,initial_lat_values))
  
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
    
    lonlat_vals5(c(-180,180, -90,90))  # Global
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
    
    lonlat_vals5(c(-30,40, 30,75))       # Europe
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
    
    lonlat_vals5(c(25,170, 5,80))        # Asia
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
    
    lonlat_vals5(c(90,180, -55,20))      # Oceania
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
    
    lonlat_vals5(c(-25,55, -40,40))      # Africa
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
    
    lonlat_vals5(c(-175,-10, 5,85))      # North America
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
    
    lonlat_vals5(c(-90,-30, -60,15))     # South America
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
  
  
  ####### Interactivity ----
  
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
  
  ####### Initialise and update custom points lines highlights ----
  
  ts_points_data5 = reactiveVal(data.frame())
  ts_highlights_data5 = reactiveVal(data.frame())
  ts_lines_data5 = reactiveVal(data.frame())
  
  # timeseries Points
  observeEvent(input$add_point_ts5, {
    ts_points_data5(rbind(
      ts_points_data5(),
      create_new_points_data(
        input$point_location_x_ts5,
        input$point_location_y_ts5,
        input$point_label_ts5,
        input$point_shape_ts5,
        input$point_colour_ts5,
        input$point_size_ts5
      )
    ))
  })  
  
  observeEvent(input$remove_last_point_ts5, {
    ts_points_data5(ts_points_data5()[-nrow(ts_points_data5()),])
  })
  
  observeEvent(input$remove_all_points_ts5, {
    ts_points_data5(data.frame())
  })
  
  # timeseries Highlights
  observeEvent(input$add_highlight_ts5, {
    ts_highlights_data5(rbind(
      ts_highlights_data5(),
      create_new_highlights_data(
        input$highlight_x_values_ts5,
        input$highlight_y_values_ts5,
        input$highlight_colour_ts5,
        input$highlight_type_ts5,
        input$show_highlight_on_legend_ts5,
        input$highlight_label_ts5
      )
    ))
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
  
  ####### Generate Metadata for Annual Cycle ----
  
  # === Reactive Metadata Collector for Annual Cycles ===
  metadata_inputs_annualcycle <- reactive({
    generate_metadata_annualcycle(
      range_years5          = input$range_years5,
      custom_ts5            = input$custom_ts5,
      key_position_ts5      = input$key_position_ts5,
      show_key_ts5          = input$show_key_ts5,
      title_mode_ts5        = input$title_mode_ts5,
      title_size_input_ts5  = input$title_size_input_ts5,
      title1_input_ts5      = input$title1_input_ts5,
      file_type_timeseries5 = input$file_type_timeseries5,
      dataset_selected5     = input$dataset_selected5,
      variable_selected5    = input$variable_selected5,
      range_latitude5       = input$range_latitude5,
      range_longitude5      = input$range_longitude5,
      ref_period5           = input$ref_period5,
      ref_period_sg5        = input$ref_period_sg5,
      ref_single_year5      = input$ref_single_year5,
      mode_selected5        = input$mode_selected5,
      type_selected5        = input$type_selected5
    )
  })
  
  # === Download Metadata Handler ===
  output$download_metadata_ts5 <- downloadHandler(
    filename = function() { "metadata_annualcycle.xlsx" },
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      
      openxlsx::addWorksheet(wb, "custom_meta")
      openxlsx::addWorksheet(wb, "monthly_data")
      openxlsx::addWorksheet(wb, "custom_points")
      openxlsx::addWorksheet(wb, "custom_highlights")
      openxlsx::addWorksheet(wb, "custom_lines")
      
      meta <- isolate(metadata_inputs_annualcycle())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      if (nrow(monthly_ts_data()) > 0) openxlsx::writeData(wb, "monthly_data", monthly_ts_data())
      if (nrow(ts_points_data5()) > 0) openxlsx::writeData(wb, "custom_points", ts_points_data5())
      if (nrow(ts_highlights_data5()) > 0) openxlsx::writeData(wb, "custom_highlights", ts_highlights_data5())
      if (nrow(ts_lines_data5()) > 0) openxlsx::writeData(wb, "custom_lines", ts_lines_data5())
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # === Upload Metadata Handler ===
  observeEvent(input$update_metadata_ts5, {
    req(input$upload_metadata_ts5)
    
    file_path <- input$upload_metadata_ts5$datapath
    file_name <- input$upload_metadata_ts5$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_annualcycle") {
      process_uploaded_metadata_cycles(
        file_path           = file_path,
        metadata_sheet      = "custom_meta",
        df_monthly_ts       = "monthly_data",
        df_ts_points        = "custom_points",
        df_ts_highlights    = "custom_highlights",
        df_ts_lines         = "custom_lines",
        monthly_ts_data     = monthly_ts_data,
        ts_points_data      = ts_points_data5,
        ts_highlights_data  = ts_highlights_data5,
        ts_lines_data       = ts_lines_data5
      )
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_annualcycle.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  ### SEA observe, update & interactive controls----
  ####### Input updaters ----
  
  # Update variable selection
  observe({
    req(user_data_6())
    
    if (input$source_sea_6 == "User Data"){
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "user_variable_6",
        choices = names(user_data_6())[-1])
    }
  })
  
  # Set iniital lon/lat values on startup
  lonlat_vals6 = reactiveVal(c(initial_lon_values,initial_lat_values))
  
  # Continent buttons - updates range inputs and lonlat_values
  observeEvent(input$button_global_6,{
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(-180,180))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(-90,90))
    
    lonlat_vals6(c(-180,180,-90,90))
  }) 
  
  observeEvent(input$button_europe_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(-30,40))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(30,75))
    
    lonlat_vals6(c(-30,40,30,75))
  })
  
  observeEvent(input$button_asia_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(25,170))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(5,80))
    
    lonlat_vals6(c(25,170,5,80))
  })
  
  observeEvent(input$button_oceania_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(90,180))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(-55,20))
    
    lonlat_vals6(c(90,180,-55,20))
  })
  
  observeEvent(input$button_africa_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(-25,55))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(-40,40))
    
    lonlat_vals6(c(-25,55,-40,40))
  })
  
  observeEvent(input$button_n_america_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(-175,-10))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(5,85))
    
    lonlat_vals6(c(-175,-10,5,85))
  })
  
  observeEvent(input$button_s_america_6, {
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_longitude_6",
      label = NULL,
      value = c(-90,-30))
    
    updateNumericRangeInput(
      session = getDefaultReactiveDomain(),
      inputId = "range_latitude_6",
      label = NULL,
      value = c(-60,15))
    
    lonlat_vals6(c(-90,-30,-60,15))
  })
  
  observeEvent(input$button_coord_6, {
    lonlat_vals(c(input$range_longitude_6,input$range_latitude_6))        
  })
  
  #Make continental buttons stay highlighted
  observe({
    if (input$range_longitude_6[1] == -180 && input$range_longitude_6[2] == 180 &&
        input$range_latitude_6[1] == -90 && input$range_latitude_6[2] == 90) {
      addClass("button_global_6", "green-background")
    } else {
      removeClass("button_global_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == -30 && input$range_longitude_6[2] == 40 &&
        input$range_latitude_6[1] == 30 && input$range_latitude_6[2] == 75) {
      addClass("button_europe_6", "green-background")
    } else {
      removeClass("button_europe_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == 25 && input$range_longitude_6[2] == 170 &&
        input$range_latitude_6[1] == 5 && input$range_latitude_6[2] == 80) {
      addClass("button_asia_6", "green-background")
    } else {
      removeClass("button_asia_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == 90 && input$range_longitude_6[2] == 180 &&
        input$range_latitude_6[1] == -55 && input$range_latitude_6[2] == 20) {
      addClass("button_oceania_6", "green-background")
    } else {
      removeClass("button_oceania_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == -25 && input$range_longitude_6[2] == 55 &&
        input$range_latitude_6[1] == -40 && input$range_latitude_6[2] == 40) {
      addClass("button_africa_6", "green-background")
    } else {
      removeClass("button_africa_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == -175 && input$range_longitude_6[2] == -10 &&
        input$range_latitude_6[1] == 5 && input$range_latitude_6[2] == 85) {
      addClass("button_n_america_6", "green-background")
    } else {
      removeClass("button_n_america_6", "green-background")
    }
  })
  
  observe({
    if (input$range_longitude_6[1] == -90 && input$range_longitude_6[2] == -30 &&
        input$range_latitude_6[1] == -60 && input$range_latitude_6[2] == 15) {
      addClass("button_s_america_6", "green-background")
    } else {
      removeClass("button_s_america_6", "green-background")
    }
  })
  
  #Month Range Updater
  observe({
    if (input$season_selected_6 == "Annual"){
      updateSliderTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_months_6",
        label = NULL,
        selected = c("January", "December"))
    }
  })
  
  observe({
    if (input$season_selected_6 == "DJF"){
      updateSliderTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_months_6",
        label = NULL,
        selected = c("December (prev.)", "February"))
    }
  })
  
  observe({
    if (input$season_selected_6 == "MAM"){
      updateSliderTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_months_6",
        label = NULL,
        selected = c("March", "May"))
    }
  })
  
  observe({
    if (input$season_selected_6 == "JJA"){
      updateSliderTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_months_6",
        label = NULL,
        selected = c("June", "August"))
    }
  })
  
  observe({
    if (input$season_selected_6 == "SON"){
      updateSliderTextInput(
        session = getDefaultReactiveDomain(),
        inputId = "range_months_6",
        label = NULL,
        selected = c("September", "November"))
    }
  })
  
  # Y-axis updater for SEA plot
  observe({
    if (input$axis_mode_6 == "Automatic") {
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_6",
        value = c(NA, NA)
      )
    }
  })
  
  observe({
    if (input$axis_mode_6 == "Fixed" &&
        (is.null(input$axis_input_6) || any(is.na(input$axis_input_6)))) {
      
      data <- SEA_datatable()
      relevant_cols <- data[, !names(data) %in% c("LAG_YEAR", "P")]
      
      padded_range <- set_sea_axis_values(relevant_cols)
      
      updateNumericRangeInput(
        session = getDefaultReactiveDomain(),
        inputId = "axis_input_6",
        value = padded_range
      )
    }
  })
  
  ####### Generate Metadata for SEA ----
  
  # === SEA Metadata Reactive ===
  metadata_inputs_sea <- reactive({
    generate_metadata_sea(
      axis_input_6               = input$axis_input_6,
      axis_mode_6                = input$axis_mode_6,
      coordinates_type_6         = input$coordinates_type_6,
      custom_6                   = input$custom_6,
      dataset_selected_6         = input$dataset_selected_6,
      download_options_6         = input$download_options_6,
      enable_custom_statistics_6 = input$enable_custom_statistics_6,
      enter_upload_6             = input$enter_upload_6,
      event_years_6              = input$event_years_6,
      file_type_timeseries6      = input$file_type_timeseries6,
      lag_years_6                = input$lag_years_6,
      ME_statistic_6             = input$ME_statistic_6,
      ME_variable_6              = input$ME_variable_6,
      range_latitude_6           = input$range_latitude_6,
      range_longitude_6          = input$range_longitude_6,
      range_months_6             = input$range_months_6,
      ref_period_6               = input$ref_period_6,
      ref_period_sg_6            = input$ref_period_sg_6,
      ref_single_year_6          = input$ref_single_year_6,
      sample_size_6              = input$sample_size_6,
      season_selected_6          = input$season_selected_6,
      show_confidence_bands_6    = input$show_confidence_bands_6,
      show_key_6                 = input$show_key_6,
      show_means_6               = input$show_means_6,
      show_observations_6        = input$show_observations_6,
      show_pvalues_6             = input$show_pvalues_6,
      show_ticks_6               = input$show_ticks_6,
      source_sea_6               = input$source_sea_6,
      title_mode_6               = input$title_mode_6,
      title1_input_6             = input$title1_input_6,
      use_custom_post_6          = input$use_custom_post_6,
      use_custom_pre_6           = input$use_custom_pre_6,
      user_variable_6            = input$user_variable_6,
      y_label_6                  = input$y_label_6,
      
      # Reactive val
      lonlat_vals = lonlat_vals6()
    )
  })
  
  # === SEA Metadata Download ===
  output$download_metadata_6 <- downloadHandler(
    filename = function() {"metadata_sea.xlsx"},
    content = function(file) {
      wb <- openxlsx::createWorkbook()
      openxlsx::addWorksheet(wb, "custom_meta")
      
      meta <- isolate(metadata_inputs_sea())
      if (nrow(meta) > 0) openxlsx::writeData(wb, "custom_meta", meta)
      
      openxlsx::saveWorkbook(wb, file)
    }
  )
  
  # === SEA Metadata Upload ===
  observeEvent(input$update_metadata_6, {
    req(input$upload_metadata_6)
    
    file_path <- input$upload_metadata_6$datapath
    file_name <- input$upload_metadata_6$name
    
    if (!is.null(file_name) && tools::file_path_sans_ext(file_name) == "metadata_sea") {
      
      process_uploaded_metadata_sea(
        file_path        = file_path,
        metadata_sheet   = "custom_meta",
        rv_lonlat_vals   = lonlat_vals6
      )
      
    } else {
      showModal(modalDialog(
        title = "Error",
        "Please upload the correct file: 'metadata_sea.xlsx'.",
        easyClose = TRUE,
        size = "s"
      ))
    }
  })
  
  # Processing and Plotting ----
  ### DATA PROCESSING ----  
  # NOTE that "primary" refers to anomalies, composites, variable 1 and dependent
  # variable while "secondary" refers to variable 2 and independent variable
  
  ####### Month range ----
  
  month_range_primary <- reactive({
    #Creating Numeric Vector for Month Range between 0 and 12
    if (input$nav1 == "tab1") {
      # Anomalies
      create_month_range(month_names_vector = input$range_months)
    } else if (input$nav1 == "tab2") {
      # Composites
      create_month_range(month_names_vector = input$range_months2)
    } else if (input$nav1 == "tab3") {
      # Correlation
      create_month_range(month_names_vector = input$range_months_v1)
    } else if (input$nav1 == "tab4") {
      # Regression
      create_month_range(month_names_vector = input$range_months_dv)
    } else if (input$nav1 == "tab6") {
      # SEA
      create_month_range(month_names_vector = input$range_months_6)
    }
  })
  
  month_range_secondary <- reactive({
    #Creating Numeric Vector for Month Range between 0 and 12
    if (input$nav1 == "tab3") {
      # Correlation
      create_month_range(month_names_vector = input$range_months_v2)
    } else if (input$nav1 == "tab4") {
      # Regression
      create_month_range(month_names_vector = input$range_months_iv)
    }
  })
  
  ####### Subset lons & Subset lats ----
  
  subset_lons_primary <- reactive({
    if (input$nav1 == "tab1") {   # Anomalies
      create_subset_lon_IDs(lon_range = lonlat_vals()[1:2])       
    } else if (input$nav1 == "tab2") {   # Composites
      create_subset_lon_IDs(lon_range = lonlat_vals2()[1:2])
    } else if (input$nav1 == "tab3") {   # Correlation
      create_subset_lon_IDs(lon_range = lonlat_vals_v1()[1:2])
    } else if (input$nav1 == "tab4") {   # Regression
      create_subset_lon_IDs(lon_range = lonlat_vals_dv()[1:2])
    } else if (input$nav1 == "tab5") {   # Annual Cycle
      create_subset_lon_IDs(lon_range = lonlat_vals5()[1:2])
    } else if (input$nav1 == "tab6") {   # SEA
      create_subset_lon_IDs(lon_range = lonlat_vals6()[1:2])
    }
  })
  
  subset_lons_secondary <- reactive({
    if (input$nav1 == "tab3"){   # Correlation
      create_subset_lon_IDs(lon_range = lonlat_vals_v2()[1:2])
    } else if (input$nav1 == "tab4"){   # Regression
      create_subset_lon_IDs(lon_range = lonlat_vals_iv()[1:2])
    }
  })
  
  subset_lats_primary <- reactive({
    if (input$nav1 == "tab1"){   # Anomalies
      create_subset_lat_IDs(lonlat_vals()[3:4])       
    } else if (input$nav1 == "tab2"){   # Composites
      create_subset_lat_IDs(lonlat_vals2()[3:4])
    } else if (input$nav1 == "tab3"){   # Correlation
      create_subset_lat_IDs(lonlat_vals_v1()[3:4])
    } else if (input$nav1 == "tab4"){   # Regression
      create_subset_lat_IDs(lonlat_vals_dv()[3:4])
    } else if (input$nav1 == "tab5") {   # Annual Cycle
      create_subset_lat_IDs(lonlat_vals5()[3:4])
    } else if (input$nav1 == "tab6"){   # SEA
      create_subset_lat_IDs(lonlat_vals6()[3:4])
    }
  })
  
  subset_lats_secondary <- reactive({
    if (input$nav1 == "tab3"){   # Correlation
      create_subset_lat_IDs(lonlat_vals_v2()[3:4])
    } else if (input$nav1 == "tab4"){   # Regression
      create_subset_lat_IDs(lonlat_vals_iv()[3:4])
    }
  })
  
  ####### Data ID ----
  # Generating data ID - c(pre-processed data?,dataset,variable,season)
  
  data_id_primary <- reactive({
    if (input$nav1 == "tab1") {
      # Anomalies
      generate_data_ID(
        dataset = input$dataset_selected,
        variable = input$variable_selected,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab2") {
      # Composites
      generate_data_ID(
        dataset = input$dataset_selected2,
        variable = input$variable_selected2,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab3") {
      # Correlation
      generate_data_ID(
        dataset = input$dataset_selected_v1,
        variable = input$ME_variable_v1,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab4") {
      # Regression
      generate_data_ID(
        dataset = input$dataset_selected_dv,
        variable = input$ME_variable_dv,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab6") {
      # SEA
      generate_data_ID(
        dataset = input$dataset_selected_6,
        variable = input$ME_variable_6,
        month_range = month_range_primary()
      )
    }
  })
  
  data_id_secondary <- reactive({
    if (input$nav1 == "tab3") {
      # Correlation
      generate_data_ID(
        dataset = input$dataset_selected_v2,
        variable = input$ME_variable_v2,
        month_range = month_range_secondary()
      )
    }
  })
  
  
  ####### Update custom_data ----
  
  # Update preprocessed and custom_data_primary (if required)
  
  observeEvent(data_id_primary(),{
    if (data_id_primary()[1] == 0){ # Only updates when new custom data is required...
      if (!identical(custom_data_id_primary()[2:3],data_id_primary()[2:3])){ # ....i.e. changed variable or dataset
        
        new_dataset = switch(data_id_primary()[2],
                             "1" = "ModE-RA",
                             "2" = "ModE-Sim",
                             "3" = "ModE-RAclim")
        new_variable = switch(data_id_primary()[3],
                              "1" = "Temperature",
                              "2" = "Precipitation",
                              "3" = "SLP",
                              "4" = "Z500")
        
        custom_data_primary(load_ModE_data(dataset = new_dataset, variable = new_variable)) # load new custom data
        custom_data_id_primary(data_id_primary()) # update custom data ID
      }
    } 
    
    # Update preprocessed data
    else if (data_id_primary()[1] == 2){ # Only updates when new pp data is required...
      if (!identical(preprocessed_data_id_primary()[2:4],data_id_primary()[2:4])){ # ....i.e. changed variable, dataset or month range
        preprocessed_data_primary(load_preprocessed_data(data_ID = data_id_primary()))# load new pp data
        preprocessed_data_id_primary(data_id_primary()) # update pp data ID
      }
    }
  })
  
  # Update custom_data_secondary (if required)
  observeEvent(data_id_secondary(),{
    if (data_id_secondary()[1] == 0){ # Only updates when new custom data is required...
      if (!identical(custom_data_id_secondary()[2:3],data_id_secondary()[2:3])){ # ....i.e. changed variable or dataset
        
        new_dataset = switch(data_id_secondary()[2],
                             "1" = "ModE-RA",
                             "2" = "ModE-Sim",
                             "3" = "ModE-RAclim")
        new_variable = switch(data_id_secondary()[3],
                              "1" = "Temperature",
                              "2" = "Precipitation",
                              "3" = "SLP",
                              "4" = "Z500")
        
        custom_data_secondary(load_ModE_data(dataset = new_dataset, variable = new_variable)) # load new custom data
        custom_data_id_secondary(data_id_secondary()) # update custom data ID
      }
    }
    
    # Update preprocessed data
    else if (data_id_secondary()[1] == 2){ # Only updates when new pp data is required...
      if (!identical(preprocessed_data_id_secondary()[2:4],data_id_secondary()[2:4])){ # ....i.e. changed variable, dataset or month range
        preprocessed_data_secondary(load_preprocessed_data(data_ID = data_id_secondary()))# load new pp data
        preprocessed_data_id_secondary(data_id_secondary()) # update pp data ID
      }
    }
  })
  
  ####### Geographic Subset ----
  
  data_output1_primary <- reactive({
    req(data_id_primary(),
        subset_lons_primary(),
        subset_lats_primary())
    if (data_id_primary()[1] != 2) {
      # i.e. preloaded or custom data
      create_latlon_subset(
        data_input = custom_data_primary(),
        data_ID = data_id_primary(),
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary()
      )
    } else {
      # i.e. preloaded data
      create_latlon_subset(
        data_input = preprocessed_data_primary(),
        data_ID = data_id_primary(),
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary()
        
      )
    }
  })
  
  data_output1_secondary <- reactive({
    req(data_id_secondary(),
        subset_lons_secondary(),
        subset_lats_secondary())
    if (data_id_secondary()[1] != 2) {
      # i.e. preloaded or custom data
      create_latlon_subset(
        data_input = custom_data_secondary(),
        data_ID = data_id_secondary(),
        subset_lon_IDs = subset_lons_secondary(),
        subset_lat_IDs = subset_lats_secondary()
      )
    } else {
      # i.e. preloaded data
      create_latlon_subset(
        data_input = preprocessed_data_secondary(),
        data_ID = data_id_secondary(),
        subset_lon_IDs = subset_lons_secondary(),
        subset_lat_IDs = subset_lats_secondary()
      )
    }
  })
  
  ####### Yearly subset ----
  
  data_output2_primary <- reactive({
    if (input$nav1 == "tab1") {
      # Anomalies
      create_yearly_subset(
        data_input = data_output1_primary(),
        data_ID = data_id_primary(),
        year_range = input$range_years,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab2") {
      # Composites
      create_yearly_subset_composite(
        data_output1_primary(),
        data_id_primary(),
        year_set_comp(),
        month_range_primary()
      )
    } else if (input$nav1 == "tab3") {
      # Correlation
      adjusted_years = input$range_years3 + input$lagyears_v1_cor
      create_yearly_subset(
        data_input = data_output1_primary(),
        data_ID = data_id_primary(),
        year_range = adjusted_years,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab4") {
      # Regression
      create_yearly_subset(
        data_input = data_output1_primary(),
        data_ID = data_id_primary(),
        year_range = input$range_years4,
        month_range = month_range_primary()
      )
    } else if (input$nav1 == "tab6") {
      # SEA
      create_yearly_subset(
        data_input = data_output1_primary(),
        data_ID = data_id_primary(),
        year_range = c(1422, 2008),
        month_range = month_range_primary()
      )
    }
  })
  
  data_output2_secondary <- reactive({
    if (input$nav1 == "tab3") {
      # Correlation
      adjusted_years = input$range_years3 + input$lagyears_v2_cor
      create_yearly_subset(
        data_input = data_output1_secondary(),
        data_ID = data_id_secondary(),
        year_range = adjusted_years,
        month_range = month_range_secondary()
      )
    }
  })
  
  ####### Reference subset ----
  # Create reference yearly subset & convert to mean
  data_output3_primary <- reactive({
    if (input$nav1 == "tab1") {
      # Anomalies
      apply(
        create_yearly_subset(
          data_input = data_output1_primary(),
          data_ID = data_id_primary(),
          year_range = input$ref_period,
          month_range = month_range_primary()
        ),
        c(1:2),
        mean
      )
    } else if (input$nav1 == "tab2") {
      # Composites
      if (input$mode_selected2 == "Fixed reference") {
        apply(
          create_yearly_subset(
            data_input = data_output1_primary(),
            data_ID = data_id_primary(),
            year_range = input$ref_period2,
            month_range = month_range_primary()
          ),
          
          c(1:2),
          mean
        )
      } else if (input$mode_selected2 == "Custom reference") {
        apply(
          create_yearly_subset_composite(
            data_output1_primary(),
            data_id_primary(),
            year_set_comp_ref(),
            month_range_primary()
          ),
          c(1:2),
          mean
        )
      } else {
        NA
      }
    } else if (input$nav1 == "tab3") {
      # Correlation
      apply(
        create_yearly_subset(
          data_input = data_output1_primary(),
          data_ID = data_id_primary(),
          year_range = input$ref_period_v1,
          month_range = month_range_primary()
        ),
        c(1:2),
        mean
      )
    } else if (input$nav1 == "tab4") {
      # Regression
      apply(
        create_yearly_subset(
          data_input = data_output1_primary(),
          data_ID = data_id_primary(),
          year_range = input$ref_period_dv,
          month_range = month_range_primary()
        ),
        c(1:2),
        mean
      )
    } else if (input$nav1 == "tab6") {
      # SEA
      apply(
        create_yearly_subset(
          data_input = data_output1_primary(),
          data_ID = data_id_primary(),
          year_range = input$ref_period_6,
          month_range = month_range_primary()
        ),
        c(1:2),
        mean
      )
    }
  })
  
  data_output3_secondary <- reactive({
    if (input$nav1 == "tab3") {
      # Correlation
      apply(
        create_yearly_subset(
          data_input = data_output1_secondary(),
          data_ID = data_id_secondary(),
          year_range = input$ref_period_v2,
          month_range = month_range_secondary()
        ),
        c(1:2),
        mean
      )
    }
  })    
  
  
  #Converting absolutes to anomalies
  data_output4 <- reactive({
    processed_data4 <- convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
    
    return(processed_data4)
  })
  
  ####### Convert to anomalies ----
  
  data_output4_primary <- reactive({
    if (input$nav1 == "tab1") {
      # Anomalies
      convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
    } else if (input$nav1 == "tab2") {
      # Composites
      if (input$mode_selected2 == "X years prior") {
        convert_composite_to_anomalies(
          data_output2_primary(),
          data_output1_primary(),
          data_id_primary(),
          year_set_comp(),
          month_range_primary(),
          input$prior_years2
        )
      } else {
        convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
      }
    } else if (input$nav1 == "tab3") {
      # Correlation
      if (input$mode_selected_v1 == "Absolute") {
        data_output2_primary()
      } else {
        convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
      }
    } else if (input$nav1 == "tab4") {
      # Regression
      if (input$mode_selected_dv == "Absolute") {
        data_output2_primary()
      } else {
        convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
      }
    } else if (input$nav1 == "tab6") {
      # SEA
      convert_subset_to_anomalies(data_input = data_output2_primary(), ref_data = data_output3_primary())
    }
  })
  
  data_output4_secondary <- reactive({
    if (input$nav1 == "tab3"){   # Correlation
      if (input$mode_selected_v2 == "Absolute"){
        data_output2_secondary()
      } else {
        convert_subset_to_anomalies(data_input = data_output2_secondary(), ref_data = data_output3_secondary())
      }
    }
  })
  
  ### ANOMALIES Load SD ratio data, plotting & downloads ----  
  ####### SD ratio data ----
  
  # Update SD ratio data when required
  observe({
    if((input$ref_map_mode == "SD Ratio")|(input$custom_statistic == "SD ratio")){
      if (input$nav1 == "tab1"){ # check current tab
        if (!identical(SDratio_data_id()[3:4],data_id_primary()[3:4])){ # check to see if currently loaded variable & month range are the same
          if (data_id_primary()[1] != 0) { # check for preprocessed SD ratio data
            new_data_id = data_id_primary()
            new_data_id[2] = 4 # change data ID to SD ratio
            
            SDratio_data(load_preprocessed_data(data_ID = new_data_id)) # load new SD data
            SDratio_data_id(data_id_primary()) # update custom data ID
          }
          else{
            SDratio_data(load_ModE_data(dataset = "SD Ratio", variable = input$variable_selected)) # load new SD data
            SDratio_data_id(data_id_primary()) # update custom data ID
          }
        } 
      }
    }
  })
  
  # Processed SD data
  SDratio_subset = reactive({
    
    req(input$nav1 == "tab1") # Only run code if in the current tab
    
    req(((input$ref_map_mode == "SD Ratio")|(input$custom_statistic == "SD ratio")))
    
    create_sdratio_data(SDratio_data(),data_id_primary(),"general",input$variable_selected,
                        subset_lons_primary(),subset_lats_primary(),month_range_primary(),input$range_years)
  })
  
  ####### Plotting ----

  # Map customization (statistics and map titles)
  
  plot_titles <- reactive({
    req(input$nav1 == "tab1")
    req(input$range_years)

    # Validate year range
    if (length(input$range_years) < 2 ||
        any(is.na(input$range_years)) ||
        input$range_years[1] > input$range_years[2]) {
      return(NULL)
    }

    tryCatch({
      generate_titles(
        tab = "general",
        dataset = input$dataset_selected,
        variable = input$variable_selected,
        mode = "Anomaly",
        map_title_mode = input$title_mode,
        ts_title_mode = input$title_mode_ts,
        month_range = month_range_primary(),
        year_range = input$range_years,
        baseline_range = input$ref_period,
        baseline_years_before = NA,
        lon_range = lonlat_vals()[1:2],
        lat_range = lonlat_vals()[3:4],
        map_custom_title1 = input$title1_input,
        map_custom_title2 = input$title2_input,
        ts_custom_title1 = input$title1_input_ts,
        ts_custom_title2 = NA,
        map_title_size = input$title_size_input,
        ts_title_size = input$title_size_input_ts,
        ts_data = timeseries_data()
      )
    }, error = function(e) {
      message("plot_titles() failed: ", e$message)
      return(NULL)
    })
  })
  
  
  # Add value to custom title
  
  # Step 1: Clear inputs when switching to "Default"
  observeEvent(input$title_mode, {
    if (input$title_mode == "Default" || input$title_mode_ts == "Default") {
      updateTextInput(session, "title1_input", value = "")
      updateTextInput(session, "title2_input", value = "")
      updateTextInput(session, "title1_input_ts", value = "")
    }
  })

  # Step 2: Fill updated default values after a short delay
  observeEvent({
    input$title_mode
  }, {
    req(input$title_mode == "Default" || input$title_mode_ts == "Default")

    invalidateLater(100, session)

    isolate({
      titles <- plot_titles()
      if (is.null(titles)) {
        showNotification("Could not generate default titles — check your year range.", type = "error")
        updateTextInput(session, "title1_input", value = "Invalid Title")
        updateTextInput(session, "title2_input", value = "")
        updateTextInput(session, "title1_input_ts", value = "")
      } else {
        updateTextInput(session, "title1_input", value = titles$map_title)
        updateTextInput(session, "title2_input", value = titles$map_subtitle)
        updateTextInput(session, "title1_input_ts", value = titles$ts_title)
      }
    })
  })
  
  # Anomalies Statistics
  map_statistics = reactive({
    req(input$nav1 == "tab1") # Only run code if in the current tab
    my_stats = create_stat_highlights_data(
      data_output4_primary(),
      SDratio_subset(),
      input$custom_statistic,
      input$sd_ratio,
      NA,
      subset_lons_primary(),
      subset_lats_primary()
    )
    return(my_stats)
  })
  
  #Plotting the Data (Maps)
  map_data <- function() {
    create_map_datatable(
      data_input = data_output4_primary(),
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary()
    )
  }
  
  final_map_data <- reactive({
    # req(input$value_type_map_data)  # Ensure input is available
    
    option <- input$value_type_map_data
    
    if (option == "Anomalies") {
      map_data()
    } else if (option == "Absolute") {
      create_map_datatable(data_input = data_output2_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (option == "Reference") {
      create_map_datatable(data_input = data_output3_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (option == "SD Ratio") {
      req(SDratio_subset())
      create_map_datatable(data_input = SDratio_subset(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    }
  })
  
  output$data1 <- renderTable({final_map_data()}, rownames = TRUE)
  
  #Plotting the Map
  map_dimensions <- reactive({
    req(input$nav1 == "tab1") # Only run code if in the current tab
    m_d = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_map_width,
      output_height = input$dimension[2],
      hide_axis = input$hide_axis
    )
    return(m_d)
  })
  
  map_plot <- function() {
    
    # Validate year range BEFORE anything else
    if (is.null(input$range_years) ||
        length(input$range_years) < 2 ||
        any(is.na(input$range_years)) ||
        input$range_years[1] > input$range_years[2] ||
        input$range_years[1] < 1422 ||
        input$range_years[2] > 2008) {
      validate(
        need(FALSE, "Please select a valid year range between 1422 and 2008.")
      )
    }
    
    plot_map(
      data_input = create_geotiff(map_data()),
      lon_lat_range = lonlat_vals(),
      variable = input$variable_selected,
      
      mode = "Anomaly",
      
      titles = plot_titles(),
      axis_range = input$axis_input,
      hide_axis = input$hide_axis,
      
      points_data = map_points_data(),
      highlights_data = map_highlights_data(),
      stat_highlights_data = map_statistics(),
      
      c_borders = input$hide_borders,
      white_ocean = input$white_ocean,
      white_land = input$white_land,
      
      plotOrder = plotOrder(),
      shpOrder = input$shapes_order[input$shapes_order %in% input$shapes],
      input = input,
      plotType = "shp_colour_",
      
      projection = input$projection,
      center_lat = input$center_lat,
      center_lon = input$center_lon,
      
      show_rivers = input$show_rivers,
      label_rivers = input$label_rivers,
      show_lakes = input$show_lakes,
      label_lakes = input$label_lakes,
      show_mountains = input$show_mountains,
      label_mountains = input$label_mountains)
  }

  
  output$map <- renderPlot({
    map_plot()
  }, width = function() {
    map_dimensions()[1]
  }, height = function() {
    map_dimensions()[2]
  })
  
  
  #Ref/Absolute/SD ratio Map
  ref_map_data <- function() {
    if (input$ref_map_mode == "Absolute Values") {
      create_map_datatable(data_input = data_output2_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (input$ref_map_mode == "Reference Values") {
      create_map_datatable(data_input = data_output3_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (input$ref_map_mode == "SD Ratio") {
      req(SDratio_subset())
      create_map_datatable(data_input = SDratio_subset(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    }
  }    
  
  ref_map_titles = reactive({
    req(input$nav1 == "tab1") # Only run code if in the current tab
    
    active_tab <- ifelse(input$ref_map_mode == "SD Ratio", "sdratio", "general")
    years_or_ref <- if (input$ref_map_mode == "Reference Values") {
      input$ref_period
    } else {
      input$range_years
    }
    
    rm_title <- generate_titles(
      tab = active_tab,
      dataset = input$dataset_selected,
      variable = input$variable_selected,
      mode = "Absolute",
      map_title_mode = input$title_mode,
      ts_title_mode = input$title_mode_ts,
      month_range = month_range_primary(),
      year_range = years_or_ref,
      lon_range = lonlat_vals()[1:2],
      lat_range = lonlat_vals()[3:4],
      map_custom_title1 = input$title1_input,
      map_custom_title2 = input$title2_input,
      ts_custom_title1 = input$title1_input_ts,
      map_title_size = input$title_size_input
    )
  })  
  
  ref_map_plot <- function(){
    if (input$ref_map_mode == "Absolute Values" | input$ref_map_mode == "Reference Values" ){
      v=input$variable_selected; m="Absolute"; axis_range=NULL
      
    } else if(input$ref_map_mode == "SD Ratio"){
      v=NULL; m="SD Ratio"; axis_range=c(0,1)
    }
    plot_map(
      data_input = create_geotiff(ref_map_data()),
      lon_lat_range = lonlat_vals(),
      variable = v,
      
      mode = m,
      
      titles = ref_map_titles(),
      axis_range = axis_range,
      
      c_borders = input$hide_borders,
      white_ocean = input$white_ocean,
      white_land = input$white_land,
      
      plotOrder = plotOrder(),
      shpOrder = input$shapes_order[input$shapes_order %in% input$shapes],
      input = input,
      plotType = "shp_colour_",
      
      projection = input$projection,
      center_lat = input$center_lat,
      center_lon = input$center_lon,
      
      show_rivers = input$show_rivers,
      label_rivers = input$label_rivers,
      show_lakes = input$show_lakes,
      label_lakes = input$label_lakes,
      show_mountains = input$show_mountains,
      label_mountains = input$label_mountains
    )
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
    req(input$nav1 == "tab1") # Only run code if in the current tab
    
    #Plot normal timeseries if year range is > 1 year
    if (input$range_years[1] != input$range_years[2]) {
      ts_data1 <- create_timeseries_datatable(
        data_input = data_output4_primary(),
        year_input = input$range_years,
        year_input_type = "range",
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary()
      )
      ts_data2 = add_stats_to_TS_datatable(
        data_input = ts_data1,
        add_moving_average = input$custom_average_ts,
        moving_average_range = input$year_moving_ts,
        moving_average_alignment = "center",
        add_percentiles = input$custom_percentile_ts,
        percentiles = input$percentile_ts,
        use_MA_percentiles = input$moving_percentile_ts
      )
    }
    # Plot monthly TS if year range = 1 year
    else {
      ts_data1 = load_ModE_data(dataset = input$dataset_selected,
                                variable = input$variable_selected)
      
      ts_data2 = create_monthly_TS_data(
        ts_data1,
        input$dataset_selected,
        input$variable_selected,
        input$range_years[1],
        input$range_longitude,
        input$range_latitude,
        "Anomaly",
        "Individual years",
        input$ref_period
      )
    }
    return(ts_data2)
  })
  
  timeseries_data_output = reactive({
    req(input$nav1 == "tab1") # Only run code if in the current tab
    if (input$range_years[1] != input$range_years[2]) {
      output_ts_table = rewrite_tstable(tstable = timeseries_data(),
                                        variable = input$variable_selected)
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
  
  timeseries_plot_anom<- function(){
    
    #Plot normal timeseries if year range is > 1 year
    if (input$range_years[1] != input$range_years[2]){
      # Generate NA or reference mean
      ref_ts = signif(mean(data_output3_primary()),3)
    } else {
      ref_ts = NA
    }
    
    # New 
    p <- plot_timeseries(
      type = "Anomaly",
      data = timeseries_data(),
      variable = input$variable_selected,
      ref = ref_ts,
      year_range = input$range_years,
      month_range_1 = month_range_primary(),
      titles = plot_titles(),
      show_key = input$show_key_ts,
      key_position = input$key_position_ts,
      show_ref = input$show_ref_ts,
      show_ticks = input$show_ticks_ts,
      tick_interval = input$xaxis_numeric_interval_ts,
      moving_ave = input$custom_average_ts,
      moving_ave_year = input$year_moving_ts,
      custom_percentile = input$custom_percentile_ts,
      percentiles = input$percentile_ts,
      highlights = ts_highlights_data(),
      lines = ts_lines_data(),
      points = ts_points_data(),
      axis_range = input$axis_input_ts
      )
    
    return(p)
  }
  
  output$timeseries <- renderPlot({timeseries_plot_anom()}, height = 400)
  
  ####### ModE-RA sources ----
  
  # Set up values and functions for plotting
  fad_zoom  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  season_fad_short = reactive({
    switch(input$fad_season,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  fad_global_data = reactive({
    load_modera_source_data(year = input$fad_year, season = season_fad_short())
  })
  
  # Plot map 
  fad_plot = function(base_size = 18) {
    plot_modera_sources(
      ME_source_data = fad_global_data(),
      year = input$fad_year,
      season = season_fad_short(),
      minmax_lonlat = fad_zoom(),
      base_size = base_size
    )
  }
  
  
  fad_dimensions <- reactive({
    req(input$nav1 == "tab1") # Only run code if in the current tab
    m_d_f = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_fad_map_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    return(m_d_f)
  })
  
  output$fad_map <- renderPlot({
    fad_plot()
  }, width = function() {
    fad_dimensions()[1]
  }, height = function() {
    fad_dimensions()[2]
  })
  
  # Set up data function
  fad_data <- function() {
    fad_base_data = download_feedback_data(
      global_data = fad_global_data(),
      lon_range = fad_zoom()[1:2],
      lat_range = fad_zoom()[3:4]
    )
    
    # Remove the last column
    fad_base_data = fad_base_data[, -ncol(fad_base_data)]
    
    return(fad_base_data)
  }
  
  observeEvent(lonlat_vals()|input$fad_reset_zoom,{
    fad_zoom(lonlat_vals())
  })
  
  observeEvent(input$brush_fad,{
    brush = input$brush_fad
    req(brush)  # ensure brush is not NULL
    fad_zoom(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
  })
  
  # Update fad_year 
  observeEvent(input$range_years[1], {
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "fad_year",
      value = input$range_years[1])
  })
  
  # Update fad_season
  observeEvent(month_range_primary()[1], {
    
    req(input$nav1 == "tab1") # Only run code if in the current tab
    
    if (month_range_primary()[1] >3 & month_range_primary()[1] <10){
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season",
        selected = "April to September")
    } else {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season",
        selected = "October to March")
    }
  })
  
  
  ####### Downloads ----
  #Downloading General data
  output$download_map       <- downloadHandler(filename = function() {paste(plot_titles()$file_title, "-map.", input$file_type_map, sep = "")},
                                               content = function(file) {
                                                 if (input$file_type_map == "png") {
                                                   png(file, width = map_dimensions()[3], height = map_dimensions()[4], res = 200, bg = "transparent")
                                                 } else if (input$file_type_map == "jpeg") {
                                                   jpeg(file, width = map_dimensions()[3], height = map_dimensions()[4], res = 200, bg = "white")
                                                 } else {
                                                   pdf(file, width = map_dimensions()[3] / 200, height = map_dimensions()[4] / 200, bg = "transparent")
                                                 }
                                                 print(map_plot())  # Use print to ensure the plot is fully rendered
                                                 dev.off()}
  )
  
  output$download_map_sec   <- downloadHandler(filename = function() {paste(plot_titles()$file_title, "-sec_map.", input$file_type_map_sec, sep = "")},
                                               content = function(file) {
                                                 if (input$file_type_map_sec == "png") {
                                                   png(file, width = map_dimensions()[3], height = map_dimensions()[4], res = 200, bg = "transparent")
                                                 } else if (input$file_type_map_sec == "jpeg") {
                                                   jpeg(file, width = map_dimensions()[3], height = map_dimensions()[4], res = 200, bg = "white")
                                                 } else {
                                                   pdf(file, width = map_dimensions()[3] / 200, height = map_dimensions()[4] / 200, bg = "transparent")
                                                 }
                                                 print(ref_map_plot())
                                                 dev.off()}
  )
  
  output$download_timeseries      <- downloadHandler(filename = function(){paste(plot_titles()$file_title,"-ts.",input$file_type_timeseries, sep = "")},
                                                     content  = function(file) {
                                                       if (input$file_type_timeseries == "png"){
                                                         png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                         
                                                       } else if (input$file_type_timeseries == "jpeg"){
                                                         jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                         
                                                       } else {
                                                         pdf(file, width = 14, height = 6, bg = "transparent") 
                                                       }
                                                       print(timeseries_plot_anom())
                                                       dev.off()
                                                     }) 
  
  output$download_map_data <- downloadHandler(
    filename = function() {
      paste(plot_titles()$file_title,
            "-mapdata.",
            input$file_type_map_data,
            sep = "")
    },
    content = function(file) {
      if (input$file_type_map_data == "csv") {
        map_data_new <- rewrite_maptable(
          maptable = final_map_data(),
          subset_lon_IDs = subset_lons_primary(),
          subset_lat_IDs = subset_lats_primary()
        )
        colnames(map_data_new) <- NULL
        
        write.csv(map_data_new, file, row.names = FALSE)
      } else if (input$file_type_map_data == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = final_map_data(),
            subset_lon_IDs = subset_lons_primary(),
            subset_lat_IDs = subset_lats_primary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$file_type_map_data == "GeoTIFF") {
        create_geotiff(final_map_data(), file)
      }
    }
  )
  
  output$download_timeseries_data  <- downloadHandler(filename = function(){paste(plot_titles()$file_title, "-tsdata.",input$file_type_timeseries_data, sep = "")},
                                                      content  = function(file) {
                                                        if (input$file_type_timeseries_data == "csv"){
                                                          write.csv(timeseries_data_output(), file,
                                                                    row.names = FALSE,
                                                                    fileEncoding = "latin1")
                                                        } else {
                                                          openxlsx::write.xlsx(timeseries_data_output(), file,
                                                                               row.names = FALSE,
                                                                               col.names = TRUE)
                                                        }})

  
  output$download_fad <- downloadHandler(
    filename = function()
    {paste("Assimilated Observations_", gsub(" ", "", input$fad_season), "_", input$fad_year, ".", input$file_type_fad, sep = "")},
    
    content = function(file) {
      mmd = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_fad_map_width,
        output_height = input$dimension[2],
        hide_axis = FALSE
      )
      if (input$file_type_fad == "png") {
        png(file, width = mmd[3], height = mmd[4], res = 400, bg = "transparent")
        print(fad_plot(base_size = 9))
        dev.off()
      } else if (input$file_type_fad == "jpeg") {
        jpeg(file, width = mmd[3], height = mmd[4], res = 400,bg = "white")
        print(fad_plot(base_size = 9))
        dev.off()
      } else {
        pdf(file, width = mmd[3] / 400, height = mmd[4] / 400, bg = "transparent")
        print(fad_plot(base_size = 9))
        dev.off()
      }
    }
  )
  
  
  output$download_fad_data       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season),"_",input$fad_year,"_data.",input$data_file_type_fad, sep = "")},
                                                    content  = function(file) {
                                                      if (input$data_file_type_fad == "csv"){
                                                        write.csv(fad_data(), file,
                                                                  row.names = FALSE)
                                                      } else {
                                                        openxlsx::write.xlsx(fad_data(), file,
                                                                             col.names = TRUE,
                                                                             row.names = FALSE)
                                                      }})
  
  output$download_netcdf <- downloadHandler(
    filename = function() {
      paste(plot_titles()$netcdf_title, ".nc", sep = "")
    },
    content  = function(file) {
      netcdf_ID = sample(1:1000000, 1)
      generate_custom_netcdf (
        data_input = data_output4_primary(),
        tab = "general",
        dataset = input$dataset_selected,
        ncdf_ID = netcdf_ID,
        variable = input$variable_selected,
        user_nc_variables = input$netcdf_variables,
        mode = "Anomaly",
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        month_range = month_range_primary(),
        year_range = input$range_years,
        baseline_range = input$ref_period,
        baseline_years_before = NA
      )
      file.copy(paste("user_ncdf/netcdf_", netcdf_ID, ".nc", sep = ""), file)
      file.remove(paste("user_ncdf/netcdf_", netcdf_ID, ".nc", sep = ""))
    }
  )
  
  ### COMPOSITE Year range,load SD ratio data, plotting & downloads ---- 
  
  ####### Year Range ----
  
  #Creating a year set for composite
  year_set_comp <- reactive({
    read_composite_data(input$range_years2, input$upload_file2$datapath, input$enter_upload2)
  })
  
  #List of custom anomaly years (from read Composite) as reference data
  year_set_comp_ref <- reactive({
    read_composite_data(input$range_years2a, input$upload_file2a$datapath, input$enter_upload2a)
  })
  
  ####### SD Ratio data ----
  
  # Update SD ratio data when required
  observe({
    if((input$ref_map_mode2 == "SD Ratio")|(input$custom_statistic2 == "SD ratio")){
      if (input$nav1 == "tab2"){ # check current tab
        if (!identical(SDratio_data_id()[3:4],data_id_primary()[3:4])){ # check to see if currently loaded variable & month range are the same
          if (data_id_primary()[1] != 0) { # check for preprocessed SD ratio data
            new_data_id = data_id_primary()
            new_data_id[2] = 4 # change data ID to SD ratio
            
            SDratio_data(load_preprocessed_data(data_ID = new_data_id)) # load new SD data
            SDratio_data_id(data_id_primary()) # update custom data ID
          }
          else{
            SDratio_data(load_ModE_data(dataset = "SD Ratio", variable = input$variable_selected2)) # load new SD data
            SDratio_data_id(data_id_primary()) # update custom data ID
          }
        } 
      }
    }
  })
  
  # Processed SD data
  SDratio_subset_2 = reactive({
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    req(((input$ref_map_mode2 == "SD Ratio")|(input$custom_statistic2 == "SD ratio")))
    
    create_sdratio_data(SDratio_data(),data_id_primary(),"composites",input$variable_selected2,
                        subset_lons_primary(),subset_lats_primary(),month_range_primary(),year_set_comp())
  })
  
  ####### Plotting ----
  
  # Map customization (composites)
  
  plot_titles_composites <- reactive({
    req(input$nav1 == "tab2")
    req(input$ref_period2)

    # Validate year range
    if (length(input$ref_period2) < 2 || any(is.na(input$ref_period2)) || input$ref_period2[1] > input$ref_period2[2]) {
      return(NULL)
    }
    
    tryCatch({
      generate_titles(
        tab = "composites",
        dataset = input$dataset_selected2,
        variable = input$variable_selected2,
        mode = input$mode_selected2,
        map_title_mode = input$title_mode2,
        ts_title_mode = input$title_mode_ts2,
        month_range = month_range_primary(),
        year_range = input$range_years2,
        baseline_range = input$ref_period2,
        baseline_years_before = input$prior_years2,
        lon_range = lonlat_vals2()[1:2],
        lat_range = lonlat_vals2()[3:4],
        map_custom_title1 = input$title1_input2,
        map_custom_title2 = input$title2_input2,
        ts_custom_title1 = input$title1_input_ts2,
        ts_custom_title2 = NA,
        map_title_size = input$title_size_input2,
        ts_title_size = input$title_size_input_ts2,
        ts_data = timeseries_data_2()
      )
    }, error = function(e) {
      message("plot_titles_composites() failed: ", e$message)
      return(NULL)
    })
  })
  
  # Add value to custom title (composites)
  
  # Step 1: Clear inputs when switching to "Default"
  observeEvent(input$title_mode2, {
    if (input$title_mode2 == "Default" || input$title_mode_ts2 == "Default") {
      updateTextInput(session, "title1_input2", value = "")
      updateTextInput(session, "title2_input2", value = "")
      updateTextInput(session, "title1_input_ts2", value = "")
    }
  })
  
  # Step 2: After clearing, fill in updated values (in Default mode only)
  observeEvent({
    input$title_mode2
  }, {
    req(input$title_mode2 == "Default" || input$title_mode_ts2 == "Default")
    
    invalidateLater(100, session)
    
    isolate({
      titles <- plot_titles_composites()
      if (is.null(titles)) {
        showNotification("Could not generate composite titles — check your year range.", type = "error")
        updateTextInput(session, "title1_input2", value = "Invalid Title")
        updateTextInput(session, "title2_input2", value = "")
        updateTextInput(session, "title1_input_ts2", value = "")
      } else {
        updateTextInput(session, "title1_input2", value = titles$map_title)
        updateTextInput(session, "title2_input2", value = titles$map_subtitle)
        updateTextInput(session, "title1_input_ts2", value = titles$ts_title)
      }
    })
  })
  
  # Composite statistics
  
  map_statistics_2 = reactive({
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    my_stats = create_stat_highlights_data(data_output4_primary(),SDratio_subset_2(),
                                           input$custom_statistic2,input$sd_ratio2,
                                           input$percentage_sign_match2,
                                           subset_lons_primary(),subset_lats_primary())
    
    return(my_stats)
  })
  
  #Plotting the Data (Maps)
  map_data_2 <- function() {
    create_map_datatable(data_input = data_output4_primary(),
                         subset_lon_IDs = subset_lons_primary(),
                         subset_lat_IDs = subset_lats_primary())
  }
  
  final_map_data_2 <- reactive({
    req(input$value_type_map_data2)  # Ensure input is available
    
    option <- input$value_type_map_data2
    
    if (option == "Anomalies") {
      map_data()
    } else if (option == "Absolute") {
      create_map_datatable(data_input = data_output2_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (option == "Reference") {
      create_map_datatable(data_input = data_output3_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (option == "SD Ratio") {
      req(SDratio_subset_2())
      create_map_datatable(data_input = SDratio_subset_2(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    }
  })
  
  output$data3 <- renderTable({final_map_data_2()},
                              rownames = TRUE)
  
  #Plotting the Map
  map_dimensions_2 <- reactive({
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    m_d_2 = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_map2_width,
      output_height = input$dimension[2] * 0.85,
      hide_axis = input$hide_axis2
    )
    return(m_d_2)
  })
  
  map_plot_2 <- function() {
    
    # Validate year range BEFORE anything else
    if (is.null(input$ref_period2) ||
        length(input$ref_period2) < 2 ||
        any(is.na(input$ref_period2)) ||
        input$ref_period2[1] > input$ref_period2[2] ||
        input$ref_period2[1] < 1422 ||
        input$ref_period2[2] > 2008) {
      validate(need(FALSE, "Please select a valid year range between 1422 and 2008."))
    }

    plot_map(
      data_input = create_geotiff(map_data_2()),
      lon_lat_range = lonlat_vals2(),
      variable = input$variable_selected2,
      mode = input$mode_selected2,
      titles = plot_titles_composites(),
      axis_range = input$axis_input2,
      hide_axis = input$hide_axis2,
      
      points_data = map_points_data2(),
      highlights_data = map_highlights_data2(),
      stat_highlights_data = map_statistics_2(),
      
      c_borders = input$hide_borders2,
      white_ocean = input$white_ocean2,
      white_land = input$white_land2,
      
      plotOrder = plotOrder2(),
      shpOrder = input$shapes2_order[input$shapes2_order %in% input$shapes2],
      input = input,
      plotType = "shp_colour2_",
      
      projection = input$projection2,
      center_lat = input$center_lat2,
      center_lon = input$center_lon2,
      
      show_rivers = input$show_rivers2,
      label_rivers = input$label_rivers2,
      show_lakes = input$show_lakes2,
      label_lakes = input$label_lakes2,
      show_mountains = input$show_mountains2,
      label_mountains = input$label_mountains2
    )
  }
  
  output$map2 <- renderPlot({
    map_plot_2()
  }, width = function() {
    map_dimensions_2()[1]
  }, height = function() {
    map_dimensions_2()[2]
  })
  
  # code line below sets height as a function of the ratio of lat/lon 
  
  
  #Ref/Absolute Map
  ref_map_data_2 <- function() {
    if (input$ref_map_mode2 == "Absolute Values") {
      create_map_datatable(data_input = data_output2_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (input$ref_map_mode2 == "Reference Values") {
      create_map_datatable(data_input = data_output3_primary(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    } else if (input$ref_map_mode2 == "SD Ratio") {
      create_map_datatable(data_input = SDratio_subset_2(),
                           subset_lon_IDs = subset_lons_primary(),
                           subset_lat_IDs = subset_lats_primary())
    }
  }    
  
  ref_map_titles_2 = reactive({
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    # Define mode-specific parameters
    mode_params <- list(
      "Absolute Values" = list(type = "composites", years = year_set_comp()),
      "Reference Values" = list(type = "reference", years = year_set_comp_ref()),
      "SD Ratio" = list(type = "sdratio", years = c(NA, NA))
    )
    params <- mode_params[[input$ref_map_mode2]]
    
    rm_title2 <- generate_titles(
      tab = params$type,
      dataset = input$dataset_selected2,
      variable = input$variable_selected2,
      mode = "Absolute", 
      map_title_mode = input$title_mode2,
      ts_title_mode = input$title_mode_ts2, 
      month_range = month_range_primary(),
      year_range = params$years, 
      lon_range = lonlat_vals2()[1:2],
      lat_range = lonlat_vals2()[3:4], 
      map_custom_title1 = input$title1_input2,
      map_custom_title2 = input$title2_input2,
      ts_custom_title1 = input$title1_input_ts2, 
      map_title_size = input$title_size_input2
    )
  })  
  
  ref_map_plot_2 <- function(){
    if (input$ref_map_mode2 == "Absolute Values" | input$ref_map_mode2 == "Reference Values" ){
      v=input$variable_selected2; m="Absolute"; axis_range=NULL
      
    } else if (input$ref_map_mode2 == "SD Ratio"){
      v=NULL; m="SD Ratio"; axis_range=c(0,1)
    }
    plot_map(data_input = create_geotiff(ref_map_data_2()),
             lon_lat_range = lonlat_vals2(),
             variable = v,
             mode = m,
             titles = ref_map_titles_2(),
             axis_range,
             
             c_borders = input$hide_borders2,
             white_ocean = input$white_ocean2,
             white_land = input$white_land2,
             
             plotOrder = plotOrder2(),
             shpOrder = input$shapes2_order[input$shapes2_order %in% input$shapes2],
             input = input,
             plotType = "shp_colour2_", 
             
             projection = input$projection2,
             center_lat = input$center_lat2,
             center_lon = input$center_lon2,
             
             show_rivers = input$show_rivers2,
             label_rivers = input$label_rivers2,
             show_lakes = input$show_lakes2,
             label_lakes = input$label_lakes2,
             show_mountains = input$show_mountains2,
             label_mountains = input$label_mountains2)
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
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    #Plot normal timeseries if year set is > 1 year
    if (length(year_set_comp()) > 1) {
      ts_data1 <- create_timeseries_datatable(
        data_input = data_output4_primary(),
        year_input = year_set_comp(),
        year_input_type = "set",
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary()
      )
      ts_data2 = add_stats_to_TS_datatable(
        data_input = ts_data1,
        add_moving_average = FALSE,
        moving_average_range = NA,
        moving_average_alignment = NA,
        add_percentiles = input$custom_percentile_ts2,
        percentiles = input$percentile_ts2,
        use_MA_percentiles = FALSE
      )
    } 
    # Plot monthly TS if year range = 1 year
    else {
      ts_data1 = load_ModE_data(dataset = input$dataset_selected2, variable = input$variable_selected2)
      
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
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    if (length(year_set_comp()) > 1) {
      output_ts_table = rewrite_tstable(tstable = timeseries_data_2(),
                                        variable = input$variable_selected2)
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
  timeseries_plot_comp <- function(){
    #Plot normal timeseries if year set is > 1 year
    #if (length(year_set_comp()) > 1){  
    # Generate NA or reference mean
    if(input$show_ref_ts2 == TRUE){
      ref_ts2 = signif(mean(data_output3_primary()),3)
    } else {
      ref_ts2 = NA
    }

    # New 
    p <- plot_timeseries(
      type = "Composites",
      data = timeseries_data_2(),
      variable = input$variable_selected2,
      ref = ref_ts2,
      year_range = year_set_comp(),
      month_range_1 = month_range_primary(),
      titles = plot_titles_composites(),
      #titles_mode=input$title_mode_ts2,
      show_key = input$show_key_ts2,
      key_position = input$key_position_ts2,
      show_ticks = input$show_ticks_ts2,
      tick_interval = input$xaxis_numeric_interval_ts2,
      show_ref = input$show_ref_ts2,
      custom_percentile = input$custom_percentile_ts2,
      percentiles = input$percentile_ts2,
      highlights = ts_highlights_data2(),
      lines = ts_lines_data2(),
      points = ts_points_data2(),
      axis_range = input$axis_input_ts2
    )
    
    return(p)
  }
  
  output$timeseries2 <- renderPlot({timeseries_plot_comp()}, height = 400)
  
  #List of chosen composite years (upload or manual) to plot
  output$text_years2 <- renderText("Chosen composite years:")
  output$years2 <- renderText({year_set_comp()})
  output$text_years2b <- renderText("Chosen composite years:")
  output$years2b <- renderText({year_set_comp()})
  
  output$text_custom_years2  <- renderText("Chosen reference years:")
  output$custom_years2       <- renderText({year_set_comp_ref()})
  output$text_custom_years2b <- renderText("Chosen reference years:")
  output$custom_years2b      <- renderText({year_set_comp_ref()})
  
  ####### ModE-RA sources ----
  
  # Set up values and functions for plotting
  fad_zoom2  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  season_fad_short2 = reactive({
    switch(input$fad_season2,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  fad_global_data2 = reactive({
    load_modera_source_data(year = input$fad_year2, season = season_fad_short2())
  })
  
  # Plot map 
  fad_plot2 = function(base_size = 18) {
    plot_modera_sources(
      ME_source_data = fad_global_data2(),
      year = input$fad_year2,
      season = season_fad_short2(),
      minmax_lonlat = fad_zoom2(),
      base_size = base_size
    )
  }
  
  fad_dimensions2 <- reactive({
    req(input$nav1 == "tab2") # Only run code if in the current tab
    m_d_f2 = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_fad_map2_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    return(m_d_f2)
  })
  
  output$fad_map2 <- renderPlot({
    fad_plot2()
  }, width = function() {
    fad_dimensions2()[1]
  }, height = function() {
    fad_dimensions2()[2]
  })
  
  # Set up data function
  fad_data2 <- function() {
    fad_base_data2 = download_feedback_data(
      global_data = fad_global_data2(),
      lon_range = fad_zoom2()[1:2],
      lat_range = fad_zoom2()[3:4]
    )
    
    # Remove the last column
    fad_base_data2 = fad_base_data2[, -ncol(fad_base_data2)]
    
    return(fad_base_data2)
  }
  
  observeEvent(lonlat_vals2()|input$fad_reset_zoom2,{
    fad_zoom2(lonlat_vals2())
  })
  
  observeEvent(input$brush_fad2,{
    brush = input$brush_fad2
    req(brush)  # ensure brush is not NULL
    fad_zoom2(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
  })
  
  # Update fad_year 
  observeEvent(year_set_comp()[1], {
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "fad_year2",
      value = year_set_comp()[1])
  })
  
  # Update fad_season
  observeEvent(month_range_primary()[1], {
    
    req(input$nav1 == "tab2") # Only run code if in the current tab
    
    if (month_range_primary()[1] >3 & month_range_primary()[1] <10){
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season2",
        selected = "April to September")
    } else {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season2",
        selected = "October to March")
    }
  })
  
  ####### Downloads ----
  #Downloading General data
  output$download_map2            <- downloadHandler(filename = function() {paste(plot_titles_composites()$file_title, "-map.", input$file_type_map2, sep = "")},
                                                     content = function(file) {
                                                       if (input$file_type_map2 == "png") {
                                                         png(file, width = map_dimensions_2()[3], height = map_dimensions_2()[4], res = 200, bg = "transparent")
                                                       } else if (input$file_type_map2 == "jpeg") {
                                                         jpeg(file, width = map_dimensions_2()[3], height = map_dimensions_2()[4], res = 200, bg = "white")
                                                       } else {
                                                         pdf(file, width = map_dimensions_2()[3] / 200, height = map_dimensions_2()[4] / 200, bg = "transparent")
                                                       }
                                                       print(map_plot_2())
                                                       dev.off()}
  )
  
  output$download_map_sec2        <- downloadHandler(filename = function() {paste(plot_titles_composites()$file_title, "-sec_map.", input$file_type_map_sec2, sep = "")},
                                                     content = function(file) {
                                                       if (input$file_type_map_sec2 == "png") {
                                                         png(file, width = map_dimensions_2()[3], height = map_dimensions_2()[4], res = 200, bg = "transparent")
                                                       } else if (input$file_type_map_sec2 == "jpeg") {
                                                         jpeg(file, width = map_dimensions_2()[3], height = map_dimensions_2()[4], res = 200, bg = "white")
                                                       } else {
                                                         pdf(file, width = map_dimensions_2()[3] / 200, height = map_dimensions_2()[4] / 200, bg = "transparent")
                                                       }
                                                       print(ref_map_plot_2())
                                                       dev.off()}
  )
  
  output$download_timeseries2      <- downloadHandler(
    filename = function() {
      paste(plot_titles_composites()$file_title,
            "-ts.",
            input$file_type_timeseries2,
            sep = "")
    },
    content  = function(file) {
      if (input$file_type_timeseries2 == "png") {
        png(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "transparent"
        )
      } else if (input$file_type_timeseries2 == "jpeg") {
        jpeg(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "white"
        )
      } else {
        pdf(file,
            width = 14,
            height = 6,
            bg = "transparent")
      }
      print(timeseries_plot_comp())
      dev.off()
    }
  ) 
  
  output$download_map_data2 <- downloadHandler(
    filename = function() {
      paste(
        plot_titles_composites()$file_title,
        "-mapdata.",
        input$file_type_map_data2,
        sep = ""
      )
    },
    content  = function(file) {
      if (input$file_type_map_data2 == "csv") {
        map_data_new_2 <- rewrite_maptable(
          maptable = final_map_data_2(),
          subset_lon_IDs = subset_lons_primary(),
          subset_lat_IDs = subset_lats_primary()
        )
        colnames(map_data_new_2) <- NULL
        
        write.csv(map_data_new_2, file, row.names = FALSE)
      } else if (input$file_type_map_data2 == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = final_map_data_2(),
            subset_lon_IDs = subset_lons_primary(),
            subset_lat_IDs = subset_lats_primary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$file_type_map_data2 == "GeoTIFF") {
        create_geotiff(final_map_data_2(), file)
      }
    }
  )
  
  output$download_timeseries_data2  <- downloadHandler(filename = function(){paste(plot_titles_composites()$file_title, "-tsdata.",input$file_type_timeseries_data2, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries_data2 == "csv"){
                                                           write.csv(timeseries_data_output_2(), file,
                                                                     row.names = FALSE,
                                                                     fileEncoding = "latin1")
                                                         } else {
                                                           openxlsx::write.xlsx(timeseries_data_output_2(), file,
                                                                                row.names = FALSE,
                                                                                col.names = TRUE)
                                                         }})
  
  output$download_fad2 <- downloadHandler(
    filename = function()
      {paste("Assimilated Observations_", gsub(" ", "", input$fad_season2), "_", input$fad_year2, ".", input$file_type_fad2, sep = "")},
    
    content = function(file) {
      mmd = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_fad_map2_width,
        output_height = input$dimension[2],
        hide_axis = FALSE
      )
      if (input$file_type_fad2 == "png") {
        png(file, width = mmd[3], height = mmd[4], res = 400, bg = "transparent")
        print(fad_plot2(base_size = 9))
        dev.off()
      } else if (input$file_type_fad2 == "jpeg") {
        jpeg(file, width = mmd[3], height = mmd[4], res = 400,bg = "white")
        print(fad_plot2(base_size = 9))
        dev.off()
      } else {
        pdf(file, width = mmd[3] / 400, height = mmd[4] / 400, bg = "transparent")
        print(fad_plot2(base_size = 9))
        dev.off()
      }
    }
  )
  
  output$download_fad_data2       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season2),"_",input$fad_year2,"_data.",input$data_file_type_fad2, sep = "")},
                                                     content  = function(file) {
                                                       if (input$data_file_type_fad2 == "csv"){
                                                         write.csv(fad_data2(), file,
                                                                   row.names = FALSE)
                                                       } else {
                                                         openxlsx::write.xlsx(fad_data2(), file,
                                                                              col.names = TRUE,
                                                                              row.names = FALSE)
                                                       }})
  
  ### CORRELATION shared lonlat/year range, user data, plotting & downloads ----
  
  ####### Shared lonlat/year_range ----
  
  # Find shared lonlat
  
  lonlat_vals3 = reactive({
    extract_shared_lonlat(input$type_v1,input$type_v2,input$range_longitude_v1,
                          input$range_latitude_v1,input$range_longitude_v2,
                          input$range_latitude_v2)
  })
  
  # Extract shared year range

  year_range_cor = reactive({
    result <- tryCatch({
      year_range <- extract_year_range(
        variable1_source = input$source_v1,
        variable2_source = input$source_v2,
        variable1_data_filepath = input$user_file_v1$datapath,
        variable2_data_filepath = input$user_file_v2$datapath,
        variable1_lag = input$lagyears_v1_cor,
        variable2_lag = input$lagyears_v2_cor
      )

      return(year_range)
    }, error = function(e) {
      showModal(
        modalDialog(
          title = "Error",
          "There was an error in processing your uploaded data.\nPlease check if the file has the correct format.",
          easyClose = FALSE,
          footer = tagList(modalButton("OK"))
        )
      )
      return(NULL)
    })
    return(result)
  })
  
  
  
  ####### User data processing ----
  
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
    req(user_data_v1(), input$user_variable_v1)
    
    usr_ss1 = create_user_data_subset(
      data_input = user_data_v1(),
      variable = input$user_variable_v1,
      year_range = input$range_years3,
      lag = input$lagyears_v1_cor # pass the lag
    )
    
    return(usr_ss1)
  })
      
  # Subset v2 data to year_range and chosen variable
  user_subset_v2 = reactive({
    
    req(user_data_v2(),input$user_variable_v2)
    
    usr_ss2 = create_user_data_subset(
      data_input = user_data_v2(),
      variable = input$user_variable_v2,
      year_range = input$range_years3,
      lag = input$lagyears_v2_cor # pass the lag
    )
    
    return(usr_ss2)
  })
  
  ####### Generate plot data ---- 
  
  # for variable 1:
  #Map titles
  plot_titles_v1 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    my_title_v1 <- generate_titles(
      tab = "general",
      dataset = input$dataset_selected_v1,
      variable = input$ME_variable_v1,
      mode = input$mode_selected_v1,
      map_title_mode = "Default",
      ts_title_mode = "Default",
      month_range = month_range_primary(),
      year_range = input$range_years3,
      baseline_range = input$ref_period_v1,
      lon_range = lonlat_vals_v1()[1:2],
      lat_range = lonlat_vals_v1()[3:4]
    )
    return(my_title_v1)
  }) 
  
  # Generate Map data & plotting function
  map_data_v1 <- function() {
    create_map_datatable(data_input = data_output4_primary(),
                         subset_lon_IDs = subset_lons_primary(),
                         subset_lat_IDs = subset_lats_primary())
  }
  
  ME_map_plot_v1 <- function() {
    plot_map(
      data_input = create_geotiff(map_data_v1()),
      lon_lat_range = lonlat_vals_v1(),
      variable = input$ME_variable_v1,
      mode = input$mode_selected_v1,
      titles = plot_titles_v1(),
      shpOrder = NULL,
      plotOrder = NULL,
      input = NULL,
      plotType = "default"
    )
  }
  
  # Generate timeseries data & plotting function
  timeseries_data_v1 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    ts_data1_v1 <- create_timeseries_datatable(
      data_input = data_output4_primary(),
      year_input = input$range_years3,
      year_input_type = "range",
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary()
    )
    return(ts_data1_v1)
  })
  
  timeseries_plot_v1 = function() {
    p <- plot_timeseries(
      type = "Anomaly",
      data = timeseries_data_v1(),
      variable = input$ME_variable_v1,
      ref = NULL,
      year_range = input$range_years3,
      month_range_1 = month_range_primary(),
      titles = plot_titles_v1(),
      show_key = FALSE,
      show_ref = FALSE,
      moving_ave = FALSE,
      custom_percentile = FALSE,
      highlights = data.frame(),
      lines = data.frame(),
      points = data.frame()
    )
    
    return(p)
  }
  
  # for Variable 2:
  
  #Map titles
  plot_titles_v2 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    my_title_v2 <- generate_titles(
      tab = "general",
      dataset = input$dataset_selected_v2,
      variable = input$ME_variable_v2,
      mode = input$mode_selected_v2,
      map_title_mode = "Default",
      ts_title_mode = "Default",
      month_range = month_range_secondary(),
      year_range = input$range_years3,
      baseline_range = input$ref_period_v2,
      lon_range = lonlat_vals_v2()[1:2],
      lat_range = lonlat_vals_v2()[3:4]
    )
    return(my_title_v2)
  }) 
  
  # Generate Map data & plotting function
  map_data_v2 <- function() {
    req(data_output4_secondary(),
        subset_lons_secondary(),
        subset_lats_secondary())
    create_map_datatable(data_input = data_output4_secondary(),
                         subset_lon_IDs = subset_lons_secondary(),
                         subset_lat_IDs = subset_lats_secondary())
  }
  
  map_data_v2_tiff = reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    create_geotiff(map_data_v2())
  })
  
  ME_map_plot_v2 <- function() {
    plot_map(
      data_input = map_data_v2_tiff(),
      lon_lat_range = lonlat_vals_v2(),
      variable = input$ME_variable_v2,
      mode = input$mode_selected_v2,
      titles = plot_titles_v2(),
      shpOrder = NULL,
      plotOrder = NULL,
      input = NULL,
      plotType = "default"
    )
  }
  
  # Generate timeseries data & plotting function
  timeseries_data_v2 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    ts_data1_v2 <- create_timeseries_datatable(
      data_input = data_output4_secondary(),
      year_input = input$range_years3,
      year_input_type = "range",
      subset_lon_IDs = subset_lons_secondary(),
      subset_lat_IDs = subset_lats_secondary()
    )
    return(ts_data1_v2)
  })

  timeseries_plot_v2 = function(){

  p <- plot_timeseries(
      type = "Anomaly",
      data = timeseries_data_v2(),
      variable = input$ME_variable_v2,
      ref = NULL,
      year_range = input$range_years3,
      month_range_2 = month_range_secondary(),
      titles = plot_titles_v2(),
      show_key = FALSE,
      show_ref = FALSE,
      moving_ave = FALSE,
      custom_percentile = FALSE,
      highlights = data.frame(),
      lines = data.frame(),
      points = data.frame()
    )
    return(p)
  }
  
  ####### Plotting ----
  
  ######### Plot v1/v2 plots
  
  # Generate plot dimensions
  plot_dimensions_v1 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    if (input$type_v1 == "Timeseries") {
      map_dims_v1 = c(session$clientData$output_plot_v1_width, 400)
    } else {
      map_dims_v1 = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_plot_v1_width,
        output_height = (input$dimension[2]),
        hide_axis = FALSE
      )
    }
    return(map_dims_v1)
  })
  
  plot_dimensions_v2 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    if (input$type_v2 == "Timeseries") {
      map_dims_v2 = c(session$clientData$output_plot_v2_width, 400)
    } else {
      map_dims_v2 = generate_map_dimensions(
        subset_lons_secondary(),
        subset_lats_secondary(),
        session$clientData$output_plot_v2_width,
        (input$dimension[2]),
        FALSE
      )
    }
    return(map_dims_v2)
  })     
  
  # Plot
  output$plot_v1 <- renderPlot({
    if (input$source_v1 == "User Data") {
      plot_user_timeseries(user_subset_v1(), "darkorange2")
    } else if (input$type_v1 == "Timeseries") {
      timeseries_plot_v1()
    } else{
      ME_map_plot_v1()
    }
  }, width = function() {
    plot_dimensions_v1()[1]
  }, height = function() {
    plot_dimensions_v1()[2]
  })  
  
  
  output$plot_v2 <- renderPlot({
    if (input$source_v2 == "User Data") {
      plot_user_timeseries(user_subset_v2(), "saddlebrown")
    } else if (input$type_v2 == "Timeseries") {
      timeseries_plot_v2()
    } else{
      ME_map_plot_v2()
    }
  }, width = function() {
    plot_dimensions_v2()[1]
  }, height = function() {
    plot_dimensions_v2()[2]
  })  
  
  
  ######### Plot shared TS plot
  
  # Generate correlation titles
  plot_titles_cor = reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (input$source_v1 == "ModE-") {
      variable_v1 = input$ME_variable_v1
    } else {
      variable_v1 = input$user_variable_v1
    }
    
    if (input$source_v2 == "ModE-") {
      variable_v2 = input$ME_variable_v2
    } else {
      variable_v2 = input$user_variable_v2
    }
    
    ptc = generate_correlation_titles(
      variable1_source = input$source_v1,
      variable2_source = input$source_v2,
      variable1_dataset = input$dataset_selected_v1,
      variable2_dataset = input$dataset_selected_v2,
      variable1 = variable_v1,
      variable2 = variable_v2,
      variable1_type = input$type_v1,
      variable2_type = input$type_v2,
      variable1_mode = input$mode_selected_v1,
      variable2_mode = input$mode_selected_v2,
      variable1_month_range = month_range_primary(),
      variable2_month_range = month_range_secondary(),
      variable1_lon_range = lonlat_vals_v1()[1:2],
      variable2_lon_range = lonlat_vals_v2()[1:2],
      variable1_lat_range = lonlat_vals_v1()[3:4],
      variable2_lat_range = lonlat_vals_v2()[3:4],
      year_range = input$range_years3,
      method = input$cor_method_ts,
      map_title_mode = input$title_mode3,
      ts_title_mode = input$title_mode_ts3,
      map_custom_title = input$title1_input3,
      map_custom_subtitle = input$title2_input3,
      ts_custom_title = input$title1_input_ts3,
      map_title_size = input$title_size_input3,
      ts_title_size = input$title_size_input_ts3
    )
    return(ptc)
  }) 
  
  # Add value to custom title
  # Step 1: Clear inputs when switching to "Default"
  observeEvent(input$title_mode3, {
    if (input$title_mode3 == "Default" || input$title_mode_ts3 == "Default") {
      updateTextInput(session, "title1_input3", value = "")
      updateTextInput(session, "title2_input3", value = "")
      updateTextInput(session, "title1_input_ts3", value = "")
    }
  })
  
  # Step 2: Refill with updated defaults after clearing
  observeEvent({
    input$title_mode3
    plot_titles_cor()
  }, {
    req(input$title_mode3 == "Default" || input$title_mode_ts3 == "Default")
    req(plot_titles_cor())
    
    invalidateLater(100, session)
    
    isolate({
      updateTextInput(session, "title1_input3", value = plot_titles_cor()$map_title)
      updateTextInput(session, "title2_input3", value = plot_titles_cor()$map_subtitle)
      updateTextInput(session, "title1_input_ts3", value = plot_titles_cor()$ts_title)
    })
  })

  
  # Select variable timeseries data
  ts_data_v1 = reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (input$source_v1 == "ModE-") {
      tsd_v1 = timeseries_data_v1()
    } else {
      tsd_v1 = user_subset_v1()
    }
    
    # Add moving averages (if chosen)
    tsds_v1 = add_stats_to_TS_datatable(
      data_input = tsd_v1,
      add_moving_average = input$custom_average_ts3,
      moving_average_range = input$year_moving_ts3,
      moving_average_alignment = "center",
      add_percentiles = FALSE,
      percentiles = NA,
      use_MA_percentiles = FALSE
    )
    
    return(tsds_v1)
  })
  
  ts_data_v2 = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (input$source_v2 == "ModE-"){
      tsd_v2 = timeseries_data_v2()
    } else {
      tsd_v2 = user_subset_v2()
    } 
    
    # Add moving averages (if chosen)
    tsds_v2 = add_stats_to_TS_datatable(
      data_input = tsd_v2,
      add_moving_average = input$custom_average_ts3,
      moving_average_range = input$year_moving_ts3,
      moving_average_alignment = "center",
      add_percentiles = FALSE,
      percentiles = NA,
      use_MA_percentiles = FALSE
    )
    
    return(tsds_v2)
  })
  
  # Correlate timeseries
  correlation_stats = reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    c_st = correlate_timeseries(ts_data_v1(), ts_data_v2(), input$cor_method_ts)
    
    return(c_st)
  })
  
  # Plot
  output$correlation_r_value = renderText({
    paste(
      "Timeseries correlation coefficient: r =",
      signif(correlation_stats()$estimate, digits = 3),
      sep = ""
    )
  })
  output$correlation_p_value = renderText({
    paste(
      "Timeseries correlation p-value: p =",
      signif(correlation_stats()$p.value, digits = 3),
      sep = ""
    )
  })
  
  timeseries_plot_corr = function(){
    
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
    
    plot_timeseries(
      type = "Correlation",
      data_v1 = ts_data_v1(),
      data_v2 = ts_data_v2(),
      variable1 = variable_v1,
      variable2 = variable_v2,
      year_range = input$range_years3,
      month_range_1 = month_range_primary(),
      month_range_2 = month_range_secondary(),
      titles = plot_titles_cor(),
      show_ticks = input$show_ticks_ts3,
      tick_interval = input$xaxis_numeric_interval_ts3,
      show_key = input$show_key_ts3,
      key_position = input$key_position_ts3,
      moving_ave = input$custom_average_ts3,
      moving_ave_year = input$year_moving_ts3,
      highlights = ts_highlights_data3(),
      lines = ts_lines_data3(),
      points = ts_points_data3(),
      axis_range = input$axis_input_ts3
    )
    
  }
  
  output$correlation_ts = renderPlot({timeseries_plot_corr()}, height = 400)
  
  ######### Correlation Scatter Plot
  # Function
  scatter_plot_corr = function(){
    req(ts_data_v1(), ts_data_v2(), plot_titles_cor())
    
    # Prepare the data
    y1 <- ts_data_v1()[, 2]
    y2 <- ts_data_v2()[, 2]
    df <- data.frame(v1 = y1, v2 = y2)
    df <- na.omit(df)
    
    # Extract titles
    titles <- plot_titles_cor()
    title_text <- "Correlation scatter plot"
    x_label <- titles$V1_axis_label
    y_label <- titles$V2_axis_label
    
    # Base plot
    p <- ggplot(df, aes(x = v1, y = v2)) +
      geom_point(color = "#094030", alpha = 0.7, size = 4) +
      theme_minimal(base_size = 13) +
      labs(
        title = title_text,
        x = x_label,
        y = y_label
      ) +
      theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0),  # Left-aligned
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 13),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),  # Replace size with linewidth
        axis.ticks = element_line(color = "black", linewidth = 0.5)  # Replace size with linewidth
      ) +
      scale_x_continuous(minor_breaks = waiver()) +
      scale_y_continuous(minor_breaks = waiver())
    
    # Z-score outliers
    if (input$add_outliers_ref_ts3 == "z-score") {
      # Extract year column (assumed to be the first column)
      years <- ts_data_v1()[, 1]
      
      # Compute z-scores
      z_v1 <- (df$v1 - mean(df$v1, na.rm = TRUE)) / sd(df$v1, na.rm = TRUE)
      z_v2 <- (df$v2 - mean(df$v2, na.rm = TRUE)) / sd(df$v2, na.rm = TRUE)
      
      # Determine outlier status
      df$outlier <- factor(ifelse(abs(z_v1) > input$sd_input_ref_ts3 | abs(z_v2) > input$sd_input_ref_ts3, 
                                  "Outlier", "Normal"))
      
      # Add year column
      df$year <- years
      
      # Rebuild plot with colored points and year labels for outliers
      p <- ggplot(df, aes(x = v1, y = v2, color = outlier)) +
        geom_point(alpha = 0.7, size = 4) +
        geom_text(
          data = subset(df, outlier == "Outlier"),
          aes(label = year),
          vjust = -0.8, size = 3.5, color = "black"
        ) +
        scale_color_manual(values = c("Outlier" = "#FFC000", "Normal" = "#094030")) +
        theme_minimal(base_size = 13) +
        labs(title = title_text, x = x_label, y = y_label) +
        theme(
          plot.title = element_text(size = 20, face = "bold", hjust = 0),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 13),
          panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
          axis.ticks = element_line(color = "black", linewidth = 0.5)
        ) +
        scale_x_continuous(minor_breaks = waiver()) +
        scale_y_continuous(minor_breaks = waiver())
    }
    
    # Trend outliers
    if (input$add_outliers_ref_ts3 == "Trend deviation") {
      # Extract year column (assumed to be the first column)
      years <- ts_data_v1()[, 1]
      
      # Fit linear model (trend)
      model <- lm(v2 ~ v1, data = df)
      
      # Get residuals
      residuals <- resid(model)
      
      # Standardize residuals (z-scores from trend)
      z_resid <- residuals / sd(residuals, na.rm = TRUE)
      
      # Determine outlier status based on residual z-score
      df$outlier <- factor(ifelse(abs(z_resid) > input$trend_sd_input_ref_ts3,
                                  "Outlier", "Normal"))
      
      # Add year column
      df$year <- years
      
      # Plot with color based on outlier status
      p <- ggplot(df, aes(x = v1, y = v2, color = outlier)) +
        geom_point(alpha = 0.7, size = 4) +
        geom_text(
          data = subset(df, outlier == "Outlier"),
          aes(label = year),
          vjust = -0.8, size = 3.5, color = "black"
        ) +
        scale_color_manual(values = c("Outlier" = "#FFC000", "Normal" = "#094030")) +
        theme_minimal(base_size = 13) +
        labs(title = title_text, x = x_label, y = y_label) +
        theme(
          plot.title = element_text(size = 20, face = "bold", hjust = 0),
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 13),
          panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
          axis.ticks = element_line(color = "black", linewidth = 0.5)
        ) +
        scale_x_continuous(minor_breaks = waiver()) +
        scale_y_continuous(minor_breaks = waiver())
    }
    
    # Trendline
    if (input$add_trend_ref_ts3) {
      p <- p + 
        geom_smooth(aes(linetype = "Trendline"),
                    method = "lm", se = FALSE, color = "black", size = 1) +
        scale_linetype_manual(name = "Legend", values = c("Trendline" = "dashed"))
    }
    
    # Legend visibility
    if (input$show_key_ref_ts3) {
      p <- p +
        guides(
          color = guide_legend(title = "Statistics"),
          linetype = guide_legend(title = "Legend")
        )
    } else {
      p <- p +
        guides(
          color = "none",
          linetype = "none"
        )
    }
    
    # Return the plot
    return(p)
  }
  
  # Plotting
  output$ref_map3 <- renderPlot({
    scatter_plot_corr()
  })
  
  ######### Plot correlation map
  
  # Pick out relevant v1/v2 data:
  correlation_map_data_v1 = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (input$type_v1 == "Field"){
      cmd_v1 = data_output4_primary()
    } else if (input$source_v1 == "User Data"){
      cmd_v1 = user_subset_v1()
    } else {
      cmd_v1 = timeseries_data_v1()
    } 
  })
  
  correlation_map_data_v2 = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (input$type_v2 == "Field"){
      cmd_v2 = data_output4_secondary()
    } else if (input$source_v2 == "User Data"){
      cmd_v2 = user_subset_v2()
    } else {
      cmd_v2 = timeseries_data_v2()
    } 
  })
  
  # Generate correlation map data
  correlation_map_data = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    corrmd = generate_correlation_map_data(
      correlation_map_data_v1(),
      correlation_map_data_v2(),
      input$cor_method_map,
      input$type_v1,
      input$type_v2,
      lonlat_vals_v1()[1:2],
      lonlat_vals_v2()[1:2],
      lonlat_vals_v1()[3:4],
      lonlat_vals_v2()[3:4]
    )
    return(corrmd)
  })
  
  # Generate plot dimensions
  correlation_map_dimensions <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    c_m_d = generate_map_dimensions(
      subset_lon_IDs = correlation_map_data()[[1]],
      subset_lat_IDs = correlation_map_data()[[2]],
      output_width = session$clientData$output_correlation_map_width,
      output_height = (input$dimension[2]),
      hide_axis = FALSE
    )
    
    return(c_m_d)
  })
  
  # Geotiff of correlation map data
  correlation_map_data_tiff = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    create_geotiff(generate_correlation_map_datatable(correlation_map_data()))
  })
  
  
  # Get dynamically calculated axis values
  axis_range_dynamic <- reactive({
    vals <- values(correlation_map_data_tiff())
    max_abs <- max(abs(vals), na.rm = TRUE)
    c(-max_abs, max_abs)
  })
  
  # Plot Correlation Map
  corr_m1 <- function() {
    if (any(input$type_v1 == "Field", input$type_v2 == "Field")) {
      if (input$type_v1 == "Field" && input$type_v2 == "Field") {
        v1 <- lonlat_vals_v1()
        v2 <- lonlat_vals_v2()
        lonlat_vals <- c(max(v1[1], v2[1]), min(v1[2], v2[2]), max(v1[3], v2[3]), min(v1[4], v2[4]))
      } else if (input$type_v1 == "Field") {
        lonlat_vals <- lonlat_vals_v1()
      } else {
        lonlat_vals <- lonlat_vals_v2()
      }
      
      # Dynamic axis range
      dynamic_axis <- axis_range_dynamic()
      
      # Use input axis or dynamic
      axis_input_empty <- is.null(input$axis_input3) ||
        any(is.na(input$axis_input3)) ||
        length(input$axis_input3) != 2
      
      axis_range_used <- if (axis_input_empty) {
        dynamic_axis
      } else {
        input$axis_input3
      }
      
      # Get correlation data
      corr_data <- correlation_map_data_tiff()
      
      # If dynamic axis is exactly [-1, 1], set all values to 1 (white map),
      # Ignore manual axis input
      if (all.equal(dynamic_axis, c(-1, 1)) == TRUE) {
        corr_data[] <- 1
      }
      
      titles <- plot_titles_cor()
      
      p <- plot_map(
        data_input    = corr_data,
        lon_lat_range = lonlat_vals,
        mode          = "Correlation",
        titles = plot_titles_cor(),
        axis_range = axis_range_used,
        hide_axis = input$hide_axis3,
        
        points_data = map_points_data3(),
        highlights_data = map_highlights_data3(),
        
        c_borders = input$hide_borders3,
        white_ocean = input$white_ocean3,
        white_land = input$white_land3,
        
        plotOrder = plotOrder3(),
        shpOrder = input$shapes3_order[input$shapes3_order %in% input$shapes3],
        input = input,
        plotType = "shp_colour3_",
        
        projection=input$projection3,
        center_lat=input$center_lat3,
        center_lon=input$center_lon3,
        
        show_rivers = input$show_rivers3,
        label_rivers = input$label_rivers3,
        show_lakes = input$show_lakes3,
        label_lakes = input$label_lakes3,
        show_mountains = input$show_mountains3,
        label_mountains = input$label_mountains3
      )

      # Adapt title for Europe–Asia combination  
      if ((input$type_v1 == "Field") &&
          (input$type_v2 == "Field") &&
          # Europe
          ((
            input$range_longitude_v1[1] == -30 &&
            input$range_longitude_v1[2] == 40 &&
            input$range_latitude_v1[1] == 30 &&
            input$range_latitude_v1[2] == 75
          )
          &&
          # Asia
          (
            input$range_longitude_v2[1] == 25 &&
            input$range_longitude_v2[2] == 170 &&
            input$range_latitude_v2[1] == 5 &&
            input$range_latitude_v2[2] == 80
          )
          )
          ||
          # Europe
          ((
            input$range_longitude_v2[1] == -30 &&
            input$range_longitude_v2[2] == 40 &&
            input$range_latitude_v2[1] == 30 &&
            input$range_latitude_v2[2] == 75
          )
          &&
          # Asia
          (
            input$range_longitude_v1[1] == 25 &&
            input$range_longitude_v1[2] == 170 &&
            input$range_latitude_v1[1] == 5 &&
            input$range_latitude_v1[2] == 80
          )
          )) {
        
        
      p <- p + labs(title = NA, subtitle = NA) +
        patchwork::plot_annotation(
          title = ifelse(titles$map_title != " ", titles$map_title, NULL),
          subtitle = ifelse(titles$map_subtitle != " ", titles$map_subtitle, NULL),
          theme = theme(
            plot.title = ggtext::element_textbox_simple(
              size = titles$map_title_size,
              face = "bold",
              margin = margin(0, 0, 5, 0)
            ),
            plot.subtitle = ggtext::element_textbox_simple(
              size = titles$map_title_size / 1.3,
              face = "plain",
              margin = margin(15, 0, 0, 0)
            ),
            axis.text = element_text(size = titles$map_title_size / 1.6)
          )
        )
      }
      
      return(p)
    }
  }
  
  
  output$correlation_map = renderPlot({
    corr_m1()
  }, width = function() {
    correlation_map_dimensions()[1]
  }, height = function() {
    correlation_map_dimensions()[2]
  })

  
  
  
  
  
  
  
  ######### Data tables & Downloads 
  
  # Create output ts_data
  correlation_ts_datatable = reactive({
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
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
    ctd_v1 = rewrite_tstable(tstable = ts_data_v1(), variable = variable_v1)
    ctd_v2 = rewrite_tstable(tstable = ts_data_v2(), variable = variable_v2)
    
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
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    corrmada = generate_correlation_map_datatable(correlation_map_data())
    
    return(corrmada)
  })
  
  output$correlation_map_data <- renderTable({correlation_map_datatable()}, rownames = TRUE)
  
  ####### ModE-RA sources ----
  
  # Set up values and functions for plotting
  fad_zoom3  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  season_fad_short3 = reactive({
    switch(input$fad_season3,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  fad_global_data3 = reactive({
    load_modera_source_data(year = input$fad_year3, season = season_fad_short3())
  })
  
  # Plot map 
  fad_plot3 = function(base_size = 18) {
    plot_modera_sources(
      ME_source_data = fad_global_data3(),
      year = input$fad_year3,
      season = season_fad_short3(),
      minmax_lonlat = fad_zoom3(),
      base_size = base_size
    )
  }
  
  fad_dimensions3 <- reactive({
    req(input$nav1 == "tab3") # Only run code if in the current tab
    m_d_f3 = generate_map_dimensions(
      subset_lon_IDs = subset_lons_secondary(),
      subset_lat_IDs = subset_lats_secondary(),
      output_width = session$clientData$output_fad_map3_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    return(m_d_f3)
  })
  
  output$fad_map3 <- renderPlot({
    fad_plot3()
  }, width = function() {
    fad_dimensions3()[1]
  }, height = function() {
    fad_dimensions3()[2]
  })
  
  # Set up data function
  fad_data3 <- function() {
    fad_base_data3 = download_feedback_data(
      global_data = fad_global_data3(),
      lon_range = fad_zoom3()[1:2],
      lat_range = fad_zoom3()[3:4]
    )
    
    # Remove the last column
    fad_base_data3 = fad_base_data3[, -ncol(fad_base_data3)]
    
    return(fad_base_data3)
    
  }
  
  observeEvent(lonlat_vals_v2()|input$fad_reset_zoom3,{
    fad_zoom3(lonlat_vals_v2())
  })
  
  observeEvent(input$brush_fad3,{
    brush = input$brush_fad3
    req(brush)  # ensure brush is not NULL
    fad_zoom3(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
  })
  
  # Update fad_year 
  observeEvent(input$range_years3[1], {
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "fad_year3",
      value = input$range_years3[1])
  })
  
  # Update fad_season
  observeEvent(month_range_primary()[1], {
    
    req(input$nav1 == "tab3") # Only run code if in the current tab
    
    if (month_range_primary()[1] >3 & month_range_primary()[1] <10){
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season3",
        selected = "April to September")
    } else {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season3",
        selected = "October to March")
    }
  })
  
  ####### Downloads ----
  # Downloads
  
  output$download_timeseries3      <- downloadHandler(
    filename = function() {
      paste(plot_titles_cor()$file_title,
            "-ts.",
            input$file_type_timeseries3,
            sep = "")
    },
    content  = function(file) {
      if (input$file_type_timeseries3 == "png") {
        png(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "transparent"
        )
      } else if (input$file_type_timeseries3 == "jpeg") {
        jpeg(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "white"
        )
      } else {
        pdf(file,
            width = 14,
            height = 6,
            bg = "transparent")
      }
      print(timeseries_plot_corr())
      dev.off()
    }
  )
  
  output$download_map_sec3      <- downloadHandler(filename = function(){paste("Corr_Scatter_plot.",input$file_type_map_sec3, sep = "")},
                                                   content  = function(file) {
                                                     if (input$file_type_map_sec3 == "png"){
                                                       png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                     } else if (input$file_type_map_sec3 == "jpeg"){
                                                       jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                     } else {
                                                       pdf(file, width = 14, height = 6, bg = "transparent") 
                                                     }
                                                     print(scatter_plot_corr())
                                                     dev.off()
                                                   }) 
  
  output$download_map3              <- downloadHandler(filename = function() {paste(plot_titles_cor()$file_title, "-map.", input$file_type_map3, sep = "")},
                                                       content = function(file) {
                                                         if (input$file_type_map3 == "png") {
                                                           png(file, width = correlation_map_dimensions()[3], height = correlation_map_dimensions()[4], res = 200, bg = "transparent")
                                                         } else if (input$file_type_map3 == "jpeg") {
                                                           jpeg(file, width = correlation_map_dimensions()[3], height = correlation_map_dimensions()[4], res = 200, bg = "white")
                                                         } else {
                                                           pdf(file, width = correlation_map_dimensions()[3] / 200, height = correlation_map_dimensions()[4] / 200, bg = "transparent")
                                                         }
                                                         print(corr_m1())
                                                         dev.off()}
  )
  
  output$download_timeseries_data3  <- downloadHandler(filename = function(){paste(plot_titles_cor()$file_title, "-tsdata.",input$file_type_timeseries_data3, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries_data3 == "csv"){
                                                           write.csv(correlation_ts_datatable(), file,
                                                                     row.names = FALSE,
                                                                     fileEncoding = "latin1")
                                                         } else {
                                                           openxlsx::write.xlsx(correlation_ts_datatable(), file,
                                                                                row.names = FALSE,
                                                                                col.names = TRUE)
                                                         }}) 
  
  output$download_map_data3 <- downloadHandler(
    filename = function() {
      paste(plot_titles_cor()$file_title,
            "-mapdata.",
            input$file_type_map_data3,
            sep = "")
    },
    content  = function(file) {
      if (input$file_type_map_data3 == "csv") {
        map_data_new_3 <- rewrite_maptable(
          maptable = correlation_map_datatable(),
          subset_lon_IDs = subset_lons_secondary(),
          subset_lat_IDs = subset_lats_secondary()
        )
        colnames(map_data_new_3) <- NULL
        
        write.csv(map_data_new_3, file, row.names = FALSE)
      } else if (input$file_type_map_data3 == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = correlation_map_datatable(),
            subset_lon_IDs = subset_lons_secondary(),
            subset_lat_IDs = subset_lats_secondary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$file_type_map_data3 == "GeoTIFF") {
        create_geotiff(correlation_map_datatable(), file)
      }
    }
  )

  output$download_fad3 <- downloadHandler(
    filename = function()
    {paste("Assimilated Observations_", gsub(" ", "", input$fad_season3), "_", input$fad_year3, ".", input$file_type_fad3, sep = "")},
    
    content = function(file) {
      mmd = generate_map_dimensions(
        subset_lon_IDs = subset_lons_secondary(),
        subset_lat_IDs = subset_lats_secondary(),
        output_width = session$clientData$output_fad_map3_width,
        output_height = input$dimension[2],
        hide_axis = FALSE
      )
      if (input$file_type_fad3 == "png") {
        png(file, width = mmd[3], height = mmd[4], res = 400, bg = "transparent")
        print(fad_plot3(base_size = 9))
        dev.off()
      } else if (input$file_type_fad3 == "jpeg") {
        jpeg(file, width = mmd[3], height = mmd[4], res = 400,bg = "white")
        print(fad_plot3(base_size = 9))
        dev.off()
      } else {
        pdf(file, width = mmd[3] / 400, height = mmd[4] / 400, bg = "transparent")
        print(fad_plot3(base_size = 9))
        dev.off()
      }
    }
  )
  
  output$download_fad_data3       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season3),"_",input$fad_year3,"_data.",input$data_file_type_fad3, sep = "")},
                                                     content  = function(file) {
                                                       if (input$data_file_type_fad3 == "csv"){
                                                         write.csv(fad_data3(), file,
                                                                   row.names = FALSE)
                                                       } else {
                                                         openxlsx::write.xlsx(fad_data3(), file,
                                                                              col.names = TRUE,
                                                                              row.names = FALSE)
                                                       }})
  
  
  ### REGRESSION year range, user data, plotting & downloads ----
  
  ####### User data processing ----
  
  # Extract Shared year range
  year_range_reg = reactive({
    
    result <- tryCatch({
      res <- extract_year_range(
        input$source_iv,
        input$source_dv,
        input$user_file_iv$datapath,
        input$user_file_dv$datapath
      )

    },
    error = function(e) {
      showModal(
        modalDialog(
          title = "Error",
          "There was an error in processing your uploaded data. 
          \nPlease check if the file has the correct format.",
          easyClose = FALSE,
          footer = tagList(modalButton("OK"))
        )
      )
      return(NULL)
    }
    )
    
    return(result)
  })
  
  
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
    req(user_data_iv(), input$user_variable_iv)
    
    usr_ss1 = create_user_data_subset(user_data_iv(), input$user_variable_iv, input$range_years4)
    
    return(usr_ss1)
  }) 
  
  # Subset dv data to year_range and chosen variable
  user_subset_dv = reactive({
    req(user_data_dv(), input$user_variable_dv)
    
    usr_ss2 = create_user_data_subset(user_data_dv(), input$user_variable_dv, input$range_years4)
    
    return(usr_ss2)
  }) 
  
  ####### Prep plotting data ----
  
  #Map titles
  plot_titles_dv <- reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    my_title_dv <- generate_titles (tab = "general",
                                    dataset = input$dataset_selected_dv,
                                    variable = input$ME_variable_dv,
                                    mode = input$mode_selected_dv,
                                    map_title_mode = "Default",
                                    ts_title_mode = "Default",
                                    month_range = month_range_primary(),
                                    year_range = input$range_years4,
                                    baseline_range = input$ref_period_dv,
                                    baseline_years_before = NA,
                                    lon_range = lonlat_vals_dv()[1:2],
                                    lat_range = lonlat_vals_dv()[3:4],
                                    map_custom_title1 = NA,
                                    map_custom_title2 = NA,
                                    ts_custom_title1 = NA)
    return(my_title_dv)
  }) 
  
  plot_titles_iv <- reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    my_title_iv <- generate_titles (tab = "general",
                                    dataset = input$dataset_selected_iv,
                                    variable = input$ME_variable_iv[1],
                                    mode = input$mode_selected_iv,
                                    map_title_mode = "Default",
                                    ts_title_mode = "Default",
                                    month_range = month_range_secondary(),
                                    year_range = input$range_years4,
                                    baseline_range = input$ref_period_iv,
                                    baseline_years_before = NA,
                                    lon_range = lonlat_vals_iv()[1:2],
                                    lat_range = lonlat_vals_iv()[3:4],
                                    map_custom_title1 = NA,
                                    map_custom_title2 = NA,
                                    ts_custom_title1 = NA)
    return(my_title_iv)
  }) 
  
  # Generate Map data & plotting function for dv
  map_data_dv <- function() {
    req(data_output4_primary(),
        subset_lons_primary(),
        subset_lats_primary())
    create_map_datatable(data_input = data_output4_primary(),
                         subset_lon_IDs = subset_lons_primary(),
                         subset_lat_IDs = subset_lats_primary())
  }
  
  ME_map_plot_dv <- function(){plot_map(
    data_input = create_geotiff(map_data_dv()),
    lon_lat_range = lonlat_vals_dv(),
    variable = input$ME_variable_dv,
    mode = input$mode_selected_dv,
    titles = plot_titles_dv(),
    shpOrder = NULL,
    plotOrder = NULL,
    input = NULL,
    plotType = "default"
  )}
  
  # Generate timeseries data & plotting function for iv
  ME_ts_data_iv <- reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    req(subset_lons_secondary(),subset_lats_secondary(),month_range_secondary())
    
    me_tsd_iv = create_ME_timeseries_data(input$dataset_selected_dv,input$ME_variable_iv,subset_lons_secondary(),subset_lats_secondary(),
                                          input$mode_selected_iv,month_range_secondary(),input$range_years4,
                                          input$ref_period_iv)
    return(me_tsd_iv)
  })
  
  timeseries_plot_iv = function(){
    p <- plot_timeseries(
              type = "Anomaly",
              data = ME_ts_data_iv(),
              variable = input$ME_variable_iv[1],
              ref = NULL,
              year_range = input$range_years4,
              month_range_1 = month_range_primary(),
              titles = plot_titles_iv(),
              show_key = FALSE,
              show_ref = FALSE,
              moving_ave = FALSE,
              custom_percentile = FALSE,
              highlights = data.frame(),
              lines = data.frame(),
              points = data.frame()
    )
    return(p)
  }
  
  # Generate Timeseries data for dv
  timeseries_data_dv <- reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    ts_data1_dv <- create_timeseries_datatable(
      data_input = data_output4_primary(),
      year_input = input$range_years4,
      year_input_type = "range",
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary()
    )
    return(ts_data1_dv)
  })
  

  ####### Plotting initial IV/DV ----
  
  # Generate plot dimensions
  plot_dimensions_iv <- reactive({
    p_d_iv = map_dims_iv = c(session$clientData$output_plot_iv_width,400)
    
    return(p_d_iv)
  })
  
  plot_dimensions_dv <- reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    if (input$source_dv == "User Data"){
      map_dims_dv = c(session$clientData$output_plot_dv_width,400)
    } else {
      map_dims_dv = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_plot_dv_width,
        output_height = (input$dimension[2]),
        hide_axis = FALSE
      )
    }
    return(map_dims_dv)  
  })
  
  # Plot 
  output$plot_iv <- renderPlot({
    if (input$source_iv == "User Data") {
      plot_user_timeseries(user_subset_iv(), "darkorange2")
    } else {
      timeseries_plot_iv()
    }
  }, height = 400)  
  
  output$plot_dv <- renderPlot({
    if (input$source_dv == "User Data") {
      plot_user_timeseries(user_subset_dv(), "saddlebrown")
    } else{
      ME_map_plot_dv()
    }
  }, width = function() {
    plot_dimensions_dv()[1]
  }, height = function() {
    plot_dimensions_dv()[2]
  })  
  
  ####### Generate plot data ----

  ### Preparation
  
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

  # Generate regression titles coefficients 
  plot_titles_reg_coeff = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    req(month_range_secondary(), month_range_primary())
    
    ptr = generate_regression_titles(
      independent_source = input$source_iv,
      dependent_source = input$source_dv,
      dataset_i = input$dataset_selected_iv,
      dataset_d = input$dataset_selected_dv,
      modERA_dependent_variable = input$ME_variable_dv,
      mode_i = input$mode_selected_iv,
      mode_d = input$mode_selected_dv,
      month_range_i = month_range_secondary(),
      month_range_d = month_range_primary(),
      lon_range_i = lonlat_vals_iv()[1:2],
      lon_range_d = lonlat_vals_dv()[1:2],
      lat_range_i = lonlat_vals_iv()[3:4],
      lat_range_d = lonlat_vals_dv()[3:4],
      year_range = input$range_years4,
      year_selected = reg_resi_year_val(),
      independent_variables = variables_iv(),
      dependent_variable = variable_dv(),
      iv_number_coeff = match(input$coeff_variable, variables_iv()),
      iv_number_pvals = match(input$pvalue_variable, variables_iv()),
      map_title_mode = input$title_mode_reg_coeff,
      map_custom_title = input$title1_input_reg_coeff,
      map_custom_subtitle = input$title2_input_reg_coeff,
      title_size = input$title_size_input_reg_coeff
    )
    return(ptr)
  })
  
  # Add value to custom title
  # Step 1: Clear inputs when switching to "Default"
  observeEvent(input$title_mode_reg_coeff, {
    if (input$title_mode_reg_coeff == "Default") {
      updateTextInput(session, "title1_input_reg_coeff", value = "")
      updateTextInput(session, "title2_input_reg_coeff", value = "")
    }
  })
  
  # Step 2: Fill with default titles after clearing
  observeEvent({
    input$title_mode_reg_coeff
    plot_titles_reg_coeff()
  }, {
    req(input$title_mode_reg_coeff == "Default")
    req(plot_titles_reg_coeff())
    
    invalidateLater(100, session)
    
    isolate({
      updateTextInput(session,
                      "title1_input_reg_coeff",
                      value = plot_titles_reg_coeff()$map_title_coeff)
      updateTextInput(session,
                      "title2_input_reg_coeff",
                      value = plot_titles_reg_coeff()$map_subtitle_coeff)
    })
  })
  
  # Generate regression titles pvals
  plot_titles_reg_pval = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    req(month_range_secondary(), month_range_primary())
    
    ptr = generate_regression_titles(
      independent_source = input$source_iv,
      dependent_source = input$source_dv,
      dataset_i = input$dataset_selected_iv,
      dataset_d = input$dataset_selected_dv,
      modERA_dependent_variable = input$ME_variable_dv,
      mode_i = input$mode_selected_iv,
      mode_d = input$mode_selected_dv,
      month_range_i = month_range_secondary(),
      month_range_d = month_range_primary(),
      lon_range_i = lonlat_vals_iv()[1:2],
      lon_range_d = lonlat_vals_dv()[1:2],
      lat_range_i = lonlat_vals_iv()[3:4],
      lat_range_d = lonlat_vals_dv()[3:4],
      year_range = input$range_years4,
      year_selected = reg_resi_year_val(),
      independent_variables = variables_iv(),
      dependent_variable = variable_dv(),
      iv_number_coeff = match(input$coeff_variable, variables_iv()),
      iv_number_pvals = match(input$pvalue_variable, variables_iv()),
      map_title_mode = input$title_mode_reg_pval,
      map_custom_title = input$title1_input_reg_pval,
      map_custom_subtitle = input$title2_input_reg_pval,
      title_size = input$title_size_input_reg_pval
    )
    return(ptr)
  })
  
  # Add value to custom title
  # Step 1: Clear the inputs when switching to "Default"
  observeEvent(input$title_mode_reg_pval, {
    if (input$title_mode_reg_pval == "Default") {
      updateTextInput(session, "title1_input_reg_pval", value = "")
      updateTextInput(session, "title2_input_reg_pval", value = "")
    }
  })
  
  # Step 2: Refill inputs with updated defaults after clearing
  observeEvent({
    input$title_mode_reg_pval
    plot_titles_reg_pval()
  }, {
    req(input$title_mode_reg_pval == "Default")
    req(plot_titles_reg_pval())
    
    invalidateLater(100, session)
    
    isolate({
      updateTextInput(session,
                      "title1_input_reg_pval",
                      value = plot_titles_reg_pval()$map_title_pvals)
      updateTextInput(session,
                      "title2_input_reg_pval",
                      value = plot_titles_reg_pval()$map_subtitle_pvals)
    })
  })
  
  
  # Generate regression titles residuals
  plot_titles_reg_res = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    req(month_range_secondary(), month_range_primary())
    
    ptr = generate_regression_titles(
      independent_source = input$source_iv,
      dependent_source = input$source_dv,
      dataset_i = input$dataset_selected_iv,
      dataset_d = input$dataset_selected_dv,
      modERA_dependent_variable = input$ME_variable_dv,
      mode_i = input$mode_selected_iv,
      mode_d = input$mode_selected_dv,
      month_range_i = month_range_secondary(),
      month_range_d = month_range_primary(),
      lon_range_i = lonlat_vals_iv()[1:2],
      lon_range_d = lonlat_vals_dv()[1:2],
      lat_range_i = lonlat_vals_iv()[3:4],
      lat_range_d = lonlat_vals_dv()[3:4],
      year_range = input$range_years4,
      year_selected = reg_resi_year_val(),
      independent_variables = variables_iv(),
      dependent_variable = variable_dv(),
      iv_number_coeff = match(input$coeff_variable, variables_iv()),
      iv_number_pvals = match(input$pvalue_variable, variables_iv()),
      map_title_mode = input$title_mode_reg_res,
      map_custom_title = input$title1_input_reg_res,
      map_custom_subtitle = input$title2_input_reg_res,
      title_size = input$title_size_input_reg_res
    )
    return(ptr)
  })
  
  # Add value to custom title
  # Step 1: Clear title inputs when switching to "Default"
  observeEvent(input$title_mode_reg_res, {
    if (input$title_mode_reg_res == "Default") {
      updateTextInput(session, "title1_input_reg_res", value = "")
      updateTextInput(session, "title2_input_reg_res", value = "")
    }
  })
  
  # Step 2: Refill inputs with defaults after clearing
  observeEvent({
    input$title_mode_reg_res
    plot_titles_reg_res()
  }, {
    req(input$title_mode_reg_res == "Default")
    req(plot_titles_reg_res())
    
    invalidateLater(100, session)
    
    isolate({
      updateTextInput(session, "title1_input_reg_res",
                      value = plot_titles_reg_res()$map_title_res)
      updateTextInput(session, "title2_input_reg_res",
                      value = plot_titles_reg_res()$map_subtitle_res)
    })
  })
  
  
  # Regression TS Titles
  plot_titles_reg_ts = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    req(month_range_secondary(), month_range_primary())
    
    ptr = generate_regression_titles_ts(
      independent_source = input$source_iv,
      dependent_source = input$source_dv,
      dataset_i = input$dataset_selected_iv,
      dataset_d = input$dataset_selected_dv,
      modERA_dependent_variable = input$ME_variable_dv,
      mode_i = input$mode_selected_iv,
      mode_d = input$mode_selected_dv,
      month_range_i = month_range_secondary(),
      month_range_d = month_range_primary(),
      lon_range_i = lonlat_vals_iv()[1:2],
      lon_range_d = lonlat_vals_dv()[1:2],
      lat_range_i = lonlat_vals_iv()[3:4],
      lat_range_d = lonlat_vals_dv()[3:4],
      year_range = input$range_years4,
      year_selected = reg_resi_year_val(),
      independent_variables = variables_iv(),
      dependent_variable = variable_dv(),
      iv_number_coeff = match(input$coeff_variable, variables_iv()),
      iv_number_pvals = match(input$pvalue_variable, variables_iv()),
      map_title_mode = input$title_mode_ts4,
      map_custom_title = input$title1_input_ts4,
      map_custom_subtitle = input$title2_input_ts4,
      title_size = input$title_size_input_ts4
    )
    return(ptr)
  })
  
  # Add value to custom title
  # Step 1: Clear inputs when switching to "Default"
  observeEvent(input$title_mode_ts4, {
    if (input$title_mode_ts4 == "Default") {
      updateTextInput(session, "title1_input_ts4", value = "")
      updateTextInput(session, "title2_input_ts4", value = "")
    }
  })
  
  # Step 2: Refill inputs with updated defaults after clearing
  observeEvent({
    input$title_mode_ts4
    plot_titles_reg_ts()
  }, {
    req(input$title_mode_ts4 == "Default")
    req(plot_titles_reg_ts())
    
    invalidateLater(100, session)
    
    isolate({
      updateTextInput(session,
                      "title1_input_ts4",
                      value = plot_titles_reg_ts()$ts_title)
      updateTextInput(session,
                      "title2_input_ts4",
                      value = plot_titles_reg_ts()$ts_subtitle)
    })
  })
  
  # Select variable timeseries data
  ts_data_iv = reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    if (input$source_iv == "ModE-"){
      tsd_iv = ME_ts_data_iv()
    } else {
      tsd_iv = user_subset_iv()
    }  
    return(tsd_iv)
  })
  
  ts_data_dv = reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    if (input$source_dv == "ModE-"){
      tsd_dv = timeseries_data_dv()
    } else {
      tsd_dv = user_subset_dv()
    }  
    return(tsd_dv)
  })
  
  # Generate plot dimension
  plot_dimensions_reg = reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    p_d_r = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_plot_dv_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    
    return(p_d_r)
  })

  ####### Plotting ----

  ######### Regression timeseries plot 
  
  regression_ts_data = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    rtsd = create_regression_timeseries_datatable(ts_data_dv(),regression_summary_data(),
                                                  plot_titles_reg_ts())
    return(rtsd)
  })
    
  timeseries_plot_reg1 = function() {
    plot_timeseries(
      type = "Regression_Trend",
      data = regression_ts_data(),
      ref = NULL,
      year_range = input$range_years4,
      titles = plot_titles_reg_ts(),
      show_key = TRUE,
      key_position = input$key_position_ts4,
      show_ticks = input$show_ticks_ts4,
      tick_interval = input$xaxis_numeric_interval_ts4,
      show_ref = FALSE,
      moving_ave = FALSE,
      custom_percentile = FALSE,
      highlights = ts_highlights_data4a(),
      lines = ts_lines_data4a(),
      points = ts_points_data4a(),
      axis_range = input$axis_input_ts4a
    )
  }
  
  output$plot_reg_ts1 = renderPlot({
    timeseries_plot_reg1()
  }, height = 400)
  
  timeseries_plot_reg2 = function() {
    plot_timeseries(
      type = "Regression_Residual",
      data = regression_ts_data(),
      ref = NULL,
      year_range = input$range_years4,
      titles = plot_titles_reg_ts(),
      show_ticks = input$show_ticks_ts4,
      tick_interval = input$xaxis_numeric_interval_ts4,
      show_key = TRUE,
      key_position = input$key_position_ts4,
      show_ref = FALSE,
      moving_ave = FALSE,
      custom_percentile = FALSE,
      highlights = ts_highlights_data4b(),
      lines = ts_lines_data4b(),
      points = ts_points_data4b(),
      axis_range = input$axis_input_ts4b
    )
  }
  
  output$plot_reg_ts2 = renderPlot({timeseries_plot_reg2()},height=400)
  
  output$data_reg_ts= renderDataTable({regression_ts_data()}, rownames = FALSE, options = list(
    autoWidth = TRUE, 
    searching = FALSE,
    paging = TRUE,
    pagingType = "numbers"
  ))
  
  ### Regression Summary data 
  
  regression_summary_data = reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    rsd = create_regression_summary_data(ts_data_iv(),ts_data_dv(),variables_iv())
    
    return(rsd)
  })
  
  reg_sd = function(){
    req(regression_summary_data())
    summary(regression_summary_data())}
  
  output$regression_summary_data = renderPrint({reg_sd()})  
  
  ######### Regression coefficient plot
  
  regression_coeff_data = reactive({
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    reg_cd = create_regression_coeff_data(ts_data_iv(), data_output4_primary(), variables_iv())
    
    return(reg_cd)
  })
  
  reg_coef_tiff = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    create_geotiff(reg_coef_table()) 
  })
  
  # Plot Map
  reg_coef_map = function() {
    
    plot_map(
      data_input = reg_coef_tiff(),
      lon_lat_range = lonlat_vals_dv(),
      variable = variable_dv(),
      
      mode = "Regression_coefficients",
      
      titles = plot_titles_reg_coeff(),
      
      axis_range = input$axis_input_reg_coeff,
      hide_axis = input$hide_axis_reg_coeff,
      
      points_data = map_points_data_reg_coeff(),
      highlights_data = map_highlights_data_reg_coeff(),
      
      plotOrder = plotOrder_reg_coeff(),
      shpOrder = input$shapes_reg_coeff_order[input$shapes_reg_coeff_order %in% input$shapes_reg_coeff],
      input = input,   # always just 'input'
      plotType = "shp_colour_reg_coeff_",
      
      c_borders = input$hide_borders_reg_coeff,
      white_ocean = input$white_ocean_reg_coeff,
      white_land = input$white_land_reg_coeff,
      
      projection = input$projection_reg_coeff,
      center_lat = input$center_lat_reg_coeff,
      center_lon = input$center_lon_reg_coeff,

      show_rivers = input$show_rivers_reg_coeff,
      label_rivers = input$label_rivers_reg_coeff,
      show_lakes = input$show_lakes_reg_coeff,
      label_lakes = input$label_lakes_reg_coeff,
      show_mountains = input$show_mountains_reg_coeff,
      label_mountains = input$label_mountains_reg_coeff
    )
  }
  
  output$plot_reg_coeff = renderPlot({reg_coef_map()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
  
  # Plot Table
  reg_coef_table = function(){
    req(input$coeff_variable)
    if (length(variables_iv()) == 1){ #  Deals with the 'variable' dimension disappearing
      rcd1 = regression_coeff_data()
    } else{
      rcd1 = regression_coeff_data()[match(input$coeff_variable,variables_iv()),,]
    }
    # Transform and add rownames to data
    rcd2 = create_regression_map_datatable(rcd1,subset_lons_primary(),subset_lats_primary())
    return (rcd2)
  }
  
  output$data_reg_coeff = renderTable({reg_coef_table()}, rownames = TRUE)
  
  
  ######### Regression pvalue plot
  
  regression_pvalue_data = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    rpvd = create_regression_pvalue_data(ts_data_iv(), data_output4_primary(), variables_iv())
    return(rpvd)
  })
  
  reg_pval_tiff = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    create_geotiff(reg_pval_table()) 
  })
  
  reg_pval_map = function() {
    
    plot_map(
      data_input = reg_pval_tiff(),
      lon_lat_range = lonlat_vals_dv(),
      variable = variable_dv(),
      
      mode = "Regression_p_values",
      
      titles = plot_titles_reg_pval(),
      
      axis_range = input$axis_input_reg_pval,
      hide_axis = input$hide_axis_reg_pval,
      
      points_data = map_points_data_reg_pval(),
      highlights_data = map_highlights_data_reg_pval(),
      
      plotOrder = plotOrder_reg_pval(),
      shpOrder = input$shapes_reg_pval_order[input$shapes_reg_pval_order %in% input$shapes_reg_pval],
      input = input,
      plotType = "shp_colour_reg_pval_",
      
      c_borders = input$hide_borders_reg_pval,
      white_ocean = input$white_ocean_reg_pval,
      white_land = input$white_land_reg_pval,
      
      projection = input$projection_reg_pval,
      center_lat = input$center_lat_reg_pval,
      center_lon = input$center_lon_reg_pval,
      
      show_rivers = input$show_rivers_reg_pval,
      label_rivers = input$label_rivers_reg_pval,
      show_lakes = input$show_lakes_reg_pval,
      label_lakes = input$label_lakes_reg_pval,
      show_mountains = input$show_mountains_reg_pval,
      label_mountains = input$label_mountains_reg_pval
    )
  }
  
  output$plot_reg_pval = renderPlot({
    reg_pval_map()
  }, width = function(){plot_dimensions_reg()[1]}, height = function(){plot_dimensions_reg()[2]})
  
  reg_pval_table = function(){
    req(input$pvalue_variable)
    if (length(variables_iv()) == 1){ #  Deals with the 'variable' dimension disappearing
      rpd1 = regression_pvalue_data()
    } else{
      rpd1 = regression_pvalue_data()[match(input$pvalue_variable,variables_iv()),,]
    }
    # Transform and add rownames to data
    rpd2 = create_regression_map_datatable(rpd1,subset_lons_primary(),subset_lats_primary())
    
    return(rpd2)
  }
  
  output$data_reg_pval = renderTable({reg_pval_table()},rownames = TRUE)

  
  ######### Regression residuals plot
  
  regression_residuals_data = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    rresd = create_regression_residuals(ts_data_iv(), data_output4_primary(), variables_iv())
    return(rresd)
  })
  
  reg_res_tiff = reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    create_geotiff(reg_res_table()) 
  })
  
  # Make sure plot only updates when year is valid
  reg_resi_year_val  = reactiveVal()
  observe({
    if(input$reg_resi_year >= input$range_years4[1] & input$reg_resi_year <= input$range_years4[2]){
      reg_resi_year_val(input$reg_resi_year)
    }
  })
  
  reg_res_map = function() {
    
    plot_map(
      data_input = reg_res_tiff(),
      lon_lat_range = lonlat_vals_dv(),
      variable = variable_dv(),
      
      mode = "Regression_residuals",
      
      titles = plot_titles_reg_res(),
      
      axis_range = input$axis_input_reg_res,
      hide_axis = input$hide_axis_reg_res,
      
      points_data = map_points_data_reg_res(),
      highlights_data = map_highlights_data_reg_res(),
      
      plotOrder = plotOrder_reg_res(),
      shpOrder = input$shapes_reg_res_order[input$shapes_reg_res_order %in% input$shapes_reg_res],
      input = input,
      plotType = "shp_colour_reg_res_",
      
      c_borders = input$hide_borders_reg_res,
      white_ocean = input$white_ocean_reg_res,
      white_land = input$white_land_reg_res,
      
      projection = input$projection_reg_res,
      center_lat = input$center_lat_reg_res,
      center_lon = input$center_lon_reg_res,
      
      show_rivers = input$show_rivers_reg_res,
      label_rivers = input$label_rivers_reg_res,
      show_lakes = input$show_lakes_reg_res,
      label_lakes = input$label_lakes_reg_res,
      show_mountains = input$show_mountains_reg_res,
      label_mountains = input$label_mountains_reg_res
    )
  }
  
  output$plot_reg_resi = renderPlot({
    reg_res_map()
  }, width = function() {
    plot_dimensions_reg()[1]
  }, height = function() {
    plot_dimensions_reg()[2]
  })
  
  reg_res_table = function(){
    # Find ID of year selected
    year_ID = (reg_resi_year_val()-input$range_years4[1])+1
    rrd1 = regression_residuals_data()[year_ID,,]
    # Transform and add rownames to data
    rrd2 = create_regression_map_datatable(rrd1,subset_lons_primary(),subset_lats_primary())
  }
  
  output$data_reg_res = renderTable({reg_res_table()},rownames = TRUE)

  ####### ModE-RA sources ----
  
  # Set up values and functions for plotting
  fad_zoom4  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  season_fad_short4 = reactive({
    switch(input$fad_season4,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  fad_global_data4 = reactive({
    load_modera_source_data(year = input$fad_year4, season = season_fad_short4())
  })
  
  # Plot map 
  fad_plot4 = function(base_size = 18) {
    plot_modera_sources(
      ME_source_data = fad_global_data4(),
      year = input$fad_year4,
      season = season_fad_short4(),
      minmax_lonlat = fad_zoom4(),
      base_size = base_size
    )
  }
  
  fad_dimensions4 <- reactive({
    req(input$nav1 == "tab4") # Only run code if in the current tab
    m_d_f4 = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_fad_map4_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    return(m_d_f4)
  })
  
  output$fad_map4 <- renderPlot({
    fad_plot4()
  }, width = function() {
    fad_dimensions4()[1]
  }, height = function() {
    fad_dimensions4()[2]
  })
  
  # Set up data function
  fad_data4 <- function() {
    fad_base_data4 = download_feedback_data(
      global_data = fad_global_data4(),
      lon_range = fad_zoom4()[1:2],
      lat_range = fad_zoom4()[3:4]
    )
    
    # Remove the last column
    fad_base_data4 = fad_base_data4[, -ncol(fad_base_data4)]
    
    return(fad_base_data4)
    
  }
  
  observeEvent(lonlat_vals_dv()|input$fad_reset_zoom4,{
    fad_zoom4(lonlat_vals_dv())
  })
  
  observeEvent(input$brush_fad4,{
    brush = input$brush_fad4
    req(brush)  # ensure brush is not NULL
    fad_zoom4(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
  })
  
  # Update fad_year 
  observeEvent(input$range_years4[1], {
    updateNumericInput(
      session = getDefaultReactiveDomain(),
      inputId = "fad_year4",
      value = input$range_years4[1])
  })
  
  # Update fad_season
  observeEvent(month_range_secondary()[1], {
    
    req(input$nav1 == "tab4") # Only run code if in the current tab
    
    if (month_range_secondary()[1] >3 & month_range_secondary()[1] <10){
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season4",
        selected = "April to September")
    } else {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "fad_season4",
        selected = "October to March")
    }
  })
  
  ####### Downloads ----
  
  output$download_reg_ts_plot      <- downloadHandler(
    filename = function() {
      paste(plot_titles_reg_ts()$file_title,
            "-ts.",
            input$reg_ts_plot_type,
            sep = "")
    },
    content  = function(file) {
      if (input$reg_ts_plot_type == "png") {
        png(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "transparent"
        )
      } else if (input$reg_ts_plot_type == "jpeg") {
        jpeg(
          file,
          width = 3000,
          height = 1285,
          res = 200,
          bg = "white"
        )
      } else {
        pdf(file,
            width = 14,
            height = 6,
            bg = "transparent")
      }
      print(timeseries_plot_reg1())
      dev.off()
    }
  )
  
  output$download_reg_ts2_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg_ts()$file_title,"-ts.",input$reg_ts2_plot_type, sep = "")},
                                                       content  = function(file) {
                                                         if (input$reg_ts2_plot_type == "png"){
                                                           png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                         } else if (input$reg_ts2_plot_type == "jpeg"){
                                                           jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                         } else {
                                                           pdf(file, width = 14, height = 6, bg = "transparent") 
                                                         }
                                                         print(timeseries_plot_reg2())
                                                         dev.off()
                                                       })
  
  output$download_reg_ts_plot_data  <- downloadHandler(filename = function(){paste(plot_titles_reg_ts()$file_title, "-tsdata.",input$reg_ts_plot_data_type, sep = "")},
                                                       content  = function(file) {
                                                         if (input$reg_ts_plot_data_type == "csv"){
                                                           write.csv(regression_ts_data(), file,
                                                                     row.names = FALSE,
                                                                     fileEncoding = "latin1")
                                                         } else {
                                                           openxlsx::write.xlsx(regression_ts_data(), file,
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
  
  
  output$download_reg_coe_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg_coeff()$file_title,"-map.",input$reg_coe_plot_type, sep = "")},
                                                       content  = function(file) {
                                                         if (input$reg_coe_plot_type == "png"){
                                                           png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                         } else if (input$reg_coe_plot_type == "jpeg"){
                                                           jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white")
                                                         } else {
                                                           pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                         }
                                                         print(reg_coef_map())
                                                         dev.off()
                                                       })
  
  output$download_reg_coe_plot_data <- downloadHandler(
    filename = function() {
      paste(
        plot_titles_reg_coeff()$file_title,
        "-mapdata.",
        input$reg_coe_plot_data_type,
        sep = ""
      )
    },
    content  = function(file) {
      if (input$reg_coe_plot_data_type == "csv") {
        map_data_new_4a <- rewrite_maptable(
          maptable = reg_coef_table(),
          subset_lon_IDs = subset_lons_secondary(),
          subset_lat_IDs = subset_lats_secondary()
        )
        colnames(map_data_new_4a) <- NULL
        
        write.csv(map_data_new_4a, file, row.names = FALSE)
      } else if (input$reg_coe_plot_data_type == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = reg_coef_table(),
            subset_lon_IDs = subset_lons_secondary(),
            subset_lat_IDs = subset_lats_secondary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$reg_coe_plot_data_type == "GeoTIFF") {
        create_geotiff(reg_coef_table(), file)
      }
    }
  )
  
  output$download_reg_pval_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg_pval()$file_title,"-map.",input$reg_pval_plot_type, sep = "")},
                                                        content  = function(file) {
                                                          if (input$reg_pval_plot_type == "png"){
                                                            png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                          } else if (input$reg_pval_plot_type == "jpeg"){
                                                            jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white") 
                                                          } else {
                                                            pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                          }
                                                          print(reg_pval_map())
                                                          dev.off()
                                                        })
  
  output$download_reg_pval_plot_data <- downloadHandler(
    filename = function() {
      paste(
        plot_titles_reg_pval()$file_title,
        "-mapdata.",
        input$reg_pval_plot_data_type,
        sep = ""
      )
    },
    content  = function(file) {
      if (input$reg_pval_plot_data_type == "csv") {
        map_data_new_4b <- rewrite_maptable(
          maptable = reg_pval_table(),
          subset_lon_IDs = subset_lons_secondary(),
          subset_lat_IDs = subset_lats_secondary()
        )
        colnames(map_data_new_4b) <- NULL
        
        write.csv(map_data_new_4b, file, row.names = FALSE)
      } else if (input$reg_pval_plot_data_type == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = reg_pval_table(),
            subset_lon_IDs = subset_lons_secondary(),
            subset_lat_IDs = subset_lats_secondary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$reg_pval_plot_data_type == "GeoTIFF") {
        create_geotiff(reg_pval_table(), file)
      }
    }
  )
  
  output$download_reg_res_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg_res()$file_title,"-map.",input$reg_res_plot_type, sep = "")},
                                                       content  = function(file) {
                                                         if (input$reg_res_plot_type == "png"){
                                                           png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                         } else if (input$reg_res_plot_type == "jpeg"){
                                                           jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white") 
                                                         } else {
                                                           pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                         }
                                                         print(reg_res_map())
                                                         dev.off()
                                                       })
  
  output$download_reg_res_plot_data <- downloadHandler(
    filename = function() {
      paste(
        plot_titles_reg_res()$file_title,
        "-mapdata.",
        input$reg_res_plot_data_type,
        sep = ""
      )
    },
    content  = function(file) {
      if (input$reg_res_plot_data_type == "csv") {
        map_data_new_4c <- rewrite_maptable(
          maptable = reg_res_table(),
          subset_lon_IDs = subset_lons_secondary(),
          subset_lat_IDs = subset_lats_secondary()
        )
        colnames(map_data_new_4c) <- NULL
        
        write.csv(map_data_new_4c, file, row.names = FALSE)
      } else if (input$reg_res_plot_data_type == "xlsx") {
        openxlsx::write.xlsx(
          rewrite_maptable(
            maptable = reg_res_table(),
            subset_lon_IDs = subset_lons_secondary(),
            subset_lat_IDs = subset_lats_secondary()
          ),
          file,
          row.names = FALSE,
          col.names = FALSE
        )
      } else if (input$reg_res_plot_data_type == "GeoTIFF") {
        create_geotiff(reg_res_table(), file)
      }
    }
  )

  
  output$download_fad4 <- downloadHandler(
    filename = function()
    {paste("Assimilated Observations_", gsub(" ", "", input$fad_season4), "_", input$fad_year4, ".", input$file_type_fad4, sep = "")},
    
    content = function(file) {
      mmd = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_fad_map4_width,
        output_height = input$dimension[2],
        hide_axis = FALSE
      )
      if (input$file_type_fad4 == "png") {
        png(file, width = mmd[3], height = mmd[4], res = 400, bg = "transparent")
        print(fad_plot4(base_size = 9))
        dev.off()
      } else if (input$file_type_fad4 == "jpeg") {
        jpeg(file, width = mmd[3], height = mmd[4], res = 400,bg = "white")
        print(fad_plot4(base_size = 9))
        dev.off()
      } else {
        pdf(file, width = mmd[3] / 400, height = mmd[4] / 400, bg = "transparent")
        print(fad_plot4(base_size = 9))
        dev.off()
      }
    }
  )
  
  
  output$download_fad_data4       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season4),"_",input$fad_year4,"_data.",input$data_file_type_fad4, sep = "")},
                                                     content  = function(file) {
                                                       if (input$data_file_type_fad4 == "csv"){
                                                         write.csv(fad_data4(), file,
                                                                   row.names = FALSE)
                                                       } else {
                                                         openxlsx::write.xlsx(fad_data4(), file,
                                                                              col.names = TRUE,
                                                                              row.names = FALSE)
                                                       }})
  
  
  
  ### ANNUAL CYCLES data processing and plotting ----
  ####### Plot timeseries & data ----
  
  # Plot Timeseries
  monthly_ts_titles = reactive({
    if (input$title_mode_ts5 == "Custom" & input$title1_input_ts5 != ""){
      ts_title = input$title1_input_ts5
    } else {
      ts_title = "Monthly Timeseries"
    }
    ts_subtitle = NA
    ts_title_size = input$title_size_input_ts5
    
    titles_df = data.frame(ts_title,ts_subtitle,ts_title_size)
    
    return(titles_df)
  }) 
  
  # Add value to custom title
  observe({
    req(monthly_ts_titles())
    if (input$title1_input_ts5 == "") {
      updateTextInput(session, "title1_input_ts5", value = monthly_ts_titles()$ts_title)
    }
  })
  
  monthly_ts_plot = reactive({
    plot_monthly_timeseries(
      data = monthly_ts_data(),
      titles = monthly_ts_titles(),
      show_key = input$show_key_ts5,
      key_position = input$key_position_ts5,
      highlights = ts_highlights_data5(),
      lines = ts_lines_data5(),
      points = ts_points_data5()
    )
  })
  
  output$timeseries5 <- renderPlot({monthly_ts_plot()}, height = 400)
  
  # Show variable, unit and data
  
  output$data5 = renderDataTable({monthly_ts_data()}, rownames = FALSE, options = list(
    autoWidth = TRUE, 
    searching = FALSE,
    paging = TRUE,
    pagingType = "numbers"
  ))

  
  
  ####### ModE-RA sources ----
  
  # Set up values and functions for plotting
  fad_zoom5  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  season_fad_short5 = reactive({
    switch(input$fad_season5,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  fad_global_data5 = reactive({
    load_modera_source_data(year = input$fad_year5, season = season_fad_short5())
  })
  
  # Plot map 
  fad_plot5 = function(base_size = 18) {
    plot_modera_sources(
      ME_source_data = fad_global_data5(),
      year = input$fad_year5,
      season = season_fad_short5(),
      minmax_lonlat = fad_zoom5(),
      base_size = base_size
    )
  }
  
  fad_dimensions5 <- reactive({
    req(input$nav1 == "tab5") # Only run code if in the current tab
    m_d_f5 = generate_map_dimensions(
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary(),
      output_width = session$clientData$output_fad_map5_width,
      output_height = input$dimension[2],
      hide_axis = FALSE
    )
    return(m_d_f5)
  })
  
  output$fad_map5 <- renderPlot({
    fad_plot5()
  }, width = function() {
    fad_dimensions5()[1]
  }, height = function() {
    fad_dimensions5()[2]
  })
  
  # Set up data function
  fad_data5 <- function() {
    fad_base_data5 = download_feedback_data(
      global_data = fad_global_data5(),
      lon_range = fad_zoom5()[1:2],
      lat_range = fad_zoom5()[3:4]
    )
    
    # Remove the last column
    fad_base_data5 = fad_base_data5[, -ncol(fad_base_data5)]
    
    return(fad_base_data5)
    
  }
  
  # Update fad lonlat

  observeEvent(lonlat_vals5()|input$fad_reset_zoom5,{
    fad_zoom5(lonlat_vals5())
  })
  
  observeEvent(input$brush_fad5, {
    brush <- input$brush_fad5
    req(brush)  # ensure brush is not NULL
    
    # Only update after brush is completed (i.e., after mouse released)
    fad_zoom5(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
  })
  
  ####### Downloading Annual cycles data ----
  
  output$download_timeseries5      <- downloadHandler(filename = function(){paste("annual-cycle_plot.",input$file_type_timeseries5, sep = "")},
                                                      content  = function(file) {
                                                        if (input$file_type_timeseries5 == "png"){
                                                          png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                        } else if (input$file_type_timeseries5 == "jpeg"){
                                                          jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                        } else {
                                                          pdf(file, width = 14, height = 6, bg = "transparent") 
                                                        }
                                                        print(monthly_ts_plot())
                                                        dev.off()
                                                      }) 
  
  
  output$download_timeseries_data5  <- downloadHandler(filename = function(){paste("annual-cycle_data.",input$file_type_timeseries_data5, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries_data5 == "csv"){
                                                           write.csv(monthly_ts_data(), file,
                                                                     row.names = FALSE,
                                                                     fileEncoding = "latin1")
                                                         } else {
                                                           openxlsx::write.xlsx(monthly_ts_data(), file,
                                                                                row.names = FALSE,
                                                                                col.names = TRUE)
                                                         }})

  
  output$download_fad5 <- downloadHandler(
    filename = function()
    {paste("Assimilated Observations_", gsub(" ", "", input$fad_season5), "_", input$fad_year5, ".", input$file_type_fad5, sep = "")},
    
    content = function(file) {
      mmd = generate_map_dimensions(
        subset_lon_IDs = subset_lons_primary(),
        subset_lat_IDs = subset_lats_primary(),
        output_width = session$clientData$output_fad_map5_width,
        output_height = input$dimension[2],
        hide_axis = FALSE
      )
      if (input$file_type_fad5 == "png") {
        png(file, width = mmd[3], height = mmd[4], res = 400, bg = "transparent")
        print(fad_plot5(base_size = 9))
        dev.off()
      } else if (input$file_type_fad5 == "jpeg") {
        jpeg(file, width = mmd[3], height = mmd[4], res = 400,bg = "white")
        print(fad_plot5(base_size = 9))
        dev.off()
      } else {
        pdf(file, width = mmd[3] / 400, height = mmd[4] / 400, bg = "transparent")
        print(fad_plot5(base_size = 9))
        dev.off()
      }
    }
  )
  
  output$download_fad_data5       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season5),"_",input$fad_year5,"_data.",input$data_file_type_fad5, sep = "")},
                                                     content  = function(file) {
                                                       if (input$data_file_type_fad5 == "csv"){
                                                         write.csv(fad_data5(), file,
                                                                   row.names = FALSE)
                                                       } else {
                                                         openxlsx::write.xlsx(fad_data5(), file,
                                                                              col.names = TRUE,
                                                                              row.names = FALSE)
                                                       }})
  
  ### MODE-RA SOURCES data procession and plotting ----
  ####### Plotting (for download)----
  
  season_MES_short <- reactive({
    switch(input$season_MES,
           "April to September" = "summer",
           "October to March" = "winter")
  })
  
  # Load global data
  MES_global_data <- reactive({
    if (input$year_MES >= 1422 && input$year_MES <= 2008) {
      load_modera_source_data(year = input$year_MES, season = season_MES_short()) |>
        dplyr::select(LON, LAT, VARIABLE, TYPE, Name_Database, Paper_Database, Code_Proxy, Reference_Proxy, Reference_Proxy_Database, Omitted_Duplicates) |>
        st_as_sf(coords = c('LON', 'LAT')) |>
        st_set_crs(4326)
    } else {
      NULL
    }
  })
  
  ####### Leaflet Map ----
  
  output$MES_leaflet <- renderLeaflet({
    data <- MES_global_data()
    
    leaflet(data) |>
      # Base maps
      addProviderTiles(providers$Esri.WorldGrayCanvas, group = "ESRI gray") |>
      addTiles(group = "Open Street Map") |>
      addProviderTiles(providers$Esri.WorldImagery, group = "ESRI Satellite") |>
      setView(lng = 0, lat = 30, zoom = 1.6) |>
      
      # Add layers control for filtering by TYPE
      addLayersControl(
        baseGroups = c("ESRI gray", "Open Street Map", "ESRI Satellite"), # Base maps
        overlayGroups = type_list,  # Use TYPE values as overlay groups
        options = layersControlOptions(collapsed = TRUE)  # Make the control always expanded
      ) |>
      
      # Add initial data points
      addCircleMarkers(data = data,
                       radius = 5,
                       fillColor = ~pal_type(data$TYPE),
                       stroke = TRUE,
                       weight = 1,
                       color = "grey",
                       fillOpacity = 1,
                       opacity = 1,
                       group = data$TYPE,
                       popup = paste(
                         "<strong>Measurement type: </strong>", named_variables[data$VARIABLE],
                         "<br><strong>Source type: </strong>", named_types[data$TYPE],
                         "<br><strong>Name database: </strong>", "<a href='", data$Paper_Database, "' target='_blank'>", data$Name_Database, "</a>",
                         #"<br><strong>Paper database: </strong>", "<a href='", data$Paper_Database, "' target='_blank'>", data$Paper_Database, "</a>",
                         "<br><strong>Proxy code: </strong>", data$Code_Proxy,
                         "<br><strong>Proxy reference: </strong>", data$Reference_Proxy,
                         "<br><strong>Proxy reference database: </strong>", data$Reference_Proxy_Database
                       ))
    
  })
  
  # Use a separate observer to show or hide the legend
  observe({
    
    if (input$legend_MES == TRUE) {
      proxy <- leafletProxy("MES_leaflet")
      proxy %>%
        addLegend(pal = pal_type,
                  values = type_list, # pal_type and type_list are defined in helpers.R
                  title = "Legend",
                  labels = c("Bivalve", "Coral", "Documentary", "Glacier ice", "Ice", "Instrumental", "Lake sediment", "Other", "Speleothem", "Tree"),
                  position = "bottomleft",
                  opacity = 1.0) |>
        
        addControl(
          html = sprintf("<strong>Total global sources: %d</strong>", nrow(MES_global_data())),
          position = "bottomleft"
        )
    }
    else {
      proxy <- leafletProxy("MES_leaflet")
      proxy %>% clearControls()
    }
  })
  
  # Use a separate observer to add the data points
  observe({
    
    data <- MES_global_data()
    
    if (!is.null(data)) {
      proxy <- leafletProxy("MES_leaflet")
      
      proxy %>% clearMarkers() %>%
        addCircleMarkers(data = data,
                         radius = 5,
                         fillColor = ~pal_type(data$TYPE),
                         stroke = TRUE,
                         weight = 1,
                         color = "grey",
                         fillOpacity = 1,
                         opacity = 1,
                         group = data$TYPE,
                         popup = paste(
                           "<strong>Measurement type: </strong>", named_variables[data$VARIABLE],
                           "<br><strong>Source type: </strong>", named_types[data$TYPE], 
                           "<br><strong>Name database: </strong>", "<a href='", data$Paper_Database, "' target='_blank'>", data$Name_Database, "</a>",
                           #"<br><strong>Paper database: </strong>", "<a href='", data$Paper_Database, "' target='_blank'>", data$Paper_Database, "</a>",
                           "<br><strong>Proxy code: </strong>", data$Code_Proxy,
                           "<br><strong>Proxy reference: </strong>", data$Reference_Proxy,
                           "<br><strong>Proxy reference database: </strong>", data$Reference_Proxy_Database
                         ))
    }
  })
  
  ### Download Preparation for Data (CSV/XLSX)
  # Set up values and functions for plotting
  fad_zoom_MES  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
  
  MES_global_data_download = reactive({
    load_modera_source_data(year = input$year_MES, season = season_MES_short())
  })
  
  # Set up data function
  fad_data_MES <- function() {
    fad_base_data_MES = download_feedback_data(
      global_data = MES_global_data_download(),
      lon_range = fad_zoom_MES()[1:2],
      lat_range = fad_zoom_MES()[3:4]
    )
    
    # Remove the last column
    fad_base_data_MES = fad_base_data_MES[, -ncol(fad_base_data_MES)]
    
    return(fad_base_data_MES)
  }
  
  
  output$download_MES_data       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$season_MES),"_",input$year_MES,"_data.",input$data_file_type_MES, sep = "")},
                                                    content  = function(file) {
                                                      if (input$data_file_type_MES == "csv"){
                                                        write.csv(fad_data_MES(), file,
                                                                  row.names = FALSE)
                                                      } else {
                                                        openxlsx::write.xlsx(fad_data_MES(), file,
                                                                             col.names = TRUE,
                                                                             row.names = FALSE)
                                                      }})
  
  ####### TS Sources and Observation Map ----
  ### Timeseries plot for ModE-ra sources and observations
  
  # File path and data parameters
  file_path_sources <- "data/feedback_archive_fin/Info/total_sources_observations.xlsx"
  sheet_name_sources <- "sources"
  year_column_sources <- "Year"
  value_columns_sources <- c("Total_global_sources_summer", 
                             "Total_global_sources_winter", 
                             "Total_global_sources") # List of columns to plot
  
  # Corresponding line titles for the legend
  line_titles_sources <- c("Total_global_sources_summer" = "Global Sources (Apr. - Sept.)", 
                           "Total_global_sources_winter" = "Global Sources (Oct. - Mar.)", 
                           "Total_global_sources" = "Global Sources Total")
  
  # Read data from Excel once and reuse it
  data_sources <- read_excel(file_path_sources, sheet = sheet_name_sources)
  data_sources[[year_column_sources]] <- as.numeric(data_sources[[year_column_sources]])
  
  # Render plot for selected lines using plotly
  output$time_series_plot <- renderPlotly({
    selected_columns <- c("Total_global_sources_summer",
                          "Total_global_sources_winter",
                          "Total_global_sources")
    year_range <- input$year_range_sources
    
    plot_ts_modera_sources(data_sources, year_column_sources, selected_columns, line_titles_sources,
                           title = "Total Global Sources",
                           x_label = "Year",
                           y_label = "Sources",
                           x_ticks_every = 20,
                           year_range = year_range)
  })

  ### SEA Superposed epoch analysis ----
  ####### User Data Processing ----
  
  # Load in user data for SEA
  user_data_6 = reactive({
    
    req(input$user_file_6)
    
    if (input$source_sea_6 == "User Data"){
      new_data1 = read_regcomp_data(input$user_file_6$datapath)   
      return(new_data1)
    }
    else{
      return(NULL)
    }
  })
  
  # Subset user data to chosen variable
  user_subset_6 <- reactive({
    req(input$nav1 == "tab6")       # Only run if in the correct tab
    req(input$user_variable_6)      # Ensure input is available
    
    ts_data1 <- user_data_6()       # Get full timeseries data
    req(ncol(ts_data1) >= 2)        # Ensure at least two columns exist
    
    # Get first column name (e.g., "Jahr") and selected variable
    time_col <- colnames(ts_data1)[1]
    var_col <- input$user_variable_6
    
    # Subset to those two columns
    ts_us_sub <- ts_data1[, c(time_col, var_col), drop = FALSE]
    
    return(ts_us_sub)
  })
  
  #Creating a year set for sea
  year_set_sea <- reactive({
    read_sea_data(input$event_years_6, input$upload_file_6b$datapath, input$enter_upload_6, input$source_sea_6)
  })
  
  ####### ModE-Data Processing ----
  
  #Using the time series data as input
  timeseries_data_sea <- reactive({
    req(input$nav1 == "tab6") # Only run code if in the current tab
    
    ts_data1 <- create_timeseries_datatable(
      data_input = data_output4_primary(),
      year_input = c(1422, 2008),
      year_input_type = "range",
      subset_lon_IDs = subset_lons_primary(),
      subset_lat_IDs = subset_lats_primary()
    )
    
    return(ts_data1)
  })
  
  #Choose the wished statistic
  timeseries_subdata_sea <- reactive({
    req(input$nav1 == "tab6") # Only run if in the correct tab
    req(input$ME_statistic_6) # Ensure input is available
    
    ts_data1 <- timeseries_data_sea() # Get full timeseries data
    
    # Create a dataframe with Year and the selected statistic
    ts_sub <- ts_data1[, c("Year", input$ME_statistic_6), drop = FALSE]
    
    return(ts_sub)
  })
  
  ####### SEA Processing ----
  
  # Extract years, title & y label based on selected data source
  years = reactive({
    if (input$source_sea_6 == "User Data") {
      return(unlist(user_subset_6()[,1]))  # Extract years from user-uploaded data
    } else {
      return(unlist(timeseries_data_sea()[,1]))  # Extract years from ModE- data
    }
  })
  
  
  # Y Label and Plot Title
  ts_y_label = reactive({
    if (input$source_sea_6 == "User Data") {
      if (input$y_label_6 != "" && input$title_mode_6 == "Custom"){
        return(input$y_label_6)
      } else {
        return(paste(colnames(user_subset_6())[2]))
      }
      
    } else {
      if (input$y_label_6 != "" && input$title_mode_6 == "Custom"){
        return(input$y_label_6)
      } else {
        return(paste(input$ME_statistic_6,input$season_selected_6,input$ME_variable_6))
      }
    }
  })
  
  ts_title = reactive({
    if (input$source_sea_6 == "User Data") {
      if (input$title1_input_6 != "" && input$title_mode_6 == "Custom") {
        return(input$title1_input_6)
      } else {
        return(paste("SEA of", colnames(user_subset_6())[2]))
      }
    } else {
      if (input$title1_input_6 != "" && input$title_mode_6 == "Custom") {
        return(input$title1_input_6)
      } else {
        return(paste("SEA of", input$ME_statistic_6,input$season_selected_6,input$ME_variable_6))
      }
    }
  })
  
  
  # # Add value to custom title
  
  # Step 1: When switching to Default, reset the inputs to blank
  observeEvent(input$title_mode_6, {
    if (input$title_mode_6 != "Custom") {
      updateTextInput(session, "title1_input_6", value = "")
      updateTextInput(session, "y_label_6", value = "")
    }
  })
  
  # Step 2: Fill the fields after they are blanked out
  observeEvent({
    input$title_mode_6
    input$ME_statistic_6
    input$ME_variable_6
    input$source_sea_6
  }, {
    req(input$title_mode_6 != "Custom")  # Only do this in Default mode
    # Delay by one reactive tick to allow inputs to update
    invalidateLater(100, session)
    isolate({
      updateTextInput(session, "title1_input_6", value = ts_title())
      updateTextInput(session, "y_label_6", value = ts_y_label())
    })
  })
  
  
  
  # Turn "years" column into rownames
  ts_data = reactive({
    req(input$source_sea_6)  # Ensure source selection exists
    
    if (input$source_sea_6 == "User Data") {
      ts_data_new = data.frame(user_subset_6()[, 2, drop = FALSE])  # Keep it as a dataframe
    } else {
      ts_data_new = data.frame(timeseries_subdata_sea()[, 2, drop = FALSE])  # Use selected statistic
    }
    
    row.names(ts_data_new) = years()  # Assign row names
    return(ts_data_new)
  })
  
  # Cut event years based on the data
  event_years_cut <- reactive({
    if (input$enter_upload_6 == "Manual") {
      v_years <- as.integer(unlist(strsplit(input$event_years_6, split = ",")))
    } else if (input$enter_upload_6 == "Upload") {
      df <- year_set_sea()
      v_years <- df$Event  # Use first column only
    } else {
      return(NULL)
    }
    
    v_years_cut <- subset(v_years, v_years > (min(years()) - input$lag_years_6[1]) &
                            v_years < (max(years()) - input$lag_years_6[2]))
    return(v_years_cut)
  })
  
  # Calculate SEA data
  SEA_data = reactive({
    ts <- ts_data()
    
    # Helper: fill NAs in ts_data for random resampling
    fill_na_random <- function(ts_input) {
      ts_copy <- ts_input
      if (sum(is.na(ts_copy)) > 0) {
        non_na_vals <- ts_copy[!is.na(ts_copy)]
        ts_copy[is.na(ts_copy)] <- sample(non_na_vals, sum(is.na(ts_copy)), replace = TRUE)
      }
      return(ts_copy)
    }
    
    # Case 1: Use event-specific windows from uploaded file
    if (input$enter_upload_6 == "Upload" &&
        (input$use_custom_pre_6 || input$use_custom_post_6)) {
      
      df_event_years <- year_set_sea()
      ts_range <- as.numeric(rownames(ts))
      
      # Prepare per-event lag-adjusted window
      lag_range <- seq(-abs(input$lag_years_6[1]), input$lag_years_6[2])
      obs_matrix <- matrix(NA, nrow = 0, ncol = length(lag_range))
      colnames(obs_matrix) <- lag_range
      used_events <- c()
      
      for (i in 1:nrow(df_event_years)) {
        event    <- as.integer(df_event_years[i, 1])
        pre_end  <- as.integer(df_event_years[i, 2])
        post_end <- as.integer(df_event_years[i, 3])
        
        lag_before <- abs(input$lag_years_6[1])
        lag_after  <- input$lag_years_6[2]
        
        # --- Pre-event years ---
        pre_years <- seq(event - 1, event - lag_before, by = -1)
        if (input$use_custom_pre_6 && !is.na(pre_end)) {
          pre_years <- pre_years[pre_years <= pre_end]
        }
        pre_years <- sort(pre_years) # Optional: ascending order
        
        # --- Post-event years ---
        post_years <- seq(event + 1, event + lag_after, by = 1)
        if (input$use_custom_post_6 && !is.na(post_end)) {
          post_years <- post_years[post_years <= post_end]
        }
        
        # Combine pre, event, post (include event if you wish)
        years_window <- c(pre_years, event, post_years)
        relative_lags <- years_window - event
        values <- ts[as.character(years_window), 1]
        
        row_vals <- rep(NA, length(lag_range))
        match_index <- match(relative_lags, lag_range)
        row_vals[match_index[!is.na(match_index)]] <- values[!is.na(match_index)]
        
        obs_matrix <- rbind(obs_matrix, row_vals)
        used_events <- c(used_events, event)
      }
      
      # Calculate observed mean
      obs_mean <- colMeans(obs_matrix, na.rm = TRUE)
      
      # Optional: fill NAs and recompute random sample for CI bands
      ts_filled <- fill_na_random(ts)
      rand_matrix <- matrix(NA, nrow = input$sample_size_6, ncol = length(lag_range))
      
      for (j in 1:input$sample_size_6) {
        rand_events <- sample(as.numeric(rownames(ts_filled)),
                              length(used_events), replace = TRUE)
        tmp_obs <- matrix(NA, nrow = length(rand_events), ncol = length(lag_range))
        
        for (k in seq_along(rand_events)) {
          event <- rand_events[k]
          years_window <- seq(event - abs(input$lag_years_6[1]), event + input$lag_years_6[2])
          relative_lags <- years_window - event
          values <- ts_filled[as.character(years_window), 1]
          
          row_vals <- rep(NA, length(lag_range))
          match_index <- match(relative_lags, lag_range)
          row_vals[match_index[!is.na(match_index)]] <- values[!is.na(match_index)]
          
          tmp_obs[k, ] <- row_vals
        }
        rand_matrix[j, ] <- colMeans(tmp_obs, na.rm = TRUE)
      }
      
      # Confidence intervals
      lower_95 <- apply(rand_matrix, 2, quantile, probs = 0.025, na.rm = TRUE)
      upper_95 <- apply(rand_matrix, 2, quantile, probs = 0.975, na.rm = TRUE)
      lower_99 <- apply(rand_matrix, 2, quantile, probs = 0.005, na.rm = TRUE)
      upper_99 <- apply(rand_matrix, 2, quantile, probs = 0.995, na.rm = TRUE)
      rand_mean <- colMeans(rand_matrix, na.rm = TRUE)
      
      return(list(
        actual = list(
          lag = lag_range,
          mean = obs_mean
        ),
        observed = obs_matrix,
        event_years = used_events,
        random = list(
          mean = rand_mean,
          lower_95 = lower_95,
          upper_95 = upper_95,
          lower_99 = lower_99,
          upper_99 = upper_99,
          lag = lag_range
        )
      ))
    }
    
    # Case 2: Standard SEA with global lags using burnr::sea()
    else {
      original_SEA <- burnr::sea(ts_data(), event_years_cut(),
                                 nbefore = abs(input$lag_years_6[1]),
                                 nafter  = input$lag_years_6[2],
                                 n_iter  = input$sample_size_6)
      
      # Optional NA random fill
      if (sum(is.na(ts_data())) > 0) {
        ts_filled <- fill_na_random(ts_data())
        new_SEA <- burnr::sea(ts_filled, event_years_cut(),
                              nbefore = abs(input$lag_years_6[1]),
                              nafter  = input$lag_years_6[2],
                              n_iter  = input$sample_size_6)
        
        original_SEA$random$mean <- new_SEA$random$mean
        original_SEA$random$lower_95 <- new_SEA$random$lower_95
        original_SEA$random$upper_95 <- new_SEA$random$upper_95
        original_SEA$random$lower_99 <- new_SEA$random$lower_99
        original_SEA$random$upper_99 <- new_SEA$random$upper_99
      }
      
      return(original_SEA)
    }
  })
  
  # Create SEA datatable
  SEA_datatable = reactive({
    
    LAG_YEAR = SEA_data()$random$lag
    OBSERVATIONS_MEAN =  SEA_data()$actual$mean
    SEAdatatable = data.frame(LAG_YEAR,OBSERVATIONS_MEAN)
    
    if (input$show_means_6){
      SAMPLE_MEAN = SEA_data()$random$mean
      SEAdatatable = data.frame(SEAdatatable,SAMPLE_MEAN)
    }
    
    if (input$show_confidence_bands_6 == "95%"){
      CI_95_LOWER = SEA_data()$random$lower_95
      CI_95_UPPER = SEA_data()$random$upper_95
      SEAdatatable = data.frame(SEAdatatable,CI_95_LOWER,CI_95_UPPER)
    }
    
    if (input$show_confidence_bands_6 == "99%"){
      CI_99_LOWER = SEA_data()$random$lower_99
      CI_99_UPPER = SEA_data()$random$upper_99
      SEAdatatable = data.frame(SEAdatatable,CI_99_LOWER,CI_99_UPPER)
    }
    
    if (input$show_pvalues_6){
      alternative_SEA = dplR::sea(ts_data(),event_years_cut(),lag = max(abs(input$lag_years_6)))
      P = alternative_SEA$p[which(alternative_SEA$lag %in% SEA_data()$actual$lag)]
      SEAdatatable = data.frame(SEAdatatable,P)
    }
    
    if (input$show_observations_6){
      
      Observations = SEA_data()$observed[1,]
      
      for (i in 2:dim(SEA_data()$observed)[1]){
        observation_data = SEA_data()$observed[i,]
        Observations = data.frame(Observations,observation_data)
      }
      
      colnames(Observations) = paste0("Observations_",SEA_data()$event_years)
      SEAdatatable = data.frame(SEAdatatable,Observations)
    }
    return(SEAdatatable)
  })
  
  # Create plot function:
  SEA_plotfunction <- function() {
    data <- SEA_datatable()
    
    # Set y-axis range
    y_data <- data[, !names(data) %in% c("LAG_YEAR", "P")]
    SEAmin <- min(y_data, na.rm = TRUE)
    SEAmax <- max(y_data, na.rm = TRUE)
    SEArange <- SEAmax - SEAmin
    
    if (!is.null(input$axis_input_6) && all(!is.na(input$axis_input_6))) {
      ymin <- input$axis_input_6[1]
      ymax <- input$axis_input_6[2]
    } else {
      ymin <- SEAmin - (0.05 * SEArange)
      ymax <- SEAmax + (0.05 * SEArange)
    }
    
    # Base plot
    p <- ggplot(data, aes(x = LAG_YEAR)) +
      geom_line(aes(y = OBSERVATIONS_MEAN, color = "Observation Means"), size = 1.2, 
                show.legend = input$show_key_6) +
      scale_color_manual(
        values = c(
          "Observation Means" = "black",
          "Individual Events" = "grey",
          "Random Sample Means" = "purple",
          "Upper 95% Confidence Band" = "gold",
          "Lower 95% Confidence Band" = "firebrick3",
          "Upper 99% Confidence Band" = "gold",
          "Lower 99% Confidence Band" = "firebrick3"
        ),
        breaks = c(
          "Observation Means",
          "Individual Events",
          "Random Sample Means",
          "Upper 95% Confidence Band",
          "Lower 95% Confidence Band",
          "Upper 99% Confidence Band",
          "Lower 99% Confidence Band"
        )
      ) +
      labs(color = "Legend:") +
      geom_vline(xintercept = 0, linetype = "dashed", color = "grey", size = 1.2) +
      labs(x = "Lag Year", y = ts_y_label(), title = ts_title()) +
      theme_minimal(base_size = 16) +
      ylim(ymin, ymax) +
      theme(
        plot.margin = margin(6.7, 7.3, 4.1, 3.5, "pt"),
        legend.box = "vertical",
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12),
        legend.spacing.y = unit(0.4, "cm"),
        legend.key = element_blank(),
        legend.key.size = unit(1.2, "lines")
      )
    
    # Add individual event lines
    if (input$show_observations_6) {
      for (i in SEA_data()$event_years) {
        p <- p +
          geom_line(aes_string(y = paste0("Observations_", i), color = '"Individual Events"'),
                    size = 0.8, show.legend = input$show_key_6)
      }
    }
    
    # Add additional lines
    if (input$show_means_6) {
      p <- p + geom_line(aes(y = SAMPLE_MEAN, color = "Random Sample Means"), size = 1,
                         show.legend = input$show_key_6)
    }
    
    # Add Confidence Bands (if applicable)
    if (input$show_confidence_bands_6 == "95%") {
      p <- p + 
        geom_line(aes(y = CI_95_LOWER, color = "Lower 95% Confidence Band"), size = 1,
                  show.legend = input$show_key_6) +
        geom_line(aes(y = CI_95_UPPER, color = "Upper 95% Confidence Band"), size = 1,
                  show.legend = input$show_key_6)
    }
    
    if (input$show_confidence_bands_6 == "99%") {
      p <- p + 
        geom_line(aes(y = CI_99_LOWER, color = "Lower 99% Confidence Band"), size = 1,
                  show.legend = input$show_key_6) +
        geom_line(aes(y = CI_99_UPPER, color = "Upper 99% Confidence Band"), size = 1,
                  show.legend = input$show_key_6)
    }
    
    # Replot main line on top for visual reasons
    p <- p + geom_line(aes(y = OBSERVATIONS_MEAN), size = 1.2, color = "black")
    
    # Add p-values
    if (input$show_pvalues_6) {
      p <- p +
        geom_point(
          aes(
            y = OBSERVATIONS_MEAN,
            fill = factor(cut(P,
                              breaks = c(-Inf, 0.01, 0.05, Inf),
                              labels = c("p<0.01", "p<0.05", "NS"))
            )
          ),
          shape = 21, size = 6, stroke = 1.2, color = "black", show.legend = input$show_key_6
        ) +
        scale_fill_manual(
          values = c("p<0.01" = "#006D2C", "p<0.05" = "darkseagreen3", "NS" = "#EDF8E9"),
          labels = c("p<0.01", "p<0.05", "p>0.05"),
          breaks = c("p<0.01", "p<0.05", "NS"),
          drop = FALSE
        ) +
        labs(fill = "p-value:")
    }
    
    # Add tick marks
    if (input$show_ticks_6) {
      p <- p + scale_x_continuous(breaks = seq(input$lag_years_6[1], input$lag_years_6[2], by = 1))
    }
    
    # Separate legends for color and fill
    p <- p + guides(
      color = guide_legend(order = 1, override.aes = list(shape = NA, fill = NA)),
      fill = guide_legend(order = 2)
    )
    
    return(p)
  }
  
  # Generate Plot
  output$SEA_plot_6 <- renderPlot({
    SEA_plotfunction()
  })
  
  ####### Downloads ----
  output$download_timeseries6      <- downloadHandler(filename = function(){paste(ts_title(),"-sea.",input$file_type_timeseries6, sep = "")},
                                                      content  = function(file) {
                                                        if (input$file_type_timeseries6 == "png"){
                                                          png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                          
                                                        } else if (input$file_type_timeseries6 == "jpeg"){
                                                          jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                          
                                                        } else {
                                                          pdf(file, width = 14, height = 6, bg = "transparent") 
                                                        }
                                                        print(SEA_plotfunction())
                                                        dev.off()
                                                      })
  
  output$download_timeseries_data6  <- downloadHandler(filename = function(){paste(ts_title(),"-sea.",input$file_type_timeseries_data6, sep = "")},
                                                       content  = function(file) {
                                                         if (input$file_type_timeseries_data6 == "csv"){
                                                           write.csv(SEA_datatable(), file,
                                                                     row.names = FALSE,
                                                                     fileEncoding = "latin1")
                                                         } else {
                                                           openxlsx::write.xlsx(SEA_datatable(), file,
                                                                                col.names = TRUE,
                                                                                row.names = FALSE)
                                                         }})
  
  ### Concerning all modes (mainly updating Ui) ----
  
  #Updates Values outside of min / max (numericInput)
  
  updateNumericInputRange1 <- function(inputId, minValue, maxValue) {
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
  updateNumericInputRange1("point_size", 1, 10)
  updateNumericInputRange1("point_size2", 1, 10)
  updateNumericInputRange1("point_size3", 1, 10)
  updateNumericInputRange1("point_size_reg_coeff", 1, 10)
  updateNumericInputRange1("point_size_reg_pval", 1, 10)
  updateNumericInputRange1("point_size_reg_res", 1, 10)  
  
  updateNumericInputRange1("point_size_ts", 4, 20)
  updateNumericInputRange1("point_size_ts2", 4, 20)
  updateNumericInputRange1("point_size_ts3", 4, 20)
  updateNumericInputRange1("point_size_ts4", 4, 20)
  updateNumericInputRange1("point_size_ts5", 4, 20)
  
  updateNumericInputRange1("title_size_input", 1, 40)
  updateNumericInputRange1("title_size_input_ts", 1, 40)
  updateNumericInputRange1("title_size_input2", 1, 40)
  updateNumericInputRange1("title_size_input_ts2", 1, 40)
  updateNumericInputRange1("title_size_input3", 1, 40)
  updateNumericInputRange1("title_size_input_ts3", 1, 40)
  updateNumericInputRange1("title_size_input_ts4", 1, 40)
  updateNumericInputRange1("title_size_input_reg_coeff", 1, 40)
  updateNumericInputRange1("title_size_input_reg_pval", 1, 40)
  updateNumericInputRange1("title_size_input_reg_res", 1, 40)
  
  updateNumericInputRange1("prior_years2", 1, 50)
  updateNumericInputRange1("percentage_sign_match2", 1, 100)
  updateNumericInputRange1("sample_size_6", 100, 100000000000)
  
  updateNumericInputRange1("sd_ratio", 0, 1)
  updateNumericInputRange1("sd_ratio2", 0, 1)
  updateNumericInputRange1("sd_input_ref_ts3", 1, 10)
  updateNumericInputRange1("trend_sd_input_ref_ts3", 1, 10)
  
  updateNumericInputRange1("year_moving_ts", 3, 30)
  updateNumericInputRange1("year_moving_ts3", 3, 30)
  
  updateNumericInputRange1("xaxis_numeric_interval_ts", 1, 500)
  updateNumericInputRange1("xaxis_numeric_interval_ts2", 1, 500)
  updateNumericInputRange1("xaxis_numeric_interval_ts3", 1, 500)
  updateNumericInputRange1("xaxis_numeric_interval_ts4", 1, 500)
  
  updateNumericInputRange1("center_lat", -90, 90)
  updateNumericInputRange1("center_lon", -180, 180)
  updateNumericInputRange1("center_lat2", -90, 90)
  updateNumericInputRange1("center_lon2", -180, 180)
  updateNumericInputRange1("center_lat3", -90, 90)
  updateNumericInputRange1("center_lon3", -180, 180)
  updateNumericInputRange1("center_lat_reg_coeff", -90, 90)
  updateNumericInputRange1("center_lon_reg_coeff", -180, 180)
  updateNumericInputRange1("center_lat_reg_pval", -90, 90)
  updateNumericInputRange1("center_lon_reg_pval", -180, 180)
  updateNumericInputRange1("center_lat_reg_res", -90, 90)
  updateNumericInputRange1("center_lon_reg_res", -180, 180)
  
  updateNumericInputRange1("lagyears_v1_cor", -100, 100)
  updateNumericInputRange1("lagyears_v2_cor", -100, 100)
  
  updateNumericInputRange1("fad_year", 1422, 2008)
  updateNumericInputRange1("fad_year2", 1422, 2008)
  updateNumericInputRange1("fad_year3", 1422, 2008)
  updateNumericInputRange1("fad_year4", 1422, 2008)
  updateNumericInputRange1("fad_year5", 1422, 2008)
  updateNumericInputRange1("reg_resi_year", 1422, 2008)
  updateNumericInputRange1("range_years_sg", 1422, 2008)
  updateNumericInputRange1("ref_period_sg", 1422, 2008)
  updateNumericInputRange1("ref_period_sg2", 1422, 2008)
  updateNumericInputRange1("ref_period_sg_v1", 1422, 2008)
  updateNumericInputRange1("ref_period_sg_v2", 1422, 2008)
  updateNumericInputRange1("ref_period_sg_iv", 1422, 2008)
  updateNumericInputRange1("ref_period_sg_dv", 1422, 2008)
  updateNumericInputRange1("ref_period_sg5", 1422, 2008)
  updateNumericInputRange1("ref_period_sg6", 1422, 2008)
  updateNumericInputRange1("year_MES", 1422, 2008)
  
  
  #Updates Values outside of min / max (numericRangeInput)
  updateNumericRangeInputSafe <- function(inputId, minValue, maxValue, skip_if = NULL) {
    observe({
      if (!is.null(skip_if) && skip_if()) return()

      range_values <- input[[inputId]]
      if (is.null(range_values) || length(range_values) != 2) return()

      left <- range_values[1]
      right <- range_values[2]

      new_left <- if (!is.numeric(left) || is.na(left) || left < minValue || left > maxValue) minValue else left
      new_right <- if (!is.numeric(right) || is.na(right) || right < minValue || right > maxValue) maxValue else right

      if (!identical(c(left, right), c(new_left, new_right))) {
        updateNumericRangeInput(inputId = inputId, value = c(new_left, new_right))
      }
    })
  }

  updateNumericRangeInputSafe("range_years3", 1422, 2008, skip_if = function() {
    input$source_v1 == "User Data" && input$source_v2 == "User Data"
  })

  updateNumericRangeInputSafe("range_years4", 1422, 2008, skip_if = function() {
    input$source_dv == "User Data" && input$source_iv == "User Data"
  })

  updateNumericRangeInputSafe("range_years", 1422, 2008)
  updateNumericRangeInputSafe("ref_period", 1422, 2008)
  updateNumericRangeInputSafe("ref_period2", 1422, 2008)
  updateNumericRangeInputSafe("ref_period_v1", 1422, 2008)
  updateNumericRangeInputSafe("ref_period_v2", 1422, 2008)
  updateNumericRangeInputSafe("ref_period_iv", 1422, 2008)
  updateNumericRangeInputSafe("ref_period_dv", 1422, 2008)
  updateNumericRangeInputSafe("ref_period5", 1422, 2008)
  updateNumericRangeInputSafe("ref_period_6", 1422, 2008)

  updateNumericRangeInputSafe("range_longitude", -180, 180)
  updateNumericRangeInputSafe("range_longitude2", -180, 180)
  updateNumericRangeInputSafe("range_longitude_v1", -180, 180)
  updateNumericRangeInputSafe("range_longitude_v2", -180, 180)
  updateNumericRangeInputSafe("range_longitude_iv", -180, 180)
  updateNumericRangeInputSafe("range_longitude_dv", -180, 180)
  updateNumericRangeInputSafe("range_longitude5", -180, 180)
  updateNumericRangeInputSafe("range_longitude_6", -180, 180)
  updateNumericRangeInputSafe("fad_longitude_a5", -180, 180)

  updateNumericRangeInputSafe("range_latitude", -90, 90)
  updateNumericRangeInputSafe("range_latitude2", -90, 90)
  updateNumericRangeInputSafe("range_latitude_v1", -90, 90)
  updateNumericRangeInputSafe("range_latitude_v2", -90, 90)
  updateNumericRangeInputSafe("range_latitude_iv", -90, 90)
  updateNumericRangeInputSafe("range_latitude_dv", -90, 90)
  updateNumericRangeInputSafe("range_latitude5", -90, 90)
  updateNumericRangeInputSafe("range_latitude_6", -90, 90)
  updateNumericRangeInputSafe("fad_latitude_a5", -90, 90)

  updateNumericRangeInputSafe("lag_years_6", -100, 100)
  updateNumericRangeInputSafe("year_range_sources", 1421, 2009)
  
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
  
  ### Stop App on end of session ----
  session$onSessionEnded(function() {
    stopApp()
  })
  # Close server function ----
}

# Run the app with profiling
# profvis({runApp(app)})