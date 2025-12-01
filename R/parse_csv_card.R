library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(purrr)

parse_csv_card <- function(path) {
  
  raw <- read_lines(path)
  raw <- raw[nchar(raw) > 0]   # remove empty lines
  
  # --- Identify section headers ---
  info_start  <- grep("CARD INFORMATION", raw)
  cond_start  <- grep("CURRENT PRICES BY CONDITION", raw)
  hist_start  <- grep("PRICE HISTORY", raw)
  
  # --- Extract metadata block ---
  meta_block <- raw[(info_start + 1):(cond_start - 1)]
  meta_df <- meta_block %>%
    str_split_fixed("\t", 2) %>%
    as.data.frame() %>%
    setNames(c("field", "value")) %>%
    mutate(
      field = str_trim(field),
      value = str_trim(value)
    ) %>%
    pivot_wider(names_from = field, values_from = value)
  
  # --- Extract condition price table ---
  cond_block <- raw[(cond_start + 1):(hist_start - 1)]
  cond_table <- read_csv(
    paste(cond_block, collapse = "\n"),
    show_col_types = FALSE
  )
  
  # --- Extract historical prices table ---
  hist_block <- raw[(hist_start + 1):length(raw)]
  hist_table <- read_csv(
    paste(hist_block, collapse = "\n"),
    show_col_types = FALSE
  )
  
  # --- Return tidy nested tibble ---
  tibble(
    file = basename(path),
    card_name = meta_df$`Card Name`,
    set_name = meta_df$`Set Name`,
    rarity = meta_df$Rarity,
    card_number = meta_df$`Card Number`,
    market_price = meta_df$`Current Market Price`,
    metadata = list(meta_df),
    conditions = list(cond_table),
    history = list(hist_table)
  )
}
