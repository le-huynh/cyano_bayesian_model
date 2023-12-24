# Rule
# target : prerequisite1 prerequisite2 prerequisite3
#	(tab)recipe

.PHONY: all clean

################################################################################
# 
# Part 1: Data for data analysis
# 
# Run scripts to generate dataset for data analysis
# 
################################################################################

data/process/naga_data50.csv: \
code/get_naga_data.R\
code/climate_windFun.R\
code/climate_rainFun.R\
code/climate_tempFun.R\
code/climate_dfFun.R\
data/process/naga_data01.csv
	Rscript code/get_naga_data.R

################################################################################
# 
# Part 2: Fitting Bayesian models
# 
# Run scripts to fit models (never directly run via `GNUmake`)
# 
################################################################################

# data/rds/PC*.rds data/rds/mcyB*.rds: \
# code/bayes_hurdle_*.R\
# data/process/naga_data*.csv
#	Rscript code/bayes_hurdle_*.R

#data/rds/fit*.rds: \
#code/get_fitted_data.R\
#data/process/naga_data50.csv\
#data/rds/PC*.rds\
#data/rds/mcyb*.rds
#	Rscript code/get_fitted_data.R


################################################################################
# 
# Part 3: Figure and table generation
# 
# Run scripts to generate figures
# 
################################################################################

results/figures/site_map.pdf:\
code/plot_site_map.R\
data/Japan_shapefile/jpn_admbnda_adm1_2019.shp
	Rscript code/plot_site_map.R

results/figures/site.pdf: \
code/plot_site.R\
data/process/naga_data02.csv
	Rscript code/plot_site.R

results/figures/env_factor.pdf: \
code/plot_env_factor.R\
code/plot_env_temp.R\
code/plot_env_tsi.R\
code/plot_env_rain.R\
code/get_tidy_data.R\
data/process/naga_data50.csv
	Rscript code/plot_env_factor.R

results/figures/env_facet_temp.pdf results/figures/env_facet_rainfall.pdf results/figures/env_tsi.pdf: \
code/plot_env_multiple_dataset.R\
code/get_tidy_data.R\
data/process/naga_data*.csv
	Rscript code/plot_env_multiple_dataset.R

results/figures/pc_mcyb.pdf: \
code/plot_PC_mcyB.R\
code/get_tidy_data.R\
data/process/naga_data50.csv
	Rscript code/plot_PC_mcyB.R

results/figures/ppc.pdf: \
code/plot_ppc.R\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds
	Rscript code/plot_ppc.R

results/figures/posterior_pc.pdf results/figures/posterior_mcyb.pdf: \
code/plot_posterior.R\
code/func_posterior.R\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds
	Rscript code/plot_posterior.R

results/figures/heatmap_pc.pdf results/figures/heatmap_mcyb.pdf: \
code/plot_heatmap.R\
code/get_tidy_data.R\
data/rds/fitted_data/fit_pc50_logit.rds\
data/rds/fitted_data/fit_mcyb50_logit.rds\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds\
data/process/naga_data50.csv
	Rscript code/plot_heatmap.R

results/figures/logistic.pdf: \
code/plot_logistic.R\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds\
data/process/naga_data50.csv
	Rscript code/plot_logistic.R

results/figures/predict.pdf: \
code/plot_predict.R\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds\
data/process/naga_data50.csv
	Rscript code/plot_predict.R

results/figures/diag_pc_tsi.pdf results/figures/diag_mcyb_tsi.pdf: \
code/plot_diagnostics.R\
code/func_diag.R\
data/rds/hurdle_logit/pc50_logit.rds\
data/rds/hurdle_logit/mcyb50_logit.rds
	Rscript code/plot_diagnostics.R

results/figures/limnology.pdf: \
code/plot_env_limnology.R\
code/get_tidy_data.R\
data/process/naga_data50.csv
	Rscript code/plot_env_limnology.R

results/figures/kfoldic_logit.pdf: \
code/plot_kfold_logit.R\
code/func_kfold_df.R\
code/func_kfold_plot.R\
data/rds/hurdle_logit/pc*.rds\
data/rds/hurdle_logit/mcyb*.rds
	Rscript code/plot_kfold_logit.R

results/figures/kfoldic_poisson.pdf: \
code/plot_kfold_poisson.R\
code/func_kfold_df.R\
code/func_kfold_plot.R\
data/rds/hurdle_poisson/pc*.rds\
data/rds/hurdle_poisson/mcyb*.rds
	Rscript code/plot_kfold_poisson.R

################################################################################
# 
# Part 4: Pull it all together
# 
# Render the manuscript
# 
################################################################################

submission/figure_table.pdf:\
submission/figure_table.Rmd\
results/pictures/sitemap_paper.pdf\
results/figures/pc_mcyb.pdf\
results/figures/kfoldic_logit.pdf\
results/figures/posterior_pc.pdf\
results/figures/posterior_mcyb.pdf\
results/figures/logistic.pdf\
results/figures/predict.pdf\
results/figures/heatmap_mcyb.pdf
	Rscript -e 'rmarkdown::render("$<", output_format = "all")'

submission/appendix.pdf:\
submission/appendix.Rmd\
code/get_tidy_data.R\
data/process/naga_data50.csv\
results/figures/env_facet_temp.pdf\
results/figures/env_facet_rainfall.pdf\
results/figures/env_tsi.pdf\
results/figures/ppc.pdf\
results/figures/kfoldic_poisson.pdf\
results/figures/diag_pc_tsi.pdf\
results/figures/diag_mcyb_tsi.pdf
	Rscript -e 'rmarkdown::render("$<", output_format = "all")'

submission/manuscript.pdf: \
submission/manuscript.Rmd\
submission/abstract.Rmd\
submission/interest.Rmd\
submission/credit.Rmd\
submission/thanks.Rmd\
submission/highlight.Rmd\
submission/figure_table.Rmd\
submission/appendix.Rmd\
submission/my_header.tex\
data/process/naga_data50.csv\
submission/science-of-the-total-environment.csl\
submission/naga01.bib
	Rscript -e 'rmarkdown::render("$<", output_format = "all")'

all: submission/manuscript.pdf


