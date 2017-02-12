library(shiny)
library(ggplot2)

fluidPage(
  
  titlePanel("rsloan"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Choose a dataset:", 
                  choices = c( "im08", "im09")),
      
      numericInput("obs", "Number of observations to view:", 10),
      
      helpText("Note: Haoye test"),
      
      submitButton("Update View")
    ),

    mainPanel(
      h4("Observations"),
      tableOutput("view"),
      
      h4("Summary"),
      verbatimTextOutput("summary")
    )
  )
)