
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
    output$hb_map <- renderPlot({
      
      total_admission_by_hb_age_sex_2022_03_02_cleaned <- read_csv("../../data/olympics_overall_medals.csv")
      total_adm_equal <- hospital_admissions_by_hb_agesex_2022_03_02_cleaned %>%
        filter(admission_type == "All") %>% 
        filter(age_group_fct != "All ages") %>% 
        filter(sex == "All") %>%
        filter(hb != "") %>% 
        select(hb, month_year, month_of_admission, number_admissions, age_group_fct) %>% 
        distinct() %>% 
        group_by(month_year, age_group_fct) %>%
        summarise(sum_admissions = sum(number_admissions)) %>% 
        ggplot()+
        aes(x = month_year, y = sum_admissions, group = age_group_fct, col = age_group_fct)+
        geom_line()+
        xlab("tbc")+
        ylab("tbc")+
        ggtitle("Admissions by Age Group")
      
      total_adm_equal
      
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
