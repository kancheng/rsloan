set.seed(929)

library(plotly)
library(shiny)
library(RMySQL)
library(ggplot2)
library(rmarkdown)
library("clValid")

# UI R File & Object

shinyUI(
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
                              "Author : ",a("Haoye",href="https://kancheng.github.io/"),
                              br(),
                              "Github : ",a("https://github.com/kancheng/rsloan",href="https://github.com/kancheng/rsloan"),
                              br(),
                              "ResearchGate : ",a("https://www.researchgate.net/profile/Hao_Cheng_Kan",href="https://www.researchgate.net/profile/Hao_Cheng_Kan")
                         )
               ),
               tabPanel("Work",
                        tabsetPanel("Analyze",
                                    tabPanel("Import - 輸入資料來源",
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
                                                                          "資訊管理系 - 2008", "資訊管理系 - 2009", "資訊管理系 - 2010", "資訊管理系 - 2011", "資訊管理系 - 2012", 
                                                                          "資訊管理系 - 2013", "資訊管理系 - 2014", "資訊管理系 - 2015",
                                                                          "企業管理系 - 2008", "企業管理系 - 2009", "企業管理系 - 2010", "企業管理系 - 2011", "企業管理系 - 2012", 
                                                                          "企業管理系 - 2013", "企業管理系 - 2014", "企業管理系 - 2015",
                                                                          "財務金融系 - 2008", "財務金融系 - 2009", "財務金融系 - 2010", "財務金融系 - 2011", "財務金融系 - 2012", 
                                                                          "財務金融系 - 2013", "財務金融系 - 2014", "財務金融系 - 2015",
                                                                          "國際企業系 - 2008", "國際企業系 - 2009", "國際企業系 - 2010", "國際企業系 - 2011", "國際企業系 - 2012", 
                                                                          "國際企業系 - 2013", "國際企業系 - 2014", "國際企業系 - 2015",
                                                                          "工業管理系 - 2008", "工業管理系 - 2009", "工業管理系 - 2010", "工業管理系 - 2011", "工業管理系 - 2012", 
                                                                          "工業管理系 - 2013", "工業管理系 - 2014", "工業管理系 - 2015")),
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
                                    #tabPanel("CV - 建議分群",
                                    #         sidebarLayout(
                                    #           sidebarPanel( width = 3
                                    #             
                                    #           ),
                                    #           mainPanel( width = 7
                                    #             
                                    #           )
                                    #         )
                                    #),
                                    tabPanel("Setting - 分析設定",
                                          sidebarLayout(
                                            sidebarPanel(width = 3,
                                                     helpText("由此選擇分群數量與分群方法跟距離。"),
                                                     h1("分群數量"),
                                                     numericInput("clunmtb", "Clu Number:", 6),
                                                     h1("分群方法"),
                                                     radioButtons("hclust.methods", "Choose :",
                                                                  c("Ward.D" = "ward.D", "Ward.D2" = "ward.D2", "Single" = "single",
                                                                    "Complete" = "complete", "Average" = "average", "Mcquitty" = "mcquitty",
                                                                    "Median" = "median", "Centroid" = "centroid"
                                                                    )
                                                     ),
                                                     h1("分群距離"),
                                                     radioButtons("dist.methods", "Choose :",
                                                                  c("Euclidean" = "euclidean","Maximum" = "maximum", "Manhattan" = "manhattan",
                                                                    "Canberra" = "canberra", "Binary" = "binary", "Minkowski" = "minkowski"
                                                                    )
                                                     ),
                                                     submitButton("Update", icon("refresh"), width = "100%")
                                            ),
                                            mainPanel(width = 7,
                                              h2( "檢視資料欄位" ),
                                              helpText("Display the Dataset's Colume name which user's choice. "),
                                              br(),
                                              textOutput("alldtscolnm", container = pre),
                                              br(),
                                              h2( "主要欄位" ),
                                              textInput("pchoser", "", value = "\"sid\""),
                                              br(),
                                              verbatimTextOutput("pcselt"),
                                              br(),
                                              submitButton("Submit", icon("refresh"), width = "30%"),
                                              hr(),
                                              h2( "分群基礎欄位" ),
                                              textInput("cbchoser", "", value = "\"loam\", \"微積分一\",\"經濟學\",\"程式設計\"" ),
                                              verbatimTextOutput("cbcselt"),
                                              br(),
                                              submitButton("Submit", icon("refresh"), width = "30%")
                                            )
                                          )
                                    ),
                                    tabPanel("Cluster - 集群分析",
                                             tabsetPanel(
                                               tabPanel("分群資料結果檢視",
                                                        h2("Cluster"),
                                                        helpText("檢視分群資料集"),
                                                        # submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        tableOutput('clutable')
                                               ),
                                               tabPanel("集群圖",
                                                        h2("Plot"),
                                                        helpText("檢視分群樹狀圖"),
                                                        # submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput('cluplot')
                                               )
                                             )
                                    ),
                                    tabPanel("Summary - 敘述統計",
                                             h2("Summary"),
                                             helpText("分群狀態、最小最大等計算"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('sumytable')
                                    ),
                                    tabPanel("Analysis - 變異數分析",
                                             h2("Analysis"),
                                             helpText("ANOVA & Tukey 分析"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('anaytable')
                                    ),
                                    tabPanel("SLoan - 就學貸敘述統計",
                                             tabsetPanel(
                                               tabPanel( "Have SLoan - 有就學貸款",
                                                         h2("Have SLoan"),
                                                         # submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         tableOutput('hsloandt')
                                               ),
                                               tabPanel( "Not SLoan - 無就學貸款",
                                                         h2("Not SLoan"),
                                                         # submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         tableOutput('nsloandt')
                                               )
                                             )
                                    ),
                                    tabPanel("Propotion - 就學貸款人數比率",
                                      sidebarLayout(
                                        sidebarPanel(width = 3,
                                             h2("Table"),
                                             helpText("檢視就學貸款人數比率資料集"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('pptndt')
                                        ),
                                        mainPanel(width = 7,
                                             h2("Plot"),
                                             br(),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             plotOutput("prosloan")
                                        )
                                      )        
                                    ),
                                    tabPanel("Diagram - 視覺化結果",
                                             tabsetPanel(
                                               tabPanel("Plot Setting - 單圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       h1( "Dataset Column" ),
                                                                       helpText("Display the Dataset's Colume name which user's choice. "),
                                                                       br(),
                                                                       textOutput("alldtscolnm2", container = pre)
                                                          ),
                                                          mainPanel(width = 7,
                                                                    h2( "Single Plot" ),
                                                                    h3("PK Column"),
                                                                    textInput("spbtxt1", "", value = "\"微積分一\""),
                                                                    verbatimTextOutput("spbt1vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%"),
                                                                    h3("Analyze Column : "),
                                                                    textInput("spbtxt2", "", value = "\"計算機概論\""),
                                                                    verbatimTextOutput("spbt2vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%")
                                                          )
                                                        )
                                               ),
                                               tabPanel("Single Plot - 單繪圖",
                                                        h2("Single Plot"),
                                                        br(),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput("singplot")
                                               ),
                                               tabPanel("Plot Setting - 多圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       h1( "Dataset Column" ),
                                                                       helpText("Display the Dataset's Colume name which user's choice. "),
                                                                       br(),
                                                                       textOutput("alldtscolnm3", container = pre)
                                                          ),
                                                          mainPanel(width = 7,
                                                                    h2( "Multiple Plot" ),
                                                                    h3("PK Column"),
                                                                    textInput("mpbtxt1", "", value = "\"微積分一\""),
                                                                    verbatimTextOutput("mpb1vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%"),
                                                                    h3("Analyze Column : "),
                                                                    textInput("mpbtxt2", "", value = "\"計算機概論\", \"管理學\", \"統計學\", \"微積分一\""
                                                                              , width = "100%"),
                                                                    verbatimTextOutput("mpb2vto"),
                                                                    submitButton("Submit", icon("refresh"), width = "30%")
                                                          )
                                                        )
                                               ),
                                               tabPanel("Multiple Plot - 多繪圖",
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

