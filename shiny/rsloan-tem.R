set.seed(929)

library(shiny)
library(RMySQL)
library(ggplot2)

ui = shinyUI(
  fluidPage(
    includeCSS(path = "./www/main.css"),
    tags$head(
      tags$link(rel = "shortcut icon", href = "https://raw.githubusercontent.com/kancheng/rsloan/master/shiny/www/favicon.ico")
    ),
      navbarPage("RSLoan",
  
        tabPanel( "Home",

          div( id = "home-txtbg",
              div( id = "home-txtct", "RSLoan"),
              
            br(),
            br(),
            
            div( id = "home-micttxt",
              "The system is to analyze students' learning performance and economic status.")
            ,br()),

          div( titlePanel("About"),
            "Organization : Lunghwa University of Science and Technology",
                        br(),
                        "Author : Haoye",
                        br(),
                        "Github : ",a("https://github.com/kancheng/rsloan",href="https://github.com/kancheng/rsloan"),
                        br(),
                        "ResearchGate : ",a("https://www.researchgate.net/profile/Hao_Cheng_Kan",href="https://www.researchgate.net/profile/Hao_Cheng_Kan")
          )
        ),
  
        tabPanel("Work",
          navlistPanel("Analyze", widths = c(1,8),
            tabPanel("Import",
              sidebarLayout(
                sidebarPanel(width = 3,

                  radioButtons("inputdt", "Choose :",
                               c("Sample Data" = "wkdsct","External Data" = "wkupfdt")
                               ),
                  numericInput("obsr", "Row View:", 15),
                  numericInput("obsc", "Col View:", 20),
                  submitButton("Submit", icon("refresh"), width = "100%"),
                 # tags$hr(),
                  tags$br(),
                  selectInput("dataset", "Sample Data :", 
                              choices = c(
                                "bu08", "bu09", "bu10", "bu11", "bu12", "bu13", "bu14", "bu15",
                                "fi08", "fi09", "fi10", "fi11", "fi12", "fi13", "fi14", "fi15",
                                "ib08", "ib09", "ib10", "ib11", "ib12", "ib13", "ib14", "ib15",
                                "id08", "id09", "id10", "id11", "id12", "id13", "id14", "id15",
                                "im08", "im09", "im10", "im11", "im12", "im13", "im14", "im15")),
                  fileInput('upfile', 'External Data : ',
                    accept = c('text/csv', 
                      'text/comma-separated-values,text/plain',  '.csv')),
                    checkboxInput('header', 'Header', TRUE),
                    radioButtons('sep', 'Separator',
                        c(Comma=',',
                          Semicolon=';',
                          Tab='\t'),
                        ','),
                    radioButtons('quote', 'Quote',
                        c(None='',
                          'Double Quote'='"',
                          'Single Quote'="'"),
                          '"'),
                  helpText("Please follow the instruction went Upload dataset.")),
                mainPanel(width = 8,
                  h4("Observations"),
                  tableOutput("view")
                )
              )
            ),

            tabPanel("Cluster",
              titlePanel("Cluster"),      
                       tableOutput('clutable')
            ),
            tabPanel("Diagram"
            ),
            tabPanel("Export"
            )
          )
        ),

        tabPanel("Instruction",
                 titlePanel("Instruction"),
                 # demo data csv
                 br(),
                 tableOutput("swdmtb")

        )

      )
  )
)





server = function(input, output) {
  source("./data/main-rfunc.R")
  source("./data/demo.R")
  
  # Instruction
  output$swdmtb = renderTable({demo}, caption = paste("If you want to use the RSLoan, Please download demo csv file."),
    caption.placement = getOption("xtable.caption.placement", "top"),
    caption.width = getOption("xtable.caption.width", NULL)
  )
  
  # DB Connect
  conn = dbConnect(MySQL( ), dbname = "rsloan", username = "root", password = "hitachi")
  
  # DB Table Name
  keydfn = c( "bu08", "bu09", "bu10", "bu11", "bu12", "bu13", "bu14", "bu15",
              "fi08", "fi09", "fi10", "fi11", "fi12", "fi13", "fi14", "fi15",
              "ib08", "ib09", "ib10", "ib11", "ib12", "ib13", "ib14", "ib15",
              "id08", "id09", "id10", "id11", "id12", "id13", "id14", "id15",
              "im08", "im09", "im10", "im11", "im12", "im13", "im14", "im15")

  selesqltb = function (ind){
    for( i in 1:length(ind)){
      cmds = paste0("dbGetQuery(conn, \"SELECT * FROM ", ind[i], "\")")
      assign(ind[i],
        eval(parse(text = cmds))
      , env = .GlobalEnv)
    }
  }
  
  # all data
  selesqltb(keydfn)
  
  # all table name
  tablename = dbGetQuery(conn, "SHOW TABLES")

  # Data Input
    output$view = renderTable({
      indsw = switch(input$inputdt,
                     wkupfdt = {
                       
                      inFile = input$upfile
                      if (is.null(inFile)){
                        return(NULL)
                      }
                      cudf = read.csv(inFile$datapath, header = input$header, sep = input$sep,  quote = input$quote)
                     # assign ("cudf", cudf, env = .GlobalEnv)
                      head( cudf , n = input$obsr)[1:input$obsc]
                      
                     },
                     
                      wkdsct = {
                        cudf = datasetInput()
                        #assign ("cudf", cudf, env = .GlobalEnv)
                        head( cudf, n = input$obsr)[1:input$obsc]
                        
                      }
                     )
    })

  datasetInput = reactive({
    switch(input$dataset,
    # "table" = tablename,
    "bu08" = bu08, "bu09" = bu09, "bu10" = bu10, "bu11" = bu11, "bu12" = bu12, "bu13" = bu13, "bu14" = bu14, "bu15" = bu15,
    "fi08" = fi08, "fi09" = fi09, "fi10" = fi10, "fi11" = fi11, "fi12" = fi12, "fi13" = fi13, "fi14" = fi14, "fi15" = fi15,
    "ib08" = ib08, "ib09" = ib09, "ib10" = ib10, "ib11" = ib11, "ib12" = ib12, "ib13" = ib13, "ib14" = ib14, "ib15" = ib15,
    "id08" = id08, "id09" = id09, "id10" = id10, "id11" = id11, "id12" = id12, "id13" = id13, "id14" = id14, "id15" = id15,
    "im08" = im08, "im09" = im09, "im10" = im10, "im11" = im11, "im12" = im12, "im13" = im13, "im14" = im14, "im15" = im15
    )
  })

  # Cluster
  # output$cluwork = 
  
  output$clutable = renderTable({
    if(!(is.null(input$upfile$datapath))){
      
      cudf = read.csv(input$upfile$datapath, header = input$header, sep = input$sep,  quote = input$quote)
      head(cudf)
    } else if(!(is.null(datasetInput()))){
      head(datasetInput())
    }
  })
  
  
  #output$clutable = renderTable({
  #  input$submbtn
  # })
  
}

shinyApp(ui = ui, server = server)


