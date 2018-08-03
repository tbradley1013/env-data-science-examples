#==============================================================================
# This script is converting the Climate Change time series data from 
# individual csv files into compressed rds files
#
# Tyler Bradley
#==============================================================================

library(tidyverse)


files <- list.files("climate-change-temp/data-raw/", full.names = TRUE)

data_sets <- map(files, read_csv)


walk2(data_sets, files, ~{
  file_name <- paste("climate-change-temp/data/", str_extract(.y, "[^/]+$") %>% str_replace("\\.csv", ".rds"))
  
  write_rds(.x, file_name, compress = "gz")
})
