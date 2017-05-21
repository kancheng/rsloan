kmon = function( Odata, beky, keycol, kc = 6, knstart = 25,
	dtname = "unt", swd = getwd(),...){

	temkc = kc
	temknstart = knstart

	serna = function( data, beky, keycol){
		tdfnm = rep(1:nrow(data))
		pkb = data[ , keycol]
		temdf = data.frame( bnm = tdfnm, bpk = pkb)
		hcabd = data[ , beky]
		nap = vector( mode = "character", length = 0)
		for( i in 1:NCOL(hcabd)) {
			nam = paste0("base", i, ".", beky[i])
			nap = c( nap, nam)
		}
		names(hcabd) = nap
		hcal2d = cbind( temdf, hcabd)
		hcal2d
	}

# KMC Data DF IN
	data = serna( Odata, beky, keycol)
	dhdc = data[ , -c(1, 2)]
	kmcal = kmeans( x = dhdc, center = temkc, nstart = temknstart)
	hcadata = kmcal$cluster


# KMC pic
#	piophdn = paste0( dtname, ".png")
#	hcadpic( hcdata = dhdc, hck = hcktem, hcm = hcmtem, dism = dismtem)

# KMC Data DF OUT
	hcad2 = cbind(data,hcadata)
	hcbsdtnm = paste0("hcbs", dtname)
	assign( hcbsdtnm, 
		hcad2
	, env = .GlobalEnv)

# Cluster DF Cut
	hchartem = vector(mode = "character", length = 0)
	for(i in 1:kc) {
		nam = paste0("hc", i, dtname)
		hchartem = c( hchartem, nam)
		temhc = hcad2[hcad2$hcadata == i, ]$bpk
		temodt = Odata$sid
		assign( nam, 
		Odata[ which( temodt %in% temhc), ]
		, env = .GlobalEnv)
	}

# TukeyHSD & ANOVA Base Data
	hcbsdtavtna = paste0(dtname,"avt")
	hcbsdtavtem = merge( hcad2, Odata, by.x = "bpk", by.y = "sid", all = TRUE)
	assign( hcbsdtavtna,
		hcbsdtavtem
	, env = .GlobalEnv)

# TukeyHSD & ANOVA CSV process

	optkavtm =  data.frame( tsnm = character(), 
		term = character(), 
		comparison = character(), 
		estimate = numeric(), 
		conf.low = numeric(), 
		conf.high = numeric(), 
		adj.p.value = numeric())
	tukavpc = which(c("sid","loam")%in% names(Odata))
	tukavtm = Odata[ , -tukavpc]
	alalt = as.list(tukavtm)
	tarname  = colnames(tukavtm)

	# Factor process
	tmtkab = factor(hcad2$hcadata)

	# Merge DF process
	for( j in 1:ncol(tukavtm)){
		temdf  = tidy ( TukeyHSD(aov( alalt[[j]] ~ tmtkab ) , "tmtkab"))
		temdf  = cbind( tsnm = rep(tarname[j]) ,temdf)
		optkavtm = rbind(optkavtm, temdf) 
	}
	tuacsvopn = paste0(dtname,"tkav")
	assign( tuacsvopn,
		optkavtm
	, env = .GlobalEnv)

# The Descriptive Statistics of each Cluster

		dscdf = Odata[,-which( c("sid","loam")%in% names(Odata))]
		dscpkycol = names(dscdf)
	for(dscnm in 1:2){
		loanstatus = c(0,1)
		eckallds =  data.frame( 
		subj = character(), club = character(), slon = numeric(), 
		minimum = numeric(), q1 = numeric(), median = numeric(), 
		mean = numeric(), q3 = numeric(), maximum = numeric(), 
		na = numeric(), sd = numeric())

		for(ecnum in 1:length(dscpkycol)){
			temcsdf =  data.frame( 
				subj = character(), club = character(), slon = numeric(), 
				minimum = numeric(), q1 = numeric(), median = numeric(), 
				mean = numeric(), q3 = numeric(), maximum = numeric(), 
				na = numeric(), sd = numeric())
				dscfprc.col = dscpkycol[ecnum]

			for( dsclunb in 1:kc){
				tarsut = paste0("Clu.", dsclunb)
				dsc.commands = paste0( hchartem[dsclunb],"[",hchartem[dsclunb], "$loam == ", loanstatus[dscnm], ",]", "$", dscfprc.col)
				dsctemd = eval(parse(text = dsc.commands))
				temsummary = tidy(summary( dsctemd, na.rm = TRUE))
				temsd = sd( dsctemd, na.rm = TRUE)
				ecopthd = cbind( subj = dscfprc.col, club = tarsut, slon = loanstatus[dscnm], temsummary, sd = temsd)
				temcsdf = rbind(temcsdf,ecopthd)
			}
		eckallds = rbind(eckallds, temcsdf)
		}

		dscnach = paste0(dtname,"ln", loanstatus[dscnm],"dsc")
		assign( dscnach,
			eckallds
		, env = .GlobalEnv)
	}

# Number of Student Loans
	slonbsdf = data.frame( dtna = character(), club = character(), 
			slon = numeric(), no.slon = numeric(), 
			total = numeric())

	for( slon2b in 1:kc){
		slonclut = paste0("Clu.", slon2b)
		slon.commands = paste0( "NROW(", hchartem[slon2b],"[",hchartem[slon2b],"$loam == 1, ]", ")" )
		noslon.commands = paste0( "NROW(",hchartem[slon2b],"[",hchartem[slon2b],"$loam == 0, ]", ")" )
		total.commands = paste0( "NROW(", hchartem[slon2b], ")" )
		slon.evalp = eval(parse(text = slon.commands))
		noslon.evalp = eval(parse(text = noslon.commands))
		total.evalp = eval(parse(text = total.commands))
		slontmhd = cbind( dtna = dtname, club = slonclut, slon = slon.evalp, no.slon = noslon.evalp, total = total.evalp)
		slonbsdf = rbind( slonbsdf, slontmhd)
	}
	slonaopc = paste0(dtname,"slon")
		assign( slonaopc,
			slonbsdf
		, env = .GlobalEnv)

# The Descriptive Statistics of each Cluster
# no Student loans condition

		dscdf = Odata[,-which( c("sid","loam")%in% names(Odata))]
		dscpkycol = names(dscdf)
		eckallds =  data.frame( 
		subj = character(), club = character(), minimum = numeric(), 
		q1 = numeric(), median = numeric(), mean = numeric(), 
		q3 = numeric(), maximum = numeric(), 
		na = numeric(), sd = numeric())

		for(ecnum in 1:length(dscpkycol)){
			temcsdf =  data.frame( 
				subj = character(), club = character(), slon = numeric(), 
				minimum = numeric(), q1 = numeric(), median = numeric(), 
				mean = numeric(), q3 = numeric(), maximum = numeric(), 
				na = numeric(), sd = numeric())
				dscfprc.col = dscpkycol[ecnum]

			for( dsclunb in 1:kc){
				tarsut = paste0("Clu.", dsclunb)
				dsc.commands2 = paste0(hchartem[dsclunb],"$",dscpkycol[ecnum])
				dscfprc.data = eval(parse(text = dsc.commands2))
				temsummary = tidy(summary( dscfprc.data, na.rm = TRUE))
				temsd = sd( dscfprc.data, na.rm = TRUE)
				ecopthd = cbind( subj = dscfprc.col, club = tarsut, temsummary, sd = temsd)
				temcsdf = rbind(temcsdf,ecopthd)
			}
		eckallds = rbind(eckallds, temcsdf)
		}

		dsach = paste0(dtname,"al2ndsc")
		assign( dsach,
			eckallds
		, env = .GlobalEnv)

}

