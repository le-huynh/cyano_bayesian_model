#---
# plot_env_multiple_dataset.R
#
# This Rscript:
# * Plot temporal variation in air temperature, rainfall for multiple datasets
# * Plot temporal variation in TSI
#
# Dependencies...
# data/process/naga_data*.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/env_facet_temp.pdf (+ .png)
# results/figures/env_facet_rainfall.pdf (+ .png)
# results/figures/env_tsi.pdf (+ .png)
#---

library(here)
library(tidyverse)
library(lubridate)
library(lehuynh)

source(here("code/func_env_multiple_dataset.R"))

# data #------------------------

df <- env_df(file_path = here("data/process"))

# info #------------------------------

date <- c(naga_data10 = "10 days",
	naga_data20 = "20 days",
	naga_data30 = "30 days",
	naga_data40 = "40 days",
	naga_data50 = "50 days",
	naga_data60 = "60 days",
	naga_data70 = "70 days",
	naga_data80 = "80 days",
	naga_data90 = "90 days",
	naga_data100 = "100 days")

width = "full_page"
height = 200

# Fig: rainfall #-------------------

fig_rain <- df %>%
	ggplot(aes(x = Time, y = Rain)) +
	geom_jitter(alpha = 0.35,
		  width = 0.175,
		  size = 1.25,
		  show.legend = FALSE) +
	facet_wrap(~ dataset,
		 ncol = 2,
		 labeller = labeller(dataset = date)) +
	labs(y = "Rainfall (mm)",
	     x = "") +
	theme_bw() +
	theme(axis.text = ggplot2::element_text(colour = "black"),
	      panel.grid = element_line(color = "gray98"))

ggsave_elsevier("results/figures/env_facet_rainfall.pdf",
	      fig_rain, 
	      width = width, 
	      height = height)
ggsave_elsevier("results/figures/env_facet_rainfall.png",
	      fig_rain, 
	      width = width, 
	      height = height)

# Fig: temperature #--------------------
temp_mean = df %>% 
	group_by(dataset, Time) %>%
	summarize(average = mean(siteTemp)) %>% 
	ungroup()

fig_temp <- df %>%	
	ggplot(aes(x = Time, y = siteTemp)) +
	geom_jitter(aes(color = dataset),
		  width = 0.175,
		  height = 0.1,
		  alpha = 0.25,
		  show.legend = FALSE) +
	geom_point(data = temp_mean,
		 aes(x = Time, y = average, color = dataset)) +
	geom_line(data = temp_mean, 
		mapping = aes(x = Time,
			    y = average,
			    group = dataset,
			    color = dataset)) +
	scale_color_discrete(labels = date) +
	labs(y = "Air temperature (\u00B0C)",
	     x = "",
	     color = "") + 
	lehuynh_theme() +
	theme(legend.position = "top")
	
ggsave_elsevier("results/figures/env_facet_temp.pdf",
	      fig_temp, 
	      width = width, 
	      height = height)
ggsave_elsevier("results/figures/env_facet_temp.png",
	      fig_temp, 
	      width = width, 
	      height = height)

# Fig: TSI #--------------------

source("code/get_tidy_data.R")

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42") %>%
	mutate(Time = format_ISO8601(samplingDate,
			         precision = "ym"))

fig_tsi <- ggplot(naga42, aes(x = Time, y = TSI_chla)) +
	geom_boxplot(outlier.colour = NA,
		   width = .5) + 
	geom_jitter(alpha = 0.5,
		  width = 0.15,
		  #size = 2.5,
		  colour = "black") +
	labs(y = "TSI",
	     x = "") +
	lehuynh_theme()

ggsave_elsevier("results/figures/env_tsi.pdf",
	      fig_tsi, 
	      width = "one_half_column", 
	      height = 120)
ggsave_elsevier("results/figures/env_tsi.png",
	      fig_tsi, 
	      width = "one_half_column", 
	      height = 120)

