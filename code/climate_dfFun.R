#---
# climate_dfFun.R
#
# This Rscript:
# 1. Calculate average value of parameter -> `x` days prior to collection date
# 2. Add average value to final dataset
#
# Dependencies...
# data/climate_data/climate_*.csv
# data/process/Naga_data01.csv
#
# Produces...
# a data.frame
#
#---

library(here)
library(tidyverse)


climateDF = function(prior_day)
	{
	data = read.csv(here("data/process/naga_data01.csv"))
	naga = read.csv(here("data/climate_data/climate_nagasaki.csv"))
	omura = read.csv(here("data/climate_data/climate_omura.csv"))
	shima = read.csv(here("data/climate_data/climate_shimabara.csv"))
	unzen = read.csv(here("data/climate_data/climate_unzen.csv"))
	
	nagaElev  = 26.9
	omuraElev = 3
	shimaElev = 14
	unzenElev = 677.5
	
data2 = data %>% 
	mutate(Station = if_else(Location == "Isahaya", "Omura",
		       if_else(Location == "Unzen", "Unzen",
		       if_else(Location == "Shimabara", "Shimabara",
		               "Nagasaki"))),
	       sampleDate = if_else(Collection_date == "1-Apr-18", "01/04/18",
	       		if_else(Collection_date == "13-May-18", "13/05/18",
	       		if_else(Collection_date == "14-May-17", "14/05/17",
	       	          if_else(Collection_date == "15-May-17", "15/05/17",
	       	          if_else(Collection_date == "26-Aug-17", "26/08/17",
	       	          if_else(Collection_date == "26-Jul-17", "26/07/17",
	       	                  "Error")))))) %>% as.Date("%d/%m/%y"),
	       stationElev = if_else(Station == "Nagasaki", nagaElev,
	       		 if_else(Station == "Omura", omuraElev,
	       		 if_else(Station == "Unzen", unzenElev,
	       		 if_else(Station == "Shimabara", shimaElev,
	       		         -1)))),
	       PC_r0 = if_else (PC < 1, 0, round(PC)) %>% replace_na(0),
	       mcyB_r0 = if_else (mcyB < 1, 0, round(mcyB)) %>% replace_na(0)
	) %>%
	select(sampleDate, 
	       Location, 
	       Station, 
	       stationElev, 
	       siteElev = Elevation,
	       Chla,
	       PC_r0,
	       mcyB_r0)

data2 = data2 %>%	
	mutate(Wind = if_else(sampleDate=="2017-05-14" & Station=="Omura",
			  windFun(clidata = omura, 
			          prior_day = prior_day,
			          sample_date = "2017-05-14"),
		    if_else(sampleDate=="2017-05-14" & Station=="Shimabara",
		            windFun(clidata = shima, 
		                    prior_day = prior_day,
		                    sample_date = "2017-05-14"),
		    if_else(sampleDate=="2017-05-14" & Station=="Unzen",
		            windFun(clidata = unzen, 
		                    prior_day = prior_day,
		                    sample_date = "2017-05-14"),
		    if_else(sampleDate=="2017-05-15" & Station=="Nagasaki", 
		            windFun(clidata = naga, 
		                    prior_day = prior_day,
		                    sample_date = "2017-05-15"),
		    if_else(sampleDate=="2017-07-26" & Station=="Unzen",
		            windFun(clidata = unzen, 
		                    prior_day = prior_day,
		                    sample_date = "2017-07-26"),
		    if_else(sampleDate=="2017-08-26" & Station=="Nagasaki",
		            windFun(clidata = naga, 
		                    prior_day = prior_day,
		                    sample_date = "2017-08-26"),
		    if_else(sampleDate=="2018-04-01" & Station=="Unzen", 
		            windFun(clidata = unzen, 
		                    prior_day = prior_day,
		                    sample_date = "2018-04-01"),
		    if_else(sampleDate=="2018-04-01" & Station=="Nagasaki",
		            windFun(clidata = naga, 
		                    prior_day = prior_day,
		                    sample_date = "2018-04-01"),
		    if_else(sampleDate=="2018-05-13" & Station=="Unzen",
		            windFun(clidata = unzen, 
		                    prior_day = prior_day,
		                    sample_date = "2018-05-13"),
		    if_else(sampleDate=="2018-05-13" & Station=="Nagasaki",
		            windFun(clidata = naga, 
		                    prior_day = prior_day,
		                    sample_date = "2018-05-13"),
		            -1
		            )))))))))),
	   Rain = if_else(sampleDate=="2017-05-14" & Station=="Omura",
	   	        rainFun(clidata = omura, 
	   	                prior_day = prior_day,
	   	                sample_date = "2017-05-14"),
	   	if_else(sampleDate=="2017-05-14" & Station=="Shimabara",
		        rainFun(clidata = shima, 
		                prior_day = prior_day,
		                sample_date = "2017-05-14"),
		if_else(sampleDate=="2017-05-14" & Station=="Unzen",
		        rainFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2017-05-14"),
		if_else(sampleDate=="2017-05-15" & Station=="Nagasaki", 
		        rainFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2017-05-15"),
		if_else(sampleDate=="2017-07-26" & Station=="Unzen",
		        rainFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2017-07-26"),
		if_else(sampleDate=="2017-08-26" & Station=="Nagasaki",
		        rainFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2017-08-26"),
		if_else(sampleDate=="2018-04-01" & Station=="Unzen", 
		        rainFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2018-04-01"),
		if_else(sampleDate=="2018-04-01" & Station=="Nagasaki",
		        rainFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2018-04-01"),
		if_else(sampleDate=="2018-05-13" & Station=="Unzen",
		        rainFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2018-05-13"),
		if_else(sampleDate=="2018-05-13" & Station=="Nagasaki",
		        rainFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2018-05-13"),
		        -1)))))))))),
      stationTemp = if_else(sampleDate=="2017-05-14" & Station=="Omura",
	   	        tempFun(clidata = omura, 
	   	                prior_day = prior_day,
	   	                sample_date = "2017-05-14"),
	   	if_else(sampleDate=="2017-05-14" & Station=="Shimabara",
		        tempFun(clidata = shima, 
		                prior_day = prior_day,
		                sample_date = "2017-05-14"),
		if_else(sampleDate=="2017-05-14" & Station=="Unzen",
		        tempFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2017-05-14"),
		if_else(sampleDate=="2017-05-15" & Station=="Nagasaki", 
		        tempFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2017-05-15"),
		if_else(sampleDate=="2017-07-26" & Station=="Unzen",
		        tempFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2017-07-26"),
		if_else(sampleDate=="2017-08-26" & Station=="Nagasaki",
		        tempFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2017-08-26"),
		if_else(sampleDate=="2018-04-01" & Station=="Unzen", 
		        tempFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2018-04-01"),
		if_else(sampleDate=="2018-04-01" & Station=="Nagasaki",
		        tempFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2018-04-01"),
		if_else(sampleDate=="2018-05-13" & Station=="Unzen",
		        tempFun(clidata = unzen, 
		                prior_day = prior_day,
		                sample_date = "2018-05-13"),
		if_else(sampleDate=="2018-05-13" & Station=="Nagasaki",
		        tempFun(clidata = naga, 
		                prior_day = prior_day,
		                sample_date = "2018-05-13"),
		        -1)))))))))))

data2 = data2 %>% 
	mutate(siteTemp = (stationElev - siteElev)* (0.6/100) + stationTemp)
}

