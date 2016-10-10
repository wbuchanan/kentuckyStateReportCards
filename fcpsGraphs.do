// Creates scheme that can be used for the test data graphs.  
// The lines are print, photocopy, and color blind friendly.  
// Similar criteria were used to find colors with sufficient contrast/accessibility
// to make the graphs easier to interpret view/share with a wider audience.
brewscheme, scheme(fcpstestlevs) linesty(orrd) linec(4) barsty(rdylbu) 		 ///   
barc(6) scatsty(tableau) scatc(3) areasty(paired) areac(3) dotsty(tableau) 	 ///   
dotc(3) cisty(paired) cic(3) cisat(40) symbols(plus triangle circle) 		 ///   
somesty(puor) somec(4)

loc cover keepus(distnm schnm schtype title1 mingrade maxgrade poc)
loc grinfo keepus(distnm schnm)
loc join qui: merge m:1 schid schyr using clean/profile.dta, nogen keep(3)

loc getfcps qui: keep if inlist(substr(schid, 1, 3), "165", "999")

qui: use clean/acctProfile.dta, clear
`join' `cover'
`getfcps'


qui: use clean/assessKPREP.dta, clear


keep if inlist(substr(schid, 1, 3), "165", "999")
