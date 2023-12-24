#---
# plot_ppc.R
#
# This Rscript:
# Plot posterior predictive check (fitted vs. observed value) of PC, mcyB models
#
# Dependencies...
# data/rds/hurdle_logit/pc50_logit.rds
# data/rds/hurdle_logit/mcyb50_logit.rds
#
# Produces...
# results/figures/ppc.pdf
# results/figures/ppc.png
#---
set.seed(58709506)

library(here)
library(tidyverse)
library(lehuynh)
library(patchwork)

# data #------------------------------
pc   = read_rds(here("data/rds/hurdle_logit/pc50_logit.rds"))
mcyb = read_rds(here("data/rds/hurdle_logit/mcyb50_logit.rds"))

# plot #------------------------
fig_pc = ppc_brms(pc,
	        xtitle = "Observed total cyanobacterial \nabundance (copies/mL)",
	        ytitle = "Fitted total cyanobacterial abundance (copies/mL)",
	        dy = c(0.04, 0.1),
	        dx = c(0.038, 0.1),
	        cor = TRUE,
	        equation = TRUE,
	        xcor = 2500,
	        ycor = 22000,
	        xequ = 2500,
	        yequ = 19900)

fig_mcyb = ppc_brms(mcyb,
		xtitle = "Observed toxic cyanobacterial \nabundance (copies/mL)",
		ytitle = "Fitted toxic cyanobacterial abundance (copies/mL)",
		dy = c(0.04, 0.1),
		dx = c(0.001, 0.1),
		cor = TRUE,
		equation = TRUE,
		xcor = 600,
		ycor = 5900,
		xequ = 600,
		yequ = 5300)

fig_ppc <- fig_pc + 
	fig_mcyb +
	plot_annotation(tag_levels = 'A') +
	plot_layout(widths = c(0.95, 1))

# save plot #------------------------
height <- 240/2
width <- "full_page"

ggsave_elsevier("results/figures/ppc.pdf",
	      fig_ppc,
	      width = width,
	      height = height)

ggsave_elsevier("results/figures/ppc.png",
	      fig_ppc,
	      width = width,
	      height = height)

