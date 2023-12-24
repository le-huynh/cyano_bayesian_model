#---
# plot_tsi.R
#
# This Rscript:
# Plot temporal variation of TSI
#
# Dependencies...
# data/process/naga_data*.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/tsi.pdf
# results/figures/tsi.png
#---

library(here)
library(tidyverse)
library(lehuynh)

source("code/get_tidy_data.R")

# data #-----------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

# plot #----------------

tsi_plot = ggplot(naga42, aes(x = Time, y = TSI_chla)) +
	geom_boxplot(outlier.colour = NA,
		   width = .5) + 
	geom_jitter(alpha = 0.5,
		  width = 0.15,
		  #size = 2.5,
		  colour = "black") +
	ylab("TSI") +
	scale_x_discrete(name = "Collection time",
		       limits = c("5/2017",
		       	        "7/2017",
		       	        "8/2017",
		       	        "4/2018",
		       	        "5/2018")) +
	lehuynh_theme()

#width <- "one_column"
#height <- 240/3
#ggsave("results/figures/tsi.pdf",
#       tsi_plot,
#       width = width,
#       height = height)
#ggsave("results/figures/tsi.png",
#       tsi_plot,
#       width = width,
#       height = height)

