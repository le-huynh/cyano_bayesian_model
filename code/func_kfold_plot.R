#---
# func_kfold_plot.R
#
# This Rscript:
# generate a function to plot kfoldic vs days (including SE) for
# PC models, mcyB models
#
# Dependencies...
#
# Produces...
# kfold_plot()
#---

library(tidyverse)
library(lehuynh)

kfold_plot <- function(data,
		   xtitle = expression(paste(italic("kfoldic"))),
		   ytitle = "Model",
		   title = "Fig. A",
		   coord_flip = TRUE,
		   model_name = NULL,
		   model_label = NULL,
		   ...)
{
	data2 <- data %>%
		filter(term == "kfoldic") %>%
		filter(Estimate == min(Estimate)) %>%
		mutate(low = Estimate - SE,
		       high = Estimate + SE)
	
	fig <- data %>%
		mutate(low = Estimate - SE,
		       high = Estimate + SE) %>%
		ggplot(aes(y = name, x = Estimate)) +
		geom_point(size = 2,
			 color = "gray48") +
		geom_errorbarh(aes(xmin = low , xmax = high),
			     color = "gray48") +
		geom_point(data = data2,
			 aes(y = name, x = Estimate),
			 size = 2,
			 color = "black") +
		geom_errorbarh(data = data2, 
			     aes(xmin = low , xmax = high),
			     color = "black") +
		labs(x = xtitle,
		     y = ytitle,
		     title = title) +
		lehuynh_theme(...)
	
	if (!is.null(model_name) & !is.null(model_label)) {
		fig <- fig + 
			scale_y_discrete(breaks = model_name,
				       labels = model_label)
			
	}
	
	if (coord_flip == TRUE) fig + coord_flip()
		else fig
}


