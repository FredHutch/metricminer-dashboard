# Library----
library(shiny)
library(bslib)
library(bsicons)
library(htmltools)
library(ggplot2)
library(fontawesome)
library(metricminer)
library(DT)
library(googlesheets4)
source("data.R")

# Setup ----
googlesheets4::gs4_deauth()

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


# UI----
ui <- page_navbar(
  # Favicon
  tags$head(tags$link(rel="shortcut icon", href="i/img/favicon.ico")),
  # Hard-code version of bootstrap used
  theme = bs_theme(version = 5),
  title = "ITCR Analytics",
  fillable = TRUE,
  nav_spacer(),
  nav_panel("Google Analytics",
            layout_columns(
              fill = FALSE,
              value_box(
                # TODO: Dynamic Rendering
                # https://rstudio.github.io/bslib/articles/value-boxes/index.html#dynamic-rendering-shiny
                title = "# of ITN Website Users",
                value = 5066,
                fill = TRUE,
                p("All-Time"),
                showcase = bsicons::bs_icon("people-fill"),
                showcase_layout = "top right",
              ),
              value_box(
                title = "# of Course Visits",
                value = 3965,
                p("All-Time for All Courses"),
                showcase = bsicons::bs_icon("people-fill"),
                showcase_layout = "top right"
              ),
              value_box(
                title = "# of Workshops",
                value = 14,
                p("All-Time for All Workshops"),
                showcase = bsicons::bs_icon("hammer"),
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
                showcase = bsicons::bs_icon("browser-chrome"),
                showcase_layout = "top right"
              )
            ),
            layout_column_wrap(
              fill = TRUE,
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

# Server----
server <- function(input, output, session) {
  # Google Sheet
  metrics <- reactiveFileReader(1000, session,
                                "https://docs.google.com/spreadsheets/d/13x8lD9SeuPGCs8SbtbRRK_q6o1V_rd3B07JuhebT-vk/edit?usp=sharing",
                                googlesheets4::read_sheet,
                                sheet = "metrics")
  dimensions <- reactiveFileReader(1000, session,
                                "https://docs.google.com/spreadsheets/d/13x8lD9SeuPGCs8SbtbRRK_q6o1V_rd3B07JuhebT-vk/edit?usp=sharing",
                                googlesheets4::read_sheet,
                                sheet = "dimensions")
  link_clicks <- reactiveFileReader(1000, session,
                                "https://docs.google.com/spreadsheets/d/13x8lD9SeuPGCs8SbtbRRK_q6o1V_rd3B07JuhebT-vk/edit?usp=sharing",
                                googlesheets4::read_sheet,
                                sheet = "link_clicks")
  
  
  
  output$metrics_table <- renderDT({
    datatable(
      metrics(), 
      colnames = c("Website", "Active Users", "New Users", "Total Users",
                   "Event Count per User", "Screen Page Views per User",
                   "Sessions", "Average Session Duration", "Screen Page Views",
                   "Engagement Rate"),
      options = list(lengthChange = FALSE, # remove "Show X entries"
                     searching = FALSE, # remove Search box
                     autoWidth = TRUE,
                     columnDefs = list(list(width = '95px', 
                                            targets = c(1:(ncol(metrics()) - 1))))
      ), 
      # For the table to grow/shrink
      fillContainer = TRUE
    )
  })
  output$dimensions_table <- renderDT({
    datatable(
      dimensions(), 
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
      link_clicks(), 
      colnames = c("Website", "Link URL"),
      options = list(lengthChange = FALSE, # remove "Show X entries"
                     searching = FALSE), # remove Search box
      # For the table to grow/shrink
      fillContainer = TRUE,
      escape = FALSE
    )
  })
  output$metric_plot <- renderPlot({
    ggplot(metrics(), aes(x = reorder(website, -activeUsers), y = activeUsers)) +
      geom_bar(stat = "identity", fill = "#007bc2") +
      theme_classic() +
      theme(axis.text.x = element_text(angle = 45, hjust=1)) +
      xlab("") +
      ylab("# of Users") +
      geom_text(aes(label = activeUsers), size = 5, vjust = - 1) +
      ylim(c(0, 5500)) +
      theme(axis.title.y = element_text(size = rel(1.5)),
            axis.text.x = element_text(size = rel(1.4)),
            axis.text.y = element_text(size = rel(1.4)))
  })
  
}

# Code for Deployment to Hutch servers
addResourcePath("/i", file.path(getwd(), "www"))
options <- list()
if (!interactive()) {
  options$port = 3838
  options$launch.browser = FALSE
  options$host = "0.0.0.0"
  
}

shinyApp(ui, server, options=options)

