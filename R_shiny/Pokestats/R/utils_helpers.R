#' helpers
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd


get_pokemon_names <- function(){
  url = "https://pokeapi.co/api/v2/"

  httr::GET(paste0(url, "pokemon?limit=884")) %>%
  httr::content() %>%
  purrr::pluck("results") %>%
  purrr::map_df(magrittr::extract, c("name"))


}
