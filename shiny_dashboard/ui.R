
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)


shinyUI(fluidPage(
  titlePanel(
    h2("How has covid affected Scotland's Hospitals?",
             align = "left")),
  
  fluidRow(
    
    column(width = 2, offset = 0,
           style = "border: 4px double blue;",
           pickerInput("health_board_input",
                       "Select Health Board(s)",
                       choices = hb_choices,
                       selected = hb_choices,
                       options = list(`actions-box` = TRUE),
                       multiple = T),
           plotlyOutput("hb_map", height = "382px")
           ),
    
    column(width = 10,
           h3("Trends in hospital admissions"),
           style = "border: 4px double blue;",
           column(width = 8,
                  plotlyOutput("attendance_plot")
           ),
           column(width = 4,
                  plotOutput("spe_plot")
           )
    )
  ),
  
  fluidRow(
    
    column(width = 6, offset = 0,
           h3("Change in Patient Demographics: Pre-Covid vs During Covid"),
           style = "border: 4px double blue;",
           
           column(width = 6,
                  plotOutput("demo_plot") #, width = "600px", height = "400px")
           ),
           column(width = 6,
           "Insert SIMD graph here"
    ))
    ,
    column(width = 6, offset = 0,
           h3("Hospital Performance Metrics (KPIs)"),
           style = "border: 4px double blue;",
           
           column(width = 4,
                  plotOutput("wait_times_plot")           
           ),
           
           column(width = 8, 
                  plotlyOutput("beds_vs_time"))
           
    ),
    
    
  )
)
)



