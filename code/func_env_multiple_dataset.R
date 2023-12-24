#---
# func_env_multiple_dataset.R
#
# This Rscript:
# * import multiple .csv files (climate data of x-day prior to sampling date)
# * extract `Collection Time`, `temperature`, `rainfall` data
# * put extracted information into a dataframe
# Note: [IMPORTANT] line 33, 34, 35:
# - filter(): specific code for removing naga_data01.csv
# - factor(): specific code for 10 datasets
#
# Dependencies...
# code/get_imported_data.R
#
# Produces...
# env_df()
#---

library(here)
library(tidyverse)
library(lubridate)

source(here("code/get_imported_data.R"))

env_df <- function(file_path,
	         input_pattern = NULL,
	         remove_pattern = ".csv"){
	
df <- import_data(file_path = file_path,
	        data_type = "csv",
	        output = "list",
	        input_pattern = input_pattern,
	        remove_pattern = remove_pattern) %>%
	enframe("dataset", "df_value") %>%
	filter(dataset != "naga_data01") %>%
	mutate(dataset = factor(dataset, 
			    paste0("naga_data", seq(10, 100, by = 10))),
	       climate = map(.x = df_value,
			 ~ .x %>%
			 transmute(Time = format_ISO8601(samplingDate,
			 			  precision = "ym"),
			 	siteTemp,
			 	Rain)),
	       climate = map(.x = climate,
	       	           ~ .x %>% slice(-c(34, 43)))) %>%
	select(!df_value) %>%
	tidyr::unnest(climate)

return(df)

}	











