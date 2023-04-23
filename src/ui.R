source("src/ui/sample_information.R")
source("src/ui/counts_matrix.R")
source("src/ui/differential_expression.R")
source("src/ui/gene_expression.R")

ui <- fluidPage(
  titlePanel("BF591 Final Project"),
  tabsetPanel(
    # Panel 1
    sample_information,
    
    # Panel 2
    counts_matrix,
    
    # Panel 3
    differential_expression,
    
    # Panel 4
    gene_expression,
  )
)
