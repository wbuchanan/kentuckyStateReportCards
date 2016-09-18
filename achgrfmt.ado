cap prog drop achgrfmt
prog def achgrfmt

	version 14.1
	
	syntax, DISlev(numlist min=1 max=1 integer) LAbels(passthru) 		 ///   
	Valvar(varlist min=1 max=1) [ LAName(passthru) noGRade ] 

	cap confirm v content_level
	if _rc != 0 g content_level = "High School"
	
	cap confirm v grade_level
	if (_rc != 0 & "`grade'" != "nograde") qui: g grade_level = "99"
	else if (_rc != 0 & "`grade'" == "nograde") qui: g grade_level = "100"
	
	cap: replace test_type = cond(inlist(test_type, "KPREP", "KPREP-EOC"), "1", ///   
							 cond(test_type == "ACCESS", "2", ///   
							 cond(test_type == "ACT", "3", ///   
							 cond(test_type == "EXPLORE", "4", ///   
							 cond(test_type == "PLAN", "5", ///   
							 cond(test_type == "NRT", "6", ///   
							 cond(test_type == "PPSAT", "7", "8"))))))) 					 
	
	cap: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
	cap: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
	cap: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)

	cap: drop if disagg_label == 	"Disability – With IEP not including Alternate" | ///   
			 disagg_label == 	"Disability – With Accommodation not including Alternate" | ///   
			 disagg_label == 	"Disability - Alternate Only"

	cap: replace sch_year = substr(sch_year, 5, 8)
	cap: replace content_level = cond(ustrregexm(content_level, "[eE][lL][eE][mM].*") == 1, "1", ///   
								 cond(ustrregexm(content_level, "[mM][iI][dD].*") == 1, "2", "3"))
	
	cap: replace content_type = cond(content_type == "Language Mechanics", "1", ///   
								cond(content_type == "Mathematics", "2", ///   
								cond(content_type == "Reading", "3", ///   
								cond(content_type == "Science", "4", ///   
								cond(content_type == "Social Studies", "5", ///   
								cond(content_type == "Writing", "6", ///   
								cond(content_type == "Algebra II", "7", ///   
								cond(content_type == "Biology", "8", ///   
								cond(content_type == "English II", "9", "10")))))))))
								
	cap: replace nbr_tested = cond(nbr_tested == "---", ".d", 				 ///   
							  cond(nbr_tested == "***", ".s", 				 ///   
											  subinstr(nbr_tested, ",", "", .)))
	la def tested .d "---" .s "***", modify										  
	
	cap amogroup `valvar', `labels' `laname'
	
	la def level 1 "Elementary School" 2 "Middle School" 3 "High School", modify
	
	la def content 	1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 		 ///   
					4 "Science" 5 "Social Studies" 6 "Writing" 				 ///   
					7 "Algebra II" 8 "Biology" 9 "English II" 				 ///   
					10 "U.S. History", modify
					
	la def testnm 1 "KPREP" 2 "ACCESS" 3 "ACT" 4 "Explore" 5 "Plan" 6 "NRT" 7 "PPSAT" 8 "PSAT", modify	
	cap: replace nbr_tested = subinstr(subinstr(nbr_tested, ",", "", .), "*", "", .)
	cap: destring sch_year content_level nbr_* content_* pct_* test_type grade_level, replace	 
	la def grade 3 "3rd Grade" 4 "4th Grade" 5 "5th Grade" 6 "6th Grade" 		 ///   
	7 "7th Grade" 8 "8th Grade" 9 "9th Grade" 10 "10th Grade" 11 "11th Grade" 	 ///   
	12 "12th Grade" 99 "High School" 100 "All Grades", modify
	cap la val grade grade
						 
	cap la val content_type content
	cap la val nbr_tested tested
	cap la val content_level level
	cap la val test_type testnm
	cap: egen x = rowmiss(nbr_tested pct_novice pct_apprentice pct_proficient pct_distinguished)
	cap: drop if x == 5
	cap: drop x
	cap rename pct_* *
	cap rename nbr_* *
	
end
