### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


# RDS objects
Hurdle Poisson model:  
+ Poisson part: gene ~ temp + rainfall + TSI + (1|pond)  
+ Logistic part: absence probability = temp + rainfall + TSI  

## fitted data:
rain = c(250, 375, 475, 600): see `code/get_fitted_data.R`  
- `fit_pc50_logit.rds`, `fit_mcyb50_logit.rds`: climate data = 50-day prior to collection date  


