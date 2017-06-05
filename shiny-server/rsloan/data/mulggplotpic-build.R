# HCA Multiple ggplot proc

sg2proc = function( dft = "untavt", midx, cidx){

	for( snm in 1:length(cidx)){
		s.nm = paste0( dft, ".", "gmp")	
		s.cmdr = paste0( "ggplot(", dft, 
		") + geom_point( alpha = 0.5, size = 3, aes(x = ", 
		midx, ", y = ", cidx[snm], 
		", colour = factor(hcadata) )) + facet_grid( ~ loam) + scale_colour_hue( l = 50 ) + ",
		"geom_text( check_overlap = TRUE, angle = 45, aes( x = ", midx, " + 1, y = ", cidx[snm], " + 1, label = bnm))")
		s.eval = eval(parse(text = s.cmdr))
		assign( s.nm, s.eval, env = .GlobalEnv)
	}

}

sg2proc2 = function( dft = "untavt", midx, cidx){
  for( snm in 1:length(cidx)){
    s.nm = paste0( dft, ".", "gmp2")	
    s.cmdr = paste0( "ggplot(", dft, 
                     ") + geom_point( alpha = 0.5, size = 3, aes(x = ", 
                     midx, ", y = ", cidx[snm], 
                     ", colour = factor(hcadata) )) + facet_grid( ~ loam) ")
    s.eval = eval(parse(text = s.cmdr))
    assign( s.nm, s.eval, env = .GlobalEnv)
  }
}

mg2proc = function( dft = "untavt", midx, cidx){

	mupnbid = trunc(sqrt(length(cidx))) + 1 
	mupobjnm = vector(mode = "character", length = 0)
	mup.head.c = "multiplot( "
	mup.tail.c = paste0(" cols = ", mupnbid, " )")

	for( snm in 1:length(cidx)){

		s.nm = paste0( dft, ".", cidx[snm], ".", "gmp")	
		s.cmdr = paste0( "ggplot(", dft, 
		") + geom_point( alpha = 0.5, aes(x = ", 
		midx, ", y = ", cidx[snm], 
		", colour = factor(hcadata) )) + facet_grid( ~ loam) + scale_colour_hue( l = 50 )")
		mupobjnm = paste0( mupobjnm, s.nm,", ")
		s.eval = eval(parse(text = s.cmdr))
		assign(s.nm, s.eval)
	}
		mupw.nm = paste0( dft, ".","mulgmp")
		mupw.cmdr = paste0( mup.head.c, mupobjnm, mup.tail.c)
		mupw.eval = eval(parse(text = mupw.cmdr))
		assign( mupw.nm,
			mupw.eval,
		env = .GlobalEnv)
}

eachsg2proc = function( dft = "untavt", midx, cidx){
  
  for( snm in 1:length(cidx)){
    s.nm = paste0( dft, ".", "egmp")	
    s.cmdr = paste0( "ggplot(", dft, 
                     ") + geom_point( alpha = 0.5, size = 3, aes(x = ", 
                     midx, ", y = ", cidx[snm], 
                     ", colour = factor(hcadata) )) + facet_grid( ~ loam) + scale_colour_hue( l = 50 ) + ",
                     "geom_text( check_overlap = TRUE, angle = 45, aes( x = ", midx, " + 1, y = ", cidx[snm], " + 1, label = bnm))")
    s.eval = eval(parse(text = s.cmdr))
    assign( s.nm, s.eval, env = .GlobalEnv)
  }
  
}

eachsg2proc2 = function( dft = "untavt", midx, cidx){
  for( snm in 1:length(cidx)){
    s.nm = paste0( dft, ".", "egmp2")	
    s.cmdr = paste0( "ggplot(", dft, 
                     ") + geom_point( alpha = 0.5, size = 3, aes(x = ", 
                     midx, ", y = ", cidx[snm], 
                     ", colour = factor(hcadata) )) + facet_grid( ~ loam) ")
    s.eval = eval(parse(text = s.cmdr))
    assign( s.nm, s.eval, env = .GlobalEnv)
  }
}

eachmg2proc = function( dft = "untavt", midx, cidx){
  
  mupnbid = trunc(sqrt(length(cidx))) + 1 
  mupobjnm = vector(mode = "character", length = 0)
  mup.head.c = "multiplot( "
  mup.tail.c = paste0(" cols = ", mupnbid, " )")
  
  for( snm in 1:length(cidx)){
    
    s.nm = paste0( dft, ".", cidx[snm], ".", "gmp")	
    s.cmdr = paste0( "ggplot(", dft, 
                     ") + geom_point( alpha = 0.5, aes(x = ", 
                     midx, ", y = ", cidx[snm], 
                     ", colour = factor(hcadata) ))  + facet_grid( ~ loam) + scale_colour_hue( l = 50 )")
    mupobjnm = paste0( mupobjnm, s.nm,", ")
    s.eval = eval(parse(text = s.cmdr))
    assign(s.nm, s.eval)
  }
  mupw.nm = paste0( dft, ".","mulgmp")
  mupw.cmdr = paste0( mup.head.c, mupobjnm, mup.tail.c)
  mupw.eval = eval(parse(text = mupw.cmdr))
  assign( mupw.nm,
          mupw.eval,
          env = .GlobalEnv)
}
