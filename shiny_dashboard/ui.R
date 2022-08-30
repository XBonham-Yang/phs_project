
# Libraries ---------------------------------------------------------------

library(shiny)
library(here)
library(tidyverse)
library(janitor)

# Input Choices -----------------------------------------------------------

hb_choices <- read_csv(here("raw_data/general/hb14_hb19.csv")) %>% 
  clean_names() %>% 
  distinct(hb_name) %>% 
  mutate(hb_name = str_remove(hb_name, "NHS ")) %>% 
  arrange(hb_name) %>% 
  pull()

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  fluidRow(
    
    column(width = 3, offset = 0,
           checkboxGroupInput("health_board_input",
                       "Select the health board?",
                       choices = hb_choices)
           ),
    column(width = 6,
           plotOutput("hb_map")           
           )
  )
)
)

