set.seed(929)

library(plotly)
library(shiny)
library(RMySQL)
library(ggplot2)
library(rmarkdown)
library("clValid")
library("DT")

require(cluster)
require(useful)

# SERVER R File & Object

function(input, output, session) {
  
  # tem
  tmsp = reactiveValues()
  
  # source r file

  # R Kan Dev Function IO
  source("./data/io.R")
  
  # R Kan Dev Function HCA
  source("./data/hca.R")
  
  # R Multiple graphs on one page 
  source("./data/mulggplotpic.R")
  
  # R Kan Dev Function AS Class & Head List
  source("./data/ashd.R")
  
  # R Kan Dev Function Pic Opt
  source("./data/picopt.R")
  
  # R Kan Dev Function HCA
  source("./data/hcaon.R")
  
  # R Kan Dev Function KMC
  source("./data/kmon.R")
  
  # R Kan Dev Function PAMC
  source("./data/pamon.R")
  
  # R Multiple graphs build object
  source("./data/mulggplotpic-build.R")
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
  
  #  Setting - clValid
  
  cvplot = function( cvdfobj, cvdfcolobj, cvpkdfobj){
    
    basedf = cvdfobj[ ,cvdfcolobj]
    # rownames(basedf) = im08$cvpkdfobj
    
    stab.basedf = clValid(basedf, 2:6, clMethods = c("hierarchical","kmeans","pam"), validation = "stability")
    
    ## summary(stab.basedf)
    par( mfrow = c( 2, 2))
    plot( stab.basedf, legend = FALSE)
  }
  cvsummary = function( cvdfobj, cvdfcolobj, cvpkdfobj){
    
    basedf = cvdfobj[ ,cvdfcolobj]
    # rownames(basedf) = im08$cvpkdfobj
    
    stab.basedf = clValid(basedf, 2:6, clMethods = c("hierarchical","kmeans","pam"), validation = "stability")
    
    summary(stab.basedf)
  }
  
  output$clValidplot = renderPlot({
    cvplot(tmsp$cudf,  eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
  })
  
  output$clValidSummary = renderPrint({
    cvsummary(tmsp$cudf,  eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)))
  })
  
  
  # Cluster
  
  output$cluplot = renderPlot({
    
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                        },
                        
                        kmcrb2 = {
                          kmon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                        },
                        
                        pamrb3 = {
                          pamon2(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                        }
    )
    
  })

  
