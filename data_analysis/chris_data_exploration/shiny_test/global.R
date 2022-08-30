
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

health_board_map <- st_read(dsn = here("clean_data/"),
                                       layer = "health_board_simple")

demo_data <- read_csv(here("clean_data/demo_clean.csv"))

# Input Choices -----------------------------------------------------------

hb_choices <- read_csv(here("raw_data/general/hb14_hb19.csv")) %>% 
  clean_names() %>% 
  distinct(hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  arrange(hb_name) %>% 
  pull()