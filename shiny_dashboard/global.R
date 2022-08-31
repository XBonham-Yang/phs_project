
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

# Read in data ------------------------------------------------------------

health_board_map <- st_read(dsn = here("clean_data/"),
                                       layer = "health_board_simple")

demo_data <- read_csv(here("clean_data/demo_clean.csv"))

waiting_times <- read_csv(here("clean_data/wait_times.csv"))

beds_animated <- read_csv(here("clean_data/beds_animated.csv"))

specialties <- read_csv(here("clean_data/specialties.csv"))

hb_list_simple <- read_csv(here("clean_data/hb_list_simple.csv")) # wasn't sure that the hb_list_simple had been added
inpatient_and_daycase_by_nhs_board_of_treatment_and_simd_non_covid_cleaned <- read_csv(here("clean_data/inpatient_and_daycase_by_nhs_board_of_treatment_and_simd_non_covid_rr_cleaned.csv"))

# Input Choices -----------------------------------------------------------

hb_choices <- read_csv(here("raw_data/general/hb14_hb19.csv")) %>% 
  clean_names() %>% 
  distinct(hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  arrange(hb_name) %>% 
  pull()

# Colour Palette (not used) -----------------------------------------------

pal <- c(
         rgb(7, 143, 204, maxColorValue = 255),#good blue
         rgb(147, 190, 32, maxColorValue = 255),#good green
         rgb(146, 65, 143, maxColorValue = 255), # good purple 
         rgb(111, 177, 210,maxColorValue = 255),#light blue
         rgb(35, 112, 60,maxColorValue = 255), #dark green 
         rgb(6, 57, 83, maxColorValue = 255) #blue dark 
)
