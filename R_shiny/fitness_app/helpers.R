library(tidyverse)

#Read data

#Some variables
p1cat_choices <- list(
  "Gender" = "gender",
  "Subscription" = "m_category",
  "BMI category" = "bmi_category"
)

p2cat_choices <- list("Weight" = "weight",
                      "BMI" = "bmi",
                      "BMI Baseline" = "bmi_vs_baseline")


p1cat_labels <- c(
  "gender" = "Gender",
  "m_category" = "Subscription",
  "bmi_category" = "BMI category"
)

p2cat_labels <- c("weight" = "Weight",
                  "bmi" = "BMI" ,
                  "bmi_vs_baseline" = "BMI Baseline")
weeks <- c(0:52)

#Tidy data and preparation
get_fitness_long <- function() {
  fitness_members <- read_csv("fitness_data/fitness_members.csv")
  fitness_tracking <- read_csv("fitness_data/fitness_tracking.csv")

  data <- fitness_members %>%
    left_join(fitness_tracking,
              by = "id") %>%
    rename(wk_000 = weight) %>%
    pivot_longer(cols = starts_with("wk_"),
                 names_to = "week",
                 values_to = "weight") %>%
    mutate(
      bmi = round(weight / (height / 100) ^ 2, 2),
      week = str_remove(week, "wk_") %>%
        as.integer(),
      bmi_category = case_when(
        bmi <= 18.5 ~ "Underweight",
        bmi <= 25.0 ~ "Healthy",
        bmi <= 30.0 ~ "Overweight",
        TRUE ~ "Obese"
      )
    ) %>%
    mutate(
      bmi_category = factor(
        bmi_category,
        levels = c("Underweight",
                   "Healthy",
                   "Overweight",
                   "Obese")
      ),
      m_category = factor(m_category,
                          levels = c("Economy",
                                     "Balance",
                                     "Premium"))
    ) %>%
    group_by(id) %>%
    mutate(bmi_vs_baseline = round(bmi / first(bmi) * 100, 1),
           id = as.integer(id)) %>%
    ungroup()
  return(data)
}
ids <- fitness_long %>%
  pull(id) %>%
  unique()
#-------------------------------------------------------------------------------

#Panel 1 : Descriptive stats about members at registration

#Part 1 : One factor table
output_table_1 <- function(data, input_var, week_nb = c(0)) {
  data %>%
    filter(week %in% week_nb) %>%
    group_by(.[input_var], week) %>%
    count(.[input_var]) %>%
    ungroup() %>%
    mutate(percentage = round(n / sum(n), 2)) %>%
    select(-week)
}

#Part 1 : One factor plot
output_plot_1 <- function(data, input_var, week_nb = c(0)) {
  output_table_1(data, input_var, week_nb) %>%
    ggplot() +
    geom_col(aes(.data[[input_var]], n,
                 fill = .data[[input_var]])) +
    labs(title = paste0("Week n°", week_nb),
         x = p1cat_labels[input_var],
         y = "N") +
    theme_minimal() +
    theme(legend.position = "none",
          plot.title = element_text(hjust = 0.5))

}

#Part 2 : Two factor table
output_table_2 <-
  function(data, input_var1, input_var2, week_nb = c(0)) {
    data %>%
      filter(week %in% week_nb) %>%
      group_by(.[input_var1], .[input_var2], week) %>%
      count(.[input_var1], .[input_var2]) %>%
      ungroup() %>%
      group_by(.[input_var1]) %>%
      mutate(percentage = round(n / sum(n), 2)) %>%
      select(-week)
  }

#Part 2 : Two factor plot
output_plot_2 <-
  function(data, input_var1, input_var2, week_nb = c(0)) {
    output_table_2(data, input_var1, input_var2, week_nb) %>%
      ggplot() +
      geom_col(aes(x = .data[[input_var1]],
                   y = percentage,
                   fill = .data[[input_var2]])) +
      labs(
        title = paste0("Week n°", week_nb),
        fill = p1cat_labels[input_var2],
        x = p1cat_labels[input_var1],
        y = "Percentage"
      ) +
      scale_y_continuous(breaks = c(0, 0.25, 0.50, 0.75, 1),
                         labels = scales::percent(c(0, 0.25, 0.50, 0.75, 1))) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5))
  }

#-------------------------------------------------------------------------------

#Panel 2 : Performance monitoring - One factor vs. time

