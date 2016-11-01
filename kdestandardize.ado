cap prog drop kdestandardize

prog def kdestandardize

	version 14
	
	syntax [, 	DROPVars(string asis) GRade(integer 0) SCHYRLab(integer 0) 	 ///   
				PRIMARYKey(string asis) Metricvars(string asis) ]
	
	// Defines local macro to use to shorten command lengths
	loc rx ustrregexm
	
	// Defines local macro for use with removing records with no data from test files
	loc testlevs tested novice apprentice proficient distinguished
	
	// Defines local macro used to remove records with no data from ccr files
	loc ccrhs diplomas collready caracad cartech cartot nregular pctwobonus pctwbonus
	
	// Defines local macro to test for middle school CCR bench mark null records
	loc ccrms tested msbnchmrkeng msbnchmrkrla msbnchmrkmth msbnchmrksci totmsccrpts
	
	// Defines local macro to test for growth null records
	loc growvars tested grorla gromth groboth
	
	la def kstype -1 "Unknown" 0 "All Students" 1 "Child Care" 				 ///   
					2 "Head Start" 3 "Home" 4 "Other" 5 "State Funded", modify

	// Drop any variables ID'd by user before constructing variable list
	if `"`dropvars'"' != "" cap drop `dropvars'

	// Define value labels that can be applied across files
	{
	
	// Define missing value labels for nbr_tested variable
	la def tested .d "Suppressed due to FERPA Concerns" .s "< 10 Students", modify		
	
	// Define missing value label for NRT percentiles
	la def pctiles .s "***", modify

	// Define value labels for delivery target types
	la def target 1 "Actual Score" 2 "Target" 3 "Numerator" 4 "Denominator"  ///   
	5 "Met Target" 

	// Define grade span level value labels
	la def level 1 "Elementary School" 2 "Middle School" 3 "High School"	 ///   
				 4 "District Average" 5 "State Average", modify
	
	// Define value labels for content area that was tested
	la def content 	1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 		 ///   
					4 "Science" 5 "Social Studies" 6 "Writing" 				 ///   
					7 "Algebra II" 8 "Biology" 9 "English II" 				 ///   
					10 "U.S. History" 11 "Combined Reading and Math", modify
					
	// Define value labels for test names				
	la def testnm 	1 "KPREP" 2 "ACCESS" 3 "ACT" 4 "Explore" 5 "Plan" 		 ///   
					6 "NRT" 7 "PPSAT" 8 "PSAT" 9 "CCR" 10 "CCR Explore", modify	

	// Define value labels for grade levels				
	la def grade -2 "Early Childhood" -1 "Pre-K" 0 "Kindergarten" 			 ///   
				 1 "1st Grade" 2 "2nd Grade"  3 "3rd Grade" 4 "4th Grade" 	 ///   
				 5 "5th Grade" 6 "6th Grade" 7 "7th Grade" 8 "8th Grade" 	 ///   
				 9 "9th Grade" 10 "10th Grade" 11 "11th Grade" 				 ///   
				 12 "12th Grade" 98 "Adult Education" 99 "High School" 		 ///   
				 97 "Magical KDE Undefined Grade" 100 "All Grades" 			 ///   
				 14 "IDEA", modify

	// Define value labels for whether or not AMOs are met			 
	la def amomet 0 "Did not meet AMOs" 1 "Met AMOs", modify

	// Perkins grant goal measures
	la def prknsmeasure 	1 "Academic Attainment - Reading"				 ///   
							2 "Academic Attainment - Mathematics"			 ///   
							3 "Technical Skill Attainment"					 ///   
							4 "Secondary School Completion"					 ///   
							5 "Student Graduation Rate"						 ///   
							6 "Secondary Placement"							 ///   
							7 "Non-Traditional Participation"				 ///   
							8 "Non-Traditional Completion", modify

	// Perkins grant goal status
	la def prknsgoal 		0 "Did Not Meet Perkins Grant Goal"				 ///   
							1 "Met Perkins Grant Goal", modify

	// Define value labels for school classification variable
	la def classification 	1 `"Needs Improvement"'							 ///    
							2 `"Needs Improvement/Progressing"' 			 ///   
							3 `"Proficient/Progressing"' 					 ///   
							4 `"Proficient"' 								 ///   
							5 `"Distinguished/Progressing"' 				 ///    
							6 `"Distinguished"', modify
				 
	// Define value labels for graduation rate goal variable						
	la def met .n "N/A" 0 "No" 1 "Yes", modify
	
	
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

		// Define value labels for other academic indicators
		la def othamo 	0 "Did Not Meet Other Academic Indicator" 			 ///   
						1 "Met Other Academic Indicator"
		
		// Define value labels for participation rates
		la def metpartic .n "N/A" 0 "Did Not Meet Participation Rate Goal"	 ///   
								  1 "Met Participation Rate Goal"
		
		la def ahlev 0 "Needs Improvement" 1 "Proficient" 2 "Distinguished"  ///   
					 .n "N/A"
		la def pllev 0 "Needs Improvement" 1 "Proficient" 2 "Distinguished"  ///   
					 .n "N/A"
		la def k3lev 0 "Needs Improvement" 1 "Proficient" 2 "Distinguished"  ///   
					 .n "N/A"
		la def wrlev 0 "Needs Improvement" 1 "Proficient" 2 "Distinguished"  ///   
					 .n "N/A"
		la def wllev 0 "Needs Improvement" 1 "Proficient" 2 "Distinguished"  ///   
					 .n "N/A"	
		
		// Program Review Target Types
		la def prtargettype 1 "Number Proficient/Distinguished"				 ///   
						2 "Percent Proficient/Distinguished", modify
						
		// Define Equity Measures
		la def eqm	   1 `"Community Support and Involment Composite"'     ///
					   2 `"Managing Student Conduct Composite"'              ///
					   3 `"Overall Effectiveness of School Teachers and Leaders"' ///
					   4 `"Overall Student Growth Rating of Teachers and Leaders"' ///
					   5 `"Percentage of new and Kentucky Teacher Internship Program (KTIP) teachers"' ///
					   6 `"Percentage of Teacher Turnover"'                  ///
					   7 `"School Leadership Composite"', modify

		// Define EQ_LABEL
		la def eqlabel 1 `"Exemplary/Accomplished"'                          ///
					  2 `"High/Expected"'                                    ///
					  3 `"School-Level"'                                     ///
					  4 `"Strongly Agree/Agree"', modify
			
		// Define PROGRAM_TYPE
		la def progtype 1 `"English Learners"'        				         ///
					 2 `"Migrant"'                                           ///
					 3 `"Special Education"'                                 ///
					 4 `"Gifted and Talented"', modify
					 
		// Define RPT_HEADER
		la def rpthdr 1 `"Behavior Events"'                                  ///
					 2 `"Behavior Events by Context"'						 ///
					 3 `"Behavior Events by Grade Level"'                    ///
					 4 `"Behavior Events by Location"' 						 ///
					 5 `"Behavior Events by Socio-Economic Status"'          ///
					 6 `"Discipline Resolutions"'                            ///
					 7 `"Discipline-Resolutions"'                            ///
					 8 `"Legal Sanctions"', modify
					 
					 
		// Define TEACHING_METHOD
		la def pedagogy 1 `"Credit Recovery - Digital Learning Povider"'     ///
					 2 `"Credit Recovery - Direct Instruction"'				 ///
					 3 `"Digital Learning Provider"'						 ///
					 4 `"Direct Instruction"'								 ///
					 5 `"District Provided Self Study"'						 ///
					 6 `"Dual Credit - College Offered"'					 ///
					 7 `"Dual Credit - District Offered"'					 ///
					 8 `"NAF Academy Course"'								 ///
					 9 `"NAF Academy Dual Credit - District Offered"'		 ///
					 10 `"Third Pary Contract"'								 ///
					 11 `"Transitional Course - KDE Curriculum"', modify
					 
		// Define FINANCE_TYPE
		la def fintype 1 `"Financial Summary"'								 ///
					  2 `"Salaries"'										 ///
					  3 `"Seek"'											 ///
					  4 `"Tax"'												 ///   
					  5 `"Revenues & Expenditures"', modify
					  
		// Define CAREER_PATHWAY_DESC
		la def path 1 `"ADMINISTRATION SUPPORT"'         					 ///
				   2 `"AGRIBIOTECHNOLOGY"'									 ///
				   3 `"ANIMAL SYSTEMS"'						 			     ///
				   4 `"BUSINESS TECHNOLOGY"'								 ///
				   5 `"COMPUTER PROGRAMMING"'								 ///
				   6 `"CONSUMER AND FAMILY MANAGEMENT"'					 	 ///
				   7 `"FINANCE"'											 ///
				   8 `"HORTICULTURE AND PLANT SERVICES"'					 ///
				   9 `"INFORMATION SUPPORT AND SERVICES"'		 			 ///
				   10 `"TECHNOLOGY"', modify
				   
		la def coop 0 "CKEC" 1 "GRREC" 2 "JEFF CO" 3 "KEDC" 4 "KVEC" 		 ///   
					5 "NKCES" 6 "OVEC" 7 "SESC" 8 "WKEC", modify
			
		// Define PERFORMANCE_TYPE
		la def ptype 0 `"Points"' 1 `"NAPD Calculation"', modify
					
		// Define ASSESSMENT_LEVEL
		la def assesslev 0 `"Kentucky"' 1 `"Nation"', modify
					
		// Value label for the acct_type variable			
		la def accttype 0 "GAP" 1 "Non-Duplicated Gap Group", modify				
						
		// Define PERFORMANCE_MEASURE
		la def pmsr 1 `"Academic Attainment - Mathematics - 1S2"'       	 ///
				   2 `"Academic Attainment - Reading - 1S1"'				 ///
				   3 `"Non-Traditional Completion - 6S2"'	 			     ///
				   4 `"Non-Traditional Participation - 6S1"'				 ///
				   5 `"Secondary Placement - 5S1"'							 ///
				   6 `"Secondary School Completion - 3S1"'					 ///
				   7 `"Student Graduation Rate - 4S1"'						 ///
				   8 `"Technical Skill Attainment - 2S1"', modify
				   
	   // Define COHORT_TYPE
	   la def cohort 2 `"FIVE YEAR"' 1 `"FOUR YEAR"', modify

	}  // End of value label definitions
	
	// Create local to store variables that need to be recast at end of program
	loc torecast 
	
	// Get the list of variable names
	qui: ds
	
	// Store variable names in a local that can persist across commands
	loc x `r(varlist)'
		
	// Handles instances of the sch_year variable	
	if `: list posof "sch_year" in x' != 0 { 
		qui: replace sch_year = substr(sch_year, 5, 8)
		qui: rename sch_year schyr
		loc torecast `torecast' schyr
		la var schyr "School Year"
	} // End handling of the sch_year variable
		
	// Handles instances of the sch_cd variable 	
	if `: list posof "sch_cd" in x' != 0 { 
		qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
		qui: rename sch_cd schid
		la var schid "Unique School ID"	
	}
	
	// Handles instances of the dist_number variable in a file
	if `: list posof "dist_number" in x' != 0 {  
		qui: replace dist_number = substr(schid, 1, 3) if mi(dist_number)
		qui: rename dist_number distid
		la var distid "District ID"
	}
	
	// Handles instances of the sch_number variable in a file
	if `: list posof "sch_number" in x' != 0 { 
		qui: replace sch_number = substr(schid, 4, 6) if mi(sch_number)
		qui: rename sch_number schnum
		la var schnum "Non-Unique School ID"
	}
	
	// Handles files that have AMO disaggregation groups in the variable list
	if 	`: list posof "disagg_label" in x' != 0 & 							 ///   
		`: list posof "disagg_order" in x' != 0 {
		
		// Calls external routine with logic/rules for handling these business 
		// rules/logic
		qui: amogroup, la(disagg_label) lan(amogroup)	
		
		qui: drop disagg_order
		
	} // End Handling of disagg_label and disagg_order variables
	
	// Handles files that have AMO disaggregation groups in the variable list
	if 	`: list posof "disagg_label" in x' != 0 & 							 ///   
		`: list posof "disagg_order" in x' == 0 {
	
		// Calls external routine with logic/rules for handling these business 
		// rules/logic
		qui: amogroup, la(disagg_label) lan(amogroup)	
	
	}
	
	// Handles the content_level variable
	if `: list posof "content_level" in x' != 0 { 
		loc cl content_level
		qui: replace content_level = cond(`rx'(`cl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`cl', "mid.*", 1) == 1, "2",  ///   
									 cond(`rx'(`cl', "high.*", 1) == 1, "3", ///   
									 cond(`rx'(`cl', "dist.*", 1) == 1, "4", "5"))))
		qui: rename content_level level
		loc torecast `torecast' level
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
							 cond(test_type == "PPSAT", "7", 				 ///   
							 cond(test_type == "PSAT", "8", 				 ///   
							 cond(test_type == "CCR", "9", 					 ///   
							 cond(test_type == "CCR EXPLORE", "10", "")))))))))) 
							 
		// Handles missing test name in 2011-2012 file
		qui: replace test_type = "10" if mi(test_type) & ustrregexm(schyr, "2012$")
		
		// Renames the test_type variable
		qui: rename test_type testnm
		
		// Stores variable to be recast later
		loc torecast `torecast' testnm
		
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
									cond(`ct' == "English II", "9", 		 ///   
									cond(`ct' == "Combined Reading and Math", "11", "10"))))))))))
									
		// Renames the variable							
		qui: rename content_type content
		
		loc torecast `torecast' content
		
		// Applies a variable label to the variable
		la var content "Subject Area"
		
	} // End handling of the content_type variable
	
	// Handles instances of the nbr_tested variable
	if `: list posof "nbr_tested" in x' != 0 {
	
		// Renames variable 
		rename nbr_tested tested
	
		// Removes commas from the number tested variable
		qui: replace tested = subinstr(tested, ",", "", .)

		// Recodes different missing value codes
		qui: replace tested = cond(tested == "---", ".d", 					 ///   
							  cond(tested == "***", ".s", 					 ///   
							  cond(tested == "N/A", ".n", tested)))
								  
		loc torecast `torecast' tested
		
		// Applies a variable label to the variable
		la var tested "# of Students Tested" 
		
	} // End handling of the nbr_tested variable
	
	// Handles instances of the grade variable
	if `: list posof "grade" in x' != 0 {
		qui: replace grade = "99" if grade == "EO"
		qui: replace grade = ustrregexra(grade, "[gG][rR][aA][dD][eE] ", "")
		qui: replace grade = cond(grade == "K", "0", cond(grade == "00", "97", grade))
		qui: replace grade = "100" if mi(grade) & inlist(schyr, 2012, 2013) & ///   
		`: list posof "two_or_more_race_male_cnt" in x' != 0
		loc torecast `torecast' grade
		la var grade "Grade Level" 
	}
	
	// Handles instances of the grade_level variable
	if `: list posof "grade_level" in x' != 0 {
		rename grade_level grade
		qui: replace grade = "15" if grade == "EO"
		qui: replace grade = ustrregexra(grade, "[gG][rR][aA][dD][eE] ", "")
		qui: replace grade = cond(grade == "K", "0", cond(grade == "00", "97", grade))
		loc torecast `torecast' grade
		la var grade "Grade Level" 
	}
	
	// If grade_level doesn't exist in the file
	else {
		if `grade' != 0 {
			qui: g grade = "`grade'"
			loc torecast `torecast' grade
			la var grade "Grade Level" 
		}
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
		
		loc torecast `torecast' reward
		
		// Applies variable label to the reward variable
		la var reward "Differentiated Accountability Reward Status"

	} // End handling of reward_recognition variable
	
	// Handles instances of the  variable
	if `: list posof "pct_novice" in x' != 0 {
		qui: rename pct_novice novice
		qui: replace novice = ".n" if novice == "N/A"
		loc torecast `torecast' novice
		la var novice "% of Students Scoring Novice"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_apprentice" in x' != 0 {
		qui: rename pct_apprentice apprentice
		qui: replace apprentice = ".n" if apprentice == "N/A"
		loc torecast `torecast' apprentice
		la var apprentice "% of Students Scoring Apprentice"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_proficient" in x' != 0 {
		qui: rename pct_proficient proficient
		qui: replace proficient = ".n" if proficient == "N/A"
		loc torecast `torecast' proficient
		la var proficient "% of Students Scoring Proficient"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_distinguished" in x' != 0 {
		qui: rename pct_distinguished distinguished
		qui: replace distinguished = ".n" if distinguished == "N/A"
		loc torecast `torecast' distinguished
		la var distinguished "% of Students Scoring Distinguished"
	} // End of handling of the  variable
	
	if `: list posof "pct_proficient_distinguished" in x' != 0 {
		qui: rename pct_proficient_distinguished profdist
		qui: replace profdist = ".n" if profdist == "N/A"
		loc torecast `torecast' profdist
		la var profdist "% of Students Scoring Proficient or Distinguished"
	} // End of handling of the  variable
	
	if `: list posof "pct_bonus" in x' != 0 {
		rename pct_bonus napdbonus
		loc torecast `torecast' napdbonus
		la var napdbonus "% Points added to the NAPD calculation if # distinguished > # novice"
	}	

	
	// Handles dropping records containing no test data if file contains test data
	if `: list testlevs in x' != 0 {
		qui: egen testmiss = rowmiss(tested novice apprentice proficient distinguished)
		qui: drop if testmiss == 5
		qui: drop testmiss
	} // End of handling of null records
			loc torecast `torecast' 

	// Handles instances of the participation_next_yr variable
	if `: list posof "participation_next_yr" in x' != 0 {
		
		// Short hand reference for the variable
		rename participation_next_yr nextpartic
		qui: replace nextpartic = ".n" if nextpartic == "N/A"
		
		// Use numeric encodings for participation rate field
		qui: replace nextpartic = cond(nextpartic == "No", "0", cond(nextpartic == "Yes", "1", ""))
		
		la copy met nextpartic
		
		loc torecast `torecast' nextpartic
		
		la var nextpartic "KDE did not document the meaning of this variable"
	
	} // End of handling of the participation_next_yr variable
	
	// Handles instances of the graduation_rate_goal variable
	if `: list posof "graduation_rate_goal" in x' != 0 {
	
		// Create shorthand reference for variable
		rename graduation_rate_goal gradgoal
	
		// Use numeric encodings for graduation rate goal field									 
		qui: replace gradgoal = cond(gradgoal == "N/A", ".n",				 ///   
							 cond(gradgoal == "No", "0",					 ///   
							 cond(gradgoal == "Yes", "1", "")))
							 
		la copy met gradgoal
		
		loc torecast `torecast' gradgoal
		
		// Label the variable
		la var gradgoal "Graduation Rate Goal"
							 
	} // End of handling of the graduation_rate_goal variable
	
	// Handles instances of the base_yr_score variable
	if `: list posof "base_yr_score" in x' != 0 {
	
		// Create shorthand reference for variable
		rename base_yr_score baseline
	
		// Replace all instances of -R with missing value in base year score						
		qui: replace baseline = subinstr(baseline, "-R", "", .)	
		
		loc torecast `torecast' baseline
		
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

		loc torecast `torecast' `cv'
							
		// Defines variable label for the variable					
		la var classification "Differentiated Accountability Status Indicator"
							
	} // End of handling of the classification variable
	
	// Handles instances of the overall_score variable
	if `: list posof "overall_score" in x' != 0 {
		qui: rename overall_score overall
		loc torecast `torecast' overall
		la var overall "Overall Points in Accountability Model"
	} // End of handling of the overall_score variable
	
	// Handles instances of the ky_rank variable
	if `: list posof "ky_rank" in x' != 0 {
		qui: rename ky_rank rank 
		loc torecast `torecast' rank
		la var rank "Rank of Schools/Districts Across the State"
	} // End of handling of the ky_rank variable
	
	// Handles instances of the gain_needed variable
	if `: list posof "gain_needed" in x' != 0 {
		qui: rename gain_needed amogain
		qui: replace amogain = strofreal(real(amo_goal) - real(baseline)) if ///   
		mi(amogain) & !mi(real(amo_goal)) & !mi(baseline)
		loc torecast `torecast' amogain
		la var amogain "Gain Needed to meet AMOs"
	} // End of handling of the gain_needed variable
	
	// Handles instances of the amo_goal variable
	if `: list posof "amo_goal" in x' != 0 {
		qui: rename amo_goal amogoal 
		qui: replace amogoal = strofreal(real(baseline) + real(amogain)) if  ///   
		mi(amogoal) & !mi(baseline) & !mi(amogain)
		loc torecast `torecast' amogoal
		la var amogoal "Annual Measureable Objectives Goal"
	} // End of handling of the amo_goal variable	
	
	// Handles instances of the amo_met variable
	if `: list posof "amo_met" in x' != 0 {
		rename amo_met amomet
		qui: replace amomet = 	cond(amomet == "No", "0", 					 ///   
								cond(amomet == "Yes", "1", ""))
		qui: destring amomet, replace ignore("*,-R %$")
		qui: replace amomet = cond(mi(amogoal), .,							 ///   
							  cond(mi(amomet) & overall >= amogoal, 1,		 ///   
							  cond(mi(amomet) & overall < amogoal, 0, amomet)))
		la val amomet amomet
		la var amomet "AMO Status Indicator"
	} // End of handling of the amo_met variable
	
	// Handles instances of the distnm variable
	if `: list posof "dist_name" in x' != 0 {
		qui: rename dist_name distnm
		qui: replace distnm = "Kentucky" if ustrregexm(sch_name, "state", 1)
		
		// Checks if the same school has multiple names
		qui: egen undistnms = nvals(distnm), by(schid)
		
		// Sort by school id in ascending order and school year in descending order
		gsort schid - schyr
		
		// Replace other names with most recent name if school had multiple names
		qui: replace distnm = distnm[_n - 1] if undistnms > 1 &				 ///   
		distnm[_n - 1] != distnm & schid[_n - 1] == schid
		
		drop undistnms
		
		la var distnm "District Name"
	} // End of handling of the distnm variable
	
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
		qui: replace coop = cond(coop == "CKEC", "0", 						 ///   
							cond(coop == "GRREC", "1",						 ///   
							cond(coop == "JEFF CO", "2", 					 ///   
							cond(coop == "KEDC", "3",						 ///   
							cond(coop == "KVEC", "4",						 ///   
							cond(coop == "NKCES", "5",						 ///   
							cond(coop == "OVEC", "6",						 ///   
							cond(coop == "SESC", "7",						 ///   
							cond(coop == "WKEC", "8", "")))))))))
		loc torecast `torecast' coop
		la var coop "Cooperative Name"
	} // End of handling of the coop variable
	
	// Handles instances of the ncesid variable
	if `: list posof "ncesid" in x' != 0 {
		if `: list posof "nces_cd" in x' != 0 {
			qui: replace ncesid = nces_cd if mi(ncesid) & !mi(nces_cd)
			qui: replace ncesid = ncesid + "00000" if length(ncesid) == 7
			qui: bysort schyr (schid): replace ncesid = ncesid[_n - 1] if 	 ///   
			mi(ncesid) & substr(schid, -3, 3) == "999"
			drop nces_cd
		}
		qui: g leaid = substr(ncesid, 1, 7)
		la var leaid "National Center for Educational Statistics LEA ID"
		la var ncesid "National Center for Educational Statistics School ID"
	} // End of handling of the ncesid variable
	
	// Handles instances of the nbr_graduates_with_diploma variable
	if `: list posof "nbr_graduates_with_diploma" in x' != 0 {
		qui: rename nbr_graduates_with_diploma diplomas
		loc torecast `torecast' diplomas
		la var diplomas "# of Students Graduating with Regular High School Diplomas"
	
	} // End of handling of the nbr_graduates_with_diploma variable
	
	// Handles instances of the college_ready variable
	if `: list posof "college_ready" in x' != 0 {
		qui: rename college_ready collready
		loc torecast `torecast' collready
		la var collready "# of College Ready Students" 	
	} // End of handling of the college_ready variable
	
	// Handles instances of the career_ready_academic variable
	if `: list posof "career_ready_academic" in x' != 0 {
		qui: rename career_ready_academic caracad 
		loc torecast `torecast' caracad
		la var caracad "# of Career Ready Students (Academic)" 	
	} // End of handling of the career_ready_academic variable
	
	// Handles instances of the career_ready_technical variable
	if `: list posof "career_ready_technical" in x' != 0 {
		qui: rename career_ready_technical cartech
		loc torecast `torecast' cartech
		la var cartech "# of Career Ready Students (Technical)" 	
	} // End of handling of the career_ready_technical variable
	
	// Handles instances of the career_ready_total variable
	if `: list posof "career_ready_total" in x' != 0 {
		qui: rename career_ready_total cartot
		loc torecast `torecast' cartot
		la var cartot "# of Career Ready Students (Total)" 	
	} // End of handling of the career_ready_total variable
	
	// Handles instances of the nbr_ccr_regular variable
	if `: list posof "nbr_ccr_regular" in x' != 0 {
		qui: rename nbr_ccr_regular nccr
		loc torecast `torecast' nccr
		la var nccr "Number Regular College/Career Ready"
	} // End of handling of the nbr_ccr_regular variable
	
	// Handles instances of the pct_ccr_no_bonus variable
	if `: list posof "pct_ccr_no_bonus" in x' != 0 {
		qui: rename pct_ccr_no_bonus pctwobonus
		loc torecast `torecast' pctwobonus
		la var pctwobonus "% College/Career Ready w/o Bonus"
	} // End of handling of the pct_ccr_no_bonus variable
	
	// Handles instances of the pct_ccr_with_bonus variable
	if `: list posof "pct_ccr_with_bonus" in x' != 0 {
		qui: rename pct_ccr_with_bonus pctwbonus	
		loc torecast `torecast' pctwbonus
		la var pctwbonus "% College/Career Ready w/ Bonus"
	} // End of handling of the pct_ccr_with_bonus variable
	
	// Handles instances of the total_points variable
	if `: list posof "total_points" in x' != 0 {
		qui: rename total_points totpts	
		loc torecast `torecast' totpts
		la var totpts "Total Points"
	} // End of handling of the total_points variable
	
	// Handles instances of the napd_calculation variable
	if `: list posof "napd_calculation" in x' != 0 {
		qui: replace napd_calculation = ".n" if napd_calculation == "N/A"
		qui: rename napd_calculation napd	
		loc torecast `torecast' napd
		la var napd "Novice * 0 + Apprentice + 0.5 + Proficient + Distinguished"
	} // End of handling of the napd_calculation variable
	
	// Handles instances of the reading_pct variable
	if `: list posof "reading_pct" in x' != 0 {
		qui: rename reading_pct grorla
		loc torecast `torecast' grorla
		la var grorla "% of Students Meeting Growth in Reading"
	} // End of handling of the reading_pct variable
	
	// Handles instances of the math_pct variable
	if `: list posof "math_pct" in x' != 0 {
		qui: rename math_pct gromth
		loc torecast `torecast' gromth
		la var gromth "% of Students Meeting Growth in Math"
	} // End of handling of the math_pct variable
	
	// Handles instances of the reading_math_pct variable
	if `: list posof "reading_math_pct" in x' != 0 {
		qui: rename reading_math_pct groboth
		loc torecast `torecast' groboth
		la var groboth "% of Students Meeting Growth in Reading AND Math"
	} // End of handling of the reading_math_pct variable
	
	// Handles instances of the latitude variable
	if `: list posof "latitude" in x' != 0 {
		qui: g double lat = real(ustrregexra(latitude, "[\t\r\n\s ]+", ""))
		la var lat "Latitude"
		drop latitude
	} // End of handling of the latitude variable
	
	// Handles instances of the longitude variable
	if `: list posof "longitude" in x' != 0 {
		qui: g double lon = real(ustrregexra(longitude, "[\t\r\n\s ]+", ""))
		la var lon "Longitude"
		drop longitude
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
		loc torecast `torecast' `st'
		la var `st' "School Type Classification"
	} // End of handling of the sch_type variable
	
	// Handles instances of the achievement_points variable
	if `: list posof "achievement_points" in x' != 0 {
		qui: rename achievement_points achievepts
		loc torecast `torecast' achievepts
		la var achievepts "Achievement Points"	
	} // End of handling of the achievement_points variable
	
	// Handles instances of the achievement_score variable
	if `: list posof "achievement_score" in x' != 0 {
		qui: rename achievement_score achievesc
		loc torecast `torecast' achievesc
		la var achievesc "Achievement Score"
	} // End of handling of the achievement_score variable
	
	// Handles instances of the gap_points variable
	if `: list posof "gap_points" in x' != 0 {
		qui: rename gap_points gappts
		loc torecast `torecast' gappts
		la var gappts "Gap Points"
	} // End of handling of the gap_points variable
	
	// Handles instances of the gap_score variable
	if `: list posof "gap_score" in x' != 0 {
		qui: rename gap_score gapsc
		loc torecast `torecast' gapsc
		la var gapsc "Gap Score" 
	} // End of handling of the gap_score variable
	
	// Handles instances of the growth_points variable
	if `: list posof "growth_points" in x' != 0 {
		qui: rename growth_points growthpts
		loc torecast `torecast' growthpts
		la var growthpts "Growth Points" 
	} // End of handling of the growth_points variable
	
	// Handles instances of the growth_score variable
	if `: list posof "growth_score" in x' != 0 {
		qui: rename growth_score growthsc
		loc torecast `torecast' growthsc
		la var growthsc "Growth Score" 
	} // End of handling of the growth_score variable
	
	// Handles instances of the ccr_points variable
	if `: list posof "ccr_points" in x' != 0 {
		qui: rename ccr_points ccrpts
		loc torecast `torecast' ccrpts
		la var ccrpts "College/Career Readiness Points" 
	} // End of handling of the ccr_points variable
	
	// Handles instances of the ccr_score variable
	if `: list posof "ccr_score" in x' != 0 {
		qui: rename ccr_score ccrsc
		loc torecast `torecast' ccrsc
		la var ccrsc "College/Career Readiness Score"
	} // End of handling of the ccr_score variable
	
	// Handles instances of the graduation_points variable
	if `: list posof "graduation_points" in x' != 0 {
		qui: rename graduation_points gradpts 
		loc torecast `torecast' gradpts
		la var gradpts "Graduation Rate Points" 
	} // End of handling of the graduation_points variable
	
	// Handles instances of the graduation_score variable
	if `: list posof "graduation_score" in x' != 0 {
		qui: rename graduation_score gradsc
		loc torecast `torecast' gradsc
		la var gradsc "Graduation Rate Score" 
	} // End of handling of the graduation_score variable
	
	// Handles instances of the weighted_summary variable
	if `: list posof "weighted_summary" in x' != 0 {
		qui: rename weighted_summary wgtsum
		loc torecast `torecast' wgtsum
		la var wgtsum "Weighted Summary" 
	} // End of handling of the weighted_summary variable
	
	// Handles instances of the state_sch_id variable
	if `: list posof "state_sch_id" in x' != 0 {
		qui: rename state_sch_id stschid
		loc torecast `torecast' stschid
		la var stschid "State Assigned School ID Number" 
	} // End of handling of the state_sch_id variable
	
	// Handles instances of the ngl_weighted variable
	if `: list posof "ngl_weighted" in x' != 0 {
		qui: rename ngl_weighted cwgtngl
		loc torecast `torecast' cwgtngl
		la var cwgtngl "Current Year's Weighted NGL Score" 
	} // End of handling of the ngl_weighted variable
	
	// Handles instances of the pr_total variable
	if `: list posof "pr_total" in x' != 0 {
		qui: rename pr_total ctotalpr
		loc torecast `torecast' ctotalpr
		la var ctotalpr "Current Year's Program Review Total Score"
	} // End of handling of the pr_total variable
	
	// Handles instances of the pr_weighted variable
	if `: list posof "pr_weighted" in x' != 0 {
		qui: rename pr_weighted cwgtpr
		loc torecast `torecast' cwgtpr
		la var cwgtpr "Current Year's Weighted Program Review Score" 
	} // End of handling of the pr_weighted variable
	
	// Handles instances of the overall variable
	if `: list posof "overall" in x' != 0 {
		qui: rename overall coverall
		loc torecast `torecast' coverall
		la var coverall "Current Year's Overall Score"
	} // End of handling of the overall variable
	
	// Handles instances of the py_yr_ngl_total variable
	if `: list posof "py_yr_ngl_total" in x' != 0 {
		qui: rename py_yr_ngl_total ptotal 
		loc torecast `torecast' ptotal
		la var ptotal "Prior Year's Total Score" 
	} // End of handling of the py_yr_ngl_total variable
	
	// Handles instances of the py_yr_ngl_weighted variable
	if `: list posof "py_yr_ngl_weighted" in x' != 0 {
		qui: rename py_yr_ngl_weighted pwgtngl
		loc torecast `torecast' pwgtngl
		la var pwgtngl "Prior Year's Weighted NGL Score" 
	} // End of handling of the py_yr_ngl_weighted variable
	
	// Handles instances of the py_yr_pr_total variable
	if `: list posof "py_yr_pr_total" in x' != 0 {
		qui: rename py_yr_pr_total ptotalpr
		loc torecast `torecast' ptotalpr
		la var ptotalpr "Prior Year's Program Review Total Score"
	} // End of handling of the py_yr_pr_total variable
	
	// Handles instances of the py_yr_pr_weighted variable
	if `: list posof "py_yr_pr_weighted" in x' != 0 {
		qui: rename py_yr_pr_weighted pwgtpr
		loc torecast `torecast' pwgtpr
		la var pwgtpr "Prior Year's Weighted Program Review Score"		
	} // End of handling of the py_yr_pr_weighted variable
	
	// Handles instances of the py_yr_overall variable
	if `: list posof "py_yr_overall" in x' != 0 {
		qui: rename py_yr_overall poverall
		loc torecast `torecast' poverall
		la var poverall "Prior Year's Overall Score"	
	} // End of handling of the py_yr_overall variable
	
	// Handles instances of the  variable
	if `: list posof "stdnt_tested_cnt" in x' != 0 {
		
		// Standardizes the name of the variable
		qui: rename stdnt_tested_cnt tested
		
		qui: replace tested = 	cond(tested == "---", ".d", 				 ///   
								cond(tested == "***", ".s", 				 ///   
								cond(tested == "N/A", ".n", tested)))
		
		loc torecast `torecast' tested
		
		// Applies a variable label to the variable
		la var tested "# of Students Tested" 
		
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_mean_score" in x' != 0 {
		qui: rename english_mean_score actengsc
		loc torecast `torecast' actengsc
		la var actengsc "ACT Average English Score"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_bnchmrk_pct" in x' != 0 {
		qui: rename english_bnchmrk_pct actengpct
		loc torecast `torecast' actengpct
		la var actengpct "% of Students Meeting ACT English Benchmark"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "mathematics_mean_score" in x' != 0 {
		qui: rename mathematics_mean_score actmthsc
		loc torecast `torecast' actmthsc
		la var actmthsc "ACT Average Mathematics Score"
	} // End of handling of the  variable
	
	// Handles instances of the mathematics_bnchmrk_pct variable
	if `: list posof "mathematics_bnchmrk_pct" in x' != 0 {
		qui: rename mathematics_bnchmrk_pct actmthpct
		loc torecast `torecast' actmthpct
		la var actmthpct "% of Students Meeting ACT Mathematics Benchmark"
	} // End of handling of the mathematics_bnchmrk_pct variable
	
	// Handles instances of the math_bnchmrk_pct variable
	if `: list posof "math_bnchmrk_pct" in x' != 0 {
		qui: rename math_bnchmrk_pct actmthpct
		loc torecast `torecast' actmthpct
		la var actmthpct "% of Students Meeting ACT Mathematics Benchmark"
	} // End of handling of the math_bnchmrk_pct variable
	
	// Handles instances of the reading_mean_score variable
	if `: list posof "reading_mean_score" in x' != 0 {
		qui: rename reading_mean_score actrlasc
		loc torecast `torecast' actrlasc
		la var actrlasc "ACT Average Reading Score"
	} // End of handling of the reading_mean_score variable
	
	// Handles instances of the reading_bnchmrk_pct variable
	if `: list posof "reading_bnchmrk_pct" in x' != 0 {
		qui: rename reading_bnchmrk_pct actrlapct
		loc torecast `torecast' actrlapct
		la var actrlapct "% of Students Meeting ACT Reading Benchmark"
	} // End of handling of the reading_bnchmrk_pct variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_mean_score" in x' != 0 {
		qui: rename science_mean_score actscisc
		loc torecast `torecast' actscisc
		la var actscisc "ACT Average Science Score"
	} // End of handling of the science_mean_score variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_bnchmrk_pct" in x' != 0 {
		qui: rename science_bnchmrk_pct actscipct
		loc torecast `torecast' actscipct
		la var actscipct "% of Students Meeting ACT Science Benchmark"
	} // End of handling of the science_mean_score variable
	
	// Handles instances of the composite_mean_score variable
	if `: list posof "composite_mean_score" in x' != 0 {
		qui: rename composite_mean_score actcmpsc
		loc torecast `torecast' actcmpsc
		la var actcmpsc "ACT Average Composite Score"
	} // End of handling of the composite_mean_score variable
	
	// Handles instances of the stdnt_tested_bnchmrk_cnt variable
	if `: list posof "stdnt_tested_bnchmrk_cnt" in x' != 0 {
		qui: rename stdnt_tested_bnchmrk_cnt bnchmrktested
		loc torecast `torecast' bnchmrktested
		// Need to verify the contents of this data element
		la var bnchmrktested "# of Students Tested for Benchmark"
	} // End of handling of the stdnt_tested_bnchmrk_cnt variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_rate" in x' != 0 {
		qui: rename attendance_rate adarate
		qui: replace adarate = ustrregexra(adarate, "\D", "")
		loc torecast `torecast' adarate
		la var adarate "Average Daily Attendance Rate"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_target" in x' != 0 {
		qui: rename attendance_target adagoal
		loc torecast `torecast' adagoal
		la var adagoal "Average Daily Attendance Rate Target"
	} // End of handling of the  variable
	
	// Handles instances of the met_academic_ind variable
	if `: list posof "met_academic_ind" in x' != 0 {
		qui: rename met_academic_ind othamo
		qui: replace othamo = 	cond(othamo == "No", "0", 					 ///   
								cond(othamo == "Yes", "1", ""))
		loc torecast `torecast' othamo
		la var othamo "Annual Measurable Objectives - Other Academic Indicator"
	} // End of handling of the met_academic_ind variable
	
	// Handles instances of the number_enrolled variable
	if `: list posof "number_enrolled" in x' != 0 {
		qui: rename number_enrolled membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "# of Students Enrolled"
	} // End of handling of the  variable

	if `: list posof "membership" in x' != 0 {
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "# of Students Enrolled"
	} // End of handling of the  variable

	
	// Handles instances of the number_tested variable
	if `: list posof "number_tested" in x' != 0 {
		qui: rename number_tested tested 
		qui: replace tested = ".n" if tested == "N/A"
		loc torecast `torecast' tested
		la var tested "# of Students Tested"
	} // End of handling of the number_tested variable
	
	// Handles instances of the participation_rate variable
	if `: list posof "participation_rate" in x' != 0 {
		qui: rename participation_rate partic 
		qui: replace partic = ".n" if partic == "N/A"
		loc torecast `torecast' partic
		la var partic "Participation Rate"
	} // End of handling of the participation_rate variable
	
	// Handles instances of the particip_rate variable
	if `: list posof "particip_rate" in x' != 0 {
		qui: rename particip_rate partic 
		qui: replace partic = ".n" if partic == "N/A"
		loc torecast `torecast' partic
		la var partic "Participation Rate"
	} // End of handling of the particip_rate variable
	
	// Handles instances of the met_participation_rate variable
	if `: list posof "met_participation_rate" in x' != 0 {
		qui: rename met_participation_rate metpartic
		qui: replace metpartic = 	cond(metpartic == "N/A", ".n", 			 ///   
									cond(metpartic == "No", "0",			 ///   
									cond(metpartic == "Yes", "1", "")))
		loc torecast `torecast' metpartic
		la var metpartic "Participation Rate Status"
	} // End of handling of the met_participation_rate variable
	
		// Handles instances of the Program Review Summative Variables
	if `: list posof "progrev_total_points" in x' != 0 {
		rename (progrev_total_points progrev_total_score)(totpts totscore)
		foreach v of var totpts totscore {
			qui: replace `v' = ".n" if `v' == "N/A"
		}
		loc torecast `torecast' totpts totscore
		la var totpts "Total Points"
		la var totscore "Total Score"
	} // Ends handling of the Program Review Summative Variables
	
	// Handles instances of the Arts & Humanities Program Review variables
	if `: list posof "ah_total_points" in x' != 0 {
		qui: rename (ah_curr_and_inst ah_form_and_summ ah_profdev_and_sup 	 ///   
		ah_admin_and_sup ah_total_points ah_classification)(ahcia ahassess	 ///   
		ahprofdev ahadmin ahtotpts ahlev)
		foreach v of var ahcia ahassess ahprofdev ahadmin ahtotpts {
			qui: replace `v' = ".n" if `v' == "N/A"
		}	
		qui: replace ahlev = 	cond(ahlev == "N/A", ".n",					 ///   
								cond(ahlev == "Needs Improvement", "0",		 ///   
								cond(ahlev == "Proficient", "1",			 ///   
								cond(ahlev == "Distinguished", "2", ""))))
		loc torecast `torecast' ahlev ahcia ahassess ahprofdev ahadmin ahtotpts
		la var ahcia "Arts & Humanities Curriculum and Instruction"
		la var ahassess "Arts & Humanities Formative/Summative Assessments"
		la var ahprofdev "Arts & Humanities Professional Development & Support"
		la var ahadmin "Arts & Humanities Administration & Support"
		la var ahtotpts "Arts & Humanities Total Points" 
		la var ahlev "Arts & Humanities Classification Level"
	} // End of handling of the Arts & Humanities Program Review variables
	
	// Handles the Practical Living & Career Studies Program Review variables
	if `: list posof "pl_total_points" in x' != 0 {
		qui: rename (pl_curr_and_inst pl_form_and_summ pl_profdev_and_sup 	 ///   
		pl_admin_and_sup pl_total_points pl_classification)(plcia plassess	 ///   
		plprofdev pladmin pltotpts pllev)
		foreach v of var plcia plassess plprofdev pladmin pltotpts {
			qui: replace `v' = ".n" if `v' == "N/A"
		}	
		qui: replace pllev = 	cond(pllev == "N/A", ".n",					 ///   
								cond(pllev == "Needs Improvement", "0",		 ///   
								cond(pllev == "Proficient", "1",			 ///   
								cond(pllev == "Distinguished", "2", ""))))
		loc torecast `torecast' pllev plcia plassess plprofdev pladmin pltotpts
		la var plcia "Practical Living & Career Studies Curriculum and Instruction"
		la var plassess "Practical Living & Career Studies Formative/Summative Assessments"
		la var plprofdev "Practical Living & Career Studies Professional Development & Support"
		la var pladmin "Practical Living & Career Studies Administration & Support"
		la var pltotpts "Practical Living & Career Studies Total Points" 
		la var pllev "Practical Living & Career Studies Classification Level"
	} // End Practical Living & Career Studies Program Review variables
	
	// Handles instances of the Writing Program Review variables
	if `: list posof "wr_total_points" in x' != 0 {
		qui: rename (wr_curr_and_inst wr_form_and_summ wr_profdev_and_sup 	 ///   
		wr_admin_and_sup wr_total_points wr_classification)(wrcia wrassess	 ///   
		wrprofdev wradmin wrtotpts wrlev)
		foreach v of var wrcia wrassess wrprofdev wradmin wrtotpts {
			qui: replace `v' = ".n" if `v' == "N/A"
		}	
		qui: replace wrlev = 	cond(wrlev == "N/A", ".n",					 ///   
								cond(wrlev == "Needs Improvement", "0",		 ///   
								cond(wrlev == "Proficient", "1",			 ///   
								cond(wrlev == "Distinguished", "2", ""))))
		loc torecast `torecast' wrlev wrcia wrassess wrprofdev wradmin wrtotpts 
		la var wrcia "Writing Curriculum and Instruction"
		la var wrassess "Writing Formative/Summative Assessments"
		la var wrprofdev "Writing Professional Development & Support"
		la var wradmin "Writing Administration & Support"
		la var wrtotpts "Writing Total Points" 
		la var wrlev "Writing Classification Level"
	} // End of handling of the Writing Program Review variables
	
	// Handles instances of the K-3 Program Review variable
	if `: list posof "k3_total_points" in x' != 0 {
		qui: rename (k3_curr_and_inst k3_form_and_summ k3_profdev_and_sup 	 ///   
		k3_admin_and_sup k3_total_points k3_classification)(k3cia k3assess	 ///   
		k3profdev k3admin k3totpts k3lev)
		foreach v of var k3cia k3assess k3profdev k3admin k3totpts {
			qui: replace `v' = ".n" if `v' == "N/A"
		}	
		qui: replace k3lev = 	cond(k3lev == "N/A", ".n",					 ///   
								cond(k3lev == "Needs Improvement", "0",		 ///   
								cond(k3lev == "Proficient", "1",			 ///   
								cond(k3lev == "Distinguished", "2", ""))))
		loc torecast `torecast' k3lev k3cia k3assess k3profdev k3admin k3totpts
		la var k3cia "K-3 Curriculum and Instruction"
		la var k3assess "K-3 Formative/Summative Assessments"
		la var k3profdev "K-3 Professional Development & Support"
		la var k3admin "K-3 Administration & Support"
		la var k3totpts "K-3 Total Points" 
		la var k3lev "K-3 Classification Level"
	} // End of handling of the K-3 Program Review variables
	
	// Handles instances of the World Language Program Review variables
	if `: list posof "wl_total_points" in x' != 0 {
		qui: rename (wl_curr_and_inst wl_form_and_summ wl_profdev_and_sup 	 ///   
		wl_admin_and_sup wl_total_points wl_classification)(wlcia wlassess	 ///   
		wlprofdev wladmin wltotpts wllev)
		foreach v of var wlcia wlassess wlprofdev wladmin wltotpts {
			qui: replace `v' = ".n" if `v' == "N/A"
		}	
		qui: replace wllev = 	cond(wllev == "N/A", ".n",					 ///   
								cond(wllev == "Needs Improvement", "0",		 ///   
								cond(wllev == "Proficient", "1",			 ///   
								cond(wllev == "Distinguished", "2", ""))))
		loc torecast `torecast' wllev wlcia wlassess wlprofdev wladmin wltotpts
		la var wlcia "World Language Curriculum and Instruction"
		la var wlassess "World Language Formative/Summative Assessments"
		la var wlprofdev "World Language Professional Development & Support"
		la var wladmin "World Language Administration & Support"
		la var wltotpts "World Language Total Points" 
		la var wllev "World Language Classification Level"
	} // End of handling of the World Language Program Review variables
	
	// Handles instances of the reading_percentile variable
	if `: list posof "reading_percentile" in x' != 0 {
		qui: rename reading_percentile rlapctile
		qui: replace rlapctile = ".s" if rlapctile == "***"
		loc torecast `torecast' rlapctile
		la var rlapctile "Novice Reduction Reading Percentile"	
	} // End of handling of the reading_percentile variable
	
	// Handles instances of the mathematics_percentile variable
	if `: list posof "mathematics_percentile" in x' != 0 {
		qui: rename mathematics_percentile mthpctile 
		qui: replace mthpctile = ".s" if mthpctile == "***"
		loc torecast `torecast' mthpctile
		la var mthpctile "Novice Reduction Mathematics Percentile"	
	} // End of handling of the mathematics_percentile variable
	
	// Handles instances of the science_percentile variable
	if `: list posof "science_percentile" in x' != 0 {
		qui: rename science_percentile scipctile
		qui: replace scipctile = ".s" if scipctile == "***"
		loc torecast `torecast' scipctile
		la var scipctile "Novice Reduction Science Percentile"	
	} // End of handling of the science_percentile variable
	
	// Handles instances of the social_percentile variable
	if `: list posof "social_percentile" in x' != 0 {
		qui: rename social_percentile socpctile
		qui: replace socpctile = ".s" if socpctile == "***"
		loc torecast `torecast' socpctile
		la var socpctile "Novice Reduction Social Studies Percentile"	
	} // End of handling of the social_percentile variable
	
	// Handles instances of the language_mechanics_percentile variable
	if `: list posof "language_mechanics_percentile" in x' != 0 {
		qui: rename language_mechanics_percentile lanpctile
		qui: replace lanpctile = ".s" if lanpctile == "***"
		loc torecast `torecast' lanpctile
		la var lanpctile "Novice Reduction Language Mechanics Percentile"	
	} // End of handling of the language_mechanics_percentile variable
	
	if `: list posof "totalsenior_enroll" in x' != 0 {
		qui: rename totalsenior_enroll totenrsrs
		loc torecast `torecast' totenrsrs
		la var totenrsrs "Total # of Enrolled Seniors"
	}

	if `: list posof "prepsenior_enroll" in x' != 0 {
		qui: rename prepsenior_enroll prepenrsrs
		loc torecast `torecast' prepenrsrs
		// Need to verify contents of this variable
		la var prepenrsrs "Total # of Seniors Enrolled in Preparatory Program"
	}

	if `: list posof "collegeready" in x' != 0 {
		qui: rename collegeready collready
		loc torecast `torecast' collready
		la var collready "# of College Ready Students"
	}	

	if `: list posof "work_keys" in x' != 0 {
		qui: rename work_keys actwrkkeys
		loc torecast `torecast' actwrkkeys
		la var actwrkkeys "# of Students Scoring  on ACT WorkKeys"
	}	

	if `: list posof "asvab" in x' != 0 {
		loc torecast `torecast' asvab
		la var asvab "# of Students Scoring  or Higher on the ASVAB"
	}	

	if `: list posof "ind_certs" in x' != 0 {
		qui: rename ind_certs industrycert
		loc torecast `torecast' industrycert
		la var industrycert "# of Students Passing Industry Certification Exams"
	}	
	
	if `: list posof "kossa" in x' != 0 {
		loc torecast `torecast' kossa
		la var kossa "# of Students Score or Higher on the KOSSA Exam"
	}	

	if `: list posof "cr_total" in x' != 0 {
		qui: rename cr_total cartot
		loc torecast `torecast' cartot
		la var cartot "# of Career Ready Students"
	}	

	if `: list posof "ccr_total" in x' != 0 {
		qui: rename ccr_total nccr
		loc torecast `torecast' nccr
		la var nccr "# of College AND Career Ready Students"
	}	

	if `: list posof "total_ccr_pct" in x' != 0 {
		qui: rename total_ccr_pct pctccr
		loc torecast `torecast' pctccr
		la var pctccr "Total % of College AND Career Ready Students"
	}	 
	
	if `: list posof "performance_measure" in x' != 0 {
		qui: rename performance_measure prknsmeasure
		qui: replace prknsmeasure = cond(regexm(prknsmeasure, "Read"), "1",	 ///   
									cond(regexm(prknsmeasure, "Math"), "2",  ///   
									cond(regexm(prknsmeasure, "Technical"), "3", ///   
									cond(regexm(prknsmeasure, "Scho"), "4",  ///   
									cond(regexm(prknsmeasure, "Grad"), "5",	 ///   
									cond(regexm(prknsmeasure, "Place"), "6", ///   
									cond(regexm(prknsmeasure, "Partic"), "7", ///   
									cond(regexm(prknsmeasure, "Compl"), "8", ""))))))))

		loc torecast `torecast' prknsmeasure
		la var prknsmeasure "Perkins Grant Performance Measures"
	}

	if `: list posof "benchmark_students" in x' != 0 {
		qui: rename benchmark_students bnchmrkprkns
		loc torecast `torecast' bnchmrkprkns
		la var bnchmrkprkns "# of Students in Perkins Grant Benchmarks"
	}	

	if `: list posof "performance_goal" in x' != 0 {
		qui: rename performance_goal prknsgoal
		qui: replace prknsgoal = cond(prknsgoal == "Not Met", "0",			 ///   
								 cond(prknsgoal == "Met", "1", ""))
		loc torecast `torecast' prknsgoal
		la var prknsgoal "Was the Perkins Grant Goal Met?"
	}

	if `: list posof "total_enrollment" in x' != 0 {
		qui: rename total_enrollment membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total # of Students Enrolled"
	}	

	if `: list posof "enrollment" in x' != 0 {
		qui: rename enrollment membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total # of Students Enrolled"
	}	

	// Handles instances of the  variable
	if `: list posof "target_level" in x' != 0 {
		loc tl target_level
		qui: replace target_level = cond(`rx'(`tl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`tl', "mid.*", 1) == 1, "2", "3"))
		qui: rename target_level level
		loc torecast `torecast' level
		la var level "Educational Level" 
	
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "target_type" in x' != 0 {
		qui: rename target_type target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(target == "Numerator", "3",			 ///   
								cond(target == "Denominator", "4",			 ///   
								cond(target == "Met Target", "5", ""))))) 
		loc torecast `torecast' target
		la var target "Accountability Component Targets"

	} // End of handling of the  variable

	// Handles instances of the  variable
	if `: list posof "target_label" in x' != 0 {
		qui: rename target_label target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(ustrregexm(target, ".*numerator.*", 1) == 1, "3",		 ///   
								cond(ustrregexm(target, ".*denominator.*", 1) == 1, "4",	 ///   
								cond(target == "Met Target", "5", "")))))  
		loc torecast `torecast' target
		la var target "Accountability Component Targets"
	} // End of handling of the  variable
	
	if `: list posof "target_label_sort" in x' != 0 drop target_label_sort
			
	if `: list posof "prior_setting" in x' != 0 {
		qui: rename prior_setting kstype
		qui: replace kstype = 	cond(kstype == "Unknown", "-1",				 ///   
						cond(inlist(kstype, "All Students", "Any"), "0",	 ///   
								cond(kstype == "Child Care", "1",			 ///   
								cond(kstype == "Head Start", "2",			 ///   
								cond(kstype == "Home", "3",					 ///   
								cond(kstype == "Other", "4",				 ///   
								cond(kstype == "State Funded", "5", "")))))))
		loc torecast `torecast' kstype
		la var kstype "Kindergarten Screening Prior Setting Type"
	}

	// Kindergarten screening targets by year
	if `: list posof "kscreen_2013" in x' != 0 {
		qui: rename kscreen_# kscreen#
		foreach v of var kscreen* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: drop if inlist(`v', "No", "Yes")
			loc torecast `torecast' `v'
			la var `v' "Kindergarten Readiness Screening Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(kscreen*)
		qui: ds kscreen*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
	}
	
	// Handles Program Review Delivery Targets
	if `: list posof "pr_type" in x' != 0 {
		qui: rename pr_type targettype
		qui: replace targettype = cond(targettype == "NUMBER_PD", "1",		 ///   
									cond(targettype == "PERCENT_PD", "2", ""))
		qui: destring targettype, replace ignore("*,-R %$")
		la val targettype targettype
		la var targettype "Program Review Delivery Target Type"
		qui: rename pr_# progrev#
		foreach v of var progrev* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: replace `v' = cond(`v' == "No", "0", cond(`v' == "Yes", "1", `v'))
			qui: destring `v', replace ignore("*,-R %$")
			la var `v' "Program Review Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(progrev*)
		qui: ds progrev*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
		deltargets, st(progrev) pk(fileid schid schyr) tar(targettype)
		la val met met
		
	}

	if ustrregexm(`"`x'"', "yr_[0-9]{4}") == 1 {
		rename yr_# yr#
		foreach v of var yr???? {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: replace `v' = 	cond(`v' == "Yes", "1", 					 ///   
								cond(`v' == "No", "0", 						 ///   
								cond(`v' == "N/A", ".n", `v')))
			loc torecast `torecast' `v'
			la var `v' "Delivery Target for `yr'"
		}
		qui: egen nullrecord = rowmiss(yr*)
		qui: ds yr*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
	
	}
	
	if ustrregexm(`"`x'"', "ccr_[0-9]{4}") == 1 {
		rename ccr_# ccr#
		foreach v of var ccr???? {
			qui: replace `v' = 	cond(`v' == "Yes", "1", 					 ///   
								cond(`v' == "No", "0", 						 ///   
								cond(`v' == "N/A", ".n", `v')))
			qui: destring `v', replace ignore("*,-R %$")
		}
		qui: egen nullrecord = rowmiss(ccr*)
		qui: ds ccr*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
		qui: g targettype = 2
		deltargets, st(ccr) pk(fileid schid schyr) tar(targettype)

	}
	
	// Handles instances of the EQ_PCT variable
	if `: list posof "eq_pct" in x' != 0 {
		qui: rename eq_pct eqpct
		qui: replace eqpct = ".n" if eqpct == "N/A"
		loc torecast `torecast' eqpct
		la var eqpct "Equity Percent"
	} // End of handling of the EQ_PCT variable
	
	// Handles instances of the  variable EQUITY_MEASURE
	if `: list posof "equity_measure" in x' != 0 {
		
		//Recodes equity measure variable with numeric values
		qui: replace equity_measure = ///   
		cond(equity_measure == `"Community Support and Involvment Composite"', "1", ///
		cond(equity_measure == `"Managing Student Conduct Composite"', "2",  ///
		cond(equity_measure == `"Overall Effectiveness of School Teachers and Leaders"', "3",  ///
		cond(equity_measure == `"Overall Student Growth Rating of Teachers and Leaders"', "4", ///
		cond(equity_measure == `"Percentage of new and Kentucky Teacher Internship Program (KTIP) teachers"', "5", ///
		cond(equity_measure == `"Percentage of teacher turnover"', "6", ///
		cond(equity_measure == `"School Leadership Composite"', "7", "")))))))
		
		//Rename Equity_Measure variable
		qui: rename equity_measure eqm

		loc torecast `torecast' eqm
		
		//Applies variable label to the variable
		la var eqm "Equity Measure"
									
	} // End of handling of the Equity_Measure  variable

	// Handles instances of the EQ_LABEL variable
	if `: list posof "eq_label" in x' != 0 {
		qui: replace eq_label = cond(eq_label == "Exemplary/ Accomplished", "1", ///
								cond(eq_label == "High/Expected", "2",       ///
								cond(eq_label == "School-Level", "3",    	 ///
								cond(eq_label == "Strongly Agree/Agree", "4", "5")))) 
		qui: rename eq_label eqlabel
		qui: destring eqlabel, replace ignore("*,-R %$")
		
		qui: reshape wide eqpct, i(fileid schyr schid eqlabel) j(eqm)
		qui: reshape wide eqpct?, i(fileid schyr schid ) j(eqlabel)
		qui: count
		loc x `= `r(N)''
		foreach v of var eqpct* {
			qui: count if mi(`v')
			if `r(N)' == `x' drop `v'
		}
		qui: rename (eqpct14 eqpct24 eqpct31 eqpct42 eqpct55 eqpct63 eqpct74) ///   
		(csnicomp stdconduct effectivestaff staffsgp pctnewtch pctchurn ldrship)
		
		la var csnicomp "% Agree/Strongly Agree - Community Support/Involvement"
		la var stdconduct "% Agree/Strongly Agree - Managing Student Conduct"
		la var effectivestaff "% Exemplary/Accomplished - Overall Effectiveness"
		la var staffsgp "% Exemplary/Accomplished - Overall Student Growth Rating"
		la var pctnewtch "% New/KTIP Educators"
		la var pctchurn "% School-Level Educator Churn" 
		la var ldrship "% Agree/Strongly Agree - School Leadership Composite"
				
	} // End of handling of the EQ_LABEL variable
	
	if `: list posof "program_label" in x' != 0 {
		amogroup, la(program_label) laname(amogroup)
		qui: drop program_label
	}
	
	// Handles instances of the PROGRAM_TYPE variable
	if `: list posof "program_type" in x' != 0 {
		qui: replace program_type=cond(program_type == "English Language Learners (ELL)", "1", ///
								  cond(program_type == "Migrant", "2",            ///
								  cond(program_type == "Special Education", "3",  ///
								  cond(program_type == "Gifted and Talented", "4", "")))) 
		qui: rename program_type progtype
		loc torecast `torecast' progtype
		la var progtype "Program Type"
	} // End of handling of the PROGRAM_TYPE variable
	
	// Handles instances of the TOTAL_CNT variable
	if `: list posof "total_cnt" in x' != 0 {
		qui: rename total_cnt membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total Student Membership"
	} // End of handling of the TOTAL_CNT variable
	
	// Handles instances of the TOTAL_PCT variable
	if `: list posof "total_pct" in x' != 0 {
		qui: rename total_pct totpct
		loc torecast `torecast' totpct
		la var totpct "Total % of Students"
	} // End of handling of the TOTAL_PCT variable
	
	//Handles instances of the WHITE_CNT variable
	if `: list posof "white_cnt" in x' != 0 {
		qui: rename white_cnt nwhite
		loc torecast `torecast' nwhite
		la var nwhite "# of White Students"
	} // End of handling of the WHITE_CNT variable
	
	//Handles instances of the BLACK_CNT variable
	if `: list posof "black_cnt" in x' != 0 {
		qui: rename black_cnt nblack
		loc torecast `torecast' nblack
		la var nblack "# of Black Students"
	} // End of handling of the BLACK_CNT variable
	
	//Handles instances of the HISPANIC_CNT variable
	if `: list posof "hispanic_cnt" in x' != 0 {
		qui: rename hispanic_cnt nhisp
		loc torecast `torecast' nhisp
		la var nhisp "# of Hispanic/Latino(a) Students"
	} // End of handling of the HISPANIC_CNT variable
	
	//Handles instances of the Asian_CNT variable
	if `: list posof "asian_cnt" in x' != 0 {
		qui: rename asian_cnt nasian
		loc torecast `torecast' nasian
		la var nasian "# of Asian Students"
	} // End of handling of the Asian_CNT variable
	
	//Handles instances of the AIAN_CNT variable
	if `: list posof "aian_cnt" in x' != 0 {
		qui: rename aian_cnt naian
		loc torecast `torecast' naian
		la var naian "# of American Indian/Alaskan Native Students"
	} // End of handling of the AIAN_CNT variable
	
	//Handles instances of the HAWAIIAN_CNT variable
	if `: list posof "hawaiian_cnt" in x' != 0 {
		qui: rename hawaiian_cnt npacisl
		loc torecast `torecast' npacisl
		la var npacisl "# of Native Hawaiian/Pacific Islander Students"
	} // End of handling of the HAWAIIAN_CNT variable
	
	//Handles instances of the OTHER_CNT variable
	if `: list posof "other_cnt" in x' != 0 {
		qui: rename other_cnt nmulti
		loc torecast `torecast' nmulti
		la var nmulti "# of Multiracial Students"
	} // End of handling of the OTHER_CNT variable
	
	//Handles instances of the MALE_CNT variable
	if `: list posof "male_cnt" in x' != 0 {
		qui: rename male_cnt nmale
		loc torecast `torecast' nmale
		la var nmale "# of Male Students"
	} // End of handling of the MALE_CNT variable
	
	//Handles instances of the FEMALE_CNT variable
	if `: list posof "female_cnt" in x' != 0 {
		qui: rename female_cnt nfemale
		loc torecast `torecast' nfemale
		la var nfemale "# of Female Students"
	} // End of handling of the FEMALE_CNT variable
	
	//Handles instances of the TOTAL_STDNT_CNT variable
	if `: list posof "total_stdnt_cnt" in x' != 0 {
		qui: rename total_stdnt_cnt membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total Membership"
	} // End of handling of the TOTAL_STDNT_CNT variable
	
	//Handles instances of the TOTAL_UNIQUE_EVENT_CNT variable
	if `: list posof "total_unique_event_cnt" in x' != 0 {
		qui: rename total_unique_event_cnt totevents
		loc torecast `torecast' totevents
		la var totevents "Total Unique Event Count"
	} // End of handling of the TOTAL_UNIQUE_EVENT_CNT variable
	
	//Handles instances of the RPT_HEADER variable
	if `: list posof "rpt_header" in x' != 0 {
		/*
		qui: replace rpt_header = cond(rpt_header == "Behavior Events", "1", ///
			  cond(rpt_header == "Behavior Events by Context", "2",       	 ///
			  cond(rpt_header == "Behavior Events by Grade Level", "3",   	 ///
			  cond(rpt_header == "Behavior Events by Locations"," 4",     	 ///
			  cond(rpt_header == "Behavior Events by Socio-Economic Status", "5",  ///
			  cond(rpt_header == "Discipline Resolutions", "6",           	 ///
			  cond(rpt_header == "Discipline-Resolutions", "7",           	 ///
			  cond(rpt_header == "Legal Sanctions", "8", ""))))))))		  
		*/	  
		qui: replace rpt_header = proper(subinstr(subinstr(subinstr( ///   
				subinstr(rpt_header, ":", "", .), ///   
				"Discipline", "Behavior", .), ///   
				"-", " ", .), "Socio Economic", "Socioeconomic", .))
		qui: rename rpt_header rpthdr
		// qui: destring rpthdr,replace ignore("*,-R %$")
		// la val rpthdr rpthdr
		la var rpthdr "Report Header"
	} // End of handling of the RPT_HEADER variable
	
	//Handles instances of the RPT_HEADER_ORDER variable
	if `: list posof "rpt_header_order" in x' != 0 {
		qui: rename rpt_header_order rpthdrodr
		loc torecast `torecast' rpthdrodr
		la var rpthdrodr "Report Header Order"
	} // End of handling of the RPT_HEADER_ORDER variable
	
	//Handles instance of the RPT_LINE_ORDER variable
	if `: list posof "rpt_line_order" in x' != 0 {
		qui: rename rpt_line_order rptlnodr
		loc torecast `torecast' rptlnodr
		la var rptlnodr "Report Line Order"
	} // End of handling of the RPT_LINE_ORDER variable
	
	//Handles instance of the SPENDING_PER_STDNT variable
	if `: list posof "spending_per_stdnt" in x' != 0 {
		qui: rename spending_per_stdnt ppe
		loc torecast `torecast' ppe
		la var ppe "Per-Pupil Expenditure"
	} // End of handling of the SPENDING_PER_STDNT variable
	
	//Handles instance of the AVG_DAILY_ATTENDANCE variable
	if `: list posof "avg_daily_attendance" in x' != 0 {
		qui: rename avg_daily_attendance ada
		loc torecast `torecast' ada
		la var ada "Average Daily Attendance"
	} // End of handling of the AVG_DAILY_ATTENDANCE variable
	
	//Handles instance of the MEMBERSHIP_TOTAL variable
	if `: list posof "membership_total" in x' != 0 {
		qui: rename membership_total membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total Student Membership"
	} // End of handling of the MEMBERSHIP_TOTAL variable
	
	//Handles instance of the MEMBERSHIP_MALE_CNT variable
	if `: list posof "membership_male_cnt" in x' != 0 {
		qui: rename membership_male_cnt nmale
		loc torecast `torecast' nmale
		la var nmale "# of Male Students"
	} // End of handling of the MEMBERSHIP_MALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_MALE_PCT variable
	if `: list posof "membership_male_pct" in x' != 0 {
		qui: rename membership_male_pct pctmale
		loc torecast `torecast' pctmale
		la var pctmale "% of Male Students"
	} // End of handling of the MEMBERSHIP_MALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_CNT variable
	if `: list posof "membership_female_cnt" in x' != 0 {
		qui: rename membership_female_cnt nfemale
		loc torecast `torecast' nfemale
		la var nfemale "# of Female Students"
	} // End of handling of the MEMBERSHIP_FEMALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_PCT variable
	if `: list posof "membership_female_pct" in x' != 0 {
		qui: rename membership_female_pct pctfemale
		loc torecast `torecast' pctfemale
		la var pctfemale "% of Female Students"
	} // End of handling of the MEMBERSHIP_FEMALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_CNT variable
	if `: list posof "membership_white_cnt" in x' != 0 {
		qui: rename membership_white_cnt nwhite
		loc torecast `torecast' nwhite
		la var nwhite "# of White Students"
	} // End of handling of the MEMBERSHIP_WHITE_CNT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_PCT variable
	if `: list posof "membership_white_pct" in x' != 0 {
		qui: rename membership_white_pct pctwhite
		loc torecast `torecast' pctwhite
		la var pctwhite "% of White Students"
	} // End of handling of the MEMBERSHIP_WHITE_PCT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_CNT variable
	if `: list posof "membership_black_cnt" in x' != 0 {
		qui: rename membership_black_cnt nblack
		loc torecast `torecast' nblack
		la var nblack "# of Black Students"
	} // End of handling of the MEMBERSHIP_BLACK_CNT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_PCT variable
	if `: list posof "membership_black_pct" in x' != 0 {
		qui: rename membership_black_pct pctblack
		loc torecast `torecast' pctblack
		la var pctblack "% of Black Students"
	} // End of handling of the MEMBERSHIP_BLACK_PCT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_CNT variable
	if `: list posof "membership_hispanic_cnt" in x' != 0 {
		qui: rename membership_hispanic_cnt nhisp
		loc torecast `torecast' nhisp
		la var nhisp "# of Hispanic/Latino(a) Students"
	} // End of handling of the MEMBERSHIP_HISPANIC_CNT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_PCT variable
	if `: list posof "membership_hispanic_pct" in x' != 0 {
		qui: rename membership_hispanic_pct pcthisp
		loc torecast `torecast' pcthisp
		la var pcthisp "% of Hispanic/Latino(a) Students"
	} // End of handling of the MEMBERSHIP_HISPANIC_PCT variable
	
	//Handles instance of the MEMBERSHIP_ASAIN_CNT variable
	if `: list posof "membership_asian_cnt" in x' != 0 {
		qui: rename membership_asian_cnt nasian
		loc torecast `torecast' nasian
		la var nasian "# of Asian Students"
	} // End of handling of the MEMBERSHIP_ASIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_ASIAN_PCT variable
	if `: list posof "membership_asian_pct" in x' != 0 {
		qui: rename membership_asian_pct pctasian
		loc torecast `torecast' pctasian
		la var pctasian "% of Asian Students"
	} // End of handling of the MEMBERSHIP_ASIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_CNT variable
	if `: list posof "membership_aian_cnt" in x' != 0 {
		cap confirm var naian
		if _rc == 0 qui: replace naian = real(membership_aiain_cnt) if mi(naian)
		else qui: destring membership_aian_cnt, ignore("*,-R %$") gen(naian)
		la var naian "# of American Indian/Alaskan Native Students"
	} // End of handling of the MEMBERSHIP_AIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_PCT variable
	if `: list posof "membership_aian_pct" in x' != 0 {
		qui: rename membership_aian_pct pctaian
		loc torecast `torecast' pctaian
		la var pctaian "% of American Indian/Alaskan Native Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_CNT variable
	if `: list posof "membership_hawaiian_cnt" in x' != 0 {
		qui: rename membership_hawaiian_cnt npacisl
		loc torecast `torecast' npacisl
		la var npacisl "# of Native Hawwaiian/Pacific Islander Students"
	} // End of handling of the MEMBERSHIP_HAWAIIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_PCT variable
	if `: list posof "membership_hawaiian_pct" in x' != 0 {
		qui: rename membership_hawaiian_pct pctpacisl
		loc torecast `torecast' pctpacisl
		la var pctpacisl "% of Native Hawwaiian/Pacific Islander Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	if `: list posof "membership_two_or_more_cnt" in x' != 0 {
		qui: rename membership_two_or_more_cnt nmulti
		loc torecast `torecast' nmulti
		la var nmulti "# of Multiracial Students"
	} // End of handling of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_PCT variable
	if `: list posof "membership_two_or_more_pct" in x' != 0 {
		qui: rename membership_two_or_more_pct pctmulti
		loc torecast `torecast' pctmulti
		la var pctmulti "% of Multiracial Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_CNT variable
	if `: list posof "enrollment_free_lunch_cnt" in x' != 0 {
		qui: rename enrollment_free_lunch_cnt nfreelnch
		loc torecast `torecast' nfreelnch
		la var nfreelnch "# of Free Lunch Students"
	} // End of handling of the ENROLLMENT_FREE_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_PCT variable
	if `: list posof "enrollment_free_lunch_pct" in x' != 0 {
		qui: rename enrollment_free_lunch_pct pctfreelnch
		loc torecast `torecast' pctfreelnch
		la var pctfreelnch "% of Free Lunch Students"
	} // End of handling of the ENROLLMENT_FREE_LUNCH_PCT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	if `: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {
		qui: rename enrollment_reduced_lunch_cnt nredlnch
		loc torecast `torecast' nredlnch
		la var nredlnch "# of Reduced Lunch Students"
	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	if `: list posof "enrollment_reduced_lunch_pct" in x' !=0 {
		qui: rename enrollment_reduced_lunch_pct pctredlnch
		loc torecast `torecast' pctredlnch
		la var pctredlnch "% of Reduced Lunch Students"
	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	
	/* Need to move next two blocks to the end of the program (after the 
	destring `torecast' line) */
	if 	`: list posof "enrollment_free_lunch_cnt" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {	
		qui: g nfrl = nfreelnch + nredlnch
		la var nfrl "# of Students Qualifying for Free/Reduced Price Lunch"
	}	
		
	if 	`: list posof "enrollment_free_lunch_pct" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_pct" in x' != 0 {	
		qui: g pctfrl = pctfreelnch + pctredlnch
		la var pctfrl "% of Students Qualifying for Free/Reduced Price Lunch"
	}	
		
	if 	`: list posof "membership_other_cnt" in x' != 0 {
		cap confirm var nmulti
		if _rc == 0 qui: replace nmulti = real(membership_other_cnt) if	 	 ///   
					mi(nmulti) & !mi(membership_other_cnt)
		else qui: g nmulti = real(membership_other_cnt)
		drop membership_other_cnt
		la var nmulti "# of Multi-Racial Students"
	} 

	if 	`: list posof "membership_other_pct" in x' != 0 {
		cap confirm var pctmulti
		if _rc == 0 qui: replace pctmulti = real(membership_other_pct) if 	 ///   
						 mi(pctmulti) & !mi(membership_other_pct)
		else qui: g pctmulti = real(membership_other_pct)				 
		drop membership_other_pct
		la var pctmulti "% of Multi-Racial Students"
	} 

	if 	`: list posof "membership_free_lunch_cnt" in x' != 0 {
		qui: rename membership_free_lunch_cnt memfreelnch
		loc torecast `torecast' memfreelnch
		qui: replace nfreelnch = memfreelnch if mi(nfreelnch)
		drop memfreelnch
	}
	 
	if 	`: list posof "membership_reduced_lunch_cnt" in x' != 0 {	
		qui: rename membership_reduced_lunch_cnt memredlnch
		loc torecast `torecast' nredlnch
		qui: replace nredlnch = memredlnch if mi(nredlnch)
		drop memredlnch
	}
		
	//Handles instance of the RETENTION_RATE variable
	if `: list posof "retention_rate" in x' !=0 {
		qui: rename retention_rate retrate
		qui: replace retrate = ustrregexra(retrate, "\D", "")
		loc torecast `torecast' retrate
		la var retrate "Retention Rate"
	} // End of handling of the RETENTION_RATE variable
	
	//Handles instance of the DROPOUT_RATE variable
	if `: list posof "dropout_rate" in x' !=0 {
		qui: rename dropout_rate droprate
		qui: replace droprate = ustrregexra(droprate, "\D", "")
		loc torecast `torecast' droprate
		la var droprate "Dropout Rate"
	} // End of handling of the DROPOUT_RATE variable
	
	//Handles instance of the GRADUATION_RATE variable
	if `: list posof "graduation_rate" in x' !=0 {
		qui: rename graduation_rate gradrate
		qui: replace gradrate = ustrregexra(gradrate, "\D", "")
		loc torecast `torecast' gradrate
		la var gradrate "Graduation Rate"
	} // End of handling of the GRADUATION_RATE variable
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_CNT
	if `: list posof "transition_college_inout_cnt" in x' !=0 {
		qui: rename transition_college_inout_cnt ncollege
		qui: replace ncollege = ustrregexra(ncollege, "\D", "")
		loc torecast `torecast' ncollege
		la var ncollege "# of Students Enrolled in College In/Out of State"
	} //End of handling of the TRANSITION_COLLEGE_INOUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_PCT
	if `: list posof "transition_college_inout_pct" in x' !=0 {
		qui: rename transition_college_inout_pct pctcollege
		qui: replace pctcollege = ustrregexra(pctcollege, "\D", "")
		loc torecast `torecast' pctcollege
		la var pctcollege "% of Students Enrolled in College In/Out of State"
	} //End of handling of the TRANSITION_COLLEGE_INOUT_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_CNT
	if `: list posof "transition_college_in_cnt" in x' !=0 {
		qui: rename transition_college_in_cnt nincollege
		qui: replace nincollege = ustrregexra(nincollege, "\D", "")
		loc torecast `torecast' nincollege
		la var nincollege "# of Students Enrolled in College In State"
	} //End of handling of the TRANSITION_COLLEGE_IN_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_PCT
	if `: list posof "transition_college_in_pct" in x' !=0 {
		qui: rename transition_college_in_pct pctincollege
		qui: replace pctincollege = ustrregexra(pctincollege, "\D", "")
		loc torecast `torecast' pctincollege
		la var pctincollege "% of Students Enrolled in College In State"
	} //End of handling of the TRANSITION_COLLEGE_IN_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_CNT
	if `: list posof "transition_college_out_cnt" in x' !=0 {
		qui: rename transition_college_out_cnt noutcollege
		qui: replace noutcollege = ustrregexra(noutcollege, "\D", "")
		loc torecast `torecast' noutcollege
		la var noutcollege "# of Students Enrolled in College Out of State"
	} //End of handling of the TRANSITION_COLLEGE_OUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_PCT
	if `: list posof "transition_college_out_pct" in x' !=0 {
		qui: rename transition_college_out_pct pctoutcollege
		qui: replace pctoutcollege = ustrregexra(pctoutcollege, "\D", "")
		loc torecast `torecast' pctoutcollege
		la var pctoutcollege "% of Students Enrolled in College Out of State"
	} //End of handling of the TRANSITION_COLLEGE_OUT_PCT
	
	// Handles instances of the TEACHING_METHOD variable
	if `: list posof "teaching_method" in x' != 0 {
		qui: rename teaching_method pedagogy
		qui: replace pedagogy = cond(pedagogy == `"Credit Recovery - Digital Learning Provider"', "1", 	 ///
				cond(pedagogy == `"Credit Recovery - Direct Instruction"', "2",    ///
				cond(pedagogy == `"Digital Learning Provider"', "3", 				 ///
				cond(pedagogy == `"Direct Instruction"', "4", 	 				 ///
				cond(pedagogy == `"District Provided Self Study"', "5", 			 ///
				cond(pedagogy == `"Dual Credit - College Offered"', "6", 		 	 ///
				cond(pedagogy == `"Dual Credit - District Offered"', "7", 		 ///
				cond(pedagogy == `"NAF Academy Course"', "8", 					 ///
				cond(pedagogy == `"NAF Academy Dual Credit - District Offered"', "9", 				 ///
				cond(pedagogy == `"Third Party Contract"', "10", 					 ///
				cond(pedagogy == `"Transitional Course - KDE Curriculum"', "11", "")))))))))))
		loc torecast `torecast' pedagogy
		la var pedagogy "Pedagogical/Instructional Methodology"
	} // End of handling of the TEACHING_METHOD variable
	
	//Handles instance of the ONSITE_CLASSROOM_CNT variable
	if `: list posof "onsite_classroom_cnt" in x' !=0 {
		qui: rename onsite_classroom_cnt nonsitecls
		loc torecast `torecast' nonsitecls
		la var nonsitecls "# of Onsite Classrooms"
	} //End of handling of the ONSITE_CLASSROOM_CNT variable
	
	//Handles instance of the OFFSITE_CTE_CNT variable
	if `: list posof "offsite_cte_cnt" in x' !=0 {
		qui: rename offsite_cte_cnt noffsitecte
		loc torecast `torecast' noffsitecte
		la var noffsitecte "# of Offsite Career/Technical Education Classes"
	} //End of handling of the OFFSITE_CTE_CNT variable
	
	//Handles instance of the OFFSITE_COLLEGE_CNT variable
	if `: list posof "offsite_college_cnt" in x' !=0 {
		qui: rename offsite_college_cnt noffsitecol
		loc torecast `torecast' noffsitecol
		la var noffsitecol "# of Offsite College Classes"
	} //End of handling of the OFFSITE_COLLEGE_CNT variable
	
	//Handles instance of the HOME_HOSPITAL_CNT variable
	if `: list posof "home_hospital_cnt" in x' !=0 {
		qui: rename home_hospital_cnt nhomehosp
		loc torecast `torecast' nhomehosp
		la var nhomehosp "# of Home Hospital Classes"
	} //End of handling of the HOME_HOSPITAL_CNT variable
	
	//Handles instance of the ONLINE_CNT varialbe
	if `: list posof "online_cnt" in x' !=0 {
		qui: rename online_cnt nonline
		loc torecast `torecast' nonline
		la var nonline "# of Online Classes"
	} //End of handling of the ONLINE_CNT variable
	
	//Handles instance of the FINANACE_TYPE variable
	if `: list posof "finance_type" in x' !=0 {
		qui: rename finance_type fintype
		qui: replace fintype = cond(fintype == "FINANCIAL SUMMARY", "1",	 ///
							   cond(fintype == "SALARIES", "2",				 ///
							   cond(fintype == "SEEK", "3",					 ///
							   cond(fintype == "TAX", "4", 					 ///   
							   cond(fintype == "REVENUES AND EXPENDITURES", "5", "")))))
		loc torecast `torecast' fintype
		la var fintype "Finance Type"
	} //End of handling of the FINANCE_TYPE variable
	
	//Handles instance of the FINANACE_LABEL variable
	if `: list posof "finance_label" in x' !=0 {
		qui: rename finance_label finlabel
		loc torecast `torecast' finlabel
		la var finlabel "Finance Line Items"
	} //End of handling of the FINANCE_LABEL variable
	
	//Handles instance of the FINANACE_VALUE variable
	if `: list posof "finance_value" in x' !=0 {
		qui: rename finance_value finvalue
		loc torecast `torecast' finvalue
		la var finvalue "Finance Value"
	} //End of handling of the FINANCE_VALUE variable
	
	//Handles instance of the FINANACE_RANK variable
	if `: list posof "finance_rank" in x' !=0 {
		qui: rename finance_rank finrank
		loc torecast `torecast' finrank
		la var finrank "Finance Rank"
	} //End of handling of the FINANCE_RANK variable
	
	//Handles instance of the ENROLLMENT_CNT variable
	if `: list posof "enrollment_cnt" in x' !=0 {
		qui: rename enrollment_cnt membership
		qui: replace membership = ".n" if membership == "N/A"
		loc torecast `torecast' membership
		la var membership "Total # of Students Enrolled"
	} //End of handling of the ENROLLMENT_CNT variable
	
	//Handles instance of the CERTIFICATION_CNT variable
	if `: list posof "certification_cnt" in x' !=0 {
		qui: rename certification_cnt ncert
		loc torecast `torecast' ncert
		la var ncert "# of Certifications"
	} //End of handling of the CERTIFICATION_CNT variable
	
	// Handles instances of the CAREER_PATHWAY_DESC variable
	if `: list posof "career_pathway_desc" in x' != 0 {
		// qui: replace career_pathway_desc = proper(career_pathway_desc)
		qui: rename career_pathway_desc ctepath
		loc torecast `torecast' ctepath
		la var ctepath "Career Pathways"
	} // End of handling of the CAREER_PATHWAY_DESC variable
	
	// Handler for the low_grade variable
	if `: list posof "low_grade" in x' != 0 {
		qui: ds
		loc newlist `r(varlist)'
		if `: list posof "distid" in newlist' != 0 loc district distid
		else loc district dist_number
		
		// This is used to make the county names and IDs consistent across years
		preserve
			keep `district' cntyid cntynm
			qui: drop if mi(cntyid) | mi(cntynm)
			qui: duplicates drop
			tempfile cnty
			qui: save `cnty'.dta, replace
		restore
		qui: merge m:1 `district' using `cnty'.dta, nogen update replace
		
		// This is used to make the coop names and IDs consistent across years
		preserve
			keep `district' coopid coop
			qui: drop if mi(coopid, coop)
			qui: duplicates drop
			tempfile coop
			qui: save `coop'.dta, replace
		restore
		qui: merge m:1 `district' using `coop'.dta, nogen update replace
		
		qui: rename low_grade mingrade
		qui: replace mingrade = ustrregexra(mingrade, "(st)|(th)|(rd)|(nd)", "")
		qui: replace mingrade = cond(mingrade == "Adult Ed", "98",			 ///   
					cond(inlist(mingrade, "Entry", "K", "Primary"), "0", 	 ///   
					cond(mingrade == "Preschool", "-1", mingrade)))
		loc torecast `torecast' mingrade
		la var mingrade "Lowest Grade Level Served by School"
	} // End of handling of the low_grade variable

	// Handler for the high_grade variable
	if `: list posof "high_grade" in x' != 0 {
		qui: rename high_grade maxgrade
		qui: replace maxgrade = ustrregexra(maxgrade, "(st)|(th)|(rd)|(nd)", "")
		qui: replace maxgrade = cond(maxgrade == "Adult Ed", "98",			 ///   
					cond(inlist(maxgrade, "Entry", "K", "Primary"), "0", 	 ///   
					cond(maxgrade == "Preschool", "-1", maxgrade)))
		loc torecast `torecast' maxgrade
		la var maxgrade "Highest Grade Level Served by School"
	} // End of handling of the high_grade variable

	// Handler for the title1_status variable
	if `: list posof "title1_status" in x' != 0 {
		/*
		qui: rename title1_status title1
		qui: replace title1 = proper(trim(itrim(ustrregexra(				 ///   
					ustrregexra(subinstr(title1, "Title 1", "Title I", .),   ///   
						"[ ]?[–-]+[ ]?No Program", " - No Program"), 		 ///   
						"[–-]+", " - "))))
		qui: replace = cond()
		la var  ""
		*/
		qui: rename title1_status title1
		loc torecast `torecast' title1
		la var title1 "Title I Status Indicator"
	} // End of handling of the title1_status variable

	// Handler for the  variable
	if `: list posof "contact_name" in x' != 0 {
		qui: rename contact_name poc
		
		// Sort by school id in ascending order and school year in descending order
		gsort schid - schyr
		qui: egen pcs = nvals(poc), by(schid)
		// Replace other names with most recent name if school had multiple names
		qui: replace poc = poc[_n - 1] if pcs > 1 & poc[_n - 1] != poc &	 ///   
		schid[_n - 1] == schid
		drop pcs
		la var poc "Point of Contact"
		
	} // End of handling of the  variable

	// Handler for the  variable
	if `: list posof "address" in x' != 0 {
		qui: rename (address address2)(addy addy2)
		la var addy "Street Address"
		la var addy2 "Street Address (Line 2)"
	} // End of handling of the  variable

	//Handles instance of the PERFORMANCE_TYPE variable
	if `: list posof "performance_type" in x' !=0 {
		qui: rename performance_type ptype
		qui: replace ptype = cond(ptype == "Points", "0",		 ///
							   cond(ptype == "NAPD Calculation", "1", ""))
		loc torecast `torecast' ptype
		la var ptype "Performance Type"
	} //End of handling of the PERFORMANCE_TYPE variable
	
	//Handles instance of the ASSESSMENT_LEVEL variable
	if `: list posof "assessment_level" in x' !=0 {
		qui: rename assessment_level assesslev
		qui: replace assesslev = cond(assesslev == "Kentucky", "0",			 ///
							     cond(assesslev == "Nation", "1", ""))
		loc torecast `torecast' assesslev
		la var assesslev "Assessment Level"
	} //End of handling of the ASSESSMENT_LEVEL variable	
		
	//Handles instance of the COHORT_TYPE variable
	if `: list posof "cohort_type" in x' !=0 {
		qui: rename cohort_type targettype
		qui: replace targettype = cond(targettype == "FIVE YEAR", "2",		 ///
							  cond(targettype == "FOUR YEAR", "1", ""))
		qui: replace targettype = "1" if mi(targettype) & schyr <= 2013					  
		loc torecast `torecast' targettype
	} //End of handling of the COHORT_TYPE variable
	
	//Handles instances of the RPT_LINE variable
	if `: list posof "rpt_line" in x' != 0 {
		qui: replace rpt_line = ustrregexra(rpt_line, "Event$", "Events")
		qui: replace rpt_line = subinstr(rpt_line, "Drug ", "Drugs ", .)
		qui: replace rpt_line = proper(trim(itrim(rpt_line)))				
		qui: replace rpt_line = subinstr(rpt_line, "Expelled;", "Expelled,", .)
		qui: replace rpt_line = ustrregexra(rpt_line, "Hour$", "Hours")
		qui: replace rpt_line = "Paid Meal Status" if rpt_line == "Paid Lunch"
		qui: replace rpt_line = subinstr(rpt_line, "Sponsered", "Sponsored", .)
		qui: replace rpt_line = subinstr(rpt_line, "Service ", "Services ", .)
		qui: replace rpt_line = subinstr(rpt_line, ";", ",", .)

		qui: rename rpt_line rptln
		la var rptln "Report Line"
	} // End of handling of the RPT_LINE variable
	
	//Handles instances of the GRAD_TARGETS variable
	if `: list posof "grad_targets" in x' != 0 {
		qui: rename grad_targets target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(target == "Numerator", "3",			 ///   
								cond(target == "Denominator", "4",			 ///   
								cond(target == "Met Target", "5", ""))))) 
		loc torecast `torecast' target
		la var target "Graduation Rate Targets"
	} // End of handling of the GRAD_TARGETS variable

	// Handler for the po_box variable
	if `: list posof "po_box" in x' != 0 {
		qui: rename po_box pobox
		la var pobox "Post Office Box"
	} // End of handling of the  variable

	// Handler for the city variable
	if `: list posof "city" in x' != 0 {
		la var city "City"
	} // End of handling of the  variable

	// Handler for the state variable
	if `: list posof "state" in x' != 0 {
		la var state "State"
	} // End of handling of the  variable

	// Handler for the zipcode variable
	if `: list posof "zipcode" in x' != 0 {
		qui: rename zipcode zip
		la var zip "USPS Zip Code"
	} // End of handling of the  variable

	// Handler for the phone variable
	if `: list posof "phone" in x' != 0 {
		la var phone "Phone Number"
	} // End of handling of the  variable

	// Handler for the fax variable
	if `: list posof "fax" in x' != 0 {
		la var fax "Fax Number"
	} // End of handling of the  variable
	
	if 	`: list posof "transition_parttime_cnt" in x' != 0 {
		qui: rename transition_parttime_cnt nparttime
		qui: replace nparttime = ustrregexra(nparttime, "\D", "")
		loc torecast `torecast' nparttime
		la var nparttime "# of Students Transitioning into Part-Time Higher-Ed"
	}

	if 	`: list posof "transition_parttime_pct" in x' != 0 {
		qui: rename transition_parttime_pct pctparttime
		qui: replace pctparttime = ustrregexra(pctparttime, "\D", "")
		loc torecast `torecast' pctparttime
		la var pctparttime "% of Students Transitioning into Part-Time Higher-Ed"
	}

	if 	`: list posof "transition_workforce_cnt" in x' != 0 {
		qui: rename transition_workforce_cnt nworkforce
		qui: replace nworkforce = ustrregexra(nworkforce, "\D", "")
		loc torecast `torecast' nworkforce
		la var nworkforce "# of Students Transitioning to the Workforce"
	}

	if 	`: list posof "transition_workforce_pct" in x' != 0 {
		qui: rename transition_workforce_pct pctworkforce
		qui: replace pctworkforce = ustrregexra(pctworkforce, "\D", "")
		loc torecast `torecast' pctworkforce
		la var pctworkforce "% of Students Transitioning to the Workforce"
	}

	if 	`: list posof "transition_vocational_cnt" in x' != 0 {
		qui: rename transition_vocational_cnt nvocational
		qui: replace nvocational = ustrregexra(nvocational, "\D", "")
		loc torecast `torecast' nvocational
		la var nvocational "# of Students Transitioning to Vocational Program"
	}

	if 	`: list posof "transition_vocational_pct" in x' != 0 {
		qui: rename transition_vocational_pct pctvocational
		qui: replace pctvocational = ustrregexra(pctvocational, "\D", "")
		loc torecast `torecast' pctvocational
		la var pctvocational "% of Students Transitioning to Vocational Program"
	}

	if 	`: list posof "transition_failure_cnt" in x' != 0 {
		qui: rename transition_failure_cnt nfailure
		qui: replace nfailure = ustrregexra(nfailure, "\D", "")
		loc torecast `torecast' nfailure
		la var nfailure "# of Students Transitioning to Failure?"
	}

	if 	`: list posof "transition_failure_pct" in x' != 0 {
		qui: rename transition_failure_pct pctfailure
		qui: replace pctfailure = ustrregexra(pctfailure, "\D", "")
		loc torecast `torecast' pctfailure
		la var pctfailure "% of Students Transitioning to Failure?"
	}

	if 	`: list posof "transition_military_cnt" in x' != 0 {
		qui: rename transition_military_cnt nmilitary
		qui: replace nmilitary = ustrregexra(nmilitary, "\D", "")
		loc torecast `torecast' nmilitary
		la var nmilitary "# of Students Transitioning to the Military"
	}

	if 	`: list posof "transition_military_pct" in x' != 0 {
		qui: rename transition_military_pct pctmilitary
		qui: replace pctmilitary = ustrregexra(pctmilitary, "\D", "")
		loc torecast `torecast' pctmilitary
		la var pctmilitary "% of Students Transitioning to the Military"
	}

	if 	`: list posof "stdnt_tch_ratio" in x' != 0 {
		qui: split stdnt_tch_ratio, parse(":") gen(x)
		qui: g stdtchratio = cond(real(x1) == 0, 0, (real(x2) / real(x1))) 
		qui: drop stdnt_tch_ratio x1 x2
		la var stdtchratio "Student to Teacher Ratio"
	}

	if 	`: list posof "fulltime_tch_total" in x' != 0 {
		qui: rename fulltime_tch_total nfte
		loc torecast `torecast' nfte
		la var nfte "# of Full Time Teachers"
	}

	if 	`: list posof "national_board_cert_tch_cnt" in x' != 0 {
		qui: rename national_board_cert_tch_cnt nnbct
		loc torecast `torecast' nnbct
		la var nnbct "# of National Board Certified Teachers"
	}

	if 	`: list posof "pct_cls_not_hq_tch" in x' != 0 {
		qui: rename pct_cls_not_hq_tch pctnothq
		loc torecast `torecast' pctnothq
		la var pctnothq "% of non-Highly Qualified Educators"
	}

	if 	`: list posof "avg_yrs_tch_exp" in x' != 0 {
		qui: rename avg_yrs_tch_exp tchexp
		loc torecast `torecast' tchexp
		la var tchexp "Average # of Years of Educator Experience"
	}

	if 	`: list posof "prof_qual_ba_pct" in x' != 0 {
		qui: rename prof_qual_ba_pct pctqualba
		loc torecast `torecast' pctqualba
		la var pctqualba "% Highly Qualified Educators with a Bachelor's Degree"
	}

	if 	`: list posof "prof_qual_ma_pct" in x' != 0 {
		qui: rename prof_qual_ma_pct pctqualma
		loc torecast `torecast' pctqualma
		la var pctqualma "% Highly Qualified Educators with a Master's Degree"
	}

	if `: list posof "prof_qual_rank1_pct" in x' != 0 {
		qui: rename prof_qual_rank1_pct pctqualrank1
		loc torecast `torecast' pctqualrank1
		la var pctqualrank1 "% Highly Qualified Educators with a Degree from a Rank 1 IHE"
	}

	if 	`: list posof "prof_qual_specialist_pct" in x' != 0 {
		qui: rename prof_qual_specialist_pct pctqualspecialist
		loc torecast `torecast' pctqualspecialist
		la var pctqualspecialist "% Highly Qualified Educators with a Specialist Endorsement"
	}

	if 	`: list posof "prof_qual_doctorate_pct" in x' != 0 {
		qui: rename prof_qual_doctorate_pct pctdr
		loc torecast `torecast' pctdr
		la var pctdr "% Highly Qualified Educators with a Doctorate"
	}

	if 	`: list posof "prof_qual_tch_pct" in x' != 0 {
		qui: rename prof_qual_tch_pct pctqualtch
		loc torecast `torecast' pctqualtch
		la var pctqualtch "% Highly Qualified Educators"
	}

	if 	`: list posof "tch_prov_cert_pct" in x' != 0 {
		qui: rename tch_prov_cert_pct pctprovcert
		loc torecast `torecast' pctprovcert
		la var pctprovcert "% of Educators with Provisional Certification"
	}

	if 	`: list posof "stdnt_comp_ratio" in x' != 0 {
		qui: split stdnt_comp_ratio, parse(":") gen(x)
		qui: g stdcompratio = cond(real(x1) == 0, 0, (real(x2) / real(x1))) 
		qui: drop stdnt_comp_ratio x1 x2
		la var stdcompratio "Student to Computer Ratio"
	}

	if 	`: list posof "computer_5yr_old_pct" in x' != 0 {
		qui: rename computer_5yr_old_pct pctoldcomp
		loc torecast `torecast' pctoldcomp
		la var pctoldcomp "% of Computers > 5 Years Old"
	}

	if 	`: list posof "pt_conference" in x' != 0 {
		qui: rename pt_conference ptconf
		loc torecast `torecast' ptconf
		la var ptconf "# of Parents Attenting Parent-Teacher Conferences"
	}

	if 	`: list posof "sbdm_vote" in x' != 0 {
		qui: rename sbdm_vote sbdmvote
		loc torecast `torecast' sbdmvote
		la var sbdmvote "# of SBDM Votes Cast"
	}

	if 	`: list posof "parents_on_council" in x' != 0 {
		qui: rename parents_on_council councilparent
		loc torecast `torecast' councilparent
		la var councilparent "# of Parents on Council"
	}

	if 	`: list posof "volunteer_hrs" in x' != 0 {
		qui: rename volunteer_hrs volunteertime
		loc torecast `torecast' volunteertime
		la var volunteertime "# of Volunteer Hours"
	}
	
	if 	`: list posof "enrollment_total" in x' != 0 {
		qui: replace membership = real(enrollment_total) if mi(membership) & !mi(enrollment_total) 
		drop enrollment_total
	}

	if 	`: list posof "enrollment_male_cnt" in x' != 0 {
		qui: replace nmale = real(enrollment_male_cnt) if mi(nmale) & !mi(enrollment_male_cnt) 
		drop enrollment_male_cnt
	}

	if 	`: list posof "enrollment_male_pct" in x' != 0 {
		qui: replace pctmale = real(enrollment_male_pct) if mi(pctmale) & !mi(enrollment_male_pct) 
		drop enrollment_male_pct
	}

	if 	`: list posof "enrollment_female_cnt" in x' != 0 {
		qui: replace nfemale = real(enrollment_female_cnt) if mi(nfemale) & !mi(enrollment_female_cnt) 
		drop enrollment_female_cnt
	}

	if 	`: list posof "enrollment_female_pct" in x' != 0 {
		qui: replace pctfemale = real(enrollment_female_pct) if mi(pctfemale) & !mi(enrollment_female_pct) 
		drop enrollment_female_pct
	}

	if 	`: list posof "enrollment_white_cnt" in x' != 0 {
		qui: replace nwhite = real(enrollment_white_cnt) if mi(nwhite) & !mi(enrollment_white_cnt) 
		drop enrollment_white_cnt
	}

	if 	`: list posof "enrollment_white_pct" in x' != 0 {
		qui: replace pctwhite = real(enrollment_white_pct) if mi(pctwhite) & !mi(enrollment_white_pct) 
		drop enrollment_white_pct
	}

	if 	`: list posof "enrollment_black_cnt" in x' != 0 {
		qui: replace nblack = real(enrollment_black_cnt) if mi(nblack) & !mi(enrollment_black_cnt) 
		drop enrollment_black_cnt
	}

	if 	`: list posof "enrollment_black_pct" in x' != 0 {
		qui: replace pctblack = real(enrollment_black_pct) if mi(pctblack) & !mi(enrollment_black_pct) 
		drop enrollment_black_pct
	}

	if 	`: list posof "enrollment_hispanic_cnt" in x' != 0 {
		qui: replace nhisp = real(enrollment_hispanic_cnt) if mi(nhisp) & !mi(enrollment_hispanic_cnt) 
		drop enrollment_hispanic_cnt
	}

	if 	`: list posof "enrollment_hispanic_pct" in x' != 0 {
		qui: replace pcthisp = real(enrollment_hispanic_pct) if mi(pcthisp) & !mi(enrollment_hispanic_pct) 
		drop enrollment_hispanic_pct
	}

	if 	`: list posof "enrollment_asian_cnt" in x' != 0 {
		qui: replace nasian = real(enrollment_asian_cnt) if mi(nasian) & !mi(enrollment_asian_cnt) 
		drop enrollment_asian_cnt
	}

	if 	`: list posof "enrollment_asian_pct" in x' != 0 {
		qui: replace pctasian = real(enrollment_asian_pct) if mi(pctasian) & !mi(enrollment_asian_pct) 
		drop enrollment_asian_pct
	}

	if 	`: list posof "enrollment_aian_cnt" in x' != 0 {
		qui: replace naian = real(enrollment_aian_cnt) if mi(naian) & !mi(enrollment_aian_cnt) 
		drop enrollment_aian_cnt
	}

	if 	`: list posof "enrollment_aian_pct" in x' != 0 {
		qui: replace pctaian = real(enrollment_aian_pct) if mi(pctaian) & !mi(enrollment_aian_pct) 
		drop enrollment_aian_pct
	}

	if 	`: list posof "enrollment_hawaiian_cnt" in x' != 0 {
		qui: replace npacisl = real(enrollment_hawaiian_cnt) if mi(npacisl) & !mi(enrollment_hawaiian_cnt) 
		drop enrollment_hawaiian_cnt
	}

	if 	`: list posof "enrollment_hawaiian_pct" in x' != 0 {
		qui: replace pctpacisl = real(enrollment_hawaiian_pct) if mi(pctpacisl) & !mi(enrollment_hawaiian_pct) 
		drop enrollment_hawaiian_pct
	}

	if 	`: list posof "enrollment_other_cnt" in x' != 0 {
		qui: replace nmulti = real(enrollment_other_cnt) if mi(nmulti) & !mi(enrollment_other_cnt) 
		drop enrollment_other_cnt
	}

	if 	`: list posof "enrollment_other_pct" in x' != 0 {
		qui: replace pctmulti = real(enrollment_other_pct) if mi(pctmulti) & !mi(enrollment_other_pct) 
		drop enrollment_other_pct
	}

	if 	`: list posof "fte_tch_total" in x' != 0 {
		qui: replace nfte = real(fte_tch_total) if mi(nfte) & !mi(fte_tch_total) 
		drop fte_tch_total
	}

	if 	`: list posof "male_fte_total" in x' != 0 {
		rename male_fte_total malefte 
		loc torecast `torecast' malefte
		la var malefte "# of Male FTE"
	}

	if 	`: list posof "female_fte_total" in x' != 0 {
		rename female_fte_total femalefte
		loc torecast `torecast' femalefte
		la var femalefte "# of Female FTE"
	}

	if 	`: list posof "male_total" in x' != 0 {
		qui: replace nmale = real(male_total) if mi(nmale) & !mi(male_total) 
		drop male_total
	}

	if 	`: list posof "female_total" in x' != 0 {
		qui: replace nfemale = real(female_total) if mi(nfemale) & !mi(female_total) 
		drop female_total
	}

	if 	`: list posof "white_male_cnt" in x' != 0 {
		rename white_male_cnt nwhitem 
		loc torecast `torecast' nwhitem
		la var nwhitem "# of White Males"
	}

	if 	`: list posof "white_female_cnt" in x' != 0 {
		rename white_female_cnt nwhitef
		loc torecast `torecast' nwhitef
		la var nwhitef "# of White Females"
	}

	if 	`: list posof "white_total" in x' != 0 {
		qui: replace nwhite = real(white_total) if mi(nwhite) & !mi(white_total) 
		drop white_total
	}

	if 	`: list posof "black_male_cnt" in x' != 0 {
		rename black_male_cnt nblackm 
		loc torecast `torecast' nblackm
		la var nblackm "# of Black Males"
	}

	if 	`: list posof "black_female_cnt" in x' != 0 {
		rename black_female_cnt nblackf
		loc torecast `torecast' nblackf
		la var nblackf "# of Black Females"
	}

	if 	`: list posof "black_total" in x' != 0 {
		qui: replace nblack = real(black_total) if mi(nblack) & !mi(black_total) 
		drop black_total
	}

	if 	`: list posof "hispanic_male_cnt" in x' != 0 {
		rename hispanic_male_cnt nhispm
		loc torecast `torecast' nhispm
		la var nhispm "# of Hispanic/Latino Males"
	}

	if 	`: list posof "hispanic_female_cnt" in x' != 0 {
		rename hispanic_female_cnt nhispf
		loc torecast `torecast' nhispf
		la var nhispf "# of Hispanic/Latina Females"
	}

	if 	`: list posof "hispanic_total" in x' != 0 {
		qui: replace nhisp = real(hispanic_total) if mi(nhisp) & !mi(hispanic_total) 
		drop hispanic_total
	}

	if 	`: list posof "asian_male_cnt" in x' != 0 {
		rename asian_male_cnt nasianm
		loc torecast `torecast' nasianm
		la var nasianm "# of Asian Males"
	}

	if 	`: list posof "asian_female_cnt" in x' != 0 {
		rename asian_female_cnt nasianf
		loc torecast `torecast' nasianf
		la var nasianf "# of Asian Females"
	}

	if 	`: list posof "asian_total" in x' != 0 {
		qui: replace nasian = real(asian_total) if mi(nasian) & !mi(asian_total) 
		drop asian_total
	}

	if 	`: list posof "aian_male_cnt" in x' != 0 {
		rename aian_male_cnt naianm
		loc torecast `torecast' naianm
		la var naianm "# of American Indian/Alaskan Native Males"
	}

	if 	`: list posof "aian_female_cnt" in x' != 0 {
		rename aian_female_cnt naianf 
		loc torecast `torecast' naianf
		la var naianf "# of American Indian/Alaskan Native Females"
	}

	if 	`: list posof "aian_total" in x' != 0 {
		qui: replace naian = real(aian_total) if mi(naian) & !mi(aian_total) 
		drop aian_total
	}

	if 	`: list posof "hawaiian_male_cnt" in x' != 0 {
		rename hawaiian_male_cnt npacislm
		loc torecast `torecast' npacislm
		la var npacislm "# of Native Hawaiian/Pacific Islander Males"
	}

	if 	`: list posof "hawaiian_female_cnt" in x' != 0 {
		rename hawaiian_female_cnt npacislf 
		loc torecast `torecast' npacislf
		la var npacislf "# of Native Hawaiian/Pacific Islander Females"
	}

	if 	`: list posof "hawaiian_total" in x' != 0 {
		qui: replace npacisl = real(hawaiian_total) if mi(npacisl) & !mi(hawaiian_total) 
		drop hawaiian_total
	}

	if 	`: list posof "two_or_more_race_male_cnt" in x' != 0 {
		rename two_or_more_race_male_cnt nmultim
		loc torecast `torecast' nmultim
		la var nmultim "# of Multi-Racial Males"
	}

	if 	`: list posof "two_or_more_race_female_cnt" in x' != 0 {
		rename two_or_more_race_female_cnt nmultif
		loc torecast `torecast' nmultif
		la var nmultif "# of Multi-Racial Females"
	}

	if 	`: list posof "two_or_more_race_total" in x' != 0 {
		qui: replace nmulti = real(two_or_more_race_total) if mi(nmulti) & !mi(two_or_more_race_total) 
		drop two_or_more_race_total
	}

	// Handles Growth Score types
	if 	`: list posof "growth_level" in x' != 0 {
		qui: g growid = cond(growth_level == "Student Growth Percentage" | 	 ///   
							mi(growth_level) & schyr <= 2015, 1,			 ///   
							cond(growth_level == "Categorical Growth", 2, .g))
		drop growth_level
		qui: reshape wide tested grorla gromth groboth, i(schyr schid level  ///   
		fileid) j(growid)
		rename (tested1 grorla1 gromth1 groboth1 tested2 grorla2 gromth2 	 ///   
		groboth2)(sgptested sgprla sgpmth sgpboth cattested catrla catmth 	 ///   
		catboth)
		la var sgptested "Student Growth Percentile - # of Students Tested" 
		la var sgprla "Student Growth Percentile - Reading" 
		la var sgpmth "Student Growth Percentile - Mathematics" 
		la var sgpboth "Student Growth Percentile - Reading & Mathematics" 
		la var cattested "Categorical Growth - # of Students Tested" 
		la var catrla "Categorical Growth - Reading" 
		la var catmth "Categorical Growth - Mathematics" 
		la var catboth "Categorical Growth - Reading & Mathematics"
		qui: egen x = rowmiss(sgptested sgprla sgpmth sgpboth cattested 	 ///   
		catrla catmth catboth)
		qui: drop if x == 8
		drop x
							
	}
		
	if `: list posof "comp_and_domain_enrollment" in x' != 0 {
		qui: rename comp_and_domain_enrollment cndenr
		loc torecast `torecast' cndenr
		la var cndenr "# Enrolled - Composite & Domain"
	}

	if `: list posof "comp_and_domain_numtested" in x' != 0 {
		qui: rename comp_and_domain_numtested cndtested
		loc torecast `torecast' cndtested
		la var cndtested "# Tested - Composite & Domain"
	}

	if `: list posof "comp_and_domain_partciprate" in x' != 0 {
		qui: rename comp_and_domain_partciprate cndpartic
		qui: replace cndpartic = ".n" if cndpartic == "N/A"
		loc torecast `torecast' cndpartic
		la var cndpartic "Participation Rate - Composite & Domain"
	}

	if `: list posof "shse_enrollment" in x' != 0 {
		qui: rename shse_enrollment shseenr
		loc torecast `torecast' shseenr
		la var shseenr "# Enrolled - Self-Help & Social-Emotional"
	}

	if `: list posof "shse_numtested" in x' != 0 {
		qui: rename shse_numtested shsetested
		loc torecast `torecast' shsetested
		la var shsetested "# Tested - Self-Help & Social-Emotional"
	}

	if `: list posof "shse_participrate" in x' != 0 {
		qui: rename shse_participrate shsepartic
		qui: replace shsepartic = ".n" if shsepartic == "N/A"
		loc torecast `torecast' shsepartic
		la var shsepartic "Participation Rate - Self-Help & Social-Emotional"
	}

	if `: list posof "kr_not_ready" in x' != 0 {
		qui: rename kr_not_ready knotready
		loc torecast `torecast' knotready
		la var knotready "# Students Not Ready for Kindergarten"
	}

	if `: list posof "kr_kindergartenready" in x' != 0 {
		qui: rename kr_kindergartenready kready
		loc torecast `torecast' kready
		la var kready "# Students Ready for Kindergarten"
	}

	if `: list posof "cog_below_avg" in x' != 0 {
		qui: rename cog_below_avg cogblw
		loc torecast `torecast' cogblw
		la var cogblw "% of Below Average on Cognitive Measures"
	}

	if `: list posof "cog_avg" in x' != 0 {
		qui: rename cog_avg cogavg
		loc torecast `torecast' cogavg
		la var cogavg "% of Average on Cognitive Measures"
	}

	if `: list posof "cog_above_avg" in x' != 0 {
		qui: rename cog_above_avg cogabv
		loc torecast `torecast' cogabv
		la var cogabv "% of Above Average on Cognitive Measures"
	}

	if `: list posof "lang_below_avg" in x' != 0 {
		qui: rename lang_below_avg lanblw
		loc torecast `torecast' lanblw
		la var lanblw "% of Below Average on Language Measures"
	}

	if `: list posof "lang_avg" in x' != 0 {
		qui: rename lang_avg lanavg
		loc torecast `torecast' lanavg
		la var lanavg "% of Average on Language Measures"
	}

	if `: list posof "lang_above_avg" in x' != 0 {
		qui: rename lang_above_avg lanabv
		loc torecast `torecast' lanabv
		la var lanabv "% of Above Average on Language Measures"
	}

	if `: list posof "phydev_below_avg" in x' != 0 {
		qui: rename phydev_below_avg phyblw
		loc torecast `torecast' phyblw
		la var phyblw "% of Below Average on Physical Development Measures"
	}

	if `: list posof "phydev_avg" in x' != 0 {
		qui: rename phydev_avg phyavg
		loc torecast `torecast' phyavg
		la var phyavg "% of Average on Physical Development Measures"
	}

	if `: list posof "phydev_above_avg" in x' != 0 {
		qui: rename phydev_above_avg phyabv
		loc torecast `torecast' phyabv
		la var phyabv "% of Above Average on Physical Development Measures"
	}

	if `: list posof "selfhelp_below_avg" in x' != 0 {
		qui: rename selfhelp_below_avg slfblw
		loc torecast `torecast' slfblw
		la var slfblw "% of Below Average on Self-Help Measures"
	}

	if `: list posof "selfhelp_avg" in x' != 0 {
		qui: rename selfhelp_avg slfavg
		loc torecast `torecast' slfavg
		la var slfavg "% of Average on Self-Help Measures"
	}

	if `: list posof "selfhelp_above_avg" in x' != 0 {
		qui: rename selfhelp_above_avg slfabv
		loc torecast `torecast' slfabv
		la var slfabv "% of Above Average on Self-Help Measures"
	}

	if `: list posof "social_emo_below_avg" in x' != 0 {
		qui: rename social_emo_below_avg selblw
		loc torecast `torecast' selblw
		la var selblw "% of Below Average on Socio-Emotional Measures"
	}

	if `: list posof "social_emo_avg" in x' != 0 {
		qui: rename social_emo_avg selavg
		loc torecast `torecast' selavg
		la var selavg "% of Average on Socio-Emotional Measures"
	}

	if `: list posof "social_emo_above_avg" in x' != 0 {
		qui: rename social_emo_above_avg selabv
		loc torecast `torecast' selabv
		la var selabv "% of Above Average on Socio-Emotional Measures"
	}

	if 	`: list posof "coop_cd" in x' != 0 {
		qui: rename coop_cd coopid 
		la var coopid "Cooperative ID Number"
	}
	
	if ustrregexm(`"`x'"', "cohort_[0-9]{4}") == 1 {
		rename cohort_# cohort#
		foreach v of var cohort???? {
			qui: replace `v' = 	cond(upper(`v') == "YES", "1", 				 ///   
								cond(upper(`v') == "NO", "0", 				 ///   
								cond(upper(`v') == "N/A", ".n", 			 ///   
								cond(upper(`v') == "***", ".s", 			 ///   
								cond(upper(`v') == "---", ".d", `v')))))
			loc torecast `torecast' `v'
		}
		qui: egen nullrecord = rowmiss(cohort*)
		qui: ds cohort*
		qui: drop if nullrecord == `: word count `r(varlist)''
		drop nullrecord		
		// deltargets, st(cohort) pk(fileid schid schyr amogroup) tar(targettype)
	}	
	
	if `: list posof "test_takers_cnt" in x' != 0 {
		qui: rename test_takers_cnt ntested
		loc torecast `torecast' ntested
		la var ntested "# of Students Taking AP Exams"
	}

	if `: list posof "test_takers_pct" in x' != 0 {
		qui: rename test_takers_pct pcttested
		loc torecast `torecast' pcttested
		la var pcttested "% of Students Taking AP Exams"
	}

	if `: list posof "exam_taken_cnt" in x' != 0 {
		qui: rename exam_taken_cnt nexams
		loc torecast `torecast' nexams
		la var nexams "# of AP Exams Administered"
	}

	if `: list posof "exam_taken_grade3to5_cnt" in x' != 0 {
		qui: rename exam_taken_grade3to5_cnt ncredit
		loc torecast `torecast' ncredit
		la var ncredit "# of Exams with College Credit Bearing Scores"
	}

	if `: list posof "exam_taken_grade3to5_pct" in x' != 0 {
		qui: rename exam_taken_grade3to5_pct pctcredit
		loc torecast `torecast' pctcredit
		la var pctcredit "% of Exams with College Credit Bearing Scores"
	}
	
		if `: list posof "py_novice_pct" in x' != 0 {
		qui: rename py_novice_pct pnovicepct
		loc torecast `torecast' pnovicepct
		la var pnovicepct "Prior Year % Novice"
	}

	if `: list posof "py_reduction_target_needed" in x' != 0 {
		qui: rename py_reduction_target_needed pynovicetarget
		loc torecast `torecast' pynovicetarget
		la var pynovicetarget "Prior Year Reduction Target"
	}

	if `: list posof "cy_novice_pct" in x' != 0 {
		qui: rename cy_novice_pct cnovicepct
		loc torecast `torecast' cnovicepct
		la var cnovicepct "Current Year % Novice"
	}

	if `: list posof "cy_reduction_target_met" in x' != 0 {
		qui: rename cy_reduction_target_met cnovicemet
		loc torecast `torecast' cnovicemet
		la var cnovicemet "Current Year Target Met"
	}

	if `: list posof "pct_target_met" in x' != 0 {
		qui: rename pct_target_met pctmet
		loc torecast `torecast' pctmet
		la var pctmet "% of Students Meeting Target"
	}

	if `: list posof "points_by_content_area" in x' != 0 {
		qui: rename points_by_content_area contentpts
		loc torecast `torecast' contentpts
		la var contentpts "Novice Reduction Points by Content Area"
	}

	if `: list posof "points_by_nr" in x' != 0 {
		qui: rename points_by_nr nrpts
		loc torecast `torecast' nrpts
		la var nrpts "Novice Reduction Points"
	}

	if `: list posof "reading" in x' != 0 {
		qui: rename reading rlagap
		loc torecast `torecast' rlagap
		la var rlagap "Gap Summary - Reading"
	}

	if `: list posof "math" in x' != 0 {
		qui: rename math mthgap
		loc torecast `torecast' mthgap
		la var mthgap "Gap Summary - Mathematics"
	}

	if `: list posof "science" in x' != 0 {
		qui: rename science scigap
		loc torecast `torecast' scigap
		la var scigap "Gap Summary - Science"
	}

	if `: list posof "social_studies" in x' != 0 {
		qui: rename social_studies socgap 
		loc torecast `torecast' socgap
		la var socgap "Gap Summary - Social Studies"
	}

	if `: list posof "writing" in x' != 0 {
		qui: rename writing wrtgap
		loc torecast `torecast' wrtgap
		la var wrtgap "Gap Summary - Writing"
	}

	if `: list posof "language_mechanics" in x' != 0 {
		qui: rename language_mechanics langap
		loc torecast `torecast' langap
		la var langap "Gap Summary - Language Mechanics"
	}

	if `: list posof "acct_type" in x' != 0 { 
		qui: rename acct_type accttype
		qui: replace accttype = cond(accttype == "GAP", "0", "1")
		loc torecast `torecast' accttype
		la var accttype "Accountability Type"						
	}

	if `: list posof "non_dup_gap" in x' != 0 { 
		qui: rename non_dup_gap ndg
		loc torecast `torecast' ndg
		la var ndg "Non Duplicated Gap Group"
	}

	if `: list posof "novice_reduction" in x' != 0 { 
		qui: rename novice_reduction nr
		loc torecast `torecast' nr
		la var nr "Novice Reduction Gap"
	}

	// Handles instances of the sch_name variable
	if `: list posof "sch_name" in x' != 0 {
		qui: rename sch_name schnm 
		qui: replace schnm = "Kentucky" if ustrregexm(schnm, "state", 1)
		qui: replace schnm = distnm + " School District" if schid != "999999" & ///   
		substr(schid, -3, 3) == "999"
		
		// Checks if the same school has multiple names
		qui: egen unschnms = nvals(schnm), by(schid)
		
		// Sort by school id in ascending order and school year in descending order
		gsort schid - schyr
		
		// Replace other names with most recent name if school had multiple names
		qui: replace schnm = schnm[_n - 1] if unschnms > 1 &				 ///   
		schnm[_n - 1] != schnm & schid[_n - 1] == schid
		
		drop unschnms
		
		// Assigns variable label to the variable
		la var schnm "School Name"
		
	} // End of handling of the sch_name variable
	
	// Loop over variables that will be recast to numeric types
	foreach v in `torecast' {
	
		// Replace instances of -R that appear at the end of the string and ---
		qui: replace `v' = ustrregexra(`v', "(-R$)|(---)", "")
		
	} // End of Loop	
	
	// Recast numeric variables in a single batch
	qui: destring `torecast', replace ignore("*, %$")
	
	// Loop over variables again
	foreach v in `torecast' {
		if `"`v'"' == "schyr" {
			if `schyrlab' == 1 la val schyr schyrshrt
			else if `schyrlab' == 2 la val schyr schyrlong
		}
		else {
			cap la val `v' `v'
		}
	} // End Loop	
		
	// If metric variable list is passed this will check for empty records.
	if `"`metricvars'"' != "" {
	
		loc mvars `: word count `metricvars''
		
		qui: egen nullrow = rowmiss(`metricvars')
		
		qui: drop if nullrow == `mvars'
		
		qui: drop nullrow
		
	}	
	
	// Check for primary key if user passed values to the parameter
	if `"`primarykey'"' != "" { 
		
		// Tests the primary key constraint
		testpk `primarykey'
		
		// Sort the data based on the values passed to the primary key parameter
		qui: sort `primarykey'
	
		// Keep only variables containing values or identifying information
		if `"`metricvars'"' != "" keep `primarykey' `metricvars'
		
		// Sets the display order of the variables
		order `primarykey' `metricvars'
		
	} // End IF Block for primary key option
	
	// Optimization of storage types/formats
	qui: compress
		
end		


// Sub process to check for optional primary key definition
prog def testpk, rclass
	syntax varlist 
	cap isid `varlist'
	if _rc == 0 di as res "Primary Key: `varlist' confirmed."
	else if _rc != 0 di as res "Primary Key: `varlist' failed."
	
	// Adds string containing primary key definition as a data set characteristic
	char define _dta[primaryKey] `"`: subinstr loc varlist " " ", ", all'"'
	ret sca _rc = _rc
end	

// Subroutine for handling reshaping the delivery targets data 
prog def deltargets

	syntax, STub(string asis) Pk(varlist) [ TARgettype(string asis) 		 ///   
	i1(string asis) i2(string asis) i3(string asis) j1(string asis) 		 ///   
	j2(string asis) j3(string asis) ]
	
		if `"`targettype'"' == "" loc targettype targettype
		if `"`i1'"' == "" loc i1 `pk' target `targettype'
		if `"`j1'"' == "" loc j1 targetyr
		if `"`i2'"' == "" loc i2 `pk' targetyr target
		if `"`j2'"' == "" loc j2 `targettype'
		if `"`i3'"' == "" loc i3 `pk' targetyr
		if `"`j3'"' == "" loc j3 target
		cap drop ncesid
		qui: reshape long `stub', i(`i1') j(`j1')
		qui: reshape wide `stub', i(`i2') j(`j2')
		qui: ds `stub'*
		loc x `r(varlist)'
		if `: word count `x'' == 2 {
			rename (`stub'1 `stub'2)(n pct)
			qui: reshape wide n pct, i(`i3') j(`j3')
		}
		else {
			rename `stub'* pct
			qui: g byte n = .
			qui: reshape wide n pct, i(`i3') j(`j3')
			drop n?
		}
		
		
		la def met .n "N/A" 0 "No" 1 "Yes", modify
		la var `j1' "Delivery Target Year"
		qui: ds pct* 
		loc targets `r(varlist)'
		if `: list posof "pct1" in targets' != 0 {
			cap {
				rename n1 nactual
				la var nactual "Actual Score # Target"
			}
			cap {
				qui: rename pct1 pctactual
				la var pctactual "Actual Score % Target"
			}
		}	
		
		if `: list posof "pct2" in targets' != 0 {
			cap {
				rename n2 ndelivery
				la var ndelivery "Delivery Target # Target"
			}
			cap {
				qui: rename pct2 pctdelivery
				la var pctdelivery "Delivery Target % Target"
			}
		}
		
		if `: word count `targets'' == 5 {
		
			if `: list posof "pct3" in targets' != 0 {
				cap {
					rename n3 nnum
					la var nnum "Numerator # Target"
				}
				cap {
					qui: rename pct3 pctnum
					la var pctnum "Numerator % Target"
				}
			}
			
			if `: list posof "pct4" in targets' != 0 {
				cap {
					rename n4 nden
					la var nden "Denominator # Target"
				}
				cap {
					qui: rename pct4 pctden
					la var pctden "Denominator % Target"
				}
			}
			
			if `: list posof "pct5" in targets' != 0 {
				cap {
					qui: rename pct5 met
					qui: compress met
					la val met met
					la var met "Met Target"
					assert pctactual > pctdelivery if met == 1
				}
				cap drop n5
			}
			
		}
		
		else if `: word count `targets'' == 3 {
			cap {
				qui: rename pct5 met
				qui: compress met
				la val met met
				la var met "Met Target"
				assert pctactual > pctdelivery if met == 1
			}
		}
		
end
		
