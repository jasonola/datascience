#' helpers
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd


get_world_data <- function() {
  sf::st_read("./worlddata/ne_110m_admin_0_countries.shp", quiet = TRUE)
}

get_capitals_data <- function() {
  readr::read_csv("./data/worldcities.csv") %>%
    dplyr::filter(capital == "primary") %>%
    #keep admin capitals
    dplyr::filter(
      !city_ascii %in% c(
        "Dar es Salaam",
        "Cape Town",
        "Bloemfontein",
        "Sucre",
        "Abidjan",
        "Nay Pyi Taw",
        "The Hague",
        "Sri Jayewardenepura Kotte"
      )
    ) %>%
    tibble::add_row(country = "Canada",
                    city = "Ottawa",
                    iso3 = "CAN") %>%
    dplyr::mutate(iso3 = dplyr::if_else(country == "Armenia", "ARM", iso3))
}


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

plot_continent <- function(continent) {
  if (continent == "Europe") {
    get_continent(continent) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != continent),
        fill = NA,
        color = "gray",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "gray",
                       color = "white",
                       size = 0.1) +
      ggplot2::coord_sf(xlim = c(-30.23, 49.81),
                        ylim = c(35.54, 67.51)) +
      ggplot2::theme_void()
  }
  else if (continent == "Oceania") {
    get_continent(continent) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != continent),
        fill = NA,
        color = "gray",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "gray",
                       color = "white",
                       size = 0.1) +
      ggplot2::coord_sf(xlim = c(87, 196),
                        ylim = c(-50, 5)) +
      ggplot2::theme_void()
  }
  else{
    get_continent(continent) %>%
      ggplot2::ggplot() +
      ggplot2::geom_sf(
        data = world %>% dplyr::filter(CONTINENT != continent),
        fill = NA,
        color = "gray",
        size = 0.3
      ) +
      ggplot2::geom_sf(fill = "gray",
                       color = "white",
                       size = 0.1) +
      ggplot2::coord_sf(xlim = sf::st_bbox(get_bbox(continent))[c(1, 3)],
                        ylim = sf::st_bbox(get_bbox(continent))[c(2, 4)]) +
      ggplot2::theme_void()
  }

}

get_countries_by_continent <- function(continent) {
  world %>%
    dplyr::filter(CONTINENT == continent) %>%
    dplyr::pull(ADMIN)
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

get_country_row <- function(c) {
  world %>%
    dplyr::filter(ADMIN == c)
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

get_capitals_by_continent <- function(continent) {
  world %>%
    dplyr::filter(CONTINENT == continent) %>%
    dplyr::filter(!is.na(city)) %>%
    dplyr::pull(city)
}

shuffle_choices_cap <- function() {
  rand_country <- sample(world_countries, 1)
  choice1 <- rand_country %>%
    get_country_row() %>%
    dplyr::pull(city)

  choice2 <- get_country_row(rand_country) %>%
    dplyr::pull(CONTINENT) %>%
    get_capitals_by_continent() %>%
    dplyr::setdiff(choice1) %>%
    sample(1)

  choice3 <- get_country_row(rand_country) %>%
    dplyr::pull(CONTINENT) %>%
    get_capitals_by_continent() %>%
    dplyr::setdiff(c(choice1, choice2)) %>%
    sample(1)

  choice4 <- get_country_row(rand_country) %>%
    dplyr::pull(CONTINENT) %>%
    get_capitals_by_continent() %>%
    dplyr::setdiff(c(choice1, choice2, choice3)) %>%
    sample(1)

  return(c(rand_country, choice1, choice2, choice3, choice4))
}

get_info_map <- function(selected_countries) {
  world %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(size = 0.1, fill = "#95A5A6", color = "white") +
    ggplot2::geom_sf(data = world %>% dplyr::filter(ADMIN %in% selected_countries),
                     fill = "#2C3E50") +
    ggplot2::theme_void()


}

get_info_table <- function(selected_countries) {
  world %>%
    dplyr::filter(ADMIN %in% selected_countries) %>%
    tibble::as_tibble() %>%
    dplyr::select(
      "ISO" = GU_A3,
      "Country name" = ADMIN,
      "Capital" = city,
      "Population" = POP_EST,
      "GDP" = GDP_MD_EST,
      "Continent" = CONTINENT
    ) %>%
    DT::datatable(options = list(
      searching = F,
      info = F,
      paging = F
    ),
    rownames = F)
}

shuffle_choices_flags <- function() {
  choice1 <- sample(world_countries_flags, 1)

  choice2 <- world_countries_flags %>%
    setdiff(choice1) %>%
    sample(1)

  choice3 <- world_countries_flags %>%
    setdiff(c(choice1, choice2)) %>%
    sample(1)

  choice4 <- world_countries_flags %>%
    setdiff(c(choice1, choice2, choice3)) %>%
    sample(1)

  return(c(choice1, choice2, choice3, choice4))
}

get_flag_url <- function(country){
  readr::read_csv("data/flags_iso.csv") %>%
    dplyr::filter(Country == country) %>%
    dplyr::pull(URL)
}

get_pop_chart <- function(selected_countries){
  world %>%
    dplyr::filter(ADMIN %in% selected_countries) %>%
    dplyr::arrange(desc(POP_EST)) %>%
    dplyr::mutate(POP_EST = POP_EST/1000000) %>%
    dplyr::mutate(ADMIN = forcats::fct_inorder(ADMIN)) %>%
    ggplot2::ggplot(ggplot2::aes(ADMIN,POP_EST))+
    ggplot2::geom_col(fill = "#95A5A6")+
    ggplot2::labs(title = "Country population in millions",
                  x = "Country",
                  y = "Population")+
    ggplot2::theme_minimal()+
    ggplot2::theme(text = ggplot2::element_text(colour = "#2C3E50"),
                   panel.grid = ggplot2::element_line(color ="#2C3E50", size = 0.05))
}

get_gdp_chart <- function(selected_countries){
  world %>%
    dplyr::filter(ADMIN %in% selected_countries) %>%
    dplyr::arrange(desc(GDP_MD_EST)) %>%
    dplyr::mutate(GDP_MD_EST = GDP_MD_EST/1000000) %>%
    dplyr::mutate(ADMIN = forcats::fct_inorder(ADMIN)) %>%
    ggplot2::ggplot(ggplot2::aes(ADMIN,GDP_MD_EST))+
    ggplot2::geom_col(fill = "#95A5A6")+
    ggplot2::labs(title = "Country GDP in millions",
                  x = "Country",
                  y = "GDP")+
    ggplot2::theme_minimal()+
    ggplot2::theme(text = ggplot2::element_text(colour = "#2C3E50"),
                   panel.grid = ggplot2::element_line(color ="#2C3E50", size = 0.05))
}