#Part 3 : One factor vs time table
output_table_3 <- function(data, input_id_nb, input_wk_nb) {
  data %>%
    filter(id %in% input_id_nb,
           week %in% input_wk_nb) %>%
    select(id,
           m_category,
           gender,
           week,
           weight,
           bmi,
           bmi_vs_baseline,
           bmi_category)
}

#Part3 : One factor vs time plot
output_plot_3 <-
  function(data,
           input_id_nb,
           input_wk_nb,
           input_y_var) {
    output_table_3(data, input_id_nb, input_wk_nb) %>%
      ggplot() +
      geom_line(
        data = data %>%
          filter(week %in% input_wk_nb),
        aes(week,
            .data[[input_y_var]],
            group = id),
        alpha = 0.05
      ) +
      geom_line(aes(
        week,
        .data[[input_y_var]],
        group = id,
        color = fct_inorder(as.character(id))
      ),
      size = 0.5) +
      facet_grid(rows = vars(gender),
                 cols = vars(m_category)) +
      labs(x = "Week",
           color = "Member ID",
           y = p2cat_labels[input_y_var]) +
      theme_minimal()
  }

#Part 4 : Week as faceting variable table
output_table_4 <- function(data, input_var, week_nbs) {
  data %>%
    filter(week %in% week_nbs) %>%
    group_by(week, .[input_var]) %>%
    count()
}

#Part 4 : Week as faceting variable plot
output_plot_4 <- function(data, input_var, week_nbs) {
  output_table_4(data, input_var, week_nbs) %>%
    ggplot() +
    geom_col(aes(x = .data[[input_var]],
                 y = n,
                 fill = .data[[input_var]])) +
    facet_grid(cols = vars(week)) +
    labs(
      title = "Week",
      x = p1cat_labels[input_var],
      y = "N",
      fill = ""
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 90),
      legend.position = "none",
      plot.title = element_text(hjust = 0.5)
    )
}

#-------------------------------------------------------------------------------

#Panel 3 : Performance monitoring - Several factors vs. time

#Part 5 : Week number as numerical variable on x-axis table
output_table_5 <- function(data, input_wk_nb) {
  data %>%
    filter(week %in% input_wk_nb) %>%
    count(week, gender, m_category, bmi_category) %>%
    group_by(week, gender, m_category) %>%
    mutate(total = sum(n),
           percentage = round(n / total * 100, 1)) %>%
    ungroup()
}

#Part 5 : Week number as numerical variable on x-axis plot
output_plot_5 <-
  function(data, input_var1, input_var2, input_wk_nb) {
    cats <- c("gender", "m_category", "bmi_category")
    output_table_5(data, input_wk_nb) %>%
      ggplot() +
      geom_area(aes(week, percentage,
                    fill = .data[[input_var1]]),) +
      facet_grid(rows = vars(.data[[input_var2]]),
                 cols = vars(.data[[cats[!cats %in% c(input_var1, input_var2)]]])) +
      labs(x = "Week",
           y = "Percentage",
           fill = "") +
      theme_minimal()
  }

#Part 6 : Week number as faceting variable table
output_table_6 <-
  function(data, input_wk_nb, input_var1, input_var2) {
    cats <- c("gender", "m_category", "bmi_category")
    data %>%
      filter(week %in% input_wk_nb) %>%
      count(week, .[input_var1], .[input_var2],
            .[cats[!cats %in% c(input_var1, input_var2)]]) %>%
      group_by(week, .[input_var1], .[input_var2]) %>%
      mutate(total = sum(n),
             percentage = round(n / total * 100, 1)) %>%
      ungroup()
  }

#Part 6 : Week number as faceting variable plot
output_plot_6 <-
  function(data, input_wk_nb, input_var1, input_var2) {
    output_table_6(data, input_wk_nb, input_var1, input_var2) %>%
      filter(week %in% input_wk_nb) %>%
      ggplot() +
      geom_col(aes(.data[[input_var1]], n,
                   fill = .data[[input_var2]]),
               position = "fill") +
      labs(
        title = "Week",
        x = p1cat_labels[input_var1],
        y = "Percentage",
        fill = p1cat_labels[input_var2]
      ) +
      facet_wrap(vars(week)) +
      scale_y_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1),
                         labels = scales::percent(c(0, 0.25, 0.5, 0.75, 1))) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5),
            axis.text.x = element_text(angle = 90))
  }

