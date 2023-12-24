### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


# RDS objects
Hurdle Poisson model:  
+ Logistic part: absence probability = env. condition  
+ Poisson part: gene ~ env. condition + (1|Pond)  

## Formula
gene_logit = gene ~ ztemp + zTSI + zrain + (1|Pond),
	 bsence ~ ztemp + zTSI + zrain

gene_temp = gene ~ ztemp + (1|Pond),
         absence ~ ztemp

gene_rain = gene ~ zrain + (1|Pond),
         absence ~ zrain

gene_tsi = gene ~ zTSI + (1|Pond),
        absence ~ zTSI

gene_temp_rain = gene ~ ztemp + zrain + (1|Pond),
	    absence ~ ztemp + zrain

gene_temp_tsi = gene ~ ztemp + zTSI + (1|Pond),
	   absence ~ ztemp + zTSI

gene_rain_tsi = gene ~ zTSI + zrain + (1|Pond),
	   absence ~ zTSI + zrain


## Bayesian models
- `pc*.rds`, `mcyb*.rds`: fitted models using climate data = 50-day prior to collection date, including kfoldic  


