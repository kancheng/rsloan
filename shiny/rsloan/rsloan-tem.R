set.seed(929)
setwd("/home/haoye/rws")
getwd()
library(shiny)
library(RMySQL)
library(ggplot2)

ui = shinyUI(
  fluidPage(
    includeCSS(path = "https://github.com/kancheng/rsloan/blob/master/shiny/rsloan/main.css"),

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
                "RSLoan"),
            br(),
            br(),
            div(
              style = "
                  font-weight:200px;
                  font-size:17px;
                  color:#fdfdfd;",
              "The system of analysis students learning performance and economic status.")
            ,br()),
          div(          titlePanel("About"),
                        "Organization : Lunghwa University of Science and Technology",
                        br(),
                        "Author : Haoye",
                        br(),
                        "Github : ",a("https://github.com/kancheng/rsloan",href="https://github.com/kancheng/rsloan"))
        ),
  
        tabPanel("Cluster",
  
          titlePanel("Student Data"),
          
            sidebarLayout(
  
                sidebarPanel(
                  selectInput("dataset", "Choose a dataset:", 
                  choices = c( 
                    "bu08", "bu09", "bu10", "bu11", "bu12", "bu13", "bu14", "bu15",
                    "fi08", "fi09", "fi10", "fi11", "fi12", "fi13", "fi14", "fi15",
                    "ib08", "ib09", "ib10", "ib11", "ib12", "ib13", "ib14", "ib15",
                    "id08", "id09", "id10", "id11", "id12", "id13", "id14", "id15",
                    "im08", "im09", "im10", "im11", "im12", "im13", "im14", "im15")),
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
        )
      )

  )
)



server = function(input, output) {

  conn = dbConnect(MySQL( ), dbname = "rsloan", username = "root", password = "hitachi")
  
  # all table name
  tablename = dbGetQuery(conn, "SHOW TABLES")
  
  # all data
  bu08 = dbGetQuery(conn, "SELECT * FROM bu08")
  bu09 = dbGetQuery(conn, "SELECT * FROM bu09")
  bu10 = dbGetQuery(conn, "SELECT * FROM bu10")
  bu11 = dbGetQuery(conn, "SELECT * FROM bu11")
  bu12 = dbGetQuery(conn, "SELECT * FROM bu12")
  bu13 = dbGetQuery(conn, "SELECT * FROM bu13")
  bu14 = dbGetQuery(conn, "SELECT * FROM bu14")
  bu15 = dbGetQuery(conn, "SELECT * FROM bu15")
  
  fi08 = dbGetQuery(conn, "SELECT * FROM fi08")
  fi09 = dbGetQuery(conn, "SELECT * FROM fi09")
  fi10 = dbGetQuery(conn, "SELECT * FROM fi10")
  fi11 = dbGetQuery(conn, "SELECT * FROM fi11")
  fi12 = dbGetQuery(conn, "SELECT * FROM fi12")
  fi13 = dbGetQuery(conn, "SELECT * FROM fi13")
  fi14 = dbGetQuery(conn, "SELECT * FROM fi14")
  fi15 = dbGetQuery(conn, "SELECT * FROM fi15")
  
  ib08 = dbGetQuery(conn, "SELECT * FROM ib08")
  ib09 = dbGetQuery(conn, "SELECT * FROM ib09")
  ib10 = dbGetQuery(conn, "SELECT * FROM ib10")
  ib11 = dbGetQuery(conn, "SELECT * FROM ib11")
  ib12 = dbGetQuery(conn, "SELECT * FROM ib12")
  ib13 = dbGetQuery(conn, "SELECT * FROM ib13")
  ib14 = dbGetQuery(conn, "SELECT * FROM ib14")
  ib15 = dbGetQuery(conn, "SELECT * FROM ib15")
  
  id08 = dbGetQuery(conn, "SELECT * FROM id08")
  id09 = dbGetQuery(conn, "SELECT * FROM id09")
  id10 = dbGetQuery(conn, "SELECT * FROM id10")
  id11 = dbGetQuery(conn, "SELECT * FROM id11")
  id12 = dbGetQuery(conn, "SELECT * FROM id12")
  id13 = dbGetQuery(conn, "SELECT * FROM id13")
  id14 = dbGetQuery(conn, "SELECT * FROM id14")
  id15 = dbGetQuery(conn, "SELECT * FROM id15")
  
  im08 = dbGetQuery(conn, "SELECT * FROM im08")
  im09 = dbGetQuery(conn, "SELECT * FROM im09")
  im10 = dbGetQuery(conn, "SELECT * FROM im10")
  im11 = dbGetQuery(conn, "SELECT * FROM im11")
  im12 = dbGetQuery(conn, "SELECT * FROM im12")
  im13 = dbGetQuery(conn, "SELECT * FROM im13")
  im14 = dbGetQuery(conn, "SELECT * FROM im14")
  im15 = dbGetQuery(conn, "SELECT * FROM im15")
  
  output$contents = renderTable({
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
  })
  
  datasetInput = reactive({
    switch(input$dataset,

    # "table" = tablename,

    "bu08" = bu08,
    "bu09" = bu09,
    "bu10" = bu10,
    "bu11" = bu11,
    "bu12" = bu12,
    "bu13" = bu13,
    "bu14" = bu14,
    "bu15" = bu15,
    
    "fi08" = fi08,
    "fi09" = fi09,
    "fi10" = fi10,
    "fi11" = fi11,
    "fi12" = fi12,
    "fi13" = fi13,
    "fi14" = fi14,
    "fi15" = fi15,
    
    "ib08" = ib08,
    "ib09" = ib09,
    "ib10" = ib10,
    "ib11" = ib11,
    "ib12" = ib12,
    "ib13" = ib13,
    "ib14" = ib14,
    "ib15" = ib15,
    
    "id08" = id08,
    "id09" = id09,
    "id10" = id10,
    "id11" = id11,
    "id12" = id12,
    "id13" = id13,
    "id14" = id14,
    "id15" = id15,
    
    "im08" = im08,
    "im09" = im09,
    "im10" = im10,
    "im11" = im11,
    "im12" = im12,
    "im13" = im13,
    "im14" = im14,
    "im15" = im15
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


