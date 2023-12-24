#---
# func_posterior.R
#
# This Rscript:
# Generate a function to plot posterior uncertainty intervals of 
# logistic regression part (A), Poisson regression part (B) 
#
# Produces...
# posterior()
#---

library(ggplot2)
library(bayesplot)
library(patchwork)
library(cowplot)

posterior <- function(data,
		  prob = 0.8,
		  prob_outer = 0.99,
		  point_est = "median",
		  text_family = "sans",
		  text_col = "black",
		  text_size = 9) {
	
bayesplot::color_scheme_set("blue")
	
par_logit <- c("b_hu_Intercept",
	     "b_hu_ztemp",
	     "b_hu_zrain",
	     "b_hu_zTSI")
	
par_poisson <- c("b_Intercept",
	       "b_ztemp",
	       "b_zrain",
	       "b_zTSI")
	
par_title <- c("Intercept",
	     "Air temperature",
	     "Rainfall",
	     "TSI")

para_list <- data.frame(par_logit, par_poisson, par_title)
	

output_logit = vector("list", length = length(para_list$par_title))
	
for (i in seq_along(para_list$par_title)) {
    output_logit[[i]] <- mcmc_areas(data,
    			  pars = para_list[[i,1]],
    			  transformations = function(x) -x,
    			  prob = prob,
    			  prob_outer = prob_outer,
    			  point_est = point_est) +
		    labs(title = para_list[[i,3]]) +
		    theme(axis.text.y = element_blank(),
			axis.text.x = element_text(family = text_family,
			      		       color = text_col,
			      		       size = text_size),
			title = element_text(family = text_family,
			      		 size = text_size,
			      		 color = text_col))
		}
	
fig_logit = output_logit[[1]] + 
	output_logit[[2]] + 
	output_logit[[3]] +
	output_logit[[4]] +
	plot_layout(ncol = 1) +
	plot_annotation(title = "Logistic regression part",
		      theme = theme(plot.title = element_text(size = 12,
		      				      hjust = 0.1)))
	
	
output_poisson = vector("list", length = length(para_list$par_title))
	
for (i in seq_along(para_list$par_title)) {
	output_poisson[[i]] <- mcmc_areas(data,
				  pars = para_list[[i,2]],
				  prob = prob,
				  prob_outer = prob_outer,
				  point_est = point_est) +
		labs(title = para_list[[i,3]]) +
		theme(axis.text.y = element_blank(),
		      axis.text.x = element_text(family = text_family,
		      		       color = text_col,
		      		       size = text_size),
		      title = element_text(family = text_family,
		      		 size = text_size,
		      		 color = text_col))
}

fig_poisson = output_poisson[[1]] + 
	output_poisson[[2]] + 
	output_poisson[[3]] +
	output_poisson[[4]] +
	plot_layout(ncol = 1) +
	plot_annotation(title = "Poisson regression part",
		      theme = theme(plot.title = element_text(size = 12,
			      			      hjust = 0.1)))
	
	fig = plot_grid(fig_logit, fig_poisson,
		      ncol = 2,
		      labels = "AUTO")
	
	return(fig)
}


