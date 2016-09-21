
loc sheets "Accountability CCR High School" "Accountability CCR High School" "Sheet 1" "Sheet 1"

// Load first year of data	
qui: import excel using raw/2012/ACCOUNTABILITY_CCR_HIGHSCHOOL.xlsx, 	 ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Load subsequent years and append them to first dataset
forv i = 2013/2015 {
	preserve
		tempfile x`i'
		import excel using raw/`i'/ACCOUNTABILITY_CCR_HIGHSCHOOL.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `= `i' - 2011' of "`sheets'"'"')
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

drop test_type cntyno cntyname state_sch_id ncesid coop coop_code sch_type 	 ///   
category disagg_label dist_name sch_name 
qui: tostring sch_year, replace
qui: replace sch_year = substr(sch_year, 5, 8)
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
qui: replace sch_number = "999" if mi(sch_number)

	#d ;
		la def amogroup 0 "All Students" 1 "Male" 2 "Female" 
		3 "White (Non-Hispanic)"
		4 "African American"
		5 "Hispanic"
		6 "Asian"
		7 "American Indian or Alaska Native"
		8 "Native Hawaiian or Other Pacific Islander"
		9 "Two or more races"
		10 "Migrant"
		11 "Limited English Proficiency"
		12 "Free/Reduced-Price Meals"
		13 "Disability-With IEP (Total)"
		14 "Disability-With IEP (not including Alternate)"
		15 "Disability-With Accommodation (not including Alternate)"
		16 "Disability-Alternate Only"
		17 "Gap Group (non-duplicated)", modify;

	#d cr

foreach v of var nbr_graduates_with_diploma college_ready 					 ///   
career_ready_academic career_ready_technical career_ready_total 			 ///   
nbr_ccr_regular pct_ccr_no_bonus pct_ccr_with_bonus	{

	qui: destring `v', replace ignore("*,")
	
}
	
qui: destring sch_year, replace

rename (sch_year disagg_order nbr_graduates_with_diploma 					 ///   
college_ready career_ready_academic career_ready_technical 					 ///   
career_ready_total nbr_ccr_regular pct_ccr_no_bonus pct_ccr_with_bonus 		 ///   
dist_number sch_number)(schyr amogroup diplomas collready 					 ///   
caracad cartech cartot nregular pctwobonus pctwbonus distid schid)

drop sch_cd

order distid schid schyr amogroup

la val amogroup amogroup
la var schyr "School Year"
la var amogroup "Student Reporting Subgroups"
la var distid "District ID"
la var schid "School ID"
la var diplomas "Number of Students Graduating with Regular High School Diplomas"
la var collready "Number of College Ready Students" 
la var caracad "Number of Career Ready Students (Academic)" 
la var cartech "Number of Career Ready Students (Technical)" 
la var cartot "Number of Career Ready Students (Total)" 
la var nregular "Number Regular College/Career Ready"
la var pctwobonus "% College/Career Ready w/o Bonus"
la var pctwbonus "% College/Career Ready w/ Bonus"

qui: egen x = rowmiss(diplomas collready caracad cartech cartot nregular pctwobonus pctwbonus)
qui: drop if x == 8
drop x

isid distid schid schyr amogroup

qui: save clean/ccrHS.dta, replace
