if (!requireNamespace("GEOquery", quietly = TRUE)) {
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install("GEOquery")
}

library("GEOquery")
library("tidyverse")

download_files <- function(urls,
                           dir_path = "data",
                           num_retries = 3) {
  if (!file.exists(dir_path)) {
    dir.create(dir_path, recursive = TRUE)
  }
  for (url in urls) {
    destfile <- file.path(dir_path, basename(url))
    for (i in 1:num_retries) {
      tryCatch(
        download.file(
          url,
          destfile,
          method = "auto",
          quiet = TRUE,
          mode = "wb"
        ),
        error = function(e) {
          message(paste("Download attempt", i, "failed for", url))
          if (i == num_retries) {
            message(paste("Maximum number of retries reached for", url))
            stop("Failed to download ",
                 url,
                 " after ",
                 num_retries,
                 " attempts.")
          } else {
            if (grepl("network", tolower(conditionMessage(e)))) {
              Sys.sleep(60)
            } else {
              Sys.sleep(5)
            }
          }
        }
      )
      if (file.exists(destfile)) {
        break
      }
    }
    cat("File stored at:\n", destfile, "\n")
  }
}

create_metadata_file <- function(file_path) {
  gse <- getGEO(filename = file_path)
  gse_df <- as_tibble(gse)
  gse_df <- data.frame(
    geo_accession = gse$geo_accession,
    sample_id = gse$title,
    source = gse$source_name_ch1,
    tissue = gse$tissue,
    diagnosis = gse$`diagnosis:ch1`,
    pmi = gse$`pmi:ch1`,
    age_of_death = gse$`age of death:ch1`,
    rin = gse$`rin:ch1`,
    mrna_seq_reads = gse$`mrna-seq reads:ch1`,
    age_of_onset = gse$`age of onset:ch1`,
    duration = gse$`duration:ch1`,
    cag = gse$`cag:ch1`,
    vonsattel_grade = gse$`vonsattel grade:ch1`,
    hv_striatal_score = gse$`h-v striatal score:ch1`,
    hv_cortical_score = gse$`h-v cortical score:ch1`
  ) %>%
    select(
      geo_accession,
      sample_id,
      source,
      tissue,
      diagnosis,
      pmi,
      age_of_death,
      rin,
      mrna_seq_reads,
      age_of_onset,
      duration,
      cag,
      vonsattel_grade,
      hv_striatal_score,
      hv_cortical_score
    )
  write.csv(gse_df,
            file = "./data/metadata.csv",
            row.names = FALSE,
            quote = FALSE)
  file.remove(file_path)
}

# filter_zero_var_genes <- function(verse_counts) {
#   gene_vars <- verse_counts[-1] %>%
#     apply(1, var) %>%
#     as.vector()
#   filtered <- verse_counts %>%
#     filter(gene_vars > 0)
#   return(filtered)
# }

# filter_mean_genes <- function(verse_counts, threshold) {
#   gene_means <- verse_counts[-1] %>%
#     apply(1, mean) %>%
#     as.vector()
#   filtered <- verse_counts %>%
#     filter(gene_means >= threshold)
#   return(filtered)
# }

convert_to_csv <- function(file_path, output_name) {
  print(file_path)
  data <-
    read.table(
      file_path,
      header = TRUE,
      sep = "\t",
      quote = "",
      comment.char = ""
    )
  if (startsWith(names(data)[1], "X") &&
      startsWith(data[[1]][1], "ENS")) {
    names(data)[1] <- "ensembl_id"
  }

  # if (grepl("GSE64810_mlhd_DESeq2_norm_counts_adjust", file_path)) {
  #     data <- filter_zero_var_genes(data)
  #     data <- filter_mean_genes(data, 1)
  #   }

  write.csv(data,
            file.path("data", output_name),
            row.names = FALSE,
            quote = FALSE)
  file.remove(file_path)
}

base_url <- "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE64nnn/GSE64810"

http_urls <- c(
  paste0(base_url, "/matrix/GSE64810_series_matrix.txt.gz"),
  paste0(
    base_url,
    "/suppl/GSE64810_mlhd_DESeq2_norm_counts_adjust.txt.gz"
  ),
  paste0(
    base_url,
    "/suppl/GSE64810_mlhd_DESeq2_diffexp_DESeq2_outlier_trimmed_adjust.txt.gz"
  )
)

download_files(http_urls)

if (length(list.files("./data", pattern = "*.gz")) == length(http_urls)) {
  create_metadata_file("./data/GSE64810_series_matrix.txt.gz")
  convert_to_csv(
    "./data/GSE64810_mlhd_DESeq2_norm_counts_adjust.txt.gz",
    "normalized_counts_matrix.csv"
  )
  convert_to_csv(
    "./data/GSE64810_mlhd_DESeq2_diffexp_DESeq2_outlier_trimmed_adjust.txt.gz",
    "deseq2_analysis.csv"
  )
}