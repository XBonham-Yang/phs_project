
# Libraries ---------------------------------------------------------------

library(tidyverse)
library(janitor)
library(sf)
library(here)
library(plotly)
library(ggforce)
library(reshape2)
library(infer)
library(scales)
library(tsibble)
library(gganimate)

# Read in data ------------------------------------------------------------

health_board_map <- st_read(dsn = here("clean_data/"),
                                       layer = "health_board_simple")

demo_data <- read_csv(here("clean_data/demo_clean.csv"))

waiting_times <- read_csv(here("clean_data/wait_times.csv"))

beds_available <- read_csv(here("clean_data/beds_available.csv"))

beds_available <- tsibble(beds_available, index = "wheny", key = c(hb, month, all_staffed_beddays, total_occupied_beddays, year, population_catchment, specialty_name, hb_name)) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS"))

specialties <- read_csv(here("clean_data/specialties.csv"))

animated_data <- read_csv(here("clean_data/animated_data.csv"))

# Input Choices -----------------------------------------------------------

hb_choices <- read_csv(here("raw_data/general/hb14_hb19.csv")) %>% 
  clean_names() %>% 
  distinct(hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  arrange(hb_name) %>% 
  pull()

# Colour Palette (not used) -----------------------------------------------

pal <- c(rgb(199, 175, 117, maxColorValue = 255),
         rgb(124, 36, 24, maxColorValue = 255), 
         rgb(210, 221, 213, maxColorValue = 255), 
         rgb(168, 106, 57, maxColorValue = 255), 
         rgb(222, 224, 227, maxColorValue = 255),
         rgb(186, 158, 53, maxColorValue = 255), 
         rgb(6, 57, 83, maxColorValue = 255), 
         rgb(109, 67, 85, maxColorValue = 255)
)
