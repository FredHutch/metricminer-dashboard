library(shiny)
library(bslib)
library(bsicons)
library(htmltools)
library(ggplot2)
library(fontawesome)
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
  title = "ITCR Analytics",
  nav_spacer(),
  nav_panel("Google Analytics",
            layout_columns(
              fill = TRUE,
              value_box(
                # TODO: Dynamic Rendering
                # https://rstudio.github.io/bslib/articles/value-boxes/index.html#dynamic-rendering-shiny
                title = "# of Visits to ITN Website",
                value = 5066,
                p("All-Time"),
                showcase = bsicons::bs_icon("people-fill"),
                showcase_layout = "top right",
              ),
              value_box(
                title = "# of Visits to Courses",
                value = 3965,
                p("All-Time for All Courses"),
                showcase = bsicons::bs_icon("people-fill"),
                showcase_layout = "top right"
              ),
              value_box(
                title = "# of Workshops",
                value = 14,
                p("All-Time for All Workshops"),
                showcase = bsicons::bs_icon("list-ol"),
                showcase_layout = "top right"
              ),
              value_box(
                title = "# of Courses",
                value = 14,
                p("ITCR-funded Courses"),
                showcase = bsicons::bs_icon("book-half"),
                showcase_layout = "top right"
              ),
              value_box(
                title = "Bookdown learners",
                value = 9452,
                p("2447 Coursera learners"),
                showcase = bsicons::bs_icon("calendar-fill"),
                showcase_layout = "top right"
              )
            ),
            layout_column_wrap(
              width = NULL,
              style = css(grid_template_columns = "1.2fr 1fr"),
              navset_card_tab(
                height = 900,
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
              ),
              card(
                card_header("Plot of Users"),
                plotOutput("metric_plot")
              )
              
            )
            
  ),
  nav_panel("GitHub",
            layout_columns(
              fill = FALSE,
              value_box(
                # TODO: Dynamic Rendering
                # https://rstudio.github.io/bslib/articles/value-boxes/index.html#dynamic-rendering-shiny
                title = "Issues/Pull Requests Opened",
                value = 13,
                p("All-Time"),
                showcase = bsicons::bs_icon("exclamation-circle"),
                showcase_layout = "top right",
              ),
              value_box(
                title = "Pull Requests Merged/Closed",
                value = 3965,
                p("All-Time"),
                showcase = bsicons::bs_icon("x-circle"),
                showcase_layout = "top right"
              ),
              value_box(
                title = "Remaining Open Issues",
                value = 23,
                p("All-Time"),
                showcase = bsicons::bs_icon("exclamation-circle"),
                showcase_layout = "top right"
              )
            )
  ),
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
                     searching = FALSE, # remove Search box
                     autoWidth = TRUE,
                     columnDefs = list(list(width = '95px', 
                                            targets = c(1:(ncol(metrics) - 1))))
      ), 
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
      fillContainer = TRUE,
      escape = FALSE
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
  output$metric_plot <- renderPlot({
    ggplot(metrics, aes(x = reorder(website, -activeUsers), y = activeUsers)) +
      geom_bar(stat = "identity", fill = "#89CFF0") +
      theme_classic() +
      theme(axis.text.x = element_text(angle = 45, hjust=1)) +
      xlab("") +
      ylab("Users") +
      geom_text(aes(label = activeUsers), size = 6, vjust = - 1) +
      ylim(c(0, 5500)) +
      theme(axis.title.y = element_text(size = rel(1.5)),
            axis.text.x = element_text(size = rel(1.2)),
            axis.text.y = element_text(size = rel(1.2)))
  })
  
}

options <- list()
if (!interactive()) {
  options$port = 3838
  options$launch.browser = FALSE
  options$host = "0.0.0.0"

}

shinyApp(ui, server, options=options)

