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
  list(column_type, description)
}

}
