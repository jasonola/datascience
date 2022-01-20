#' capitals UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_capitals_ui <- function(id){
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        uiOutput(ns("selector")),
        actionButton(ns("submit"), label = "Submit"),
        actionButton(ns("refresh"), label = "Refresh")
      ),
      mainPanel(
        plotOutput(ns("game_map_country"))
      )
    ),
  )
}

#' capitals Server Functions
#'
#' @noRd
mod_capitals_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    score <- reactiveVal(0)
    rd <- reactiveVal(0)

    choices <- reactiveValues(
      choices = shuffle_choices_cap()
    )


    output$selector <- renderUI(
      radioButtons(ns("radio_wrapper"),
                   choices = sample(choices$choices[2:5]),
                   label = stringr::str_glue("What is the capital of {choices$choices[1]}")),
    )

    output$game_map_country <- renderPlot({
      plot_continent_wth_country(choices$choices[1])
    })


    observeEvent(input$submit, {

      new_rd <- rd() + 1
      rd(new_rd)

      if(rd()<=10){
        if(input$radio_wrapper == choices$choices[2]){
          new_score <- score() + 1
          score(new_score)
          shinyalert::shinyalert("Yes the answer is correct !",
                                 stringr::str_glue("Score : {score()}/10"),
                                 type = "success")
        }
        else{
          shinyalert::shinyalert(stringr::str_glue("No Answer is False ! The answer is {choices$choices[2]}"),
                                 stringr::str_glue("Score : {score()}/10"),
                                 type = "error")
        }
      }

      choices$choices <- shuffle_choices_cap()

      if(rd() == 10){
        if(score()>7){
          shinyalert::shinyalert("Game over ! Great score you are a capitals mastermind !",
                                 stringr::str_glue("Your score is : {score()}/10"))
        }else{
          shinyalert::shinyalert("Game over ! Aww.. You will do better next time ;)",
                                 stringr::str_glue("Your score is : {score()}/10"))
        }
        removeUI("#capitals_ui_1-submit")
      }
    })
    observeEvent(input$refresh, {
      shinyjs::refresh()
    })


  })

}

## To be copied in the UI
# mod_capitals_ui("capitals_ui_1")

## To be copied in the server
# mod_capitals_server("capitals_ui_1")
