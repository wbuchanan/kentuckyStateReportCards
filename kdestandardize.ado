cap prog drop kdestandardize

prog def kdestandardize

	version 14
	
	syntax [, 	DROPVars(string asis) noGRade SCHYRLab(integer 0) 			 ///   
				PRIMARYKey(string asis) ]
	
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
	
	la def kstype .u "Unknown" 0 "Any" 1 "Child Care" 2 "Head Start" 		 ///   
					3 "Home" 4 "Other" 5 "State Funded", modify

	// Drop any variables ID'd by user before constructing variable list
	if `"`dropvars'"' != "" cap drop `dropvars'

	// Define value labels that can be applied across files
	{
	
	// Define missing value labels for nbr_tested variable
	la def tested .d "---" .s "***", modify		
	
	// Define missing value label for NRT percentiles
	la def pctiles .s "***", modify

	// Define value labels for delivery target types
	la def target 1 "Actual Score" 2 "Target" 3 "Numerator" 4 "Denominator"  ///   
	5 "Met Target" 

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
		la def equmeas 1 `"Community Support and Involment Composite"'       ///
					   2 `"Managing Student Conduct Composite"'              ///
					   3 `"Overall Effectiveness of School Teachers and Leaders"' ///
					   4 `"Overall Student Growth Rating of Teachers and Leaders"' ///
					   5 `"Percentage of new and Kentucky Teacher Internship Program (KTIP) teachers"' ///
					   6 `"Percentage of Teacher Turnover"'                  ///
					   7 `"School Leadership Composite"', modify

	   // Define EQ_LABEL
	   la def eqlabel 1 `"Exemplary/Accomplished"'                           ///
					  2 `"High/Expected"'                                    ///
					  3 `"School-Level"'                                     ///
					  4 `"Strongly Agree/Agree"', modify
					  
	   // Define PROGRAM_TYPE
	   la def progtype 1 `"English Language Learners (ELL)"'                 ///
					 2 `"Migrant"'                                           ///
					 3 `"Special Education"'                                 ///
					 4 `"Gifted and Talented"', modify
					 
	   // Define RPT_HEADER
	   la def rpthdr 1 `"Behavior Events"'                                   ///
					 2 `"Behavior Events by Context"'						 ///
					 3 `"Behavior Events by Grade Level"'                    ///
					 4 `"Behavior Events by Location"' 						 ///
					 5 `"Behavior Events by Socio-Economic Status"'          ///
					 6 `"Discipline Resolutions"'                            ///
					 7 `"Discipline-Resolutions"'                            ///
					 8 `"Legal Sanctions"', modify
					 
					 
	   // Define TEACHING_METHOD
	   la def pedagogy 1 `"Credit Recovery - Digital Learning Povider"'      ///
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
	   la def fintype 1 `"FINANCIAL SUMMARY"'								 ///
					  2 `"SALARIES"'										 ///
					  3 `"SEEK"'											 ///
					  4 `"TAX"', modify
					  
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
				   
	}  // End of value label definitions
	
	
	// Get the list of variable names
	qui: ds
	
	// Store variable names in a local that can persist across commands
	loc x `r(varlist)'
		
	// Handles instances of the sch_year variable	
	if `: list posof "sch_year" in x' != 0 { 
		qui: replace sch_year = substr(sch_year, 5, 8)
		qui: rename sch_year schyr
		qui: destring schyr, replace ignore("*,-R %$")
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
		qui: amogroup disagg_order, la(disagg_label) lan(amogroup)					
		
	} // End Handling of disagg_label and disagg_order variables
	
	// Handles the content_level variable
	if `: list posof "content_level" in x' != 0 { 
		loc cl content_level
		qui: replace content_level = cond(`rx'(`cl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`cl', "mid.*", 1) == 1, "2", "3"))
		qui: rename content_level level
		qui: destring level, replace ignore("*,-R %$")
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
		qui: destring testnm, replace ignore("*,-R %$")
		
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
		qui: destring content, replace ignore("*,-R %$")
		
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
		qui: destring nbr_tested, replace ignore("*,-R %$")
		
		// Renames the variable
		qui: rename nbr_tested tested
		
		// Applies a variable label to the variable
		la var tested "Number of Students Tested" 
		
	} // End handling of the nbr_tested variable
	
	
	// Handles instances of the grade_level variable
	if `: list posof "grade_level" in x' != 0 {
		qui: destring grade_level, replace ignore("*,-R %$")
		qui: rename grade_level grade
		la val grade grade
		la var grade "Accountability Grade Level" 
	}
	
	// If grade_level doesn't exist in the file
	else {
	
		if `"`grade'"' != "nograde" qui: g grade = "99"
		else qui: g grade = "100"
		qui: destring grade, replace ignore("*,-R %$")
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
		qui: destring reward, replace ignore("*,-R %$")
		
		// Applies value labels to the reward variable
		la val reward reward
		
		// Applies variable label to the reward variable
		la var reward "Differentiated Accountability Reward Status"

	} // End handling of reward_recognition variable
	
	// Handles instances of the amo_met variable
	if `: list posof "amo_met" in x' != 0 {
		qui: replace amo_met = 	cond(amo_met == "No", "0", 					 ///   
								cond(amo_met == "Yes", "1", ""))
		qui: destring amo_met, replace ignore("*,-R %$")
		qui: rename amo_met amomet
		la val amomet amomet
		la var amomet "AMO Status Indicator"
	} // End of handling of the amo_met variable
	
	// Handles instances of the  variable
	if `: list posof "pct_novice" in x' != 0 {
		qui: rename pct_novice novice
		qui: destring novice, replace ignore("*,-R %$")
		la var novice "Percent of Students Scoring Novice"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_apprentice" in x' != 0 {
		qui: rename pct_apprentice apprentice
		qui: destring apprentice, replace ignore("*,-R %$")
		la var apprentice "Percent of Students Scoring Apprentice"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_proficient" in x' != 0 {
		qui: rename pct_proficient proficient
		qui: destring proficient, replace ignore("*,-R %$")
		la var proficient "Percent of Students Scoring Proficient"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_distinguished" in x' != 0 {
		qui: rename pct_distinguished distinguished
		qui: destring distinguished, replace ignore("*,-R %$")
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
		
		qui: destring `pny', replace ignore("*,-R %$")
		
		la val `pny' nextpartic
		
		qui: rename `pny' nextpartic
		
		la var nextpartic "KDE did not document the meaning of this variable"
	
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
		qui: destring `grg', replace ignore("*,-R %$")
		
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
		qui: destring baseline, replace ignore("*,-R %$")
		
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
		qui: destring `cv', replace ignore("*,-R %$")
		
		// Apply value labels to variable
		la val `cv' `cv'
							
		// Defines variable label for the variable					
		la var classification "Differentiated Accountability Status Indicator"
							
	} // End of handling of the classification variable
	
	// Handles instances of the overall_score variable
	if `: list posof "overall_score" in x' != 0 {
		qui: destring overall_score, replace ignore("*,-R %$")
		qui: rename overall_score overall
		la var overall "Overall Points in Accountability Model"
	} // End of handling of the overall_score variable
	
	// Handles instances of the ky_rank variable
	if `: list posof "ky_rank" in x' != 0 {
		qui: destring ky_rank, replace ignore("*,-R %$")
		qui: rename ky_rank rank 
		la var rank "Rank of Schools/Districts Across the State"
	} // End of handling of the ky_rank variable
	
	// Handles instances of the gain_needed variable
	if `: list posof "gain_needed" in x' != 0 {
		qui: destring gain_needed, replace ignore("*,-R %$")
		qui: rename gain_needed amogain
		la var amogain "Gain Needed to meet AMOs"
	} // End of handling of the gain_needed variable
	
	// Handles instances of the amo_goal variable
	if `: list posof "amo_goal" in x' != 0 {
		qui: destring amo_goal, replace ignore("*,-R %$")
		qui: rename amo_goal amogoal 
		la var amogoal "Annual Measureable Objectives Goal"
	} // End of handling of the amo_goal variable
	
	// Handles instances of the distnm variable
	if `: list posof "dist_name" in x' != 0 {
		qui: rename dist_name distnm
		qui: replace distnm = "Kentucky" if ustrregexm(sch_name, "state", 1)
		la var distnm "District Name"
	} // End of handling of the distnm variable
	
	// Handles instances of the sch_name variable
	if `: list posof "sch_name" in x' != 0 {
		qui: rename sch_name schnm 
		qui: replace schnm = "Kentucky" if ustrregexm(schnm, "state", 1)
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
	if `: list posof "ncesid" in x' != 0 {
		la var ncesid "National Center for Educational Statistics ID Number"
	} // End of handling of the ncesid variable
	
	// Handles instances of the nbr_graduates_with_diploma variable
	if `: list posof "nbr_graduates_with_diploma" in x' != 0 {
		qui: destring nbr_graduates_with_diploma, replace ignore("*,-R %$")
		qui: rename nbr_graduates_with_diploma diplomas
		la var diplomas "Number of Students Graduating with Regular High School Diplomas"
	
	} // End of handling of the nbr_graduates_with_diploma variable
	
	// Handles instances of the college_ready variable
	if `: list posof "college_ready" in x' != 0 {
		qui: destring college_ready, replace ignore("*,-R %$")
		qui: rename college_ready collready
		la var collready "Number of College Ready Students" 
	
	} // End of handling of the college_ready variable
	
	// Handles instances of the career_ready_academic variable
	if `: list posof "career_ready_academic" in x' != 0 {
		qui: destring career_ready_academic, replace ignore("*,-R %$")
		qui: rename career_ready_academic caracad 
		la var caracad "Number of Career Ready Students (Academic)" 
	
	} // End of handling of the career_ready_academic variable
	
	// Handles instances of the career_ready_technical variable
	if `: list posof "career_ready_technical" in x' != 0 {
		qui: destring career_ready_technical, replace ignore("*,-R %$")
		qui: rename career_ready_technical cartech
		la var cartech "Number of Career Ready Students (Technical)" 
	
	} // End of handling of the career_ready_technical variable
	
	// Handles instances of the career_ready_total variable
	if `: list posof "career_ready_total" in x' != 0 {
		qui: destring career_ready_total, replace ignore("*,-R %$")
		qui: rename career_ready_total cartot
		la var cartot "Number of Career Ready Students (Total)" 
	
	} // End of handling of the career_ready_total variable
	
	// Handles instances of the nbr_ccr_regular variable
	if `: list posof "nbr_ccr_regular" in x' != 0 {
		qui: destring nbr_ccr_regular, replace ignore("*,-R %$")
		qui: rename nbr_ccr_regular nregular
		la var nregular "Number Regular College/Career Ready"
	
	} // End of handling of the nbr_ccr_regular variable
	
	// Handles instances of the pct_ccr_no_bonus variable
	if `: list posof "pct_ccr_no_bonus" in x' != 0 {
		qui: destring pct_ccr_no_bonus, replace ignore("*,-R %$")
		qui: rename pct_ccr_no_bonus pctwobonus
		la var pctwobonus "% College/Career Ready w/o Bonus"
	
	} // End of handling of the pct_ccr_no_bonus variable
	
	// Handles instances of the pct_ccr_with_bonus variable
	if `: list posof "pct_ccr_with_bonus" in x' != 0 {
		qui: destring pct_ccr_with_bonus, replace ignore("*,-R %$")
		qui: rename pct_ccr_with_bonus pctwbonus	
		la var pctwbonus "% College/Career Ready w/ Bonus"
	
	} // End of handling of the pct_ccr_with_bonus variable
	
	// Handles instances of the actmsengpct variable
	if `: list posof "english_bnchmrk_pct" in x' != 0 {
		qui: destring english_bnchmrk_pct, replace ignore("*,-R %$")
		qui: rename english_bnchmrk_pct actmsengpct
		la var actmsengpct "% of MS Students Meeting English CCR Benchmark"	
	} // End of handling of the actmsengpct variable
	
	// Handles instances of the actmsrlapct variable
	if `: list posof "reading_bnchmrk_pct" in x' != 0 {
		qui: destring reading_bnchmrk_pct, replace ignore("*,-R %$")
		qui: rename reading_bnchmrk_pct actmsrlapct   
		la var actmsrlapct "% of MS Students Meeting Reading CCR Benchmark" 	
	} // End of handling of the actmsrlapct variable
	
	// Handles instances of the actmsmthpct variable
	if `: list posof "math_bnchmrk_pct" in x' != 0 {
		qui: destring math_bnchmrk_pct, replace ignore("*,-R %$")
		qui: rename math_bnchmrk_pct actmsmthpct
		la var actmsmthpct "% of MS Students Meeting Math CCR Benchmark" 
	} // End of handling of the actmsmthpct variable
	
	// Handles instances of the actmsscipct variable
	if `: list posof "science_bnchmrk_pct" in x' != 0 {
		qui: destring science_bnchmrk_pct, replace ignore("*,-R %$")
		qui: rename science_bnchmrk_pct actmsscipct
		la var actmsscipct "% of MS Students Meeting Science CCR Benchmark" 
	} // End of handling of the actmscipct variable
	
	// Handles instances of the total_points variable
	if `: list posof "total_points" in x' != 0 {
		qui: destring total_points, replace ignore("*,-R %$")
		qui: rename total_points totmsccrpts	
		la var totmsccrpts "Total Points for Middle School CCR Component"
	} // End of handling of the total_points variable
	
	// Handles instances of the napd_calculation variable
	if `: list posof "napd_calculation" in x' != 0 {
		qui: destring napd_calculation, replace ignore("*,-R %$")
		qui: rename napd_calculation napd	
	} // End of handling of the napd_calculation variable
	
	// Handles instances of the reading_pct variable
	if `: list posof "reading_pct" in x' != 0 {
	   qui: destring reading_pct, replace ignore("*,-R %$")
	   qui: rename reading_pct grorla
	   la var grorla "% of Students Meeting Growth in Reading"
	} // End of handling of the reading_pct variable
	
	// Handles instances of the math_pct variable
	if `: list posof "math_pct" in x' != 0 {
		qui: destring math_pct, replace ignore("*,-R %$")
		qui: rename math_pct gromth
		la var gromth "% of Students Meeting Growth in Math"
	} // End of handling of the math_pct variable
	
	// Handles instances of the reading_math_pct variable
	if `: list posof "reading_math_pct" in x' != 0 {
		qui: destring reading_math_pct, replace ignore("*,-R %$")
		qui: rename reading_math_pct groboth
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
		qui: destring `st', replace ignore("*,-R %$")
		qui: la val `st' `st'
		la var `st' "School Type Classification"
	} // End of handling of the sch_type variable
	
	// Handles instances of the achievement_points variable
	if `: list posof "achievement_points" in x' != 0 {
		qui: destring achievement_points, replace ignore("*,-R %$")
		qui: rename achievement_points achievepts
		la var achievepts "Achievement Points"	
	} // End of handling of the achievement_points variable
	
	// Handles instances of the achievement_score variable
	if `: list posof "achievement_score" in x' != 0 {
		qui: destring achievement_score, replace ignore("*,-R %$")
		qui: rename achievement_score achievesc
		la var achievesc "Achievement Score"
	} // End of handling of the achievement_score variable
	
	// Handles instances of the gap_points variable
	if `: list posof "gap_points" in x' != 0 {
		qui: destring gap_points, replace ignore("*,-R %$")
		qui: rename gap_points gappts
		la var gappts "Gap Points"
	} // End of handling of the gap_points variable
	
	// Handles instances of the gap_score variable
	if `: list posof "gap_score" in x' != 0 {
		qui: destring gap_score, replace ignore("*,-R %$")
		qui: rename gap_score gapsc
		la var gapsc "Gap Score" 
	} // End of handling of the gap_score variable
	
	// Handles instances of the growth_points variable
	if `: list posof "growth_points" in x' != 0 {
		qui: destring growth_points, replace ignore("*,-R %$")
		qui: rename growth_points growthpts
		la var growthpts "Growth Points" 
	} // End of handling of the growth_points variable
	
	// Handles instances of the growth_score variable
	if `: list posof "growth_score" in x' != 0 {
		qui: destring growth_score, replace ignore("*,-R %$")
		qui: rename growth_score growthsc
		la var growthsc "Growth Score" 
	} // End of handling of the growth_score variable
	
	// Handles instances of the ccr_points variable
	if `: list posof "ccr_points" in x' != 0 {
		qui: destring ccr_points, replace ignore("*,-R") 
		qui: rename ccr_points ccrpts
		la var ccrpts "College/Career Readiness Points" 
	} // End of handling of the ccr_points variable
	
	// Handles instances of the ccr_score variable
	if `: list posof "ccr_score" in x' != 0 {
		qui: destring ccr_score, replace ignore("*,-R %$")
		qui: rename ccr_score ccrsc
		la var ccrsc "College/Career Readiness Score"
	} // End of handling of the ccr_score variable
	
	// Handles instances of the graduation_points variable
	if `: list posof "graduation_points" in x' != 0 {
		qui: destring graduation_points, replace ignore("*,-R %$")
		qui: rename graduation_points gradpts 
		la var gradpts "Graduation Rate Points" 
	} // End of handling of the graduation_points variable
	
	// Handles instances of the graduation_score variable
	if `: list posof "graduation_score" in x' != 0 {
		qui: destring graduation_score, replace ignore("*,-R %$")
		qui: rename graduation_score gradsc
		la var gradsc "Graduation Rate Score" 
	} // End of handling of the graduation_score variable
	
	// Handles instances of the weighted_summary variable
	if `: list posof "weighted_summary" in x' != 0 {
		qui: destring weighted_summary, replace ignore("*,-R %$")
		qui: rename weighted_summary wgtsum
		la var wgtsum "Weighted Summary" 
	} // End of handling of the weighted_summary variable
	
	// Handles instances of the state_sch_id variable
	if `: list posof "state_sch_id" in x' != 0 {
		qui: destring state_sch_id, replace ignore("*,-R") 
		qui: rename state_sch_id stschid
		la var stschid "State Assigned School ID Number" 
	} // End of handling of the state_sch_id variable
	
	// Handles instances of the ngl_weighted variable
	if `: list posof "ngl_weighted" in x' != 0 {
		qui: destring ngl_weighted, replace ignore("*,-R %$")
		qui: rename ngl_weighted cwgtngl
		la var cwgtngl "Current Year's Weighted NGL Score" 
	} // End of handling of the ngl_weighted variable
	
	// Handles instances of the pr_total variable
	if `: list posof "pr_total" in x' != 0 {
		qui: destring pr_total, replace ignore("*,-R %$")
		qui: rename pr_total ctotalpr
		la var ctotalpr "Current Year's Program Review Total Score"
	} // End of handling of the pr_total variable
	
	// Handles instances of the pr_weighted variable
	if `: list posof "pr_weighted" in x' != 0 {
		qui: destring pr_weighted, replace ignore("*,-R %$")
		qui: rename pr_weighted cwgtpr
		la var cwgtpr "Current Year's Weighted Program Review Score" 
	} // End of handling of the pr_weighted variable
	
	// Handles instances of the overall variable
	if `: list posof "overall" in x' != 0 {
		qui: destring overall, replace ignore("*,-R %$")
		qui: rename overall coverall
		la var coverall "Current Year's Overall Score"
	} // End of handling of the overall variable
	
	// Handles instances of the py_yr_ngl_total variable
	if `: list posof "py_yr_ngl_total" in x' != 0 {
		qui: destring py_yr_ngl_total, replace ignore("*,-R %$")
		qui: rename py_yr_ngl_total ptotal 
		la var ptotal "Prior Year's Total Score" 
	} // End of handling of the py_yr_ngl_total variable
	
	// Handles instances of the py_yr_ngl_weighted variable
	if `: list posof "py_yr_ngl_weighted" in x' != 0 {
		qui: destring py_yr_ngl_weighted, replace ignore("*,-R %$")
		qui: rename py_yr_ngl_weighted pwgtngl
		la var pwgtngl "Prior Year's Weighted NGL Score" 
	} // End of handling of the py_yr_ngl_weighted variable
	
	// Handles instances of the py_yr_pr_total variable
	if `: list posof "py_yr_pr_total" in x' != 0 {
		qui: destring py_yr_pr_total, replace ignore("*,-R %$")
		qui: rename py_yr_pr_total ptotalpr
		la var ptotalpr "Prior Year's Program Review Total Score"
	} // End of handling of the py_yr_pr_total variable
	
	// Handles instances of the py_yr_pr_weighted variable
	if `: list posof "py_yr_pr_weighted" in x' != 0 {
		qui: destring py_yr_pr_weighted, replace ignore("*,-R %$")
		qui: rename py_yr_pr_weighted pwgtpr
		la var pwgtpr "Prior Year's Weighted Program Review Score"		
	} // End of handling of the py_yr_pr_weighted variable
	
	// Handles instances of the py_yr_overall variable
	if `: list posof "py_yr_overall" in x' != 0 {
		qui: destring py_yr_overall, repalce ignore("*,-R %$")
		qui: rename py_yr_overall poverall
		la var poverall "Prior Year's Overall Score"	
	} // End of handling of the py_yr_overall variable
	
	// Handles instances of the  variable
	if `: list posof "stdnt_tested_cnt" in x' != 0 {
		
		// Standardizes the name of the variable
		qui: rename stdnt_tested_cnt tested
		
		qui: replace tested = 	cond(tested == "---", ".d", 				 ///   
								cond(tested == "***", ".s", tested))
		
		// Recast to numeric value
		qui: destring tested, replace ignore("*,-R %$")
		
		// Applies a variable label to the variable
		la var tested "Number of Students Tested" 
		
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_mean_score" in x' != 0 {
		qui: rename english_mean_score acthsengsc
		qui: destring acthsengsc, replace ignore("*,-R %$")
		la var acthsengsc "ACT Average English Score"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_bnchmrk_pct" in x' != 0 {
		qui: rename english_bnchmrk_pct acthsengpct
		qui: destring acthsengpct, replace ignore("*,-R %$")
		la var acthsengpct "% of Students Meeting ACT English Benchmark"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "mathematics_mean_score" in x' != 0 {
		qui: rename mathematics_mean_score acthsmthsc
		qui: destring acthsmthsc, replace ignore("*,-R %$")
		la var acthsmthsc "ACT Average Mathematics Score"
	} // End of handling of the  variable
	
	// Handles instances of the mathematics_bnchmrk_pct variable
	if `: list posof "mathematics_bnchmrk_pct" in x' != 0 {
		qui: rename mathematics_bnchmrk_pct acthsmthpct
		qui: destring acthsmthpct, replace ignore("*,-R %$")
		la var acthsmthpct "% of Students Meeting ACT Mathematics Benchmark"
	} // End of handling of the mathematics_bnchmrk_pct variable
	
	// Handles instances of the reading_mean_score variable
	if `: list posof "reading_mean_score" in x' != 0 {
		qui: rename reading_mean_score acthsrlasc
		qui: destring acthsrlasc, replace ignore("*,-R %$")
		la var acthsrlasc "ACT Average Reading Score"
	} // End of handling of the reading_mean_score variable
	
	// Handles instances of the reading_bnchmrk_pct variable
	if `: list posof "reading_bnchmrk_pct" in x' != 0 {
		qui: rename reading_bnchmrk_pct acthsrlapct
		qui: destring acthsrlapct, replace ignore("*,-R %$")
		la var acthsrlapct "% of Students Meeting ACT Reading Benchmark"
	} // End of handling of the reading_bnchmrk_pct variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_mean_score" in x' != 0 {
		qui: rename science_mean_score acthsscisc
		qui: destring acthsscisc, replace ignore("*,-R %$")
		la var acthsscisc "ACT Average Science Score"
	} // End of handling of the science_mean_score variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_bnchmrk_pct" in x' != 0 {
		qui: rename science_bnchmrk_pct acthsscipct
		qui: destring acthsscipct, replace ignore("*,-R %$")
		la var acthsscipct "% of Students Meeting ACT Science Benchmark"
	} // End of handling of the science_mean_score variable
	
	// Handles instances of the composite_mean_score variable
	if `: list posof "composite_mean_score" in x' != 0 {
		qui: rename composite_mean_score acthscmpsc
		qui: destring acthscmpsc, replace ignore("*,-R %$")
		la var acthscmpsc "ACT Average Composite Score"
	} // End of handling of the composite_mean_score variable
	
	// Handles instances of the stdnt_tested_bnchmrk_cnt variable
	if `: list posof "stdnt_tested_bnchmrk_cnt" in x' != 0 {
		qui: rename stdnt_tested_bnchmrk_cnt bnchmrktested
		qui: destring bnchmrktested, replace ignore("*,-R %$")
		// Need to verify the contents of this data element
		la var bnchmrktested "Number of Students Tested for ACT Benchmarks"
	} // End of handling of the stdnt_tested_bnchmrk_cnt variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_rate" in x' != 0 {
		qui: rename attendance_rate ada
		qui: destring ada, replace ignore("*,-R %$")
		la var ada "Average Daily Attendance Rate"
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_target" in x' != 0 {
		qui: rename attendance_target adagoal
		qui: destring adagoal, replace ignore("*,-R %$")
		la var adagoal "Average Daily Attendance Rate Target"
	} // End of handling of the  variable
	
	// Handles instances of the met_academic_ind variable
	if `: list posof "met_academic_ind" in x' != 0 {
		qui: rename met_academic_ind othamo
		qui: replace othamo = 	cond(othamo == "No", "0", 					 ///   
								cond(othamo == "Yes", "1", ""))
		qui: destring othamo, replace ignore("*,-R %$")
		la val othamo othamo
		la var othamo "Annual Measurable Objectives - Other Academic Indicator"
	} // End of handling of the met_academic_ind variable
	
	// Handles instances of the number_enrolled variable
	if `: list posof "number_enrolled" in x' != 0 {
		qui: rename number_enrolled membership
		qui: destring membership, replace ignore("*,-R %$")
		la var membership "Number of Students Enrolled"
	} // End of handling of the  variable
	
	// Handles instances of the number_tested variable
	if `: list posof "number_tested" in x' != 0 {
		qui: rename number_tested tested 
		qui: destring tested, replace ignore("*,-R %$")
		la var tested "Number of Students Tested"
	} // End of handling of the number_tested variable
	
	// Handles instances of the participation_rate variable
	if `: list posof "participation_rate" in x' != 0 {
		qui: rename participation_rate partic 
		qui: destring partic, replace ignore("*,-R %$")
		la var partic "Participation Rate"
	} // End of handling of the participation_rate variable
	
	// Handles instances of the particip_rate variable
	if `: list posof "particip_rate" in x' != 0 {
		qui: rename particip_rate partic 
		qui: destring partic, replace ignore("*,-R %$")
		la var partic "Participation Rate"
	} // End of handling of the particip_rate variable
	
	// Handles instances of the met_participation_rate variable
	if `: list posof "met_participation_rate" in x' != 0 {
		qui: rename met_participation_rate metpartic
		qui: replace metpartic = 	cond(metpartic == "N/A", ".n", 			 ///   
									cond(metpartic == "No", "0",			 ///   
									cond(metpartic == "Yes", "1", "")))
		qui: destring metpartic, replace ignore("*,-R %$")
		la val metpartic metpartic
		la var metpartic "Participation Rate Status"
	} // End of handling of the met_participation_rate variable
	
		// Handles instances of the Program Review Summative Variables
	if `: list posof "progrev_total_points" in x' != 0 {
		rename (progrev_total_points progrev_total_score)(prtotpts prtotsc)
		foreach v of var prtotpts prtotsc {
			qui: replace `v' = ".n" if `v' == "N/A"
		}
		qui: destring prtotpts prtotsc, replace ignore("*,-R %$")
		la var prtotpts "Program Review Total Points"
		la var prtotsc "Program Review Total Score"
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
		qui: destring ahlev ahcia ahassess ahprofdev ahadmin ahtotpts, 		 ///   
		replace	ignore("*,-R")		
		la val ahlev ahlev
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
		qui: destring pllev plcia plassess plprofdev pladmin pltotpts, 		 ///   
		replace	ignore("*,-R %$")
		la val pllev pllev
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
		qui: destring wrlev wrcia wrassess wrprofdev wradmin wrtotpts, 		 ///   
		replace	ignore("*,-R %$")
		la val wrlev wrlev
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
		qui: destring k3lev k3cia k3assess k3profdev k3admin k3totpts, 		 ///   
		replace	ignore("*,-R %$")
		
		la val k3lev k3lev
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
		qui: destring wllev wlcia wlassess wlprofdev wladmin wltotpts, 		 ///   
		replace	ignore("*,-R %$")
		la val wllev wllev
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
		qui: destring rlapctile, replace  ignore("*,-R %$")
		la var rlapctile "Novice Reduction Reading Percentile"	
	} // End of handling of the reading_percentile variable
	
	// Handles instances of the mathematics_percentile variable
	if `: list posof "mathematics_percentile" in x' != 0 {
		qui: rename mathematics_percentile mthpctile 
		qui: replace mthpctile = ".s" if mthpctile == "***"
		qui: destring mthpctile, replace  ignore("*,-R %$")
		la var mthpctile "Novice Reduction Mathematics Percentile"	
	} // End of handling of the mathematics_percentile variable
	
	// Handles instances of the science_percentile variable
	if `: list posof "science_percentile" in x' != 0 {
		qui: rename science_percentile scipctile
		qui: replace scipctile = ".s" if scipctile == "***"
		qui: destring scipctile, replace ignore("*,-R %$")
		la var scipctile "Novice Reduction Science Percentile"	
	} // End of handling of the science_percentile variable
	
	// Handles instances of the social_percentile variable
	if `: list posof "social_percentile" in x' != 0 {
		qui: rename social_percentile socpctile
		qui: replace socpctile = ".s" if socpctile == "***"
		qui: destring socpctile, replace ignore("*,-R") 
		la var socpctile "Novice Reduction Social Studies Percentile"	
	} // End of handling of the social_percentile variable
	
	// Handles instances of the language_mechanics_percentile variable
	if `: list posof "language_mechanics_percentile" in x' != 0 {
		qui: rename language_mechanics_percentile lanpctile
		qui: replace lanpctile = ".s" if lanpctile == "***"
		qui: destring lanpctile, replace  ignore("*,-R %$")
		la var lanpctile "Novice Reduction Language Mechanics Percentile"	
	} // End of handling of the language_mechanics_percentile variable
	
	if `: list posof "totalsenior_enroll" in x' != 0 {
		qui: rename totalsenior_enroll totenrsrs
		qui: destring totenrsrs, replace ignore("*,-R %$")
		la var totenrsrs "Total Number of Enrolled Seniors"
	}

	if `: list posof "prepsenior_enroll" in x' != 0 {
		qui: rename prepsenior_enroll prepenrsrs
		qui: destring prepenrsrs, replace ignore("*,-R %$")
		// Need to verify contents of this variable
		la var prepenrsrs "Total Number of Seniors Enrolled in Preparatory Program"
	}

	if `: list posof "collegeready" in x' != 0 {
		qui: rename collegeready collrdy
		qui: destring collrdy, replace ignore("*,-R %$")
		la var collrdy "Number of College Ready Students"
	}	

	if `: list posof "work_keys" in x' != 0 {
		qui: rename work_keys actwrkkeys
		qui: destring actwrkkeys, replace ignore("*,-R %$")
		la var actwrkkeys "Number of Students Scoring  on ACT WorkKeys"
	}	

	if `: list posof "asvab" in x' != 0 {
		qui: destring asvab, replace ignore("*,-R %$")
		la var asvab "Number of Students Scoring  or Higher on the ASVAB"
	}	

	if `: list posof "ind_certs" in x' != 0 {
		qui: rename ind_certs industrycert
		qui: destring industrycert, replace ignore("*,-R %$")
		la var industrycert "Number of Students Passing Industry Certification Exams"
	}	

	if `: list posof "kossa" in x' != 0 {
		qui: destring kossa, replace ignore("*,-R %$")
		la var kossa "Number of Students Score or Higher on the KOSSA Exam"
	}	

	if `: list posof "cr_total" in x' != 0 {
		qui: rename cr_total carrdy
		qui: destring carrdy, replace ignore("*,-R %$")
		la var carrdy "Number of Career Ready Students"
	}	

	if `: list posof "ccr_total" in x' != 0 {
		qui: rename ccr_total ccrn
		qui: destring ccrn, replace ignore("*,-R %$")
		la var ccrn "Number of College AND Career Ready Students"
	}	

	if `: list posof "total_ccr_pct" in x' != 0 {
		qui: rename total_ccr_pct ccrpct
		qui: destring ccrpct, replace ignore("*,-R %$")
		la var ccrpct "Total % of College AND Career Ready Students"
	}	 
	
	if `: list posof "performance_measure" in x' != 0 {
		qui: g prknsmeasure = performance_measure
		qui: replace prknsmeasure = cond(regexm(prknsmeasure, "Read"), "1",	 ///   
									cond(regexm(prknsmeasure, "Math"), "2",  ///   
									cond(regexm(prknsmeasure, "Technical"), "3", ///   
									cond(regexm(prknsmeasure, "Scho"), "4",  ///   
									cond(regexm(prknsmeasure, "Grad"), "5",	 ///   
									cond(regexm(prknsmeasure, "Place"), "6", ///   
									cond(regexm(prknsmeasure, "Partic"), "7", ///   
									cond(regexm(prknsmeasure, "Compl"), "8", ""))))))))

		qui: destring prknsmeasure, replace
		la val prknsmeasure prknsmeasure
		la var prknsmeasure "Perkins Grant Performance Measures"
	}

	if `: list posof "benchmark_students" in x' != 0 {
		qui: rename benchmark_students bnchmrkprkns
		qui: destring bnchmrkprkns, replace ignore("*,-R %$")
		la var bnchmrkprkns "Number of Students in Perkins Grant Benchmarks"
	}	

	if `: list posof "performance_goal" in x' != 0 {
		qui: rename performance_goal prknsgoal
		qui: replace prknsgoal = cond(prknsgoal == "Not Met", "0",			 ///   
								 cond(prknsgoal == "Met", "1", ""))
		qui: destring prknsgoal, replace ignore("*,-R %$")
		la val prknsgoal prknsgoal
		la var prknsgoal "Was the Perkins Grant Goal Met?"
	}

	if `: list posof "total_enrollment" in x' != 0 {
		qui: rename total_enrollment prknsenr
		qui: destring prknsenr, replace ignore("*,-R %$")
		la var prknsenr "Total Number of Students Enrolled"
	}	

	
	// Handles instances of the  variable
	if `: list posof "target_level" in x' != 0 {
		loc tl target_level
		qui: replace target_level = cond(`rx'(`cl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`cl', "mid.*", 1) == 1, "2", "3"))
		qui: rename target_level level
		qui: destring level, replace ignore("*,-R %$")
		la val level level
		la var level "Educational Level" 
	
	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "target_type" in x' != 0 {
		qui: rename target_type target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(target == "Target", "2",				 ///   
								cond(target == "Numerator", "3",			 ///   
								cond(target == "Denominator", "4",			 ///   
								cond(target == "Met Target", "5", ""))))) 

	} // End of handling of the  variable
	
	if `: list posof "prior_setting" in x' != 0 {
		qui: rename prior_setting kstype
		qui: replace kstype = 	cond(kstype == "Unknown", ".u",				 ///   
								cond(kstype == "Any", "0",					 ///   
								cond(kstype == "Child Care", "1",			 ///   
								cond(kstype == "Head Start", "2",			 ///   
								cond(kstype == "Home", "3",					 ///   
								cond(kstype == "Other", "4",				 ///   
								cond(kstype == "State Funded", "5", "")))))))
		qui: destring kstype, replace ignore("*,-R %$")
		la val kstype kstype
		la var kstype "Kindergarten Screening Prior Setting Type"
	}

	// Kindergarten screening targets by year
	if `: list posof "kscreen_2013" in x' != 0 {
		qui: rename kscreen_# kscreen#
		foreach v of var kscreen* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: drop if inlist(`v', "No", "Yes")
			qui: destring `v', replace ignore("*,-R %$")
			la var `v' "Kindergarten Readiness Screening Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(kscreen*)
		qui: ds kscreen*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
	}
	
	// Handles Program Review Delivery Targets
	if `: list posof "pr_type" in x' != 0 {
		qui: rename pr_type prtargettype
		qui: replace prtargettype = cond(prtargettype == "NUMBER_PD", "1",	 ///   
									cond(prtargettype == "PERCENT_PD", "2", ""))
		qui: destring prtargettype, replace ignore("*,-R %$")
		la val prtargettype prtargettype
		la var prtargettype "Program Review Delivery Target Type"
		qui: rename pr_# progrev#
		foreach v of var progrev* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: drop if inlist(`v', "No", "Yes")
			qui: destring `v', replace ignore("*,-R %$")
			la var `v' "Program Review Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(progrev*)
		qui: ds progrev*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
	}

	
	
	// Handles instances of the  variable EQUITY_MEASURE
	if `: list posof "equity_measure" in x' != 0 {
	//Recodes equity measure variable with numeric values
		qui: replace equity_measure=cond(equity_measure == "Community Support and Involvement Composite", "1", ///
									cond(equity_measure == "Managing Student Conduct Composite", "2",  ///
									cond(equity_measure == "Overall Effectiveness of School Teachers and Leaders", "3",  ///
									cond(equity_measure == "Overall Student Growth Rating of Teachers and Leaders", "4", ///
									cond(equity_measure == "Percentage of new and Kentucky Teacher Internship Program (KTIP) teachers", "5", ///
									cond(equity_measure == "Percentage of Teacher Turnover", "6", ///
									cond(equity_measure == "School Leadership Composite", "7", ""))))))) ///
	//Rename Equity_Measure variable
	qui: rename equity_measure equmeas
	//Recasts the values to numeric types
	qui: destring equmeas,replace ignore("*,-R %$")
	//Applies value labels to the variable
	la val equmeas equmeas
	//Applies variable label to the variable
	la var equmeas "Equity Measure"
									
	} // End of handling of the Equity_Measure  variable
	
	// Handles instances of the EQ_LABEL variable
	if `: list posof "EQ_LABEL" in x' != 0 {
		qui: replace eq_label=cond(`rx'(eq_label, "Exemplary/ Accomplished.*", 1), "1", ///
							  cond(eq_label == "High/Expect.*", "2",         ///
							  cond(eq_label == "School-Level.*", "3",        ///
							  cond(eq_label == "Strongly Agree/Agree.*", "4")))) 
		qui: rename eq_label eqlabel
		qui: destring eqlabel, replace ignore("*,-R %$")
		la val eqlabel eqlabel
		la var eqlabel "Equity Label"
	} // End of handling of the EQ_LABEL variable
	
	// Handles instances of the EQ_PCT variable
	if `: list posof "eq_pct" in x' != 0 {
	qui: rename eq_pct eqpct
		qui: destring eqpct, replace ignore("*,-R %$")
		la var eqpct "Equity Percent"
	} // End of handling of the EQ_PCT variable
	
	// Handles instances of the PROGRAM_TYPE variable
	if `: list posof "program_type" in x' != 0 {
		qui: replace program_type=cond(program_type == "English Language Learners (ELL)", "1", ///
								  cond(program_type == "Migrant","2",            ///
								  cond(program_type == "Special Education","3",  ///
								  cond(program_type == "Gifted and Talented","4")))) 
		qui: rename program_type progtype
		qui: desting progtype,replace ignore("*,-R %$")
		la val progtype progtype
		la var progtype "Program Type"
	} // End of handling of the PROGRAM_TYPE variable
	
	// Handles instances of the TOTAL_CNT variable
	if `: list posof "total_cnt" in x' != 0 {
		qui: rename total_cnt membership
		qui: destring membership, replace ignore("*,-R %$")
		la var membership "Total Student Membership"
	} // End of handling of the TOTAL_CNT variable
	
	// Handles instances of the TOTAL_PCT variable
	if `: list posof "total_pct" in x' != 0 {
		qui: rename total_pct totpct
		qui: destring totpct, replace ignore("*,-R %$")
		la var totpct "Total Percent of Students"
	} // End of handling of the TOTAL_PCT variable
	
	//Handles instances of the WHITE_CNT variable
	if `: list posof "white_cnt" in x' != 0 {
		qui: rename white_cnt nwhite
		qui: destring nwhite, replace ignore("*,-R %$")
		la var nwhite "Number of White Students"
	} // End of handling of the WHITE_CNT variable
	
	//Handles instances of the BLACK_CNT variable
	if `: list posof "black_cnt" in x' != 0 {
		qui: rename black_cnt nblack
		qui: destring nblack, replace ignore("*,-R %$")
		la var nblack "Number of Black Students"
	} // End of handling of the BLACK_CNT variable
	
	//Handles instances of the HISPANIC_CNT variable
	if `: list posof "hispanic_cnt" in x' != 0 {
		qui: rename hispanic_cnt nhisp
		qui: destring nhisp, replace ignore("*,-R %$")
		la var nhisp "Number of Hispanic/Latino(a) Students"
	} // End of handling of the HISPANIC_CNT variable
	
	//Handles instances of the Asian_CNT variable
	if `: list posof "asian_cnt" in x' != 0 {
		qui: rename asian_cnt nasian
		qui: destring nasian, replace ignore("*,-R %$")
		la var nasian "Number of Asian Students"
	} // End of handling of the Asian_CNT variable
	
	//Handles instances of the AIAN_CNT variable
	if `: list posof "aian_cnt" in x' != 0 {
		qui: rename aian_cnt nnatam
		qui: destring nnatam, replace ignore("*,-R %$")
		la var nnatam "Number of American Indian/Alaskan Native Students"
	} // End of handling of the AIAN_CNT variable
	
	//Handles instances of the HAWAIIAN_CNT variable
	if `: list posof "hawaiian_cnt" in x' != 0 {
		qui: rename hawaiian_cnt npacisl
		qui: destring npacisl, replace ignore("*,-R %$")
		la var npacisl "Number of Native Hawaiian/Pacific Islander Students"
	} // End of handling of the HAWAIIAN_CNT variable
	
	//Handles instances of the OTHER_CNT variable
	if `: list posof "other_cnt" in x' != 0 {
		qui: rename other_cnt nmulti
		qui: destring nmulti, replace ignore("*,-R %$")
		la var nmulti "Number of Multiracial Students"
	} // End of handling of the OTHER_CNT variable
	
	//Handles instances of the MALE_CNT variable
	if `: list posof "male_cnt" in x' != 0 {
		qui: rename male_cnt nmale
		qui: destring nmale, replace ignore("*,-R %$")
		la var nmale "Number of Male Students"
	} // End of handling of the MALE_CNT variable
	
	//Handles instances of the FEMALE_CNT variable
	if `: list posof "female_cnt" in x' != 0 {
		qui: rename female_cnt nfemale
		qui: destring nfemale, replace ignore("*,-R %$")
		la var nfemale "Number of Female Students"
	} // End of handling of the FEMALE_CNT variable
	
	//Handles instances of the TOTAL_STDNT_CNT variable
	if `: list posof "total_stdnt_cnt" in x' != 0 {
		qui: rename total_stdnt_cnt membership
		qui: destring membership, replace ignore("*,-R %$")
		la var membership "Total Membership"
	} // End of handling of the TOTAL_STDNT_CNT variable
	
	//Handles instances of the TOTAL_UNIQUE_EVENT_CNT variable
	if `: list posof "total_unique_event_cnt" in x' != 0 {
		qui: rename total_unique_event_cnt totevents
		qui: destring totevents, replace ignore("*,-R %$")
		la var totevents "Total Unique Event Count"
	} // End of handling of the TOTAL_UNIQUE_EVENT_CNT variable
	
	//Handles instances of the RPT_HEADER variable
	if `: list posof "rpt_header" in x' != 0 {
		qui: replace rpt_header = cond(rpt_header == "Behavior Events", "1", ///
			  cond(rpt_header == "Behavior Events by Context", "2",       	 ///
			  cond(rpt_header == "Behavior Events by Grade Level", "3",   	 ///
			  cond(rpt_header == "Behavior Events by Locations"," 4",     	 ///
			  cond(rpt_header == "Behavior Events by Socio-Economic Status", "5",  ///
			  cond(rpt_header == "Discipline Resolutions", "6",           	 ///
			  cond(rpt_header == "Discipline-Resolutions", "7",           	 ///
			  cond(rpt_header == "Legal Sanctions", "8", ""))))))))		  
		qui: rename rpt_header rpthdr
		qui: desting rpthdr,replace ignore("*,-R %$")
		la val rpthdr rpthdr
		la var rpthdr "Report Header"
	} // End of handling of the RPT_HEADER variable
	
	//Handles instances of the RPT_HEADER_ORDER variable
	if `: list posof "rpt_header_order" in x' != 0 {
		qui: rename rpt_header_order rpthdrodr
		qui: destring rpthdrodr, replace ignore("*,-R %$")
		la var rpthdrodr "Report Header Order"
	} // End of handling of the RPT_HEADER_ORDER variable
	
	//Handles instance of the RPT_LINE_ORDER variable
	if `: list posof "rpt_line_order" in x' != 0 {
	qui: rename rpt_line_order rptlnodr
	qui: destring rptlnodr, replace ignore("*,-R %$")
	la var rptlnodr "Report Line Order"
	} // End of handling of the RPT_LINE_ORDER variable
	
	//Handles instance of the SPENDING_PER_STDNT variable
	if `: list posof "spending_per_stdnt" in x' != 0 {
		qui: rename spending_per_stdnt ppe
		qui: destring ppe, replace ignore("*,-R %$")
		la var ppe "Per-Pupil Expenditure"
	} // End of handling of the SPENDING_PER_STDNT variable
	
	//Handles instance of the AVG_DAILY_ATTENDANCE variable
	if `: list posof "avg_daily_attendance" in x' != 0 {
		qui: rename avg_daily_attendance ada
		qui: destring ada, replace ignore("*,-R %$")
		la var ada "Average Daily Attendance"
	} // End of handling of the AVG_DAILY_ATTENDANCE variable
	
	//Handles instance of the MEMBERSHIP_TOTAL variable
	if `: list posof "membership_total" in x' != 0 {
		qui: rename membership_total membership
		qui: destring membership, replace ignore("*,-R %$")
		la var membership "Total Student Membership"
	} // End of handling of the MEMBERSHIP_TOTAL variable
	
	//Handles instance of the MEMBERSHIP_MALE_CNT variable
	if `: list posof "membership_male_cnt" in x' != 0 {
		qui: rename membership_male_cnt namle
		qui: destring nmale, replace ignore("*,-R %$")
		la var nmale "Number of Male Students"
	} // End of handling of the MEMBERSHIP_MALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_MALE_PCT variable
	if `: list posof "membership_male_pct" in x' != 0 {
		qui: rename membership_male_pct pctmale
		qui: destring pctmale, replace ignore("*,-R %$")
		la var pctmale "% of Male Students"
	} // End of handling of the MEMBERSHIP_MALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_CNT variable
	if `: list posof "membership_female_cnt" in x' != 0 {
		qui: rename membership_female_cnt nfemale
		qui: destring nfemale, replace ignore("*,-R %$")
		la var nfemale "Number of Female Students"
	} // End of handling of the MEMBERSHIP_FEMALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_PCT variable
	if `: list posof "membership_female_pct" in x' != 0 {
		qui: rename membership_female_pct pctfemale
		qui: destring pctfemale, replace ignore("*,-R %$")
		la var pctfemale "% of Female Students"
	} // End of handling of the MEMBERSHIP_FEMALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_CNT variable
	if `: list posof "membership_white_cnt" in x' != 0 {
		qui: rename membership_white_cnt nwhite
		qui: destring nwhite, replace ignore("*,-R %$")
		la var nwhite "Number of White Students"
	} // End of handling of the MEMBERSHIP_WHITE_CNT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_PCT variable
	if `: list posof "membership_white_pct" in x' != 0 {
		qui: rename membership_white_pct pctwhite
		qui: destring pctwhite, replace ignore("*,-R %$")
		la var pctwhite "% of White Students"
	} // End of handling of the MEMBERSHIP_WHITE_PCT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_CNT variable
	if `: list posof "membership_black_cnt" in x' != 0 {
		qui: rename membership_black_cnt nblack
		qui: destring nblack, replace ignore("*,-R %$")
		la var nblack "Number of Black Students"
	} // End of handling of the MEMBERSHIP_BLACK_CNT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_PCT variable
	if `: list posof "membership_black_pct" in x' != 0 {
		qui: rename membership_black_pct pctblack
		qui: destring pctblack, replace ignore("*,-R %$")
		la var pctblack "% of Black Students"
	} // End of handling of the MEMBERSHIP_BLACK_PCT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_CNT variable
	if `: list posof "membership_hispanic_cnt" in x' != 0 {
		qui: rename membership_hispanic_cnt nhisp
		qui: destring nhisp, replace ignore("*,-R %$")
		la var nhisp "Number of Hispanic/Latino(a) Students"
	} // End of handling of the MEMBERSHIP_HISPANIC_CNT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_PCT variable
	if `: list posof "membership_hispanic_pct" in x' != 0 {
		qui: rename membership_hispanic_pct pcthisp
		qui: destring pcthisp, replace ignore("*,-R %$")
		la var pcthisp "% of Hispanic/Latino(a) Students"
	} // End of handling of the MEMBERSHIP_HISPANIC_PCT variable
	
	//Handles instance of the MEMBERSHIP_ASAIN_CNT variable
	if `: list posof "membership_asian_cnt" in x' != 0 {
		qui: rename membership_asian_cnt nasian
		qui: destring nasian, replace ignore("*,-R %$")
		la var naisn "Number of Asian Students"
	} // End of handling of the MEMBERSHIP_ASIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_ASIAN_PCT variable
	if `: list posof "membership_asian_pct" in x' != 0 {
		qui: rename membership_asian_pct pctasian
		qui: destring pctasian, replace ignore("*,-R %$")
		la var pctasian "% of Asian Students"
	} // End of handling of the MEMBERSHIP_ASIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_CNT variable
	if `: list posof "membership_aian_cnt" in x' != 0 {
		qui: rename membership_aian_cnt natam
		qui: destring natam, replace ignore("*,-R %$")
		la var natam "Number of American Indian/Alaskan Native Students"
	} // End of handling of the MEMBERSHIP_AIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_PCT variable
	if `: list posof "membership_aian_pct" in x' != 0 {
		qui: rename membership_aian_pct pctaian
		qui: destring pctain, replace ignore("*,-R %$")
		la var pcthisp "% of American Indian/Alaskan Native Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_CNT variable
	if `: list posof "membership_hawaiian_cnt" in x' != 0 {
		qui: rename membership_hawaiian_cnt npacisl
		qui: destring npacisl, replace ignore("*,-R %$")
		la var napacisl "Number of Native Hawwaiian/Pacific Islander Students"
	} // End of handling of the MEMBERSHIP_HAWAIIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_PCT variable
	if `: list posof "membership_hawaiian_pct" in x' != 0 {
		qui: rename membership_hawaiian_pct pctpacisl
		qui: destring pctpacisl, replace ignore("*,-R %$")
		la var pctpacisl "% of Native Hawwaiian/Pacific Islander Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	if `: list posof "membership_two_or_more_cnt" in x' != 0 {
		qui: rename membership_two_or_more_cnt nmulti
		qui: destring nmulti, replace ignore("*,-R %$")
		la var nmulti "Number of Multiracial Students"
	} // End of handling of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_PCT variable
	if `: list posof "membership_two_or_more_pct" in x' != 0 {
		qui: rename membership_two_or_more_pct pctmulti
		qui: destring pctmulti, replace ignore("*,-R %$")
		la var pctmulti "% of Multiracial Students"
	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_CNT variable
	if `: list posof "enrollment_free_lunch_cnt" in x' != 0 {
		qui: rename enrollment_free_lunch_cnt nfreelnch
		qui: destring nfreelnch, replace ignore("*,-R %$")
		la var nfreelnch "Number of Free Lunch Students"
	} // End of handling of the ENROLLMENT_FREE_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_PCT variable
	if `: list posof "enrollment_free_lunch_pct" in x' != 0 {
		qui: rename enrollment_free_lunch_pct pctfreelnch
		qui: destring pctfreelnch, replace ignore("*,-R %$")
		la var pctfreelnch "% of Free Lunch Students"
	} // End of handling of the ENROLLMENT_FREE_LUNCH_PCT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	if `: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {
		qui: rename enrollment_reduced_lunch_cnt nredlnch
		qui: destring nredlnch, replace ignore("*,-R %$")
		la var nredlnch "Number of Reduced Lunch Students"
	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	if `: list posof "enrollment_reduced_lunch_pct" in x' !=0 {
		qui: rename enrollment_reduced_lunch_pct pctredlnch
		qui: destring pctredlnch, replace ignore("*,-R %$")
		la var pctredlnch "% of Reduced Lunch Students"
	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	
	if 	`: list posof "enrollment_free_lunch_cnt" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {	
		qui: g nfrl = nfreelnch + nredlnch
		la var nfrl "Number of Students Qualifying for Free/Reduced Price Lunch"
	}	
		
	if 	`: list posof "enrollment_free_lunch_pct" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_pct" in x' != 0 {	
		qui: g pctfrl = pctfreelnch + pctredlnch
		la var pctfrl "% of Students Qualifying for Free/Reduced Price Lunch"
	}	
		
	//Handles instance of the ATTENDANCE_RATE variable
	if `: list posof "attendance_rate" in x' !=0 {
		qui: rename attendance_rate attndrate
		qui: destring attndrate, replace ignore("*,-R %$")
		la var attndrate "Attendance Rate"
	} // End of handling of the ATTENDANCE_RATE variable
	
	//Handles instance of the RETENTION_RATE variable
	if `: list posof "retention_rate" in x' !=0 {
		qui: rename retention_rate retrate
		qui: destring retrate, replace ignore("*,-R %$")
		la var retrate "Retention Rate"
	} // End of handling of the RETENTION_RATE variable
	
	//Handles instance of the DROPOUT_RATE variable
	if `: list posof "dropout_rate" in x' !=0 {
		qui: rename dropout_rate droprate
		qui: destring droprate, replace ignore("*,-R %$")
		la var droprate "Dropout Rate"
	} // End of handling of the DROPOUT_RATE variable
	
	//Handles instance of the GRADUATION_RATE variable
	if `: list posof "graduation_rate" in x' !=0 {
		qui: rename graduation_rate gradrate
		qui: destring gradrate, replace ignore("*,-R %$")
		la var gradrate "Graduation Rate"
	} // End of handling of the GRADUATION_RATE variable
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_CNT
	if `: list posof "transition_college_inout_cnt" in x' !=0 {
		qui: rename transition_college_inout_cnt ncollege
		qui: destring ncollege, replace ignore("*,-R %$")
		la var ncollege "Number of Students Enrolled in College In/Out of State"
	} //End of handling of the TRANSITION_COLLEGE_INOUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_PCT
	if `: list posof "transition_college_inout_pct" in x' !=0 {
		qui: rename transition_college_inout_pct pctcollege
		qui: destring pctcollege, replace ignore("*,-R %$")
		la var pctcollege "% of Students Enrolled in College In/Out of State"
	} //End of handling of the TRANSITION_COLLEGE_INOUT_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_CNT
	if `: list posof "transition_college_in_cnt" in x' !=0 {
		qui: rename transition_college_in_cnt nincollege
		qui: destring nincollege, replace ignore("*,-R %$")
		la var nincollege "Number of Students Enrolled in College In State"
	} //End of handling of the TRANSITION_COLLEGE_IN_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_PCT
	if `: list posof "transition_college_in_pct" in x' !=0 {
		qui: rename transition_college_in_pct pctincollege
		qui: destring pctincollege, replace ignore("*,-R %$")
		la var pctincollege "% of Students Enrolled in College In State"
	} //End of handling of the TRANSITION_COLLEGE_IN_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_CNT
	if `: list posof "transition_college_out_cnt" in x' !=0 {
		qui: rename transition_college_out_cnt noutcollege
		qui: destring noutcollege, replace ignore("*,-R %$")
		la var noutcollege "Number of Students Enrolled in College Out of State"
	} //End of handling of the TRANSITION_COLLEGE_OUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_PCT
	if `: list posof "transition_college_out_pct" in x' !=0 {
		qui: rename transition_college_out_pct pctoutcollege
		qui: destring pctoutcollege, replace ignore("*,-R %$")
		la var pctoutcollege "% of Students Enrolled in College Out of State"
	} //End of handling of the TRANSITION_COLLEGE_OUT_PCT
	
	// Handles instances of the TEACHING_METHOD variable
	if `: list posof "teaching_method" in x' != 0 {
		qui: rename teaching_method pedagogy
		qui: replace method = cond(pedagogy == `"Credit Recovery - Digital Learning Provider"', "1", 	 ///
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
		qui: desting pedagogy, replace ignore("*,-R %$")
		la val pedagogy pedagogy
		la var pedagogy "Pedagogical/Instructional Methodology"
	} // End of handling of the TEACHING_METHOD variable
	
	//Handles instance of the ONSITE_CLASSROOM_CNT variable
	if `: list posof "onsite_classroom_cnt" in x' !=0 {
		qui: rename onsite_classroom_cnt nonstcls
		qui: destring numoncls, replace ignore ("*-R %")
		la var numoncls "Number of Onsite Classrooms"
	} //End of handling of the ONSITE_CLASSROOM_CNT variable
	
	//Handles instance of the OFFSITE_CTE_CNT variable
	if `: list posof "offsite_cte_cnt" in x' !=0 {
		qui: rename offsite_cte_cnt cteoffsite
		qui: destring cteoffsite, replace ignore ("*-R %")
		la var cteoffsite "Number of Offsite Career/Technical Education Classes"
	} //End of handling of the OFFSITE_CTE_CNT variable
	
	//Handles instance of the OFFSITE_COLLEGE_CNT variable
	if `: list posof "offsite_college_cnt" in x' !=0 {
		qui: rename offsite_college_cnt noffstcol
		qui: destring noffstcol, replace ignore ("*-R %")
		la var noffstcol "Number of Offsite College Classes"
	} //End of handling of the OFFSITE_COLLEGE_CNT variable
	
	//Handles instance of the HOME_HOSPITAL_CNT variable
	if `: list posof "home_hospital_count" in x' !=0 {
		qui: rename home_hospital_count nhosp
		qui: destring nhosp, replace ignore ("*-R %")
		la var nhosp "Number of Home Hospital Classes"
	} //End of handling of the HOME_HOSPITAL_CNT variable
	
	//Handles instance of the ONLINE_CNT varialbe
	if `: list posof "online_cnt" in x' !=0 {
		qui: rename online_cnt nonline
		qui: destring nonline, replace ignore ("*-R %")
		la var nonline "Number of Online Classes"
	} //End of handling of the ONLINE_CNT variable
	
	//Handles instance of the FINANACE_TYPE variable
	if `: list posof "finance_type" in x' !=0 {
		qui: rename finance_type fintype
		qui: replace fintype = cond(fintype == "FINANCIAL SUMMARY", "1",		 ///
							   cond(fintype == "SALARIES", "2",					 ///
							   cond(fintype == "SEEK", "3",						 ///
							   cond(fintype == "TAX", "4", ""))))				 ///
		qui: destring fintype, replace ignore ("*-R %")
		la val fintype fintype
		la var fintype "Finance Type"
	} //End of handling of the FINANCE_TYPE variable
	
	//Handles instance of the FINANACE_LABEL variable
	if `: list posof "finance_label" in x' !=0 {
		qui: rename finance_label finlabel
		qui: desting finlabel, replace ignore ("*-R %")
		la var fintype "Finance Lable"
	} //End of handling of the FINANCE_LABEL variable
	
	//Handles instance of the FINANACE_VALUE variable
	if `: list posof "finance_value" in x' !=0 {
		qui: rename finance_value finvalue
		qui: desting finvalue, replace ignore ("*-R %")
		la var finvalue "Finance Value"
	} //End of handling of the FINANCE_VALUE variable
	
	//Handles instance of the FINANACE_RANK variable
	if `: list posof "finance_rank" in x' !=0 {
		qui: rename finance_rank finrank
		qui: desting finrank, replace ignore ("*-R %")
		la var finrank "Finance Rank"
	} //End of handling of the FINANCE_RANK variable
	
	//Handles instance of the ENROLLMENT_CNT variable
	if `: list posof "enrollment_cnt" in x' !=0 {
		qui: rename enrollment_cnt membership
		qui: destring membership, replace ignore ("*-R %")
		la var membership "Total Enrollment"
	} //End of handling of the ENROLLMENT_CNT variable
	
	//Handles instance of the CERTIFICATION_CNT variable
	if `: list posof "certification_cnt" in x' !=0 {
		qui: rename certification_cnt ncert
		qui: destring ncert, replace ignore ("*-R %")
		la var ncert "Number of Certifications"
	} //End of handling of the CERTIFICATION_CNT variable
	
	// Handles instances of the CAREER_PATHWAY_DESC variable
	if `: list posof "career_pathway_desc" in x' != 0 {
		qui: rename career_pathway_desc ctepath
		qui: replace ctepath = cond(ctepath == `"ADMINISTRATION SUPPORT"', "1",  ///
				cond(ctepath == `"AGRIBIOTECHNOLOGY"', "2",    				 ///
				cond(ctepath == `"ANIMAL SYSTEMS"', "3", 				 	 ///
				cond(ctepath == `"BUSINESS TECHNOLOGY"', "4", 	 			 ///
				cond(ctepath == `"COMPUTER PROGRAMMING"', "5", 			 	 ///
				cond(ctepath == `"CONSUMER AND FAMILY MANAGEMENT"', "6", 	 ///
				cond(ctepath == `"FINANCE"', "7", 		 					 ///
				cond(ctepath == `"HORTICULTURE AND PLANT SCIENCES"', "8", 	 ///
				cond(ctepath == `"INFORMATION SUPPORT AND SERVICES"', "9", 	 ///
				cond(ctepath == `"TECHNOLOGY"', "10", "")))))))))) 					
		qui: desting ctepath,replace ignore("*,-R %$")
		la val ctepath ctepath
		la var ctepath "Career Pathways"
	} // End of handling of the CAREER_PATHWAY_DESC variable
	
	// Used to test for null records in the HS level CCR file
	if `: list ccrhs in x' != 0 {
		qui: egen ccrmissing = rowmiss(`ccrhs')
		qui: drop if ccrmissing == 8
		drop ccrmissing
		testpk distid schid schyr amogroup
	}

	// Used to test for null records in the MS level CCR file
	if `: list ccrms in x' != 0 {
		qui: egen ccrmissing = rowmiss(`ccrms')
		qui: drop if ccrmissing == 6
		drop ccrmissing
	}
	
	// Used to test for null records in the Accountability Growth file
	if `: list growvars in x' != 0 {
		qui: egen growmiss = rowmiss(`growvars')
		qui: drop if growmiss == 4
		qui: drop growmiss
	}
	
	// Check for primary key if user passed values to the parameter
	if `"`primarykey'"' != "" testpk `primarykey'
		
end		


// Sub process to check for optional primary key definition
prog def testpk
	syntax varlist 
	cap isid `varlist'
	if _rc == 0 di as res "Primary Key: `varlist' confirmed."
	else if _rc != 0 di as res "Primary Key: `varlist' failed."
end	
