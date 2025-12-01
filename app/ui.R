library(shiny)
library(plotly)

ui <- navbarPage(
  "Pokémon Price Dashboard",
  
  # ---- PAGE 1: Card History ----
  tabPanel("Card History",
           sidebarLayout(
             sidebarPanel(
               selectInput("card_choice", "Select Card:",
                           choices = NULL),   # Filled in server
               checkboxInput("show_predictions", "Show Predicted Price", FALSE)
             ),
             mainPanel(
               plotlyOutput("price_plot"),
               tableOutput("card_summary")
             )
           )
  ),
  
  # ---- PAGE 2: Compare Cards ----
  tabPanel("Compare Cards",
           sidebarLayout(
             sidebarPanel(
               selectInput("card1", "Card 1:", choices = NULL),
               selectInput("card2", "Card 2:", choices = NULL)
             ),
             mainPanel(
               plotlyOutput("compare_plot")
             )
           )
  ),
  
  # ---- PAGE 3: Risk/Return ----
  tabPanel("Risk & Return",
           fluidPage(
             plotlyOutput("risk_plot"),
             tableOutput("risk_table")
           )
  )
)

