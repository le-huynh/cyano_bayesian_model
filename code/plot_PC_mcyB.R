#---
# plot_PC_mcyB.R
#
# This Rscript:
# Plot distribution of total Microcystis sp. (PC) and MC-producing Microcystis
# (mcyB) population
#
# Dependencies...
# data/process/naga_data50.csv
# code/get_tidy_data.R
#
# Produces...
# results/figures/pc_mcyB.pdf
# results/figures/pc_mcyB.png
#---
library(here)
library(ggplot2)
library(lehuynh)
library(patchwork)

source("code/get_tidy_data.R")

# data #-----------------------------

naga42 <- read_csv(here("data/process/naga_data50.csv")) %>%
	tidy_data(output = "data42")

# info #---------------------
color = "black"
fill = "#666666"

dy = c(0.009, 0) # distance from plot to y-axis
dx = c(0.04, 0) # distance from plot to x-axis
xlabel <- scale_x_continuous(expand = dy)
ylabel <- scale_y_continuous(expand = dx)

# plot #--------------------------
PC_plot = ggplot(naga42, aes(x = PC_r0)) +
	geom_histogram(binwidth = 60,
		     color = color,
		     fill = fill) +
	labs(x = expression(paste("PC gene as total ",
			      italic("Microcystis"),
			      " (copies/mL)")),
	     y = "Frequency\n") +
	xlabel +
	ylabel +
	lehuynh_theme()

mcyB_plot = ggplot(naga42, aes(x = mcyB_r0)) +
	geom_histogram(binwidth = 20,
		     color = color,
		     fill = fill) +
	labs(x = expression(paste(italic("mcyB"),
			      " gene as toxic ",
			      italic("Microcystis"),
			      " (copies/mL)")),
	     y = "Frequency\n") +
	xlabel +
	ylabel +
	lehuynh_theme()

pc_mcyb <- PC_plot / mcyB_plot +
	plot_annotation(tag_levels = 'A')

# save plot #-----------------

width = "full_page"
height <- 140

ggsave_elsevier("results/figures/pc_mcyb.pdf",
	      pc_mcyb,
	      width = width,
	      height = height)

ggsave_elsevier("results/figures/pc_mcyb.png",
	      pc_mcyb,
	      width = width,
	      height = height)

