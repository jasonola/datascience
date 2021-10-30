library(tidyverse)
library(sf)
library(patchwork)

ihme <-
  read_csv("data/IHME_DAH_DATABASE_1990_2019_Y2020M04D23.CSV",
           na = c('NA', '-', ''))

diseases <- c("hiv", "mal", "tb")

dollar_received_2002 <- ihme %>%
  filter(year == 2002) %>%
  select(recipient_country, contains(diseases)) %>%
  pivot_longer(cols = contains(diseases)) %>%
  group_by(recipient_country) %>%
  summarise(dollar_received = sum(value, na.rm = T)) %>%
  mutate(dollar_received = na_if(dollar_received, 0))

cuts <- dollar_received_2002 %>%
  pull(dollar_received) %>%
  classInt::classIntervals(n = 5) %>%
  pluck("brks")

labels_recieved <-
  tibble(cut1 = round(cuts), cut2 = round(lead(cuts))) %>%
  head(-1) %>%
  mutate(
    cut1 = scales::dollar_format()(cut1),
    cut2 = scales::dollar_format()(cut2),
    label = paste0(cut1, " - ", cut2) %>% fct_inorder()
  )

dollar_received_2002 <- dollar_received_2002 %>%
  mutate(
    labels_recieved = cut(dollar_received,
                          breaks = cuts_recieved,
                          label = labels_recieved$label),
    recipient_country = str_replace_all(
      recipient_country,
      c(
        "Cote d'Ivoire" = "Ivory Coast",
        "Serbia" = "Republic of Serbia",
        "Tanzania" = "United Republic of Tanzania",
        "Swaziland" = "eSwatini"
      )
    )
  )

world <- st_read("data/110m_cultural/ne_110m_admin_0_countries.shp")

world <- world %>%
  left_join(dollar_received_2002, by = c("SOVEREIGNT" = "recipient_country"))

africa_bbox <- world %>%
  filter(CONTINENT == "Africa") %>%
  st_bbox() %>%
  st_as_sfc() %>%
  st_buffer(2)

africa <- world %>%
  filter(CONTINENT == "Africa")

inset <- world %>% filter(SOVEREIGNT != "Antarctica") %>%
  ggplot() +
  geom_sf(size = 0.1) +
  geom_sf(data = africa_bbox,
          fill = NA,
          color = "brown") +
  theme_void()

africa_map <- africa %>%
  ggplot() +
  geom_sf(
    data = world %>% filter(CONTINENT != "Africa"),
    fill = NA,
    color = "gray",
    size = 0.3
  ) +
  geom_sf(
    mapping = aes(fill = labels_recieved),
    color = "white",
    size = 0.1
  ) +
  scale_fill_brewer(palette = "Greens",
                    na.value = "gray") +
  labs(fill = "") +
  coord_sf(xlim = st_bbox(africa_bbox)[c(1, 3)],
           ylim = st_bbox(africa_bbox)[c(2, 4)]) +
  theme_void() +
  theme(legend.position = "bottom")

layout <- c(area(
  t = 1,
  l = 0,
  b = 7,
  r = 3
),
area(
  t = 1,
  l = 1,
  b = 6,
  r = 10
))

inset + africa_map +
  plot_layout(design = layout) +
  plot_annotation(
    title = "Dollars recieved in African countries (2002)",
    subtitle = "For Tuberculosis, Malaria and HIV\n",
    caption = "Source : www.healthdata.org",
    theme = theme(
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      plot.caption = element_text(face = "italic")
    )
  )
ggsave("africa_inset.png", path = "gallery/")
