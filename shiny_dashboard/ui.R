
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)


shinyUI(fluidPage(
  
  fluidRow(
    
    column(width = 12, 
           "How has covid affected Scotland's Hospitals?"
           )
  ),
  
  fluidRow(
    
    column(width = 2, offset = 0,
           pickerInput("health_board_input",
                       "Select the health board?",
                       choices = hb_choices,
                       selected = hb_choices,
                       options = list(`actions-box` = TRUE),
                       multiple = T),
           plotOutput("hb_map") 

           ),

  ),
  
  fluidRow(
    
    column(width = 6,
           plotOutput("demo_plot", width = "600px", height = "400px")
           ),
    column(width = 6,
           plotOutput("wait_times_plot")           
    )
    
           ),
  

    fluidRow(
    column(width = 5,
           plotOutput("spe_plot")),

    column(width = 6, 
           plotlyOutput("beds_vs_time"))

  )
  

  
)
)


