#---
# plot_predict.R
#
# This Rscript:
# generate plot -> Predict cyanobacterial abundance (copies/mL) of
# - total Microcystis (PC)
# - toxic Microcystis (mcyB)
#
# Dependencies...
# data/rds/hurdle_logit/pc50_logit.rds
# data/rds/hurdle_logit/mcyb50_logit.rds
# data/process/naga_data50.csv
#
# Produces...
# results/figures/predict.pdf
# results/figures/predict.png
#---
library(here)
library(tidyverse)
library(patchwork)
library(lehuynh)

source(here("code", "get_tidy_data.R"))

# data #------------------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

pc   = read_rds(here("data/rds/hurdle_logit/pc50_logit.rds"))
mcyb = read_rds(here("data/rds/hurdle_logit/mcyb50_logit.rds"))

# fitted data + info #---------------------
newtemp = c(10, 20, 30)
newrain = c(250, 425, 600)
newtsi  = c(37, 89)
znewtemp = round(MinMaxScaling(x = newtemp, y = naga42$siteTemp), digits = 4)
znewrain = round(MinMaxScaling(x = newrain, y = naga42$Rain), digits = 4)
znewtsi  = round(MinMaxScaling(x = newtsi,  y = naga42$TSI_chla), digits = 4)

lengthout = 50
newdata = crossing(ztemp = znewtemp,
	         zTSI = seq(from = min(znewtsi),
	         		to = max(znewtsi),
	         		length.out = lengthout),
	         zrain = znewrain)

#info
conTSI = c(39, 49, 59, 69, 79, 89)
zconTSI = round(MinMaxScaling(conTSI, naga42$TSI_chla), digits = 4)

# New facet label names for variable rainfall
rain_labs <- c(paste0("Rainfall: ", newrain, " mm")) 
names(rain_labs) <- znewrain

options(scipen = 999)

# func #-------------------------
cond_func = function(object,
		 newdata,
		 prob = 0.95,
		 legend = "top",
		 ylab = "Estimated cyanobacteria (cells/mL)")
{
q1 = 0.5 - prob/2
q2 = 0.5 + prob/2

fit = fitted(object = object,
	   newdata = newdata,
	   re_formula = NA,
	   probs = c(q1, q2)) %>%
	as_tibble() %>%
	bind_cols(newdata)

fig = ggplot(data = fit, 
	   mapping = aes(x = zTSI,
	   	       y = Estimate,
	    	       color = factor(ztemp),
	    	       linetype = factor(ztemp))) +
	geom_line() + 
	geom_ribbon(aes(ymin = fit[[3]],
		      ymax = fit[[4]],
		      fill = factor(ztemp)),
		  alpha = 0.2,
		  color = NA) +
	facet_wrap(~ zrain,
		 labeller = labeller(zrain = rain_labs)) +
	labs(x = "\nTSI",
	     y = ylab) +
	scale_x_continuous(breaks = zconTSI,
		         labels = conTSI) +
	scale_color_manual(name = "Temperature (\u00B0C)",
		         labels = newtemp,
		         values = c("blue", "green3", "red")) +
	scale_linetype_manual(name = "Temperature (\u00B0C)",
			  labels = newtemp,
			  values = c("solid", "dotted", "longdash")) +
	scale_fill_manual(name = "Temperature (\u00B0C)",
		        labels = newtemp,
		        values = c("blue", "green3", "red")) +
	theme_bw() +
	theme(legend.position = legend,
	      legend.key.width = unit(1.5, "cm"),
	      legend.box.margin = margin(-10, -10, -5, -10),
	      axis.text = element_text(color = "black"),
	      strip.text.x = element_text(size = 10),
	      panel.grid = element_line(color = "gray99"),
	      panel.border = element_rect(color = "black", 
				    fill = NA, 
				    size = 0.5))
fig
}	

# plot #---------------------------------
prob = 0.5

cellpc = c(0, 50000, 100000, 200000, 300000, 400000)
fig_pc <- cond_func(object = pc, 
	       newdata = newdata, 
	       legend = "top",
	       prob = prob,
	       ylab = expression(paste("PC gene as total ",
	       		    italic("Microcystis"),
	       		    " (copies/mL)"))) +
	scale_y_continuous(breaks = cellpc,
		         labels = cellpc)

cellmc = c(0, 5000, 10000, 20000, 40000, 60000)
fig_mcyb <- cond_func(object = mcyb, 
	       newdata = newdata, 
	       legend = "none",
	       prob = prob,
	       ylab = expression(paste(italic("mcyB"),
	       		    " gene as toxic ",
	       		    italic("Microcystis"),
	       		    " (copies/mL)"))) +
	scale_y_continuous(breaks = cellmc,
		         labels = cellmc)

fig = fig_pc / fig_mcyb +
	plot_annotation(tag_levels = 'A')

# save figures #---------------------------------
width <- "full_page"
height <- 220
ggsave_elsevier("results/figures/predict.pdf",
	      fig,
	      width = width,
	      height = height)
ggsave_elsevier("results/figures/predict.png",
	      fig,
	      width = width,
	      height = height)
