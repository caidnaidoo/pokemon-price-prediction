library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

server <- function(input, output, session){
  
  # ---- LOAD CLEANED DATA ----
  cards <- readRDS("../data/cleaned/cards_cleaned.rds")
  
  # ---- UPDATE SELECT LISTS ----
  updateSelectInput(session, "card_choice",
                    choices = unique(cards$name))
  
  updateSelectInput(session, "card1",
                    choices = unique(cards$name))
  
  updateSelectInput(session, "card2",
                    choices = unique(cards$name))
  
  
  # ---- REACTIVE SELECTION ----
  selected_card <- reactive({
    cards %>% filter(name == input$card_choice)
  })
  
  # ---- PRICE HISTORY PLOT ----
  output$price_plot <- renderPlotly({
    df <- selected_card()
    
    p <- ggplot(df, aes(date, price)) +
      geom_line() +
      theme_minimal() +
      labs(title = paste("Price History:", input$card_choice))
    
    ggplotly(p)
  })
  
  # ---- SUMMARY TABLE ----
  output$card_summary <- renderTable({
    selected_card() %>%
      summarize(
        mean_price = mean(price, na.rm=TRUE),
        sd_price   = sd(price, na.rm=TRUE),
        last_price = dplyr::last(price)
      )
  })
  
  # ---- COMPARISON PLOT ----
  output$compare_plot <- renderPlotly({
    df1 <- cards %>% filter(name == input$card1)
    df2 <- cards %>% filter(name == input$card2)
    
    p <- ggplot() +
      geom_line(data = df1, aes(date, price, color = input$card1)) +
      geom_line(data = df2, aes(date, price, color = input$card2)) +
      theme_minimal() +
      labs(title = "Comparison")
    
    ggplotly(p)
  })
  
  # ---- RISK RETURN PLOT ----
  output$risk_plot <- renderPlotly({
    risk_stats <- cards %>%
      group_by(name) %>%
      summarize(
        mean_ret = mean(return, na.rm=TRUE),
        sd_ret   = sd(return, na.rm=TRUE)
      )
    
    p <- ggplot(risk_stats, aes(sd_ret, mean_ret)) +
      geom_point() +
      geom_text(aes(label = name), hjust=1, vjust=1) +
      theme_minimal() +
      labs(title = "Risk vs Return")
    
    ggplotly(p)
  })
  
}   # <---- END OF SERVER FUNCTION