# kmon( im08, hacbdt, pkb, kc = 6, knstart = 25, dtname = "im08")

kmon2 = function( Odata, beky, keycol, kc = 6, knstart = 25,
	dtname = "unt", swd = getwd(),...){

	temkc = kc
	temknstart = knstart

	serna = function( data, beky, keycol){
		tdfnm = rep(1:nrow(data))
		pkb = data[ , keycol]
		temdf = data.frame( bnm = tdfnm, bpk = pkb)
		hcabd = data[ , beky]
		nap = vector( mode = "character", length = 0)
		for( i in 1:NCOL(hcabd)) {
			nam = paste0("base", i, ".", beky[i])
			nap = c( nap, nam)
		}
		names(hcabd) = nap
		hcal2d = cbind( temdf, hcabd)
		hcal2d
	}

# KMC Data DF IN
	data = serna( Odata, beky, keycol)
	dhdc = data[ , -c(1, 2)]
	kmcal = kmeans( x = dhdc, center = temkc, nstart = temknstart)
	hcadata = kmcal$cluster


# KMC pic
#	piophdn = paste0( dtname, ".png")

require(useful)
kmcplot = plot(kmcal, data=dhdc)
kmcplot
}

# kmon2( im08, hacbdt, pkb, kc = 6, knstart = 25, dtname = "im08")
