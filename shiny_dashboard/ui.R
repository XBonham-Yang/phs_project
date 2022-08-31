
# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyWidgets)
library(bslib)

shinyUI(fluidPage( theme = bs_theme(bootswatch = "readable"),
  titlePanel(
    h2("How has covid affected Scotland's Hospitals?",
             align = "left")),
  fluidRow(column(width = 2, 
               pickerInput("health_board_input",
                           "Select Health Board(s)",
                           choices = hb_choices,
                           selected = hb_choices,
                           options = list(`actions-box` = TRUE),
                           multiple = T),
               plotlyOutput("hb_map", height = "382px")
        ),
  
  column(width = 9,style = "border: 4px double steelblue;",
        h3("Trends in hospital admissions"),
        column(width = 5,
               plotlyOutput("attendance_plot")
        ),
        column(width = 3,
               plotlyOutput("spe_plot")
        )
  )),
  
  fluidRow( style = "border: 4px double steelblue;",
    column(width = 6, offset = 0,
           h3("Change in Patient Demographics: Pre-Covid vs During Covid"),
           style = "border: 2px double steelblue;",
           column(width = 2.5,
                  style = "border: 4px double grey;",
                  plotOutput("demo_plot") #, width = "600px", height = "400px")
           ),
           column(width = 2.5,
                  style = "border: 4px double grey;",
                  plotOutput("simd_total_stays")
    )),
    
    column(width = 6, offset = 0,
           h3("Hospital Performance Metrics (KPIs)\n"),
           style = "border: 2px double steelblue;",
           column(width = 2.5,
                  style = "border: 4px double grey;",
                  plotOutput("wait_times_plot")           
           ),
           
           column(width = 2.5, 
                  style = "border: 4px double grey;",
                  plotlyOutput("animated_beds"))
           
    )
    
    
  ),
  tags$i("Open data from Public Health Scotland are used for this dashboard."),
  tags$a("The Public Health Scotland Website", href = "https://publichealthscotland.scot/")
)
)



