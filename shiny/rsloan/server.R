library(shiny)
library(ggplot2)
library(RMySQL)

function(input, output) {

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



