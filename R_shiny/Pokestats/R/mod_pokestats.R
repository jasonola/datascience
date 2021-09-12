#' pokestats UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_pokestats_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("pokemon"),
      label = "Choose a Pokemon",
      choices = stringr::str_to_title(get_pokemon_names()$name),
      selected = "Pikachu",
      multiple = T
    ),
    plotOutput(ns("stat_plot")),
    DT::DTOutput(ns("stat_table"))
  )
}

#' pokestats Server Functions
#'
#' @noRd
mod_pokestats_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    pokemon_data <- reactive({
      get_pokemon_stats_multi(input$pokemon)
    })

    output$stat_plot <- renderPlot({
      validate(need(input$pokemon, "Please select one or more Pokemon"))
      get_pokemon_stats_plot(pokemon_data(), input$pokemon)
    })

    output$stat_table <- DT::renderDT({
      pokemon_data() %>%
        DT::datatable(
          options = list(
            info = F,
            paging = T,
            searching = F,
            pageLength = 6
          ),
          rownames = F,
          colnames = c("Pokemon", "Stat", "Base stat")
        )
    })
  })
}

## To be copied in the UI
# mod_pokestats_ui("pokestats_ui_1")

## To be copied in the server
# mod_pokestats_server("pokestats_ui_1")
