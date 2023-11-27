library(tibble)
library(readr)
library(dplyr)

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

itcr_website_data <- readRDS("data/itcr_website_data.rds")

metrics <- tibble::as_tibble(itcr_website_data[[1]]) %>%
  mutate_if(is.double, round2)

dimensions <- tibble::as_tibble(itcr_website_data[[2]])
link_clicks <- tibble::as_tibble(itcr_website_data[[3]]) %>% 
  mutate(linkUrl = paste0("<a href='", linkUrl,"' target='_blank'>", linkUrl,"</a>"))

jhudsl_github_metrics <- read_tsv("data/jhudsl_github_metrics.tsv")