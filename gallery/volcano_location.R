library(tidyverse)
library(sf)

eruptions <- read_csv("data/eruptions")
volcano <- read_csv("data/volcano") %>%
  mutate(primary_volcano_type = str_replace_all(
    primary_volcano_type,
    c(
      "Caldera\\(s\\)" = "Caldera",
      "Lava cone\\(es\\)" = "Lava cone",
      "Stratovolcano\\(es\\)" = "Stratovolcano",
      "Shield\\(s\\)" = "Shield",
      "Pyroclastic cone\\(s\\)" = "Pyroclastic cone",
      "Stratovolcano\\?" = "Stratovolcano",
      "Complex\\(es\\)" = "Complex",
      "Lava cone\\(s\\)" = "Lava cone",
      "Lava dome\\(s\\)" = "Lava dome",
      "Tuff cone\\(s\\)" = "Tuff cone"
    )
  ))

large_volcanoes <- volcano %>%
  left_join(eruptions,
            by = c("volcano_number", "latitude", "longitude", "volcano_name")) %>%
  filter(vei >= 5)
lv_locations <- large_volcanoes %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

world <- st_read("data/world/ne_110m_admin_0_map_units.shp")

color1 = "#211103"
color2 = "#9F2042"

world %>% filter(SOVEREIGNT != "Antarctica") %>%
  ggplot() +
  geom_sf(fill = color1,
          color = color1,
          size = 0.5) +
  geom_sf(
    data = lv_locations,
    aes(size = vei),
    shape = 17,
    color = color2,
    alpha = 0.7
  ) +
  scale_size_continuous(range = c(2, 5), breaks = c(5, 6, 7)) +
  labs(title = "Location of large volcanoes",
       subtitle = "with Volcano Explosivity Index \n",
       caption = "Source : github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-05-12") +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    text = element_text(family = "Roboto Slab"),
    plot.title = element_text(
      hjust = 0.5,
      face = "bold",
      color = color1
    ),
    plot.subtitle = element_text(
      hjust = 0.5,
      face = "bold",
      color = color2
    ),
    plot.caption = element_text(hjust = 0.5,
                                size = 6)
  )
ggsave("volcano_location.png", path = "gallery/")
