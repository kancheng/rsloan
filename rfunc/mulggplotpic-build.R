# HCA Multiple ggplot proc

sg2proc = function( dft, midx, cidx, lbobj){

	for( snm in 1:length(cidx)){
		# 抓欄位定義
		# 建立對應 ggplot2 label df 物件
		lbobj.nm = paste0(lbobj,"ldta")

		# 產生 label df cmd
		lbobj.cmdr = paste0(lbobj, "[", lbobj , "$subj == \"", cidx[snm],"\", ]")

		# 執行 label df cmd
		lbobj.eval = eval(parse(text = lbobj.cmdr))

		# 建立物件 by 區域
		assign( lbobj.nm, lbobj.eval )

		# 產生 ggplot2 object name
		s.nm = paste0( dft, ".", cidx[snm], ".", "gmp")	

		# 產生 ggplot2 cmd
		s.cmdr = paste0( "ggplot(", dft, 
		") + geom_point( aes(x = ", 
		midx, ", y = ", cidx[snm], 
		", colour = factor(hcadata) )) + facet_grid( ~ loam) + labs( title = \"", 
		lbobj.eval$sdas, " ", lbobj.eval$subd, " ", lbobj.eval$grade, "\" ) + scale_colour_hue( l = 50 ) + ",
		"geom_text( check_overlap = TRUE, angle = 45, aes( x = ", midx, " + 1, y = ", cidx[snm], " + 1, label = bnm))")

		# 執行 ggplot2 cmd
		s.eval = eval(parse(text = s.cmdr))

		# 建立 ggplot2 物件 by 全域
		assign( s.nm, s.eval, env = .GlobalEnv)

	}

}

mg2proc = function( dft, midx, cidx, lbobj){

	mupnbid = trunc(sqrt(length(cidx))) + 1 
	mupobjnm = vector(mode = "character", length = 0)
	mup.head.c = "multiplot( "
	mup.tail.c = paste0(" cols = ", mupnbid, " )")
	for( snm in 1:length(cidx)){
		# 抓欄位定義
		# 建立對應 ggplot2 label df 物件
		lbobj.nm = paste0(lbobj,"ldta")

		# 產生 label df cmd
		lbobj.cmdr = paste0(lbobj, "[", lbobj , "$subj == \"", cidx[snm],"\", ]")

		# 執行 label df cmd
		lbobj.eval = eval(parse(text = lbobj.cmdr))

		# 建立物件 by 區域
		assign( lbobj.nm, lbobj.eval )

		# 產生 ggplot2 object name
		s.nm = paste0( dft, ".", cidx[snm], ".", "gmp")	

		# 產生 ggplot2 cmd
		s.cmdr = paste0( "ggplot(", dft, 
		") + geom_point( aes(x = ", 
		midx, ", y = ", cidx[snm], 
		", colour = factor(hcadata) )) + facet_grid( ~ loam) + labs( title = \"", 
		lbobj.eval$sdas, " ", lbobj.eval$subd, " ", lbobj.eval$grade, "\" ) + scale_colour_hue( l = 50 )")

		mupobjnm = paste0( mupobjnm, s.nm,", ")

		# 執行 ggplot2 cmd
		s.eval = eval(parse(text = s.cmdr))
		# 建立 ggplot2 物件 by 全域
		assign(s.nm, s.eval)
	}
		mupw.nm = paste0( dft, ".","mulgmp")
		mupw.cmdr = paste0( mup.head.c, mupobjnm, mup.tail.c)
		mupw.eval = eval(parse(text = mupw.cmdr))
		assign( mupw.nm,
			mupw.eval,
		env = .GlobalEnv)
}