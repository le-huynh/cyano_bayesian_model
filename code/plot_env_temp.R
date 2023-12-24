#---
# plot_temperature.R
#
# This Rscript:
# Plot temporal variation in air temperature
#
# Dependencies...
# data/process/naga_data*.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/temperature.pdf
# results/figures/temperature.png
#---

library(here)
library(tidyverse)
library(lehuynh)

source("code/get_tidy_data.R")

# data #-----------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

temp_mean = naga42 %>% 
	group_by(Time) %>%
	summarize(average = mean(siteTemp)) %>% 
	ungroup()

# plot #-------------------------
temp_plot = ggplot(naga42, aes(x = Time, y = siteTemp)) +
	geom_point(data = temp_mean,
		 mapping = aes(x = Time, y = average),
		 color="NA") +
	geom_line(data = temp_mean, 
		mapping = aes(x = Time, y = average, group = 1),
		linetype = "dotdash") +
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
	ylab("Air temperature (\u00B0C)") +
	lehuynh_theme()

#width <- "one_column"
#height <- 240/3
#ggsave_elsevier("results/figures/temperature.pdf",
#	      temp_plot,
#	      width = width,
#	      height = height)
#ggsave_elsevier("results/figures/temperature.png",
#	      temp_plot,
#	      width = width,
#	      height = height)

