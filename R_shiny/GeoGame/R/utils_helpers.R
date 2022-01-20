#' helpers
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd

world <- get_world_data() %>%
  dplyr::filter(!CONTINENT %in% c("Seven seas (open ocean)", "Antarctica"))

capitals <- get_capitals_data()

world <- world %>%
  dplyr::left_join(capitals, by = c("GU_A3" = "iso3"))

world_countries <- world %>%
  dplyr::filter(!is.na(capital)) %>%
  dplyr::pull(ADMIN)

world_countries_flags <- readr::read_csv("data/flags_iso.csv") %>%
  dplyr::pull(Country)
