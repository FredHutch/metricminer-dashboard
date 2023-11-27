library(shiny)
library(bslib)
library(metricminer)
library(DT)
source("data.R")

link_itn <- tags$a(
  shiny::icon("house"), "ITN",
  href = "https://www.itcrtraining.org/home",
  target = "_blank"
)
link_code <- tags$a(
  shiny::icon("github"), "Code",
  href = "https://github.com/fhdsl/metricminer-dashboard",
  target = "_blank"
)
link_help <- tags$a(
  shiny::icon("circle-question"), "Help",
  href = "https://github.com/fhdsl/metricminer-dashboard/issues/new",
  target = "_blank"
)


ui <- page_navbar(
  # Hard-code version of bootstrap used
  theme = bs_theme(version = 5),
  title = "ITCR Analytics Dashboard",
  nav_spacer(),
  nav_panel("Google Analytics",
            layout_columns(
              fill = FALSE,
              value_box(
                # TODO: Dynamic Rendering
                # https://rstudio.github.io/bslib/articles/value-boxes/index.html#dynamic-rendering-shiny
                title = "Value 1 comes here",
                value = 12,
                showcase = bsicons::bs_icon("people-fill")
              ),
              value_box(
                title = "Value 2 comes here",
                value = 23,
                showcase = bsicons::bs_icon("person-circle")
              ),
              value_box(
                title = "Value 3 comes here",
                value = 23,
                showcase = bsicons::bs_icon("list-ol")
              )
            ),
            navset_card_tab(
              height = 450,
              full_screen = TRUE,
              title = "Tables",
              nav_panel(
                "Metrics",
                DTOutput("metrics_table")
              ),
              nav_panel(
                "Dimensions",
                DTOutput("dimensions_table")
              ),
              nav_panel(
                "Link Clicks",
                DTOutput("link_clicks_table")
              )
            )
  ),
  nav_panel("GitHub"),
  nav_panel("Calendly"),
  nav_menu(
    title = "Links",
    align = "right",
    nav_item(link_itn),
    nav_item(link_code),
    nav_item(link_help)
  )
)

server <- function(input, output) {
  output$metrics_table <- renderDT({
    datatable(
      metrics, 
      colnames = c("Website", "Active Users", "New Users", "Total Users",
                   "Event Count per User", "Screen Page Views per User",
                   "Sessions", "Average Session Duration", "Screen Page Views",
                   "Engagement Rate"),
      options = list(lengthChange = FALSE, # remove "Show X entries"
                     searching = FALSE), # remove Search box
      # For the table to grow/shrink
      fillContainer = TRUE
    )
  })
  output$dimensions_table <- renderDT({
    datatable(
      dimensions, 
      colnames = c("Website", "Day", "Month", "Year",
                   "Country", "Full Page URL"),
      options = list(lengthChange = FALSE, # remove "Show X entries"
                     searching = FALSE), # remove Search box
      # For the table to grow/shrink
      fillContainer = TRUE
    )
  })
  output$link_clicks_table <- renderDT({
    datatable(
      link_clicks, 
      colnames = c("Website", "Link URL"),
      options = list(lengthChange = FALSE, # remove "Show X entries"
                     searching = FALSE), # remove Search box
      # For the table to grow/shrink
      fillContainer = TRUE,
      escape = FALSE
    )
  })
  
}

shinyApp(ui, server)