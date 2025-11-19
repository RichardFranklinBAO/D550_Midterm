library(tidyverse)
library(broom)
library(yaml)

# ------------------------------------------------
# 1. Load config
# ------------------------------------------------
config <- yaml::read_yaml("config.yml")
team_filter <- config$team

# ------------------------------------------------
# 2. Load cleaned dataset
# ------------------------------------------------
dat_clean <- readRDS("results/01_dataclean.Rds")

# Apply team filter
if (team_filter != "ALL") {
  dat_clean <- dat_clean %>% filter(Team == team_filter)
}

# ------------------------------------------------
# 3. Fit regression model
# ------------------------------------------------
# 注意：FG% 必须用反引号
model <- lm(PTS ~ MP + Age + `FG%`, data = dat_clean)

model_glance <- glance(model)
model_tidy   <- tidy(model)

# ------------------------------------------------
# 4. Save outputs (results/04_results/)
# ------------------------------------------------
if (!dir.exists("results/04_results")) {
  dir.create("results/04_results")
}

saveRDS(model_glance, "results/04_results/model_glance.rds")
write.csv(model_glance, "results/04_results/model_glance.csv", row.names = FALSE)

saveRDS(model_tidy, "results/04_results/model_tidy.rds")
write.csv(model_tidy, "results/04_results/model_tidy.csv", row.names = FALSE)

# ------------------------------------------------
# 5. Print
# ------------------------------------------------
print(model_glance)
print(model_tidy)

