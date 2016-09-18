loc sheets "TEACHING METHODS" "Sheet 1" "Sheet 1"

// Load first year of data	
qui: import excel using raw/2013/LEARNING_ENVIRONMENT_TEACHING_METHODS.xlsx, ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Load subsequent years and append them to first dataset
forv i = 2014/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/LEARNING_ENVIRONMENT_TEACHING_METHODS.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `= `i' - 2012' of "`sheets'"'"')
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

