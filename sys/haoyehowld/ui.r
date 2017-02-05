library(shiny)
library(ggplot2)

fluidPage(
  
  titlePanel("Haoye - Hello, World!"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:", 
                  choices = c( "iris", "dimd")),
      
      numericInput("obs", "Number of observations to view:", 10),
      
      helpText("Note: Haoye test"),
      
      submitButton("Update View")
    ),

    mainPanel(
      h4("Summary"),
      verbatimTextOutput("summary"),
      
      h4("Observations"),
      tableOutput("view")
    )
  )
)