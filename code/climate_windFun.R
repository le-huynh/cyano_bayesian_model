#---
# windFun.R
#
# This Rscript:
# calculate average wind speed of x-day prior to collection day
#
# Dependencies...
# data/climate_data/climate_*.csv
#
# Produces...
#
#---

library(tidyverse)

windFun = function(clidata,
	         prior_day,
	         sample_date)
	{
sample_date = as.Date(sample_date)
wind = clidata %>% # "Date" variable: convert "chr" to "Date" data
	mutate(date2 = as.Date(Date)) %>% 
	filter(date2 < sample_date,
	       date2 >= sample_date - prior_day) %>%
	summarise(mean = mean(Average.wind.speed))

wind[1,]
}