# 原始的表格檢視
#  output$clutable = renderTable({
#    hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
#    untavt
#  })
  
  # use renderDataTable
  output$clutable = DT::renderDataTable({
    
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temuntavt = untavt
                          DT::datatable(untavt, options = list(pageLength = 25))
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temuntavt = untavt
                          DT::datatable(untavt, options = list(pageLength = 25))
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temuntavt = untavt
                          DT::datatable(untavt, options = list(pageLength = 25))
                        }
    )

  })
  
  # clutable download 
  
  output$clutabledl = downloadHandler(
    filename = function() { 
      paste( "untavt", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temuntavt, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  
  # Summary

  output$sumytable = renderDataTable({
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temuntal2ndsc = untal2ndsc
                          DT::datatable( untal2ndsc, options = list(pageLength = 25))
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temuntal2ndsc = untal2ndsc
                          DT::datatable( untal2ndsc, options = list(pageLength = 25))
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temuntal2ndsc = untal2ndsc
                          DT::datatable( untal2ndsc, options = list(pageLength = 25))
                        }
    )
  }) 
  
  # sumytable download 
  
  output$sumytabledl = downloadHandler(
    filename = function() { 
      paste( "untal2ndsc", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temuntal2ndsc, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  
  # Summary Plot
  
  summaryplot = function( sycol, sydfobj){
    sydfobj = sydfobj[sydfobj$subj == sycol, ]
    sydfobj$mean = round( sydfobj$mean,digits = 2)
    sydfobj
  }
  
  
  output$sumyeach = renderTable({
    tmsp$temsumyplotcol = input$sumyplotcol
    tmsp$temsumyplotdt = summaryplot(eval(parse(text = tmsp$temsumyplotcol)), tmsp$temuntal2ndsc)
    tmsp$temsumyplotdt
  })
  
  output$sumyeachplot = renderPlot({
    
  ggplot(tmsp$temsumyplotdt, aes( club, mean, fill = subj)) + geom_bar(stat="identity",position='dodge') + 
  geom_text(mapping = aes(label = mean), size = 5, colour = 'black', vjust = 1, hjust = .5, position = position_dodge(1)) + 
  labs( title = tmsp$temsumyplotcol)
    
  })


  # Analysis
  
  output$anaytable = renderDataTable({
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temunttkav = unttkav
                          DT::datatable( unttkav, options = list(pageLength = 25))
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temunttkav = unttkav
                          DT::datatable( unttkav, options = list(pageLength = 25))
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temunttkav = unttkav
                          DT::datatable( unttkav, options = list(pageLength = 25))
                        }
    )
  })  
  
  # anaytable download 
  
  output$anaytabledl = downloadHandler(
    filename = function() { 
      paste( "unttkav", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temunttkav, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  
  
  # SLoan
  
  output$hsloandt = renderDataTable({
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temuntln1dsc = untln1dsc
                          DT::datatable( untln1dsc, options = list(pageLength = 25))
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temuntln1dsc = untln1dsc
                          DT::datatable( untln1dsc, options = list(pageLength = 25))
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temuntln1dsc = untln1dsc
                          DT::datatable( untln1dsc, options = list(pageLength = 25))
                        }
    )
  })
  
  output$nsloandt = renderDataTable({
    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temuntln0dsc = untln0dsc
                          DT::datatable( untln0dsc, options = list(pageLength = 25))
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temuntln0dsc = untln0dsc
                          DT::datatable( untln0dsc, options = list(pageLength = 25))
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temuntln0dsc = untln0dsc
                          DT::datatable( untln0dsc, options = list(pageLength = 25))
                        }
    )
    
    
  })  
  
  # hsloandt download 
  
  output$hsloandtdl = downloadHandler(
    filename = function() { 
      paste( "untln1dsc", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temuntln1dsc, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  
  # Have SLoan Plot
  
  output$hsleach = renderTable({
    tmsp$temhslplotcol = input$hslplotcol
    tmsp$temhslplotdt = summaryplot(eval(parse(text = tmsp$temhslplotcol)), tmsp$temuntln1dsc)
    tmsp$temhslplotdt
  })
  
  output$hsleachplot = renderPlot({
    
    ggplot( tmsp$temhslplotdt, aes( club, mean, fill = subj)) + geom_bar(stat="identity",position='dodge') + 
      geom_text(mapping = aes(label = mean), size = 5, colour = 'black', vjust = 1, hjust = .5, position = position_dodge(1)) + 
      labs( title = tmsp$temhslplotcol)
    
  })
  
  
  # nsloandt download 
  
  output$nsloandtdl = downloadHandler(
    filename = function() { 
      paste( "untln0dsc", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temuntln0dsc, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  
  # Not SLoan Plot
  
  output$nsleach = renderTable({
    tmsp$temnslplotcol = input$nslplotcol
    tmsp$temnslplotdt = summaryplot(eval(parse(text = tmsp$temnslplotcol)), tmsp$temuntln0dsc)
    tmsp$temnslplotdt
  })
  
  output$nsleachplot = renderPlot({
    
    ggplot( tmsp$temnslplotdt, aes( club, mean, fill = subj)) + geom_bar(stat="identity",position='dodge') + 
      geom_text(mapping = aes(label = mean), size = 5, colour = 'black', vjust = 1, hjust = .5, position = position_dodge(1)) + 
      labs( title = tmsp$temnslplotcol)
    
  })

  
  # Propotion
  output$pptndt = renderTable({

    allcluswmd = switch(input$allclurbmd,
                        
                        hcarb1 = {
                          hcaon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), hck = input$clunmtb, hcm = input$hclust.methods, dism = input$dist.methods)
                          tmsp$temuntslon = untslon
                        },
                        
                        kmcrb2 = {
                          kmon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), kc = input$clunmtb, knstart = input$knstartnum )
                          tmsp$temuntslon = untslon
                        },
                        
                        pamrb3 = {
                          pamon(tmsp$cudf, eval(parse(text = tmsp$cbase)), eval(parse(text = tmsp$pkb)), pamkc = input$clunmtb)
                          tmsp$temuntslon = untslon
                        }
    )
  })  
  
  # pptndt download 
  output$pptndtdl = downloadHandler(
    filename = function() { 
      paste( "untslon", '.csv', sep = '') 
    },
    content = function(file) {
      write.csv(tmsp$temuntslon, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
  

  
  
  output$prosloan3 = renderPlot({
    
    tmsp$lrdata = round(as.numeric(as.character(untslon$slon)) / as.numeric(as.character(untslon$total)),4)
    tmsp$lrclub = as.character(untslon$club)
    tmsp$lrtest = data.frame( data = tmsp$lrdata, club = tmsp$lrclub)
    tmsp$lrtest2 = ggplot(data = tmsp$lrtest, mapping = aes(club, data ,fill = club )) + geom_bar(stat = 'identity', position = 'stack') + labs( title = "就貸比例") + 
      geom_text(mapping = aes(label = data), size = 5, colour = 'black', vjust = 1.5, hjust = .5, position = position_stack())
    
    tmsp$slone11 = data.frame(club = as.character(untslon$club), 
                              type = as.character(rep("slon")), data = as.numeric(as.character(tmsp$temuntslon$slon)))
    
    tmsp$slone12 = data.frame(club = as.character(untslon$club), 
                              type = as.character(rep("no.slon")), data = as.numeric(as.character(tmsp$temuntslon$no.slon)))
    
    tmsp$slone13 = data.frame(club = as.character(untslon$club), 
                              type = as.character(rep("total")), data = as.numeric(as.character(tmsp$temuntslon$total)))
    
    tmsp$slone21 = data.frame(club = as.character(untslon$club), 
                              type = as.character(rep("slon")), data = as.numeric(as.character(tmsp$temuntslon$slon)))
    
    tmsp$slone22 = data.frame(club = as.character(untslon$club), 
                              type = as.character(rep("no.slon")), data = as.numeric(as.character(tmsp$temuntslon$no.slon)))
    
    tmsp$slonae = rbind( tmsp$slone11, tmsp$slone12, tmsp$slone13)
    tmsp$temae = ggplot(data = tmsp$slonae, mapping = aes( club, data, fill = type)) + geom_bar(stat = 'identity', position = 'dodge') + 
      geom_text(mapping = aes(label = data), size = 5, colour = 'black', vjust = 1, hjust = .5, position = position_dodge(1)) + labs( title = "分群比")
    
    tmsp$slonae2 = rbind( tmsp$slone21, tmsp$slone22)
    tmsp$temae2 = ggplot(data = tmsp$slonae2, mapping = aes(club,data, fill = type)) + geom_bar(stat = 'identity', position = 'stack') + 
      labs( title = "就貸人數") + geom_text(mapping = aes(label = data), size = 5, colour = 'black', vjust = 1.5, hjust = .5, position = position_stack())
    
    require(grid)
    # Move to a new page
    grid.newpage()
    # Create layout : nrow = 2, ncol = 2
    pushViewport(viewport(layout = grid.layout(2, 2)))
    # pushViewport(viewport(layout = grid.layout(1, 2)))
    # A helper function to define a region on the layout
    define_region = function(row, col){
      viewport(layout.pos.row = row, layout.pos.col = col)
    } 
    
    print(tmsp$temae, vp = define_region(1, 1))
    print(tmsp$temae2, vp = define_region(1, 2))
    print(tmsp$lrtest2, vp = define_region(2, 1:2))

  })
  

  
  output$prosloan = renderPlot({

    tmsp$temae

  })
  
  output$prosloan2 = renderPlot({
    
    tmsp$temae2
    
  })
  
  output$temloanrate = renderPlot({
  # tmsp$lrdata = round(as.numeric(as.character(untslon$slon)) / as.numeric(as.character(untslon$total)),4)
  #  tmsp$lrclub = as.character(untslon$club)
  #  tmsp$lrtest = data.frame( data = tmsp$lrdata, club = tmsp$lrclub)
  #  tmsp$lrtest2 = ggplot(data = tmsp$lrtest, mapping = aes(club, data ,fill = club )) + geom_bar(stat = 'identity', position = 'stack') + labs( title = "就貸比例") + 
  #    geom_text(mapping = aes(label = data), size = 5, colour = 'black', vjust = 1.5, hjust = .5, position = position_stack())
    tmsp$lrtest2
    
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
  
  output$singplot2 = renderPlot({
    tmsp$evalspbtxt1 = eval(parse(text = tmsp$spbtxt1))
    tmsp$evalspbtxt2 = eval(parse(text = tmsp$spbtxt2))
    tmsp$shspic  = sg2proc2("untavt", tmsp$evalspbtxt1, tmsp$evalspbtxt2)
    untavt.gmp2
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
      write.csv(demo, file = file, quote = FALSE, sep = ",", row.names = FALSE)
    }
  )
}


