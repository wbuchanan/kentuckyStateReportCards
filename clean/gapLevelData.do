kdecombo ACCOUNTABILITY_GAP_LEVEL, sheets(`"`"Accountability Gap Level Data"' `"ACCOUNTABILITY GAP LEVEL"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)

qui: replace content_level = cond(ustrregexm(content_level, "[eE][lL][eE][mM].*") == 1, "1", ///   
							 cond(ustrregexm(content_level, "[mM][iI][dD].*") == 1, "2", "3"))

qui: replace content_type = cond(content_type == "Language Mechanics", "1", ///   
							cond(content_type == "Mathematics", "2", ///   
							cond(content_type == "Reading", "3", ///   
							cond(content_type == "Science", "4", ///   
							cond(content_type == "Social Studies", "5", "6")))))
							
qui: replace nbr_tested = cond(nbr_tested == "---", ".d", 				 ///   
						  cond(nbr_tested == "***", ".s", 				 ///   
										  subinstr(nbr_tested, ",", "", .)))
la def tested .d "---" .s "***", modify										  

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

la def level 1 "Elementary School" 2 "Middle School" 3 "High School", modify
la def content 1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 4 "Science" 5 "Social Studies" 6 "Writing", modify
	
qui: replace sch_year = substr(sch_year, 5, 8)
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)

drop sch_name category sch_cd dist_name cntyno cntyname state_sch_id ///   
ncesid coop coop_code sch_type pct_proficient_distinguished 

rename (sch_year content_level content_type nbr_tested pct_novice pct_apprentice 	 ///   
pct_proficient pct_distinguished napd_calculation dist_number sch_number) 	 ///   
(schyr schlev content tested novice apprentice proficient distinguished napd distid schid)

destring schyr schlev content tested novice apprentice proficient 			 ///   
distinguished napd, replace ignore("*-,")

la var schyr "School Year"
la var content "Subject Area"
la var schlev "Educational Level"
la var tested "Number of Students Tested" 
la var novice "Percent of Students Scoring Novice"
la var apprentice "Percent of Students Scoring Apprentice"
la var proficient "Percent of Students Scoring Proficient"
la var distinguished "Percent of Students Scoring Distinguished"
la var distid "District ID"
la var schid "School ID"
qui: egen x = rowmiss(tested novice apprentice proficient distinguished)
qui: drop if x == 5
qui: drop x

order distid schid schyr schlev content tested novice apprentice proficient  ///   
distinguished napd
la val schlev level
la val content content

qui: save clean/gapLevel.dta, replace
