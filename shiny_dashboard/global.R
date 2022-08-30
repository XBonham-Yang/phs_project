
library(tidyverse)
library(janitor)
library(sf)
library(here)
library(plotly)




pal <- c(rgb(199, 175, 117, maxColorValue = 255),
         rgb(124, 36, 24, maxColorValue = 255), 
         rgb(210, 221, 213, maxColorValue = 255), 
         rgb(168, 106, 57, maxColorValue = 255), 
         rgb(222, 224, 227, maxColorValue = 255),
         rgb(186, 158, 53, maxColorValue = 255), 
         rgb(6, 57, 83, maxColorValue = 255), 
         rgb(109, 67, 85, maxColorValue = 255)
)

health_board_map <- st_read(dsn = here("raw_data/shape_files/"),
                            layer = "SG_NHS_HealthBoards_2019") %>% 
  
  clean_names() %>% 
  st_simplify(dTolerance = 1000) %>% 
  st_cast("MULTIPOLYGON")

beds_available <- read_csv(here("clean_data/beds_available.csv"))

  
