library(shiny)
library(metricminer)

ui <- navbarPage("ITCR Analytics",
  tabPanel("GitHub"),
  tabPanel("Google Analytics"),
  tabPanel("Calendly")
)

server <- function(input, output) { }

shinyApp(ui, server)