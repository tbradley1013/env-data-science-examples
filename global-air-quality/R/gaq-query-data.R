#==============================================================================
# This script queries the OpenAQ API to retrieve air quality data from OpenAQ
#
# Tyler Bradley
# 2018-08-03
#==============================================================================

library(tidyverse)
library(aws.s3)
library(ndjson)
library(lubridate)

open_aq_bucket <- get_bucket(bucket = 'openaq-fetches',
                             prefix = "realtime-gzipped/2016", 
                             max = Inf)


save_object_safe <- purrr::possibly(save_object, otherwise = NULL)

walk(open_aq_bucket, ~{
  file_name <- paste0("global-air-quality/data-raw/json-files", .x$Key %>% str_extract("[^/]+$")); 
  
  save_object_safe(
    object = .x,
    file = file_name
  )
})

files <- list.files(path = "global-air-quality/data-raw/json-files", recursive = TRUE, full.names = TRUE)

global_air_quality_us_2016 <- map_dfr(files, ~{
  stream_in(.x) %>% 
    filter(country == "US")
})


write_rds(global_air_quality_us_2016, "global-air-quality/data-raw/global_air_quality_us_2016-full.rds", compress = "gz")


global_air_quality_us_2016 <- global_air_quality_us_2016 %>% 
  select(
    averaging_period_unit = averagingPeriod.unit,
    averaging_period_value = averagingPeriod.value, 
    latitude = coordinates.latitude,
    longitude = coordinates.longitude,
    location,
    city, 
    country, 
    source = sourceName,
    date = date.utc, 
    parameter, 
    value,
    unit
  ) %>% 
  mutate(
    date = str_replace_all(date, "T|\\.[^\\.]+$", " ") %>% 
      str_trim() %>% 
      lubridate::ymd_hms()
  )


write_rds(global_air_quality_us_2016, "global-air-quality/data/global_air_quality_us_2016.rds", "xz", compression = 9L)
