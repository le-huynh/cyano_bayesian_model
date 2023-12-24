### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


# RDS objects
Hurdle Poisson model:  
+ Poisson part: gene ~ temp + rainfall + TSI + (1|pond)  
+ Logistic part: absence probability = constant  

## Bayesian models
- `mcyB2var.rds`: fitted model for mcyB, using 2 predictors (air temperature + TSI), climate data = 30-day prior to collection date  
- `pc*.rds`, `mcyb*.rds`: fitted models using climate data = *-day prior to collection date, including kfoldic  
*: 5, 10, 15, 20, 25, 30 days

## fitted data:
rain = c(200, 300, 400, 500): see `code/get_fitted_data.R`  
- `fitpc30.rds`, `fitmc30.rds`: climate data = 30-day prior to collection date  
- `fitpc25.rds`, `fitmc25.rds`: climate data = 25-day prior to collection date  


