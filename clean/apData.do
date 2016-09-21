kdecombo ASSESSMENT_ADVANCE_PLACEMENT, sheets(`"`"ADVANCE PLACEMENT Data"' `"Sheet 1"' `"Sheet 1"'"') y(2013 2014 2015)


// Load first year of data	
qui: import excel using raw/2013/ASSESSMENT_ADVANCE_PLACEMENT.xlsx, 	 ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Load subsequent years and append them to first dataset
forv i = 2014/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/ASSESSMENT_ADVANCE_PLACEMENT.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `= `i' - 2012' of "`sheets'"'"')
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}
