#---
# plot_posterior.R
#
# This Rscript:
# Plot: posterior distribution of PC-model, mcyB-model
# * plot posterior uncertainty intervals of logistic regression part (A), 
#   Poisson regression part (B) 
# * save the plot in .pdf, .png
#
# Dependencies...
# data/rds/hurdle_logit/pc50_logit.rds\
# data/rds/hurdle_logit/mcyb50_logit.rds
#
# Produces...
# results/figures/posterior_pc.pdf
# results/figures/posterior_mcyb.png
#---

library(here)
library(tidyverse)
library(lehuynh)

source(here("code/func_posterior.R"))

# data #------------------------------
pc   = read_rds(here("data/rds/hurdle_logit/pc50_logit.rds"))
mcyb = read_rds(here("data/rds/hurdle_logit/mcyb50_logit.rds"))

width <- "full_page"
height <- 150

# PC #-------------------
fig_pc <- posterior(pc)

ggsave_elsevier("results/figures/posterior_pc.pdf",
	      fig_pc,
	      width = width,
	      height = height)
ggsave_elsevier("results/figures/posterior_pc.png",
	      fig_pc,
	      width = width,
	      height = height)

# mcyB #-------------------
fig_mcyb <- posterior(mcyb)

ggsave_elsevier("results/figures/posterior_mcyb.pdf",
	      fig_mcyb,
	      width = width,
	      height = height)
ggsave_elsevier("results/figures/posterior_mcyb.png",
	      fig_mcyb,
	      width = width,
	      height = height)


