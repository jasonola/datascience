#' helpers
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd

get_pokemon_stats <- function(pokemon) {
  url = "https://pokeapi.co/api/v2/"

  httr::GET(paste0(url, "pokemon/", stringr::str_to_lower(pokemon))) %>%
    httr::content() %>%
    purrr::pluck("stats") %>%
    purrr::map_df(magrittr::extract, c("stat", "base_stat")) %>%
    tidyr::unnest(stat) %>%
    dplyr::filter(
      stat %in% c(
        "hp",
        "attack",
        "defense",
        "special-attack",
        "special-defense",
        "speed"
      )
    ) %>%
    dplyr::mutate(stat = stringr::str_replace_all(
      stat,
      c(
        "hp" = "HP",
        "attack" = "Attack",
        "defense" = "Defense",
        "special-Attack" = "Special attack",
        "special-Defense" = "Special defense",
        "speed" = "Speed"
      )
    )) %>%
    dplyr::mutate(stat = forcats::fct_inorder(stat),
                  pokename = pokemon) %>%
    dplyr::select(pokename, stat, base_stat)
}


get_pokemon_stats_multi <- function(pokemon_vec) {
  purrr::map(.x = pokemon_vec,
             .f = get_pokemon_stats) %>%
    dplyr::bind_rows()
}


get_pokemon_stats_plot <- function(pokemon_data, pokemon_name) {
  pokemon_data %>%
    ggplot2::ggplot() +
    ggplot2::geom_col(ggplot2::aes(x = base_stat,
                                   y = stat),
                      width = 0.3,
                      fill = "red") +
    ggplot2::scale_y_discrete(limits = rev) +
    ggplot2::xlim(0, 256) +
    ggplot2::labs(
      x = "Base stat",
      y = "Stat"
    ) +
    ggplot2::facet_wrap(ggplot2::vars(pokename)) +
    ggplot2::theme_minimal() +
    ggplot2::theme(panel.grid.major.y = ggplot2::element_blank())
}
