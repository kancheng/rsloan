# data  handle
chfa.as = function(x)
{
	as.character(as.factor(x))
}
ncf.as = function(x)
{
	as.numeric(chfa.as(x))
}
nuch.as = function(x)
{
	as.numeric(as.character(x))
}

# data  head list
hdlis = function( hliobj, hrol = 5){
	lethl = length(hliobj)
	for( frl in 1:lethl){
		print(head( hliobj[[frl]], hrol))
	}
}