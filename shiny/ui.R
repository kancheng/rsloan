set.seed(929)

library(shiny)
library(RMySQL)
library(ggplot2)

# UI R File & Object

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
                                             textInput("cbchoser", "", value = "c(\"loam\", \"mm\" )" ),
                                             verbatimTextOutput("cbcselt"),
                                             br(),
                                             submitButton("Submit", icon("refresh"), width = "30%")
                                    ),
                                    tabPanel("Cluster",
                                             tabsetPanel(
                                               tabPanel("Dataset",
                                                        h2("Cluster :"),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        tableOutput('clutable')
                                               ),
                                               tabPanel("Plot",
                                                        h2("Plot :"),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput('cluplot')
                                               )
                                             )
                                    ),
                                    tabPanel("Summary",
                                             h2("Summary :"),
                                             submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('sumytable')
                                    ),
                                    tabPanel("Analysis",
                                             h2("Analysis :"),
                                             submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('anaytable')
                                    ),
                                    tabPanel("SLoan",
                                             tabsetPanel(
                                               tabPanel( "Have SLoan",
                                                         h2("Have SLoan :"),
                                                         submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         tableOutput('hsloandt')
                                               ),
                                               tabPanel( "Not SLoan",
                                                         h2("Not SLoan :"),
                                                         submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         tableOutput('nsloandt')
                                               )
                                             )
                                    ),
                                    tabPanel("Propotion",
                                             h2("Propotion :"),
                                             submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('pptndt')
                                    ),
                                    tabPanel("Diagram",
                                             tabsetPanel(
                                               tabPanel("Plot Setting",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       h1( "Dataset Column : " ),
                                                                       helpText("Display the Dataset's Colume name which user's choice. "),
                                                                       br(),
                                                                       textOutput("alldtscolnm2", container = pre)
                                                          ),
                                                          mainPanel(width = 7,
                                                                    h2( "1. Single Plot :" ),
                                                                    h3("PK Column : "),
                                                                    textInput("spbtxt1", "", value = "c(\"cala\")"),
                                                                    verbatimTextOutput("spbt1vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%"),
                                                                    h3("Analyze Column : "),
                                                                    textInput("spbtxt2", "", value = "c(\"itdc\")"),
                                                                    verbatimTextOutput("spbt2vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%"),
                                                                    br(),
                                                                    h2( "2. Multiple Plot :" ),
                                                                    h3("PK Column : "),
                                                                    textInput("mpbtxt1", "", value = "c(\"cala\")"),
                                                                    verbatimTextOutput("mpb1vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%"),
                                                                    h3("Analyze Column : "),
                                                                    textInput("mpbtxt2", "", value = "c(\"mm\", \"ma\", \"fm\", \"ac\", \"eca\", \"ecb\", \"calb\")", width = "100%"),
                                                                    verbatimTextOutput("mpb2vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%")
                                                          )
                                                        )
                                               ),
                                               tabPanel("Single Plot",
                                                        h2("Single Plot"),
                                                        br(),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput("singplot")
                                               ),
                                               tabPanel("Multiple Plot",
                                                        h2("Multiple Plot"),
                                                        br(),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput("multiplot")
                                               )
                                             )
                                    )
                        )
               ),
               
               tabPanel("Instruction",
                        sidebarLayout(
                          sidebarPanel("Instruction",
                                       downloadButton('downloadDemo', 'Download')
                          ),
                          mainPanel(
                            # demo data csv
                            tableOutput("swdmtb")
                          )
                        )
               )
               
    )
  )
)

