
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)


shinyUI(fluidPage(
  titlePanel(
    h1("How has covid affected Scotland's Hospitals?",
             align = "center")),
  
  fluidRow(
    
    column(width = 2, offset = 0,
           #style = "border: 4px double blue;",
           pickerInput("health_board_input",
                       "Select the health board?",
                       choices = hb_choices,
                       selected = hb_choices,
                       options = list(`actions-box` = TRUE),
                       multiple = T),
           plotOutput("hb_map") 

           )
    


  ),
  
  fluidRow(
    
    column(width = 6, offset = 0,
           h2("Change in Patient Demographics"),
           style = "border: 4px double blue;",
           
           column(width = 6,
                  plotOutput("demo_plot") #, width = "600px", height = "400px")
           ),
           column(width = 6,
           "Insert SIMD graph here"
    )),
    column(width = 6, offset = 0,
           h2("Hospital Performance Metrics (KPIs)"),
           style = "border: 4px double blue;",
           
           column(width = 4,
                  plotOutput("wait_times_plot")           
           ),
           
           column(width = 8, 
                  plotlyOutput("beds_vs_time"))
           
    ),
  

    fluidRow(
    column(width = 5,
           plotOutput("spe_plot"))

  )
  

  
)
)
)



