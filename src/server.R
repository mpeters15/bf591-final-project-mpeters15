server <- function(input, output, session) {
  options(shiny.fullstacktrace = TRUE)
  
  source("utils/helper_functions.R")
  
  ############################
  ####### DATA LOADING #######
  ############################
  
  p1_sample_information.load_data <- reactive({
    data <- read_csv_file(input$p1_fileinput_sample_information, convert = TRUE)
    if (!is.null(data)) {
      choices <- data %>%
        select_if(~ is.numeric(.) && n_distinct(.) > 2) %>%
        names()
      observe({
        updateRadioButtons(session, "p1_radio_sample_information", choices = choices)
      })
    }
    return(data)
  })
  
  ############################
  ######### PANEL 1 ##########
  ############################
  
  p1_sample_information.radio1 <- reactive({
    input$p1_radio_sample_information
  })
  
  output$p1_datatableoutput_sample_information_summary <- renderDataTable({
    data <- p1_sample_information.load_data()
    metadata <- cbind(colnames(data), 
                      sapply(data, function(x) summarize_metadata(x)[[1]]),
                      sapply(data, function(x) summarize_metadata(x)[[2]])
                )
    data <- as.data.frame(metadata)
    colnames(data) <- c("Column Name", "Type", "Mean (sd) or Distinct Values")
    rownames(data) <- NULL
    return(data)
  }, options = list(
    rownames = FALSE,
    colnames = FALSE,
    paging = FALSE,
    width = "100%",
    searching = FALSE,
    scrollX = TRUE
  ))
  
  output$p1_datatableoutput_sample_information_data <- renderDataTable({
    data <- p1_sample_information.load_data()
    return(data)
  }, options = list(
    rownames = TRUE,
    pageLength = 10,
    autoWidth = TRUE,
    scrollX = TRUE
  ))
  
  output$p1_plotoutput_sample_information <- renderPlot({
    data <- p1_sample_information.load_data()
    if (input$p1_radio_sample_information == "Upload a file to see choices") {
      return(NULL)
    } else {
      plot <- ggplot(data, 
        aes(x = !!sym(input$p1_radio_sample_information))) +
        geom_histogram(
          fill = "#0073b7",
          color = "black",
          alpha = 0.8
        ) +
        theme(legend.position = "bottom") +
        theme_minimal()
      return(plot)
    }
  })
  
  
}
