#---
# get_tidy_data.R
#
# This Rscript:
# tidying the data for data analysis
# * transform PC, mcyB into count data
# * calculate TSI from Chla
# * remove outliers: obs. 34, obs. 43
# * transform predictors by Min-Max normalization
#
# Dependencies...
# data/process/naga_data*.csv
#
# Produces...
# dataframes
#---
library(here)
library(tidyverse)
library(lehuynh)

tidy_data <- function(data,
		  output = c("data42", "data42z"))
	{

data42 = data %>%
	mutate(PC_r0 = if_else (PC < 1, 0, round(PC)) %>% replace_na(0),
	       mcyB_r0 = ifelse (mcyB < 1, 0, round(mcyB)) %>% replace_na(0),
	       nontoxic = PC_r0 - mcyB_r0,
	       TSI_chla = 10 * (6 - ((2.04 - 0.68 * log(Chla)) / log(2))),
	       Time = paste(Month, "/", Year, sep = ""),
	       # calculate proportions of mcyB in PC
	       prop = round((mcyB_r0 / PC_r0), digits = 2)) %>%
	select(-starts_with("SD")) %>%
	slice(-c(34, 43))

data42z = data42 %>% 
	mutate(zTSI  = MinMaxScaling(TSI_chla), 
	       ztemp = MinMaxScaling(siteTemp),
	       zrain = MinMaxScaling(Rain),
	       zchla = MinMaxScaling(log(Chla))) %>%
	select(ID,
	       Pond = ID_name,
	       PC_r0,
	       mcyB_r0,
	       nontoxic,
	       zTSI,
	       ztemp,
	       zrain,
	       zchla)

output <- match.arg(output)
switch(output,
       data42  = return(data42),
       data42z = return(data42z))
}


