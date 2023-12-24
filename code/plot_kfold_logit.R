#---
# plot_kfold_logit.R
#
# This Rscript:
# * plot kfoldic vs days (including SE): PC models (A), mcyB models (B) for
# x-day prior to sampling date
# * save in .pdf, .png
#
# Dependencies...
# code/func_kfold_df.R
# code/func_kfold_plot.R
# data/rds/hurdle_logit/pc*.rds
# data/rds/hurdle_logit/mcyb*.rds
#
# Produces...
# results/figures/kfoldic_logit.pdf
# results/figures/kfoldic_logit.png
#---

library(here)
library(tidyverse)
library(patchwork)

source(here("code/func_kfold_df.R"))
source(here("code/func_kfold_plot.R"))

# data #-------------------

file_path <- here("data/rds/hurdle_logit/")

df_pc <- kfold_df(file_path = file_path,
	        input_pattern = "pc",
	        remove_pattern = "_logit.rds")

df_mcyb <- kfold_df(file_path = file_path,
		input_pattern = "mcyb",
		remove_pattern = "_logit.rds")

# plot #-----------------------

fig_pc <- df_pc %>%
	filter(term == "kfoldic") %>%
	mutate(name = factor(name, paste0("pc", seq(10, 100, by = 10)))) %>%
	kfold_plot(ytitle = "",
		 title = expression(paste(bold("A"),
		 		     " Total ",
		 		     italic("Microcystis"))),
		 model_name = paste0("pc", seq(10, 100, by = 10)),
		 model_label = paste(seq(10, 100, by = 10), "days"),
		 axis.text.x = element_text(angle = 45, hjust = 0.9),
		 plot.title.position = "plot") +
	scale_x_log10()

fig_mcyb <- df_mcyb %>%
	filter(term == "kfoldic") %>%
	mutate(name = factor(name, paste0("mcyb", seq(10, 100, by = 10)))) %>%
	kfold_plot(ytitle = "",
		 title = expression(paste(bold("B"),
		 		     " Toxic ",
		 		     italic("Microcystis"))),
		 model_name = paste0("mcyb", seq(10, 100, by = 10)),
		 model_label = paste(seq(10, 100, by = 10), "days"),
		 axis.text.x = element_text(angle = 45, hjust = 0.9),
		 plot.title.position = "plot") +
	scale_x_log10()

fig <- fig_pc / fig_mcyb

# save plot #--------------------------
width = "one_half_column"
height = 200

ggsave_elsevier("results/figures/kfoldic_logit.pdf",
	      fig,
	      width = width,
	      height = height)
ggsave_elsevier("results/figures/kfoldic_logit.png",
	      fig,
	      width = width,
	      height = height)

