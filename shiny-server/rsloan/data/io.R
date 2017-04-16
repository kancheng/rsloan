# input csv data.frame
rcsvdf = function( csvph = paste0( getwd(), "/") ){
	asltdf = function(dliob){
		baselist = vector( mode = "list", length = 1)
		cblt = class(baselist)
		objhd = class(dliob)
		if( cblt == objhd){
			dfnm = names(dliob)
			assnum = as.numeric(length(dliob))
				for( i in 1:assnum){
					assign(dfnm[i], dliob[[i]], env = .GlobalEnv)
				}
		}
	}
	cvtfs = length(csvph)
	if( str_sub(string = csvph, start = cvtfs ,end = cvtfs)  ==  "/" ){

		csvfsn = list.files( path = csvph, pattern = "*.csv")
		ipln = gsub( ".csv", "", csvfsn)

		tmprt = function(rtcsv){
			read.csv( rtcsv, stringsAsFactors = FALSE)
		}

		iptd = lapply(paste(csvph,csvfsn, sep = ""), tmprt)
		names(iptd) = ipln
		iptd
		asltdf(iptd)
	}else{

		csvph = paste0( csvph, "/")

		csvfsn = list.files( path = csvph, pattern = "*.csv")
		ipln = gsub( ".csv", "", csvfsn)

		tmprt = function(rtcsv){
			read.csv( rtcsv, stringsAsFactors = FALSE)
		}

		iptd = lapply(paste(csvph,csvfsn, sep = ""), tmprt)
		names(iptd) = ipln
		asltdf(iptd)
	}
}

# input csv list
rcsvlt = function( csvph = paste0( getwd(), "/") ){
	cvtfs = length(csvph)
	if( str_sub(string = csvph, start = cvtfs ,end = cvtfs)  ==  "/" ){

		csvfsn = list.files( path = csvph, pattern = "*.csv")
		ipln = gsub( ".csv", "", csvfsn)

		tmprt = function(rtcsv){
			read.csv( rtcsv, stringsAsFactors = FALSE)
		}

		iptd = lapply(paste(csvph,csvfsn, sep = ""), tmprt)
		names(iptd) = ipln
		iptd
	}else{

		csvph = paste0( csvph, "/")

		csvfsn = list.files( path = csvph, pattern = "*.csv")
		ipln = gsub( ".csv", "", csvfsn)

		tmprt = function(rtcsv){
			read.csv( rtcsv, stringsAsFactors = FALSE)
		}

		iptd = lapply(paste(csvph,csvfsn, sep = ""), tmprt)
		names(iptd) = ipln
		iptd
	}
}

# data.frame output csv
wrta = function(xdo , ycsv, swd = getwd()){
setold = getwd()
setwd(swd)
	dirseh = dir()

	if( length(which(ycsv == dirseh)) > 0){
		sdc = as.character(Sys.time())
		sdc1t = gsub( ":", " ", sdc)
		sdc2t = gsub( "-", " ", sdc1t)
		sdc3t = paste(strsplit( sdc2t ,split = " ", fixed = T)[[1]],collapse="")
		s2pt = strsplit( ycsv ,split=".",fixed=T)
		ycsvhd = paste0( s2pt[[1]][1], "_", sdc3t, ".", s2pt[[1]][2]) 
		write.table( xdo, file= ycsvhd, quote = FALSE, sep = ",", row.names = FALSE)
	}else{
		write.table( xdo, file= ycsv, quote = FALSE, sep = ",", row.names = FALSE)
	}

setwd(setold)
}
