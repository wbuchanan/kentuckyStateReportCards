loc sheets "Safety Data" "Safety Data" "Sheet 1" "Sheet 1"

// Load first year of data	
qui: import excel using raw/2012/LEARNING_ENVIRONMENT_SAFETY.xlsx, 	 ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Load subsequent years and append them to first dataset
forv i = 2013/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/LEARNING_ENVIRONMENT_SAFETY.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `= `i' - 2011' of "`sheets'"'"')
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

