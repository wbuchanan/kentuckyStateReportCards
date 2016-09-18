/* 
* Program used to attach text labels to numeric values in a data set:
*/
cap prog drop amogroup

prog def amogroup

	version 14.1
	
	syntax varname, LAbels(varname) [ LAName(string asis) ]
		
	qui: drop if `labels' == `"Disability – With IEP not including Alternate"' | ///   
			`labels' == `"Disability – With Accommodation not including Alternate"' | /// 
			`labels' == `"Disability - Alternate Only"' 

	qui: destring `varlist', replace
	
	qui: levelsof `varlist', loc(vals)

	if `"`laname'"' != "" loc labs la def `laname'
	else loc labs la def `varlist'
	
	foreach v of loc vals {
	
		qui: levelsof `labels' if `varlist' == `v', loc(x)
		
		loc labs `labs' `v' `x'
		
	}
	
	qui: `labs'
	
	if `"`laname'"' != "" {
		qui: rename `varlist' `laname'
		la val `laname' `laname'
		qui: replace `laname' = 0 if mi(`laname') & `labels' == "All Students"
		la var `laname' "Federally Required AMO Reporting Subgroups"
	} 
	else {
		la val `varlist' `varlist'
		qui: replace `varlist' = 0 if mi(`varlist') & `labels' == "All Students"
		la var `varlist' "Federally Required AMO Reporting Subgroups"
	}
	
	drop `labels'
	
end

	
