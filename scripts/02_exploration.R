suppressPackageStartupMessages({
  library(dplyr)
  library(here)
  library(kableExtra)
})

here::i_am("scripts/02_exploration.R")

df <- readRDS(here::here("results", "01_dataclean.Rds"))

# Select numaric variable and exclude Rk
numeric_cols <- names(df)[sapply(df, is.numeric)]
numeric_cols <- setdiff(numeric_cols, "Rk")

##########################################
# 1. Table 1: mean and sd of all players #
##########################################

# Overall mean & SD
summary_all <- bind_rows(
  summarise(df, across(all_of(numeric_cols), ~ round(mean(.x, na.rm = TRUE), 1))),
  summarise(df, across(all_of(numeric_cols), ~ round(sd(.x,   na.rm = TRUE), 1)))
)

summary_all <- summary_all |>
  mutate(stat = c("mean", "sd"), .before = 1)

#write.csv(
#  summary_all,
#  here::here("results", "02_results", "02_summary_all.csv"),
#  row.names = TRUE
#)

# Save the table in html format
save_kable(
  kable(summary_all, format = "html") %>% 
    kable_styling(
      bootstrap_options = c("striped", "bordered", "hover"),
      full_width = FALSE,
      font_size = 13
    ) %>%
    column_spec(1, bold = TRUE),
  file = here::here("results", "02_results", "02_mean&sd_all.html")
)

###################################################
# 1. Table 2: mean and sd of all players by teams #
###################################################

# Team mean & SD
team_summary <- df %>%
  group_by(Team) %>%
  summarise(
    across(all_of(numeric_cols),
           ~ round(mean(.x, na.rm = TRUE), 1),
           .names = "{.col} mean"),
    across(all_of(numeric_cols),
           ~ round(sd(.x, na.rm = TRUE), 1),
           .names = "{.col} sd")
  )

mean_cols <- paste0(numeric_cols, " mean")
sd_cols   <- paste0(numeric_cols, " sd")

new_order <- as.vector(rbind(mean_cols, sd_cols))

team_summary <- team_summary %>%
  select(Team, all_of(new_order))

#write.csv(
#  team_summary,
#  here::here("results", "02_results", "02_team_summary.csv"),
#  row.names = FALSE
#)

# Save the table in html format
save_kable(
  kable(team_summary, format = "html") %>% 
    kable_styling(
      bootstrap_options = c("striped", "bordered", "hover"),
      full_width = FALSE,
      font_size = 13
    ) %>%
    column_spec(1, bold = TRUE),
  file = here::here("results", "02_results", "02_mean&sd_team.html")
)