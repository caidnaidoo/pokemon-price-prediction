library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(purrr)

parse_csv_card <- function(path) {
  
  raw <- readr::read_lines(path)
  
  # remove empty lines
  raw <- raw[nchar(raw) > 0]
  
  # extract metadata (Card Name, Set Name, Rarity, etc.)
  metadata_lines <- raw[grepl(",", raw) & !grepl("Variant,Condition", raw)]
  
  metadata <- metadata_lines %>%
    str_split_fixed(",", 2) %>%
    as.data.frame() %>%
    setNames(c("field", "value")) %>%
    mutate(
      field = str_trim(field),
      value = str_trim(value)
    )
  
  # pivot metadata into one row
  meta_wide <- tidyr::pivot_wider(metadata,
                                  names_from = field,
                                  values_from = value)
  
  # extract price table
  start <- grep("Variant,Condition", raw)
  if (length(start) == 0) {
    price_tbl <- tibble()
  } else {
    price_rows <- raw[(start):(length(raw))]
    price_tbl <- read_csv(
      paste(price_rows, collapse = "\n"),
      show_col_types = FALSE
    )
  }
  
  # combine into one tibble (nested price table)
  tibble(
    file = basename(path),
    card_name = meta_wide$`Card Name`,
    set_name = meta_wide$`Set Name`,
    rarity = meta_wide$Rarity,
    market_price = meta_wide$`Current Market Price`,
    metadata = list(meta_wide),
    conditions = list(price_tbl)
  )
}
