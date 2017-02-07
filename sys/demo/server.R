library(shiny)
library(ggplot2)

function(input, output) {

  datasetInput <- reactive({
    switch(input$dataset,
	"iris" = iris, 
	"dimd" = diamonds)
  })
  
  output$summary <- renderPrint({
    dataset = datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view <- renderTable({
    head(datasetInput(), n = input$obs)
  })
}



