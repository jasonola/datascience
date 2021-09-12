library(shiny)
library(tidyverse)
library(DT)
source("helpers.R")

fitness_long <- get_fitness_long()

ui <- navbarPage(
  "Fitness App",
  theme = shinythemes::shinytheme("cosmo"),
  tabPanel("Panel 1",
           fluidPage(
             titlePanel("Descriptive stats about members at registration"),
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   "p1var1",
                   label = "Select variable:",
                   choices = p1cat_choices,
                   selected = "bmi_category"
                 ),
                 checkboxInput("p1add_var",
                               label = "Add another variable?"),
                 uiOutput("p1var2_wrapper")
               ),
               mainPanel(plotOutput("p1plot"))
             ),
             DTOutput("p1table")
           )),
  tabPanel("Panel 2",
           fluidPage(
             titlePanel("Performance monitoring - One factor vs. time"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("p2var1_wrapper"),
                 checkboxInput("p2wk_facet",
                               label = "Facet by week?")
               ),
               mainPanel(plotOutput("p2plot"))
             ),
             DTOutput("p2table")
           )),
  tabPanel("Panel 3",
           fluidPage(
             titlePanel("Performance monitoring - Several factors vs. time"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("p3var1_wrapper"),
                 checkboxInput("p3wk_facet",
                               label = "Facet by week?")
               ),
               mainPanel(plotOutput("p3plot"))
             ),
             DTOutput("p3table")
           ))
)

