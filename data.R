library(tibble)
library(readr)

itcr_website_data <- readRDS("data/itcr_website_data.rds")

metrics <- tibble::as_tibble(itcr_website_data[[1]])
dimensions <- tibble::as_tibble(itcr_website_data[[2]])
link_clicks <- tibble::as_tibble(itcr_website_data[[3]])

jhudsl_github_metrics <- read_tsv("data/jhudsl_github_metrics.tsv")
