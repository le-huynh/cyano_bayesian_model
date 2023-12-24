#---
# hurdle_poisson.R
#
# The best model is `50-day`, this Rscript test how kfold change when removing
# temp, rainfall.
# => in real application, if cannot collect all 3 variables, can model with 
# only TSI, only temp, only rainfall, or (TSI + temp), etc. work? 
# how good are they?
#
# This Rscript: 
# * fit Bayesian hurdle Poisson model with different formula in Poisson part
# * save fitted model in .rds object
# Note: use `future` package to fit models parallelly 
#
# Dependencies...
# data/process/data_naga50.csv
# code/get_tidy_data.R
#
# Produces...
# data/rds/hurdle_poisson/pc*.rds
# data/rds/hurdle_poisson/mcyb*.rds
#---

library(here)
library(tidyverse)
library(brms)
library(future)

# get tidy dataset #-----------

source(here("code/get_tidy_data.R"))

naga_data50 <- read_csv(here("data/process/naga_data50.csv"))

# climate data (temp, rainfall) from 50-day prior to collection date, 42 obs.
data50_42z <- tidy_data(data = naga_data50, output = "data42z")

# formula #-------------------
fPC_temp = bf(PC_r0 ~ ztemp + (1|Pond),
	       hu ~ ztemp)

fPC_rain = bf(PC_r0 ~ zrain + (1|Pond),
	       hu ~ zrain)

fPC_tsi = bf(PC_r0 ~ zTSI + (1|Pond),
	      hu ~ zTSI)

fPC_temp_rain = bf(PC_r0 ~ ztemp + zrain + (1|Pond),
	            hu ~ ztemp + zrain)

fPC_temp_tsi = bf(PC_r0 ~ ztemp + zTSI + (1|Pond),
	           hu ~ ztemp + zTSI)

fPC_rain_tsi = bf(PC_r0 ~ zTSI + zrain + (1|Pond),
	           hu ~ zTSI + zrain)


fmcyB_temp = bf(mcyB_r0 ~ ztemp + (1|Pond),
	           hu ~ ztemp)

fmcyB_rain = bf(mcyB_r0 ~ zrain + (1|Pond),
	           hu ~ zrain)

fmcyB_tsi = bf(mcyB_r0 ~ zTSI + (1|Pond),
	          hu ~ zTSI)

fmcyB_temp_rain = bf(mcyB_r0 ~ ztemp + zrain + (1|Pond),
	                hu ~ ztemp + zrain)

fmcyB_temp_tsi = bf(mcyB_r0 ~ ztemp + zTSI + (1|Pond),
	               hu ~ ztemp + zTSI)

fmcyB_rain_tsi = bf(mcyB_r0 ~ zTSI + zrain + (1|Pond),
	               hu ~ zTSI + zrain)

# fitting model #----------------
chains = 4
iter = 200000
warmup = 100000
thin = 10
max_treedepth = 15
adapt_delta = 0.99
cores = 4
seed = 91593355

## PC #---------------------

plan(
	list(
		tweak(multisession, workers = 6), # total models
		tweak(multisession, workers = 4) # chains per model
	)
)

mPC_temp %<-% brm(formula = fPC_temp,
	           data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	      adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_temp")

mPC_rain %<-% brm(formula = fPC_rain,
		 data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_rain")

mPC_tsi %<-% brm(formula = fPC_tsi,
		 data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_tsi")

mPC_temp_rain %<-% brm(formula = fPC_temp_rain,
		 data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_temp_rain")

mPC_temp_tsi %<-% brm(formula = fPC_temp_tsi,
		 data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_temp_tsi")

mPC_rain_tsi %<-% brm(formula = fPC_rain_tsi,
		 data = data50_42z,
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_poisson/pc50_rain_tsi")

## mcyB #---------------------

plan(
	list(
		tweak(multisession, workers = 6), # total models
		tweak(multisession, workers = 4) # chains per model
	)
)

mcyb_temp %<-% brm(formula = fmcyB_temp,
	        data = data50_42z,
	        family = hurdle_poisson(),
	        chains = chains,
	        iter = iter,
	        warmup = warmup,
	        thin = thin,
	        control = list(max_treedepth = max_treedepth,
	        	     adapt_delta = adapt_delta),
	        future = TRUE,
	        seed = seed,
	        file = "data/rds/hurdle_poisson/mcyb50_temp")

mcyb_rain %<-% brm(formula = fmcyB_rain,
	        data = data50_42z,
	        family = hurdle_poisson(),
	        chains = chains,
	        iter = iter,
	        warmup = warmup,
	        thin = thin,
	        control = list(max_treedepth = max_treedepth,
	        	     adapt_delta = adapt_delta),
	        future = TRUE,
	        seed = seed,
	        file = "data/rds/hurdle_poisson/mcyb50_rain")

mcyb_tsi %<-% brm(formula = fmcyB_tsi,
	       data = data50_42z,
	       family = hurdle_poisson(),
	       chains = chains,
	       iter = iter,
	       warmup = warmup,
	       thin = thin,
	       control = list(max_treedepth = max_treedepth,
	       	     adapt_delta = adapt_delta),
	       future = TRUE,
	       seed = seed,
	       file = "data/rds/hurdle_poisson/mcyb50_tsi")

mcyb_temp_rain %<-% brm(formula = fmcyB_temp_rain,
		   data = data50_42z,
		   family = hurdle_poisson(),
		   chains = chains,
		   iter = iter,
		   warmup = warmup,
		   thin = thin,
		   control = list(max_treedepth = max_treedepth,
		   	     adapt_delta = adapt_delta),
		   future = TRUE,
		   seed = seed,
		   file = "data/rds/hurdle_poisson/mcyb50_temp_rain")

mcyb_temp_tsi %<-% brm(formula = fmcyB_temp_tsi,
		  data = data50_42z,
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_poisson/mcyb50_temp_tsi")

mcyb_rain_tsi %<-% brm(formula = fmcyB_rain_tsi,
		  data = data50_42z,
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_poisson/mcyb50_rain_tsi")

