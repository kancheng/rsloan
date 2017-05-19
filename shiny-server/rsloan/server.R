set.seed(929)

library(plotly)
library(shiny)
library(RMySQL)
library(ggplot2)
library(rmarkdown)
library("clValid")
library("DT")

# SERVER R File & Object

function(input, output, session) {
  
  # tem
  tmsp = reactiveValues()
  
  # source r file
  source("./data/main-rfunc.R")
  source("./data/demo.R")
  source("./data/colnm.R")
  
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

 # Data Col Name
  selesqltb = function (ind){
    for( i in 1:length(ind)){
      cmds1 = paste0("dbGetQuery(conn, \"SELECT * FROM ", ind[i], "\")")
      cmds2 = paste0("colnames(", ind[i],") = ", ind[i] ,"cn")
      cmds3 = paste0(ind[i])
      eval.cmds1 = eval(parse(text = cmds1))
      assign(ind[i], eval.cmds1)
      eval(parse(text = cmds2))
      eval.cmds3 = eval(parse(text = cmds3))
      assign(ind[i], eval.cmds3, env =.GlobalEnv)
    }
  }
  selesqltb(keydfn)
  

  
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
           "資訊管理系 - 2008" = im08, "資訊管理系 - 2009" = im09, "資訊管理系 - 2010" = im10, "資訊管理系 - 2011" = im11, "資訊管理系 - 2012" = im12, 
           "資訊管理系 - 2013" = im13, "資訊管理系 - 2014" = im14, "資訊管理系 - 2015" = im15,
           "企業管理系 - 2008" = bu08, "企業管理系 - 2009" = bu09, "企業管理系 - 2010" = bu10, "企業管理系 - 2011" = bu11, "企業管理系 - 2012" = bu12, 
           "企業管理系 - 2013" = bu13, "企業管理系 - 2014" = bu14, "企業管理系 - 2015" = bu15,
           "財務金融系 - 2008" = fi08, "財務金融系 - 2009" = fi09, "財務金融系 - 2010" = fi10, "財務金融系 - 2011" = fi11, "財務金融系 - 2012" = fi12, 
           "財務金融系 - 2013" = fi13, "財務金融系 - 2014" = fi14, "財務金融系 - 2015" = fi15,
           "國際企業系 - 2008" = ib08, "國際企業系 - 2009" = ib09, "國際企業系 - 2010" = ib10, "國際企業系 - 2011" = ib11, "國際企業系 - 2012" = ib12, 
           "國際企業系 - 2013" = ib13, "國際企業系 - 2014" = ib14, "國際企業系 - 2015" = ib15,
           "工業管理系 - 2008" = id08, "工業管理系 - 2009" = id09, "工業管理系 - 2010" = id10, "工業管理系 - 2011" = id11, "工業管理系 - 2012" = id12, 
           "工業管理系 - 2013" = id13, "工業管理系 - 2014" = id14, "工業管理系 - 2015" = id15

    )
  })
  
  # CV
  
  
  # Setting
  
  output$alldtscolnm = renderPrint({
    colnames(tmsp$cudf)
  })
  
  output$pcselt = renderPrint({
    tmsp$pkb = paste0( "c(", input$pchoser, ")")
    cat(tmsp$pkb)
  })
  
  output$cbcselt = renderPrint({
    tmsp$cbase = paste0( "c(", input$cbchoser, ")")
    cat(tmsp$cbase)
  })
  
  # Cluster
  
  
  output$cluplot = renderPlot({
    hcaon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
  })
  
 # output$clutable = renderTable({
   # hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
   # untavt
  #}) 
  output$clutable = DT::renderDataTable({
    hcaon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    DT::datatable(untavt,options = list(pageLength = 25))
  })
  
  # Summary
  
  output$sumytable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    untal2ndsc
  }) 
  
  # Analysis
  output$anaytable = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    unttkav
  })  
  
  # SLoan
  
  output$hsloandt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    untln1dsc
  })
  
  output$nsloandt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    untln0dsc
  })  
  
  # Propotion
  output$pptndt = renderTable({
    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
    untslon
  })  
  
  output$prosloan = renderPlot({
    
    tmsp$slone1 = data.frame(club = untslon$club, type = rep("slon"), data = untslon$slon)
    tmsp$slone2 = data.frame(club = untslon$club, type = rep("no.slon"), data = untslon$no.slon)
    tmsp$slone3 = data.frame(club = untslon$club, type = rep("total"), data = untslon$total)
    tmsp$slonae = rbind( tmsp$slone1, tmsp$slone2, tmsp$slone3)
    ggplot(data = tmsp$slonae, mapping = aes(club,data, fill = type)) + geom_bar(stat = 'identity', position = 'dodge') + 
      geom_text(mapping = aes(label = data), size = 5, colour = 'black', vjust = 1, hjust = .5, position = position_dodge(1)) + labs( title = "分群就貸比")
  })
  
  # Diagram
  output$spbt1vto = renderPrint({
    tmsp$spbtxt1 = paste0( "c(", input$spbtxt1, ")")
    cat(tmsp$spbtxt1)
  })
  
  output$spbt2vto = renderPrint({
    tmsp$spbtxt2 = paste0( "c(", input$spbtxt2, ")")
    cat(tmsp$spbtxt2)
  })
  
  output$mpb1vto = renderPrint({
    tmsp$mpbtxt1 = paste0( "c(", input$mpbtxt1, ")")
    cat(tmsp$mpbtxt1)
  })
  
  output$mpb2vto = renderPrint({
    tmsp$mpbtxt2 = paste0( "c(", input$mpbtxt2, ")")
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
  
  output$alldtscolnm3 = renderPrint({
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


