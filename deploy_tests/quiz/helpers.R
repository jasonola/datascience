library(tidyverse)
library(sf)

get_world_data <- function() {
  sf::st_read("data/ne_110m_admin_0_countries.shp", quiet = TRUE)
}

world <- get_world_data() %>%
  dplyr::filter(!CONTINENT %in% c("Seven seas (open ocean)", "Antarctica"))

get_bbox <- function(continent) {
  world %>%
    dplyr::filter(CONTINENT == continent) %>%
    sf::st_bbox() %>%
    sf::st_as_sfc() %>%
    sf::st_buffer(2)
}

get_continent <- function(continent) {
  world %>%
    dplyr::filter(CONTINENT == continent)
}

plot_continent_wth_country <- function(c) {
  country_row = world %>% dplyr::filter(ADMIN == c)
  if (country_row$CONTINENT == "Europe") {
    get_continent(country_row$CONTINENT) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != country_row$CONTINENT),
        fill = NA,
        color = "#95A5A6",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "#95A5A6",
                       color = "white",
                       size = 0.1) +
      ggplot2::geom_sf(data = country_row,
                       fill = "#2C3E50") +
      ggplot2::coord_sf(xlim = c(-30.23, 49.81),
                        ylim = c(35.54, 67.51)) +
      ggplot2::theme_void()
  }
  else if (country_row$CONTINENT == "Oceania") {
    get_continent(country_row$CONTINENT) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != country_row$CONTINENT),
        fill = NA,
        color = "#95A5A6",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "#95A5A6",
                       color = "white",
                       size = 0.1) +
      ggplot2::geom_sf(data = country_row,
                       fill = "#2C3E50") +
      ggplot2::coord_sf(xlim = c(87, 196),
                        ylim = c(-50, 5)) +
      ggplot2::theme_void()
  }
  else{
    get_continent(country_row$CONTINENT) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != country_row$CONTINENT),
        fill = NA,
        color = "#95A5A6",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "#95A5A6",
                       color = "white",
                       size = 0.1) +
      ggplot2::geom_sf(data = country_row,
                       fill = "#2C3E50") +
      ggplot2::coord_sf(xlim = sf::st_bbox(get_bbox(country_row$CONTINENT))[c(1, 3)],
                        ylim = sf::st_bbox(get_bbox(country_row$CONTINENT))[c(2, 4)]) +
      ggplot2::theme_void()
  }

}

get_countries_by_continent <- function(continent) {
  world %>%
    dplyr::filter(CONTINENT == continent) %>%
    dplyr::pull(ADMIN)
}

shuffle_choices <- function() {
  samp <- dplyr::sample_n(world, 1)

  choice1 <- samp %>% dplyr::pull(SOVEREIGNT)

  choice2 <- samp %>%
    dplyr::pull(CONTINENT) %>%
    get_countries_by_continent() %>%
    dplyr::setdiff(choice1) %>%
    sample(1)

  choice3 <- samp %>%
    dplyr::pull(CONTINENT) %>%
    get_countries_by_continent() %>%
    dplyr::setdiff(c(choice1, choice2)) %>%
    sample(1)

  choice4 <- samp %>%
    dplyr::pull(CONTINENT) %>%
    get_countries_by_continent() %>%
    dplyr::setdiff(c(choice1, choice2, choice3)) %>%
    sample(1)

  return(c(choice1, choice2, choice3, choice4))
}

