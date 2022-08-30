
library(shiny)


shinyServer(function(input, output) {
  
  total_admissions <- reactive({specialties %>% 
    filter(hb_name %in% input$health_board_input) %>% 
    group_by(is_covid_year) %>% 
    filter(admission_type == "All Inpatients and Day cases") %>% 
    summarise(total_admissions = sum(episodes)) })
  
  change_in_specialties <- reactive({specialties %>% 
    filter(hb_name %in% input$health_board_input) %>% 
    group_by(specialty_name, is_covid_year) %>% 
    summarise(total_episodes = sum(episodes)) %>% 
    pivot_wider(names_from = is_covid_year, values_from = total_episodes) %>% 
    rename("covid_year" = "TRUE", "pre_covid_year" = "FALSE") %>% 
    mutate(pre_covid_year_prop = pre_covid_year / total_admissions[1],
           covid_year_prop = covid_year /total_admissions[2],
           percentage_change = covid_year_prop - pre_covid_year_prop)
  })

    output$hb_map <- renderPlot({

      health_board_map %>%
        ggplot() +
        geom_sf(fill = pal[5], col = "gray40") +
        geom_sf(data = health_board_map %>% filter(hb_name %in% input$health_board_input),
                fill = pal[7]) +
        theme_void()
   

    })
    
    output$sep_plot <- renderPlot({
      change_in_specialties %>% 
        arrange(desc(percentage_change)) %>% 
        head(5) %>% 
        filter(percentage_change > 0) %>% 
        ggplot(aes(x = reorder(specialty_name, percentage_change, decreasing = TRUE),
                   y = percentage_change)) +
        geom_col(aes(fill = specialty_name)) +
        theme_classic() +
        scale_y_continuous(labels = percent_format())+
        theme(axis.title.x = element_blank(),
              axis.text.x = element_text(size = 8,angle = 45, hjust = 1)) +
        labs(y = "Percentage Increase (%)",
             title = "Increase in hospital admissions (by specialty) - pre-Covid vs Covid")
      
    })

})
