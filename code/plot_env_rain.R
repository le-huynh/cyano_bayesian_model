#---
# plot_temperature.R
#
# This Rscript:
# Plot temporal variation in precipitation
#
# Dependencies...
# data/process/naga_data*.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/rain.pdf
# results/figures/rain.png
#---

library(here)
library(tidyverse)
library(lehuynh)

source("code/get_tidy_data.R")

# data #-----------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

# plot #-----------------------

rain_plot = ggplot(naga42, aes(x = Time, y = Rain)) +
	geom_jitter(alpha = 0.35,
		  width = 0.175,
		  #size = 2.5,
		  colour = "black") +
	scale_x_discrete(name = "Collection time",
		       limits = c("5/2017",
		       	        "7/2017",
		       	        "8/2017", 
		       	        "4/2018", 
		       	        "5/2018")) +
	ylab("Precipitation (mm)") +
	lehuynh_theme()

#width <- "one_column"
#height <- 240/3
#ggsave_elsevier("results/figures/rain.pdf",
#	      rain_plot,
#	      width = width,
#	      height = height)
#ggsave_elsevier("results/figures/rain.png",
#	      rain_plot,
#	      width = width,
#	      height = height)

