
## Bayesian predictive model for toxic cyanobacteria occurrence from eutrophication and climate data

<img align="left" alt="info" width="26px" src="https://github.com/le-huynh/lehuynh.rbind.io/blob/main/static/img/loglo_info.png?raw=true" /> [More information](https://lehuynh.rbind.io/project/proj_cyano/post/)  


This repo includes all data, code, results of data analysis, and documents related to the manuscript using Bayesian Hurdle Poisson model to predict toxic cyanobacteria from (TSI + climate data). 

### Repo Overview

	project
	|- README.md		# the top level description of content (this doc)
	|
	|- submission/
	| |- manuscript.Rmd	# executable Rmarkdown for this study
	| |- manuscript.tex	# TeX version of *.Rmd file (for journal submission)
	| |- manuscript.pdf	# PDF version of *.Rmd file
	| |- manuscript.docx	# doc version of *.Rmd file (for discussion with Sensei)
	| |- my_header.tex	# LaTeX header file to format pdf version of manuscript
	| |- references.bib	# BibTeX formatted references
	| |- XXXX.csl		# csl file to format references for journal XXX
	| |- *.Rmd		# child documents
	| +- other files	# optional files utilized for exporting the .Rmd file to the .pdf format (safe for deletion)
	|
	|- data			# raw and primary data, are not changed once created
	| |- raw/		# raw data, will not be altered
	| |- process/		# cleaned data, will not be altered once created
	| |- climate_data/	# processed climate data, will not be altered once created
	| |- Japan_shapefile/	# shapefile to create the map of sampling sites
	| +- rds/		# final fitted models 
	|
	|- code/		# any programmatic code
	| |- func_*.R 		# code to generate helper functions
	| |- get_*.R 		# code to import/clean data
	| |- plot_*.R		# code to create figures
	| +- bayes_*.R		# code to perform Bayesian modelling
	|
	|- results		# all output from workflows and analyses
	| |- tables/		# text version of tables to be rendered with kable in R
	| |- figures/		# graphs, likely designated for manuscript figures
	| +- pictures/		# diagrams, images, and other non-graph graphics
	|
	|- exploratory/		# exploratory data analysis for study
	| |- notebook/		# preliminary data analyses
	| |- text/		# all information related to journal, meeting, outline, etc.
	| +- scratch/		# temporary files that can be safely deleted or lost
	|
	+- Makefile		# executable Makefile for this study
  
  
