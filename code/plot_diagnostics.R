#---
# plot_diagnostics.R
# 
# This plot
# - convert brms object to stan object
# - plot Kruschke's diagnostics plot for each parameter
# - save plot as .pdf
#
# Dependencies...
# data/rds/hurdle_logit/pc50_logit.rds
# data/rds/hurdle_logit/mcyb50_logit.rds
#
# Produces...
# results/figures/dia_.pdf
#---

library(here)
library(tidyverse)
library(coda)
library(CalvinBayes)
library(lehuynh)

source("code/func_diag.R")

# data #------------------------------
pc   = read_rds(here("data/rds/hurdle_logit/pc50_logit.rds")) %>%
	stanfit() %>%
	as.mcmc.list()
mcyb = read_rds(here("data/rds/hurdle_logit/mcyb50_logit.rds")) %>%
	stanfit() %>%
	as.mcmc.list()

# info #------------------------------
convert_mm_in = function(x) {x/25.4}

height_mm = 240/2
height_in = convert_mm_in(height_mm)
width_full_in      = convert_mm_in(190)
width_1half_col_in = convert_mm_in(140)
width_1col_in      = convert_mm_in(90)

par_name <- c("b_hu_Intercept",
	    "b_hu_ztemp",
	    "b_hu_zrain",
	    "b_hu_zTSI",
	    "b_Intercept",
	    "b_ztemp",
	    "b_zrain",
	    "b_zTSI")

title <- c("Intercept",
	 "Air temperature",
	 "Precipitation",
	 "TSI")
par_title <- c(paste("Logistic regression part:", title),
	     paste("Poisson regression part:", title))

par_code <- c("hu_intercept",
	    "hu_temp",
	    "hu_rainfall",
	    "hu_tsi",
	    "intercept",
	    "temp",
	    "rainfall",
	    "tsi")

para_list <- data.frame(par_name, par_title, par_code)

# PC #--------------------------------
for(i in seq_along(para_list$par_name)){

	file_name = paste0("results/figures/diag_pc_",
		         para_list[[i,3]], ".pdf")
	
	pdf(file_name,
	    width = width_full_in,
	    height = height_in)
	rv_diagMCMC(pc, 
		  parName = para_list[[i,1]], 
		  title = para_list[[i,2]])
	dev.off()
}

# mcyB #--------------------------------
for(i in seq_along(para_list$par_name)){
	
	file_name = paste0("results/figures/diag_mcyb_",
		         para_list[[i,3]], ".pdf")
	
	pdf(file_name,
	    width = width_full_in,
	    height = height_in)
	rv_diagMCMC(mcyb, 
		  parName = para_list[[i,1]], 
		  title = para_list[[i,2]])
	dev.off()
}

