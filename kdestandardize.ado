cap prog drop kdestandardize

prog def kdestandardize

	version 14
	
	syntax [, DROPVars(string asis) noGRade SCHYRLab(integer 0) ]
	
	// Defines local macro to use to shorten command lengths
	loc rx ustrregexm
	
	// Defines local macro for use with removing records with no data from test files
	loc testlevs tested novice apprentice proficient distinguished
	
	// Defines local macro used to remove records with no data from ccr files
	loc ccrhs diplomas collready caracad cartech cartot nregular pctwobonus pctwbonus
	
	loc ccrms tested msbnchmrkeng msbnchmrkrla msbnchmrkmth msbnchmrksci totmsccrpts
	
	loc growvars tested grorla gromth groboth
	
	// Drop any variables ID'd by user before constructing variable list
	if `"`dropvars'"' != "" cap drop `dropvars'

	// Define value labels that can be applied across files
	{
	
	// Define missing value labels for nbr_tested variable
	la def tested .d "---" .s "***", modify										  

	// Define grade span level value labels
	la def level 1 "Elementary School" 2 "Middle School" 3 "High School", modify
	
	// Define value labels for content area that was tested
	la def content 	1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 		 ///   
					4 "Science" 5 "Social Studies" 6 "Writing" 				 ///   
					7 "Algebra II" 8 "Biology" 9 "English II" 				 ///   
					10 "U.S. History", modify
					
	// Define value labels for test names				
	la def testnm 	1 "KPREP" 2 "ACCESS" 3 "ACT" 4 "Explore" 5 "Plan" 		 ///   
					6 "NRT" 7 "PPSAT" 8 "PSAT", modify	

	// Define value labels for grade levels				
	la def grade 3 "3rd Grade" 4 "4th Grade" 5 "5th Grade" 6 "6th Grade" 	 ///   
				 7 "7th Grade" 8 "8th Grade" 9 "9th Grade" 10 "10th Grade"   ///   
				 11 "11th Grade" 12 "12th Grade" 99 "High School" 			 ///   
				 100 "All Grades", modify

	// Define value labels for whether or not AMOs are met			 
	la def amomet 0 "Did not meet AMOs" 1 "Met AMOs", modify

	// Define value labels for school classification variable
	la def classification 	1 `"Needs Improvement"'							 ///    
							2 `"Needs Improvement/Progressing"' 			 ///   
							3 `"Proficient/Progressing"' 					 ///   
							4 `"Proficient"' 								 ///   
							5 `"Distinguished/Progressing"' 				 ///    
							6 `"Distinguished"', modify
				 
	// Define value labels for graduation rate goal variable						
	la def gradgoal .n "N/A" 0 "No" 1 "Yes", modify

	// Define value labels for participation rate variable
	la def nextpartic 0 "No" 1 "Yes", modify

	// Define value labels for reward designations
	la def reward 	1 `"District of Distinction"'							 ///   
					2 `"District of Distinction/High Progress District"'	 ///   
					3 `"Focus District"' 									 ///   
					4 `"Focus District/High Progress District"' 			 ///   
					5 `"Focus School"'  									 ///   
					6 `"Focus School/High Progress School"' 				 ///   
					7 `"High Performing District"' 							 ///   
					8 `"High Performing District/High Progress District"'	 ///    
					9 `"High Performing School"' 							 ///   
					10 `"High Performing School/High Progress School"' 		 ///   
					11 `"High Progress District"' 							 ///   
					12 `"High Progress School"' 							 ///   
					13 `"Priority School"' 									 ///   
					14 `"Priority School(Monitoring Only)"' 				 ///   
					15 `"Priority School/High Progress School"' 			 ///   
					16 `"School of Distinction"' 							 ///   
					17 `"School of Distinction/High Progress School"', modify
					
		la def schyrlong 2009 "2008-2009" 2010 "2009-2010" 2011 "2010-2011"	 ///   				
						 2012 "2011-2012" 2013 "2012-2013" 2014 "2013-2014"	 ///   
						 2015 "2014-2015" 2016 "2015-2016" 2017 "2016-2017"	 ///   
						 2018 "2017-2018" 2019 "2018-2019" 2020 "2019-2020", modify
						 
		la def schyrshrt 2009 "2008-09" 2010 "2009-10" 2011 "2010-11"		 ///   				
						 2012 "2011-12" 2013 "2012-13" 2014 "2013-14"		 ///   
						 2015 "2014-15" 2016 "2015-16" 2017 "2016-17"		 ///   
						 2018 "2017-18" 2019 "2018-19" 2020 "2019-20", modify
			
		// Changes end of line delimiter to semicolon	
		#d ;
		
		// Defines school type value labels
		la def schtype
		-1 "Not defined on http://applications.education.ky.gov/sdci/Classification.aspx"
		1 "A1 admin control from principal/head teacher & eligible to establish an SBDM"
		2 "A2 District-operated CTE center, with membership counted at A1 school."
		3 "A3 District-operated special education program."
		4 "A4 District-operated preschool program (e.g., Headstart, KERA Preschool, or PACE)."
		5 "A5 District-opertated alt program w/o definable attendance boundaries"
		6 "A6 KECSAC funded programs serving state children agency"
		7 "A7 Schools set up to track Home/Hospital/Summer School, membership counted at A1 School"
		8 "B1 Non-Public Lab/Training school operated by public IHE"
		9 "B2 Non-Public Lab/Training school operated by private IHE"
		10 "C1 Non-Public IHE operated CTE schools."
		11 "C2 Non-Public State operated CTE area centers (ATC)."
		12 "D1 Non-Public KDE operated schools."
		13 "F1 Non-Public Federal Dependent Schools (Ft. Knox & Ft. Campbell)."
		14 "F2 Non-Public Federally operated job corps facilities."
		15 "J1 Non-Public Roman Catholic."
		16 "M1 Non-Public Other religions."
		17 "M2 Non-Public Seventh Day Adventist."
		18 "R1 Non-Public Private, non-church related.";
		
		// Changes end of line delimiter back to carriage return
		#d cr 

	} // End of value label definitions
	
	// Get the list of variable names
	qui: ds
	
	// Store variable names in a local that can persist across commands
	loc x `r(varlist)'
		
	// Handles instances of the sch_year variable	
	if `: list posof "sch_year" in x' != 0 { 
		qui: replace sch_year = substr(sch_year, 5, 8)
		qui: rename sch_year schyr
		qui: destring schyr, replace
		la var schyr "School Year"
		if `schyrlab' == 1 la val schyr schyrshrt
		else if `schyrlab' == 2 la val schyr schyrlong
	} // End handling of the sch_year variable
		
	// Handles instances of the sch_cd variable 	
	if `: list posof "sch_cd" in x' != 0 { 
		qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
		qui: rename sch_cd schid
		la var schid "Unique School ID"	
	}
	
	// Handles instances of the dist_number variable in a file
	if `: list posof "dist_number" in x' != 0 {  
		qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
		qui: rename dist_number distid
		la var distid "District ID"
	}
	
	// Handles instances of the sch_number variable in a file
	if `: list posof "sch_number" in x' != 0 { 
		qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
		qui: rename sch_number schnum
		la var schnum "Non-Unique School ID"
	}
	
	// Handles files that have AMO disaggregation groups in the variable list
	if 	`: list posof "disagg_label" in x' != 0 & 							 ///   
		`: list posof "disagg_order" in x' != 0 {
		
		// Calls external routine with logic/rules for handling these business 
		// rules/logic
		qui: amogroup disagg_order, la(disagg_label) lan(amogroup)					
		
	} // End Handling of disagg_label and disagg_order variables
	
	// Handles the content_level variable
	if `: list posof "content_level" in x' != 0 { 
		loc cl content_level
		qui: replace content_level = cond(`rx'(`cl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`cl', "mid.*", 1) == 1, "2", "3"))
		qui: rename content_level level
		qui: destring level, replace
		la val level level
		la var level "Educational Level" 
	}
	
	// Handles instances of the test_type variable
	if `: list posof "test_type" in x' != 0 {
	
		// Recodes test name variable with numeric values
		qui: replace test_type = cond(`rx'(test_type, "kprep.*", 1), "1",	 ///   
							 cond(test_type == "ACCESS", "2",				 ///   
							 cond(test_type == "ACT", "3",					 ///   
							 cond(test_type == "EXPLORE", "4",				 ///   
							 cond(test_type == "PLAN", "5",					 ///   
							 cond(test_type == "NRT", "6",					 ///   
							 cond(test_type == "PPSAT", "7", "8"))))))) 

		// Renames the test_type variable
		qui: rename test_type testnm
		
		// Recasts the values to numeric types
		qui: destring testnm, replace
		
		// Applies value labels to the variable
		la val testnm testnm					
		
		// Applies variable label to the variable
		la var testnm "Test Name" 
		
	} // End handling of test_type variable
	
	// Handles instances of the content_type variable
	if `: list posof "content_type" in x' != 0 {
		
		// Shorthand reference for variable
		loc ct content_type
		
		// Recodes the values of the variable to numeric values
		qui: replace content_type = cond(`ct' == "Language Mechanics", "1",	 ///   
									cond(`ct' == "Mathematics", "2",		 ///   
									cond(`ct' == "Reading", "3",			 ///   
									cond(`ct' == "Science", "4",			 ///   
									cond(`ct' == "Social Studies", "5",		 ///   
									cond(`ct' == "Writing", "6",			 ///   
									cond(`ct' == "Algebra II", "7",			 ///   
									cond(`ct' == "Biology", "8",			 ///   
									cond(`ct' == "English II", "9", "10")))))))))
									
		// Renames the variable							
		qui: rename content_type content
		
		// Recasts the variable to a numeric type
		qui: destring content, replace
		
		// Applies value labels to the variable
		la val content content
		
		// Applies a variable label to the variable
		la var content "Subject Area"
		
	} // End handling of the content_type variable
	
	// Handles instances of the nbr_tested variable
	if `: list posof "nbr_tested" in x' != 0 {
	
		// Removes commas from the number tested variable
		qui: replace nbr_tested = subinstr(nbr_tested, ",", "", .)

		// Recodes different missing value codes
		qui: replace nbr_tested = cond(nbr_tested == "---", ".d", 			 ///   
								  cond(nbr_tested == "***", ".s", nbr_tested))
								  
		// Recasts the variable to numeric type						  
		qui: destring nbr_tested, replace
		
		// Renames the variable
		qui: rename nbr_tested tested
		
		// Applies a variable label to the variable
		la var tested "Number of Students Tested" 
		
	} // End handling of the nbr_tested variable
	
	
	// Handles instances of the grade_level variable
	if `: list posof "grade_level" in x' != 0 {
		qui: destring grade_level, replace
		qui: rename grade_level grade
		la val grade grade
		la var grade "Accountability Grade Level" 
	}
	
	// If grade_level doesn't exist in the file
	else {
	
		if `"`grade'"' != "nograde" qui: g grade = "99"
		else qui: g grade = "100"
		qui: destring grade, replace
		la val grade grade
		la var grade "Accountability Grade Level" 
	}
	
	// Handles instances of the reward_recognition variable
	if `: list posof "reward_recognition" in x' != 0 {
	
		// Renames reward_recognition variable
		qui: rename reward_recognition reward
		
		// Define numeric encodings for the reward designations
		qui: replace reward = 												 ///   
			cond(reward == `"District of Distinction"', "1", 				 ///
			cond(reward == `"District of Distinction/High Progress District"', "2",  ///
			cond(reward == `"Focus District"', "3", 						 ///
			cond(reward == `"Focus District/High Progress District"', "4", 	 ///
			cond(reward == `"Focus School"', "5", 							 ///
			cond(reward == `"Focus School/High Progress School"', "6", 		 ///
			cond(reward == `"High Performing District"', "7", 				 ///
			cond(reward == `"High Performing District/High Progress District"', "8", ///
			cond(reward == `"High Performing School"', "9", 				 ///
			cond(reward == `"High Performing School/High Progress School"', "10", 	 ///
			cond(reward == `"High Progress District"', "11", 				 ///
			cond(reward == `"High Progress School"', "12", 					 ///
			cond(reward == `"Priority School"', "13", 						 ///
			cond(reward == `"Priority School(Monitoring Only)"', "14", 		 ///
			cond(reward == `"Priority School/High Progress School"', "15", 	 ///
			cond(reward == `"School of Distinction"', "16", 				 ///
			cond(reward == `"School of Distinction/High Progress School"', "17", ""))))))))))))))))) 
		
		// Converts values of reward to numeric values
		qui: destring reward, replace
		
		// Applies value labels to the reward variable
		la val reward reward
		
		// Applies variable label to the reward variable
		la var reward "Differentiated Accountability Reward Status"

	} // End handling of reward_recognition variable
	
	// Handles instances of the amo_met variable
	if `: list posof "amo_met" in x' != 0 {
		qui: replace amo_met = 	cond(amo_met == "No", "0", 					 ///   
								cond(amo_met == "Yes", "1", ""))
		qui: destring amo_met, replace
		qui: rename amo_met amomet
		la val amomet amomet
		la var amomet "AMO Status Indicator"
	} // End of handling of the amo_met variable
	
	// Handles instances of the  variable
	if `: list posof "pct_novice" in x' != 0 {
		qui: rename pct_novice novice
		la var novice "Percent of Students Scoring Novice"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_apprentice" in x' != 0 {
		qui: rename pct_apprentice apprentice
		la var apprentice "Percent of Students Scoring Apprentice"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_proficient" in x' != 0 {
		qui: rename pct_proficient proficient
		la var proficient "Percent of Students Scoring Proficient"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_distinguished" in x' != 0 {
		qui: rename pct_distinguished distinguished
		la var distinguished "Percent of Students Scoring Distinguished"
	} // End of handling of the  variable
	
	// Handles dropping records containing no test data if file contains test data
	if `: list testlevs in x' != 0 {
		qui: egen testmiss = rowmiss(tested novice apprentice proficient distinguished)
		qui: drop if testmiss == 5
		qui: drop testmiss
	} // End of handling of null records
	
	// Handles instances of the participation_next_yr variable
	if `: list posof "participation_next_yr" in x' != 0 {
		
		// Short hand reference for the variable
		loc pny participation_next_yr
		
		// Use numeric encodings for participation rate field
		qui: replace `pny' = cond(`pny' == "No", "0", cond(`pny' == "Yes", "1", ""))
		
		qui: destring `pny', replace
		
		la val `pny' nextpartic
		
		qui: rename `pny' nextpartic
		
		la var nextpartic ""
	
	} // End of handling of the participation_next_yr variable
	
	// Handles instances of the graduation_rate_goal variable
	if `: list posof "graduation_rate_goal" in x' != 0 {
	
		// Create shorthand reference for variable
		loc grg graduation_rate_goal
	
		// Use numeric encodings for graduation rate goal field									 
		qui: replace `grg' = cond(`grg' == "N/A", ".n",						 ///   
							 cond(`grg' == "No", "0",						 ///   
							 cond(`grg' == "Yes", "1", "")))
							 
		// Recase variable to numeric values					 
		qui: destring `grg', replace
		
		// Apply value labels to variable
		la val `grg' gradgoal
		
		// Rename the variable
		qui: rename `grg' gradgoal
		
		// Label the variable
		la var gradgoal "Graduation Rate Goal"
							 
	} // End of handling of the graduation_rate_goal variable
	
	// Handles instances of the base_yr_score variable
	if `: list posof "base_yr_score" in x' != 0 {
	
		// Create shorthand reference for variable
		loc bys base_yr_score
	
		// Replace all instances of -R with missing value in base year score						
		qui: replace `bys' = subinstr(`bys', "-R", "", .)	
		
		// Rename the baseline year score variable
		qui: rename `bys' baseline
		
		// Recast to numeric values
		qui: destring baseline, replace
		
		// Apply variable label
		la var baseline "Starting Score for Schools, Districts, and State"
						
	} // End of handling of the base_yr_score variable
	
	// Handles instances of the classification variable
	if `: list posof "classification" in x' != 0 {
	
		// Create short hand reference for variable name
		loc cv classification
	
		// Recode classification with numeric values						
		qui: replace `cv' = cond(`cv' == `"Distinguished"', "6",			 ///  
							cond(`cv' == `"Distinguished/Progressing"', "5", ///  
							cond(`cv' == `"Needs Improvement"', "1",		 ///  
							cond(`cv' == `"Needs Improvement/Progressing"', "2", ///  
							cond(`cv' == `"Proficient"', "4",				 ///  
							cond(`cv' == `"Proficient/Progressing"', "3", ""))))))

		// Recast variable to numeric values
		qui: destring `cv', replace
		
		// Apply value labels to variable
		la val `cv' `cv'
							
		// Defines variable label for the variable					
		la var classification "Differentiated Accountability Status Indicator"
							
	} // End of handling of the classification variable
	
	// Handles instances of the overall_score variable
	if `: list posof "overall_score" in x' != 0 {
		qui: destring overall_score, replace ignore("*-R,")
		qui: rename overall_score overall
		la var overall "Overall Points in Accountability Model"
	} // End of handling of the overall_score variable
	
	// Handles instances of the ky_rank variable
	if `: list posof "ky_rank" in x' != 0 {
		qui: destring ky_rank, replace
		qui: rename ky_rank rank 
		la var rank "Rank of Schools/Districts Across the State"
	} // End of handling of the ky_rank variable
	
	// Handles instances of the gain_needed variable
	if `: list posof "gain_needed" in x' != 0 {
		qui: destring gain_needed, replace
		qui: rename gain_needed amogain
		la var amogain "Gain Needed to meet AMOs"
	} // End of handling of the gain_needed variable
	
	// Handles instances of the amo_goal variable
	if `: list posof "amo_goal" in x' != 0 {
		qui: destring amo_goal, replace
		qui: rename amo_goal amogoal 
		la var amogoal "Annual Measureable Objectives Goal"
	} // End of handling of the amo_goal variable
	
	// Handles instances of the distnm variable
	if `: list posof "distnm" in x' != 0 {
		qui: rename dist_name distnm
		qui: replace distnm = "Kentucky" if ustrregexm(sch_name, "state", 1)
		la var distnm "District Name"
	} // End of handling of the distnm variable
	
	// Handles instances of the sch_name variable
	if `: list posof "sch_name" in x' != 0 {
		qui: rename sch_name schnm 
		qui: replace schnm = "Kentucky" if ustrregexm(sch_name, "state", 1)
		la var schnm "School Name"
	} // End of handling of the sch_name variable
	
	// Handles instances of the cntyno variable
	if `: list posof "cntyno" in x' != 0 {
		qui: rename cntyno cntyid
		la var cntyid "County ID"

	} // End of handling of the cntyno variable
	
	// Handles instances of the coop_code variable
	if `: list posof "coop_code" in x' != 0 {
		qui: rename coop_code coopid 
		la var coopid "Cooperative ID Number"
	
	} // End of handling of the coop_code variable
	
	// Handles instances of the cntyname variable
	if `: list posof "cntyname" in x' != 0 {
		qui: rename cntyname cntynm
		la var cntynm "County Name"	
	} // End of handling of the cntyname variable
	
	// Handles instances of the coop variable
	if `: list posof "coop" in x' != 0 {
		la var coop "Cooperative Name"
	} // End of handling of the coop variable
	
	// Handles instances of the ncesid variable
	if `: list posof "ncesis" in x' != 0 {
		la var ncesid "National Center for Educational Statistics ID Number"
	} // End of handling of the ncesid variable
	
	// Handles instances of the nbr_graduates_with_diploma variable
	if `: list posof "nbr_graduates_with_diploma" in x' != 0 {
		qui: destring nbr_graduates_with_diploma, replace ignore("*,")
		qui: rename nbr_graduates_with_diploma diplomas
		la var diplomas "Number of Students Graduating with Regular High School Diplomas"
	
	} // End of handling of the nbr_graduates_with_diploma variable
	
	// Handles instances of the college_ready variable
	if `: list posof college_ready"" in x' != 0 {
		qui: destring college_ready, replace ignore("*,")
		qui: rename college_ready collready
		la var collready "Number of College Ready Students" 
	
	} // End of handling of the college_ready variable
	
	// Handles instances of the career_ready_academic variable
	if `: list posof "career_ready_academic" in x' != 0 {
		qui: destring career_ready_academic, replace ignore("*,")
		qui: rename career_ready_academic caracad 
		la var caracad "Number of Career Ready Students (Academic)" 
	
	} // End of handling of the career_ready_academic variable
	
	// Handles instances of the career_ready_technical variable
	if `: list posof "career_ready_technical" in x' != 0 {
		qui: destring career_ready_technical, replace ignore("*,")
		qui: rename career_ready_technical cartech
		la var cartech "Number of Career Ready Students (Technical)" 
	
	} // End of handling of the career_ready_technical variable
	
	// Handles instances of the career_ready_total variable
	if `: list posof "career_ready_total" in x' != 0 {
		qui: destring career_ready_total, replace ignore("*,")
		qui: rename career_ready_total cartot
		la var cartot "Number of Career Ready Students (Total)" 
	
	} // End of handling of the career_ready_total variable
	
	// Handles instances of the nbr_ccr_regular variable
	if `: list posof "nbr_ccr_regular" in x' != 0 {
		qui: destring nbr_ccr_regular, replace ignore("*,")
		qui: rename nbr_ccr_regular nregular
		la var nregular "Number Regular College/Career Ready"
	
	} // End of handling of the nbr_ccr_regular variable
	
	// Handles instances of the pct_ccr_no_bonus variable
	if `: list posof "pct_ccr_no_bonus" in x' != 0 {
		qui: destring pct_ccr_no_bonus, replace ignore("*,")
		qui: rename pct_ccr_no_bonus pctwobonus
		la var pctwobonus "% College/Career Ready w/o Bonus"
	
	} // End of handling of the pct_ccr_no_bonus variable
	
	// Handles instances of the pct_ccr_with_bonus variable
	if `: list posof "pct_ccr_with_bonus" in x' != 0 {
		qui: destring pct_ccr_with_bonus, replace ignore("*,")
		qui: rename pct_ccr_with_bonus pctwbonus	
		la var pctwbonus "% College/Career Ready w/ Bonus"
	
	} // End of handling of the pct_ccr_with_bonus variable
	
	// Handles instances of the msbnchmrkeng variable
	if `: list posof "msbnchmrkeng" in x' != 0 {
		qui: destring english_bnchmrk_pct, replace ignore("*,")
		qui: rename english_bnchmrk_pct msbnchmrkeng
		la var msbnchmrkeng "% of MS Students Meeting English CCR Benchmark"	
	} // End of handling of the msbnchmrkeng variable
	
	// Handles instances of the msbnchmrkrla variable
	if `: list posof "msbnchmrkrla" in x' != 0 {
		qui: destring reading_bnchmrk_pct, replace ignore("*,")
		qui: rename reading_bnchmrk_pct msbnchmrkrla   
		la var msbnchmrkrla "% of MS Students Meeting Reading CCR Benchmark" 	
	} // End of handling of the msbnchmrkrla variable
	
	// Handles instances of the msbnchmrkmth variable
	if `: list posof "msbnchmrkmth" in x' != 0 {
		qui: destring math_bnchmrk_pct, replace ignore("*,")
		qui: rename math_bnchmrk_pct msbnchmrkmth
		la var msbnchmrkmth "% of MS Students Meeting Math CCR Benchmark" 
	} // End of handling of the msbnchmrkmth variable
	
	// Handles instances of the msbnchmrksci variable
	if `: list posof "msbnchmrksci" in x' != 0 {
		qui: destring science_bnchmrk_pct, replace ignore("*,")
		qui: rename science_bnchmrk_pct msbnchmrksci
		la var msbnchmrksci "% of MS Students Meeting Science CCR Benchmark" 
	} // End of handling of the msbnchmrksci variable
	
	// Handles instances of the total_points variable
	if `: list posof "total_points" in x' != 0 {
		qui: destring total_points, replace ignore("*,")
		qui: rename total_points totmsccrpts	
		la var totmsccrpts "Total Points for Middle School CCR Component"
	} // End of handling of the total_points variable
	
	// Handles instances of the napd_calculation variable
	if `: list posof "napd_calculation" in x' != 0 {
		qui: destring napd_calculation, replace ignore("*-,")
		qui: rename napd_calculation napd	
	} // End of handling of the napd_calculation variable
	
	// Handles instances of the reading_pct variable
	if `: list posof "reading_pct" in x' != 0 {
	   qui: destring reading_pct, replace ignore("*-,")
	   qui: rename reading_pct grorla
	   la var grorla "% of Students Meeting Growth in Reading"
	} // End of handling of the reading_pct variable
	
	// Handles instances of the math_pct variable
	if `: list posof "math_pct" in x' != 0 {
		qui: destring math_pct, replace ignore("*-,")
		qui: rename math_pct gromth
		la var gromth "% of Students Meeting Growth in Math"
	} // End of handling of the math_pct variable
	
	// Handles instances of the reading_math_pct variable
	if `: list posof "reading_math_pct" in x' != 0 {
		qui: destring reading_math_pct, replace ignore("*-,")
		qui: rename reading_math_pct groboth
		la var groboth "% of Students Meeting Growth in Reading AND Math"
	} // End of handling of the reading_math_pct variable
	
	// Handles instances of the latitude variable
	if `: list posof "latitude" in x' != 0 {
		qui: g double lat = real(ustrregexra(latitude, "[\t\r\n\s ]+", ""))
		la var lat "Latitude"
	} // End of handling of the latitude variable
	
	// Handles instances of the longitude variable
	if `: list posof "longitude" in x' != 0 {
		qui: g double lon = real(ustrregexra(longitude, "[\t\r\n\s ]+", ""))
		la var lon "Longitude"
	} // End of handling of the longitude variable
	
	// Handles instances of the sch_type variable
	if `: list posof "sch_type" in x' != 0 {
		qui: rename sch_type schtype
		loc st schtype
		qui: replace `st' = cond(ustrregexm(`st', "A[1-7]", 1), substr(`st', 2, 1), ///   
							cond(`st' == "B1", "8", ///   
							cond(`st' == "B2", "9", ///   
							cond(`st' == "C1", "10", ///   
							cond(`st' == "C2", "11", ///   
							cond(`st' == "D1", "12", ///   
							cond(`st' == "F1", "13", ///   
							cond(`st' == "F2", "14", ///   
							cond(`st' == "J1", "15", ///   
							cond(`st' == "M1", "16", ///   
							cond(`st' == "M2", "17", ///   
							cond(`st' == "R1", "18", "-1"))))))))))))   
		qui: destring `st', replace
		qui: la val `st' `st'
		la var `st' "School Type Classification"
	} // End of handling of the sch_type variable
	
	// Handles instances of the achievement_points variable
	if `: list posof "achievement_points" in x' != 0 {
		qui: destring achievement_points, replace ignore("*-R,")
		qui: rename achievement_points achievepts
		la var achievepts "Achievement Points"	
	} // End of handling of the achievement_points variable
	
	// Handles instances of the achievement_score variable
	if `: list posof "achievement_score" in x' != 0 {
		qui: destring achievement_score
		qui: rename achievement_score achievesc
		la var achievesc "Achievement Score"
	} // End of handling of the achievement_score variable
	
	// Handles instances of the gap_points variable
	if `: list posof "gap_points" in x' != 0 {
		qui: destring gap_points
		qui: rename gap_points gappts
		la var gappts "Gap Points"
	} // End of handling of the gap_points variable
	
	// Handles instances of the gap_score variable
	if `: list posof "gap_score" in x' != 0 {
		qui: destring gap_score 
		qui: rename gap_score gapsc
		la var gapsc "Gap Score" 
	} // End of handling of the gap_score variable
	
	// Handles instances of the growth_points variable
	if `: list posof "growth_points" in x' != 0 {
		qui: destring growth_points 
		qui: rename growth_points growthpts
		la var growthpts "Growth Points" 
	} // End of handling of the growth_points variable
	
	// Handles instances of the growth_score variable
	if `: list posof "growth_score" in x' != 0 {
		qui: destring growth_score 
		qui: rename growth_score growthsc
		la var growthsc "Growth Score" 
	} // End of handling of the growth_score variable
	
	// Handles instances of the ccr_points variable
	if `: list posof "ccr_points" in x' != 0 {
		qui: destring ccr_points 
		qui: rename ccr_points ccrpts
		la var ccrpts "College/Career Readiness Points" 
	} // End of handling of the ccr_points variable
	
	// Handles instances of the ccr_score variable
	if `: list posof "ccr_score" in x' != 0 {
		qui: destring ccr_score 
		qui: rename ccr_score ccrsc
		la var ccrsc "College/Career Readiness Score"
	} // End of handling of the ccr_score variable
	
	// Handles instances of the graduation_points variable
	if `: list posof "graduation_points" in x' != 0 {
		qui: destring graduation_points 
		qui: rename graduation_points gradpts 
		la var gradpts "Graduation Rate Points" 
	} // End of handling of the graduation_points variable
	
	// Handles instances of the graduation_score variable
	if `: list posof "graduation_score" in x' != 0 {
		qui: destring graduation_score 
		qui: rename graduation_score gradsc
		la var gradsc "Graduation Rate Score" 
	} // End of handling of the graduation_score variable
	
	// Handles instances of the weighted_summary variable
	if `: list posof "weighted_summary" in x' != 0 {
		qui: destring weighted_summary 
		qui: rename weighted_summary wgtsum
		la var wgtsum "Weighted Summary" 
	} // End of handling of the weighted_summary variable
	
	// Handles instances of the state_sch_id variable
	if `: list posof "state_sch_id" in x' != 0 {
		qui: destring state_sch_id 
		qui: rename state_sch_id stschid
		la var stschid "State Assigned School ID Number" 
	} // End of handling of the state_sch_id variable
	
	// Handles instances of the ngl_weighted variable
	if `: list posof "ngl_weighted" in x' != 0 {
		qui: destring ngl_weighted 
		qui: rename ngl_weighted cwgtngl
		la var cwgtngl "Current Year's Weighted NGL Score" 
	} // End of handling of the ngl_weighted variable
	
	// Handles instances of the pr_total variable
	if `: list posof "pr_total" in x' != 0 {
		qui: destring pr_total 
		qui: rename pr_total ctotalpr
		la var ctotalpr "Current Year's Program Review Total Score"
	} // End of handling of the pr_total variable
	
	// Handles instances of the pr_weighted variable
	if `: list posof "pr_weighted" in x' != 0 {
		qui: destring pr_weighted 
		qui: rename pr_weighted cwgtpr
		la var cwgtpr "Current Year's Weighted Program Review Score" 
	} // End of handling of the pr_weighted variable
	
	// Handles instances of the overall variable
	if `: list posof "overall" in x' != 0 {
		qui: destring overall 
		qui: rename overall coverall
		la var coverall "Current Year's Overall Score"
	} // End of handling of the overall variable
	
	// Handles instances of the py_yr_ngl_total variable
	if `: list posof "py_yr_ngl_total" in x' != 0 {
		qui: destring py_yr_ngl_total 
		qui: rename py_yr_ngl_total ptotal 
		la var ptotal "Prior Year's Total Score" 
	} // End of handling of the py_yr_ngl_total variable
	
	// Handles instances of the py_yr_ngl_weighted variable
	if `: list posof "py_yr_ngl_weighted" in x' != 0 {
		qui: destring py_yr_ngl_weighted 
		qui: rename py_yr_ngl_weighted pwgtngl
		la var pwgtngl "Prior Year's Weighted NGL Score" 
	} // End of handling of the py_yr_ngl_weighted variable
	
	// Handles instances of the py_yr_pr_total variable
	if `: list posof "py_yr_pr_total" in x' != 0 {
		qui: destring py_yr_pr_total 
		qui: rename py_yr_pr_total ptotalpr
		la var ptotalpr "Prior Year's Program Review Total Score"
	} // End of handling of the py_yr_pr_total variable
	
	// Handles instances of the py_yr_pr_weighted variable
	if `: list posof "py_yr_pr_weighted" in x' != 0 {
		qui: destring py_yr_pr_weighted 
		qui: rename py_yr_pr_weighted pwgtpr
		la var pwgtpr "Prior Year's Weighted Program Review Score"		
	} // End of handling of the py_yr_pr_weighted variable
	
	// Handles instances of the py_yr_overall variable
	if `: list posof "py_yr_overall" in x' != 0 {
		qui: destring py_yr_overall 
		qui: rename py_yr_overall poverall
		la var poverall "Prior Year's Overall Score"	
	} // End of handling of the py_yr_overall variable
	
	// Handles instances of the  variable
	if `: list posof "" in x' != 0 {
	
	} // End of handling of the  variable
	
	
	if `: list ccrhs in x' != 0 {
		qui: egen ccrmissing = rowmiss(`ccrhs')
		qui: drop if ccrmissing == 8
		drop ccrmissing
		testpk distid schid schyr amogroup
	}

	if `: list ccrms in x' != 0 {
		qui: egen ccrmissing = rowmiss(`ccrms')
		qui: drop if ccrmissing == 6
		drop ccrmissing
	}
	
	if `: list growvars in x' != 0 {
		qui: egen growmiss = rowmiss(`growvars')
		qui: drop if growmiss == 4
		qui: drop growmiss
	}
		
end		



prog def testpk
	syntax varlist [, DISplay ]
	cap isid `varlist'
	if _rc == 0 & `"`display'"' != "" di "Primary Key: `varlist' confirmed."
	else if _rc != 0 di "Primary Key: `varlist' failed."
end	
