mod_game_ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    shinyjs::useShinyjs(),
    h3("Geo Quiz"),
    sidebarLayout(
      sidebarPanel(
        uiOutput(ns("selector")),
        actionButton(ns("submit"), label = "Submit"),
        actionButton(ns("refresh"), label = "Refresh")
      ),
      mainPanel(plotOutput(ns(
        "game_map_country"
      )))
    ),)
}

mod_game_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    score <- reactiveVal(0)
    rd <- reactiveVal(0)

    choices <- reactiveValues(choices = shuffle_choices())


    output$selector <- renderUI(radioButtons(
      ns("radio_wrapper"),
      choices = sample(choices$choices),
      label = "Guess the highlighted country :"
    ),)

    output$game_map_country <- renderPlot({
      plot_continent_wth_country(choices$choices[1])
    })

    observeEvent(input$submit, {

      new_rd <- rd() + 1
      rd(new_rd)

      if(rd()<=10){
        if(input$radio_wrapper == choices$choices[1]){
          new_score <- score() + 1
          score(new_score)
          shinyalert::shinyalert("Yes the answer is correct !",
                                 stringr::str_glue("Score : {score()}/10"),
                                 type = "success")
        }
        else{
          shinyalert::shinyalert(stringr::str_glue("No Answer is False ! The answer is {choices$choices[1]}"),
                                 stringr::str_glue("Score : {score()}/10"),
                                 type = "error")
        }
      }

      choices$choices <- shuffle_choices()

      if(rd() == 10){
        if(score()>7){
          shinyalert::shinyalert("Game over ! Great score you are a countries mastermind !",
                                 stringr::str_glue("Your score is : {score()}/10"))
        }else{
          shinyalert::shinyalert("Game over ! Aww.. You will do better next time ;)",
                                 stringr::str_glue("Your score is : {score()}/10"))
        }
        removeUI("#game-submit")
      }

    })
    observeEvent(input$refresh, {
      shinyjs::refresh()
    })


  })
}

