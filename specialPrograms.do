loc gifted "Gifted and Talented" "Gifted" "Gifted"
loc mig "Migrant" "Migrant" "Migrant"
loc el "English Language Learners (ELL)" "ELL" "ELL"
loc sped "Special Education" "Special Ed" "Special Ed"

loc groups gifted mig el sped

foreach g of loc groups {

	tempfile `g'

	import excel using raw/2013/LEARNING_ENVIRONMENT_PROGRAMS.xlsx, 	 ///   
	first case(l) clear sheet(`"`: word `1' of "``g''"'"')

	// Load subsequent years and append them to first dataset
	forv i = 2014/2015 {
		preserve
			tempfile `g'`i'
			import excel using raw/`i'/LEARNING_ENVIRONMENT_PROGRAMS.xlsx, 	 ///   
			first case(l) clear sheet(`"`: word `= `i' - 2012' of "``g''"'"')
			qui: save ``g'`i''.dta, replace
		restore
		append using ``g'`i''.dta
	}
	
	save ``g''.dta, replace
}

qui: use `gifted'.dta, clear
append using `mig'.dta
append using `el'.dta
append using `sped'.dta

