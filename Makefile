all: report

# 01: data cleaning
results/01_dataclean.Rds: scripts/01_cleaning.R data/nba_2025-10-30.csv
	Rscript scripts/01_cleaning.R

# 02: exploration - produce HTML table
results/02_results/02_mean_sd_all.html: scripts/02_exploration.R results/01_dataclean.Rds
	Rscript scripts/02_exploration.R
	
# 03: visualization
results/03_results/hist_pts.png: scripts/03_Visualization.R results/01_dataclean.Rds
	Rscript scripts/03_Visualization.R

# 04: modeling
results/04_results/04_modeling.Rds: scripts/04_modeling.R results/01_dataclean.Rds
	Rscript scripts/04_modeling.R

report: results/02_results/02_mean_sd_all.html results/03_results/hist_pts.png results/04_results/04_modeling.Rds
	Rscript -e "rmarkdown::render('final_docs/report.Rmd')"
	
.PHONY: clean
clean:
	rm -f results/*.Rds results/02_results/*.html results/03_results/*.png results/04_results/*.csv results/04_results/*.Rds final_docs/*.html