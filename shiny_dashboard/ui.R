
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)


shinyUI(fluidPage(
  
  
  theme = bs_theme(bootswatch = "simplex"),
  

  titlePanel(
    h1(strong("How has covid affected Scotland's Hospitals?"),
       align = "left")),
  
  fluidRow(

    column(width = 2, offset = 0,
           h4(strong("Inputs")),
           tags$form(class = "well",
           pickerInput("health_board_input",
                       strong("Select Health Board(s)"),
                       choices = hb_choices,
                       selected = hb_choices,
                       options = list(`actions-box` = TRUE),
                       multiple = T),
           actionButton("update", "Update", icon = icon("bar-chart-o")),
           plotlyOutput("hb_map", height = "293px")
           )
    ),
    
    
    column(width = 10,
           h4(strong("Trends in hospital admissions")),
           
           tags$form(class = "well",
                     fluidRow(
                       column(width = 7,
                              plotlyOutput("attendance_plot")
                       ),
                       column(width = 5,
                              plotlyOutput("spe_plot")
                       )
                     )
           )
    )
  ),
  
  fluidRow(
    
    column(width = 6, offset = 0,
           h4(strong("Change in Patient Demographics: Pre-Covid vs During Covid")),
           tags$form(class = "well",
                     fluidRow(
                       column(width = 7,
                              plotOutput("demo_plot")
                       ),
                       column(width = 5,
                              plotOutput("simd_total_stays")
                       ))
           )
           
    )

  ,
  column(width = 6, offset = 0,
         h4(strong("Hospital Performance Metrics (KPIs)\n")),
         tags$form(class = "well",
                   fluidRow(
                     column(width = 8,
                            plotlyOutput("animated_beds") 
                     ),
                     
                     column(width = 4,
                            plotOutput("wait_times_plot"))
                     
                   )
         )
  )
  ),
  tags$i("Open data from Public Health Scotland are used for this dashboard."),
  tags$a("The Public Health Scotland Website", href = "https://publichealthscotland.scot/")
  
)
)




