
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
    
    
    age_sex <- reactive({
      demo_data %>%
      filter(hb_name %in% input$health_board_input)
    })
    
    
    output$demo_plot <- renderPlot({
      
      total_pre_covid <- age_sex() %>% 
        group_by(is_covid_year) %>% 
        summarise(total_episodes = sum(episodes))
      
      age_sex() %>%
        # filter(hb_name %in% input$health_board_input) %>% 
        group_by(is_covid_year, sex, age) %>% 
        summarise(sum_episodes = sum(episodes)) %>%
        left_join(total_pre_covid, by = "is_covid_year") %>% 
        mutate(sex = factor(sex, c("Male", "Female")),
                            prop_age_group = if_else(is_covid_year == "Pre_Covid", 
                                        sum_episodes / total_episodes,
                                        sum_episodes / total_episodes)) %>%  
        select(-sum_episodes, -total_episodes) %>% 
        pivot_wider(names_from = is_covid_year, values_from = prop_age_group) %>% 
        mutate(diff = Covid - Pre_Covid,
               is_positive = if_else(diff > 0, TRUE, FALSE)) %>% 
        select(sex, age, diff, is_positive) %>% 
        ggplot(aes(x = age, y = diff, fill = is_positive)) +
        geom_col() +
        geom_hline(yintercept = 0) +
        geom_text(aes(label = scales::percent(diff, accuracy = 0.01),
                      y = diff + 0.0015 * sign(diff)),
                  size = 5) +
        scale_fill_manual(values = c("red", "seagreen")) +
        facet_wrap(~ sex, ncol = 1) +
        theme_classic() +
        theme(legend.position = "none",
              axis.text.x = element_text(angle = 45, hjust = 1, size = 12, face = "bold"),
              axis.title.x = element_blank(),
              strip.background = element_rect(
                color="white", fill = NA, size = 1.5, linetype = 0
              ),
              strip.text = element_text(face = "bold", size = 12),
              strip.placement = "inside",
              axis.line.x = element_blank(),
              axis.ticks.x = element_blank(),
              axis.line.y = element_blank(),
              axis.text.y = element_blank(),
              axis.ticks.y = element_blank(),
              axis.title.y = element_blank(),
              title = element_text(size = 14, face = "bold")) +
        labs(y = "Change (%)",
             title = "Change in demographic proportions: Pre-Covid vs Covid")
    })

})
