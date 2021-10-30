library(tidyverse)
library(tidygraph)
library(ggraph)

movies_data <-  read_delim("data/Movies.paj", delim = " ")
movies_nodes <- slice(movies_data, 2:103) %>%
  rename("node_id" = "*Network",
         "name" = "Movies.net",
         "mode" = "[2-Mode]") %>%
  select(-mode)
movies_edges <- slice(movies_data, 106:297) %>%
  rename("from" = "*Network",
         "to" = "Movies.net",
         "n_collabs" = "[2-Mode]")

movies_nodes <- movies_nodes %>%
  mutate(node_id = as.integer(node_id))

movies_edges <- movies_edges %>%
  mutate(from = as.integer(from),
         to = as.integer(to))

directed_tree <- tbl_graph(nodes = movies_nodes,
                           edges = movies_edges,
                           directed = T)

directed_tree <- directed_tree %N>%
  mutate(role = if_else(node_id < 63, "Producer", "Composer")) %N>%
  filter(!node_is_isolated())

name_id <- directed_tree %N>%
  as_tibble() %>%
  select(node_id, name)

producer_tree <- directed_tree %E>%
  as_tibble() %>%
  select(from, to) %>%
  group_by(to) %>%
  #get all the ids from composers and put them in a list
  mutate(new_from = list(unique(from))) %>%
  #unnest the list
  unnest_longer(new_from) %>%
  #filter out the loops
  filter(from != new_from) %>%
  ungroup() %>%
  select(from = new_from, to = from) %>%
  as_tbl_graph() %N>%
  select(node_id = name) %>%
  mutate(node_id = as.integer(node_id)) %>%
  left_join(name_id, by = "node_id") %>%
  #Make it undirected, there is no hierarchy.
  to_undirected()

producer_tree %>%
  mutate(Group = group_leading_eigen() %>% as.factor()) %>%
  ggraph() +
  ggforce::geom_mark_hull(
    aes(x, y,
        group = Group,
        fill = Group),
    alpha = 0.1,
    concavity = 5,
    size = 0.3
  ) +
  geom_edge_link(width = 0.1,
                 color = "#FDFFFC",
                 alpha = 0.1) +
  geom_node_text(aes(label = node_id,
                     color = Group),
                 size = 2) +
  labs(
    title = "Leading eigen clustering algorithm",
    subtitle = "Which producers worked with the same composers ?",
    caption = "Source : sites.google.com/site/
       ucinetsoftware/datasets/hollywoodfilmmusic"
  ) +
  scale_color_manual(values = c("#2EC4B6", "#E71D36", "green")) +
  scale_fill_manual(values = c("#2EC4B6", "#E71D36", "green")) +
  theme_graph() +
  theme(
    plot.background = element_rect(fill = "#011627"),
    plot.title = element_text(color = "#FDFFFC"),
    plot.subtitle = element_text(color = "#FDFFFC"),
    text = element_text(color = "white"),
    plot.caption = element_text(color = "#FDFFFC",
                                size = 8)
  )

ggsave("producer_graph.png", path = "gallery/")
