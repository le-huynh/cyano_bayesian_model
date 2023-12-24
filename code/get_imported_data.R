#---
# get_imported_data.R
#
# This Rscript:
# * import processed data for working in R
# * import fitted .RDS objects
#
# Dependencies...
# data/process/naga_data*.csv
# data/rds/hurdle_logit/pc*.rds
# data/rds/hurdle_logit/mcyb*.rds
#
# Produces...
# imported data in .GlobalEnv
#---
library(here)
library(tidyverse)

import_data <- function(file_path,
		    data_type = c("csv", "rds"),
		    output = c("list", "object"),
		    input_pattern = NULL,
		    remove_pattern = "NULL"
		    )
	{
	
	data_type = match.arg(data_type)
	   output = match.arg(output)
	
	if (data_type == "csv") {
		if (is.null(input_pattern)) pattern <- "\\.csv$"
			else pattern <- input_pattern
		loading_function = read_csv
			}

	if (data_type == "rds") {
		if (is.null(input_pattern)) pattern <- "\\.rds$"
			else pattern <- input_pattern
		loading_function = read_rds
		}
	
	file_list = list.files(path = file_path,
			   recursive = TRUE,
			   pattern = pattern,
			   full.names = TRUE)
	
	file_name = file_list %>%
		str_remove(file_path) %>%
		str_remove("/") %>%
		str_remove(remove_pattern)
	
	if (output == "list") {
		output_list <- map(file_list, loading_function) %>%
			set_names(file_name)
		return(output_list)
		}

	if (output == "object") {
		map(file_list, loading_function) %>%
			set_names(file_name) %>%
			list2env(envir = .GlobalEnv)
		}
	}




