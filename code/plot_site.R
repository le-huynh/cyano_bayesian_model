#---
# plot_site.R
#
# This Rscript:
# Plot sampling sites
#
# Dependencies...
# data/process/naga_data02.csv
#
# Produces...
# results/figures/site.pdf
# results/figures/site.png
#---

library(ggplot2)
library(ggmap)
library(here)

naga_site_bb2 = c(left = 129.751968,
	        bottom = 32.651263,
	        right = 130.387115,
	        top = 32.910145)

# get stamen map
site_stamen <- ggmap::get_stamenmap(bbox = naga_site_bb2,
			      maptype = "terrain-background",
			      zoom = 12)

# Add sampling sites
naga_data <- read.csv(here("data/process/naga_data02.csv"))

site_map <- ggmap(site_stamen) +
	# Add the sample sites to the main plot as points.
	geom_point(mapping = aes(x = Long,
			     y = Lat,
			     shape = Location),
		 data = naga_data,
		 fill = "black",
		 size = 2.5) +
	scale_shape_manual(values = c(25, 17, 15, 19, 7)) +
	scale_x_continuous(breaks = c(129.8, 130.0, 130.2),
		         labels = c("129\u00B048'E", 
		         	          "130\u00B000'E", 
		         	          "130\u00B012'E"),
		         expand = c(0, 0)) +
	scale_y_continuous(breaks = c(32.7, 32.8, 32.9),
		         labels = c("32\u00B042'N", 
		         	          "32\u00B048'N", 
		         	          "32\u00B054'N"),
		         expand = c(0, 0)) +
	theme(legend.position = "top",
	      axis.title = element_blank(),
	      axis.text = element_text(color = "black",
	      		           size = 10),
	      panel.border = element_rect(color = "black",
	      		              fill = NA))
# for ppt
# width = 10
# height = 5.5

# for paper
width  = 7.48 # 190 mm = full page
height = 4.2
unit   = "in"
ggsave("results/figures/site.pdf",
       site_map,
       units = unit,
       width = width,
       height = height)
ggsave("results/figures/site.png", 
       site_map,
       units = unit,
       width = width,
       height = height)

