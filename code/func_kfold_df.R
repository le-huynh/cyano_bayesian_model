#---
# func_kfold_df.R
#
# This Rscript: generate a function to
# * import (multiple) .rds objects, aka fitted Bayesian models
# * extract kfold cross-validation information
# * put extracted kfold information into a dataframe
#
# Dependencies...
# code/get_imported_data.R
#
# Produces...
# kfold_df()
#---

library(here)
library(tidyverse)

source(here("code/get_imported_data.R"))

kfold_df <- function(file_path,
		 input_pattern = NULL,
		 remove_pattern = "NULL"){
	
	df <- import_data(file_path = file_path,
		        data_type = "rds",
		        output = "list",
		        input_pattern = input_pattern,
		        remove_pattern = remove_pattern) %>%
		enframe("name", "model") %>% 
		mutate(kfold = map(.x = model, 
			         ~ .x$criteria$kfold$estimates),
		       kfold = map(.x = kfold,
		       	  ~ as.data.frame(.x)),
		       kfold = map(.x = kfold,
		       	  ~ rownames_to_column(.x, var = "term"))
		) %>%
		select(!model) %>%
		tidyr::unnest(kfold)
	
	return(df)
}	








