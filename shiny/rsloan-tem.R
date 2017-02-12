set.seed(929)
setwd("/home/haoye/rws")
getwd()
library(shiny)
library(RMySQL)

ui = fluidPage(
  
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

server = function(input, output) {

  conn = dbConnect(MySQL( ), dbname = "rsloan", username = "root", password = "hitachi")
  
  im08 = dbGetQuery(conn, "SELECT * FROM im08")
  im09 = dbGetQuery(conn, "SELECT * FROM im09")
  
  dbDisconnect(conn)
  
  datasetInput = reactive({
    switch(input$dataset,
	"im09" = im09,
	"im08" = im08)
  })

  
  
  output$summary = renderPrint({
    dataset = datasetInput()
    summary(dataset)
  })
  
  # Show the first "n" observations
  output$view = renderTable({
    head(datasetInput(), n = input$obs)
  })

}


shinyApp(ui = ui, server = server)


