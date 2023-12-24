#---
# bayes_hurdle_poisson_kfold.R
#
# This Rscript:
# * Calculate kfoldic from fitted Bayesian models
# * save kfold information into file .rds
#
# Dependencies...
# /rds/*.rds
#
# Produces...
# /rds/*.rds
#---
library(here)
library(tidyverse)
library(brms)
library(future)

# import .rds #---------------------

file_path = here("data/rds/hurdle_poisson")

file_list = list.files(path = file_path,
		   recursive = TRUE,
		   pattern = "\\.rds$",
		   full.names = TRUE)

file_name = file_list %>%
	str_remove(file_path) %>%
	str_remove('.rds') %>%
	str_remove('/')

map(file_list, readRDS) %>%
	setNames(file_name) %>%
	list2env(envir = .GlobalEnv)

knumber = 5

# PC-kfold #----------------------------------------------------------------------
plan(
	list(
		tweak(multisession, workers = 6), # total models
		tweak(multisession, workers = 5) # chains per model
	)
)

kpc1 %<-% add_criterion(pc50_temp, criterion = "kfold", K = knumber)
kpc2 %<-% add_criterion(pc50_rain, criterion = "kfold", K = knumber)
kpc3 %<-% add_criterion(pc50_tsi, criterion = "kfold", K = knumber)
kpc4 %<-% add_criterion(pc50_temp_rain, criterion = "kfold", K = knumber)
kpc5 %<-% add_criterion(pc50_temp_tsi, criterion = "kfold", K = knumber)
kpc6 %<-% add_criterion(pc50_rain_tsi, criterion = "kfold", K = knumber)

# mcyB-kfold #----------------------------------------------------------------------
plan(
	list(
		tweak(multisession, workers = 6), # total models
		tweak(multisession, workers = 5) # chains per model
	)
)

kmcyb1 %<-% add_criterion(mcyb50_temp, criterion = "kfold", K = knumber)
kmcyb2 %<-% add_criterion(mcyb50_rain, criterion = "kfold", K = knumber)
kmcyb3 %<-% add_criterion(mcyb50_tsi, criterion = "kfold", K = knumber)
kmcyb4 %<-% add_criterion(mcyb50_temp_rain, criterion = "kfold", K = knumber)
kmcyb5 %<-% add_criterion(mcyb50_temp_tsi, criterion = "kfold", K = knumber)
kmcyb6 %<-% add_criterion(mcyb50_rain_tsi, criterion = "kfold", K = knumber)




