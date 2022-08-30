
library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$hb_map <- renderPlot({

      # ggplotly(
      health_board_map %>%
        ggplot() +
        geom_sf(fill = pal[5], col = "gray40") +
        geom_sf(data = health_board_map %>% filter(hb_name %in% input$health_board_input),
                fill = pal[7]) +
        theme_void()
      # tooltip = "text")

    })

})
