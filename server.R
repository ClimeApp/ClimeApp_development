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
  
  #Preparations in the Server (Hidden options) ----
    ## Easter Eggs ----
    
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
    
    ## Logos ----
    
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
    
    ## Panel Visibility ----
    
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
    
    ## Hiding, showing, enabling/unabling certain inputs ----
      ### Anomalies ----
      
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
      ## Anomalies Maps
      
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
      
      ## Anomalies TS
      
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
      
      
      ### Composite ----
      
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
    
      
      ### Correlation ----
      
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

      
      # Customization
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
    
      ### Regression ----
      
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
      
      #Customization
      ## Regression Maps
      observe({shinyjs::toggle(id = "hidden_custom_maps_reg",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$custom_map_reg == TRUE,
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_axis_reg",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$axis_mode_reg == "Fixed",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_title4",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$title_mode4 == "Custom",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_features4",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$custom_features4 == TRUE,
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_points4",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$feature4 == "Point",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_highlights4",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$feature4 == "Highlight",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_download4",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$download_options4 == TRUE,
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_title_reg",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$title_mode_reg == "Custom",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_title1_reg",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$title1_input_reg == "Custom",
                               asis = FALSE)})
      
      observe({shinyjs::toggle(id = "hidden_custom_title2_reg",
                               anim = TRUE,
                               animType = "slide",
                               time = 0.5,
                               selector = NULL,
                               condition = input$title2_input_reg == "Custom",
                               asis = FALSE)})
      
      
      
      ### Annual cycles ----
      
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
      
      ### SEA ----
      
      ##Sidebar Data
      
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

    ## ANOMALIES observe, update & interactive controls ----
    
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
                                     input$title_size_input,
                                     input$custom_statistic,
                                     input$sd_ratio,
                                     input$hide_borders,
                                     input$white_ocean,
                                     input$white_land)
        
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
        updateNumericInput(session = getDefaultReactiveDomain(), "title_size_input", value = metadata[1, "title_size_input"])
        updateRadioButtons(session = getDefaultReactiveDomain(), "custom_statistic", selected = metadata[1, "custom_statistic"])
        updateNumericInput(session = getDefaultReactiveDomain(), "sd_ratio", value = metadata[1, "sd_ratio"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_borders", value = metadata[1, "hide_borders"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_ocean", value = metadata[1, "white_ocean"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_land", value = metadata[1, "white_land"])
        
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
      
      ### Generate Layer Options for customization ----
      # Reactive value to store the plot order
      plotOrder <- reactiveVal(character(0))
      
      # Usage example:
      observeEvent(input$shpFile, {
        updatePlotOrder(input$shpFile$datapath, plotOrder, "shpPickers")
      })
      
      # Function to generate color picker UI dynamically
      output$colorpickers <- renderUI({
        createColorPickers(plotOrder(), input$shpFile)
      })
      
      # Manually reorder shapefiles
      observeEvent(input$reorderButton, {
        createReorderModal(plotOrder(), input$shpFile)
        
      })
      
      observeEvent(input$reorderConfirm, {
        reorder_shapefiles(plotOrder, input$reorderSelect, input$reorderAfter, "shpPickers")
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
                                           input$title_size_input2,
                                           input$custom_statistic2,
                                           input$percentage_sign_match2,
                                           input$sd_ratio2,
                                           input$hide_borders2,
                                           input$white_ocean2,
                                           input$white_land2)
        
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
        updateNumericInput(session = getDefaultReactiveDomain(), "title_size_input2", value = metadata2[1, "title_size_input2"])
        updateRadioButtons(session = getDefaultReactiveDomain(), "custom_statistic2", selected = metadata2[1, "custom_statistic2"])
        updateNumericInput(session = getDefaultReactiveDomain(), "percentage_sign_match2", value = metadata2[1, "percentage_sign_match2"])
        updateNumericInput(session = getDefaultReactiveDomain(), "sd_ratio2", value = metadata2[1, "sd_ratio2"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "hide_borders2", value = metadata2[1, "hide_borders2"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_ocean2", value = metadata2[1, "white_ocean2"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_land2", value = metadata2[1, "white_land2"])
        
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
      
      ### Generate Layer Options for customization ----
      # Reactive value to store the plot order
      plotOrder2 <- reactiveVal(character(0))
      
      # Usage example:
      observeEvent(input$shpFile2, {
        updatePlotOrder2(input$shpFile2$datapath, plotOrder2, "shpPickers2")
      })
      
      # Function to generate color picker UI dynamically
      output$colorpickers2 <- renderUI({
        createColorPickers2(plotOrder2(), input$shpFile2)
      })
      
      # Manually reorder shapefiles
      observeEvent(input$reorderButton2, {
        createReorderModal(plotOrder2(), input$shpFile2)
        
      })
      
      observeEvent(input$reorderConfirm, {
        reorder_shapefiles(plotOrder2, input$reorderSelect, input$reorderAfter, "shpPickers2")
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

      observeEvent(year_range_cor(),{
        if (input$range_years3[1]<year_range_cor()[1]){
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_years3",
            value = c(year_range_cor()[1],input$range_years3[2])
          )
        }
  
        if (input$range_years3[2]>year_range_cor()[2]){
          updateNumericRangeInput(
            session = getDefaultReactiveDomain(),
            inputId = "range_years3",
            value = c(input$range_years3[1],year_range_cor()[2])
          )
        }
        
        updateNumericRangeInput(
          session = getDefaultReactiveDomain(),
          inputId = "range_years3",
          label = paste("Select the range of years (",year_range_cor()[1],"-",year_range_cor()[2],")",sep = "")
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
      observeEvent(input$cor_method_ts, {
        updateRadioButtonsGroup(input$cor_method_ts, c("cor_method_ts", "cor_method_map", "cor_method_map_data"))
      })
      
      observeEvent(input$cor_method_map, {
        updateRadioButtonsGroup(input$cor_method_map, c("cor_method_ts", "cor_method_map", "cor_method_map_data"))
      })
      
      observeEvent(input$cor_method_map_data, {
        updateRadioButtonsGroup(input$cor_method_map_data, c("cor_method_ts", "cor_method_map", "cor_method_map_data"))
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
                                           input$white_ocean3,
                                           input$white_land3,
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
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_ocean3", value = metadata3[1, "white_ocean3"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "white_land3", value = metadata3[1, "white_land3"])
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
      
      ### Generate Layer Options for customization ----
      # Reactive value to store the plot order
      plotOrder3 <- reactiveVal(character(0))
      
      # Usage example:
      observeEvent(input$shpFile3, {
        updatePlotOrder3(input$shpFile3$datapath, plotOrder3, "shpPickers3")
      })
      
      # Function to generate color picker UI dynamically
      output$colorpickers3 <- renderUI({
        createColorPickers3(plotOrder3(), input$shpFile3)
      })
      
      # Manually reorder shapefiles
      observeEvent(input$reorderButton3, {
        createReorderModal(plotOrder3(), input$shpFile3)
        
      })
      
      observeEvent(input$reorderConfirm, {
        reorder_shapefiles(plotOrder3, input$reorderSelect, input$reorderAfter, "shpPickers3")
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
        if (!identical(custom_data_id_primary()[2:3],monthly_ts_data_ID[2:3])){ # ....i.e. changed variable or dataset
          custom_data_primary(load_ModE_data(input$dataset_selected5,input$variable_selected5)) # load new custom data
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
      
    ## SEA observe, update & interactive controls----
      ### Input updaters ----
      
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
      
      ### Generate Metadata for SEA ----
      
      #Download Plot data 
      plot_gen_input_sea <- reactive({
        
        plot_gen_sea = generate_metadata_sea_plot(input$dataset_selected_6,
                                                  input$ME_variable_6,
                                                  input$ME_statistic_6,
                                                  input$season_selected_6,
                                                  input$range_months_6,
                                                  input$ref_period_6,
                                                  input$ref_single_year_6,
                                                  input$ref_period_sg_6,
                                                  input$range_longitude_6,
                                                  input$range_latitude_6,
                                                  lonlat_vals6())
        
        return(plot_gen_sea)
      })
      
      #Download Options data
      plot_gen_side_input_sea <- reactive({

        plot_gen_side_sea = generate_metadata_sea_side_plot(input$lag_years_6,
                                                            input$event_years_6)

        return(plot_gen_side_sea)
      })
      
      #Download Custom SEA data
      custom_map_input_sea <- reactive({
        
        custom_map_sea = generate_metadata_sea_ts(input$title_mode_6,
                                                  input$title1_input_6,
                                                  input$y_label_6,
                                                  input$show_observations_6,
                                                  input$show_pvalues_6,
                                                  input$show_ticks_6,
                                                  input$show_key_6,
                                                  input$sample_size_6,
                                                  input$show_means_6,
                                                  input$show_confidence_bands_6)
        
        return(custom_map_sea)
      })
      
      #Download Metadata as Excel
      output$download_metadata_6 <- downloadHandler(
        filename = function() {"metadata_sea.xlsx"},
        content  = function(file) {
          wb <- openxlsx::createWorkbook()
          openxlsx::addWorksheet(wb, "plot_gen_sea")
          openxlsx::addWorksheet(wb, "plot_gen_side_sea")
          openxlsx::addWorksheet(wb, "custom_map_sea")
          openxlsx::writeData(wb, "plot_gen_sea", plot_gen_input_sea())
          openxlsx::writeData(wb, "plot_gen_side_sea", plot_gen_side_input_sea())
          openxlsx::writeData(wb, "custom_map_sea", custom_map_input_sea())
          openxlsx::saveWorkbook(wb, file)
        }
      )
      
      #Upload SEA metadata
      process_uploaded_file_sea <- function() {
        
        # Update plot generation
        plot_data_sea <- openxlsx::read.xlsx(input$upload_metadata_6$datapath, sheet = "plot_gen_sea")
        
        # Update inputs based on plot_data_sea sheet plot_gen_sea
        updateSelectInput(session = getDefaultReactiveDomain(), "dataset_selected_6", selected = plot_data_sea[1, "dataset"])
        updateSelectInput(session = getDefaultReactiveDomain(), "ME_variable_6", selected = plot_data_sea[1, "variable"])
        updateSelectInput(session = getDefaultReactiveDomain(), "ME_statistic_6", selected = plot_data_sea[1, "statistic"])
        updateRadioButtons(session = getDefaultReactiveDomain(), "season_selected_6", selected = plot_data_sea[1, "season_sel"])
        updateSliderTextInput(session = getDefaultReactiveDomain(), "range_months_6", selected = plot_data_sea[1:2, "range_months"])
        updateNumericRangeInput(session = getDefaultReactiveDomain(), "ref_period_6", value = plot_data_sea[1:2, "ref_period"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "ref_single_year_6", value = plot_data_sea[1, "select_sg_ref"])
        updateNumericInput(session = getDefaultReactiveDomain(), "ref_period_sg_6", value = plot_data_sea[1, "sg_ref"])
        updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_longitude_6", value = plot_data_sea[1:2, "lon_range"])
        updateNumericRangeInput(session = getDefaultReactiveDomain(), "range_latitude_6", value = plot_data_sea[1:2, "lat_range"])
        # Update Lon Lat Vals
        lonlat_vals6(plot_data_sea[1:4, "lonlat_vals"])
        

        # Update plot generation
        plot_data_side_sea <- openxlsx::read.xlsx(input$upload_metadata_6$datapath, sheet = "plot_gen_side_sea")
        
        # Update inputs based on plot_data_sea sheet plot_gen_sea
        updateNumericRangeInput(session = getDefaultReactiveDomain(), "lag_years_6", value = plot_data_side_sea[1:2, "lag_years"])
        updateTextInput(session = getDefaultReactiveDomain(), "event_years_6", value = plot_data_side_sea[1, "event_years"])
        
        # Update inputs based on metadata_sea sheet custom_map_sea
        metadata_sea <- openxlsx::read.xlsx(input$upload_metadata_6$datapath, sheet = "custom_map_sea")
        
        updateRadioButtons(session = getDefaultReactiveDomain(), "title_mode_6", selected = metadata_sea[1, "title_mode_6"])
        updateTextInput(session = getDefaultReactiveDomain(), "title1_input_6", value = metadata_sea[1, "title1_input_6"])
        updateTextInput(session = getDefaultReactiveDomain(), "y_label_6", value = metadata_sea[1, "y_label_6"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "show_observations_6", value = metadata_sea[1, "show_observations_6"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "show_pvalues_6", value = metadata_sea[1, "show_pvalues_6"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "show_ticks_6", value = metadata_sea[1, "show_ticks_6"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "show_key_6", value = metadata_sea[1, "show_key_6"])
        updateNumericInput(session = getDefaultReactiveDomain(), "sample_size_6", value = metadata_sea[1, "sample_size_6"])
        updateCheckboxInput(session = getDefaultReactiveDomain(), "show_means_6", value = metadata_sea[1, "show_means_6"])
        updateRadioButtons(session = getDefaultReactiveDomain(), "show_confidence_bands_6", selected = metadata_sea[1, "show_confidence_bands_6"])
      }
      
      # Event handler for upload button
      observeEvent(input$update_metadata_6, {
        req(input$upload_metadata_6)
        file_path <- input$upload_metadata_6$datapath
        
        # Read the first sheet name from the uploaded Excel file
        first_sheet_name_sea <- tryCatch({
          available_sheets <- getSheetNames(file_path)
          available_sheets[[1]]
        }, error = function(e) {
          NULL
        })
        
        # Check if the correct first sheet name is present
        if (!is.null(first_sheet_name_sea) && first_sheet_name_sea == "plot_gen_sea") {
          # Correct first sheet name is present, proceed with processing the file
          process_uploaded_file_sea()
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
      
  #Processing and Plotting ----
    ## DATA PROCESSING ----  
    # NOTE that "primary" refers to anomalies, composites, variable 1 and dependent
    # variable while "secondary" refers to variable 2 and independent variable
    
      ### Month range ----
      
      month_range_primary <- reactive({
        #Creating Numeric Vector for Month Range between 0 and 12
        if (input$nav1 == "tab1"){   # Anomalies
          create_month_range(input$range_months)    
        } else if (input$nav1 == "tab2"){   # Composites
          create_month_range(input$range_months2)    
        } else if (input$nav1 == "tab3"){   # Correlation
          create_month_range(input$range_months_v1)   
        } else if (input$nav1 == "tab4"){   # Regression
          create_month_range(input$range_months_dv)
        } else if (input$nav1 == "tab6"){   # SEA
          create_month_range(input$range_months_6) 
        }
      })
      
      month_range_secondary <- reactive({
        #Creating Numeric Vector for Month Range between 0 and 12
        if (input$nav1 == "tab3"){   # Correlation
          create_month_range(input$range_months_v2)  
        } else if (input$nav1 == "tab4"){   # Regression
          create_month_range(input$range_months_iv) 
        }
      })
      
      ### Subset lons & Subset lats ----
      
      subset_lons_primary <- reactive({
        if (input$nav1 == "tab1"){   # Anomalies
          create_subset_lon_IDs(lonlat_vals()[1:2])       
        } else if (input$nav1 == "tab2"){   # Composites
          create_subset_lon_IDs(lonlat_vals2()[1:2])
        } else if (input$nav1 == "tab3"){   # Correlation
          create_subset_lon_IDs(lonlat_vals_v1()[1:2])
        } else if (input$nav1 == "tab4"){   # Regression
          create_subset_lon_IDs(lonlat_vals_dv()[1:2])
        } else if (input$nav1 == "tab6"){   # SEA
          create_subset_lon_IDs(lonlat_vals6()[1:2])
        }
      })
      
      subset_lons_secondary <- reactive({
        if (input$nav1 == "tab3"){   # Correlation
          create_subset_lon_IDs(lonlat_vals_v2()[1:2])
        } else if (input$nav1 == "tab4"){   # Regression
          create_subset_lon_IDs(lonlat_vals_iv()[1:2])
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
      
      ### Data ID ----
      # Generating data ID - c(pre-processed data?,dataset,variable,season)
      
      data_id_primary <- reactive({
        if (input$nav1 == "tab1"){   # Anomalies
          generate_data_ID(input$dataset_selected,input$variable_selected, month_range_primary())  
        } else if (input$nav1 == "tab2"){   # Composites
          generate_data_ID(input$dataset_selected2,input$variable_selected2, month_range_primary())
        } else if (input$nav1 == "tab3"){   # Correlation
          generate_data_ID(input$dataset_selected_v1,input$ME_variable_v1, month_range_primary())
        } else if (input$nav1 == "tab4"){   # Regression
          generate_data_ID(input$dataset_selected_dv,input$ME_variable_dv, month_range_primary())
        } else if (input$nav1 == "tab6"){   # SEA
          generate_data_ID(input$dataset_selected_6,input$ME_variable_6, month_range_primary())
        }  
      })
      
      data_id_secondary <- reactive({
        if (input$nav1 == "tab3"){   # Correlation
          generate_data_ID(input$dataset_selected_v2,input$ME_variable_v2, month_range_secondary())
        }
      })
      
      
      ### Update custom_data ----
      
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
            
            custom_data_primary(load_ModE_data(new_dataset,new_variable)) # load new custom data
            custom_data_id_primary(data_id_primary()) # update custom data ID
          }
        } 
        
        # Update preprocessed data
        else if (data_id_primary()[1] == 2){ # Only updates when new pp data is required...
          if (!identical(preprocessed_data_id_primary()[2:4],data_id_primary()[2:4])){ # ....i.e. changed variable, dataset or month range
            preprocessed_data_primary(load_preprocessed_data(data_id_primary()))# load new pp data
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
            
            custom_data_secondary(load_ModE_data(new_dataset,new_variable)) # load new custom data
            custom_data_id_secondary(data_id_secondary()) # update custom data ID
          }
        }
        
        # Update preprocessed data
        else if (data_id_secondary()[1] == 2){ # Only updates when new pp data is required...
          if (!identical(preprocessed_data_id_secondary()[2:4],data_id_secondary()[2:4])){ # ....i.e. changed variable, dataset or month range
            preprocessed_data_secondary(load_preprocessed_data(data_id_secondary()))# load new pp data
            preprocessed_data_id_secondary(data_id_secondary()) # update pp data ID
          }
        }
      })
      
      ### Geographic Subset ----
      
      data_output1_primary <- reactive({
        req(data_id_primary(), subset_lons_primary(), subset_lats_primary())
        if (data_id_primary()[1] != 2) { # i.e. preloaded or custom data
          create_latlon_subset(custom_data_primary(), data_id_primary(), subset_lons_primary(), subset_lats_primary())
        } else { # i.e. preloaded data
          create_latlon_subset(preprocessed_data_primary(), data_id_primary(), subset_lons_primary(), subset_lats_primary())
        }
      })
      
      data_output1_secondary <- reactive({
        req(data_id_secondary(), subset_lons_secondary(), subset_lats_secondary())
        if (data_id_secondary()[1] != 2) { # i.e. preloaded or custom data
          create_latlon_subset(custom_data_secondary(), data_id_secondary(), subset_lons_secondary(), subset_lats_secondary())
        } else { # i.e. preloaded data
          create_latlon_subset(preprocessed_data_secondary(), data_id_secondary(), subset_lons_secondary(), subset_lats_secondary())
        }
      })
      
      ### Yearly subset ----
      
      data_output2_primary <- reactive({
        if (input$nav1 == "tab1"){   # Anomalies
          create_yearly_subset(data_output1_primary(), data_id_primary(), input$range_years, month_range_primary())  
        } else if (input$nav1 == "tab2"){   # Composites
          create_yearly_subset_composite(data_output1_primary(), data_id_primary(), year_set_comp(), month_range_primary())
        } else if (input$nav1 == "tab3"){   # Correlation
          adjusted_years = input$range_years3+input$lagyears_v1_cor
          create_yearly_subset(data_output1_primary(), data_id_primary(), adjusted_years, month_range_primary())     
        } else if (input$nav1 == "tab4"){   # Regression
          create_yearly_subset(data_output1_primary(), data_id_primary(), input$range_years4, month_range_primary())
        } else if (input$nav1 == "tab6"){   # SEA
          create_yearly_subset(data_output1_primary(), data_id_primary(), c(1422,2008), month_range_primary()) 
        }
      })
      
      data_output2_secondary <- reactive({
        if (input$nav1 == "tab3"){   # Correlation
          adjusted_years = input$range_years3+input$lagyears_v2_cor
          create_yearly_subset(data_output1_secondary(), data_id_secondary(), adjusted_years, month_range_secondary())
        }
      })
      
      ### Reference subset ----
      # Create reference yearly subset & convert to mean
      
      data_output3_primary <- reactive({
        if (input$nav1 == "tab1"){   # Anomalies
          apply(create_yearly_subset(data_output1_primary(), data_id_primary(), input$ref_period, month_range_primary()),c(1:2),mean)  
        } else if (input$nav1 == "tab2"){   # Composites
          if (input$mode_selected2 == "Fixed reference"){
            apply(create_yearly_subset(data_output1_primary(), data_id_primary(), input$ref_period2, month_range_primary()),c(1:2),mean)
          } else if (input$mode_selected2 == "Custom reference") {
            apply(create_yearly_subset_composite(data_output1_primary(), data_id_primary(), year_set_comp_ref(), month_range_primary()),c(1:2),mean)
          } else {
            NA
          }
        } else if (input$nav1 == "tab3"){   # Correlation
          apply(create_yearly_subset(data_output1_primary(), data_id_primary(), input$ref_period_v1, month_range_primary()),c(1:2),mean)
        } else if (input$nav1 == "tab4"){   # Regression
          apply(create_yearly_subset(data_output1_primary(), data_id_primary(), input$ref_period_dv, month_range_primary()),c(1:2),mean)
        } else if (input$nav1 == "tab6"){   # SEA
          apply(create_yearly_subset(data_output1_primary(), data_id_primary(), input$ref_period_6, month_range_primary()),c(1:2),mean)
        }
      })    
      
      data_output3_secondary <- reactive({
        if (input$nav1 == "tab3"){   # Correlation
          apply(create_yearly_subset(data_output1_secondary(), data_id_secondary(), input$ref_period_v2, month_range_secondary()),c(1:2),mean)
        }
      })    
      
      
      #Converting absolutes to anomalies
      data_output4 <- reactive({
        
        processed_data4 <- convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
        
        return(processed_data4)
      })
      
      ### Convert to anomalies ----
      
      data_output4_primary <- reactive({
        if (input$nav1 == "tab1"){   # Anomalies
          convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
        } else if (input$nav1 == "tab2"){   # Composites
          if (input$mode_selected2 == "X years prior"){
            convert_composite_to_anomalies(data_output2_primary(), data_output1_primary(), data_id_primary(), year_set_comp(), month_range_primary(), input$prior_years2)
          } else {
            convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
          }
        } else if (input$nav1 == "tab3"){   # Correlation
          if (input$mode_selected_v1 == "Absolute"){
            data_output2_primary()
          } else {
            convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
          }
        } else if (input$nav1 == "tab4"){   # Regression
          if (input$mode_selected_dv == "Absolute"){
            data_output2_primary()
          } else {
            convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
          } 
        } else if (input$nav1 == "tab6"){   # SEA
          convert_subset_to_anomalies(data_output2_primary(), data_output3_primary())
        }
      })
      
      data_output4_secondary <- reactive({
        if (input$nav1 == "tab3"){   # Correlation
          if (input$mode_selected_v2 == "Absolute"){
            data_output2_secondary()
          } else {
            convert_subset_to_anomalies(data_output2_secondary(), data_output3_secondary())
          }
        }
      })
      
    ## ANOMALIES Load SD ratio data, plotting & downloads ----  
      ### SD ratio data ----
      
      # Update SD ratio data when required
      observe({
        if((input$ref_map_mode == "SD Ratio")|(input$custom_statistic == "SD ratio")){
          if (input$nav1 == "tab1"){ # check current tab
            if (!identical(SDratio_data_id()[3:4],data_id_primary()[3:4])){ # check to see if currently loaded variable & month range are the same
              if (data_id_primary()[1] != 0) { # check for preprocessed SD ratio data
                new_data_id = data_id_primary()
                new_data_id[2] = 4 # change data ID to SD ratio
                
                SDratio_data(load_preprocessed_data(new_data_id)) # load new SD data
                SDratio_data_id(data_id_primary()) # update custom data ID
              }
              else{
                SDratio_data(load_ModE_data("SD Ratio",input$variable_selected)) # load new SD data
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
      
      ### Plotting ----
      
      #Map customization (statistics and map titles)
      
      plot_titles <- reactive({
        req(input$nav1 == "tab1") # Only run code if in the current tab
          
        my_title <- generate_titles(tab="general", dataset=input$dataset_selected, variable=input$variable_selected, 
                                    mode="Anomaly", map_title_mode=input$title_mode,ts_title_mode=input$title_mode_ts,
                                    month_range=month_range_primary(), year_range=input$range_years, baseline_range=input$ref_period, baseline_years_before=NA,
                                    lon_range=lonlat_vals()[1:2],lat_range=lonlat_vals()[3:4],
                                    map_custom_title1=input$title1_input, map_custom_title2=input$title2_input,ts_custom_title1=input$title1_input_ts, ts_custom_title2=NA,
                                    map_title_size=input$title_size_input, ts_title_size=input$title_size_input_ts, ts_data=timeseries_data())
        return(my_title)
      })
      
      map_statistics = reactive({
        req(input$nav1 == "tab1") # Only run code if in the current tab
        my_stats = create_stat_highlights_data(data_output4_primary(),SDratio_subset(),
                                               input$custom_statistic,input$sd_ratio,
                                               NA,subset_lons_primary(),subset_lats_primary())
        return(my_stats)
      })
      
      #Plotting the Data (Maps)
      map_data <- function(){create_map_datatable(data_output4_primary(), subset_lons_primary(), subset_lats_primary())}
      
      output$data1 <- renderTable({map_data()}, rownames = TRUE)
      
      #Plotting the Map
      map_dimensions <- reactive({
        req(input$nav1 == "tab1") # Only run code if in the current tab
        m_d = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_map_width, input$dimension[2], input$hide_axis)
        return(m_d)  
      })
      
      map_plot <- function(){plot_map(create_geotiff(map_data()), lonlat_vals(), input$variable_selected, "Anomaly", plot_titles(), input$axis_input, input$hide_axis, map_points_data(), map_highlights_data(),map_statistics(),input$hide_borders,input$white_ocean,input$white_land,plotOrder(), input$shpPickers, input, "shp_colour_", input$projection, input$center_lat, input$center_lon)}    
      
      output$map <- renderPlot({map_plot()},width = function(){map_dimensions()[1]},height = function(){map_dimensions()[2]})
      
      
      #Ref/Absolute/SD ratio Map
      ref_map_data <- function(){
        if (input$ref_map_mode == "Absolute Values"){
          create_map_datatable(data_output2_primary(), subset_lons_primary(), subset_lats_primary())
        } else if (input$ref_map_mode == "Reference Values"){
          create_map_datatable(data_output3_primary(), subset_lons_primary(), subset_lats_primary())
        } else if (input$ref_map_mode == "SD Ratio"){
          req(SDratio_subset())
          create_map_datatable(SDratio_subset(), subset_lons_primary(), subset_lats_primary())
        }
      }    
      
      ref_map_titles = reactive({
        
        req(input$nav1 == "tab1") # Only run code if in the current tab
        
        active_tab <- ifelse(input$ref_map_mode == "SD Ratio", "sdratio", "general")
        years_or_ref <- ifelse(input$ref_map_mode == "Reference Values", input$ref_period, input$range_years)
        
        rm_title <- generate_titles(
          tab=active_tab, dataset=input$dataset_selected, variable=input$variable_selected, mode="Absolute",
          map_title_mode=input$title_mode, ts_title_mode=input$title_mode_ts, 
          month_range=month_range_primary(), year_range=years_or_ref,
          lon_range=lonlat_vals()[1:2], lat_range=lonlat_vals()[3:4],
          map_custom_title1=input$title1_input, map_custom_title2=input$title2_input, ts_custom_title1=input$title1_input_ts, map_title_size=input$title_size_input
        )
      })  
      
      ref_map_plot <- function(){
        if (input$ref_map_mode == "Absolute Values" | input$ref_map_mode == "Reference Values" ){
          v=input$variable_selected; m="Absolute"; axis_range=NULL
          
        } else if(input$ref_map_mode == "SD Ratio"){
          v=NULL; m="SD Ratio"; axis_range=c(0,1)
        }
        plot_map(data_input=create_geotiff(ref_map_data()), lon_lat_range=lonlat_vals(), variable=v, mode=m, titles=ref_map_titles(), axis_range=axis_range, 
                 c_borders=input$hide_borders, white_ocean=input$white_ocean, white_land=input$white_land, plotOrder=plotOrder(), 
                 shpPickers=input$shpPickers, input=input, plotType="shp_colour_", projection=input$projection, center_lat=input$center_lat, center_lon=input$center_lon)
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
        if (input$range_years[1] != input$range_years[2]){
          ts_data1 <- create_timeseries_datatable(data_output4_primary(), input$range_years, "range", subset_lons_primary(), subset_lats_primary())
          
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
        req(input$nav1 == "tab1") # Only run code if in the current tab
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
      
      #REMOVE
      
      #Plotting the timeseries
      # timeseries_plot_anom<- function(){
      #   #Plot normal timeseries if year range is > 1 year
      #   if (input$range_years[1] != input$range_years[2]){
      #     # Generate NA or reference mean
      #     if(input$show_ref_ts == TRUE){
      #       ref_ts = signif(mean(data_output3_primary()),3)
      #     } else {
      #       ref_ts = NA
      #     }
      #     
      #     plot_default_timeseries(timeseries_data(),"general",input$variable_selected,plot_titles(),input$title_mode_ts,ref_ts)
      #     # add_highlighted_areas(ts_highlights_data())
      #     # add_percentiles(timeseries_data())
      #     # add_custom_lines(ts_lines_data())
      #     # add_timeseries(timeseries_data(),"general",input$variable_selected)
      #     # add_boxes(ts_highlights_data())
      #     # add_custom_points(ts_points_data())
      #     # if (input$show_key_ts == TRUE){
      #     #   add_TS_key(input$key_position_ts,ts_highlights_data(),ts_lines_data(),input$variable_selected,month_range_primary(),
      #     #              input$custom_average_ts,input$year_moving_ts,input$custom_percentile_ts,input$percentile_ts,NA,NA,TRUE)
      #     # }
      #   } 
      #   # Plot monthly TS if year range = 1 year
      #   else {
      #     plot_monthly_timeseries(timeseries_data(),plot_titles()$ts_title,"Custom","topright","base")
      #     # add_highlighted_areas(ts_highlights_data())
      #     # add_custom_lines(ts_lines_data())
      #     # plot_monthly_timeseries(timeseries_data(),plot_titles()$ts_title,"Custom","topright","lines")
      #     # add_boxes(ts_highlights_data())
      #     # add_custom_points(ts_points_data())
      #     # if (input$show_key_ts == TRUE){
      #     #   add_TS_key(input$key_position_ts,ts_highlights_data(),ts_lines_data(),input$variable_selected,month_range_primary(),
      #     #              input$custom_average_ts,input$year_moving_ts,input$custom_percentile_ts,input$percentile_ts,NA,NA,TRUE)
      #     # }
      #   }
      # }
      
      timeseries_plot_anom<- function(){
        
        #REMOVE
        
        # #Plot normal timeseries if year range is > 1 year
        # if (input$range_years[1] != input$range_years[2]){
        #   # Generate NA or reference mean
        #   if(input$show_ref_ts == TRUE){
        #     ref_ts = signif(mean(data_output3_primary()),3)
        #   } else {
        #     ref_ts = NA
        #   }
        #   p <- plot_default_timeseries(timeseries_data(),"general",input$variable_selected,plot_titles(),input$title_mode_ts,ref_ts)
        #   p <- add_percentiles(p, timeseries_data())
        # }
        # 
        # # Plot monthly TS if year range = 1 year
        # else {
        #   p <- plot_monthly_timeseries(timeseries_data(),plot_titles()$ts_title,"Custom","topright","base")
        # }
        # 
        # p <- add_timeseries_custom_features(p, ts_highlights_data(), ts_lines_data(), ts_points_data())
        # p <- add_timeseries(p, timeseries_data(), "general", input$variable_selected)
        # 
        # if (input$show_key_ts == TRUE){
        #   p <- add_TS_key(p, input$key_position_ts,ts_highlights_data(),ts_lines_data(),input$variable_selected,month_range_primary(),
        #                   input$custom_average_ts,input$year_moving_ts,input$custom_percentile_ts,input$percentile_ts,NA,NA,TRUE)
        # }
        
        #Plot normal timeseries if year range is > 1 year
        if (input$range_years[1] != input$range_years[2]){
          # Generate NA or reference mean
          ref_ts = signif(mean(data_output3_primary()),3)
          } else {
            ref_ts = NA
          }
        
        # New 
        p <- plot_timeseries(type="Anomaly", data=timeseries_data(), variable=input$variable_selected,
                             ref=ref_ts, year_range=input$range_years, month_range_1=month_range_primary(),
                             titles=plot_titles(), 
                             show_key=input$show_key_ts, key_position=input$key_position_ts, show_ref = input$show_ref_ts,
                             moving_ave=input$custom_average_ts, moving_ave_year=input$year_moving_ts, 
                             custom_percentile=input$custom_percentile_ts, percentiles=input$percentile_ts, 
                             highlights=ts_highlights_data(), lines=ts_lines_data(), points=ts_points_data())
        
        return(p)
      }
      
      output$timeseries <- renderPlot({timeseries_plot_anom()}, height = 400)
      
      ### ModE-RA sources ----
      
      # Set up values and functions for plotting
      fad_zoom  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      season_fad_short = reactive({
        switch(input$fad_season,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      fad_global_data = reactive({
        load_modera_source_data(input$fad_year, season_fad_short())
      })
      
      # Plot map 
      fad_plot = function(){plot_modera_sources(fad_global_data(),input$fad_year, season_fad_short(),fad_zoom())}
      
      output$fad_map <- renderPlot({
        fad_plot()
      })
      
      # Set up data function
      fad_data <- function() {
        fad_base_data = download_feedback_data(fad_global_data(), fad_zoom()[1:2], fad_zoom()[3:4])
        
        # Remove the last column
        fad_base_data = fad_base_data[ , -ncol(fad_base_data)]
        
        return(fad_base_data)
      }
      
      observeEvent(lonlat_vals()|input$fad_reset_zoom,{
        fad_zoom(lonlat_vals())
      })
      
      observeEvent(input$brush_fad,{
        brush = input$brush_fad
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
      
      
      ### Downloads ----
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
      
      output$download_map_data        <- downloadHandler(filename = function() {paste(plot_titles()$file_title, "-mapdata.", input$file_type_map_data, sep = "")},
                                                         content = function(file) {
                                                           if (input$file_type_map_data == "csv"){
                                                             map_data_new <- rewrite_maptable(map_data(), subset_lons_primary(), subset_lats_primary())
                                                             colnames(map_data_new) <- NULL
                                                             write.csv(map_data_new, file,
                                                                       row.names = FALSE)
                                                           } else if (input$file_type_map_data == "xlsx") {
                                                             write.xlsx(rewrite_maptable(map_data(), subset_lons_primary(), subset_lats_primary()), file,
                                                                        row.names = FALSE, col.names = FALSE)
                                                           } else if (input$file_type_map_data == "GeoTIFF") {
                                                             create_geotiff(map_data(), file)
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
      
      output$download_fad            <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season),"_",input$fad_year,".",input$file_type_fad, sep = "")},
                                                        content  = function(file) {
                                                          
                                                          mmd = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_fad_map_width, input$dimension[2], FALSE)
                                                          
                                                          if (input$file_type_fad == "png"){
                                                            png(file, width = mmd[3] , height = mmd[4], res = 400, bg = "transparent")  
                                                            print(fad_plot())
                                                            dev.off()
                                                          } else if (input$file_type_fad == "jpeg"){
                                                            jpeg(file, width = mmd[3] , height = mmd[4], res = 400, bg = "white") 
                                                            print(fad_plot()) 
                                                            dev.off()
                                                          } else {
                                                            pdf(file, width = mmd[3]/400 , height = mmd[4]/400, bg = "transparent") 
                                                            print(fad_plot())
                                                            dev.off()
                                                          }})
      
      output$download_fad_data       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season),"_",input$fad_year,"_data.",input$data_file_type_fad, sep = "")},
                                                        content  = function(file) {
                                                          if (input$data_file_type_fad == "csv"){
                                                            write.csv(fad_data(), file,
                                                                      row.names = FALSE)
                                                          } else {
                                                            write.xlsx(fad_data(), file,
                                                                       col.names = TRUE,
                                                                       row.names = FALSE)
                                                          }})
      
      output$download_netcdf             <- downloadHandler(filename = function() {paste(plot_titles()$netcdf_title, ".nc", sep = "")},
                                                            content  = function(file) {
                                                              netcdf_ID = sample(1:1000000,1)
                                                              generate_custom_netcdf (data_output4_primary(), "general",input$dataset_selected,netcdf_ID, input$variable_selected, input$netcdf_variables, "Anomaly", subset_lons_primary(), subset_lats_primary(), month_range_primary(), input$range_years, input$ref_period, NA)
                                                              file.copy(paste("user_ncdf/netcdf_",netcdf_ID,".nc", sep=""),file)
                                                              file.remove(paste("user_ncdf/netcdf_",netcdf_ID,".nc", sep=""))
                                                            })
      
    ## COMPOSITE Year range,load SD ratio data, plotting & downloads ---- 
    
      ### Year Range ----
      
      #Creating a year set for composite
      year_set_comp <- reactive({
        read_composite_data(input$range_years2, input$upload_file2$datapath, input$enter_upload2)
      })
      
      #List of custom anomaly years (from read Composite) as reference data
      year_set_comp_ref <- reactive({
        read_composite_data(input$range_years2a, input$upload_file2a$datapath, input$enter_upload2a)
      })
      
      ### SD Ratio data ----
      
      # Update SD ratio data when required
      observe({
        if((input$ref_map_mode2 == "SD Ratio")|(input$custom_statistic2 == "SD ratio")){
          if (input$nav1 == "tab2"){ # check current tab
            if (!identical(SDratio_data_id()[3:4],data_id_primary()[3:4])){ # check to see if currently loaded variable & month range are the same
              if (data_id_primary()[1] != 0) { # check for preprocessed SD ratio data
                new_data_id = data_id_primary()
                new_data_id[2] = 4 # change data ID to SD ratio
                
                SDratio_data(load_preprocessed_data(new_data_id)) # load new SD data
                SDratio_data_id(data_id_primary()) # update custom data ID
              }
              else{
                SDratio_data(load_ModE_data("SD Ratio",input$variable_selected2)) # load new SD data
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
      
      ### Plotting ----
      
      #Map customization (statistics and map titles)
      
      plot_titles_composites <- reactive({
        
        req(input$nav1 == "tab2") # Only run code if in the current tab
        
        my_title <- generate_titles(tab="composites", dataset=input$dataset_selected2, variable=input$variable_selected2, 
                                    mode=input$mode_selected2, map_title_mode=input$title_mode2,ts_title_mode=input$title_mode_ts2,
                                    month_range=month_range_primary(), year_range=input$range_years2, baseline_range=input$ref_period2, baseline_years_before=input$prior_years2,
                                    lon_range=lonlat_vals2()[1:2],lat_range=lonlat_vals2()[3:4],
                                    map_custom_title1=input$title1_input2, map_custom_title2=input$title2_input2, ts_custom_title1=input$title1_input_ts2, ts_custom_title2=NA, 
                                    map_title_size=input$title_size_input2, ts_data=timeseries_data_2())
        
        return(my_title)
      })
      
      
      map_statistics_2 = reactive({
        
        req(input$nav1 == "tab2") # Only run code if in the current tab
        
        my_stats = create_stat_highlights_data(data_output4_primary(),SDratio_subset_2(),
                                               input$custom_statistic2,input$sd_ratio2,
                                               input$percentage_sign_match2,
                                               subset_lons_primary(),subset_lats_primary())
        
        return(my_stats)
      })
      
      #Plotting the Data (Maps)
      map_data_2 <- function(){create_map_datatable(data_output4_primary(), subset_lons_primary(), subset_lats_primary())}
      
      output$data3 <- renderTable({map_data_2()},
                                  rownames = TRUE)
      
      #Plotting the Map
      map_dimensions_2 <- reactive({
        
        req(input$nav1 == "tab2") # Only run code if in the current tab
        
        m_d_2 = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_map2_width, input$dimension[2]*0.85, input$hide_axis2)
        
        return(m_d_2)
      })
      
      map_plot_2 <- function(){plot_map(create_geotiff(map_data_2()),
                                        lonlat_vals2(),
                                        input$variable_selected2,
                                        input$mode_selected2,
                                        plot_titles_composites(),
                                        input$axis_input2,
                                        input$hide_axis2,
                                        map_points_data2(),
                                        map_highlights_data2(),
                                        map_statistics_2(),
                                        input$hide_borders2,
                                        input$white_ocean2,
                                        input$white_land2,
                                        plotOrder2(),
                                        input$shpPickers2,
                                        input, "shp_colour2_",
                                        input$projection2,
                                        input$center_lat2,
                                        input$center_lon2)}
      
      output$map2 <- renderPlot({map_plot_2()},width = function(){map_dimensions_2()[1]},height = function(){map_dimensions_2()[2]})
      # code line below sets height as a function of the ratio of lat/lon 
      
      
      #Ref/Absolute Map
      ref_map_data_2 <- function(){
        if (input$ref_map_mode2 == "Absolute Values"){
          create_map_datatable(data_output2_primary(), subset_lons_primary(), subset_lats_primary())
        } else if (input$ref_map_mode2 == "Reference Values"){
          create_map_datatable(data_output3_primary(), subset_lons_primary(), subset_lats_primary())
        } else if (input$ref_map_mode2 == "SD Ratio"){
          create_map_datatable(SDratio_subset_2(), subset_lons_primary(), subset_lats_primary())
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
          tab=params$type, dataset=input$dataset_selected2, variable=input$variable_selected2, mode="Absolute", 
          map_title_mode=input$title_mode2, ts_title_mode=input$title_mode_ts2, 
          month_range=month_range_primary(), year_range=params$years, 
          lon_range=lonlat_vals2()[1:2], lat_range=lonlat_vals2()[3:4], 
          map_custom_title1=input$title1_input2, map_custom_title2=input$title2_input2, ts_custom_title1=input$title1_input_ts2, 
          map_title_size=input$title_size_input2
        )
      })  
      
      ref_map_plot_2 <- function(){
        if (input$ref_map_mode2 == "Absolute Values" | input$ref_map_mode2 == "Reference Values" ){
          v=input$variable_selected2; m="Absolute"; axis_range=NULL
          
        } else if (input$ref_map_mode2 == "SD Ratio"){
          v=NULL; m="SD Ratio"; axis_range=c(0,1)
        }
        plot_map(data_input=create_geotiff(ref_map_data_2()),
                 lonlat_vals2(),
                 variable=v,
                 mode=m,
                 titles=ref_map_titles_2(),
                 axis_range, 
                 c_borders=input$hide_borders2,
                 white_ocean=input$white_ocean2,
                 white_land=input$white_land2, 
                 plotOrder=plotOrder2(),
                 shpPickers=input$shpPickers2,
                 input=input,
                 plotType="shp_colour2_", 
                 projection=input$projection2,
                 center_lat=input$center_lat2,
                 center_lon=input$center_lon2)
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
        if (length(year_set_comp()) > 1){    
          ts_data1 <- create_timeseries_datatable(data_output4_primary(), year_set_comp(), "set", subset_lons_primary(), subset_lats_primary())
          
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
        
        req(input$nav1 == "tab2") # Only run code if in the current tab
        
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
      timeseries_plot_comp <- function(){
        #Plot normal timeseries if year set is > 1 year
        #if (length(year_set_comp()) > 1){  
          # Generate NA or reference mean
          if(input$show_ref_ts2 == TRUE){
            ref_ts2 = signif(mean(data_output3_primary()),3)
          } else {
            ref_ts2 = NA
          }
          
        #   plot_default_timeseries(timeseries_data_2(),"composites",input$variable_selected2,plot_titles_composites(),input$title_mode_ts2,ref_ts2)
        #   add_highlighted_areas(ts_highlights_data2())
        #   add_percentiles(timeseries_data_2())
        #   add_custom_lines(ts_lines_data2())
        #   add_timeseries(timeseries_data_2(),"composites",input$variable_selected2)
        #   add_boxes(ts_highlights_data2())
        #   add_custom_points(ts_points_data2())
        #   if (input$show_key_ts2 == TRUE){
        #     add_TS_key(input$key_position_ts2,ts_highlights_data2(),ts_lines_data2(),input$variable_selected2,month_range_primary(),
        #                FALSE,NA,input$custom_percentile_ts2,input$percentile_ts2,NA,NA,TRUE)
        #   }
        # }
        # # Plot monthly TS if year range = 1 year
        # else {
        #   plot_monthly_timeseries(timeseries_data_2(),plot_titles_composites()$ts_title,"Custom","topright","base")
        #   add_highlighted_areas(ts_highlights_data2())
        #   add_custom_lines(ts_lines_data2())
        #   plot_monthly_timeseries(timeseries_data_2(),plot_titles_composites()$ts_title,"Custom","topright","lines")
        #   add_boxes(ts_highlights_data2())
        #   add_custom_points(ts_points_data2())
        #   if (input$show_key_ts2 == TRUE){
        #     add_TS_key(input$key_position_ts2,ts_highlights_data2(),ts_lines_data2(),input$variable_selected2,month_range_primary(),
        #                FALSE,NA,input$custom_percentile_ts2,input$percentile_ts2,NA,NA,TRUE)
        #   }
        # }
          
          # New 
          p <- plot_timeseries(type="Composites", data=timeseries_data_2(), variable=input$variable_selected2,
                               ref=ref_ts2, year_range=year_set_comp(), month_range_1=month_range_primary(),
                               titles=plot_titles_composites(), #titles_mode=input$title_mode_ts2, 
                               show_key=input$show_key_ts2, key_position=input$key_position_ts2, show_ref = input$show_ref_ts2, 
                               custom_percentile=input$custom_percentile_ts2, percentiles=input$percentile_ts2, 
                               highlights=ts_highlights_data2(), lines=ts_lines_data2(), points=ts_points_data2())
          
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
      
      ### ModE-RA sources ----
      
      # Set up values and functions for plotting
      fad_zoom2  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      season_fad_short2 = reactive({
        switch(input$fad_season2,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      fad_global_data2 = reactive({
        load_modera_source_data(input$fad_year2, season_fad_short2())
      })
      
      # Plot map 
      fad_plot2 = function(){plot_modera_sources(fad_global_data2(),input$fad_year2, season_fad_short2(),fad_zoom2())}
      
      output$fad_map2 <- renderPlot({fad_plot2()})
      
      # Set up data function
      fad_data2 <- function() {
        
        fad_base_data2 = download_feedback_data(fad_global_data2(), fad_zoom2()[1:2], fad_zoom2()[3:4])
        
        # Remove the last column
        fad_base_data2 = fad_base_data2[ , -ncol(fad_base_data2)]
        
        return(fad_base_data2)
      }
      
      observeEvent(lonlat_vals2()|input$fad_reset_zoom2,{
        fad_zoom2(lonlat_vals2())
      })
      
      observeEvent(input$brush_fad2,{
        brush = input$brush_fad2
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
      
      ### Downloads ----
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
      
      output$download_timeseries2      <- downloadHandler(filename = function(){paste(plot_titles_composites()$file_title,"-ts.",input$file_type_timeseries2, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_timeseries2 == "png"){
                                                              png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                            } else if (input$file_type_timeseries2 == "jpeg"){
                                                              jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                            } else {
                                                              pdf(file, width = 14, height = 6, bg = "transparent") 
                                                            }
                                                            timeseries_plot_comp()
                                                            dev.off()
                                                            }) 
      
      output$download_map_data2        <- downloadHandler(filename = function(){paste(plot_titles_composites()$file_title, "-mapdata.",input$file_type_map_data2, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_map_data2 == "csv"){
                                                              map_data_new_2 <- rewrite_maptable(map_data_2(), subset_lons_primary(), subset_lats_primary())
                                                              colnames(map_data_new_2) <- NULL
                                                              write.csv(map_data_new_2, file,
                                                                        row.names = FALSE)
                                                            } else if (input$file_type_map_data2 == "xlsx") {
                                                              write.xlsx(rewrite_maptable(map_data(), subset_lons_primary(), subset_lats_primary()), file,
                                                                         row.names = FALSE, col.names = FALSE)
                                                            } else if (input$file_type_map_data2 == "GeoTIFF") {
                                                              create_geotiff(map_data(), file)
                                                            }})
      
      output$download_timeseries_data2  <- downloadHandler(filename = function(){paste(plot_titles_composites()$file_title, "-tsdata.",input$file_type_timeseries_data2, sep = "")},
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
      
      output$download_fad2            <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season2),"_",input$fad_year2,".",input$file_type_fad2, sep = "")},
                                                         content  = function(file) {
                                                           
                                                           mmd = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_fad_map2_width, input$dimension[2], FALSE)
                                                           
                                                           if (input$file_type_fad2 == "png"){
                                                             png(file, width = mmd[3] , height = mmd[4], res = 400, bg = "transparent")  
                                                             print(fad_plot2())
                                                             dev.off()
                                                           } else if (input$file_type_fad2 == "jpeg"){
                                                             jpeg(file, width = mmd[3] , height = mmd[4], res = 400, bg = "white") 
                                                             print(fad_plot2()) 
                                                             dev.off()
                                                           } else {
                                                             pdf(file, width = mmd[3]/400 , height = mmd[4]/400, bg = "transparent") 
                                                             print(fad_plot2())
                                                             dev.off()
                                                           }})
      
      output$download_fad_data2       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season2),"_",input$fad_year2,"_data.",input$data_file_type_fad2, sep = "")},
                                                         content  = function(file) {
                                                           if (input$data_file_type_fad2 == "csv"){
                                                             write.csv(fad_data2(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_data2(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})
      
    ## CORRELATION shared lonlat/year range, user data, plotting & downloads ----
    
      ### Shared lonlat/year_range ----
      
      # Find shared lonlat
      
      lonlat_vals3 = reactive({
        extract_shared_lonlat(input$type_v1,input$type_v2,input$range_longitude_v1,
                              input$range_latitude_v1,input$range_longitude_v2,
                              input$range_latitude_v2)
      })
      
      # Extract shared year range
      
      year_range_cor = reactive({
        
        result <- tryCatch(
          {
            return(extract_year_range(input$source_v1,input$source_v2,input$user_file_v1$datapath,input$user_file_v2$datapath,input$lagyears_v1_cor,input$lagyears_v2_cor))
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
      
      
      ### User data processing ----
      
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
        year_range_cor = reactive({
          
          result <- tryCatch(
            {
              return(extract_year_range(input$source_v1,input$source_v2,input$user_file_v1$datapath,input$user_file_v2$datapath))
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
        
        usr_ss1 = create_user_data_subset(user_data_v1(),input$user_variable_v1,input$range_years3, lag=input$lagyears_v1_cor)
        
        return(usr_ss1)
      })
      
      # Subset v2 data to year_range and chosen variable
      user_subset_v2 = reactive({
        
        req(user_data_v2(),input$user_variable_v2)
        
        usr_ss2 = create_user_data_subset(user_data_v2(),input$user_variable_v2,input$range_years3, lag=input$lagyears_v1_cor)
        
        return(usr_ss2)
      })
      
      ### Generate plot data ---- 
      
      #Map titles
      plot_titles_v1 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        my_title_v1 <- generate_titles(tab="general", dataset=input$dataset_selected_v1, variable=input$ME_variable_v1, mode=input$mode_selected_v1,
                                      map_title_mode="Default", ts_title_mode="Default",
                                      month_range=month_range_primary(), year_range=input$range_years3, baseline_range=input$ref_period_v1,
                                      lon_range=lonlat_vals_v1()[1:2], lat_range=lonlat_vals_v1()[3:4])
        return(my_title_v1)
      }) 
      
      # Generate Map data & plotting function
      map_data_v1 <- function(){create_map_datatable(data_output4_primary(), subset_lons_primary(), subset_lats_primary())}
      
      ME_map_plot_v1 <- function(){plot_map(data_input=create_geotiff(map_data_v1()), lon_lat_range=lonlat_vals_v1(), variable=input$ME_variable_v1, mode=input$mode_selected_v1, 
                                            titles=plot_titles_v1())}
      
      # Generate timeseries data & plotting function
      timeseries_data_v1 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        ts_data1_v1 <- create_timeseries_datatable(data_output4_primary(), input$range_years3, "range", subset_lons_primary(), subset_lats_primary())
        return(ts_data1_v1)
      })
      
      timeseries_plot_v1 = function(){
        p <- plot_timeseries(type="Anomaly", data=timeseries_data_v1(), variable=input$ME_variable_v1,
                                     ref=NULL, year_range=input$range_years3, month_range_1=month_range_primary(),
                                     titles=plot_titles_v1(), show_key=FALSE, show_ref = FALSE,
                                     moving_ave=FALSE,custom_percentile=FALSE,
                                     highlights=data.frame(), lines=data.frame(), points=data.frame())

        return(p)
      }
      
      # for Variable 2:
      
      #Map titles
      plot_titles_v2 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        my_title_v2 <- generate_titles ("general", input$dataset_selected_v2,input$ME_variable_v2, input$mode_selected_v2,
                                        map_title_mode="Default", ts_title_mode="Default", month_range=month_range_secondary(),
                                        year_range=input$range_years3, baseline_range=input$ref_period_v2,
                                        lon_range=lonlat_vals_v2()[1:2], lat_range=lonlat_vals_v2()[3:4])
        return(my_title_v2)
      }) 
      
      # Generate Map data & plotting function
      map_data_v2 <- function(){
        req(data_output4_secondary(), subset_lons_secondary(), subset_lats_secondary())
        create_map_datatable(data_output4_secondary(), subset_lons_secondary(), subset_lats_secondary())}
      
      map_data_v2_tiff = reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        create_geotiff(map_data_v2())
      })
      
      ME_map_plot_v2 <- function(){plot_map(data_input=map_data_v2_tiff(), lon_lat_range=lonlat_vals_v2(), variable=input$ME_variable_v2, mode = input$mode_selected_v2, 
                                            titles=plot_titles_v2())}
      
      # Generate timeseries data & plotting function
      timeseries_data_v2 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        ts_data1_v2 <- create_timeseries_datatable(data_output4_secondary(), input$range_years3, "range", subset_lons_secondary(), subset_lats_secondary())
        return(ts_data1_v2)
      })
      
      #REMOVE
      #timeseries_plot_v2 = function(){plot_default_timeseries(,"general",input$ME_variable_v2,plot_titles_v2(),"Default",NA)}
      timeseries_plot_v2 = function(){
        p <- plot_timeseries(type="Anomaly", data=timeseries_data_v2(), variable=input$ME_variable_v2,
                             ref=NULL, year_range=input$range_years3, month_range_2=month_range_secondary(),
                             titles=plot_titles_v2(), show_key=FALSE, show_ref = FALSE,
                             moving_ave=FALSE,custom_percentile=FALSE,
                             highlights=data.frame(), lines=data.frame(), points=data.frame())
        return(p)
      }
      
      ### Plotting ----
      
      #### Plot v1/v2 plots
      
      # Generate plot dimensions
      plot_dimensions_v1 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        if (input$type_v1 == "Timeseries"){
          map_dims_v1 = c(session$clientData$output_plot_v1_width,400)
        } else {
          map_dims_v1 = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_plot_v1_width, (input$dimension[2]), FALSE)
        }
        return(map_dims_v1)  
      })
      
      plot_dimensions_v2 <- reactive({
        req(input$nav1 == "tab3") # Only run code if in the current tab
        if (input$type_v2 == "Timeseries"){
          map_dims_v2 = c(session$clientData$output_plot_v2_width,400)
        } else {
          map_dims_v2 = generate_map_dimensions(subset_lons_secondary(), subset_lats_secondary(), session$clientData$output_plot_v2_width, (input$dimension[2]), FALSE)
        }
        return(map_dims_v2)  
      })     
      
      # Plot 
      output$plot_v1 <- renderPlot({
        if (input$source_v1 == "User Data"){
          plot_user_timeseries(user_subset_v1(),"darkorange2")
        } else if (input$type_v1 == "Timeseries"){
          timeseries_plot_v1()
        } else{
          ME_map_plot_v1()
        }
      },width = function(){plot_dimensions_v1()[1]},height = function(){plot_dimensions_v1()[2]})  
      
      
      output$plot_v2 <- renderPlot({
        if (input$source_v2 == "User Data"){
          plot_user_timeseries(user_subset_v2(),"saddlebrown")
        } else if (input$type_v2 == "Timeseries"){
          timeseries_plot_v2()
        } else{
          ME_map_plot_v2()
        }
      },width = function(){plot_dimensions_v2()[1]},height = function(){plot_dimensions_v2()[2]})  
      
      
      #### Plot shared TS plot
      
      # Generate correlation titles
      plot_titles_cor = reactive({
        
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
        
        ptc = generate_correlation_titles(input$source_v1,input$source_v2,input$dataset_selected_v1,
                                          input$dataset_selected_v2,variable_v1,variable_v2,
                                          input$type_v1,input$type_v2,input$mode_selected_v1,input$mode_selected_v2,
                                          month_range_primary(),month_range_secondary(),lonlat_vals_v1()[1:2],lonlat_vals_v2()[1:2],
                                          lonlat_vals_v1()[3:4],lonlat_vals_v2()[3:4],input$range_years3,input$cor_method_ts,
                                          input$title_mode3,input$title_mode_ts3,input$title1_input3, input$title2_input3, input$title1_input_ts3, input$title_size_input3)
        return(ptc)
      }) 
      
      # Select variable timeseries data
      ts_data_v1 = reactive({
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
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
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
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
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
        c_st = correlate_timeseries(ts_data_v1(),ts_data_v2(),input$cor_method_ts)
        
        return(c_st)
      })
      
      # Plot
      output$correlation_r_value = renderText({paste("Timeseries correlation coefficient: r =",signif(correlation_stats()$estimate,digits =3), sep = "")})
      output$correlation_p_value = renderText({paste("Timeseries correlation p-value: p =",signif(correlation_stats()$p.value,digits =3), sep = "")})    
      
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
        
        plot_timeseries(type="Correlation", data_v1=ts_data_v1(), data_v2=ts_data_v2(), 
                        variable1=variable_v1, variable2=variable_v2,year_range=input$range_years3,
                        month_range_1=month_range_primary(), month_range_2=month_range_secondary(),
                        titles=plot_titles_cor(),
                        show_key=input$show_key_ts3, key_position=input$key_position_ts3, 
                        moving_ave=input$custom_average_ts3, moving_ave_year=input$year_moving_ts3, 
                        highlights=ts_highlights_data3(), lines=ts_lines_data3(), points=ts_points_data3())
        
      }
      
      output$correlation_ts = renderPlot({timeseries_plot_corr()}, height = 400)
      
      #### Correlation Scatter Plot
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
      
      #### Plot correlation map
      
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
        
        corrmd = generate_correlation_map_data(correlation_map_data_v1(),correlation_map_data_v2(),input$cor_method_map,
                                               input$type_v1,input$type_v2,lonlat_vals_v1()[1:2],lonlat_vals_v2()[1:2],
                                               lonlat_vals_v1()[3:4],lonlat_vals_v2()[3:4])
        return(corrmd)
      })
      
      # Generate plot dimensions
      correlation_map_dimensions <- reactive({
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
        c_m_d = generate_map_dimensions(correlation_map_data()[[1]], correlation_map_data()[[2]], session$clientData$output_correlation_map_width, input$dimension[2], FALSE)
        
        return(c_m_d)
      })
      
      # Geotiff of correlation map data
      correlation_map_data_tiff = reactive({
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
        create_geotiff(generate_correlation_map_datatable(correlation_map_data()))
      })
      
      # Plot
      corr_m1 = function(){
        if ((input$type_v1 == "Field") | (input$type_v2 == "Field")){
          if(input$type_v1 == "Field"){
            lonlat_vals = lonlat_vals_v1()
          } else {
            lonlat_vals = lonlat_vals_v2()
          }
          plot_map(data_input=correlation_map_data_tiff(), lon_lat_range=lonlat_vals,  mode="Correlation", 
                   titles=plot_titles_cor(),axis_range=input$axis_input3, hide_axis=input$hide_axis3, 
                   points_data=map_points_data3(), highlights_data=map_highlights_data3(),
                   c_borders=input$hide_borders3, white_ocean=input$white_ocean3, white_land=input$white_land3, 
                   plotOrder=plotOrder3(), shpPickers=input$shpPickers3)
        }
      }
      
      output$correlation_map = renderPlot({corr_m1()},width = function(){correlation_map_dimensions()[1]},height = function(){correlation_map_dimensions()[2]})
      
      #### Data tables & Downloads 
      
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
        
        req(input$nav1 == "tab3") # Only run code if in the current tab
        
        corrmada = generate_correlation_map_datatable(correlation_map_data())
        
        return(corrmada)
      })
      
      output$correlation_map_data <- renderTable({correlation_map_datatable()}, rownames = TRUE)
      
      ### ModE-RA sources ----
      
      # Set up values and functions for plotting
      fad_zoom3  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      season_fad_short3 = reactive({
        switch(input$fad_season3,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      fad_global_data3 = reactive({
        load_modera_source_data(input$fad_year3, season_fad_short3())
      })
      
      # Plot map 
      fad_plot3 = function(){plot_modera_sources(fad_global_data3(),input$fad_year3, season_fad_short3(),fad_zoom3())}
      
      output$fad_map3 <- renderPlot({fad_plot3()})
      
      # Set up data function
      fad_data3 <- function() {
        
        fad_base_data3 = download_feedback_data(fad_global_data3(), fad_zoom3()[1:2], fad_zoom3()[3:4])
        
        # Remove the last column
        fad_base_data3 = fad_base_data3[ , -ncol(fad_base_data3)]
        
        return(fad_base_data3)
        
      }
      
      observeEvent(lonlat_vals3()|input$fad_reset_zoom3,{
        fad_zoom3(lonlat_vals3())
      })
      
      observeEvent(input$brush_fad3,{
        brush = input$brush_fad3
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
      
      ### Downloads ----
      # Downloads
      
      output$download_timeseries3      <- downloadHandler(filename = function(){paste(plot_titles_cor()$Download_title,"-ts.",input$file_type_timeseries3, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_timeseries3 == "png"){
                                                              png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                            } else if (input$file_type_timeseries3 == "jpeg"){
                                                              jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                            } else {
                                                              pdf(file, width = 14, height = 6, bg = "transparent") 
                                                            }
                                                            timeseries_plot_corr()
                                                            dev.off()
                                                            })
      
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
      
      output$download_map3              <- downloadHandler(filename = function() {paste(plot_titles_cor()$Download_title, "-map.", input$file_type_map3, sep = "")},
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
                                                            } else if (input$file_type_map_data3 == "xlsx") {
                                                              write.xlsx(rewrite_maptable(map_data(), subset_lons_primary(), subset_lats_primary()), file,
                                                                         row.names = FALSE, col.names = FALSE)
                                                            } else if (input$file_type_map_data3 == "GeoTIFF") {
                                                              create_geotiff(map_data(), file)
                                                            }})
      
      output$download_fad3            <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season3),"_",input$fad_year3,".",input$file_type_fad3, sep = "")},
                                                         content  = function(file) {
                                                           
                                                           mmd = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_fad_map3_width, input$dimension[2], FALSE)
                                                           
                                                           if (input$file_type_fad3 == "png"){
                                                             png(file, width = mmd[3] , height = mmd[4], res = 400, bg = "transparent")  
                                                             print(fad_plot3())
                                                             dev.off()
                                                           } else if (input$file_type_fad3 == "jpeg"){
                                                             jpeg(file, width = mmd[3] , height = mmd[4], res = 400, bg = "white") 
                                                             print(fad_plot3()) 
                                                             dev.off()
                                                           } else {
                                                             pdf(file, width = mmd[3]/400 , height = mmd[4]/400, bg = "transparent") 
                                                             print(fad_plot3())
                                                             dev.off()
                                                           }})
      
      output$download_fad_data3       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season3),"_",input$fad_year3,"_data.",input$data_file_type_fad3, sep = "")},
                                                         content  = function(file) {
                                                           if (input$data_file_type_fad3 == "csv"){
                                                             write.csv(fad_data3(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_data3(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})
      
      
    ## REGRESSION year range, user data, plotting & downloads ----
    
      ### User data processing ----
      
      # Extract Shared year range
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
        
        usr_ss1 = create_user_data_subset(user_data_iv(),input$user_variable_iv,input$range_years4)
        
        return(usr_ss1)
      }) 
      
      # Subset dv data to year_range and chosen variable
      user_subset_dv = reactive({
        
        req(user_data_dv(),input$user_variable_dv)
        
        usr_ss2 = create_user_data_subset(user_data_dv(),input$user_variable_dv,input$range_years4)
        
        return(usr_ss2)
      }) 
      
      ### Prep plotting data ----
      
      #Map titles
      plot_titles_dv <- reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        my_title_dv <- generate_titles ("general",input$dataset_selected_dv, input$ME_variable_dv, input$mode_selected_dv,
                                        "Default","Default", month_range_primary(),input$range_years4,
                                        input$ref_period_dv, NA,lonlat_vals_dv()[1:2],lonlat_vals_dv()[3:4],
                                        NA, NA, NA)
        return(my_title_dv)
      }) 
      
      plot_titles_iv <- reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        my_title_iv <- generate_titles ("general",input$dataset_selected_iv, input$ME_variable_iv[1], input$mode_selected_iv,
                                        "Default","Default", month_range_secondary(),input$range_years4,
                                        input$ref_period_iv, NA,lonlat_vals_iv()[1:2],lonlat_vals_iv()[3:4],
                                        NA, NA, NA)
        return(my_title_iv)
      }) 
      
      # Generate Map data & plotting function for dv
      map_data_dv <- function(){
        req(data_output4_primary(), subset_lons_primary(), subset_lats_primary())
        create_map_datatable(data_output4_primary(), subset_lons_primary(), subset_lats_primary())}
      
      ME_map_plot_dv <- function(){plot_map(data_input=create_geotiff(map_data_dv()), lon_lat_range=lonlat_vals_dv(),
                                            variable=input$ME_variable_dv, mode=input$mode_selected_dv, titles=plot_titles_dv())}
      
      # Generate timeseries data & plotting function for iv
      ME_ts_data_iv <- reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        req(subset_lons_secondary(),subset_lats_secondary(),month_range_secondary())
        
        me_tsd_iv = create_ME_timeseries_data(input$dataset_selected_dv,input$ME_variable_iv,subset_lons_secondary(),subset_lats_secondary(),
                                              input$mode_selected_iv,month_range_secondary(),input$range_years4,
                                              input$ref_period_iv)
        return(me_tsd_iv)
      })
      
      #REMOVE
      #_iv = function(){plot_default_timeseries(,"general",input$ME_variable_iv[1],,"Default",NA)}
      timeseries_plot_iv = function(){
        p <- plot_timeseries(type="Anomaly", data=ME_ts_data_iv(), variable=input$ME_variable_iv[1],
                             ref = NULL,year_range=input$range_years4, month_range_1=month_range_primary(),
                             titles=plot_titles_iv(), show_key=FALSE, show_ref = FALSE,
                             moving_ave=FALSE,custom_percentile=FALSE,
                             highlights=data.frame(), lines=data.frame(), points=data.frame())
        return(p)
      }
      
      # Generate Timeseries data for dv
      timeseries_data_dv <- reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        ts_data1_dv <- create_timeseries_datatable(data_output4_primary(), input$range_years4, "range", subset_lons_primary(), subset_lats_primary())
        return(ts_data1_dv)
      })
      
      #timeseries_plot_dv = function(){plot_default_timeseries(timeseries_data_dv(),"general",input$ME_variable_dv,plot_titles_dv(),"Default")}
      
      
      ### Plotting initial IV/DV ----
      
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
          map_dims_dv = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_plot_dv_width, (input$dimension[2]), FALSE)
        }
        return(map_dims_dv)  
      })
      
      # Plot 
      output$plot_iv <- renderPlot({
        if (input$source_iv == "User Data"){
          plot_user_timeseries(user_subset_iv(),"darkorange2")
        } else {
          timeseries_plot_iv()
        } 
      },height = 400)  
      
      output$plot_dv <- renderPlot({
        if (input$source_dv == "User Data"){
          plot_user_timeseries(user_subset_dv(),"saddlebrown")
        } else{
          ME_map_plot_dv()
        }
      },width = function(){plot_dimensions_dv()[1]},height = function(){plot_dimensions_dv()[2]})  
      
      ### Regression plots ----
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
      
      # Map Points
      observeEvent(input$add_point, {
        map_points_data_reg(rbind(map_points_data(),
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
      
      # Generate regression titles    
      plot_titles_reg = reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        req(month_range_secondary(),month_range_primary())
        
        ptr = generate_regression_titles(input$source_iv,input$source_dv,
                                         input$dataset_selected_iv,input$dataset_selected_dv,
                                         input$ME_variable_dv,
                                         input$mode_selected_iv, input$mode_selected_dv,
                                         month_range_secondary(),month_range_primary(),
                                         lonlat_vals_iv()[1:2],lonlat_vals_dv()[1:2],lonlat_vals_iv()[3:4],lonlat_vals_dv()[3:4],
                                         input$range_years4, reg_resi_year_val(),
                                         variables_iv(), variable_dv(), 
                                         match(input$coeff_variable,variables_iv()), match(input$pvalue_variable,variables_iv()),
                                         input$title_mode_reg,
                                         input$title1_input_reg,
                                         input$title2_input_reg,
                                         input$title_size_input_reg
        )
        return(ptr)
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
        
        p_d_r = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_plot_dv_width, input$dimension[2], FALSE)
        
        return(p_d_r)
      })
      
      ## Regression timeseries plot
      
      regression_ts_data = reactive({
        req(input$nav1 == "tab4") # Only run code if in the current tab
        rtsd = create_regression_timeseries_datatable(ts_data_dv(),regression_summary_data(),
                                                      plot_titles_reg())
        return(rtsd)
      })
      
      timeseries_plot_reg1 = function(){
        plot_timeseries(type="Regression_Trend", data=regression_ts_data(),ref=NULL,
                        year_range=input$range_years4, titles=plot_titles_reg(),
                        show_key=TRUE, key_position="right", show_ref = FALSE,
                        moving_ave=FALSE,custom_percentile=FALSE,
                        highlights=data.frame(), lines=data.frame(), points=data.frame())
      }
      
      output$plot_reg_ts1 = renderPlot({timeseries_plot_reg1()},height=400)
      
      timeseries_plot_reg2 = function(){
        plot_timeseries(type="Regression_Residual", data=regression_ts_data(),ref=NULL,
                        year_range=input$range_years4, titles=plot_titles_reg(),
                        show_key=TRUE, key_position="right", show_ref = FALSE,
                        moving_ave=FALSE,custom_percentile=FALSE,
                        highlights=data.frame(), lines=data.frame(), points=data.frame())
      }
      
      output$plot_reg_ts2 = renderPlot({timeseries_plot_reg2()},height=400)
      
      output$data_reg_ts= renderDataTable({regression_ts_data()}, rownames = FALSE, options = list(
        autoWidth = TRUE, 
        searching = FALSE,
        paging = TRUE,
        pagingType = "numbers"
      ))
      
      ## Regression Summary data 
      
      regression_summary_data = reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        rsd = create_regression_summary_data(ts_data_iv(),ts_data_dv(),variables_iv())
        
        return(rsd)
      })
      
      reg_sd = function(){
        req(regression_summary_data())
        summary(regression_summary_data())}
      
      output$regression_summary_data = renderPrint({reg_sd()})  
      
      ## Regression coefficient plot
      
      regression_coeff_data = reactive({
        
        req(input$nav1 == "tab4") # Only run code if in the current tab
        
        reg_cd = create_regression_coeff_data(ts_data_iv(), data_output4_primary(), variables_iv())
        
        return(reg_cd)
      })
      
      reg_coef_tiff = reactive({
        req(input$nav1 == "tab4") # Only run code if in the current tab
        create_geotiff(reg_coef_table()) 
      })
      
      reg_coef_map = function(){
        req(input$coeff_variable)
        plot_map(data_input=reg_coef_tiff(), lon_lat_range=lonlat_vals_dv(), variable=input$coeff_variable, mode="Regression_coefficients", titles=plot_titles_reg())
      }
      
      output$plot_reg_coeff = renderPlot({reg_coef_map()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
      
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
      
      
      
      ## Regression pvalue plot
      
      regression_pvalue_data = reactive({
        req(input$nav1 == "tab4") # Only run code if in the current tab
        rpvd = create_regression_pvalue_data(ts_data_iv(), data_output4_primary(), variables_iv())
        return(rpvd)
      })
      
      reg_pval_tiff = reactive({
        req(input$nav1 == "tab4") # Only run code if in the current tab
        create_geotiff(reg_pval_table()) 
      })
      
      reg_pval_map = function(){
        req(input$pvalue_variable)
        plot_map(data_input=reg_pval_tiff(),lon_lat_range=lonlat_vals_dv(),variable=input$pvalue_variable, mode="Regression_p_values", titles=plot_titles_reg())
      }
      
      output$plot_reg_pval = renderPlot({reg_pval_map()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
      
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
      
      
      
      ## Regression residuals plot
      
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
          
          titles = plot_titles_reg(),
          
          axis_range = input$axis_input_reg,
          hide_axis = input$hide_axis_reg,
          
          # points_data = map_points_data_reg()
          # highlights_data = map_highlights_data_reg(),
          
          c_borders = input$hide_borders_reg,
          white_ocean = input$white_ocean_reg,
          white_land = input$white_land_reg
          
          # plotOrder = input$plotOrder_reg,
          # shpPickers = input$shpPickers_reg,
          # input = input,
          # plotType = input$plotType_reg,
          # projection = input$projection_reg,
          # center_lat = input$center_lat_reg,
          # center_lon = input$center_lon_reg
        )
      }
      
      output$plot_reg_resi = renderPlot({reg_res_map()},width = function(){plot_dimensions_reg()[1]},height = function(){plot_dimensions_reg()[2]})
      
      reg_res_table = function(){
        # Find ID of year selected
        year_ID = (reg_resi_year_val()-input$range_years4[1])+1
        rrd1 = regression_residuals_data()[year_ID,,]
        # Transform and add rownames to data
        rrd2 = create_regression_map_datatable(rrd1,subset_lons_primary(),subset_lats_primary())
      }
      
      output$data_reg_res = renderTable({reg_res_table()},rownames = TRUE)
      
      ### ModE-RA sources ----
      
      # Set up values and functions for plotting
      fad_zoom4  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      season_fad_short4 = reactive({
        switch(input$fad_season4,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      fad_global_data4 = reactive({
        load_modera_source_data(input$fad_year4, season_fad_short4())
      })
      
      # Plot map 
      fad_plot4 = function(){plot_modera_sources(fad_global_data4(),input$fad_year4, season_fad_short4(),fad_zoom4())}
      
      output$fad_map4 <- renderPlot({fad_plot4()})
      
      # Set up data function
      fad_data4 <- function() {
        
        fad_base_data4 = download_feedback_data(fad_global_data4(), fad_zoom4()[1:2], fad_zoom4()[3:4])
        
        # Remove the last column
        fad_base_data4 = fad_base_data4[ , -ncol(fad_base_data4)]
        
        return(fad_base_data4)
        
      }
      
      observeEvent(lonlat_vals_dv()|input$fad_reset_zoom4,{
        fad_zoom4(lonlat_vals_dv())
      })
      
      observeEvent(input$brush_fad4,{
        brush = input$brush_fad4
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
      
      ### Downloads ----
      
      output$download_reg_ts_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-ts.",input$reg_ts_plot_type, sep = "")},
                                                          content  = function(file) {
                                                            if (input$reg_ts_plot_type == "png"){
                                                              png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                            } else if (input$reg_ts_plot_type == "jpeg"){
                                                              jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                            } else {
                                                              pdf(file, width = 14, height = 6, bg = "transparent") 
                                                            }                                                          
                                                            timeseries_plot_reg1()
                                                            dev.off()
                                                            })
      
      output$download_reg_ts2_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-ts.",input$reg_ts2_plot_type, sep = "")},
                                                           content  = function(file) {
                                                             if (input$reg_ts2_plot_type == "png"){
                                                               png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                             } else if (input$reg_ts2_plot_type == "jpeg"){
                                                               jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                             } else {
                                                               pdf(file, width = 14, height = 6, bg = "transparent") 
                                                             }
                                                             timeseries_plot_reg2()
                                                             dev.off()
                                                             })
      
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
                                                               png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                             } else if (input$reg_coe_plot_type == "jpeg"){
                                                               jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white")
                                                             } else {
                                                               pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                             }
                                                             reg_coef_map()
                                                             dev.off()
                                                             })
      
      output$download_reg_coe_plot_data        <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_coe_plot_data_type, sep = "")},
                                                                  content  = function(file) {
                                                                    if (input$reg_coe_plot_data_type == "csv"){
                                                                      map_data_new_4a <- rewrite_maptable(reg_coef_table(),NA,NA)
                                                                      colnames(map_data_new_4a) <- NULL
                                                                      
                                                                      write.csv(map_data_new_4a, file,
                                                                                row.names = FALSE)
                                                                    } else {
                                                                      write.xlsx(rewrite_maptable(reg_coef_table(),NA,NA), file,
                                                                                 row.names = FALSE,
                                                                                 col.names = FALSE)
                                                                    }})
      
      output$download_reg_pval_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-map.",input$reg_pval_plot_type, sep = "")},
                                                            content  = function(file) {
                                                              if (input$reg_pval_plot_type == "png"){
                                                                png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                              } else if (input$reg_pval_plot_type == "jpeg"){
                                                                jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white") 
                                                              } else {
                                                                pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                              }
                                                              reg_pval_map()
                                                              dev.off()
                                                              })
      
      output$download_reg_pval_plot_data       <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_pval_plot_data_type, sep = "")},
                                                                  content  = function(file) {
                                                                    if (input$reg_pval_plot_data_type == "csv"){
                                                                      map_data_new_4b <- rewrite_maptable(reg_pval_table(),NA,NA)
                                                                      colnames(map_data_new_4b) <- NULL
                                                                      
                                                                      write.csv(map_data_new_4b, file,
                                                                                row.names = FALSE)
                                                                    } else {
                                                                      write.xlsx(rewrite_maptable(reg_pval_table(),NA,NA), file,
                                                                                 row.names = FALSE,
                                                                                 col.names = FALSE)
                                                                    }})
      
      output$download_reg_res_plot      <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title,"-map.",input$reg_res_plot_type, sep = "")},
                                                           content  = function(file) {
                                                             if (input$reg_res_plot_type == "png"){
                                                               png(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "transparent")  
                                                             } else if (input$reg_res_plot_type == "jpeg"){
                                                               jpeg(file, width = plot_dimensions_reg()[3] , height = plot_dimensions_reg()[4], res = 200, bg = "white") 
                                                             } else {
                                                               pdf(file, width = plot_dimensions_reg()[3]/200 , height = plot_dimensions_reg()[4]/200, bg = "transparent") 
                                                             }
                                                             reg_res_map()
                                                             dev.off()
                                                             })
      
      output$download_reg_res_plot_data        <- downloadHandler(filename = function(){paste(plot_titles_reg()$Download_title, "-mapdata.",input$reg_res_plot_data_type, sep = "")},
                                                                  content  = function(file) {
                                                                    if (input$reg_res_plot_data_type == "csv"){
                                                                      map_data_new_4c <- rewrite_maptable(reg_res_table(),NA,NA)
                                                                      colnames(map_data_new_4c) <- NULL
                                                                      
                                                                      write.csv(map_data_new_4c, file,
                                                                                row.names = FALSE)
                                                                    } else {
                                                                      write.xlsx(rewrite_maptable(reg_res_table(),NA,NA), file,
                                                                                 row.names = FALSE,
                                                                                 col.names = FALSE)
                                                                    }})
      
      output$download_fad4            <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season4),"_",input$fad_year4,".",input$file_type_fad4, sep = "")},
                                                         content  = function(file) {
                                                           
                                                           mmd = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_fad_map4_width, input$dimension[2], FALSE)
                                                           
                                                           if (input$file_type_fad4 == "png"){
                                                             png(file, width = mmd[3] , height = mmd[4], res = 400, bg = "transparent")  
                                                           } else if (input$file_type_fad4 == "jpeg"){
                                                             jpeg(file, width = mmd[3] , height = mmd[4], res = 400, bg = "white") 
                                                           } else {
                                                             pdf(file, width = mmd[3]/400 , height = mmd[4]/400, bg = "transparent") 
                                                           }
                                                           print(fad_plot4())
                                                           dev.off()
                                                           })
      
      output$download_fad_data4       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season4),"_",input$fad_year4,"_data.",input$data_file_type_fad4, sep = "")},
                                                         content  = function(file) {
                                                           if (input$data_file_type_fad4 == "csv"){
                                                             write.csv(fad_data4(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_data4(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})
      
      
      
    ## ANNUAL CYCLES data processing and plotting ----
      ### Plot timeseries & data ----
      
      # Plot Timeseries
      monthly_ts_titles = reactive({
        if (input$title_mode_ts5 == "Custom" & input$title1_input_ts5 != ""){
          ts_title = input$title1_input_ts5
        } else {
          ts_title = "Monthly Timeseries"
        }
        ts_subtitle = NA
        ts_title_size = 18
        
        titles_df = data.frame(ts_title,ts_subtitle,ts_title_size)
        
        return(titles_df)
      }) 
      
      
      monthly_ts_plot = reactive({
        plot_monthly_timeseries(data = monthly_ts_data(), titles = monthly_ts_titles(),
                                key_position = input$key_position_ts5, highlights=ts_highlights_data5(),
                                lines=ts_lines_data5(), points=ts_points_data5())
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
      
      # Set up values and functions for plotting
      fad_zoom5  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      season_fad_short5 = reactive({
        switch(input$fad_season5,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      fad_global_data5 = reactive({
        load_modera_source_data(input$fad_year5, season_fad_short5())
      })
      
      # Plot map 
      fad_plot5 = function(){plot_modera_sources(fad_global_data5(),input$fad_year5, season_fad_short5(),fad_zoom5())}
      
      output$fad_map5 <- renderPlot({fad_plot5()})
      
      # Set up data function
      fad_data5 <- function() {
        
        fad_base_data5 = download_feedback_data(fad_global_data5(), fad_zoom5()[1:2], fad_zoom5()[3:4])
        
        # Remove the last column
        fad_base_data5 = fad_base_data5[ , -ncol(fad_base_data5)]
        
        return(fad_base_data5)
        
      }
      
      # Update fad lonlat
      
      observe({
        # Update zoom parameters based on range_longitude5 and range_latitude5 change
        fad_zoom5(c(input$range_longitude5[1],input$range_longitude5[2],input$range_latitude5[1], input$range_latitude5[2]))
      })
      
      
      observeEvent(input$fad_reset_zoom5,{
        fad_zoom5(c(-180,180,-90,90))
      })
      
      observeEvent(input$brush_fad5,{
        brush = input$brush_fad5
        fad_zoom5(c(brush$xmin, brush$xmax, brush$ymin, brush$ymax))
      })
      
      ### Downloading Annual cycles data ----
      
      output$download_timeseries5      <- downloadHandler(filename = function(){paste("monthly-ts.",input$file_type_timeseries5, sep = "")},
                                                          content  = function(file) {
                                                            if (input$file_type_timeseries5 == "png"){
                                                              png(file, width = 3000, height = 1285, res = 200, bg = "transparent") 
                                                            } else if (input$file_type_timeseries5 == "jpeg"){
                                                              jpeg(file, width = 3000, height = 1285, res = 200, bg = "white") 
                                                            } else {
                                                              pdf(file, width = 14, height = 6, bg = "transparent") 
                                                            }
                                                            plot_monthly_timeseries(monthly_ts_data(),input$title1_input_ts5,input$title_mode_ts5,input$main_key_position_ts5)
                                                            dev.off()
                                                            }) 
      
      
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
      
      output$download_fad5            <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season5),"_",input$fad_year5,".",input$file_type_fad5, sep = "")},
                                                         content  = function(file) {
                                                           
                                                           mmd = generate_map_dimensions(subset_lons_primary(), subset_lats_primary(), session$clientData$output_fad_map5_width, input$dimension[2], FALSE)
                                                           
                                                           if (input$file_type_fad5 == "png"){
                                                             png(file, width = mmd[3] , height = mmd[4], res = 400, bg = "transparent")  
                                                           } else if (input$file_type_fad5 == "jpeg"){
                                                             jpeg(file, width = mmd[3] , height = mmd[4], res = 400, bg = "white") 
                                                           } else {
                                                             pdf(file, width = mmd[3]/400 , height = mmd[4]/400, bg = "transparent") 
                                                           }
                                                           print(fad_plot5())
                                                           dev.off()
                                                           })
      
      output$download_fad_data5       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$fad_season5),"_",input$fad_year5,"_data.",input$data_file_type_fad5, sep = "")},
                                                         content  = function(file) {
                                                           if (input$data_file_type_fad5 == "csv"){
                                                             write.csv(fad_data5(), file,
                                                                       row.names = FALSE)
                                                           } else {
                                                             write.xlsx(fad_data5(), file,
                                                                        col.names = TRUE,
                                                                        row.names = FALSE)
                                                           }})
      
    ## MODE-RA SOURCES data procession and plotting ----
      ### Plotting (for download)----
      
      season_MES_short <- reactive({
        switch(input$season_MES,
               "April to September" = "summer",
               "October to March" = "winter")
      })
      
      # Load global data
      MES_global_data <- reactive({
        if (input$year_MES >= 1422 && input$year_MES <= 2008) {
          load_modera_source_data(input$year_MES, season_MES_short()) |>
            dplyr::select(LON, LAT, VARIABLE, TYPE, Name_Database, Paper_Database, Code_Proxy, Reference_Proxy, Reference_Proxy_Database, Omitted_Duplicates) |>
            st_as_sf(coords = c('LON', 'LAT')) |>
            st_set_crs(4326)
        } else {
          NULL
        }
      })
      
      ### Leaflet Map ----
      
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
      
      ## Download Preparation for Data (CSV/XLSX)
      # Set up values and functions for plotting
      fad_zoom_MES  <- reactiveVal(c(-180,180,-90,90)) # These are the min/max lon/lat for the zoomed plot
      
      MES_global_data_download = reactive({
        load_modera_source_data(input$year_MES, season_MES_short())
      })
      
      # Set up data function
      fad_data_MES <- function() {
        fad_base_data_MES = download_feedback_data(MES_global_data_download(), fad_zoom_MES()[1:2], fad_zoom_MES()[3:4])
        
        # Remove the last column
        fad_base_data_MES = fad_base_data_MES[ , -ncol(fad_base_data_MES)]
        
        return(fad_base_data_MES)
      }
      
      
      output$download_MES_data       <- downloadHandler(filename = function(){paste("Assimilated Observations_",gsub(" ", "", input$season_MES),"_",input$year_MES,"_data.",input$data_file_type_MES, sep = "")},
                                                        content  = function(file) {
                                                          if (input$data_file_type_MES == "csv"){
                                                            write.csv(fad_data_MES(), file,
                                                                      row.names = FALSE)
                                                          } else {
                                                            write.xlsx(fad_data_MES(), file,
                                                                       col.names = TRUE,
                                                                       row.names = FALSE)
                                                          }})
      
      ### TS Sources and Observation Map ----
      ## Timeseries plot for ModE-ra sources and observations
      
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
      
    ## SEA Superposed epoch analysis ----
      ### User Data Processing ----
      
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
      
      #Creating a year set for composite
      year_set_sea <- reactive({
        read_composite_data(input$event_years_6, input$upload_file_6b$datapath, input$enter_upload_6)
      })
      
      ### ModE-Data Processing ----
      
      #Using the time series data as input
      timeseries_data_sea <- reactive({
        req(input$nav1 == "tab6") # Only run code if in the current tab
        
          ts_data1 <- create_timeseries_datatable(data_output4_primary(), c(1422,2008), "range", subset_lons_primary(), subset_lats_primary())

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
      
      ### SEA Processing ----
      
      # Extract years, title & y label based on selected data source
      years = reactive({
        if (input$source_sea_6 == "User Data") {
          return(unlist(user_subset_6()[,1]))  # Extract years from user-uploaded data
        } else {
          return(unlist(timeseries_data_sea()[,1]))  # Extract years from ModE- data
        }
      })
      
      ts_y_label = reactive({
        if (input$source_sea_6 == "User Data") {
          if (is.null(input$y_label_6) || input$y_label_6 == ""){
            y_label = paste(colnames(user_subset_6())[2])
          } else {
            y_label = input$y_label_6
          }
          return(y_label)
          
        } else {
          if (is.null(input$y_label_6) || input$y_label_6 == ""){
            y_label = paste(colnames(timeseries_data_sea())[2],input$ME_variable_6)
          } else {
            y_label = input$y_label_6
          }
          return(y_label)
        }
      })
      
      ts_title = reactive({
        if (input$source_sea_6 == "User Data") {
          if (is.null(input$title1_input_6) || input$title1_input_6 == ""){
            return(paste("SEA of",colnames(user_subset_6())[2]))  
          } else {
            return(input$title1_input_6)
          }
        } else {
          if (is.null(input$title1_input_6) || input$title1_input_6 == ""){
            return(paste("SEA of",colnames(timeseries_data_sea())[2],input$ME_variable_6))  
          } else {
            return(input$title1_input_6)
          }
        }
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
        # Choose source of event years based on input$enter_upload_6
        if (input$enter_upload_6 == "Manual") {
          v_years <- as.integer(unlist(strsplit(input$event_years_6, split = ",")))
        } else if (input$enter_upload_6 == "Upload") {
          v_years <- year_set_sea()
        } else {
          return(NULL)  # or handle error/default case
        }
        
        # Filter event years based on lag
        v_years_cut <- subset(v_years, (v_years > (min(years()) - input$lag_years_6[1])) &
                                (v_years < (max(years()) - input$lag_years_6[2])))
        
        return(v_years_cut)
      })
      
      # Calculate SEA data
      SEA_data = reactive({
        original_SEA = burnr::sea(ts_data(),event_years_cut(),nbefore = abs(input$lag_years_6[1]),
                                  nafter=input$lag_years_6[2],n_iter=input$sample_size_6)
        # Replace mean and CIs with stats from NA-replaced data (if required)
        if(sum(is.na(ts_data()))>0){
          ts_data_random_filled = ts_data()
          
          # Extract the non-NA values from the column
          non_na_values <- as.vector(ts_data_random_filled[!is.na(ts_data_random_filled)])
          
          # Replace NAs with random values from non-NA values
          ts_data_random_filled[is.na(ts_data_random_filled)] <- sample(non_na_values, sum(is.na(ts_data_random_filled)), replace = TRUE)
          
          #Perform new SEA
          new_SEA = burnr::sea(ts_data_random_filled,event_years_cut(),nbefore = abs(input$lag_years_6[1]),
                               nafter=input$lag_years_6[2],n_iter=input$sample_size_6)
          #Replace values
          original_SEA$random$mean = new_SEA$random$mean
          original_SEA$random$lower_95 = new_SEA$random$lower_95
          original_SEA$random$upper_95 = new_SEA$random$upper_95
          original_SEA$random$lower_99 = new_SEA$random$lower_99
          original_SEA$random$upper_99 = new_SEA$random$upper_99
        }
        return(original_SEA)
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
        
        # Find y limits
        SEAmax <- max(data[, !names(data) %in% c("LAG_YEAR", "P")], na.rm = TRUE)
        SEAmin <- min(data[, !names(data) %in% c("LAG_YEAR", "P")], na.rm = TRUE)
        SEArange <- SEAmax - SEAmin
        ymax <- SEAmax + (0.05 * SEArange)
        ymin <- SEAmin - (0.05 * SEArange)
        
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
      
      ### Downloads ----
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
                                                              openxlsx::write.xlsx(SEA_datatable(), file)
                                                            }})
      
    ## Concerning all modes (mainly updating Ui) ----
    
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
    updateNumericInputRange1("point_size_ts", 1, 10)
    updateNumericInputRange1("point_size_ts2", 1, 10)
    updateNumericInputRange1("point_size_ts3", 1, 10)
    updateNumericInputRange1("percentage_sign_match", 1, 100)
    updateNumericInputRange1("percentage_sign_match2", 1, 100)
    updateNumericInputRange1("hidden_SD_ratio", 0, 1)
    updateNumericInputRange1("hidden_SD_ratio2", 0, 1)
    updateNumericInputRange1("year_moving_ts", 3, 30)
    updateNumericInputRange1("year_moving_ts3", 3, 30)
    updateNumericInputRange1("prior_years2", 1, 50)
    
    updateNumericInputRange2 <- function(inputId, minValue, maxValue) {
      observe({
        input_values <- input[[inputId]]
        
        delay(3000, {
          if (is.null(input_values) || is.na(input_values) || nchar(as.character(input_values)) <= 3) { 
            # If input is null, NA, or has <= 3 characters, take no action
          } else if (!is.numeric(input_values)) {
            updateNumericInput(inputId = inputId, value = 1422)
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
    updateNumericInputRange2("fad_year_a", 1422, 2008)
    updateNumericInputRange2("fad_year_a2", 1422, 2008)
    updateNumericInputRange2("fad_year_a3a", 1422, 2008)
    updateNumericInputRange2("fad_year_a3b", 1422, 2008)
    updateNumericInputRange2("fad_year_a4a", 1422, 2008)
    updateNumericInputRange2("fad_year_a4b", 1422, 2008)
    updateNumericInputRange2("fad_year_a5", 1422, 2008)
    updateNumericInputRange2("reg_resi_year", 1422, 2008)
    updateNumericInputRange2("range_years_sg", 1422, 2008)
    updateNumericInputRange2("ref_period_sg", 1422, 2008)
    updateNumericInputRange2("ref_period_sg2", 1422, 2008)
    updateNumericInputRange2("ref_period_sg_v1", 1422, 2008)
    updateNumericInputRange2("ref_period_sg_v2", 1422, 2008)
    updateNumericInputRange2("ref_period_sg_iv", 1422, 2008)
    updateNumericInputRange2("ref_period_sg_dv", 1422, 2008)
    updateNumericInputRange2("ref_period_sg5", 1422, 2008)
    updateNumericInputRange2("year_MES", 1422, 2008)
    
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
    
    ## Stop App on end of session ----
    session$onSessionEnded(function() {
      stopApp()
    })
  # Close server function ----
}

# Run the app with profiling
# profvis({runApp(app)})