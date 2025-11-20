# DATA 550 — Midterm Team Project

## NBA Per-36 Minutes Report (2025–26)

This repository contains a reproducible pipeline that ingests NBA per-36 player stats, cleans data, produces a “Table 1” style summary, generates figures, fits a simple regression, and renders a final HTML report.\
**Customization** is controlled via `config.yml` (e.g., run on ALL teams or a specific team).

------------------------------------------------------------------------

## Data

-   `data/nba_2025-10-30.csv` — Player per-36 minute stats (Basketball-Reference snapshot).
-   `data/nba_codebook.xlsx` — Variable dictionary.

> Data are versioned in the repo for grading. If your institution restricts data sharing, replace with a same-schema synthetic file.

------------------------------------------------------------------------

## Repository Layout

``` text
.
├── config.yml                    # customization (team filter etc.)
├── Makefile                      # build rules (see below)
├── scripts/
│   ├── 01_cleaning.R             # read, clean, standardize -> results/01_dataclean.Rds
│   ├── 02_exploration.R          # summary table -> results/02_results/summary_table.html
│   ├── 03_visualization.R        # figures -> results/03_results/*.png
│   ├── 04_modeling.R             # lm(PTS ~ MP + Age + FG%) -> results/model_glance.rds/csv
│   └── 05_summary.R              # (optional) exports model glance table
├── results/
│   ├── 01_dataclean.Rds
│   ├── 02_results/
│       ├── 02_mean&sd_all.html                # REQUIRED TABLE 1
│       ├── 02_mean&sd_team.html               # REQUIRED TABLE 2
│   └── 03_results/
│       ├── hist_pts.png                       # REQUIRED FIGURE 1
│       ├── box_pts_position.png               # REQUIRED FIGURE 2
│       ├── top10_pts_bar.png                  # REQUIRED FIGURE 3
│       └── scatter_mp_pts.png                 # REQUIRED FIGURE 4
└── final_docs/
    ├── report.Rmd                             # composes all outputs
    └── report.html                            # final artifact (built)

### Requirements

  * **R ≥ 4.3**
  * We use **renv** for package management. First time on a new machine:

<!-- end list -->

```r
install.packages("renv")   # if needed
renv::restore()            # installs exact package versions from renv.lock
```

### How to Build the Report

From the repository root (terminal):

``` bash
# build everything (cleaning -> table -> figures -> model -> HTML report)
make report

# the final report will be at:
# final_docs/report.html
```

Alternatively, inside R:

``` r
renv::restore()
system("make report")
```

### How to Customize the Report

Edit `config.yml`:

``` yaml
team: "ALL"      # options: "ALL" for full dataset, or a team code like "ATL"
```

-   `team: "ALL"` – runs all steps on all 421 players.
-   `team: "ATL"` – filters to that team before generating outputs (table, figures, model).

**To apply changes:** Re-build with `make report`.

### Where the REQUIRED Outputs are Created

#### Required Table

-   **Path:** `results/02_results/summary_table.html`
-   **Created by:** `scripts/02_exploration.R`
-   **Content:** “Table 1” style summary (N, mean/SD of age, PTS, 3P%, FT%), respecting `config.yml$team`.

#### Required Figures

All created by `scripts/03_visualization.R`.

-   `results/03_results/hist_pts.png`: Histogram of PTS (distribution).
-   `results/03_results/box_pts_position.png`: Boxplot of PTS by position.
-   `results/03_results/top10_pts_bar.png`: Top-10 players by PTS (bar chart).
-   `results/03_results/scatter_mp_pts.png`: Scatterplot MP vs PTS (colored by team).

*Note: These artifacts are automatically included in `final_docs/report.html`.*

### Makefile Targets (Quick Reference)

-   `make report`: Full pipeline -\> `final_docs/report.html`
-   `make clean`: Remove derived outputs (`results/*`, `final_docs/*.html`)

### Contributing (Team Workflow)

1.  Fork the repo → clone your fork.
2.  Run `renv::restore()` to install packages.
3.  Create a feature branch (e.g., `feat/visualization-<name>`) and implement changes in `scripts/`.
4.  Ensure `make report` succeeds locally.
5.  Commit & push your branch, open a Pull Request to main.

*If you add packages, run `renv::snapshot()` in your branch so others can `renv::restore()`.*

### Troubleshooting

-   If `make report` fails due to missing packages, run `renv::restore()` in R and retry.
-   Ensure file names in `data/` match what `scripts/01_cleaning.R` expects (default: `nba_2025-10-30.csv`).

------------------------------------------------------------------------
