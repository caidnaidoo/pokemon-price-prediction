library(tidyverse)

source("R/parse_csv_card.R")  # make sure this file exists!

clean_all_cards <- function() {
  
  # 1. Get all CSVs in raw folder
  files <- list.files("data/raw", pattern = "\\.csv$", full.names = TRUE)
  
  # 2. Parse each card
  parsed_cards <- map_df(files, parse_csv_card)
  
  # 3. Save cleaned dataset
  saveRDS(parsed_cards, "data/cleaned/cards_cleaned.rds")
  
  message("Successfully cleaned and saved: data/cleaned/cards_cleaned.rds")
}
