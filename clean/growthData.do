kdecombo ACCOUNTABILITY_GROWTH, sheets(`"`"Accountability Growth Data"' `"ACCOUNTABILITY GROWTH"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)

qui: replace content_level = cond(ustrregexm(content_level, "[eE][lL][eE][mM].*") == 1, "1", ///   
							 cond(ustrregexm(content_level, "[mM][iI][dD].*") == 1, "2", "3"))

qui: replace nbr_tested = cond(nbr_tested == "---", ".d", 				 ///   
						  cond(nbr_tested == "***", ".s", 				 ///   
										  subinstr(nbr_tested, ",", "", .)))
la def tested .d "---" .s "***", modify										  

la def level 1 "Elementary School" 2 "Middle School" 3 "High School", modify

qui: replace sch_year = substr(sch_year, 5, 8)
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)

drop cntyno cntyname sch_type state_sch_id ncesid coop coop_code *_name 	 ///   
category sch_cd

rename (sch_year content_level nbr_tested reading_pct math_pct 				 ///   
reading_math_pct dist_number sch_number)(schyr schlev tested read math 		 ///   
readmath distid schid)

destring schyr schlev tested read math readmath, replace ignore("*,")

order distid schid schyr schlev tested read math readmath

la var schyr "School Year"
la var schlev "Educational Level"
la var tested "Number of Students Tested" 
la var distid "District ID"
la var schid "School ID"
la var read "% of Students Meeting Growth in Reading"
la var math "% of Students Meeting Growth in Mathematics"
la var readmath "% of Students Meeting Growth in Reading and Mathematics"
qui: egen x = rowmiss(tested read math readmath)
qui: drop if x == 4
qui: drop x
la val schlev level

qui: save clean/growthData.dta, replace
