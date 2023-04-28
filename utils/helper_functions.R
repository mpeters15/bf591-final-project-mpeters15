read_csv_file <- function(file_input, convert = FALSE) {
  req(file_input)
  file <- file_input
  if (is.null(file)) {
    return(NULL)
  } else {
    if (convert == TRUE) {
      data <-
        read.csv(file$datapath,
                 header = TRUE,
                 stringsAsFactors = TRUE)
      
      if ("geo_accession" %in% names(data)) {
        data$geo_accession <- as.character(data$geo_accession)
      }
      
      if ("sample_id" %in% names(data)) {
        data$sample_id <- as.character(data$sample_id)
      }
    } else {
      data <-
        read.csv(file$datapath,
                 header = TRUE,
                 stringsAsFactors = FALSE)
    }
    return(data)
  }
}

summarize_metadata <- function(x) {
  column_type <- class(x)
  if (column_type %in% c("integer", "numeric")) {
    x <- na.omit(x)
    column_summary <- sprintf("%.2f (+/- %.2f)", mean(x), sd(x))
  } else if (column_type == "factor" && nlevels(x) < length(x)) {
    column_summary <- x %>% 
      levels() %>% 
      paste(collapse = ", ")
  } else if (nlevels(as.factor(x)) == length(x)) {
      column_summary <- "Identifier"
  } else {
    column_summary <- x[1]
  }
  list(column_type, column_summary)
}

threshold_row_variance <- function(data, percentile, nsampl) {
  subset <- select(data, -1)
  row_variance <- subset %>% 
    apply(1, var, na.rm = TRUE)
  cutoff_value <- quantile(row_variance, probs = percentile)
  idx <- which(row_variance > cutoff_value & rowSums(subset != 0) >= nsampl)
  data %>% 
    mutate(Pass = if_else(row_number() %in% idx, "pass", "fail"),
           NumZeros = rowSums(subset == 0),
           Median = apply(subset, 1, median, na.rm = TRUE),
           RowVariance = row_variance) %>%
    relocate(Pass, NumZeros, Median, RowVariance, .after = 1)
}

volcano_plot <- function(data, x_name, y_name, slider, color1, color2) {
  plot <- ggplot(data, aes(
    x = !!sym(x_name),
    y = -log10(!!sym(y_name)),
    color = padj < (1 * (10 ** slider))
  )) +
  geom_point() +
  scale_colour_manual(
    name = sprintf("padj < 1 × 10^%s", slider),
    values = c(
      "FALSE" = color1,
      "TRUE" = color2,
      "NA" = "grey"
    )
  ) +
  labs(x = x_name, y = sprintf("-log10(%s)", y_name)) +
  theme_minimal() +
  theme(legend.position = "bottom")
  return(plot)
}

multi_plot <- function(data, type, colname) {
  plot <- NULL
  if (type == "bar plot") {
    plot <- ggplot(data, aes_string(x = colname, fill = colname)) +
      geom_bar() +
      ylab("Gene Expression") +
      theme_minimal() + 
      scale_fill_brewer(palette = "Paired")
  } else if (type == "box plot") {
    plot <-
      ggplot(data, aes_string(x = colname, y = "gene_expression", fill = colname)) +
      geom_boxplot() +
      ylab("Gene Expression") +
      theme_minimal() + 
      scale_fill_brewer(palette = "Paired")
  } else if (type == "violin plot") {
    plot <-
      ggplot(data, aes_string(x = colname, y = "gene_expression", fill = colname)) +
      geom_violin(trim = FALSE) +
      geom_boxplot(width = 0.07) +
      ylab("Gene Expression") +
      theme_minimal() + 
      scale_fill_brewer(palette = "Paired")
  } else if (type == "beeswarm plot") {
    plot <-
      ggplot(data, aes_string(x = colname, y = "gene_expression", color = colname)) +
      geom_beeswarm(cex = 3, aes(size = 1)) +
      ylab("Gene Expression") +
      theme_minimal() + 
      scale_color_brewer(palette = "Paired")
  }
  return(plot + theme(legend.position = "bottom"))
}
