library(shiny)

shinyServer(function(input, output) {
    mod_game_server("game")
})
