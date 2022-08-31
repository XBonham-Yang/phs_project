
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)


shinyUI(fluidPage(
  
  
  # theme = bs_theme(bootswatch = "morph"),
  

  titlePanel(
    h2("How has covid affected Scotland's Hospitals?",
       align = "left")),
  
  
  fluidRow(

    column(width = 2, offset = 0,
           h4("Inputs"),
           tags$form(class = "well",
           pickerInput("health_board_input",
                       "Select Health Board(s)",
                       choices = hb_choices,
                       selected = hb_choices,
                       options = list(`actions-box` = TRUE),
                       multiple = T),
           actionButton("update", "Update"),
           plotlyOutput("hb_map", height = "293px")
           )
    ),
    
    column(width = 10,
           h4("Trends in hospital admissions"),
           tags$form(class = "well",
                     fluidRow(
                       column(width = 8,
                              plotlyOutput("attendance_plot")
                       ),
                       column(width = 4,
                              plotlyOutput("spe_plot")
                       )
                     )
           )
    )
  ),
  
  fluidRow(
    
    column(width = 6, offset = 0,
           h4("Change in Patient Demographics: Pre-Covid vs During Covid"),
           tags$form(class = "well",
                     fluidRow(
                       column(width = 6,
                              plotOutput("demo_plot")
                       ),
                       column(width = 6,
                              plotOutput("simd_total_stays")
                       ))
           )
           
    )

  ,
  column(width = 6, offset = 0,
         h4("Hospital Performance Metrics (KPIs)"),
         tags$form(class = "well",
                   fluidRow(
                     column(width = 4,
                            plotOutput("wait_times_plot")           
                     ),
                     
                     column(width = 8, 
                            plotlyOutput("animated_beds"))
                     
                   )
         )
  )
  )
  
)
)




