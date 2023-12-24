#---
# plot_logistic.R
#
# This Rscript:
# * plot logistic curves for Bayesian models (Pc gene, mcyB gene)
# * save file .pdf, .png
#
# Dependencies...
# data/process/naga_data50.csv
# data/rds/hurdle_logit/pc50_logit.rds
# data/rds/hurdle_logit/mcyb50_logit.rds
# code/get_tidy_data.R
#
# Produces...
# results/figures/logistic.pdf
# results/figures/logistic.png
#---

library(here)
library(tidyverse)
library(brms)
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

lengthout = 100
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

# function #-------------------
plot_logistic <- function(object,
		      newdata,
		      prob = 0.95,
		      legend = "top",
		      ytitle = "Presence probability of cyanobacteria"){

q1 = 0.5 - prob/2
q2 = 0.5 + prob/2
	
coef_df <- object %>% 
	posterior_summary(probs = c(q1, q2)) %>%
	as.data.frame() %>%
	rownames_to_column() %>%
	filter(str_detect(rowname, "b_hu_")) %>%
	sjmisc::rotate_df(cn = TRUE, rn = "curve") %>%
	rename_with(str_remove, starts_with("b_hu_"), "b_hu_")

estimate <- coef_df[1,]
estimate_df <- newdata %>% 
	mutate(logit = estimate$Intercept + estimate$zTSI * zTSI + estimate$zrain * zrain + estimate$ztemp * ztemp,
	       prob_absence = exp(logit) / (1 + exp(logit)),
	       prob_presence = 1 - prob_absence)

low <- coef_df[3,]
low_df <- newdata %>% 
	mutate(logit = low$Intercept + low$zTSI * zTSI + low$zrain * zrain + low$ztemp * ztemp,
	       prob_absence = exp(logit) / (1 + exp(logit)),
	       prob_presence = 1 - prob_absence)

high <- coef_df[4,]
high_df <- newdata %>% 
	mutate(logit = high$Intercept + high$zTSI * zTSI + high$zrain * zrain + high$ztemp * ztemp,
	       prob_absence = exp(logit) / (1 + exp(logit)),
	       prob_presence = 1 - prob_absence)

fig <- ggplot(data = estimate_df,
       aes(x = zTSI,
           y = prob_presence,
           color = factor(ztemp),
           linetype = factor(ztemp))) +
	geom_line() +
	facet_grid(~ zrain,
		 labeller = labeller(zrain = rain_labs)) +
	geom_ribbon(aes(ymin = low_df$prob_presence,
		      ymax = high_df$prob_presence),
		  alpha = 0.05,
		  color = NA) +
	labs(x = "\nTSI",
	     y = ytitle) +
	scale_x_continuous(breaks = zconTSI,
		         labels = conTSI) +
	scale_color_manual(name = "Temperature (\u00B0C)",
		         labels = newtemp,
		         values = c("blue", "green4", "red")) +
	scale_linetype_manual(name = "Temperature (\u00B0C)",
			  labels = newtemp,
			  values = c("solid", "dotted", "longdash")) +
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

fig_pc <- plot_logistic(object = pc, 
		newdata = newdata, 
		legend = "top",
		prob = prob,
		ytitle = expression(paste("Presence probability of total \n",
				      italic("Microcystis\n"))))

fig_mcyb <- plot_logistic(object = mcyb, 
		  newdata = newdata, 
		  legend = "none",
		  prob = prob,
		  ytitle = expression(paste("Presence probability of toxic \n",
		  		      italic("Microcystis\n"))))

fig = fig_pc / fig_mcyb +
	plot_annotation(tag_levels = 'A')

# save figures #---------------------------------
width <- "full_page"
height <- 220

ggsave_elsevier("results/figures/logistic.pdf",
	      fig,
	      width = width,
	      height = height)

ggsave_elsevier("results/figures/logistic.png",
	      fig,
	      width = width,
	      height = height)

