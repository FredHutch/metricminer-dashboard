library(tibble)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(metricminer)

# Custom rounding function for x > 1 that rounds up 
# if decimal place of x is more than or equal to 0.5 
# else rounds down
round_larger_than_one <- function(x) {
  x_floor <- x - floor(x)
  ifelse(x_floor < 0.5, floor(x), ceiling(x))
}

round2 <- function(x) {
  ifelse(x > 1,
         round_larger_than_one(x),
         # for Engagement rates
         round(x, 2)
  )
}

# ITCR Website Data
itcr_website_data <- readRDS("data/itcr_website_data.rds")

metrics <- tibble::as_tibble(itcr_website_data[[1]]) %>%
  mutate_if(is.double, round2)

metrics_itn_website <- metrics %>% filter(website == "ITN Website")
metrics_course <- metrics %>% filter(website != "ITN Website")

dimensions <- tibble::as_tibble(itcr_website_data[[2]]) %>% 
  mutate(fullPageUrl = paste0("<a href='", "https://", fullPageUrl,"' target='_blank'>", fullPageUrl,"</a>"))
link_clicks <- tibble::as_tibble(itcr_website_data[[3]]) %>% 
  mutate(linkUrl = paste0("<a href='", linkUrl,"' target='_blank'>", linkUrl,"</a>"))

# jhudsl GitHub Metrics
jhudsl_github_metrics <- read_tsv("data/jhudsl_github_metrics.tsv") %>%
  # convert all columns to character
  mutate(across(everything(), as.character)) %>% 
  # convert NA to Not Available
  mutate(across(everything(), ~replace_na(as.character(.), "-"))) %>% 
  mutate(repo_name = str_remove(repo_name, "jhudsl/"))
  


# fhdsl GitHub Metrics
fhdsl_github_metrics <- read_csv("data/fhdsl_github_metrics.csv") %>%
  # convert all columns to character
  mutate(across(everything(), as.character)) %>% 
  # convert NA to Not Available
  mutate(across(everything(), ~replace_na(as.character(.), "-"))) %>% 
  mutate(repo_name = str_remove(repo_name, "fhdsl/"))

  

# Slido
slido_data <- readRDS("data/slido_data.RDS")
