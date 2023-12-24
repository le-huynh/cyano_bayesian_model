#---
# plot_kfold_poisson.R
#
# This Rscript:
# * plot kfoldic vs models (including SE): PC models (A), mcyB models (B) for
# 50-day prior to sampling date
# * save in .pdf, .png
#
# Dependencies...
# data/rds/hurdle_poisson/pc*.rds
# data/rds/hurdle_poisson/mcyb*.rds
#
# Produces...
# results/figures/kfoldic_poisson.pdf
# results/figures/kfoldic_poisson.png
#---
library(here)
library(tidyverse)
library(patchwork)

source(here("code/func_kfold_df.R"))
source(here("code/func_kfold_plot.R"))

# data #-------------------

file_path <- here("data/rds/hurdle_poisson/")

df_pc <- kfold_df(file_path = file_path,
	        input_pattern = "pc",
	        remove_pattern = ".rds")

df_mcyb <- kfold_df(file_path = file_path,
		input_pattern = "mcyb",
		remove_pattern = ".rds")

model_list <- data.frame(distinct(df_pc, name),
		     distinct(df_mcyb, name),
		     label = c("temperature + rainfall + TSI",
		     	     "rainfall",
			     "rainfall + TSI",
			     "temperature",
			     "temperature + rainfall",
			     "temperature + TSI",
			     "TSI")) %>%
	rename(pc = name,
	       mcyb = name.1)

# plot #-----------------------

fig_pc <- df_pc %>%
	filter(term == "kfoldic") %>%
	mutate(name = fct_reorder(name, Estimate)) %>%
	kfold_plot(ytitle = "Model (total cyanobacteria)",
		 coord_flip = FALSE,
		 model_name = model_list$pc,
		 model_label = model_list$label) +
	scale_x_log10()

fig_mcyb <- df_mcyb %>%
	filter(term == "kfoldic") %>%
	mutate(name = fct_reorder(name, Estimate)) %>%
	kfold_plot(ytitle = "Model (toxic cyanobacteria)",
		 coord_flip = FALSE,
		 model_name = model_list$mcyb,
		 model_label = model_list$label) +
	scale_x_log10()

fig <- fig_pc / fig_mcyb +
	plot_annotation(tag_levels = 'A')

# save plot #--------------------------
width = "one_half_column"
height = 200

ggsave_elsevier("results/figures/kfoldic_poisson.pdf",
	      fig,
	      width = width,
	      height = height)
ggsave_elsevier("results/figures/kfoldic_poisson.png",
	      fig,
	      width = width,
	      height = height)

