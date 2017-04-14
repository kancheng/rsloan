set.seed(929)

library(shiny)
library(RMySQL)
library(ggplot2)

# UI R File & Object
source("chooser.R")

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
          tabsetPanel("Analyze",
            tabPanel("Import",
              sidebarLayout(
                sidebarPanel(width = 3,
                  radioButtons("inputdt", "Choose :",
                               c("Sample Data" = "wkdsct","External Data" = "wkupfdt")
                               ),
                  numericInput("obsr", "Row View:", 15, min = 1, width = "100%"),
                  numericInput("obsc", "Col View:", 20, min = 1, width = "100%"),
                  submitButton("Update", icon("refresh"), width = "100%"),
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
                mainPanel(width = 7,
                  br(),
                  h1("Observations"),
                  br(),
                  tableOutput("view")
                )
              )
            ),
            tabPanel("Setting",
                  h2( "Dataset Column : " ),
                  helpText("Display the Dataset's Colume name which user's choice. "),
                  br(),
                  textOutput("alldtscolnm", container = pre),
                  br(),
                  h2( "Primary Column : " ),
                  textInput("pchoser", "", value = "c(\"sid\")"),
                  br(),
                  verbatimTextOutput("pcselt"),
                  br(),
                  submitButton("Submit", icon("refresh"), width = "30%"),
                  hr(),
                  h2( "Cluster Base Column : " ),
                  textInput("cbchoser", "", value = "c(\"cala\")" ),
                  verbatimTextOutput("cbcselt"),
                  br(),
                  submitButton("Submit", icon("refresh"), width = "30%")
            ),
            tabPanel("Cluster",
                     
              h2("Cluster :"),
              tableOutput('clutable')
              
            ),
            tabPanel("Summary",
                     
              h2("Summary :"),
              tableOutput('sumytable')
                     
            ),
            tabPanel("Analysis",
                     
              h2("Analysis :"),
              tableOutput('anaytable')
                     
            ),
            tabPanel("SLoan",
              tabsetPanel(
                tabPanel( "Have SLoan",
                  h2("Have SLoan :"),
                  tableOutput('hsloandt')
                ),
                tabPanel( "Not SLoan",
                  h2("Not SLoan :"),
                  tableOutput('nsloandt')
                )
              )
            ),
            tabPanel("Propotion",
              h2("Propotion :"),
              tableOutput('pptndt')
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


# SERVER R File & Object

server = function(input, output, session) {
  
  # tem
  tmsp = reactiveValues()

  hclust.methods = c("ward.D", "single", "complete", "average", "mcquitty", "median", "centroid", "ward.D2")
  dist.methods = c("euclidean", "maximum", "manhattan", "canberra", "binary" , "minkowski")

  # source r file
  source("./data/main-rfunc.R")
  source("./data/demo.R")
  source("chooser.R")

  
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
  # tablename = dbGetQuery(conn, "SHOW TABLES")

  # Data Input

    output$view = renderTable({
    indsw = switch(input$inputdt,
                   
            wkupfdt = {
                inFile = input$upfile
                if (is.null(inFile)){ return(NULL) }
                tmsp$cudf = read.csv(inFile$datapath, header = input$header, sep = input$sep,  quote = input$quote)
                if ( length(colnames(tmsp$cudf)) < 20 ){
                  head( tmsp$cudf , n = input$obsr)[1:length(colnames(tmsp$cudf))]
                }else{
                  head( tmsp$cudf , n = input$obsr)[1:input$obsc]
                }

            },
                     
            wkdsct = {
                tmsp$cudf = datasetInput()
                if ( length(colnames(tmsp$cudf)) < 20 ){
                  head( tmsp$cudf , n = input$obsr)[1:length(colnames(tmsp$cudf))]
                }else{
                  head( tmsp$cudf , n = input$obsr)[1:input$obsc]
                }
                
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

  # Setting
  output$alldtscolnm = renderPrint({
    colnames(tmsp$cudf)
  })
  
  output$pcselt = renderPrint({
    tmsp$pkb = input$pchoser
    cat(tmsp$pkb)
  })
  
  output$cbcselt = renderPrint({
    tmsp$cbase = input$cbchoser
    cat(tmsp$cbase)
  })

  # Cluster

  output$clutable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untavt
  }) 
  
  # Summary
  
  output$sumytable = renderTable({
    untal2ndsc
  }) 

  # Analysis
  output$anaytable = renderTable({
    unttkav
  })  
  
  # SLoan

  output$hsloandt = renderTable({
    untln1dsc
  })
  
  output$nsloandt = renderTable({
    untln0dsc
  })  
  
  # Propotion
  output$pptndt = renderTable({
    untslon
  })  
  
}

shinyApp(ui = ui, server = server)


