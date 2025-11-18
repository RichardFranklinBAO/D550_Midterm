library(readr)
library(dplyr)
library(stringr)
library(here)

raw_data <- read_csv(here("data", "nba_2025-10-30.csv"),
                     show_col_types = FALSE)

clean_data <- raw_data %>%
  distinct() %>%                      
  rename_with(~ str_replace_all(.x, " ", "_")) %>%
  mutate(across(where(is.character), str_trim)) %>%
  mutate(
    Age = as.numeric(Age),
    G   = as.numeric(G),
    MP  = as.numeric(MP),
    PTS = as.numeric(PTS)
  ) %>% 
  filter(                                         
    !is.na(Age),
    !is.na(MP),
    !is.na(PTS),
    G > 0,
    MP > 0,
    PTS >= 0
  )

saveRDS(clean_data, here("results", "01_dataclean.Rds"))

message("Cleaning done. Saved to results/01_dataclean.Rds")