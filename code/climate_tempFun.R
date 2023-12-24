#---
# tempFun.R
#
# This Rscript:
# calculate average air temperature of x-day prior to collection day at 
# meteorological station.  
# * siteTemp = (stationElevation - siteElevation)* (0.6/100) + stationTemp
#
# Dependencies...
# data/climate_data/climate_*.csv
#
# Produces...
#
#---

library(tidyverse)

tempFun = function(clidata,
	         prior_day,
	         sample_date)
{
sample_date = as.Date(sample_date)

stationTemp = clidata %>% # "Date" variable: convert "chr" to "Date" data
		mutate(date2 = as.Date(Date)) %>% 
		filter(date2 < sample_date,
		       date2 >= sample_date - prior_day) %>%
		summarise(mean = mean(Average.temperature))

stationTemp[1,]
}

