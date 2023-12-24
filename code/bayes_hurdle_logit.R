#---
# bayes_hurdle_chla.R
#
# This Rscript: replace TSI by Chla
# * Fit Bayesian model for PC, mcyB via `brms` package
# * save fitted model in .rds object
# Note: use `future` package to fit models parallelly 
#
# Dependencies...
# data/process/data_naga*.csv
#
# Produces...
# data/rds/hurdle_chla/pc*.rds
# data/rds/hurdle_chla/mcyb*.rds
# *: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 (days prior to collection date)
#---

library(here)
library(tidyverse)
library(lehuynh)
library(brms)
library(future)

# data #--------------------
date = seq(from = 10, to = 100, by = 10)

data  = vector("list", length = length(date))
dataz = vector("list", length = length(date))

for (i in seq_along(date)) {
    data[[i]] = read_csv(here(paste0("data/process/naga_data", date[[i]], ".csv")))

    dataz[[i]] = data[[i]] %>%
    	mutate(PC_r0 = if_else (PC < 1, 0, round(PC)) %>% replace_na(0),
    	       mcyB_r0 = if_else (mcyB < 1, 0, round(mcyB)) %>% replace_na(0),
    	       TSI_chla = 10 * (6 - ((2.04 - 0.68 * log(Chla)) / log(2))),
    	       zTSI = MinMaxScaling(TSI_chla), 
    	       ztemp = MinMaxScaling(siteTemp),
    	       zrain = MinMaxScaling(Rain),
    	       zchla = MinMaxScaling(Chla)) %>%
    	select(ID,
    	       Pond = ID_name,
    	       PC_r0,
    	       mcyB_r0,
    	       zTSI,
    	       ztemp,
    	       zrain,
    	       zchla) %>%
    	slice(-c(34, 43))
}

# formula #-------------------
fPC_chla   = bf(PC_r0 ~ ztemp + zchla + zrain + (1|Pond),
	       hu ~ ztemp + zchla + zrain)

fmcyB_chla = bf(mcyB_r0 ~ ztemp + zchla + zrain + (1|Pond),
	       hu ~ ztemp + zchla + zrain)

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
		tweak(multisession, workers = 10), # total models
		tweak(multisession, workers = 4) # chains per model
	)
)

mPC10_chla %<-% brm(formula = fPC_chla,
	         data = dataz[[1]],
	         family = hurdle_poisson(),
	         chains = chains,
	         iter = iter,
	         warmup = warmup,
	         thin = thin,
	         control = list(max_treedepth = max_treedepth,
	         	              adapt_delta = adapt_delta),
	         future = TRUE,
	         seed = seed,
	         file = "data/rds/hurdle_chla/pc10_chla")

mPC20_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[2]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc20_chla")

mPC30_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[3]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc30_chla")

mPC40_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[4]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc40_chla")

mPC50_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[5]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc50_chla")

mPC60_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[6]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc60_chla")

###
mPC70_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[7]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc70_chla")

mPC80_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[8]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc80_chla")

mPC90_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[9]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc90_chla")

mPC100_chla %<-% brm(formula = fPC_chla,
		 data = dataz[[10]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/pc100_chla")

## mcyB #---------------------

plan(
	list(
		tweak(multisession, workers = 10), # total models
		tweak(multisession, workers = 4) # chains per model
	)
)

mcyb10_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[1]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb10_chla")

mcyb20_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[2]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb20_chla")

mcyb30_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[3]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb30_chla")

mcyb40_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[4]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb40_chla")

mcyb50_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[5]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb50_chla")

mcyb60_chla %<-% brm(formula = fmcyB_chla,
		 data = dataz[[6]],
		 family = hurdle_poisson(),
		 chains = chains,
		 iter = iter,
		 warmup = warmup,
		 thin = thin,
		 control = list(max_treedepth = max_treedepth,
		 	     adapt_delta = adapt_delta),
		 future = TRUE,
		 seed = seed,
		 file = "data/rds/hurdle_chla/mcyb60_chla")

###
mcyb70_chla %<-% brm(formula = fmcyB_chla,
		  data = dataz[[7]],
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_chla/mcyb70_chla")

mcyb80_chla %<-% brm(formula = fmcyB_chla,
		  data = dataz[[8]],
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_chla/mcyb80_chla")

mcyb90_chla %<-% brm(formula = fmcyB_chla,
		  data = dataz[[9]],
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_chla/mcyb90_chla")

mcyb100_chla %<-% brm(formula = fmcyB_chla,
		  data = dataz[[10]],
		  family = hurdle_poisson(),
		  chains = chains,
		  iter = iter,
		  warmup = warmup,
		  thin = thin,
		  control = list(max_treedepth = max_treedepth,
		  	     adapt_delta = adapt_delta),
		  future = TRUE,
		  seed = seed,
		  file = "data/rds/hurdle_chla/mcyb100_chla")


