library(tidyverse)
library(lubridate)
library(tsibble)

cheese_data <- read_csv("data/cheese_data.csv")

cheese_data_f1 <- cheese_data %>%
  filter(factory == "f1")

index_replace <- cheese_data %>%
  na_if(0) %>%
  is.na() %>%
  as_tibble() %>%
  mutate(sumrow = rowSums(.),
         rownum = row_number()) %>%
  filter(sumrow == 1) %>%
  pull(rownum)

index_remove <- cheese_data %>%
  na_if(0) %>%
  is.na() %>%
  as_tibble() %>%
  mutate(sumrow = rowSums(.),
         rownum = row_number()) %>%
  filter(sumrow == 2) %>%
  pull(rownum)

col_interested <- 4:8

cheese_data_nona <- cheese_data %>%
  mutate(rownum = row_number()) %>%
  filter(!rownum %in% index_remove) %>% #remove rows with 2 values
  na_if(0) %>%
  mutate(meanrow = rowMeans(.[col_interested], na.rm = T) %>% round(1)) %>%
  rowwise() %>%
  mutate_at(vars(col_interested), # choose columns of interest
            funs(if_else(is.na(.), meanrow, .)))#replace by meanrow if value is na

cheese_data_nona_nounexp <- cheese_data_nona %>%
  mutate_at(vars(col_interested),
            #replace unexpected data with mean of m1,m2,m3,m4,m5
            funs(if_else(. >= 65, mean(m1, m2, m3, m4, m5), .)))

spc_data_f1 <- cheese_data_nona_nounexp %>%
  filter(factory == "f1") %>%
  ungroup() %>%
  mutate(xbar = rowMeans(.[col_interested])) %>% #compute new mean column
  rowwise() %>%
  mutate(range = max(m1, m2, m3, m4, m5) - min(m1, m2, m3, m4, m5)) %>%
  select(-c(rownum, meanrow))

avg_xbar <- spc_data_f1 %>%
  ungroup() %>%
  summarise(mean(xbar)) %>%
  pull()

avg_range <- spc_data_f1 %>%
  ungroup() %>%
  summarise(mean(range)) %>%
  pull()

constants <- read_csv("data/XbarR_constants.csv")
d3 <- constants %>%
  filter(n == 5) %>%
  pull(D3)

d4 <- constants %>%
  filter(n == 5) %>%
  pull(D4)
lcl <- constants %>%
  mutate(lcl = d3 * avg_range) %>%
  summarise(lcl = mean(lcl)) %>%
  pull()

ucl <- constants %>%
  mutate(ucl = d4 * avg_range) %>%
  summarise(ucl = mean(ucl)) %>%
  pull()

lcl_xbar <- constants %>%
  mutate(lclxbar = avg_xbar - A2 * avg_range) %>%
  summarise(lclxbar = mean(lclxbar)) %>%
  pull()

ucl_xbar <- constants %>%
  mutate(uclxbar = avg_xbar + A2 * avg_range) %>%
  summarise(uclxbar = mean(uclxbar)) %>%
  pull()

out_of_bounds <- spc_data_f1 %>%
  filter(xbar > ucl_xbar |
           xbar < lcl_xbar) # filter out of control limits

all_lower_ref_value <-
  function(x)
    all(x < avg_xbar) # function used with slider
all_above_ref_value <- function(x)
  all(x > avg_xbar)

num_lower <- slider::slide_lgl(.x = spc_data_f1$xbar,
                               .f = all_lower_ref_value,
                               .after = 9) %>%
  sum()

num_above <- slider::slide_lgl(
  .x = spc_data_f1$xbar,
  .f = all_above_ref_value,
  .after = 9,
  # complete because there is only 1 and it is last
  .complete = T
) %>%
  sum()
points_with_10_more <- spc_data_f1 %>%
  ungroup() %>%
  # check all values to see if they have 9 more values on threshold (avg_bar)
  mutate(consec = slider::slide_lgl(.x = xbar,
                                    # we use lower only because there are no values above
                                    .f = all_lower_ref_value,
                                    .after = 9)) %>%
  filter(consec) %>% #filter these values in
  pull(timepoint) # pull the values

consecutive_times <-
  (head(points_with_10_more, 1)):(tail(points_with_10_more, 1) +
                                    9)
# get the last timepoint then substract by length

consecutive_points <- spc_data_f1 %>%
  filter(timepoint %in% consecutive_times)

x_bar_chart <- spc_data_f1 %>%
  ggplot(aes(timepoint, xbar)) +
  geom_line() +
  geom_hline(yintercept = c(ucl_xbar, lcl_xbar),
             color = "red") +
  geom_hline(yintercept = avg_xbar,
             linetype = "dashed") +
  labs(
    title = "Factory 1 X bar chart",
    subtitle = "With control limits and average Xbar",
    x = "Timepoint",
    y = "Xbar"
  ) +
  theme_minimal() +
  geom_point(
    data = out_of_bounds,
    mapping = aes(x = timepoint, y = xbar),
    color = "red",
    shape = 8
  ) +
  geom_point(
    data = consecutive_points,
    mapping = aes(x = timepoint, y = xbar),
    color = "red",
    shape = 21,
    size = 4
  )

ggsave("control_chart.png", path = "gallery/")
