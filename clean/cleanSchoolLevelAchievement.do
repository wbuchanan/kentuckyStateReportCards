

loc sheets "Acct Achievement Level Data" "ACCT Achievement Level" "Sheet1" "Sheet1"

// Load first year of data	
qui: import excel using raw/2012/ACCOUNTABILITY_ACHIEVEMENT_LEVEL.xlsx, 	 ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Cleans up formatting
achgrfmt, dis(0)

// Load subsequent years and append them to first dataset
forv i = 2013/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/ACCOUNTABILITY_ACHIEVEMENT_LEVEL.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `= `i' - 2011' of "`sheets'"'"')
		achgrfmt, dis(1)
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

achfmtclean
order distid schid schyr schlev disaglevel content amogroup tested novice 	 ///   
apprentice proficient distinguished

compress
					 
save clean/acctAchievementLevel.dta, replace
					 
