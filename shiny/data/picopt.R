# pic output
picopt = function( objpic, picna, piclas = "png", picw = 1920, pich = 962, swd = getwd(),....){
	setold = getwd()
	setwd(swd)
	picbase = c( "png", "bmp", "jpeg", "tiff")
	dirseh = dir()
	sdc = as.character(Sys.time())
	sdc1t = gsub( ":", " ", sdc)
	sdc2t = gsub( "-", " ", sdc1t)
	sdc3t = paste(strsplit( sdc2t ,split = " ", fixed = T)[[1]],collapse="")
	s2pt = strsplit( picna ,split=".",fixed=T)
	picnahd = paste0( s2pt[[1]][1], "_", sdc3t, ".", s2pt[[1]][2]) 

	if(s2pt[[1]][2] == piclas){

		if( length(which(picna == dirseh)) > 0){
			if( piclas == picbase[1]){
				png( filename = picnahd, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[2]){
				bmp( filename = picnahd, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[3]){
				jpeg( filename = picnahd, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[4]){
				tiff( filename = picnahd, width = picw, height = pich)
					objpic
				dev.off()
			}else{
				message("Error")
			}
		}else{
			if( piclas == picbase[1]){
				png( filename = picna, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[2]){
				bmp( filename = picna, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[3]){
				jpeg( filename = picna, width = picw, height = pich)
					objpic
				dev.off()
			}else if( piclas == picbase[4]){
				tiff( filename = picna, width = picw, height = pich)
					objpic
				dev.off()
			}else{
				message("Error")
			}
		}
	}else{
			message("Error")
	}
			setwd(setold)
}

# ggplot2 package pic output
gpot = function( objpic, picna, piclas = "png", picw = 1920, pich = 962, swd = getwd(),....){
	setold = getwd()
	setwd(swd)
	picbase = c( "png", "bmp", "jpeg", "tiff")
	dirseh = dir()
	sdc = as.character(Sys.time())
	sdc1t = gsub( ":", " ", sdc)
	sdc2t = gsub( "-", " ", sdc1t)
	sdc3t = paste(strsplit( sdc2t ,split = " ", fixed = T)[[1]],collapse="")
	s2pt = strsplit( picna ,split=".",fixed=T)
	picnahd = paste0( s2pt[[1]][1], "_", sdc3t, ".", s2pt[[1]][2]) 

	if(s2pt[[1]][2] == piclas){

		if( length(which(picna == dirseh)) > 0){
			if( piclas == picbase[1]){
				png( filename = picnahd, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[2]){
				bmp( filename = picnahd, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[3]){
				jpeg( filename = picnahd, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[4]){
				tiff( filename = picnahd, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else{
				message("Error")
			}
		}else{
			if( piclas == picbase[1]){
				png( filename = picna, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[2]){
				bmp( filename = picna, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[3]){
				jpeg( filename = picna, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else if( piclas == picbase[4]){
				tiff( filename = picna, width = picw, height = pich)
					print(objpic)
				dev.off()
			}else{
				message("Error")
			}
		}
	}else{
			message("Error")
	}
			setwd(setold)
}