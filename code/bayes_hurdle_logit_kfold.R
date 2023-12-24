#---
# bayes_hurdle_chla_kfold.R
#
# This Rscript:
# * Calculate kfoldic from fitted Bayesian models: with different prior-day
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

file_path = here("data/rds/hurdle_chla")

file_list = list.files(path = file_path,
		   recursive = TRUE,
		   pattern = "\\.rds$",
		   full.names = TRUE)

file_name = file_list %>%
	str_remove(file_path) %>%
	str_remove('_chla.rds') %>%
	str_remove('/')

map(file_list, readRDS) %>%
	setNames(file_name) %>%
	list2env(envir = .GlobalEnv)

knumber = 5

# PC-kfold #----------------------------------------------------------------------
plan(
	list(
		tweak(multisession, workers = 10), # total models
		tweak(multisession, workers = 5) # chains per model
	)
)

kpc10 %<-% add_criterion(pc10, criterion = "kfold", K = knumber)
kpc20 %<-% add_criterion(pc20, criterion = "kfold", K = knumber)
kpc30 %<-% add_criterion(pc30, criterion = "kfold", K = knumber)
kpc40 %<-% add_criterion(pc40, criterion = "kfold", K = knumber)
kpc50 %<-% add_criterion(pc50, criterion = "kfold", K = knumber)
kpc60 %<-% add_criterion(pc60, criterion = "kfold", K = knumber)
kpc70 %<-% add_criterion(pc70, criterion = "kfold", K = knumber)
kpc80 %<-% add_criterion(pc80, criterion = "kfold", K = knumber)
kpc90 %<-% add_criterion(pc90, criterion = "kfold", K = knumber)
kpc100 %<-% add_criterion(pc100, criterion = "kfold", K = knumber)

# mcyB-kfold #----------------------------------------------------------------------
plan(
	list(
		tweak(multisession, workers = 10), # total models
		tweak(multisession, workers = 5) # chains per model
	)
)

kmcyb10 %<-% add_criterion(mcyb10, criterion = "kfold", K = knumber)
kmcyb20 %<-% add_criterion(mcyb20, criterion = "kfold", K = knumber)
kmcyb30 %<-% add_criterion(mcyb30, criterion = "kfold", K = knumber)
kmcyb40 %<-% add_criterion(mcyb40, criterion = "kfold", K = knumber)
kmcyb50 %<-% add_criterion(mcyb50, criterion = "kfold", K = knumber)
kmcyb60 %<-% add_criterion(mcyb60, criterion = "kfold", K = knumber)
kmcyb70 %<-% add_criterion(mcyb70, criterion = "kfold", K = knumber)
kmcyb80 %<-% add_criterion(mcyb80, criterion = "kfold", K = knumber)
kmcyb90 %<-% add_criterion(mcyb90, criterion = "kfold", K = knumber)
kmcyb100 %<-% add_criterion(mcyb100, criterion = "kfold", K = knumber)


