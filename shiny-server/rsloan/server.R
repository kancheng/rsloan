set.seed(929)

library(plotly)
library(shiny)
library(RMySQL)
library(ggplot2)
library(rmarkdown)

# SERVER R File & Object

function(input, output, session) {
  
  # tem
  tmsp = reactiveValues()
  
  hclust.methods = c("ward.D", "single", "complete", "average", "mcquitty", "median", "centroid", "ward.D2")
  dist.methods = c("euclidean", "maximum", "manhattan", "canberra", "binary" , "minkowski")
  
  # source r file
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
  
  
  output$cluplot = renderPlot({
    hcaon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
  })
  
  output$clutable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untavt
  }) 
  
  # Summary
  
  output$sumytable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untal2ndsc
  }) 
  
  # Analysis
  output$anaytable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    unttkav
  })  
  
  # SLoan
  
  output$hsloandt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untln1dsc
  })
  
  output$nsloandt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untln0dsc
  })  
  
  # Propotion
  output$pptndt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
    untslon
  })  
  
  # Diagram
  mainindex = c( "cala" )
  courindex1 = c( "itdc")
  
  courindex2 = c( "itdc", "cppg", "pcpg", "oopg", "itdcn", "cala", "calb", "ec", 
                  "dtst", "nwkpm", "sadm", "idbs", "st", "mana", "inkpg", "dbms", "mis")
  
  output$spbt1vto = renderPrint({
    tmsp$spbtxt1 = input$spbtxt1
    cat(tmsp$spbtxt1)
  })
  
  output$spbt2vto = renderPrint({
    tmsp$spbtxt2 = input$spbtxt2
    cat(tmsp$spbtxt2)
  })
  
  output$mpb1vto = renderPrint({
    tmsp$mpbtxt1 = input$mpbtxt1
    cat(tmsp$mpbtxt1)
  })
  
  output$mpb2vto = renderPrint({
    tmsp$mpbtxt2 = input$mpbtxt2
    cat(tmsp$mpbtxt2)
  })
  
  
  output$singplot = renderPlot({
    tmsp$evalspbtxt1 = eval(parse(text = tmsp$spbtxt1))
    tmsp$evalspbtxt2 = eval(parse(text = tmsp$spbtxt2))
    tmsp$shspic  = sg2proc("untavt", tmsp$evalspbtxt1, tmsp$evalspbtxt2)
    untavt.gmp
  })
  
  output$multiplot = renderPlot({
    tmsp$evalmpbtxt1 = eval(parse(text = tmsp$mpbtxt1))
    tmsp$evalmpbtxt2 = eval(parse(text = tmsp$mpbtxt2))
    tmsp$shmpic = mg2proc("untavt", tmsp$evalmpbtxt1, tmsp$evalmpbtxt2)
    untavt.mulgmp
  })
  
  output$alldtscolnm2 = renderPrint({
    colnames(tmsp$cudf)
  })
  
  
  # Instruction
  
  output$downloadDemo = downloadHandler(
    filename = function() { 
      paste( "demo", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(demo, file)
    }
  )
}


