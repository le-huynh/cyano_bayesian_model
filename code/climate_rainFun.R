#---
# rainFun.R
#
# This Rscript:
# calculate total precipitation of x-day prior to collection day
#
# Dependencies...
# data/climate_data/climate_*.csv
#
# Produces...
#
#---

library(tidyverse)

rainFun = function(clidata,
	         prior_day,
	         sample_date)
{
	sample_date = as.Date(sample_date)
	rain = clidata %>% # "Date" variable: convert "chr" to "Date" data
		mutate(date2 = as.Date(Date)) %>% 
		filter(date2 < sample_date,
		       date2 >= sample_date - prior_day) %>%
		summarise(total = sum(Total.precipitation))
	
	rain[1,]
}

