library(shiny)
library(ggplot2)
library(colourpicker)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(DT)
library(tidyverse)
library(ComplexHeatmap)
library(beeswarm)
library(ggbeeswarm)
library(RColorBrewer)
library(BiocManager)
options(repos = BiocManager::repositories())

options(shiny.maxRequestSize = 30 * 1024 ^ 2)

source("src/ui.R")
source("src/server.R")

shinyApp(ui = ui, server = server)
