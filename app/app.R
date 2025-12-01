library(shiny)
library(dplyr)
library(ggplot2)

cards <- readRDS("../data/cleaned/cards_cleaned.rds")

ui <- fluidPage(
  titlePanel("Pokémon Card Price Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "card",
        "Select a Card:",
        choices = unique(cards$card_name)
      ),
      actionButton("refresh", "Reload Data")
    ),
    
    mainPanel(
      h3("Card Summary"),
      tableOutput("card_info"),
      
      h3("Condition Prices"),
      tableOutput("conditions"),
      
      h3("Price Visualization (Coming Soon)"),
      plotOutput("price_plot")
    )
  )
)

server <- function(input, output, session) {
  
  selected <- reactive({
    cards %>% filter(card_name == input$card)
  })
  
  output$card_info <- renderTable({
    selected() %>%
      select(card_name, set_name, rarity, market_price)
  })
  
  output$conditions <- renderTable({
    selected()$conditions[[1]]
  })
  
  output$price_plot <- renderPlot({
    plot(1,1, main="Model predictions coming soon!")
  })
}

shinyApp(ui, server)
