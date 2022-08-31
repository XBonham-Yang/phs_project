
library(shiny)


shinyServer(function(input, output) {
  
  output$hb_map <- renderPlotly({

    p <- health_board_map %>%
      ggplot(aes(text = hb_name)) +
      geom_sf(fill = "gray90", col = "gray40", size = 0.1) +
      geom_sf(data = health_board_map %>% filter(hb_name %in% input$health_board_input),
              fill = pal[6], size = 0.1, colour = "white") +
      theme_void()
    
    ggplotly(p,
    tooltip = "text") %>%
      config(scrollZoom = TRUE,
             displayModeBar = F,
             showAxisDragHandles = F)
    
})
  
  age_sex <- reactive({
    demo_data %>%
      filter(hb_name %in% input$health_board_input)
  })
  
  wait_times <- reactive({
    waiting_times %>% 
      filter(hb_name %in% input$health_board_input)
  })
  
  output$demo_plot <- renderPlot({
    
    total_pre_covid <- age_sex() %>% 
      group_by(is_covid_year) %>% 
      summarise(total_episodes = sum(episodes))
    
    age_sex() %>%
      filter(hb_name %in% input$health_board_input) %>% 
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
                size = 4) +
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
           title = "Changes in Age and Sex proportions")
  })
  
  output$wait_times_plot <- renderPlot({
    
    wait_times() %>% 
      group_by(is_covid_year) %>% 
      summarise(sum_attendance = sum(total_attendance), 
                wait_target = sum(wait_lt_4hrs)) %>% 
      pivot_longer(wait_target, names_to = "wait_time", values_to = "value") %>% 
      mutate(proportion = value / sum_attendance) %>%
      mutate(ymin = rescale(0, to = pi*c(-.5,.5), from = 0:1), 
             ymax = rescale(proportion, to = pi*c(-.5,.5), from = 0:1)) %>%
      ggplot(aes(x0 = 0, y0 = 0, r0 = .5, r = 1)) + 
      geom_arc_bar(aes(start = - pi / 2, end = pi / 2), fill = "grey80") +
      geom_arc_bar(aes(x0 = 0, y0 = 0, r0 = .5, r = 1, start = ymin, end = ymax,
                       fill = proportion)) +
      coord_fixed() +
      facet_wrap(~ is_covid_year, ncol = 1) +
      ylim(-0.3, 1) +
      geom_text(aes(x = 0, y = 0.01,
                    label = scales::percent(proportion, accuracy = 0.1)),
                size = 6.5) +
      geom_text(aes(x = 0, y = -0.25),
                label = c("Pre-Covid", "During Covid"),
                size = 4.2) +
      theme_void() +
      theme(strip.background = element_blank(),
            strip.text = element_blank(),
            legend.position = "none",
            title = element_text(face = "bold", size = 14),
            plot.margin = unit(c(0, 0, 0, 0), "cm")) +
      labs(title = "Proportion of A&E attendances\nmeeting target (<4hrs)")
    
  })
  
  total_admissions <- reactive({specialties %>% 
    filter(hb_name %in% input$health_board_input) %>% 
    group_by(is_covid_year) %>% 
    filter(admission_type == "All Inpatients and Day cases") %>% 
    summarise(total_admissions = sum(episodes)) %>% pull()})
  
  change_in_specialties <- reactive({specialties %>% 
    filter(hb_name %in% input$health_board_input) %>% 
    group_by(specialty_name, is_covid_year) %>% 
    summarise(total_episodes = sum(episodes)) %>% 
    pivot_wider(names_from = is_covid_year, values_from = total_episodes) %>% 
    rename("covid_year" = "TRUE", "pre_covid_year" = "FALSE") %>% 
    mutate(pre_covid_year_prop = pre_covid_year / total_admissions()[1],
           covid_year_prop = covid_year /total_admissions()[2],
           percentage_change = covid_year_prop - pre_covid_year_prop)%>% 
      arrange(desc(percentage_change)) %>% head(5) %>% 
      filter(percentage_change > 0)  
  })

   
    
    output$spe_plot <- renderPlotly({
        ggplot(change_in_specialties())+
          aes(x = specialty_name,
                   y = percentage_change) +
        geom_col(aes(fill = specialty_name)) +
        theme_classic() +
        scale_fill_manual(values = pal)+
        scale_colour_manual(values = pal)+
        scale_y_continuous(labels = percent_format())+
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
              title = element_text(size = 14, face = "bold"))+ 
        labs(y = "Percentage Increase (%)",
             title = "Increase in hospital admissions pre-Covid vs Covid",
             subtitle = "- by specialty")
    })
      

    output$animated_beds <- renderPlotly({
      
      beds_animated %>%
        group_by(frame) %>%
        filter(hb_name %in% input$health_board_input) %>%
        ggplot(aes(x = hb_name, y = percentage_occupancy, fill = frame))+
        geom_bar(stat = "identity", position = "dodge")+
        theme(panel.background = element_blank(),
              legend.title = element_blank())+
        labs(x = "Health Board",
             y = "Perecntage Occupancy")+
        coord_flip()+
        labs(title = "Pre vs Post-Covid Occupancy",
             x = "Health Board",
             y = "Avg. Occupancy")+
        scale_fill_manual(values = pal)

    })

    total_attendance <- reactive({
      
      demo_data %>% 
        filter(hb_name %in% input$health_board_input)
      
    })
    
    hb_label <- reactive({
      
      if(length(input$health_board_input) == 14) {
        hb_label <- "All Health Boards"
      } else {
        hb_label <- str_c("Total of Multiple HBs:\n",
                          str_c(input$health_board_input, collapse = ",\n"))
      }
      
    })
    
    hb_plotly_label <- reactive({
      
      if(length(input$health_board_input) <= 5) {
        
        hb_plotly_label = input$health_board_input
        
      } else{
        
        if(length(input$health_board_input) == 14) {
          
          hb_plotly_label <- "All Health Boards"
          
        } else {
          
        hb_plotly_label <- str_c("Total of Multiple HBs:\n",
                          str_c(input$health_board_input, collapse = ",\n"))
      }
      
    }})
    
    output$attendance_plot <- renderPlotly({
      
      if(length(input$health_board_input) <= 5) {

        p <-  total_attendance() %>% 
          group_by(quarter, hb_name) %>% 
          summarise(total_attendance = sum(episodes)) %>% 
          mutate(HB = paste(hb_name,"\nAttendance: ", comma(total_attendance),
                            "\nDate: ", quarter)) %>% 
          ggplot(aes(x = quarter, y = total_attendance, colour = hb_name, 
                     label = HB)) +
          geom_line()
        
      } else {

        p <- total_attendance() %>%  
          mutate(hb_label = hb_label()) %>% 
          group_by(quarter) %>% 
          summarise(total_attendance = sum(episodes)) %>%
          mutate(HB = paste(hb_label(),"\nAttendance: ", comma(total_attendance),
                            "\nDate: ", quarter)) %>% 
          ggplot(aes(x = quarter, y = total_attendance, colour = hb_label(),
                     label = HB)) +
          geom_line()
        
      }
      
      p <- p + theme_classic() +
        scale_y_continuous(labels = comma,
                           expand = c(0, 0),
                           limits = c(0, NA)) +
        labs(title = "Total hospital attendances: July 2007 to June 2022",
             subtitle = "Up to 5 health boards shown at a time, >5 selections shows total of selected",
             col = "Health Board",
             y = "Total Hospital Admissions") +
        theme(axis.title.x = element_blank(),
              axis.text.x = element_text(angle = 45, hjust = 1),
              legend.text.align = 0,
              panel.background = element_rect(colour = "black"))
      
      ggplotly(p,
               tooltip = c("label")) %>% 
        config(displayModeBar = F) %>% 
        layout(hovermode = "x") 

    })
    
    simd <- reactive({
      inpatient_and_daycase_by_nhs_board_of_treatment_and_simd_non_covid_cleaned %>% 
          filter(hb_name %in% input$health_board_input)    
    })
    
    output$simd_total_stays <- renderPlot({
        simd() %>% 
        select(quarter_year, year, hb_name, simd, admission_type, stays, is_covid_year) %>%
        filter(!is.na(simd)) %>%
        group_by(is_covid_year, simd) %>%
        summarise(total_stays = sum(stays)) %>% 
        ggplot()+
        aes(x = is_covid_year, y = total_stays, fill = simd)+
        geom_col(stat="idendity", position = "fill")+
        theme_classic() +
        theme(axis.title.x = element_blank(),
              axis.text.x = element_text(angle = 45, hjust = 1)) +
        ylab("Sum of hospital stays")+
        ggtitle("Total hospital stays by SIMD data")+
        geom_text(aes(label = total_stays), position = position_fill(vjust=0.5), colour = "white")+
        scale_y_continuous(label = scales::percent)  
    })
    
    
})
