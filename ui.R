
# Libraries ---------------------------------------------------------------

library(shiny)
library(here)
library(tidyverse)
library(janitor)
library(tsibble)

# Input Choices -----------------------------------------------------------

hb_choices <- read_csv(here("raw_data/general/hb14_hb19.csv")) %>% 
  clean_names() %>% 
  distinct(hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  arrange(hb_name) %>% 
  pull()

beds_available <- read_csv("clean_data/beds_available.csv")

beds_available <- tsibble(beds_available, index = "wheny", key = c(hb, month, all_staffed_beddays, total_occupied_beddays, year, population_catchment, specialty_name, hb_name)) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS")) 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  fluidRow(
    
    column(width = 3, offset = 0,
           checkboxGroupInput("health_board_input",
                              "Select the health board?",
                              choices = hb_choices, selected = "Lothian")
    ),
    column(width = 6,
           plotOutput("hb_map")           
    ),
    column(width = 6, 
           plotlyOutput("beds_vs_time")
    )
  )
)
)


