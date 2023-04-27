server <- function(input, output, session) {
  options(shiny.fullstacktrace = TRUE)
  
  source("utils/helper_functions.R")
  
  ############################
  ####### DATA LOADING #######
  ############################
  
  p1_sample_information.load_data <- reactive({
    data <- read_csv_file(input$p1_fileinput_sample_information, convert = TRUE)
    if (!is.null(data)) {
      choices <- names(Filter(function(x) is.numeric(x) && n_distinct(x) > 2, data))
      observe({
        updateRadioButtons(session, "p1_radio_sample_information", choices = choices)
      })
    }
    return(data)
  })
  
  p2_counts_matrix.load_data <- reactive({
    data <- read_csv_file(input$p2_fileinput_normalized_counts_matrix)
    if (!is.null(data)) {
      observe({
        updateSliderInput(
          session,
          "p2_slider_nonzero_gene_samples",
          max = ncol(data),
          value = median(ncol(data)/2)
        )
      })
    }
    return(data)
  })
  
  p3_differential_expression.load_data <- reactive({
    data <- read_csv_file(input$p3_fileinput_differential_expression_results)
    return(data)
  })
  
  p4_gene_expression.load_data1 <- reactive({
    data <- read_csv_file(input$p4_fileinput_normalized_counts_data)
    if (!is.null(data)) {
      observe({
        updateSelectizeInput(inputId = "p4_selectizeinput_gene_search",
                             choices = c("Search Bar" = "", unique(data[, 1])))
      })
    }
    return(data)
  })
  
  p4_gene_expression.load_data2 <- reactive({
    data <- read_csv_file(input$p4_fileinput_sample_information, convert = TRUE)
    if (!is.null(data)) {
      observe({
        choices <- names(Filter(is.factor, data))
        updateRadioButtons(session, "p4_radio_categorical_column", choices = choices)
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
  
  ############################
  ######### PANEL 2 ##########
  ############################
  
  p2_counts_matrix.slider_percentile_variance <- reactive({
    if (is.null(input$p2_slider_percentile_variance))
      return(50)
    input$p2_slider_percentile_variance
  })
  
  p2_counts_matrix.slider_nonzero_gene_samples <- reactive({
    if (is.null(input$p2_slider_nonzero_gene_samples))
      return(2)
    input$p2_slider_nonzero_gene_samples
  })
  
  p2_counts_matrix.radio_principal_component_1 <- reactive({
    if (is.null(input$p2_radio_principal_component_1))
      return(1)
    input$p2_radio_principal_component_1
  })
  
  p2_counts_matrix.radio_principal_component_2 <- reactive({
    if (is.null(input$p2_radio_principal_component_2))
      return(2)
    input$p2_radio_principal_component_2
  })
  
  p2_counts_matrix.slider_pca <- reactive({
    if (is.null(input$p2_slider_pca))
      return(5)
    input$p2_slider_pca
  })
  
  output$p1_datatableoutput_sample_information_data <- renderDataTable({
    data <- p1_sample_information.load_data()
    return(data)
  }, options = list(
    rownames = TRUE,
    pageLength = 10,
    autoWidth = TRUE,
    scrollX = TRUE
  ))
  
  output$p2_datatableoutput_filter_summary <- renderDataTable({
    data <- p2_counts_matrix.load_data()
    subset <- select(data, -1)
    num_genes <- nrow(subset)
    num_samples <- ncol(subset)
    data_filtered <- data %>%
      threshold_row_variance(
        p2_counts_matrix.slider_percentile_variance() / 100,
        p2_counts_matrix.slider_nonzero_gene_samples()
      ) %>%
      filter(Pass == 'pass')
    npass <- nrow(select(data_filtered, -c(1:5)))
    nfail <- num_genes - npass
    result <- data_filtered %>%
      summarize("Total" = num_genes,
                "Pass" = npass,
                "Fail" = nfail) %>%
      pivot_longer(cols = everything(),
                   names_to = "X",
                   values_to = "Genes") %>%
      mutate("Percentage (%) of genes passing filter" = round(Genes / num_genes * 100, 1),
            "Number of genes passing filter" = Genes,
            " " = X) %>%
      select(" ",
            "Number of genes passing filter",
            "Percentage (%) of genes passing filter")
    output$p2_htmloutput_sample_size <- renderText({
      paste("<b>Number of samples: ", num_samples, "</b>")
    })
    return(result)
  }, options = list(
    rownames = FALSE,
    colnames = FALSE,
    paging = FALSE,
    width = "100%",
    searching = FALSE,
    scrollX = TRUE
  ))
  
  output$p2_plotoutput_median_count_vs_variance <- renderPlot({
    data <- p2_counts_matrix.load_data()
    data <- threshold_row_variance(
      data,
      p2_counts_matrix.slider_percentile_variance() / 100,
      p2_counts_matrix.slider_nonzero_gene_samples()
    )
    data$logMedian <- log(data$Median + 1)
    plot <- ggplot(data = data, aes(x = logMedian, y = log(RowVariance))) +
      geom_point(aes(color = Pass)) +
      labs(color = "Genes Passing Set Filter") +
      scale_color_manual(values = c("#e74c3c", "#00a65a")) +
      theme_classic()
    return(plot)
  })
  
  output$p2_plotoutput_median_count_vs_number_of_zeros <- renderPlot({
    data <- p2_counts_matrix.load_data()
    data <- threshold_row_variance(
      data,
      p2_counts_matrix.slider_percentile_variance() / 100,
      p2_counts_matrix.slider_nonzero_gene_samples()
    )
    data$logMedian <- log(data$Median + 1)
    plot <- ggplot(data = data, aes(x = logMedian, y = NumZeros)) +
      geom_point(aes(color = Pass)) +
      labs(color = "Genes Passing Set Filter") +
      scale_color_manual(values = c("#e74c3c", "#00a65a")) +
      theme_classic()
    return(plot)
  })
  
  output$p2_plotoutput_heatmap <- renderPlot({
    data <- p2_counts_matrix.load_data()
    data <-
      threshold_row_variance(
        data,
        p2_counts_matrix.slider_percentile_variance() / 100,
        p2_counts_matrix.slider_nonzero_gene_samples()
      )
    filt_data <- data[data$Pass == 'pass', ]
    filt_data <- filt_data[-c(1:5)]
    filt_data <- log(filt_data + 1)
    label_name <- "Log(Counts)"
    plot <- Heatmap(
      filt_data,
      name = label_name,
      show_row_names = FALSE,
      cluster_rows = FALSE,
      cluster_columns = TRUE,
      heatmap_legend_param = list()
    ) + 
    labs(title = "Heatmap of Log-Transformed Gene Counts")
    return(plot)
  })
  
  output$p2_plotoutput_scatter_pca <- renderPlot({
    data <- p2_counts_matrix.load_data()
    data <-
      threshold_row_variance(
        data,
        p2_counts_matrix.slider_percentile_variance() / 100,
        p2_counts_matrix.slider_nonzero_gene_samples()
      )
    filt_data <- subset(data, Pass == 'pass', select = -c(1:5))
    if (nrow(filt_data) == 0) {
      return(NULL)
    }
    pca <- prcomp(filt_data)
    pca_df <- as.data.frame(pca$x)
    pca_variance <- pca$sdev^2
    percent_variance <- pca_variance / sum(pca_variance)
    PC1 <- as.integer(p2_counts_matrix.radio_principal_component_1())
    PC2 <- as.integer(p2_counts_matrix.radio_principal_component_2())
    x_lab <- sprintf("PC%d, variance: %.2f%%", PC1, percent_variance[PC1] * 100)
    y_lab <- sprintf("PC%d, variance: %.2f%%", PC2, percent_variance[PC2] * 100)
    
    plot <- ggplot(pca_df, aes(x = !!sym(paste0("PC", PC1)), y = !!sym(paste0("PC", PC2)))) +
      geom_point() +
      labs(x = x_lab, y = y_lab, title = "PCA Scatter Plot") +
      theme(
        legend.position = "bottom",
        plot.title = element_text(size = 14, face = "bold", margin = margin(b = 10)),
        axis.text = element_text(size = 12),
        axis.title = element_text(size = 14),
        panel.background = element_rect(fill = "white"),
        panel.grid.major = element_line(color = "#F2F2F2"),
        panel.grid.minor = element_blank()
      ) +
      theme_classic()
    return(plot)
  })
  
  ############################
  ######### PANEL 3 ##########
  ############################
  
  
  ############################
  ######### PANEL 4 ##########
  ############################
  
  
}
