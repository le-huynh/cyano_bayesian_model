#---
# plot_site_map.R
#
# This Rscript:
# Plot map of Nagasaki
#
# Dependencies...
# data/Japan_shapefile/jpn_admbnda_adm1_2019.shp
#
# Produces...
# results/figures/site_map.pdf
# results/figures/site_map.png
#---
library(dplyr)
library(ggplot2)
library(ggmap)
library(here)
library(rgdal)

# Japan -> full map (bboxfinder.com)
japan_bb = c(left = 127.924805,
	   bottom = 29.688053,
	   right = 146.733398,
	   top = 45.828799)

# Nagasaki prefecture -> full map
# nagasaki_bb = c(left = 128.386230,
#                bottom = 31.942840,
#                right = 131.627197,
#                top = 34.759666)

#' [use] Nagasaki prefecture -> except islands 
naga_bb = c(left = 129.256897,
	  bottom = 32.502813,
	  right = 130.685120,
	  top = 33.683211)

# get stamen map
# if "error" -> run code directly in R Console
# increase `zoom` to get higher resolution
naga_stamen <- ggmap::get_stamenmap(bbox = naga_bb,
			      maptype = "terrain",
			      zoom = 10)

# read shapefile of Japan (level = 1 = prefecture)
jap_shp = rgdal::readOGR(here("data", 
			"Japan_shapefile", 
			"jpn_admbnda_adm1_2019.shp"))

# convert shapefile to data.frame -> use with ggplot2/ggmap() and plot()
jap_shape = ggplot2::fortify(jap_shp)

# extract shapefile of Nagasaki (id = 26)
naga_shape = dplyr::filter(jap_shape, id == 26)

# plot Nagasaki map, except islands
naga_map = ggmap::ggmap(naga_stamen) +
	geom_polygon(aes(x = long, y = lat, group = group),
		   data = naga_shape,
		   colour = 'white',
		   fill = 'gray87',
		   alpha = 0.35,
		   size = 0.3) +
	theme(axis.title = element_blank(),
	      axis.text = element_blank(),
	      axis.ticks = element_blank(),
	      plot.margin = margin(t = 0, 
	      		       r = 0, 
	      		       b = -0.075, 
	      		       l = 0, 
	      		       unit = "in")) 

# add rectangle
naga_map = naga_map +
	geom_rect(xmin = 129.751968, 
		xmax = 130.387115, 
		ymin = 32.651263, 
		ymax = 32.910145, 
		fill = NA, 
		colour = "black", 
		size = 0.3)

# add "Nagasaki"
naga_map = naga_map +
	annotate(geom = "text", 
	         x = 129.6, y = 33.05, 
	         label = "Nagasaki \n Prefecture", 
	         fontface = "bold.italic", color = "black", size = 2.8) 
# for ppt
# width = 2.5
# height = 2.475

# for paper
width  = 2.0
height = 1.985
unit = "in"
ggsave("results/figures/site_map.pdf",
       naga_map,
       units = unit,
       width = width,
       height = height)
ggsave("results/figures/site_map.png", 
       naga_map,
       units = unit,
       width = width,
       height = height)

