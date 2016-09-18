// 
cap prog drop achfmtclean

prog def achfmtclean

	qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
	qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
	qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
	qui: drop cntyno cntyname coop coop_code state_sch_id ncesid sch_type 	 ///   
	sch_cd pct_proficient_distinguished napd_calculation dist_name sch_name  ///   
	pct_bonus

	rename (sch_year content_type disagg_order dist_number sch_number 		 ///  
	content_level) (schyr content amogroup distid schid schlev)

	rename nbr_* *
	rename pct_* *
	la var schyr "School Year"
	la var content "Subject Area"
	la var schlev "Educational Level"
	la var amogroup "Student Reporting Subgroups"
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
						 
end

