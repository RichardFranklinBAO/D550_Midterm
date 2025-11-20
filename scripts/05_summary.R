# scripts/05_summary.R

library(here)

here::i_am("scripts/05_summary.R")

rmarkdown::render(
  input       = here::here("final", "summary.Rmd"),
  output_file = "summary.html",
  output_dir  = here::here("final"),
  envir       = new.env()
)


