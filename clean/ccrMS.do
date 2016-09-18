
kdecombo ACCOUNTABILITY_CCR_MIDDLESCHOOL, y(2012 2013 2014 2015) sheets(`"`"Accountability CCR Explore"' `"ACCOUNTABILITY CCR EXPLORE MS"' `"Sheet 1"' `"Sheet 1"'"')

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
	
qui: replace sch_year = substr(sch_year, 5, 8)
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
qui: drop test_type cntyno cntyname sch_type state_sch_id ncesid coop 		 ///   
coop_code category sch_cd dist_name sch_name disagg_label
qui: destring nbr_tested english_bnchmrk_pct reading_bnchmrk_pct 			 ///   
math_bnchmrk_pct science_bnchmrk_pct total_points sch_year disagg_order, 	 ///   
replace ignore("*,")

la val disagg_order amogroup

qui: egen x = rowmiss(nbr_tested english_bnchmrk_pct reading_bnchmrk_pct 	 ///   
math_bnchmrk_pct science_bnchmrk_pct total_points)
qui: drop if x == 6
drop x

rename (sch_year disagg_order nbr_tested english_bnchmrk_pct 				 ///   
reading_bnchmrk_pct math_bnchmrk_pct science_bnchmrk_pct total_points 		 ///   
dist_number sch_number)(schyr amogroup tested eng read math sci total distid schid)

order distid schid schyr amogroup tested eng read math sci total

la var schyr "School Year"
la var amogroup "Student Reporting Subgroups"
la var distid "District ID"
la var schid "School ID"
la var tested "Number of Students Tested"
la var eng "Met English CCR Benchmark for Middle School"
la var read "Met Reading CCR Benchmark for Middle School" 
la var math "Met Mathematics CCR Benchmark for Middle School" 
la var sci "Met Science CCR Benchmark for Middle School" 
la var total "Total Points for Accountability"

qui: save clean/ccrMS.dta, replace
