#---
# plot_heatmap.R
#
# This Rscript:
# generate heatmap -> Probabilities of exceeding threshold levels of 
# - total Microcystis (PC)
# - toxic Microcystis (mcyB)
#
# Dependencies...
# data/rds/fitted_data/fit_pc50_logit.rds
# data/rds/fitted_data/fit_mcyb50_logit.rds
# data/process/naga_data50.csv
# code/get_tidy_data.R
# code/get_fitted_data.R
#
# Produces...
# results/figures/heatmap.pdf
# results/figures/heatmap.png
#---
library(here)
library(tidyverse)
library(patchwork)
library(lehuynh)

source(here("code", "get_tidy_data.R"))

# data #------------------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

# fitted data
fit_pc = read_rds(here("data/rds/fitted_data/fit_pc50_logit.rds")) %>%
	gather(threshold, value, thres1:thres4)

fit_mcyb = read_rds(here("data/rds/fitted_data/fit_mcyb50_logit.rds")) %>%
	gather(threshold, value, thres1:thres4)

# info #---------------------
newtemp = c(10, 30)
newrain = c(250, 375, 475, 600)
newtsi  = c(37, 89)
znewtemp = round(MinMaxScaling(x = newtemp, y = naga42$siteTemp), digits = 4)
znewrain = round(MinMaxScaling(x = newrain, y = naga42$Rain), digits = 4)
znewtsi  = round(MinMaxScaling(x = newtsi,  y = naga42$TSI_chla), digits = 4)

conTemp = c(10, 15, 20, 25, 30)
conTSI  = c(39, 49, 59, 69, 79, 89)
zconTemp = round(MinMaxScaling(conTemp, naga42$siteTemp), digits = 4)
zconTSI  = round(MinMaxScaling(conTSI, naga42$TSI_chla), digits = 4)

# threshold levels (cells/mL)
thres1 = 200
thres2 = 2000
thres3 = 20000
thres4 = 100000

thres = c(thres1, thres2, thres3, thres4)

# New facet label names for rainfall variable
rain_labs <- c(paste("Rainfall:", newrain, "mm"))
names(rain_labs) <- znewrain

options(scipen = 999)
thres_labs <- c(paste(">", thres, "cells/mL"))
names(thres_labs) <- c("thres1", "thres2", "thres3", "thres4")

# fig: height + width
width = "full_page"
height_pc = 220
height_mcyb = (240/3)*2

# func #---------------------------
heatmap = function(object) {
	
	heatmap = object %>%          
		ggplot(aes(x = ztemp, y = zTSI, fill = value)) +
		geom_raster(interpolate = T) +
		facet_grid(threshold ~ zrain,
			 labeller = labeller(zrain = rain_labs,
			 		 threshold = thres_labs)) + 
		scale_fill_viridis_c(option = "A",
				 limits = c(0,1)) +
		labs(x = "\nAir temperature (\u00B0C)",
		     y = "TSI\n",
		     fill = "Probability") +
		scale_x_continuous(breaks = zconTemp,
			         labels = conTemp,
			         expand = c(0,0)) +
		scale_y_continuous(breaks = zconTSI,
			         labels = conTSI,
			         expand = c(0,0)) +
		theme(legend.position = "top",
		      legend.key.width = unit(1.75, "cm"),
		      legend.box.margin = margin(-5, -10, -10, -10),
		      axis.text.y = element_text(color = "black"),
		      axis.text.x = element_text(color = "black", 
		      		             angle = 90,
		      		       	   vjust = 0.5,
		      		       	   hjust = 0),
		      strip.text = element_text(size = 10),
		      panel.spacing.x = unit(2.5, "mm"),
		      panel.border = element_rect(color = "black", 
		      		              fill = NA)
		      )
	
	heatmap
}

# plot PC #-------------------------
fig_pc = heatmap(fit_pc)

ggsave_elsevier("results/figures/heatmap_pc.pdf",
	      fig_pc,
	      width = width,
	      height = height_pc)
ggsave_elsevier("results/figures/heatmap_pc.png",
	      fig_pc,
	      width = width,
	      height = height_pc)

# plot mcyB #---------------------------------
fig_mcyb = fit_mcyb %>%
	filter(threshold != "thres4") %>%
	heatmap()

ggsave_elsevier("results/figures/heatmap_mcyb.pdf",
	      fig_mcyb,
	      width = width,
	      height = height_mcyb)
ggsave_elsevier("results/figures/heatmap_mcyb.png",
	      fig_mcyb,
	      width = width,
	      height = height_mcyb)


