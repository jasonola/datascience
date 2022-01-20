#' info UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_info_ui <- function(id) {
  ns <- NS(id)
  fluidPage(sidebarLayout(sidebarPanel(
    selectizeInput(
      ns("country_choices"),
      label = "Choose countries to display info",
      choices = world_countries,
      selected = "Switzerland",
      multiple = TRUE,
      options = list(maxItems = 5)
    ),
    selectizeInput(
      ns("info_choice"),
      label = "Choose visualisation : ",
      choices = c("Map", "Population", "GDP")
    )
  ),
  mainPanel(
    plotOutput(ns("map_info"))
  )
  ),
  DT::DTOutput(ns("table_info"))
  )




}

#' info Server Functions
#'
#' @noRd
mod_info_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$map_info <-
      renderPlot({
        if(input$info_choice == "Map"){
          get_info_map(input$country_choices)
        }else if(input$info_choice == "Population"){
          get_pop_chart(input$country_choices)
        }else if(input$info_choice == "GDP"){
          get_gdp_chart(input$country_choices)
        }
      })

    output$table_info <-
      DT::renderDT(get_info_table(input$country_choices))


  })
}


## To be copied in the UI
# mod_info_ui("info_ui_1")

## To be copied in the server
# mod_info_server("info_ui_1")
