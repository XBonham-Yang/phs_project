
# Load in libraries

library(tidyverse)
library(janitor)
library(here)


# Health Board Data -------------------------------------------------------

hb_raw <- read_csv("raw_data/general/hb14_hb19.csv")

hb_raw %>% 
  clean_names() %>% 
  select(hb, hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  write_csv("clean_data/hb_list_simple.csv")


# Age & Sex Demographics --------------------------------------------------

demo_raw <- read_csv("raw_data/non_covid/inpatient_and_daycase_by_nhs_board_of_treatment_age_and_sex.csv")

hb <- read_csv("clean_data/hb_list_simple.csv")

demo_raw %>% 
  clean_names() %>% 
  left_join(hb, "hb") %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  select(-ends_with("qf"), -hb) %>% 
  select(quarter, hb_name, location:episodes) %>% 
  mutate(sex = factor(sex, c("Male", "Female")),
         year = as.numeric(str_sub(quarter, 1, 4)),
         is_covid_year = case_when(
           year <= 2019 ~ "Pre_Covid", #
           year >= 2020 ~ "Covid"), # set covid to be Q2 of 2020
         is_covid_year = factor(is_covid_year, c("Pre_Covid", "Covid"))) %>%
  filter(!is.na(is_covid_year)) %>% 
  write_csv("clean_data/demo_clean.csv")


# Health Board Map (Simplified) -------------------------------------------

health_board_map <- st_read(dsn = "raw_data/shape_files/",
                            layer = "SG_NHS_HealthBoards_2019") 
 
health_board_map %>% 
  clean_names() %>% 
  st_simplify(dTolerance = 1000) %>% 
  st_cast("MULTIPOLYGON") %>% 
  st_write(dsn = "clean_data/",
           layer = "health_board_simple",
           driver = "ESRI Shapefile")

