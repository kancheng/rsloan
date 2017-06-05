set.seed(929)

library(plotly)
library(shiny)
library(RMySQL)
library(ggplot2)
library(rmarkdown)
library("clValid")
library("DT")
require(useful)

# UI R File & Object

shinyUI(
  fluidPage(
    includeCSS(path = "./www/main.css"),
    tags$head(
      tags$link(rel = "shortcut icon", href = "https://raw.githubusercontent.com/kancheng/rsloan/master/shiny-server/rsloan/www/favicon.ico")
    ),
    navbarPage("A3S",
               
               tabPanel( "Home",
                         
                         div( id = "home-txtbg",
                              div( id = "home-txtct", "A3S"),
                              br(),
                              div( id = "home-mic",
                                "學業成就分析系統",
                                br(),
                                "Academic achievement analysis system"
                              ),
                              br()
                              ),
                         br(),
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

                                    tabPanel("Setting - 分析設定",
                                      tabsetPanel(
                                        tabPanel("*分群設定",

                                          h1( "檢視資料欄位" ),
                                          helpText("Display the Dataset's Colume name which user's choice. "),
                                          br(),
                                          textOutput("alldtscolnm", container = pre),
                                          hr(),
                                                 
                                          h2( "主要欄位" ),
                                          helpText("為辨別個別學生的欄位，欄位與資料皆為唯一"),
                                          textInput("pchoser", "", value = "\"sid\""),
                                          verbatimTextOutput("pcselt"),
                                          # submitButton("Submit", icon("refresh"), width = "50%"),
                                          hr(),
                                                         
                                          h2( "分群基礎欄位" ),
                                          helpText("為所要分群的科目欄位"),
                                          textInput("cbchoser", "", value = "\"loam\", \"微積分一\",\"經濟學\",\"程式設計\"" ),
                                          verbatimTextOutput("cbcselt"),
                                          submitButton("Submit", icon("refresh"), width = "40%")

                                        ),
                                        tabPanel("*建議分群",
                                          sidebarLayout( 
                                            sidebarPanel(width = 3,
                                                         
                                              h2("分群數量"),
                                              helpText("由此選擇分群數量與分群方法跟距離。"),
                                              numericInput("clunmtb", "Clu Number:", 6),
                                              br(),
                                              h2("分群方法設定"),
                                              radioButtons("allclurbmd", "Choose :",
                                                           c("Hierarchical Clustering" = "hcarb1", 
                                                             "K-Means" = "kmcrb2", "PAM" = "pamrb3"
                                                           )
                                              ),
                                              submitButton("Update", icon("refresh"), width = "100%"),
                                              br(),
                                              helpText("請至下一分頁設定功能參數")
                                              
                                            ),
                                            
                                            mainPanel(width = 7,
                                                      tabsetPanel( id = "allcvsuyplot",
                                                        tabPanel("建議分群", plotOutput('clValidplot')),
                                                        tabPanel("Summary", verbatimTextOutput('clValidSummary'))
                                                      )
                                            )

                                          )
                                        ),
                                        tabPanel("*功能參數設定",
                                          fluidRow(
                                            column(4, wellPanel(
                                              h2("Hierarchical Clustering"),       
                                              h3("分群方法"),
                                              radioButtons("hclust.methods", "Choose :",
                                                           c("Ward.D" = "ward.D", "Ward.D2" = "ward.D2", "Single" = "single",
                                                             "Complete" = "complete", "Average" = "average", "Mcquitty" = "mcquitty",
                                                             "Median" = "median", "Centroid" = "centroid"
                                                           )
                                              ),
                                              
                                              h3("分群距離"),
                                              radioButtons("dist.methods", "Choose :",
                                                           c("Euclidean" = "euclidean","Maximum" = "maximum", "Manhattan" = "manhattan",
                                                             "Canberra" = "canberra", "Binary" = "binary", "Minkowski" = "minkowski"
                                                           )
                                              ),
                                              submitButton("Run", icon("refresh"), width = "100%") 
                                            )),
                                                   
                                            column(4, wellPanel(
                                              h2("K-Means"),
                                              numericInput("knstartnum", "Nstart Number:", 25),
                                              submitButton("Run", icon("refresh"), width = "100%") 
                                            ))
                                          )

                                        )

                                      )
                                    ),
                                    tabPanel("Cluster - 集群分析",
                                             tabsetPanel(
                                               tabPanel("*分群資料結果檢視",
                                                        h2("Cluster"),
                                                        helpText("檢視分群資料集"),
                                                        # submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        
                                                        # tableOutput('clutable')
                                                        DT::dataTableOutput('clutable')
                                               ),
                                               tabPanel("集群圖",
                                                        h2("Plot"),
                                                        helpText("檢視分群樹狀圖"),
                                                        # submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput('cluplot')
                                               ),
                                               tabPanel("Download",
                                                        h2("集群分析"),
                                                        helpText("下載分群資料集 CSV"),
                                                        br(),
                                                        downloadButton('clutabledl', 'Download')
                                               )
                                               
                                             )
                                    ),
                                    tabPanel("Summary - 敘述統計",
                                      tabsetPanel(
                                        
                                        tabPanel("*Summary" ,
                                             h2("Summary"),
                                             helpText("分群狀態、最小最大等計算"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             # tableOutput('sumytable')
                                             DT::dataTableOutput('sumytable')
                                        ),
                                        
                                        tabPanel("Summary - 單科目平均檢視",
                                          sidebarLayout(
                                            
                                            sidebarPanel(width = 3,
                                              h2( "輸入單科目名稱" ),
                                              helpText("為所要檢視的分群單科目平均狀態"),
                                              textInput("sumyplotcol", "", value = "\"微積分一\"" ),
                                              submitButton("Submit", icon("refresh"), width = "40%")
                                                         
                                            ),
                                            mainPanel(width = 7,
                                              h2("Summary"),
                                              tableOutput("sumyeach"),
                                              br(),
                                              h2("Plot"),
                                              plotOutput("sumyeachplot") 
                                            )
                                                     
                                          )
                                        ),
                                        
                                        tabPanel("Download",
                                                 h2("敘述統計"),
                                                 helpText("下載敘述統計資料集 CSV"),
                                                 br(),
                                                 downloadButton('sumytabledl', 'Download')
                                        )
                                        
                                      )
                                    ),
                                    tabPanel("Analysis - 變異數分析",
                                      tabsetPanel(  
                                             
                                        tabPanel("*Analysis",
                                             h2("Analysis"),
                                             helpText("ANOVA & Tukey 分析"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             # tableOutput('anaytable')
                                             DT::dataTableOutput('anaytable')
                                        ),
                                        
                                        tabPanel("Download",
                                                 h2("變異數分析"),
                                                 helpText("下載變異數分析資料集 CSV"),
                                                 br(),
                                                 downloadButton('anaytabledl', 'Download')
                                        )
                                        
                                      )
                                    ),
                                    tabPanel("SLoan - 就學貸敘述統計",
                                      tabsetPanel(
                                               
                                        tabPanel( "*Have SLoan - 有就學貸款",
                                                         h2("Have SLoan"),
                                                         helpText("有辦理就學貸款的各群敘述統計"),
                                                         # submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         # tableOutput('hsloandt')
                                                         DT::dataTableOutput('hsloandt')
                                        ),
                                               
                                        tabPanel( "Have SLoan - 單科目平均檢視",
                                          sidebarLayout(
                                            
                                            sidebarPanel(width = 3,
                                              h2( "輸入單科目名稱" ),
                                              helpText("為所要檢視的分群單科目平均狀態"),
                                              textInput("hslplotcol", "", value = "\"微積分一\"" ),
                                              submitButton("Submit", icon("refresh"), width = "40%")              
                                            ),
                                                    
                                            mainPanel(width = 7,
                                              h2("Summary"),
                                              tableOutput("hsleach"),
                                              br(),
                                              h2("Plot"),
                                              plotOutput("hsleachplot")            
                                            )
                                                    
                                          )
                                        ),
                                               
                                        tabPanel( "*Not SLoan - 無就學貸款",
                                                         h2("Not SLoan"),
                                                         helpText("無辦理就學貸款的各群敘述統計"),
                                                         # submitButton("Submit", icon("refresh"), width = "30%"),
                                                         br(),
                                                         # tableOutput('nsloandt')
                                                         DT::dataTableOutput('nsloandt')
                                        ),
                                              
                                        tabPanel( "Not SLoan - 單科目平均檢視",
                                          sidebarLayout(
                                                    
                                            sidebarPanel(width = 3,
                                              h2( "輸入單科目名稱" ),
                                              helpText("為所要檢視的分群單科目平均狀態"),
                                              textInput("nslplotcol", "", value = "\"微積分一\"" ),
                                              submitButton("Submit", icon("refresh"), width = "40%")             
                                            ),
                                                    
                                            mainPanel(width = 7,
                                              h2("Summary"),
                                              tableOutput("nsleach"),
                                              br(),
                                              h2("Plot"),
                                              plotOutput("nsleachplot")     
                                            )
                                                    
                                          )
                                        ),
                                               
                                        tabPanel("Download",
                                          h2("Have SLoan"),
                                          helpText("下載變異數分析資料集 CSV"),
                                          br(),
                                          downloadButton('hsloandtdl', 'Download'),
                                          br(),
                                          h2("Not SLoan"),
                                          helpText("下載變異數分析資料集 CSV"),
                                          downloadButton('nsloandtdl', 'Download')
                                        )
                                               
                                      )
                                    ),
                                    
                                    tabPanel("Propotion - 就學貸款人數比率",
                                      sidebarLayout(
                                        mainPanel(width = 3,
                                             h2("Table"),
                                             helpText("檢視就學貸款人數比率資料集"),
                                             # submitButton("Submit", icon("refresh"), width = "30%"),
                                             br(),
                                             tableOutput('pptndt'),
                                             helpText("下載就學貸款人數比率資料集 CSV"),
                                             downloadButton('pptndtdl', 'Download')
                                        ),
                                        mainPanel(width = 7,
                                          tabsetPanel(
                                            tabPanel("*Merge",
                                                     h2("Plot"),
                                                     br(),
                                                     # submitButton("Submit", icon("refresh"), width = "30%"),
                                                     br(),
                                                     plotOutput("prosloan3")
                                            ),
                                            tabPanel("分群比",
                                              h2("Plot"),
                                              br(),
                                              # submitButton("Submit", icon("refresh"), width = "30%"),
                                              br(),
                                              plotOutput("prosloan")
                                            ),
                                            tabPanel("就貸人數",
                                              h2("Plot"),
                                              br(),
                                              # submitButton("Submit", icon("refresh"), width = "30%"),
                                              br(),
                                              plotOutput("prosloan2")
                                            ),
                                            tabPanel("就貸比例",
                                                     h2("Formula"),
                                                     br(),
                                                     withMathJax(),
                                                     helpText("$$ 就貸比例 = \\frac{分群中辦理就學貸款人數}{分群總人數}$$"),
                                                     br(),
                                                     h2("Percentage"),
                                                     br(),
                                                     plotOutput('temloanrate'),
                                                     br()   
                                            )
                                          )
                                        )
                                      )        
                                    ),
                                    tabPanel("Diagram - 視覺化結果",
                                             tabsetPanel(
                                               tabPanel("*Plot Setting - 單圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       
                                                                       h2( "Single Plot" ),
                                                                      # radioButtons("pointview", "Choose :",
                                                                                 #   c("顯示數值" = "havepoint", 
                                                                                  #    "隱藏數值" = "notpoint"
                                                                                  #  )
                                                                       #),
                                                                       h3("PK Column"),
                                                                       textInput("spbtxt1", "", value = "\"微積分一\""),
                                                                       verbatimTextOutput("spbt1vto"),
                                                                       # submitButton("Submit", icon("refresh"), width = "30%"),
                                                                       
                                                                       h3("Analyze Column"),
                                                                       textInput("spbtxt2", "", value = "\"計算機概論\""),
                                                                       verbatimTextOutput("spbt2vto"),
                                                                       submitButton("Submit", icon("refresh"), width = "30%")
                                                                       
                                                          ),
                                                          mainPanel(width = 7,

                                                                    h1( "Dataset Column" ),
                                                                    helpText("Display the Dataset's Colume name which user's choice. "),
                                                                    br(),
                                                                    textOutput("alldtscolnm2", container = pre)

                                                          )
                                                        )
                                               ),
                                               tabPanel("Single Plot - 單繪圖",
                                                        tabsetPanel(
                                                          tabPanel("顯示數值",
                                                            h2("Single Plot"),
                                                            helpText("單一科目散佈圖"),
                                                            br(),
                                                            submitButton("Submit", icon("refresh"), width = "30%"),
                                                            br(),
                                                            plotOutput("singplot")
                                                          ),
                                                          tabPanel("隱藏數值",
                                                            h2("Single Plot"),
                                                            helpText("單一科目散佈圖"),
                                                            br(),
                                                            submitButton("Submit", icon("refresh"), width = "30%"),
                                                            br(),
                                                            plotOutput("singplot2")                                                          
                                                          )
                                                        )
                                               ),
                                               tabPanel("*Plot Setting - 多圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       
                                                            h2( "Multiple Plot" ),
                                                            h3("PK Column"),
                                                            textInput("mpbtxt1", "", value = "\"微積分一\""),
                                                            verbatimTextOutput("mpb1vto"),
                                                            # submitButton("Submit", icon("refresh"), width = "30%"),
                                                                       
                                                            h3("Analyze Column"),
                                                            textInput("mpbtxt2", "", value = "\"計算機概論\", \"管理學\", \"統計學\", \"微積分一\""
                                                                  , width = "100%"),
                                                            verbatimTextOutput("mpb2vto"),
                                                            submitButton("Submit", icon("refresh"), width = "30%") 

                                                          ),
                                                          mainPanel(width = 7,
                                                                    
                                                            h1( "Dataset Column" ),
                                                            helpText("Display the Dataset's Colume name which user's choice. "),
                                                            br(),
                                                            textOutput("alldtscolnm3", container = pre)

                                                          )
                                                        )
                                               ),
                                               tabPanel("Multiple Plot - 多繪圖",
                                                        h2("Multiple Plot"),
                                                        helpText("多科目散佈圖合併"),
                                                        br(),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput("multiplot")
                                               ),
                                               tabPanel("*分組單圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       
                                                                       h2( "Single Plot" ),
                                                                       h3("PK Column"),
                                                                       textInput("espbtxt1", "", value = "\"微積分一\""),
                                                                       verbatimTextOutput("espbt1vto"),
                                                                       # submitButton("Submit", icon("refresh"), width = "30%"),
                                                                       
                                                                       h3("Analyze Column"),
                                                                       textInput("espbtxt2", "", value = "\"計算機概論\""),
                                                                       verbatimTextOutput("espbt2vto"),
                                                                       submitButton("Submit", icon("refresh"), width = "30%")
                                                                       
                                                          ),
                                                          mainPanel(width = 7,
                                                                    
                                                                    h1( "Dataset Column" ),
                                                                    helpText("Display the Dataset's Colume name which user's choice. "),
                                                                    br(),
                                                                    textOutput("ealldtscolnm2", container = pre)
                                                                    
                                                          )
                                                        )
                                               ),
                                               tabPanel("分組單繪圖",
                                                        tabsetPanel(
                                                          tabPanel("顯示有辦理就學貸款數值",
                                                                   h2("Single Plot"),
                                                                   helpText("單一科目散佈圖"),
                                                                   br(),
                                                                   submitButton("Submit", icon("refresh"), width = "30%"),
                                                                   br(),
                                                                   plotOutput("el1singplot")
                                                          ),
                                                          tabPanel("隱藏有辦理就學貸款數值",
                                                                   h2("Single Plot"),
                                                                   helpText("單一科目散佈圖"),
                                                                   br(),
                                                                   submitButton("Submit", icon("refresh"), width = "30%"),
                                                                   br(),
                                                                   plotOutput("el1singplot2")                                                          
                                                          ),
                                                          tabPanel("顯示無辦理就學貸款數值",
                                                                   h2("Single Plot"),
                                                                   helpText("單一科目散佈圖"),
                                                                   br(),
                                                                   submitButton("Submit", icon("refresh"), width = "30%"),
                                                                   br(),
                                                                   plotOutput("el0singplot")
                                                          ),
                                                          tabPanel("隱藏無辦理就學貸款數值",
                                                                   h2("Single Plot"),
                                                                   helpText("單一科目散佈圖"),
                                                                   br(),
                                                                   submitButton("Submit", icon("refresh"), width = "30%"),
                                                                   br(),
                                                                   plotOutput("el0singplot2")                                                          
                                                          )
                                                        )
                                               ),
                                               tabPanel("*分組多圖參數設定",
                                                        sidebarLayout(
                                                          sidebarPanel(width = 3,
                                                                       
                                                                       h2( "Multiple Plot" ),
                                                                       h3("PK Column"),
                                                                       textInput("empbtxt1", "", value = "\"微積分一\""),
                                                                       verbatimTextOutput("empb1vto"),
                                                                       # submitButton("Submit", icon("refresh"), width = "30%"),
                                                                       
                                                                       h3("Analyze Column"),
                                                                       textInput("empbtxt2", "", value = "\"計算機概論\", \"管理學\", \"統計學\", \"微積分一\""
                                                                                 , width = "100%"),
                                                                       verbatimTextOutput("empb2vto"),
                                                                       submitButton("Submit", icon("refresh"), width = "30%") 
                                                                       
                                                          ),
                                                          mainPanel(width = 7,
                                                                    
                                                                    h1( "Dataset Column" ),
                                                                    helpText("Display the Dataset's Colume name which user's choice. "),
                                                                    br(),
                                                                    textOutput("ealldtscolnm3", container = pre)
                                                                    
                                                          )
                                                        )
                                               ),
                                               tabPanel("分組多繪圖",
                                                tabsetPanel(
                                                  tabPanel("有辦理就學貸款",
                                                        h2("Multiple Plot"),
                                                        helpText("多科目散佈圖合併"),
                                                        br(),
                                                        submitButton("Submit", icon("refresh"), width = "30%"),
                                                        br(),
                                                        plotOutput("el1multiplot")
                                                  ),
                                                  tabPanel("無辦理就學貸款",
                                                           h2("Multiple Plot"),
                                                           helpText("多科目散佈圖合併"),
                                                           br(),
                                                           submitButton("Submit", icon("refresh"), width = "30%"),
                                                           br(),
                                                           plotOutput("el0multiplot")
                                                  )   
                                                )                                                        
                                               )
                                             )
                                    )
                        )
               ),
               
               tabPanel("Instruction",
                        h1("說明"),
                        helpText("The system is to analyze students' learning performance and economic status."),
                        br(),
                        sidebarLayout(
                          mainPanel( width = 4,
                                      h2("範例檔案下載"),
                                     br(),
                                       downloadButton('downloadDemo', 'Download')
                          ),
                          mainPanel( width = 6,
                            # demo data csv
                            h2("檢視範例"),
                            br(),
                            helpText("除去這兩個為 '學生編號'(sid) 與 '管理學院-就學貸款'(loam) 欄位，其他可直接往後填自己想要的成績欄位。"),
                            tableOutput("swdmtb")
                          )
                        )
               )
               
    )
  )
)

