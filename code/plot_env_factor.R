#---
# plot_env_factor.R
#
# This Rscript:
# Plot temporal variation in air temperature (A), TSI (B), 
# and rainfall (C)
#
# Dependencies...
# code/plot_env_temp.R
# code/plot_env_tsi.R
# code/plot_env_rain.R
#
# Produces...
# results/figures/env_factor.pdf
# results/figures/env_factor.png
#---

library(patchwork)
library(lehuynh)

source("code/plot_env_temp.R")
source("code/plot_env_tsi.R")
source("code/plot_env_rain.R")

env_plot = temp_plot + 
	 rain_plot + 
	 tsi_plot +
	 plot_layout(ncol = 1) +
	 plot_annotation(tag_levels = 'A')

width <- "one_column"
height <- 200
ggsave_elsevier("results/figures/env_factor.pdf",
	      env_plot, 
	      width = width, 
	      height = height)
ggsave_elsevier("results/figures/env_factor.png",
	      env_plot, 
	      width = width, 
	      height = height)
