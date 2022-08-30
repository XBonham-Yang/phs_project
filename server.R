
library(shiny)
library(tsibble)

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
    
    output$beds_vs_time <- renderPlotly({
      
      tsibble(beds_available, index = "wheny", key = c(hb, month, all_staffed_beddays, total_occupied_beddays, year, population_catchment, specialty_name, hb_name))%>% 
        mutate(hb_name = str_remove(hb_name, "NHS"))%>% 
        group_by(hb_name) %>% 
        summarise(avg_occupancy = sum(total_occupied_beddays / sum(all_staffed_beddays))*100)%>%  
        ungroup() %>% 
        filter(hb_name %in% input$health_board_input) %>%
        ggplot(aes(x = wheny, y = avg_occupancy, colour = hb_name))+
        geom_line()+
        labs(title = "Avg. Beds Available by Population Status",
             x = "Date",
             y = "Percentage Occupancy")+
        theme(panel.background = element_blank())
    })

})

