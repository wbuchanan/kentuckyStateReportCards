// Load first year of data	
qui: import excel using raw/2012/ACCOUNTABILITY_ACHIEVEMENT_GRADE.xlsx, first case(l) clear

// Cleans up formatting
achgrfmt, dis(1)

// Load subsequent years and append them to first dataset
forv i = 2013/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/ACCOUNTABILITY_ACHIEVEMENT_GRADE.xlsx, first case(l) clear
		achgrfmt, dis(1)
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

qui: replace grade_level = "99" if grade_level == "EO"	
qui: destring grade, replace
la def grade 3 "3rd Grade" 4 "4th Grade" 5 "5th Grade" 6 "6th Grade" 		 ///   
7 "7th Grade" 8 "8th Grade" 10 "10th Grade" 11 "11th Grade" 			 	 ///   
99 "End of Course Exam", modify
la val grade grade

achfmtclean
rename *_level *
la var grade "Grade Level"
order distid schid schyr schlev disaglevel content grade amogroup tested	 ///   
novice apprentice proficient distinguished

compress
					 
save clean/acctAchievementGradeLevel.dta, replace
					 
