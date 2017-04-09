# HCA
hcad = function( hcdata, hck = 5, hcm = "ward.D", dism = "euclidean", ...){
	hcdif = dist( hcdata, method = dism)
	hctf = hclust( hcdif, method = hcm)
	hctrf = cutree( hctf, k = hck)
	hctrf
}

# HCA PIC
hcadpic = function( hcdata, hck = 5, hcm = "ward.D", dism = "euclidean", ...){
	hcdif = dist( hcdata, method = dism)
	hctf = hclust( hcdif, method = hcm)
	plot(hctf)
	rect.hclust( hctf, k = hck, border = "red")
}