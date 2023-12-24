#---
# plot_limnology.R
#
# This Rscript:
# Plot limnological characteristics of samples
#
# Dependencies...
# data/process/naga_data50.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/limnology.pdf
# results/figures/limnology.png
#---

library(tidyverse)
library(lehuynh)

source("code/get_tidy_data.R")

# data #--------------------------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42") %>%
	mutate(NOx = NO2 + NO3) %>%
	select(Chla, NO2, NO3, NH4, PO4) %>% 
	log10() %>%
	gather(para_name, log10_value)

# info #--------------------------------
title <- labs(x = "",
	    y = "Value")

var <- c("Chla", "NO2", "NO3", "NH4", "PO4")
xlabel <- scale_x_discrete(
	limits = var,
	labels = c("Chla" = expression(atop(Chlorophyll-a, 
				      paste("(", mu, "g/L)"))),
		 "NO2" = expression(atop(N-NO[2], "(mg/L)")),
		 "NO3" = expression(atop(N-NO[3], "(mg/L)")),
		 "NH4" = expression(atop(N-NH[4], "(mg/L)")),
		 "PO4" = expression(atop(P-PO[4], "(mg/L)"))
	))

ylabel <- scale_y_discrete(limits = c(-3, -2, -1, 0, 1, 2),
		       labels = c("-3" = expression(10^-3),
		       	        "-2" = expression(10^-2),
		        	        "-1" = expression(10^-1),
		        	        "0"  = expression(10^0),
		        	        "1"  = expression(10^1),
		        	        "2"  = expression(10^2)))

cbbPalette <- c(#"#000000", 
	      "#E69F00", 
	      "#56B4E9", 
	      "#009E73", 
	      #"#F0E442", 
	      #"#0072B2", 
	      "#D55E00", 
	      "#CC79A7")

gr_fill <- scale_fill_manual(breaks = var, 
		         values = cbbPalette)

gr_col <- scale_color_manual(breaks = var, 
		         values = cbbPalette)

# plot #-----------------------------
env_plot = ggplot(naga42, aes(x = para_name, y = log10_value)) +
	geom_boxplot(aes(col = para_name,
		       fill = para_name,
		       alpha = 0.25),
		   outlier.colour = NA,
		   show.legend = FALSE) + 
	geom_jitter(aes(col = para_name), 
		  alpha = 0.75,
		  width = 0.15,
		  show.legend = FALSE) +
	title + 
	xlabel +
	ylabel +
	gr_fill +
	gr_col +
	lehuynh_theme()

# save plot #-----------------------

width <- "full_page"
height <- 240/2

ggsave_elsevier("results/figures/limnology.pdf",
	      env_plot,
	      width = width,
	      height = height)

ggsave_elsevier("results/figures/limnology.png",
	      env_plot,
	      width = width,
	      height = height)

