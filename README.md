````markdown
# DATA 550 — Midterm Team Project
## NBA Per-36 Minutes Report (2025–26)

This repository contains a reproducible pipeline that ingests NBA per-36 stats, cleans the data, produces a “Table 1” summary, generates figures, fits a simple regression, and renders a final HTML report. The workflow is parameterized via `config.yml` so the report can be customized to a specific team or run on the full dataset.

### Data
* `data/nba_2025-10-30.csv`: Player per-36 stats (source: Basketball-Reference).
* `data/nba_codebook.xlsx`: Variable descriptions.

### Repository Layout

```text
.
├── config.yml                    # customization (e.g., team: "ALL" | "ATL" | ...)
├── Makefile                      # build rules
├── scripts/
│   ├── 01_cleaning.R             # read data, clean, subset by team -> results/01_dataclean.Rds
│   ├── 02_exploration.R          # creates summary table -> results/02_results/summary_table.html
│   ├── 03_visualization.R        # creates figures -> results/03_results/*.png
│   ├── 04_modeling.R             # fits lm(PTS ~ MP + Age + FG%) -> results/model_glance.rds
│   └── 05_summary.R              # exports model glance -> results/model_glance.csv
├── results/
│   ├── 01_dataclean.Rds
│   ├── 02_results/summary_table.html         # REQUIRED TABLE (see below)
│   └── 03_results/                           # REQUIRED FIGURES (see below)
└── final_docs/
    └── report.Rmd -> report.html
````

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

```bash
# build everything (cleaning -> table -> figures -> model -> HTML report)
make report

# the final report will be at:
# final_docs/report.html
```

Alternatively, inside R:

```r
renv::restore()
system("make report")
```

### How to Customize the Report

Edit `config.yml`:

```yaml
team: "ALL"      # options: "ALL" for full dataset, or a team code like "ATL"
```

  * `team: "ALL"` – runs all steps on all 421 players.
  * `team: "ATL"` – filters to that team before generating outputs (table, figures, model).

**To apply changes:** Re-build with `make report`.

### Where the REQUIRED Outputs are Created

#### Required Table

  * **Path:** `results/02_results/summary_table.html`
  * **Created by:** `scripts/02_exploration.R`
  * **Content:** “Table 1” style summary (N, mean/SD of age, PTS, 3P%, FT%), respecting `config.yml$team`.

#### Required Figures

All created by `scripts/03_visualization.R`.

  * `results/03_results/hist_pts.png`: Histogram of PTS (distribution).
  * `results/03_results/box_pts_position.png`: Boxplot of PTS by position.
  * `results/03_results/top10_pts_bar.png`: Top-10 players by PTS (bar chart).
  * `results/03_results/scatter_mp_pts.png`: Scatterplot MP vs PTS (colored by team).

*Note: These artifacts are automatically included in `final_docs/report.html`.*

### Makefile Targets (Quick Reference)

  * `make report`: Full pipeline -\> `final_docs/report.html`
  * `make clean`: Remove derived outputs (`results/*`, `final_docs/*.html`)

### Contributing (Team Workflow)

1.  Fork the repo → clone your fork.
2.  Run `renv::restore()` to install packages.
3.  Create a feature branch (e.g., `feat/visualization-<name>`) and implement changes in `scripts/`.
4.  Ensure `make report` succeeds locally.
5.  Commit & push your branch, open a Pull Request to main.

*If you add packages, run `renv::snapshot()` in your branch so others can `renv::restore()`.*

### Troubleshooting

  * If `make report` fails due to missing packages, run `renv::restore()` in R and retry.
  * Ensure file names in `data/` match what `scripts/01_cleaning.R` expects (default: `nba_2025-10-30.csv`).

-----