server <- function(input, output, session) {
  #Panel 1 ---------------------------------------------------------------------
  output$p1var2_wrapper <- renderUI({
    if (input$p1add_var) {
      selectInput("p1var2",
                  label = "Other variable:",
                  choices = p1cat_choices[!str_detect(p1cat_choices,
                                                      input$p1var1)])
    }
  })

  output$p1table <-  renderDT({
    if (input$p1add_var) {
      output_table_2(fitness_long,
                     input_var1 = input$p1var1,
                     input_var2 = input$p1var2) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = F
          ),
          rownames = F,
          colnames = c(
            unname(p1cat_labels[input$p1var1]),
            unname(p1cat_labels[input$p1var2]),
            "N",
            "Percentage"
          )
        )
    }
    else{
      output_table_1(fitness_long,
                     input_var = input$p1var1) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = F
          ),
          rownames = F,
          colnames = c(unname(p1cat_labels[input$p1var1]),
                       "N", "Percentage")
        )
    }
  })


  output$p1plot <- renderPlot({
    if (input$p1add_var) {
      req(input$p1var2)
      output_plot_2(fitness_long,
                    input_var1 = input$p1var1,
                    input_var2 = input$p1var2)
    }
    else{
      output_plot_1(fitness_long,
                    input_var = input$p1var1)
    }
  })

  #Panel 2 ---------------------------------------------------------------------

  output$p2var1_wrapper <- renderUI({
    if (input$p2wk_facet) {
      list(
        selectInput(
          "p2weeks",
          choices = weeks,
          label = "Choose weeks:",
          multiple = T,
          selected = c(0, 3, 6)
        ),
        selectInput(
          "p2vars_facet",
          choices = p1cat_choices,
          label = "Select variable:",
          selected = "bmi_category"
        )
      )
    }
    else{
      list(
        selectInput(
          "p2var1",
          choices = p2cat_choices,
          label = "Select metric:",
          selected = "bmi_vs_baseline"
        ),
        selectInput(
          "p2id_nb",
          choices = ids,
          label = "Choose ID(s):",
          multiple = T
        ),
        sliderInput(
          "p2wk_nb",
          label = "Choose week(s):",
          min = min(weeks),
          max = max(weeks),
          value = c(0, 26),
          ticks = F,
          step = 1
        )
      )
    }

  })
  output$p2table <- renderDT({
    if (input$p2wk_facet) {
      req(input$p2weeks)
      output_table_4(
        fitness_long,
        input_var = input$p2vars_facet,
        week_nbs = input$p2weeks
      ) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = T
          ),
          rownames = F,
          colnames = c("Week", unname(p1cat_labels[input$p2vars_facet]), "N")
        )
    }
    else{
      req(input$p2var1)
      validate(need(!is.null(input$p2id_nb), "Please enter some ID numbers"))
      output_table_3(
        fitness_long,
        input_id_nb = input$p2id_nb,
        input_wk_nb = input$p2wk_nb[1]:input$p2wk_nb[2]
      ) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = T
          ),
          rownames = F,
          colnames = c(
            "ID",
            "Subscription",
            "Gender",
            "Week",
            "Weight",
            "BMI",
            "BMI vs baseline",
            "BMI category"
          )
        )
    }

  })
  output$p2plot <- renderPlot({
    if (input$p2wk_facet) {
      req(input$p2vars_facet)
      validate(need(!is.null(input$p2weeks), "Please select weeks"))
      output_plot_4(
        fitness_long,
        input_var = input$p2vars_facet,
        week_nbs = input$p2weeks
      )
    }
    else{
      req(input$p2var1)
      output_plot_3(
        fitness_long,
        input_id_nb = input$p2id_nb,
        input_wk_nb = input$p2wk_nb[1]:input$p2wk_nb[2],
        input_y_var = input$p2var1
      )
    }

  })
  #Panel 3 ---------------------------------------------------------------------

  output$p3var1_wrapper <- renderUI({
    if (input$p3wk_facet) {
      list(
        selectInput(
          "p3weeks",
          choices = weeks,
          label = "Choose weeks:",
          multiple = T,
          selected = c(0, 3, 6)
        ),
        selectizeInput(
          "p3vars_facet",
          choices = p1cat_choices,
          label = "Select 2 variables:",
          selected = "gender",
          options = list(maxItems = 2)
        )
      )
    }
    else{
      list(
        selectizeInput(
          "p3vars",
          choices = p1cat_choices,
          label = "Select 2 variables:",
          selected = "bmi_category",
          options = list(maxItems = 2)
        ),
        sliderInput(
          "p3wk_nb",
          label = "Choose week(s):",
          min = min(weeks),
          max = max(weeks),
          value = c(0, 26),
          ticks = F,
          step = 1
        )
      )
    }

  })

  output$p3table <- renderDT({
    if (input$p3wk_facet) {
      req(input$p3vars_facet[2])
      output_table_6(
        fitness_long,
        input_wk_nb = input$p3weeks,
        input_var1 = input$p3vars_facet[1],
        input_var2 = input$p3vars_facet[2]
      ) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = T
          ),
          rownames = F,
          colnames = c(
            "Week",
            unname(p1cat_labels[input$p3vars_facet[1]]),
            unname(p1cat_labels[input$p3vars_facet[2]]),
            unname(p1cat_labels[!p1cat_labels %in% c(unname(p1cat_labels[input$p3vars_facet[1]]),
                                                     unname(p1cat_labels[input$p3vars_facet[2]]))]),
            "N",
            "Total",
            "Percentage"
          )
        )
    }
    else{
      req(input$p3vars)
      output_table_5(fitness_long,
                     input_wk_nb = input$p3wk_nb[1]:input$p3wk_nb[2]) %>%
        datatable(
          options = list(
            info = F,
            searching = F,
            paging = T
          ),
          rownames = F,
          colnames = c(
            "Week",
            "Gender",
            "Subscription",
            "BMI category",
            "N",
            "Total",
            "Percentage"
          )
        )
    }

  })

  output$p3plot <- renderPlot({
    if (input$p3wk_facet) {
      validate(
        need(input$p3vars_facet[2] != "", "Please select 2 variables"),
        need(!is.null(input$p3weeks), "Please select the week(s)")
      )
      output_plot_6(
        fitness_long,
        input_wk_nb = input$p3weeks,
        input_var1 = input$p3vars_facet[1],
        input_var2 = input$p3vars_facet[2]
      )
    }
    else{
      validate(need(input$p3vars[2] != "", "Please select 2 variables"))
      output_plot_5(
        fitness_long,
        input_wk_nb = input$p3wk_nb[1]:input$p3wk_nb[2],
        input_var1 = input$p3vars[1],
        input_var2 = input$p3vars[2]
      )
    }

  })
}

shinyApp(ui, server)
