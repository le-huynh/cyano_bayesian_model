#---
# get_fitted_data.R
#
# This Rscript:
# - generate fitted data to plot heatmap -> 
# --> Probabilities of exceeding threshold levels of 
# + total Microcystis (PC)
# + toxic Microcystis (mcyB)
# - save .rds objects
#
# Dependencies...
# data/process/naga_data50.csv
# data/rds/hurdle_logit/pc50_logit.rds
# data/rds/hurdle_logit/mcyb50_logit.rds
#
# Produces...
# data/rds/fitted_data/fit_pc50_logit.rds
# data/rds/fitted_data/fit_mcyb50_logit.rds
#---

library(here)
library(tidyverse)
library(lehuynh)

source(here("code", "get_tidy_data.R"))

# data #------------------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

pc   = read_rds(here("data/rds/hurdle_logit/pc50_logit.rds"))
mcyb = read_rds(here("data/rds/hurdle_logit/mcyb50_logit.rds"))

# info #---------------------
newtemp = c(10, 30)
newrain = c(250, 375, 475, 600)
newtsi  = c(37, 89)
znewtemp = round(MinMaxScaling(x = newtemp, y = naga42$siteTemp), digits = 4)
znewrain = round(MinMaxScaling(x = newrain, y = naga42$Rain), digits = 4)
znewtsi  = round(MinMaxScaling(x = newtsi,  y = naga42$TSI_chla), digits = 4)

lengthout = 100
newdata = crossing(ztemp = seq(from = min(znewtemp),
			 to = max(znewtemp),
			 length.out = lengthout),
	         zTSI  = seq(from = min(znewtsi),
	         	  	 to = max(znewtsi),
			 length.out = lengthout),
	         zrain = znewrain)

# function #-------------------------------

prob = function(x, mean, sd) {
	prob = 1 - pnorm(x, mean, sd)
	return(prob)
	}


fitnd = function(object,
	       newdata,
	       re_formula = NA,
	       thres1 = 200, # threshold levels (cells/mL)
	       thres2 = 2000,
	       thres3 = 20000,
	       thres4 = 100000) {
	
fit = fitted(object = object,
	   newdata = newdata,
	   re_formula = re_formula) %>%
	as_tibble() %>% 
	select(Estimate, Est.Error) %>%
	mutate(thres1 = prob(thres1, mean = Estimate, sd = Est.Error),
	       thres2 = prob(thres2, mean = Estimate, sd = Est.Error),
	       thres3 = prob(thres3, mean = Estimate, sd = Est.Error), 
	       thres4 = prob(thres4, mean = Estimate, sd = Est.Error)) %>%
	bind_cols(newdata)

fit
}


# fitted data #----------------------------------
fit_pc = fitnd(object = pc,
	    newdata = newdata) %>%
	saveRDS("data/rds/fitted_data/fit_pc50_logit.rds")

fit_mcyb = fitnd(object = mcyb,
	    newdata = newdata) %>%
	saveRDS("data/rds/fitted_data/fit_mcyb50_logit.rds")

