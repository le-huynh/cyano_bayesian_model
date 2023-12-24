#---
# get_naga_data.R
#
# This Rscript: generate working full-dataset
# * calculate averge temperature, total rainfall, average maximum wind speed
# of 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 days prior to collection date
# * save .csv file
#
# Dependencies...
# code/climate_windFun.R
# code/climate_rainFun.R
# code/climate_tempFun.R
# code/climate_dfFun.R
# data/process/naga_data01.csv
#
# Produces...
# data/process/naga_data*.csv
# *: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 (days prior to collection date)
#---

library(here)
library(tidyverse)

source(here("code/climate_windFun.R"))
source(here("code/climate_rainFun.R"))
source(here("code/climate_tempFun.R"))
source(here("code/climate_dfFun.R"))

data = read_csv(here("data/process/naga_data01.csv"))

date = seq(from = 10, to = 100, by = 10)

climate = vector("list", length = length(date))
output  = vector("list", length = length(date))

for (i in seq_along(date)) {
	file_name = paste0("data/process/naga_data", date[[i]], ".csv")
	
	climate[[i]] = climateDF(prior_day = date[[i]])
	
	output[[i]] = data %>%
		mutate(samplingDate   = climate[[i]]$sampleDate,
		       climateStation = climate[[i]]$Station,
		       Rain     = climate[[i]]$Rain,
		       Wind     = climate[[i]]$Wind,
		       siteTemp = climate[[i]]$siteTemp) %>%
		select(ID, Site_name, ID_name,
		       samplingDate, Month, Year,
		       Lat, Long, Location, Elevation, climateStation,
		       siteTemp, Rain, Wind,
		       Chla:SD_TP) %>%
		write.csv(file = file_name,
			row.names = FALSE)
	}









