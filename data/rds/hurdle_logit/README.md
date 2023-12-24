### Note 
At the moment, the data used in this project is undergoing continuous updates and refinement.  
As a result, we have not included it in the current version of this repository.  
We are committed to open science and will make the data publicly available in this repository as soon as the ongoing processes are finalized and validated.  


# RDS objects
Hurdle Poisson model:  
+ Poisson part: gene ~ temp + rainfall + TSI + (1|pond)  
+ Logistic part: absence probability = temp + rainfall + TSI  

## Bayesian models
- `pc*_logit.rds`, `mcyb*_logit.rds`: fitted models using climate data = *-day prior to collection date, including kfoldic  
*: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 days

