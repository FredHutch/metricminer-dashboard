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
            card(
              card_header("Metrics Table"),
              DTOutput("metrics_table")
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
      metrics, fillContainer = TRUE
    )
  })
  
}

shinyApp(ui, server)