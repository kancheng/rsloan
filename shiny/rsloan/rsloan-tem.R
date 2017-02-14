set.seed(929)
setwd("/home/haoye/rws")
getwd()
library(shiny)
library(RMySQL)
library(ggplot2)

ui = shinyUI(
  fluidPage(

    tags$head(
      
      tags$link(rel = "shortcut icon", href = "https://raw.githubusercontent.com/kancheng/rsloan/master/shiny/rsloan/www/favicon.ico")
                        
                        ),
    
      navbarPage("RSLoan",

        tabPanel( "Home",
                  
          div( 
            style = "
                max-height:516px;
                width:100%;
                text-align:center; 
                background-color: #428BCA; 
                background-repeat: repeat-x;
                background-position: center;
            ", 
              div(
                style = "
                  font-size:120px;
                  margin-bottom:0;
                  color:#fdfdfd;",
                "RSLoan"
              )
            )
                 
          ),
  
        tabPanel("Cluster",
  
          titlePanel("Student Data"),
          
            sidebarLayout(
  
                sidebarPanel(
                  selectInput("dataset", "Choose a dataset:", 
                  choices = c( "im08", "im09", "table")),
                  numericInput("obs", "Number of observations to view:", 10),
                  helpText("Note: Haoye test"),
  
                  tags$hr(),
  
                  fileInput('file1', 'Choose CSV File',
                            accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')
                  ),
                  
                  submitButton("Update View")
  
                ),
  
                mainPanel(
                  h4("Observations"),
                  tableOutput("view"),
                  h4("Head"),
                  verbatimTextOutput("headdat")
                )
            )
        ),

        tabPanel("reference",
                 titlePanel("Reference")
        ),
  
        tabPanel("about",
          titlePanel("About"),
            br(),
            "Organization : Lunghwa University of Science and Technology",
            br(),
            "Author : Haoye",
            br(),
            "Github : ",a("https://github.com/kancheng/rsloan",href="https://github.com/kancheng/rsloan")
        )

      )

  )
)



server = function(input, output) {

  conn = dbConnect(MySQL( ), dbname = "rsloan", username = "root", password = "hitachi")
  tablename = dbGetQuery(conn, "SHOW TABLES")
  im08 = dbGetQuery(conn, "SELECT * FROM im08")
  im09 = dbGetQuery(conn, "SELECT * FROM im09")
  
  dbDisconnect(conn)
  
  output$contents <- renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })
  
  datasetInput = reactive({
    switch(input$dataset,
    "table" = tablename,
    "im09" = im09,
    "im08" = im08
    )
  })


  
  output$headdat = renderPrint({
    dataset = datasetInput()
    head(dataset)
  })
  
  # Show the first "n" observations
  output$view = renderTable({
    head(datasetInput(), n = input$obs)
  })

}


shinyApp(ui = ui, server = server)


