// Drops program from memory if already loaded
cap prog drop kdestandardize

// Defines the program used to standardized KDE School Report card files
prog def kdestandardize, rclass

	version 14
	
	syntax [, 	DROPVars(string asis) GRade(integer 0) SCHYRLab(integer 0) 	 ///   
				PRIMARYKey(string asis) Metricvars(string asis) 			 ///   
				TABlename(passthru) ]
	
	// Check for required dependencies
	checkdep egenmore
	
	// Defines local macro to use to shorten command lengths
	loc rx ustrregexm
	
	// Defines local macro for use with removing records with no data from test files
	loc testlevs tested novice apprentice proficient distinguished
	
	// Defines local macro used to remove records with no data from ccr files
	loc ccrhs diplomas collready caracad cartech cartot pctwobonus pctwbonus
	
	// Defines local macro to test for middle school CCR bench mark null records
	loc ccrms tested msbnchmrkeng msbnchmrkrla msbnchmrkmth msbnchmrksci totmsccrpts
	
	// Defines local macro to test for growth null records
	loc growvars tested grorla gromth groboth
	
	// Drop any variables ID'd by user before constructing variable list
	if `"`dropvars'"' != "" cap drop `dropvars'

	// Define value labels that can be applied across files
	{
	
	// Identifies the kindergarten school type
	la def kstype -1 "Unknown" 0 "All Students" 1 "Child Care" 				 ///   
					2 "Head Start" 3 "Home" 4 "Other" 5 "State Funded", modify

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
	la def grade 	-2 "Early Childhood" -1 "Pre-K" 0 "Kindergarten" 		 ///   
					1 "1st Grade" 2 "2nd Grade"  3 "3rd Grade" 4 "4th Grade" ///   
					5 "5th Grade" 6 "6th Grade" 7 "7th Grade" 8 "8th Grade"  ///   
					9 "9th Grade" 10 "10th Grade" 11 "11th Grade" 			 ///   
					12 "12th Grade" 14 "IDEA" 15 "Kindergarten - 1st Grade"	 ///   
					16 "Kindergarten - 2nd Grade"							 ///   
					17 "Kindergarten - 3rd Grade"							 ///   
					18 "Kindergarten - 4th Grade"							 ///   
					19 "Kindergarten - 5th Grade"							 ///   
					20 "Kindergarten - 6th Grade"							 ///   
					21 "Kindergarten - 7th Grade"							 ///   
					22 "Kindergarten - 8th Grade"							 ///   
					23 "Kindergarten - 9th Grade"							 ///   
					24 "Kindergarten - 10th Grade"							 ///   
					25 "Kindergarten - 11th Grade"							 ///   
					26 "Kindergarten - 12th Grade"							 ///   
					27 "1st - 2nd Grade" 28 "1st - 3rd Grade"				 ///   
					29 "1st - 4th Grade" 30 "1st - 5th Grade"				 ///   
					31 "1st - 6th Grade" 32 "1st - 7th Grade"				 ///   
					33 "1st - 8th Grade" 34 "1st - 9th Grade"				 ///   
					35 "1st - 10th Grade" 36 "1st - 11th Grade"				 ///   
					37 "1st - 12th Grade" 38 "2nd - 3rd Grade"				 ///   
					39 "2nd - 4th Grade" 40 "2nd - 5th Grade"				 ///   
					41 "2nd - 6th Grade" 42 "2nd - 7th Grade"				 ///   
					43 "2nd - 8th Grade" 44 "2nd - 9th Grade"				 ///   
					45 "2nd - 10th Grade" 46 "2nd - 11th Grade"				 ///   
					47 "2nd - 12th Grade" 48 "3rd - 4th Grade"				 ///   
					49 "3rd - 5th Grade" 50 "3rd - 6th Grade"				 ///   
					51 "3rd - 7th Grade" 52 "3rd - 8th Grade"				 ///   
					53 "3rd - 9th Grade" 54 "3rd - 10th Grade"				 ///   
					55 "3rd - 11th Grade" 56 "3rd - 12th Grade"				 ///   
					57 "4th - 5th Grade" 58 "4th - 6th Grade"				 ///   
					59 "4th - 7th Grade" 60 "4th - 8th Grade"				 ///   
					61 "4th - 9th Grade" 62 "4th - 10th Grade"				 ///   
					63 "4th - 11th Grade" 64 "4th - 12th Grade"				 ///   
					65 "5th - 6th Grade" 66 "5th - 7th Grade"				 ///   
					67 "5th - 8th Grade" 68 "5th - 9th Grade"				 ///   
					69 "5th - 10th Grade" 70 "5th - 11th Grade"				 ///   
					71 "5th - 12th Grade" 72 "6th - 7th Grade"				 ///   
					73 "6th - 8th Grade" 74 "6th - 9th Grade"				 ///   
					75 "6th - 10th Grade" 76 "6th - 11th Grade"				 ///   
					77 "6th - 12th Grade" 78 "7th - 8th Grade"				 ///   
					79 "7th - 9th Grade" 80 "7th - 10th Grade"				 ///   
					81 "7th - 11th Grade" 82 "7th - 12th Grade"				 ///   
					83 "8th - 9th Grade" 84 "8th - 10th Grade"				 ///   
					85 "8th - 11th Grade" 86 "8th - 12th Grade"				 ///   
					87 "9th - 10th Grade" 88 "9th - 11th Grade"				 ///   
					89 "9th - 12th Grade" 90 "10th - 11th Grade"			 ///   
					91 "10th - 12th Grade" 92 "11th - 12th Grade"			 ///   
					93 "Elementary School" 94 "Middle School"				 /// 
					97 "Magical KDE Undefined Grade" 98 "Adult Education" 	 ///   
					99 "High School" 100 "All Grades", modify

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
		
		// Used if we want to make the schyr variable display full academic years
		la def schyrlong 2009 "2008-2009" 2010 "2009-2010" 2011 "2010-2011"	 ///   				
						 2012 "2011-2012" 2013 "2012-2013" 2014 "2013-2014"	 ///   
						 2015 "2014-2015" 2016 "2015-2016" 2017 "2016-2017"	 ///   
						 2018 "2017-2018" 2019 "2018-2019" 2020 "2019-2020", modify
		
		// Used if we want to make the schyr variable display shorter academic years
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
		
		// Defines value labels for program review domains
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
					 4 `"Gifted and Talented"'								 ///   
					 5 `"Homeless"', modify
					 
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
		
		// Defines the educational cooperative that the schools/districts belong to
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

		// Renames the variable to standardized name 
		qui: rename sch_year schyr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' schyr

		// Adds a variable label to this variable 
		la var schyr "School Year"

	} // End handling of the sch_year variable
		
	// Handles instances of the sch_cd variable 	
	if `: list posof "sch_cd" in x' != 0 { 
		qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3

		// Renames the variable to standardized name 
		qui: rename sch_cd schid

		// Adds a variable label to this variable 
		la var schid "Unique School ID"	

	}
	
	// Handles instances of the dist_number variable in a file
	if `: list posof "dist_number" in x' != 0 {  
		qui: replace dist_number = substr(schid, 1, 3) if mi(dist_number)

		// Renames the variable to standardized name 
		qui: rename dist_number distid

		// Adds a variable label to this variable 
		la var distid "District ID"

	}
	
	// Handles instances of the sch_number variable in a file
	if `: list posof "sch_number" in x' != 0 { 
		qui: replace sch_number = substr(schid, 4, 6) if mi(sch_number)

		// Renames the variable to standardized name 
		qui: rename sch_number schnum

		// Adds a variable label to this variable 
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

		// Renames the variable to standardized name 
		qui: rename content_level level

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' level

		// Adds a variable label to this variable 
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

		// Renames the variable to standardized name 
		qui: rename test_type testnm
		
		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' testnm
		
		// Applies variable label to the variable

		// Adds a variable label to this variable 
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

		// Renames the variable to standardized name 
		qui: rename content_type content
		
		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' content
		
		// Applies a variable label to the variable

		// Adds a variable label to this variable 
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
								  

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' tested
		
		// Applies a variable label to the variable

		// Adds a variable label to this variable 
		la var tested "# of Students Tested" 
		

	} // End handling of the nbr_tested variable
	
	// Handles instances of the grade variable
	if `: list posof "grade" in x' != 0 {
		qui: replace grade = "99" if grade == "EO"
		qui: replace grade = ustrregexra(grade, "[gG][rR][aA][dD][eE] ", "")
		qui: replace grade = cond(grade == "K", "0", cond(grade == "00", "97", grade))
		qui: replace grade = "100" if mi(grade) & inlist(schyr, "2012", "2013") & ///   
		`: list posof "two_or_more_race_male_cnt" in x' != 0

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' grade

		// Adds a variable label to this variable 
		la var grade "Grade Level" 

	}
	
	// Handles instances of the grade_level variable
	if `: list posof "grade_level" in x' != 0 {
		rename grade_level grade
		qui: replace grade = "15" if grade == "EO"
		qui: replace grade = ustrregexra(grade, "[gG][rR][aA][dD][eE] ", "")
		qui: replace grade = cond(grade == "K", "0", cond(grade == "00", "97", grade))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' grade

		// Adds a variable label to this variable 
		la var grade "Grade Level" 

	}
	
	// If grade_level doesn't exist in the file
	else {
		if `grade' != 0 {
			qui: g grade = "`grade'"

			// Adds to list of variables that need to be recast as numeric 
			loc torecast `torecast' grade

			// Adds a variable label to this variable 
			la var grade "Grade Level" 
		}

	}	
	
	// Handles instances of the reward_recognition variable
	if `: list posof "reward_recognition" in x' != 0 {
	
		// Renames reward_recognition variable

		// Renames the variable to standardized name 
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
		

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' reward
		
		// Applies variable label to the reward variable

		// Adds a variable label to this variable 
		la var reward "Differentiated Accountability Reward Status"


	} // End handling of reward_recognition variable
	
	// Handles instances of the  variable
	if `: list posof "pct_novice" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_novice novice
		qui: replace novice = ".n" if novice == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' novice

		// Adds a variable label to this variable 
		la var novice "% of Students Scoring Novice"


	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_apprentice" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_apprentice apprentice
		qui: replace apprentice = ".n" if apprentice == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' apprentice

		// Adds a variable label to this variable 
		la var apprentice "% of Students Scoring Apprentice"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_proficient" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_proficient proficient
		qui: replace proficient = ".n" if proficient == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' proficient

		// Adds a variable label to this variable 
		la var proficient "% of Students Scoring Proficient"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "pct_distinguished" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_distinguished distinguished
		qui: replace distinguished = ".n" if distinguished == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' distinguished

		// Adds a variable label to this variable 
		la var distinguished "% of Students Scoring Distinguished"

	} // End of handling of the  variable
	
	if `: list posof "pct_proficient_distinguished" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_proficient_distinguished profdist
		qui: replace profdist = ".n" if profdist == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' profdist

		// Adds a variable label to this variable 
		la var profdist "% of Students Scoring Proficient or Distinguished"

	} // End of handling of the  variable
	
	if `: list posof "pct_bonus" in x' != 0 {
		rename pct_bonus napdbonus

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' napdbonus

		// Adds a variable label to this variable 
		la var napdbonus "% Points added to the NAPD calculation if # distinguished > # novice"

	}	

	
	// Handles dropping records containing no test data if file contains test data
	if `: list testlevs in x' != 0 {
		qui: egen testmiss = rowmiss(tested novice apprentice proficient distinguished)
		qui: drop if testmiss == 5
		qui: drop testmiss

	} // End of handling of null records

			// Adds to list of variables that need to be recast as numeric 
			loc torecast `torecast' 

	// Handles instances of the participation_next_yr variable
	if `: list posof "participation_next_yr" in x' != 0 {
		
		// Short hand reference for the variable
		rename participation_next_yr nextpartic
		qui: replace nextpartic = ".n" if nextpartic == "N/A"
		
		// Use numeric encodings for participation rate field
		qui: replace nextpartic = cond(nextpartic == "No", "0", cond(nextpartic == "Yes", "1", ""))
		
		la copy met nextpartic
		

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nextpartic
		

		// Adds a variable label to this variable 
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
		

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gradgoal
		
		// Label the variable

		// Adds a variable label to this variable 
		la var gradgoal "Graduation Rate Goal"
							 

	} // End of handling of the graduation_rate_goal variable
	
	// Handles instances of the base_yr_score variable
	if `: list posof "base_yr_score" in x' != 0 {
	
		// Create shorthand reference for variable
		rename base_yr_score baseline
	
		// Replace all instances of -R with missing value in base year score						
		qui: replace baseline = subinstr(baseline, "-R", "", .)	
		

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' baseline
		
		// Apply variable label

		// Adds a variable label to this variable 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' `cv'
							
		// Defines variable label for the variable					

		// Adds a variable label to this variable 
		la var classification "Differentiated Accountability Status Indicator"
							

	} // End of handling of the classification variable
	
	// Handles instances of the overall_score variable
	if `: list posof "overall_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename overall_score overall

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' overall

		// Adds a variable label to this variable 
		la var overall "Overall Points in Accountability Model"

	} // End of handling of the overall_score variable
	
	// Handles instances of the ky_rank variable
	if `: list posof "ky_rank" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ky_rank rank 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' rank

		// Adds a variable label to this variable 
		la var rank "Rank of Schools/Districts Across the State"

	} // End of handling of the ky_rank variable
	
	// Handles instances of the gain_needed variable
	if `: list posof "gain_needed" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename gain_needed amogain
		qui: replace amogain = strofreal(real(amo_goal) - real(baseline)) if ///   
		mi(amogain) & !mi(real(amo_goal)) & !mi(baseline)

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' amogain

		// Adds a variable label to this variable 
		la var amogain "Gain Needed to meet AMOs"

	} // End of handling of the gain_needed variable
	
	// Handles instances of the amo_goal variable
	if `: list posof "amo_goal" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename amo_goal amogoal 
		qui: replace amogoal = strofreal(real(baseline) + real(amogain)) if  ///   
		mi(amogoal) & !mi(baseline) & !mi(amogain)

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' amogoal

		// Adds a variable label to this variable 
		la var amogoal "Annual Measureable Objectives Goal"

	} // End of handling of the amo_goal variable	
	
	// Handles instances of the amo_met variable
	if `: list posof "amo_met" in x' != 0 {
		rename amo_met amomet
		qui: replace amomet = 	cond(amomet == "No", "0", 					 ///   
								cond(amomet == "Yes", "1", ""))
		qui: destring amomet, replace ignore("*,-R %$")
		cap char amomet[destring] ""
		cap char amomet[destring_cmd] ""
		qui: replace amomet = cond(mi(amogoal), .,							 ///   
							  cond(mi(amomet) & overall >= amogoal, 1,		 ///   
							  cond(mi(amomet) & overall < amogoal, 0, amomet)))
		la val amomet amomet

		// Adds a variable label to this variable 
		la var amomet "AMO Status Indicator"

	} // End of handling of the amo_met variable
	
	// Handles instances of the distnm variable
	if `: list posof "dist_name" in x' != 0 {

		// Renames the variable to standardized name 
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
		

		// Adds a variable label to this variable 
		la var distnm "District Name"

	} // End of handling of the distnm variable
	
	// Handles instances of the cntyno variable
	if `: list posof "cntyno" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cntyno cntyid

		// Adds a variable label to this variable 
		la var cntyid "County ID"

	} // End of handling of the cntyno variable
	
	// Handles instances of the coop_code variable
	if `: list posof "coop_code" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename coop_code coopid 

		// Adds a variable label to this variable 
		la var coopid "Cooperative ID Number"

	} // End of handling of the coop_code variable
	
	// Handles instances of the cntyname variable
	if `: list posof "cntyname" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cntyname cntynm

		// Adds a variable label to this variable 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' coop

		// Adds a variable label to this variable 
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

		// Adds a variable label to this variable 
		la var leaid "National Center for Educational Statistics LEA ID"

		// Adds a variable label to this variable 
		la var ncesid "National Center for Educational Statistics School ID"

	} // End of handling of the ncesid variable
	
	// Handles instances of the nbr_graduates_with_diploma variable
	if `: list posof "nbr_graduates_with_diploma" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename nbr_graduates_with_diploma diplomas

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' diplomas

		// Adds a variable label to this variable 
		la var diplomas "# of Students Graduating with Regular High School Diplomas"
	

	} // End of handling of the nbr_graduates_with_diploma variable
	
	// Handles instances of the college_ready variable
	if `: list posof "college_ready" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename college_ready collready

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' collready

		// Adds a variable label to this variable 
		la var collready "# of College Ready Students" 	

	} // End of handling of the college_ready variable
	
	// Handles instances of the career_ready_academic variable
	if `: list posof "career_ready_academic" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename career_ready_academic caracad 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' caracad

		// Adds a variable label to this variable 
		la var caracad "# of Career Ready Students (Academic)" 	

	} // End of handling of the career_ready_academic variable
	
	// Handles instances of the career_ready_technical variable
	if `: list posof "career_ready_technical" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename career_ready_technical cartech

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cartech

		// Adds a variable label to this variable 
		la var cartech "# of Career Ready Students (Technical)" 	

	} // End of handling of the career_ready_technical variable
	
	// Handles instances of the career_ready_total variable
	if `: list posof "career_ready_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename career_ready_total cartot

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cartot

		// Adds a variable label to this variable 
		la var cartot "# of Career Ready Students (Total)" 	

	} // End of handling of the career_ready_total variable
	
	// Handles instances of the nbr_ccr_regular variable
	if `: list posof "nbr_ccr_regular" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename nbr_ccr_regular nccr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nccr

		// Adds a variable label to this variable 
		la var nccr "Number Regular College/Career Ready"

	} // End of handling of the nbr_ccr_regular variable
	
	// Handles instances of the pct_ccr_no_bonus variable
	if `: list posof "pct_ccr_no_bonus" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_ccr_no_bonus pctwobonus

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctwobonus

		// Adds a variable label to this variable 
		la var pctwobonus "% College/Career Ready w/o Bonus"

	} // End of handling of the pct_ccr_no_bonus variable
	
	// Handles instances of the pct_ccr_with_bonus variable
	if `: list posof "pct_ccr_with_bonus" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_ccr_with_bonus pctwbonus	

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctwbonus

		// Adds a variable label to this variable 
		la var pctwbonus "% College/Career Ready w/ Bonus"

	} // End of handling of the pct_ccr_with_bonus variable
	
	// Handles instances of the total_points variable
	if `: list posof "total_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_points totpts	

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' totpts

		// Adds a variable label to this variable 
		la var totpts "Total Points"

	} // End of handling of the total_points variable
	
	// Handles instances of the napd_calculation variable
	if `: list posof "napd_calculation" in x' != 0 {
		qui: replace napd_calculation = ".n" if napd_calculation == "N/A"

		// Renames the variable to standardized name 
		qui: rename napd_calculation napd	

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' napd

		// Adds a variable label to this variable 
		la var napd "Novice * 0 + Apprentice + 0.5 + Proficient + Distinguished"

	} // End of handling of the napd_calculation variable
	
	// Handles instances of the reading_pct variable
	if `: list posof "reading_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading_pct grorla

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' grorla

		// Adds a variable label to this variable 
		la var grorla "% of Students Meeting Growth in Reading"

	} // End of handling of the reading_pct variable
	
	// Handles instances of the math_pct variable
	if `: list posof "math_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename math_pct gromth

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gromth

		// Adds a variable label to this variable 
		la var gromth "% of Students Meeting Growth in Math"

	} // End of handling of the math_pct variable
	
	// Handles instances of the reading_math_pct variable
	if `: list posof "reading_math_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading_math_pct groboth

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' groboth

		// Adds a variable label to this variable 
		la var groboth "% of Students Meeting Growth in Reading AND Math"

	} // End of handling of the reading_math_pct variable
	
	// Handles instances of the latitude variable
	if `: list posof "latitude" in x' != 0 {

		// Creates a double type variable to store latitude
		qui: g double lat = real(ustrregexra(latitude, "[\t\r\n\s ]+", ""))

		// Adds a variable label to this variable 
		la var lat "Latitude"

		// Drops original variable from file
		drop latitude

	} // End of handling of the latitude variable
	
	// Handles instances of the longitude variable
	if `: list posof "longitude" in x' != 0 {

		// Creates a double type variable to store longitude
		qui: g double lon = real(ustrregexra(longitude, "[\t\r\n\s ]+", ""))

		// Adds a variable label to this variable 
		la var lon "Longitude"

		// Drops original longitude variable
		drop longitude

	} // End of handling of the longitude variable
	
	// Handles instances of the sch_type variable
	if `: list posof "sch_type" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' `st'

		// Adds a variable label to this variable 
		la var `st' "School Type Classification"

	} // End of handling of the sch_type variable
	
	// Handles instances of the achievement_points variable
	if `: list posof "achievement_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename achievement_points achievepts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' achievepts

		// Adds a variable label to this variable 
		la var achievepts "Achievement Points"	

	} // End of handling of the achievement_points variable
	
	// Handles instances of the achievement_score variable
	if `: list posof "achievement_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename achievement_score achievesc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' achievesc

		// Adds a variable label to this variable 
		la var achievesc "Achievement Score"

	} // End of handling of the achievement_score variable
	
	// Handles instances of the gap_points variable
	if `: list posof "gap_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename gap_points gappts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gappts

		// Adds a variable label to this variable 
		la var gappts "Gap Points"

	} // End of handling of the gap_points variable
	
	// Handles instances of the gap_score variable
	if `: list posof "gap_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename gap_score gapsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gapsc

		// Adds a variable label to this variable 
		la var gapsc "Gap Score" 

	} // End of handling of the gap_score variable
	
	// Handles instances of the growth_points variable
	if `: list posof "growth_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename growth_points growthpts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' growthpts

		// Adds a variable label to this variable 
		la var growthpts "Growth Points" 

	} // End of handling of the growth_points variable
	
	// Handles instances of the growth_score variable
	if `: list posof "growth_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename growth_score growthsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' growthsc

		// Adds a variable label to this variable 
		la var growthsc "Growth Score" 

	} // End of handling of the growth_score variable
	
	// Handles instances of the ccr_points variable
	if `: list posof "ccr_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ccr_points ccrpts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ccrpts

		// Adds a variable label to this variable 
		la var ccrpts "College/Career Readiness Points" 

	} // End of handling of the ccr_points variable
	
	// Handles instances of the ccr_score variable
	if `: list posof "ccr_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ccr_score ccrsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ccrsc

		// Adds a variable label to this variable 
		la var ccrsc "College/Career Readiness Score"

	} // End of handling of the ccr_score variable
	
	// Handles instances of the graduation_points variable
	if `: list posof "graduation_points" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename graduation_points gradpts 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gradpts

		// Adds a variable label to this variable 
		la var gradpts "Graduation Rate Points" 

	} // End of handling of the graduation_points variable
	
	// Handles instances of the graduation_score variable
	if `: list posof "graduation_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename graduation_score gradsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gradsc

		// Adds a variable label to this variable 
		la var gradsc "Graduation Rate Score" 

	} // End of handling of the graduation_score variable
	
	// Handles instances of the weighted_summary variable
	if `: list posof "weighted_summary" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename weighted_summary wgtsum

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' wgtsum

		// Adds a variable label to this variable 
		la var wgtsum "Weighted Summary" 

	} // End of handling of the weighted_summary variable
	
	// Handles instances of the state_sch_id variable
	if `: list posof "state_sch_id" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename state_sch_id stschid

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' stschid

		// Adds a variable label to this variable 
		la var stschid "State Assigned School ID Number" 

	} // End of handling of the state_sch_id variable
	
	// Handles instances of the ngl_weighted variable
	if `: list posof "ngl_weighted" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ngl_weighted cwgtngl

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cwgtngl

		// Adds a variable label to this variable 
		la var cwgtngl "Current Year's Weighted NGL Score" 

	} // End of handling of the ngl_weighted variable
	
	// Handles instances of the pr_total variable
	if `: list posof "pr_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pr_total ctotalpr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ctotalpr

		// Adds a variable label to this variable 
		la var ctotalpr "Current Year's Program Review Total Score"

	} // End of handling of the pr_total variable
	
	// Handles instances of the pr_weighted variable
	if `: list posof "pr_weighted" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pr_weighted cwgtpr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cwgtpr

		// Adds a variable label to this variable 
		la var cwgtpr "Current Year's Weighted Program Review Score" 

	} // End of handling of the pr_weighted variable
	
	// Handles instances of the overall variable
	if `: list posof "overall" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename overall coverall

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' coverall

		// Adds a variable label to this variable 
		la var coverall "Current Year's Overall Score"

	} // End of handling of the overall variable
	
	// Handles instances of the py_yr_ngl_total variable
	if `: list posof "py_yr_ngl_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_yr_ngl_total ptotal 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ptotal

		// Adds a variable label to this variable 
		la var ptotal "Prior Year's Total Score" 

	} // End of handling of the py_yr_ngl_total variable
	
	// Handles instances of the py_yr_ngl_weighted variable
	if `: list posof "py_yr_ngl_weighted" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_yr_ngl_weighted pwgtngl

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pwgtngl

		// Adds a variable label to this variable 
		la var pwgtngl "Prior Year's Weighted NGL Score" 

	} // End of handling of the py_yr_ngl_weighted variable
	
	// Handles instances of the py_yr_pr_total variable
	if `: list posof "py_yr_pr_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_yr_pr_total ptotalpr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ptotalpr

		// Adds a variable label to this variable 
		la var ptotalpr "Prior Year's Program Review Total Score"

	} // End of handling of the py_yr_pr_total variable
	
	// Handles instances of the py_yr_pr_weighted variable
	if `: list posof "py_yr_pr_weighted" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_yr_pr_weighted pwgtpr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pwgtpr

		// Adds a variable label to this variable 
		la var pwgtpr "Prior Year's Weighted Program Review Score"		

	} // End of handling of the py_yr_pr_weighted variable
	
	// Handles instances of the py_yr_overall variable
	if `: list posof "py_yr_overall" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_yr_overall poverall

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' poverall

		// Adds a variable label to this variable 
		la var poverall "Prior Year's Overall Score"	

	} // End of handling of the py_yr_overall variable
	
	// Handles instances of the  variable
	if `: list posof "stdnt_tested_cnt" in x' != 0 {
		
		// Standardizes the name of the variable

		// Renames the variable to standardized name 
		qui: rename stdnt_tested_cnt tested
		
		qui: replace tested = 	cond(tested == "---", ".d", 				 ///   
								cond(tested == "***", ".s", 				 ///   
								cond(tested == "N/A", ".n", tested)))
		

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' tested
		
		// Applies a variable label to the variable

		// Adds a variable label to this variable 
		la var tested "# of Students Tested" 
		

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_mean_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename english_mean_score actengsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actengsc

		// Adds a variable label to this variable 
		la var actengsc "ACT Average English Score"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "english_bnchmrk_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename english_bnchmrk_pct actengpct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actengpct

		// Adds a variable label to this variable 
		la var actengpct "% of Students Meeting ACT English Benchmark"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "mathematics_mean_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename mathematics_mean_score actmthsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actmthsc

		// Adds a variable label to this variable 
		la var actmthsc "ACT Average Mathematics Score"

	} // End of handling of the  variable
	
	// Handles instances of the mathematics_bnchmrk_pct variable
	if `: list posof "mathematics_bnchmrk_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename mathematics_bnchmrk_pct actmthpct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actmthpct

		// Adds a variable label to this variable 
		la var actmthpct "% of Students Meeting ACT Mathematics Benchmark"

	} // End of handling of the mathematics_bnchmrk_pct variable
	
	// Handles instances of the math_bnchmrk_pct variable
	if `: list posof "math_bnchmrk_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename math_bnchmrk_pct actmthpct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actmthpct

		// Adds a variable label to this variable 
		la var actmthpct "% of Students Meeting ACT Mathematics Benchmark"

	} // End of handling of the math_bnchmrk_pct variable
	
	// Handles instances of the reading_mean_score variable
	if `: list posof "reading_mean_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading_mean_score actrlasc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actrlasc

		// Adds a variable label to this variable 
		la var actrlasc "ACT Average Reading Score"

	} // End of handling of the reading_mean_score variable
	
	// Handles instances of the reading_bnchmrk_pct variable
	if `: list posof "reading_bnchmrk_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading_bnchmrk_pct actrlapct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actrlapct

		// Adds a variable label to this variable 
		la var actrlapct "% of Students Meeting ACT Reading Benchmark"

	} // End of handling of the reading_bnchmrk_pct variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_mean_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename science_mean_score actscisc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actscisc

		// Adds a variable label to this variable 
		la var actscisc "ACT Average Science Score"

	} // End of handling of the science_mean_score variable
	
	// Handles instances of the science_mean_score variable
	if `: list posof "science_bnchmrk_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename science_bnchmrk_pct actscipct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actscipct

		// Adds a variable label to this variable 
		la var actscipct "% of Students Meeting ACT Science Benchmark"

	} // End of handling of the science_mean_score variable
	
	// Handles instances of the composite_mean_score variable
	if `: list posof "composite_mean_score" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename composite_mean_score actcmpsc

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actcmpsc

		// Adds a variable label to this variable 
		la var actcmpsc "ACT Average Composite Score"

	} // End of handling of the composite_mean_score variable
	
	// Handles instances of the stdnt_tested_bnchmrk_cnt variable
	if `: list posof "stdnt_tested_bnchmrk_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename stdnt_tested_bnchmrk_cnt bnchmrktested

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' bnchmrktested
		// Need to verify the contents of this data element

		// Adds a variable label to this variable 
		la var bnchmrktested "# of Students Tested for Benchmark"

	} // End of handling of the stdnt_tested_bnchmrk_cnt variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_rate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename attendance_rate adarate
		qui: replace adarate = ustrregexra(adarate, "[ a-zA-Z]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' adarate

		// Adds a variable label to this variable 
		la var adarate "Average Daily Attendance Rate"

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "attendance_target" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename attendance_target adagoal

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' adagoal

		// Adds a variable label to this variable 
		la var adagoal "Average Daily Attendance Rate Target"

	} // End of handling of the  variable
	
	// Handles instances of the met_academic_ind variable
	if `: list posof "met_academic_ind" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename met_academic_ind othamo
		qui: replace othamo = 	cond(othamo == "No", "0", 					 ///   
								cond(othamo == "Yes", "1", ""))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' othamo

		// Adds a variable label to this variable 
		la var othamo "Annual Measurable Objectives - Other Academic Indicator"

	} // End of handling of the met_academic_ind variable
	
	// Handles instances of the number_enrolled variable
	if `: list posof "number_enrolled" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename number_enrolled membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "# of Students Enrolled"

	} // End of handling of the  variable

	if `: list posof "membership" in x' != 0 {
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "# of Students Enrolled"

	} // End of handling of the  variable

	
	// Handles instances of the number_tested variable
	if `: list posof "number_tested" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename number_tested tested 
		qui: replace tested = ".n" if tested == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' tested

		// Adds a variable label to this variable 
		la var tested "# of Students Tested"

	} // End of handling of the number_tested variable
	
	// Handles instances of the participation_rate variable
	if `: list posof "participation_rate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename participation_rate partic 
		qui: replace partic = ".n" if partic == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' partic

		// Adds a variable label to this variable 
		la var partic "Participation Rate"

	} // End of handling of the participation_rate variable
	
	// Handles instances of the particip_rate variable
	if `: list posof "particip_rate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename particip_rate partic 
		qui: replace partic = ".n" if partic == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' partic

		// Adds a variable label to this variable 
		la var partic "Participation Rate"

	} // End of handling of the particip_rate variable
	
	// Handles instances of the met_participation_rate variable
	if `: list posof "met_participation_rate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename met_participation_rate metpartic
		qui: replace metpartic = 	cond(metpartic == "N/A", ".n", 			 ///   
									cond(metpartic == "No", "0",			 ///   
									cond(metpartic == "Yes", "1", "")))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' metpartic

		// Adds a variable label to this variable 
		la var metpartic "Participation Rate Status"

	} // End of handling of the met_participation_rate variable
	
		// Handles instances of the Program Review Summative Variables
	if `: list posof "progrev_total_points" in x' != 0 {
		rename (progrev_total_points progrev_total_score)(totpts totscore)
		foreach v of var totpts totscore {
			qui: replace `v' = ".n" if `v' == "N/A"
		}

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' totpts totscore

		// Adds a variable label to this variable 
		la var totpts "Total Points"

		// Adds a variable label to this variable 
		la var totscore "Total Score"

	} // Ends handling of the Program Review Summative Variables
	
	// Handles instances of the Arts & Humanities Program Review variables
	if `: list posof "ah_total_points" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ahlev ahcia ahassess ahprofdev ahadmin ahtotpts

		// Adds a variable label to this variable 
		la var ahcia "Arts & Humanities Curriculum and Instruction"

		// Adds a variable label to this variable 
		la var ahassess "Arts & Humanities Formative/Summative Assessments"

		// Adds a variable label to this variable 
		la var ahprofdev "Arts & Humanities Professional Development & Support"

		// Adds a variable label to this variable 
		la var ahadmin "Arts & Humanities Administration & Support"

		// Adds a variable label to this variable 
		la var ahtotpts "Arts & Humanities Total Points" 

		// Adds a variable label to this variable 
		la var ahlev "Arts & Humanities Classification Level"

	} // End of handling of the Arts & Humanities Program Review variables
	
	// Handles the Practical Living & Career Studies Program Review variables
	if `: list posof "pl_total_points" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pllev plcia plassess plprofdev pladmin pltotpts

		// Adds a variable label to this variable 
		la var plcia "Practical Living & Career Studies Curriculum and Instruction"

		// Adds a variable label to this variable 
		la var plassess "Practical Living & Career Studies Formative/Summative Assessments"

		// Adds a variable label to this variable 
		la var plprofdev "Practical Living & Career Studies Professional Development & Support"

		// Adds a variable label to this variable 
		la var pladmin "Practical Living & Career Studies Administration & Support"

		// Adds a variable label to this variable 
		la var pltotpts "Practical Living & Career Studies Total Points" 

		// Adds a variable label to this variable 
		la var pllev "Practical Living & Career Studies Classification Level"

	} // End Practical Living & Career Studies Program Review variables
	
	// Handles instances of the Writing Program Review variables
	if `: list posof "wr_total_points" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' wrlev wrcia wrassess wrprofdev wradmin wrtotpts 

		// Adds a variable label to this variable 
		la var wrcia "Writing Curriculum and Instruction"

		// Adds a variable label to this variable 
		la var wrassess "Writing Formative/Summative Assessments"

		// Adds a variable label to this variable 
		la var wrprofdev "Writing Professional Development & Support"

		// Adds a variable label to this variable 
		la var wradmin "Writing Administration & Support"

		// Adds a variable label to this variable 
		la var wrtotpts "Writing Total Points" 

		// Adds a variable label to this variable 
		la var wrlev "Writing Classification Level"

	} // End of handling of the Writing Program Review variables
	
	// Handles instances of the K-3 Program Review variable
	if `: list posof "k3_total_points" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' k3lev k3cia k3assess k3profdev k3admin k3totpts

		// Adds a variable label to this variable 
		la var k3cia "K-3 Curriculum and Instruction"

		// Adds a variable label to this variable 
		la var k3assess "K-3 Formative/Summative Assessments"

		// Adds a variable label to this variable 
		la var k3profdev "K-3 Professional Development & Support"

		// Adds a variable label to this variable 
		la var k3admin "K-3 Administration & Support"

		// Adds a variable label to this variable 
		la var k3totpts "K-3 Total Points" 

		// Adds a variable label to this variable 
		la var k3lev "K-3 Classification Level"

	} // End of handling of the K-3 Program Review variables
	
	// Handles instances of the World Language Program Review variables
	if `: list posof "wl_total_points" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' wllev wlcia wlassess wlprofdev wladmin wltotpts

		// Adds a variable label to this variable 
		la var wlcia "World Language Curriculum and Instruction"

		// Adds a variable label to this variable 
		la var wlassess "World Language Formative/Summative Assessments"

		// Adds a variable label to this variable 
		la var wlprofdev "World Language Professional Development & Support"

		// Adds a variable label to this variable 
		la var wladmin "World Language Administration & Support"

		// Adds a variable label to this variable 
		la var wltotpts "World Language Total Points" 

		// Adds a variable label to this variable 
		la var wllev "World Language Classification Level"

	} // End of handling of the World Language Program Review variables
	
	// Handles instances of the reading_percentile variable
	if `: list posof "reading_percentile" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading_percentile rlapctile
		qui: replace rlapctile = ".s" if rlapctile == "***"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' rlapctile

		// Adds a variable label to this variable 
		la var rlapctile "Novice Reduction Reading Percentile"	

	} // End of handling of the reading_percentile variable
	
	// Handles instances of the mathematics_percentile variable
	if `: list posof "mathematics_percentile" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename mathematics_percentile mthpctile 
		qui: replace mthpctile = ".s" if mthpctile == "***"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' mthpctile

		// Adds a variable label to this variable 
		la var mthpctile "Novice Reduction Mathematics Percentile"	

	} // End of handling of the mathematics_percentile variable
	
	// Handles instances of the science_percentile variable
	if `: list posof "science_percentile" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename science_percentile scipctile
		qui: replace scipctile = ".s" if scipctile == "***"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' scipctile

		// Adds a variable label to this variable 
		la var scipctile "Novice Reduction Science Percentile"	

	} // End of handling of the science_percentile variable
	
	// Handles instances of the social_percentile variable
	if `: list posof "social_percentile" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename social_percentile socpctile
		qui: replace socpctile = ".s" if socpctile == "***"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' socpctile

		// Adds a variable label to this variable 
		la var socpctile "Novice Reduction Social Studies Percentile"	

	} // End of handling of the social_percentile variable
	
	// Handles instances of the language_mechanics_percentile variable
	if `: list posof "language_mechanics_percentile" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename language_mechanics_percentile lanpctile
		qui: replace lanpctile = ".s" if lanpctile == "***"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' lanpctile

		// Adds a variable label to this variable 
		la var lanpctile "Novice Reduction Language Mechanics Percentile"	

	} // End of handling of the language_mechanics_percentile variable
	
	if `: list posof "totalsenior_enroll" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename totalsenior_enroll totenrsrs

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' totenrsrs

		// Adds a variable label to this variable 
		la var totenrsrs "Total # of Enrolled Seniors"

	}

	if `: list posof "prepsenior_enroll" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prepsenior_enroll prepenrsrs

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' prepenrsrs
		// Need to verify contents of this variable

		// Adds a variable label to this variable 
		la var prepenrsrs "Total # of Seniors Enrolled in Preparatory Program"

	}

	if `: list posof "collegeready" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename collegeready collready

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' collready

		// Adds a variable label to this variable 
		la var collready "# of College Ready Students"

	}	

	if `: list posof "work_keys" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename work_keys actwrkkeys

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' actwrkkeys

		// Adds a variable label to this variable 
		la var actwrkkeys "# of Students Scoring  on ACT WorkKeys"

	}	

	if `: list posof "asvab" in x' != 0 {

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' asvab

		// Adds a variable label to this variable 
		la var asvab "# of Students Scoring  or Higher on the ASVAB"

	}	

	if `: list posof "ind_certs" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ind_certs industrycert

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' industrycert

		// Adds a variable label to this variable 
		la var industrycert "# of Students Passing Industry Certification Exams"

	}	
	
	if `: list posof "kossa" in x' != 0 {

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' kossa

		// Adds a variable label to this variable 
		la var kossa "# of Students Score or Higher on the KOSSA Exam"

	}	

	if `: list posof "cr_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cr_total cartot

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cartot

		// Adds a variable label to this variable 
		la var cartot "# of Career Ready Students"

	}	

	if `: list posof "ccr_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename ccr_total nccr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nccr

		// Adds a variable label to this variable 
		la var nccr "# of College AND Career Ready Students"

	}	

	if `: list posof "total_ccr_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_ccr_pct pctccr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctccr

		// Adds a variable label to this variable 
		la var pctccr "Total % of College AND Career Ready Students"

	}	 
	
	if `: list posof "performance_measure" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename performance_measure prknsmeasure
		qui: replace prknsmeasure = cond(regexm(prknsmeasure, "Read"), "1",	 ///   
									cond(regexm(prknsmeasure, "Math"), "2",  ///   
									cond(regexm(prknsmeasure, "Technical"), "3", ///   
									cond(regexm(prknsmeasure, "Scho"), "4",  ///   
									cond(regexm(prknsmeasure, "Grad"), "5",	 ///   
									cond(regexm(prknsmeasure, "Place"), "6", ///   
									cond(regexm(prknsmeasure, "Partic"), "7", ///   
									cond(regexm(prknsmeasure, "Compl"), "8", ""))))))))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' prknsmeasure

		// Adds a variable label to this variable 
		la var prknsmeasure "Perkins Grant Performance Measures"

	}

	if `: list posof "benchmark_students" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename benchmark_students bnchmrkprkns

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' bnchmrkprkns

		// Adds a variable label to this variable 
		la var bnchmrkprkns "# of Students in Perkins Grant Benchmarks"

	}	

	if `: list posof "performance_goal" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename performance_goal prknsgoal
		qui: replace prknsgoal = cond(prknsgoal == "Not Met", "0",			 ///   
								 cond(prknsgoal == "Met", "1", ""))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' prknsgoal

		// Adds a variable label to this variable 
		la var prknsgoal "Was the Perkins Grant Goal Met?"

	}

	if `: list posof "total_enrollment" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_enrollment membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total # of Students Enrolled"

	}	

	if `: list posof "enrollment" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename enrollment membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total # of Students Enrolled"

	}	

	// Handles instances of the  variable
	if `: list posof "target_level" in x' != 0 {
		loc tl target_level
		qui: replace target_level = cond(`rx'(`tl', "elem.*", 1) == 1, "1", ///   
									 cond(`rx'(`tl', "mid.*", 1) == 1, "2", "3"))

		// Renames the variable to standardized name 
		qui: rename target_level level

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' level

		// Adds a variable label to this variable 
		la var level "Educational Level" 
	

	} // End of handling of the  variable
	
	// Handles instances of the  variable
	if `: list posof "target_type" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename target_type target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(target == "Numerator", "3",			 ///   
								cond(target == "Denominator", "4",			 ///   
								cond(target == "Met Target", "5", ""))))) 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' target

		// Adds a variable label to this variable 
		la var target "Accountability Component Targets"


	} // End of handling of the  variable

	// Handles instances of the  variable
	if `: list posof "target_label" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename target_label target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(ustrregexm(target, ".*numerator.*", 1) == 1, "3",		 ///   
								cond(ustrregexm(target, ".*denominator.*", 1) == 1, "4",	 ///   
								cond(target == "Met Target", "5", "")))))  

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' target

		// Adds a variable label to this variable 
		la var target "Accountability Component Targets"

	} // End of handling of the  variable
	
	if `: list posof "target_label_sort" in x' != 0 drop target_label_sort
			
	if `: list posof "prior_setting" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prior_setting kstype
		qui: replace kstype = 	cond(kstype == "Unknown", "-1",				 ///   
						cond(inlist(kstype, "All Students", "Any"), "0",	 ///   
								cond(kstype == "Child Care", "1",			 ///   
								cond(kstype == "Head Start", "2",			 ///   
								cond(kstype == "Home", "3",					 ///   
								cond(kstype == "Other", "4",				 ///   
								cond(kstype == "State Funded", "5", "")))))))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' kstype

		// Adds a variable label to this variable 
		la var kstype "Kindergarten Screening Prior Setting Type"

	}

	// Kindergarten screening targets by year
	if `: list posof "kscreen_2013" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename kscreen_# kscreen#
		foreach v of var kscreen* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: drop if inlist(`v', "No", "Yes")

			// Adds to list of variables that need to be recast as numeric 
			loc torecast `torecast' `v'

			// Adds a variable label to this variable 
			la var `v' "Kindergarten Readiness Screening Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(kscreen*)
		qui: ds kscreen*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord

	}
	
	// Handles Program Review Delivery Targets
	if `: list posof "pr_type" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pr_type targettype
		qui: replace targettype = cond(targettype == "NUMBER_PD", "1",		 ///   
									cond(targettype == "PERCENT_PD", "2", ""))
		qui: destring targettype, replace ignore("*,-R %$")
		cap char targettype[destring] ""
		cap char targettype[destring_cmd] ""
		la val targettype targettype

		// Adds a variable label to this variable 
		la var targettype "Program Review Delivery Target Type"

		// Renames the variable to standardized name 
		qui: rename pr_# progrev#
		foreach v of var progrev* {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: replace `v' = cond(`v' == "No", "0", cond(`v' == "Yes", "1", `v'))
			qui: destring `v', replace ignore("*,-R %$")
			cap char `v'[destring] ""
			cap char `v'[destring_cmd] ""

			// Adds a variable label to this variable 
			la var `v' "Program Review Target for `yr'"
		}	
		qui: egen nullrecord = rowmiss(progrev*)
		qui: ds progrev*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
		deltargets, st(progrev) pk(fileid schid schyr) tar(targettype)
		la val met met
		loc torecast `: subinstr loc torecast "target" "", all'
		

	}

	if ustrregexm(`"`x'"', "yr_[0-9]{4}") == 1 {
		rename yr_# yr#
		foreach v of var yr???? {
			loc yr "`= substr("`v'", -4, 4)'"
			qui: replace `v' = 	cond(`v' == "Yes", "1", 					 ///   
								cond(`v' == "No", "0", 						 ///   
								cond(`v' == "N/A", ".n", `v')))

			// Adds to list of variables that need to be recast as numeric 
			loc torecast `torecast' `v'

			// Adds a variable label to this variable 
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
			cap char `v'[destring] ""
			cap char `v'[destring_cmd] ""			
		}
		qui: egen nullrecord = rowmiss(ccr*)
		qui: ds ccr*
		qui: drop if nullrecord == `: word count `r(varlist)''
		qui: drop nullrecord
		qui: g targettype = 2
		deltargets, st(ccr) pk(fileid schid schyr) tar(targettype)
		loc torecast `: subinstr loc torecast "target" "", all'


	}
	
	// Handles instances of the EQ_PCT variable
	if `: list posof "eq_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename eq_pct eqpct
		qui: replace eqpct = ".n" if eqpct == "N/A"

		// Adds a variable label to this variable 
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

		// Renames the variable to standardized name 
		qui: rename equity_measure eqm

		// loc torecast `torecast' eqm
		
		//Applies variable label to the variable

		// Adds a variable label to this variable 
		la var eqm "Equity Measure"
									

	} // End of handling of the Equity_Measure  variable

	// Handles instances of the EQ_LABEL variable
	if `: list posof "eq_label" in x' != 0 {
		qui: replace eq_label = cond(eq_label == "Exemplary/ Accomplished", "1", ///
								cond(eq_label == "High/Expected", "2",       ///
								cond(eq_label == "School-Level", "3",    	 ///
								cond(eq_label == "Strongly Agree/Agree", "4", "5")))) 

		// Renames the variable to standardized name 
		qui: rename eq_label eqlabel
		qui: destring eqlabel, replace ignore("*,-R %$")
		cap char eqlabel[destring] ""
		cap char eqlabel[destring_cmd] ""
		qui: reshape wide eqpct, i(fileid schyr schid eqlabel) j(eqm) string
		qui: reshape wide eqpct?, i(fileid schyr schid ) j(eqlabel)
		qui: count
		loc x `= `r(N)''
		foreach v of var eqpct* {
			qui: count if mi(`v')
			if `r(N)' == `x' drop `v'
		}

		// Renames the variable to standardized name 
		qui: rename (eqpct14 eqpct24 eqpct31 eqpct42 eqpct55 eqpct63 eqpct74) ///   
		(csnicomp stdconduct effectivestaff staffsgp pctnewtch pctchurn ldrship)

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' csnicomp stdconduct effectivestaff staffsgp pctnewtch pctchurn ldrship

		// Adds a variable label to this variable 
		la var csnicomp "% Agree/Strongly Agree - Community Support/Involvement"

		// Adds a variable label to this variable 
		la var stdconduct "% Agree/Strongly Agree - Managing Student Conduct"

		// Adds a variable label to this variable 
		la var effectivestaff "% Exemplary/Accomplished - Overall Effectiveness"

		// Adds a variable label to this variable 
		la var staffsgp "% Exemplary/Accomplished - Overall Student Growth Rating"

		// Adds a variable label to this variable 
		la var pctnewtch "% New/KTIP Educators"

		// Adds a variable label to this variable 
		la var pctchurn "% School-Level Educator Churn" 

		// Adds a variable label to this variable 
		la var ldrship "% Agree/Strongly Agree - School Leadership Composite"
				

	} // End of handling of the EQ_LABEL variable
	
	if `: list posof "program_label" in x' != 0 {
		amogroup, la(program_label) laname(proggroup)

	}
	
	// Handles instances of the PROGRAM_TYPE variable
	if `: list posof "program_type" in x' != 0 {
		qui: replace program_type=cond( ///   
		inlist(program_type, "English Language Learners (ELL)", "English Learners"), "1", ///
								  cond(program_type == "Migrant", "2",            ///
								  cond(program_type == "Special Education", "3",  ///
								  cond(program_type == "Gifted and Talented", "4", ///   
								  cond(program_type == "Homeless", "5", ""))))) 

		// Renames the variable to standardized name 
		qui: rename program_type progtype

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' progtype

		// Adds a variable label to this variable 
		la var progtype "Program Type"

	} // End of handling of the PROGRAM_TYPE variable
	
	// Handles instances of the TOTAL_CNT variable
	if `: list posof "total_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_cnt membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total Student Membership"

	} // End of handling of the TOTAL_CNT variable
	
	// Handles instances of the TOTAL_PCT variable
	if `: list posof "total_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_pct totpct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' totpct

		// Adds a variable label to this variable 
		la var totpct "Total % of Students"

	} // End of handling of the TOTAL_PCT variable
	
	//Handles instances of the WHITE_CNT variable
	if `: list posof "white_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename white_cnt nwhite

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nwhite

		// Adds a variable label to this variable 
		la var nwhite "# of White Students"

	} // End of handling of the WHITE_CNT variable
	
	//Handles instances of the BLACK_CNT variable
	if `: list posof "black_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename black_cnt nblack

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nblack

		// Adds a variable label to this variable 
		la var nblack "# of Black Students"

	} // End of handling of the BLACK_CNT variable
	
	//Handles instances of the HISPANIC_CNT variable
	if `: list posof "hispanic_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename hispanic_cnt nhisp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nhisp

		// Adds a variable label to this variable 
		la var nhisp "# of Hispanic/Latino(a) Students"

	} // End of handling of the HISPANIC_CNT variable
	
	//Handles instances of the Asian_CNT variable
	if `: list posof "asian_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename asian_cnt nasian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nasian

		// Adds a variable label to this variable 
		la var nasian "# of Asian Students"

	} // End of handling of the Asian_CNT variable
	
	//Handles instances of the AIAN_CNT variable
	if `: list posof "aian_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename aian_cnt naian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' naian

		// Adds a variable label to this variable 
		la var naian "# of American Indian/Alaskan Native Students"

	} // End of handling of the AIAN_CNT variable
	
	//Handles instances of the HAWAIIAN_CNT variable
	if `: list posof "hawaiian_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename hawaiian_cnt npacisl

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' npacisl

		// Adds a variable label to this variable 
		la var npacisl "# of Native Hawaiian/Pacific Islander Students"

	} // End of handling of the HAWAIIAN_CNT variable
	
	//Handles instances of the OTHER_CNT variable
	if `: list posof "other_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename other_cnt nmulti

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmulti

		// Adds a variable label to this variable 
		la var nmulti "# of Multiracial Students"

	} // End of handling of the OTHER_CNT variable
	
	//Handles instances of the MALE_CNT variable
	if `: list posof "male_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename male_cnt nmale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmale

		// Adds a variable label to this variable 
		la var nmale "# of Male Students"

	} // End of handling of the MALE_CNT variable
	
	//Handles instances of the FEMALE_CNT variable
	if `: list posof "female_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename female_cnt nfemale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfemale

		// Adds a variable label to this variable 
		la var nfemale "# of Female Students"

	} // End of handling of the FEMALE_CNT variable
	
	//Handles instances of the TOTAL_STDNT_CNT variable
	if `: list posof "total_stdnt_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_stdnt_cnt membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total Membership"

	} // End of handling of the TOTAL_STDNT_CNT variable
	
	//Handles instances of the TOTAL_UNIQUE_EVENT_CNT variable
	if `: list posof "total_unique_event_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename total_unique_event_cnt totevents

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' totevents

		// Adds a variable label to this variable 
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

		// Renames the variable to standardized name 
		qui: rename rpt_header rpthdr
		// qui: destring rpthdr,replace ignore("*,-R %$")
		// la val rpthdr rpthdr

		// Adds a variable label to this variable 
		la var rpthdr "Report Header"

	} // End of handling of the RPT_HEADER variable
	
	//Handles instances of the RPT_HEADER_ORDER variable
	if `: list posof "rpt_header_order" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename rpt_header_order rpthdrodr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' rpthdrodr

		// Adds a variable label to this variable 
		la var rpthdrodr "Report Header Order"

	} // End of handling of the RPT_HEADER_ORDER variable
	
	//Handles instance of the RPT_LINE_ORDER variable
	if `: list posof "rpt_line_order" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename rpt_line_order rptlnodr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' rptlnodr

		// Adds a variable label to this variable 
		la var rptlnodr "Report Line Order"

	} // End of handling of the RPT_LINE_ORDER variable
	
	//Handles instance of the SPENDING_PER_STDNT variable
	if `: list posof "spending_per_stdnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename spending_per_stdnt ppe

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ppe

		// Adds a variable label to this variable 
		la var ppe "Per-Pupil Expenditure"

	} // End of handling of the SPENDING_PER_STDNT variable
	
	//Handles instance of the AVG_DAILY_ATTENDANCE variable
	if `: list posof "avg_daily_attendance" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename avg_daily_attendance ada

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ada

		// Adds a variable label to this variable 
		la var ada "Average Daily Attendance"

	} // End of handling of the AVG_DAILY_ATTENDANCE variable
	
	//Handles instance of the MEMBERSHIP_TOTAL variable
	if `: list posof "membership_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_total membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total Student Membership"

	} // End of handling of the MEMBERSHIP_TOTAL variable
	
	//Handles instance of the MEMBERSHIP_MALE_CNT variable
	if `: list posof "membership_male_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_male_cnt nmale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmale

		// Adds a variable label to this variable 
		la var nmale "# of Male Students"

	} // End of handling of the MEMBERSHIP_MALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_MALE_PCT variable
	if `: list posof "membership_male_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_male_pct pctmale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctmale

		// Adds a variable label to this variable 
		la var pctmale "% of Male Students"

	} // End of handling of the MEMBERSHIP_MALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_CNT variable
	if `: list posof "membership_female_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_female_cnt nfemale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfemale

		// Adds a variable label to this variable 
		la var nfemale "# of Female Students"

	} // End of handling of the MEMBERSHIP_FEMALE_CNT variable
	
	//Handles instance of the MEMBERSHIP_FEMALE_PCT variable
	if `: list posof "membership_female_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_female_pct pctfemale

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctfemale

		// Adds a variable label to this variable 
		la var pctfemale "% of Female Students"

	} // End of handling of the MEMBERSHIP_FEMALE_PCT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_CNT variable
	if `: list posof "membership_white_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_white_cnt nwhite

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nwhite

		// Adds a variable label to this variable 
		la var nwhite "# of White Students"

	} // End of handling of the MEMBERSHIP_WHITE_CNT variable
	
	//Handles instance of the MEMBERSHIP_WHITE_PCT variable
	if `: list posof "membership_white_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_white_pct pctwhite

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctwhite

		// Adds a variable label to this variable 
		la var pctwhite "% of White Students"

	} // End of handling of the MEMBERSHIP_WHITE_PCT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_CNT variable
	if `: list posof "membership_black_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_black_cnt nblack

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nblack

		// Adds a variable label to this variable 
		la var nblack "# of Black Students"

	} // End of handling of the MEMBERSHIP_BLACK_CNT variable
	
	//Handles instance of the MEMBERSHIP_BLACK_PCT variable
	if `: list posof "membership_black_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_black_pct pctblack

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctblack

		// Adds a variable label to this variable 
		la var pctblack "% of Black Students"

	} // End of handling of the MEMBERSHIP_BLACK_PCT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_CNT variable
	if `: list posof "membership_hispanic_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_hispanic_cnt nhisp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nhisp

		// Adds a variable label to this variable 
		la var nhisp "# of Hispanic/Latino(a) Students"

	} // End of handling of the MEMBERSHIP_HISPANIC_CNT variable
	
	//Handles instance of the MEMBERSHIP_HISPANIC_PCT variable
	if `: list posof "membership_hispanic_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_hispanic_pct pcthisp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pcthisp

		// Adds a variable label to this variable 
		la var pcthisp "% of Hispanic/Latino(a) Students"

	} // End of handling of the MEMBERSHIP_HISPANIC_PCT variable
	
	//Handles instance of the MEMBERSHIP_ASAIN_CNT variable
	if `: list posof "membership_asian_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_asian_cnt nasian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nasian

		// Adds a variable label to this variable 
		la var nasian "# of Asian Students"

	} // End of handling of the MEMBERSHIP_ASIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_ASIAN_PCT variable
	if `: list posof "membership_asian_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_asian_pct pctasian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctasian

		// Adds a variable label to this variable 
		la var pctasian "% of Asian Students"

	} // End of handling of the MEMBERSHIP_ASIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_CNT variable
	if `: list posof "membership_aian_cnt" in x' != 0 {
		cap confirm var naian
		if _rc == 0 qui: replace naian = membership_aiain_cnt if mi(naian)
		else qui: rename membership_aian_cnt naian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' naian

		// Adds a variable label to this variable 
		la var naian "# of American Indian/Alaskan Native Students"

	} // End of handling of the MEMBERSHIP_AIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_AIAN_PCT variable
	if `: list posof "membership_aian_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_aian_pct pctaian

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctaian

		// Adds a variable label to this variable 
		la var pctaian "% of American Indian/Alaskan Native Students"

	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_CNT variable
	if `: list posof "membership_hawaiian_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_hawaiian_cnt npacisl

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' npacisl

		// Adds a variable label to this variable 
		la var npacisl "# of Native Hawwaiian/Pacific Islander Students"

	} // End of handling of the MEMBERSHIP_HAWAIIAN_CNT variable
	
	//Handles instance of the MEMBERSHIP_HAWAIIAN_PCT variable
	if `: list posof "membership_hawaiian_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_hawaiian_pct pctpacisl

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctpacisl

		// Adds a variable label to this variable 
		la var pctpacisl "% of Native Hawwaiian/Pacific Islander Students"

	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	if `: list posof "membership_two_or_more_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_two_or_more_cnt nmulti

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmulti

		// Adds a variable label to this variable 
		la var nmulti "# of Multiracial Students"

	} // End of handling of the MEMBERSHIP_TWO_OR_MORE_CNT variable
	
	//Handles instance of the MEMBERSHIP_TWO_OR_MORE_PCT variable
	if `: list posof "membership_two_or_more_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_two_or_more_pct pctmulti

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctmulti

		// Adds a variable label to this variable 
		la var pctmulti "% of Multiracial Students"

	} // End of handling of the MEMBERSHIP_AIAN_PCT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_CNT variable
	if `: list posof "enrollment_free_lunch_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename enrollment_free_lunch_cnt nfreelnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfreelnch

		// Adds a variable label to this variable 
		la var nfreelnch "# of Free Lunch Students"

	} // End of handling of the ENROLLMENT_FREE_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_FREE_LUNCH_PCT variable
	if `: list posof "enrollment_free_lunch_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename enrollment_free_lunch_pct pctfreelnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctfreelnch

		// Adds a variable label to this variable 
		la var pctfreelnch "% of Free Lunch Students"

	} // End of handling of the ENROLLMENT_FREE_LUNCH_PCT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	if `: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename enrollment_reduced_lunch_cnt nredlnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nredlnch

		// Adds a variable label to this variable 
		la var nredlnch "# of Reduced Lunch Students"

	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_CNT variable
	
	//Handles instance of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	if `: list posof "enrollment_reduced_lunch_pct" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename enrollment_reduced_lunch_pct pctredlnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctredlnch

		// Adds a variable label to this variable 
		la var pctredlnch "% of Reduced Lunch Students"

	} // End of handling of the ENROLLMENT_REDUCED_LUNCH_PCT variable
	
	/* Need to move next two blocks to the end of the program (after the 
	destring `torecast' line) */
	if 	`: list posof "enrollment_free_lunch_cnt" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_cnt" in x' != 0 {	
		qui: g nfrl = nfreelnch + nredlnch

		// Adds a variable label to this variable 
		la var nfrl "# of Students Qualifying for Free/Reduced Price Lunch"

	}	
		
	if 	`: list posof "enrollment_free_lunch_pct" in x' != 0 &				 ///   
		`: list posof "enrollment_reduced_lunch_pct" in x' != 0 {	
		qui: g pctfrl = pctfreelnch + pctredlnch

		// Adds a variable label to this variable 
		la var pctfrl "% of Students Qualifying for Free/Reduced Price Lunch"

	}	
		
	if 	`: list posof "membership_other_cnt" in x' != 0 {
		cap confirm var nmulti
		if _rc == 0 qui: replace nmulti = membership_other_cnt if mi(nmulti) ///   
											& !mi(membership_other_cnt)
		else qui: rename membership_other_cnt nmulti

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmulti

		// Adds a variable label to this variable 
		la var nmulti "# of Multi-Racial Students"

	} 

	if 	`: list posof "membership_other_pct" in x' != 0 {
		cap confirm var pctmulti
		if _rc == 0 qui: replace pctmulti = membership_other_pct if 		 ///   
						 mi(pctmulti) & !mi(membership_other_pct)
		else qui: rename membership_other_pct pctmulti	 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctmulti

		// Adds a variable label to this variable 
		la var pctmulti "% of Multi-Racial Students"

	} 

	if 	`: list posof "membership_free_lunch_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename membership_free_lunch_cnt memfreelnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfreelnch
		qui: replace nfreelnch = memfreelnch if mi(nfreelnch)
		drop memfreelnch

	}
	 
	if 	`: list posof "membership_reduced_lunch_cnt" in x' != 0 {	

		// Renames the variable to standardized name 
		qui: rename membership_reduced_lunch_cnt memredlnch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nredlnch
		qui: replace nredlnch = memredlnch if mi(nredlnch)
		drop memredlnch

	}
		
	//Handles instance of the RETENTION_RATE variable
	if `: list posof "retention_rate" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename retention_rate retrate
		qui: replace retrate = ustrregexra(retrate, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' retrate

		// Adds a variable label to this variable 
		la var retrate "Retention Rate"

	} // End of handling of the RETENTION_RATE variable
	
	//Handles instance of the DROPOUT_RATE variable
	if `: list posof "dropout_rate" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename dropout_rate droprate
		qui: replace droprate = ustrregexra(droprate, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' droprate

		// Adds a variable label to this variable 
		la var droprate "Dropout Rate"

	} // End of handling of the DROPOUT_RATE variable
	
	//Handles instance of the GRADUATION_RATE variable
	if `: list posof "graduation_rate" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename graduation_rate gradrate
		qui: replace gradrate = ustrregexra(gradrate, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' gradrate

		// Adds a variable label to this variable 
		la var gradrate "Graduation Rate"

	} // End of handling of the GRADUATION_RATE variable
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_CNT
	if `: list posof "transition_college_inout_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_inout_cnt ncollege
		qui: replace ncollege = ustrregexra(ncollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ncollege

		// Adds a variable label to this variable 
		la var ncollege "# of Students Enrolled in College In/Out of State"

	} //End of handling of the TRANSITION_COLLEGE_INOUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_INOUT_PCT
	if `: list posof "transition_college_inout_pct" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_inout_pct pctcollege
		qui: replace pctcollege = ustrregexra(pctcollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctcollege

		// Adds a variable label to this variable 
		la var pctcollege "% of Students Enrolled in College In/Out of State"

	} //End of handling of the TRANSITION_COLLEGE_INOUT_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_CNT
	if `: list posof "transition_college_in_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_in_cnt nincollege
		qui: replace nincollege = ustrregexra(nincollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nincollege

		// Adds a variable label to this variable 
		la var nincollege "# of Students Enrolled in College In State"

	} //End of handling of the TRANSITION_COLLEGE_IN_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_IN_PCT
	if `: list posof "transition_college_in_pct" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_in_pct pctincollege
		qui: replace pctincollege = ustrregexra(pctincollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctincollege

		// Adds a variable label to this variable 
		la var pctincollege "% of Students Enrolled in College In State"

	} //End of handling of the TRANSITION_COLLEGE_IN_PCT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_CNT
	if `: list posof "transition_college_out_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_out_cnt noutcollege
		qui: replace noutcollege = ustrregexra(noutcollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' noutcollege

		// Adds a variable label to this variable 
		la var noutcollege "# of Students Enrolled in College Out of State"

	} //End of handling of the TRANSITION_COLLEGE_OUT_CNT
	
	//Handles instance of the TRANSITION_COLLEGE_OUT_PCT
	if `: list posof "transition_college_out_pct" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename transition_college_out_pct pctoutcollege
		qui: replace pctoutcollege = ustrregexra(pctoutcollege, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctoutcollege

		// Adds a variable label to this variable 
		la var pctoutcollege "% of Students Enrolled in College Out of State"

	} //End of handling of the TRANSITION_COLLEGE_OUT_PCT
	
	// Handles instances of the TEACHING_METHOD variable
	if `: list posof "teaching_method" in x' != 0 {

		// Renames the variable to standardized name 
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

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pedagogy

		// Adds a variable label to this variable 
		la var pedagogy "Pedagogical/Instructional Methodology"

	} // End of handling of the TEACHING_METHOD variable
	
	//Handles instance of the ONSITE_CLASSROOM_CNT variable
	if `: list posof "onsite_classroom_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename onsite_classroom_cnt nonsitecls

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nonsitecls

		// Adds a variable label to this variable 
		la var nonsitecls "# of Onsite Classrooms"

	} //End of handling of the ONSITE_CLASSROOM_CNT variable
	
	//Handles instance of the OFFSITE_CTE_CNT variable
	if `: list posof "offsite_cte_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename offsite_cte_cnt noffsitecte

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' noffsitecte

		// Adds a variable label to this variable 
		la var noffsitecte "# of Offsite Career/Technical Education Classes"

	} //End of handling of the OFFSITE_CTE_CNT variable
	
	//Handles instance of the OFFSITE_COLLEGE_CNT variable
	if `: list posof "offsite_college_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename offsite_college_cnt noffsitecol

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' noffsitecol

		// Adds a variable label to this variable 
		la var noffsitecol "# of Offsite College Classes"

	} //End of handling of the OFFSITE_COLLEGE_CNT variable
	
	//Handles instance of the HOME_HOSPITAL_CNT variable
	if `: list posof "home_hospital_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename home_hospital_cnt nhomehosp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nhomehosp

		// Adds a variable label to this variable 
		la var nhomehosp "# of Home Hospital Classes"

	} //End of handling of the HOME_HOSPITAL_CNT variable
	
	//Handles instance of the ONLINE_CNT varialbe
	if `: list posof "online_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename online_cnt nonline

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nonline

		// Adds a variable label to this variable 
		la var nonline "# of Online Classes"

	} //End of handling of the ONLINE_CNT variable
	
	//Handles instance of the FINANACE_TYPE variable
	if `: list posof "finance_type" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename finance_type fintype
		qui: replace fintype = cond(fintype == "FINANCIAL SUMMARY", "1",	 ///
							   cond(fintype == "SALARIES", "2",				 ///
							   cond(fintype == "SEEK", "3",					 ///
							   cond(fintype == "TAX", "4", 					 ///   
							   cond(fintype == "REVENUES AND EXPENDITURES", "5", "")))))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' fintype

		// Adds a variable label to this variable 
		la var fintype "Finance Type"

	} //End of handling of the FINANCE_TYPE variable
	
	//Handles instance of the FINANACE_LABEL variable
	if `: list posof "finance_label" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename finance_label finlabel

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' finlabel

		// Adds a variable label to this variable 
		la var finlabel "Finance Line Items"

	} //End of handling of the FINANCE_LABEL variable
	
	//Handles instance of the FINANACE_VALUE variable
	if `: list posof "finance_value" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename finance_value finvalue

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' finvalue

		// Adds a variable label to this variable 
		la var finvalue "Finance Value"

	} //End of handling of the FINANCE_VALUE variable
	
	//Handles instance of the FINANACE_RANK variable
	if `: list posof "finance_rank" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename finance_rank finrank

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' finrank

		// Adds a variable label to this variable 
		la var finrank "Finance Rank"

	} //End of handling of the FINANCE_RANK variable
	
	//Handles instance of the ENROLLMENT_CNT variable
	if `: list posof "enrollment_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename enrollment_cnt membership
		qui: replace membership = ".n" if membership == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' membership

		// Adds a variable label to this variable 
		la var membership "Total # of Students Enrolled"

	} //End of handling of the ENROLLMENT_CNT variable
	
	//Handles instance of the CERTIFICATION_CNT variable
	if `: list posof "certification_cnt" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename certification_cnt ncert

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ncert

		// Adds a variable label to this variable 
		la var ncert "# of Certifications"

	} //End of handling of the CERTIFICATION_CNT variable
	
	// Handles instances of the CAREER_PATHWAY_DESC variable
	if `: list posof "career_pathway_desc" in x' != 0 {
		// qui: replace career_pathway_desc = proper(career_pathway_desc)

		// Renames the variable to standardized name 
		qui: rename career_pathway_desc ctepath

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ctepath

		// Adds a variable label to this variable 
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
		

		// Renames the variable to standardized name 
		qui: rename low_grade mingrade
		qui: replace mingrade = ustrregexra(mingrade, "(st)|(th)|(rd)|(nd)", "")
		qui: replace mingrade = cond(mingrade == "Adult Ed", "98",			 ///   
					cond(inlist(mingrade, "Entry", "K", "Primary"), "0", 	 ///   
					cond(mingrade == "Preschool", "-1", mingrade)))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' mingrade

		// Adds a variable label to this variable 
		la var mingrade "Lowest Grade Level Served by School"

	} // End of handling of the low_grade variable

	// Handler for the high_grade variable
	if `: list posof "high_grade" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename high_grade maxgrade
		qui: replace maxgrade = ustrregexra(maxgrade, "(st)|(th)|(rd)|(nd)", "")
		qui: replace maxgrade = cond(maxgrade == "Adult Ed", "98",			 ///   
					cond(inlist(maxgrade, "Entry", "K", "Primary"), "0", 	 ///   
					cond(maxgrade == "Preschool", "-1", maxgrade)))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' maxgrade

		// Adds a variable label to this variable 
		la var maxgrade "Highest Grade Level Served by School"

	} // End of handling of the high_grade variable

	// Handler for the title1_status variable
	if `: list posof "title1_status" in x' != 0 {
		/*

		// Renames the variable to standardized name 
		qui: rename title1_status title1
		qui: replace title1 = proper(trim(itrim(ustrregexra(				 ///   
					ustrregexra(subinstr(title1, "Title 1", "Title I", .),   ///   
						"[ ]?[–-]+[ ]?No Program", " - No Program"), 		 ///   
						"[–-]+", " - "))))
		qui: replace = cond()

		// Adds a variable label to this variable 
		la var  ""
		*/

		// Renames the variable to standardized name 
		qui: rename title1_status title1

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' title1

		// Adds a variable label to this variable 
		la var title1 "Title I Status Indicator"

	} // End of handling of the title1_status variable

	// Handler for the  variable
	if `: list posof "contact_name" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename contact_name poc
		
		// Sort by school id in ascending order and school year in descending order
		gsort schid - schyr
		qui: egen pcs = nvals(poc), by(schid)
		// Replace other names with most recent name if school had multiple names
		qui: replace poc = poc[_n - 1] if pcs > 1 & poc[_n - 1] != poc &	 ///   
		schid[_n - 1] == schid
		drop pcs

		// Adds a variable label to this variable 
		la var poc "Point of Contact"
		

	} // End of handling of the  variable

	// Handler for the  variable
	if `: list posof "address" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename (address address2)(addy addy2)

		// Adds a variable label to this variable 
		la var addy "Street Address"

		// Adds a variable label to this variable 
		la var addy2 "Street Address (Line 2)"

	} // End of handling of the  variable

	//Handles instance of the PERFORMANCE_TYPE variable
	if `: list posof "performance_type" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename performance_type ptype
		qui: replace ptype = cond(ptype == "Points", "0",		 ///
							   cond(ptype == "NAPD Calculation", "1", ""))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ptype

		// Adds a variable label to this variable 
		la var ptype "Performance Type"

	} //End of handling of the PERFORMANCE_TYPE variable
	
	//Handles instance of the ASSESSMENT_LEVEL variable
	if `: list posof "assessment_level" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename assessment_level assesslev
		qui: replace assesslev = cond(assesslev == "Kentucky", "0",			 ///
							     cond(assesslev == "Nation", "1", ""))

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' assesslev

		// Adds a variable label to this variable 
		la var assesslev "Assessment Level"

	} //End of handling of the ASSESSMENT_LEVEL variable	
		
	//Handles instance of the COHORT_TYPE variable
	if `: list posof "cohort_type" in x' !=0 {

		// Renames the variable to standardized name 
		qui: rename cohort_type targettype
		qui: replace targettype = cond(targettype == "FIVE YEAR", "2",		 ///
							  cond(targettype == "FOUR YEAR", "1", ""))
		qui: replace targettype = "1" if mi(targettype) & real(schyr) <= 2013					  

		// Adds to list of variables that need to be recast as numeric 
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


		// Renames the variable to standardized name 
		qui: rename rpt_line rptln

		// Adds a variable label to this variable 
		la var rptln "Report Line"

	} // End of handling of the RPT_LINE variable
	
	//Handles instances of the GRAD_TARGETS variable
	if `: list posof "grad_targets" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename grad_targets target
		qui: replace target = 	cond(target == "Actual Score", "1",			 ///    
								cond(inlist(target, "Target", "Delivery Target"), "2", ///   
								cond(target == "Numerator", "3",			 ///   
								cond(target == "Denominator", "4",			 ///   
								cond(target == "Met Target", "5", ""))))) 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' target

		// Adds a variable label to this variable 
		la var target "Graduation Rate Targets"

	} // End of handling of the GRAD_TARGETS variable

	// Handler for the po_box variable
	if `: list posof "po_box" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename po_box pobox

		// Adds a variable label to this variable 
		la var pobox "Post Office Box"

	} // End of handling of the  variable

	// Handler for the city variable
	if `: list posof "city" in x' != 0 {

		// Adds a variable label to this variable 
		la var city "City"

	} // End of handling of the  variable

	// Handler for the state variable
	if `: list posof "state" in x' != 0 {

		// Adds a variable label to this variable 
		la var state "State"

	} // End of handling of the  variable

	// Handler for the zipcode variable
	if `: list posof "zipcode" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename zipcode zip

		// Adds a variable label to this variable 
		la var zip "USPS Zip Code"

	} // End of handling of the  variable

	// Handler for the phone variable
	if `: list posof "phone" in x' != 0 {

		// Adds a variable label to this variable 
		la var phone "Phone Number"

	} // End of handling of the  variable

	// Handler for the fax variable
	if `: list posof "fax" in x' != 0 {

		// Adds a variable label to this variable 
		la var fax "Fax Number"

	} // End of handling of the  variable
	
	if 	`: list posof "transition_parttime_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_parttime_cnt nparttime
		qui: replace nparttime = ustrregexra(nparttime, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nparttime

		// Adds a variable label to this variable 
		la var nparttime "# of Students Transitioning into Part-Time Higher-Ed"

	}

	if 	`: list posof "transition_parttime_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_parttime_pct pctparttime
		qui: replace pctparttime = ustrregexra(pctparttime, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctparttime

		// Adds a variable label to this variable 
		la var pctparttime "% of Students Transitioning into Part-Time Higher-Ed"

	}

	if 	`: list posof "transition_workforce_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_workforce_cnt nworkforce
		qui: replace nworkforce = ustrregexra(nworkforce, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nworkforce

		// Adds a variable label to this variable 
		la var nworkforce "# of Students Transitioning to the Workforce"

	}

	if 	`: list posof "transition_workforce_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_workforce_pct pctworkforce
		qui: replace pctworkforce = ustrregexra(pctworkforce, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctworkforce

		// Adds a variable label to this variable 
		la var pctworkforce "% of Students Transitioning to the Workforce"

	}

	if 	`: list posof "transition_vocational_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_vocational_cnt nvocational
		qui: replace nvocational = ustrregexra(nvocational, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nvocational

		// Adds a variable label to this variable 
		la var nvocational "# of Students Transitioning to Vocational Program"

	}

	if 	`: list posof "transition_vocational_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_vocational_pct pctvocational
		qui: replace pctvocational = ustrregexra(pctvocational, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctvocational

		// Adds a variable label to this variable 
		la var pctvocational "% of Students Transitioning to Vocational Program"

	}

	if 	`: list posof "transition_failure_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_failure_cnt nfailure
		qui: replace nfailure = ustrregexra(nfailure, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfailure

		// Adds a variable label to this variable 
		la var nfailure "# of Students Transitioning to Failure?"

	}

	if 	`: list posof "transition_failure_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_failure_pct pctfailure
		qui: replace pctfailure = ustrregexra(pctfailure, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctfailure

		// Adds a variable label to this variable 
		la var pctfailure "% of Students Transitioning to Failure?"

	}

	if 	`: list posof "transition_military_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_military_cnt nmilitary
		qui: replace nmilitary = ustrregexra(nmilitary, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmilitary

		// Adds a variable label to this variable 
		la var nmilitary "# of Students Transitioning to the Military"

	}

	if 	`: list posof "transition_military_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename transition_military_pct pctmilitary
		qui: replace pctmilitary = ustrregexra(pctmilitary, "[^\.\d]", "")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctmilitary

		// Adds a variable label to this variable 
		la var pctmilitary "% of Students Transitioning to the Military"

	}

	if 	`: list posof "stdnt_tch_ratio" in x' != 0 {
		qui: split stdnt_tch_ratio, parse(":") gen(x)
		qui: g stdtchratio = cond(real(x1) == 0, 0, (real(x2) / real(x1))) 
		qui: drop stdnt_tch_ratio x1 x2

		// Adds a variable label to this variable 
		la var stdtchratio "Student to Teacher Ratio"

	}

	if 	`: list posof "fulltime_tch_total" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename fulltime_tch_total nfte

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nfte

		// Adds a variable label to this variable 
		la var nfte "# of Full Time Teachers"

	}

	if 	`: list posof "national_board_cert_tch_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename national_board_cert_tch_cnt nnbct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nnbct

		// Adds a variable label to this variable 
		la var nnbct "# of National Board Certified Teachers"

	}

	if 	`: list posof "pct_cls_not_hq_tch" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_cls_not_hq_tch pctnothq

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctnothq

		// Adds a variable label to this variable 
		la var pctnothq "% of non-Highly Qualified Educators"

	}

	if 	`: list posof "avg_yrs_tch_exp" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename avg_yrs_tch_exp tchexp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' tchexp

		// Adds a variable label to this variable 
		la var tchexp "Average # of Years of Educator Experience"

	}

	if 	`: list posof "prof_qual_ba_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_ba_pct pctqualba

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctqualba

		// Adds a variable label to this variable 
		la var pctqualba "% Highly Qualified Educators with a Bachelor's Degree"

	}

	if 	`: list posof "prof_qual_ma_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_ma_pct pctqualma

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctqualma

		// Adds a variable label to this variable 
		la var pctqualma "% Highly Qualified Educators with a Master's Degree"

	}

	if `: list posof "prof_qual_rank1_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_rank1_pct pctqualrank1

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctqualrank1

		// Adds a variable label to this variable 
		la var pctqualrank1 "% Highly Qualified Educators with a Degree from a Rank 1 IHE"

	}

	if 	`: list posof "prof_qual_specialist_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_specialist_pct pctqualspecialist

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctqualspecialist

		// Adds a variable label to this variable 
		la var pctqualspecialist "% Highly Qualified Educators with a Specialist Endorsement"

	}

	if 	`: list posof "prof_qual_doctorate_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_doctorate_pct pctdr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctdr

		// Adds a variable label to this variable 
		la var pctdr "% Highly Qualified Educators with a Doctorate"

	}

	if 	`: list posof "prof_qual_tch_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename prof_qual_tch_pct pctqualtch

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctqualtch

		// Adds a variable label to this variable 
		la var pctqualtch "% Highly Qualified Educators"

	}

	if 	`: list posof "tch_prov_cert_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename tch_prov_cert_pct pctprovcert

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctprovcert

		// Adds a variable label to this variable 
		la var pctprovcert "% of Educators with Provisional Certification"

	}

	if 	`: list posof "stdnt_comp_ratio" in x' != 0 {
		qui: split stdnt_comp_ratio, parse(":") gen(x)
		qui: g stdcompratio = cond(real(x1) == 0, 0, (real(x2) / real(x1))) 
		qui: drop stdnt_comp_ratio x1 x2

		// Adds a variable label to this variable 
		la var stdcompratio "Student to Computer Ratio"

	}

	if 	`: list posof "computer_5yr_old_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename computer_5yr_old_pct pctoldcomp

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctoldcomp

		// Adds a variable label to this variable 
		la var pctoldcomp "% of Computers > 5 Years Old"

	}

	if 	`: list posof "pt_conference" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pt_conference ptconf

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ptconf

		// Adds a variable label to this variable 
		la var ptconf "# of Parents Attenting Parent-Teacher Conferences"

	}

	if 	`: list posof "sbdm_vote" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename sbdm_vote sbdmvote

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' sbdmvote

		// Adds a variable label to this variable 
		la var sbdmvote "# of SBDM Votes Cast"

	}

	if 	`: list posof "parents_on_council" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename parents_on_council councilparent

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' councilparent

		// Adds a variable label to this variable 
		la var councilparent "# of Parents on Council"

	}

	if 	`: list posof "volunteer_hrs" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename volunteer_hrs volunteertime

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' volunteertime

		// Adds a variable label to this variable 
		la var volunteertime "# of Volunteer Hours"

	}
	
	if 	`: list posof "enrollment_total" in x' != 0 {
		qui: replace membership = enrollment_total if mi(membership) & !mi(enrollment_total) 
		drop enrollment_total

	}

	if 	`: list posof "enrollment_male_cnt" in x' != 0 {
		qui: replace nmale = enrollment_male_cnt if mi(nmale) & !mi(enrollment_male_cnt) 
		drop enrollment_male_cnt

	}

	if 	`: list posof "enrollment_male_pct" in x' != 0 {
		qui: replace pctmale = enrollment_male_pct if mi(pctmale) & !mi(enrollment_male_pct) 
		drop enrollment_male_pct

	}

	if 	`: list posof "enrollment_female_cnt" in x' != 0 {
		qui: replace nfemale = enrollment_female_cnt if mi(nfemale) & !mi(enrollment_female_cnt) 
		drop enrollment_female_cnt

	}

	if 	`: list posof "enrollment_female_pct" in x' != 0 {
		qui: replace pctfemale = enrollment_female_pct if mi(pctfemale) & !mi(enrollment_female_pct) 
		drop enrollment_female_pct

	}

	if 	`: list posof "enrollment_white_cnt" in x' != 0 {
		qui: replace nwhite = enrollment_white_cnt if mi(nwhite) & !mi(enrollment_white_cnt) 
		drop enrollment_white_cnt

	}

	if 	`: list posof "enrollment_white_pct" in x' != 0 {
		qui: replace pctwhite = enrollment_white_pct if mi(pctwhite) & !mi(enrollment_white_pct) 
		drop enrollment_white_pct

	}

	if 	`: list posof "enrollment_black_cnt" in x' != 0 {
		qui: replace nblack = enrollment_black_cnt if mi(nblack) & !mi(enrollment_black_cnt) 
		drop enrollment_black_cnt

	}

	if 	`: list posof "enrollment_black_pct" in x' != 0 {
		qui: replace pctblack = enrollment_black_pct if mi(pctblack) & !mi(enrollment_black_pct) 
		drop enrollment_black_pct

	}

	if 	`: list posof "enrollment_hispanic_cnt" in x' != 0 {
		qui: replace nhisp = enrollment_hispanic_cnt if mi(nhisp) & !mi(enrollment_hispanic_cnt) 
		drop enrollment_hispanic_cnt

	}

	if 	`: list posof "enrollment_hispanic_pct" in x' != 0 {
		qui: replace pcthisp = enrollment_hispanic_pct if mi(pcthisp) & !mi(enrollment_hispanic_pct) 
		drop enrollment_hispanic_pct

	}

	if 	`: list posof "enrollment_asian_cnt" in x' != 0 {
		qui: replace nasian = enrollment_asian_cnt if mi(nasian) & !mi(enrollment_asian_cnt) 
		drop enrollment_asian_cnt

	}

	if 	`: list posof "enrollment_asian_pct" in x' != 0 {
		qui: replace pctasian = enrollment_asian_pct if mi(pctasian) & !mi(enrollment_asian_pct) 
		drop enrollment_asian_pct

	}

	if 	`: list posof "enrollment_aian_cnt" in x' != 0 {
		qui: replace naian = enrollment_aian_cnt if mi(naian) & !mi(enrollment_aian_cnt) 
		drop enrollment_aian_cnt

	}

	if 	`: list posof "enrollment_aian_pct" in x' != 0 {
		qui: replace pctaian = enrollment_aian_pct if mi(pctaian) & !mi(enrollment_aian_pct) 
		drop enrollment_aian_pct

	}

	if 	`: list posof "enrollment_hawaiian_cnt" in x' != 0 {
		qui: replace npacisl = enrollment_hawaiian_cnt if mi(npacisl) & !mi(enrollment_hawaiian_cnt) 
		drop enrollment_hawaiian_cnt

	}

	if 	`: list posof "enrollment_hawaiian_pct" in x' != 0 {
		qui: replace pctpacisl = enrollment_hawaiian_pct if mi(pctpacisl) & !mi(enrollment_hawaiian_pct) 
		drop enrollment_hawaiian_pct

	}

	if 	`: list posof "enrollment_other_cnt" in x' != 0 {
		qui: replace nmulti = enrollment_other_cnt if mi(nmulti) & !mi(enrollment_other_cnt) 
		drop enrollment_other_cnt

	}

	if 	`: list posof "enrollment_other_pct" in x' != 0 {
		qui: replace pctmulti = enrollment_other_pct if mi(pctmulti) & !mi(enrollment_other_pct) 
		drop enrollment_other_pct

	}

	if 	`: list posof "fte_tch_total" in x' != 0 {
		qui: replace nfte = fte_tch_total if mi(nfte) & !mi(fte_tch_total) 
		drop fte_tch_total

	}

	if 	`: list posof "male_fte_total" in x' != 0 {
		rename male_fte_total malefte 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' malefte

		// Adds a variable label to this variable 
		la var malefte "# of Male FTE"

	}

	if 	`: list posof "female_fte_total" in x' != 0 {
		rename female_fte_total femalefte

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' femalefte

		// Adds a variable label to this variable 
		la var femalefte "# of Female FTE"

	}

	if 	`: list posof "male_total" in x' != 0 {
		qui: replace nmale = male_total if mi(nmale) & !mi(male_total) 
		drop male_total

	}

	if 	`: list posof "female_total" in x' != 0 {
		qui: replace nfemale = female_total if mi(nfemale) & !mi(female_total) 
		drop female_total

	}

	if 	`: list posof "white_male_cnt" in x' != 0 {
		rename white_male_cnt nwhitem 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nwhitem

		// Adds a variable label to this variable 
		la var nwhitem "# of White Males"

	}

	if 	`: list posof "white_female_cnt" in x' != 0 {
		rename white_female_cnt nwhitef

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nwhitef

		// Adds a variable label to this variable 
		la var nwhitef "# of White Females"

	}

	if 	`: list posof "white_total" in x' != 0 {
		qui: replace nwhite = white_total if mi(nwhite) & !mi(white_total) 
		drop white_total

	}

	if 	`: list posof "black_male_cnt" in x' != 0 {
		rename black_male_cnt nblackm 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nblackm

		// Adds a variable label to this variable 
		la var nblackm "# of Black Males"

	}

	if 	`: list posof "black_female_cnt" in x' != 0 {
		rename black_female_cnt nblackf

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nblackf

		// Adds a variable label to this variable 
		la var nblackf "# of Black Females"

	}

	if 	`: list posof "black_total" in x' != 0 {
		qui: replace nblack = black_total if mi(nblack) & !mi(black_total) 
		drop black_total

	}

	if 	`: list posof "hispanic_male_cnt" in x' != 0 {
		rename hispanic_male_cnt nhispm

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nhispm

		// Adds a variable label to this variable 
		la var nhispm "# of Hispanic/Latino Males"

	}

	if 	`: list posof "hispanic_female_cnt" in x' != 0 {
		rename hispanic_female_cnt nhispf

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nhispf

		// Adds a variable label to this variable 
		la var nhispf "# of Hispanic/Latina Females"

	}

	if 	`: list posof "hispanic_total" in x' != 0 {
		qui: replace nhisp = hispanic_total if mi(nhisp) & !mi(hispanic_total) 
		drop hispanic_total

	}

	if 	`: list posof "asian_male_cnt" in x' != 0 {
		rename asian_male_cnt nasianm

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nasianm

		// Adds a variable label to this variable 
		la var nasianm "# of Asian Males"

	}

	if 	`: list posof "asian_female_cnt" in x' != 0 {
		rename asian_female_cnt nasianf

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nasianf

		// Adds a variable label to this variable 
		la var nasianf "# of Asian Females"

	}

	if 	`: list posof "asian_total" in x' != 0 {
		qui: replace nasian = asian_total if mi(nasian) & !mi(asian_total) 
		drop asian_total

	}

	if 	`: list posof "aian_male_cnt" in x' != 0 {
		rename aian_male_cnt naianm

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' naianm

		// Adds a variable label to this variable 
		la var naianm "# of American Indian/Alaskan Native Males"

	}

	if 	`: list posof "aian_female_cnt" in x' != 0 {
		rename aian_female_cnt naianf 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' naianf

		// Adds a variable label to this variable 
		la var naianf "# of American Indian/Alaskan Native Females"

	}

	if 	`: list posof "aian_total" in x' != 0 {
		qui: replace naian = aian_total if mi(naian) & !mi(aian_total) 
		drop aian_total

	}

	if 	`: list posof "hawaiian_male_cnt" in x' != 0 {
		rename hawaiian_male_cnt npacislm

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' npacislm

		// Adds a variable label to this variable 
		la var npacislm "# of Native Hawaiian/Pacific Islander Males"

	}

	if 	`: list posof "hawaiian_female_cnt" in x' != 0 {
		rename hawaiian_female_cnt npacislf 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' npacislf

		// Adds a variable label to this variable 
		la var npacislf "# of Native Hawaiian/Pacific Islander Females"

	}

	if 	`: list posof "hawaiian_total" in x' != 0 {
		qui: replace npacisl = hawaiian_total if mi(npacisl) & !mi(hawaiian_total) 
		drop hawaiian_total

	}

	if 	`: list posof "two_or_more_race_male_cnt" in x' != 0 {
		rename two_or_more_race_male_cnt nmultim

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmultim

		// Adds a variable label to this variable 
		la var nmultim "# of Multi-Racial Males"

	}

	if 	`: list posof "two_or_more_race_female_cnt" in x' != 0 {
		rename two_or_more_race_female_cnt nmultif

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nmultif

		// Adds a variable label to this variable 
		la var nmultif "# of Multi-Racial Females"

	}

	if 	`: list posof "two_or_more_race_total" in x' != 0 {
		qui: replace nmulti = two_or_more_race_total if mi(nmulti) & !mi(two_or_more_race_total) 
		drop two_or_more_race_total

	}

	// Handles Growth Score types
	if 	`: list posof "growth_level" in x' != 0 {
		qui: g growid = cond(growth_level == "Student Growth Percentage" | 	 ///   
							mi(growth_level) & real(schyr) <= 2015, 1,			 ///   
							cond(growth_level == "Categorical Growth", 2, .g))
		drop growth_level
		qui: reshape wide tested grorla gromth groboth, i(schyr schid level  ///   
		fileid) j(growid)
		rename (tested1 grorla1 gromth1 groboth1 tested2 grorla2 gromth2 	 ///   
		groboth2)(sgptested sgprla sgpmth sgpboth cattested catrla catmth 	 ///   
		catboth)

		// Adds a variable label to this variable 
		la var sgptested "Student Growth Percentile - # of Students Tested" 

		// Adds a variable label to this variable 
		la var sgprla "Student Growth Percentile - Reading" 

		// Adds a variable label to this variable 
		la var sgpmth "Student Growth Percentile - Mathematics" 

		// Adds a variable label to this variable 
		la var sgpboth "Student Growth Percentile - Reading & Mathematics" 

		// Adds a variable label to this variable 
		la var cattested "Categorical Growth - # of Students Tested" 

		// Adds a variable label to this variable 
		la var catrla "Categorical Growth - Reading" 

		// Adds a variable label to this variable 
		la var catmth "Categorical Growth - Mathematics" 

		// Adds a variable label to this variable 
		la var catboth "Categorical Growth - Reading & Mathematics"
		qui: egen x = rowmiss(sgptested sgprla sgpmth sgpboth cattested 	 ///   
		catrla catmth catboth)
		qui: drop if x == 8
		drop x
		loc torecast : subinstr loc torecast "tested" "", all
		loc torecast : subinstr loc torecast "grorla" "", all
		loc torecast : subinstr loc torecast "gromth" "", all
		loc torecast : subinstr loc torecast "groboth" "", all

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' sgptested cattested sgprla sgpmth sgpboth 	 ///   
		catrla catmth catboth
							

	}
		
	if `: list posof "comp_and_domain_enrollment" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename comp_and_domain_enrollment cndenr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cndenr

		// Adds a variable label to this variable 
		la var cndenr "# Enrolled - Composite & Domain"

	}

	if `: list posof "comp_and_domain_numtested" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename comp_and_domain_numtested cndtested

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cndtested

		// Adds a variable label to this variable 
		la var cndtested "# Tested - Composite & Domain"

	}

	if `: list posof "comp_and_domain_partciprate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename comp_and_domain_partciprate cndpartic
		qui: replace cndpartic = ".n" if cndpartic == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cndpartic

		// Adds a variable label to this variable 
		la var cndpartic "Participation Rate - Composite & Domain"

	}

	if `: list posof "shse_enrollment" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename shse_enrollment shseenr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' shseenr

		// Adds a variable label to this variable 
		la var shseenr "# Enrolled - Self-Help & Social-Emotional"

	}

	if `: list posof "shse_numtested" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename shse_numtested shsetested

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' shsetested

		// Adds a variable label to this variable 
		la var shsetested "# Tested - Self-Help & Social-Emotional"

	}

	if `: list posof "shse_participrate" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename shse_participrate shsepartic
		qui: replace shsepartic = ".n" if shsepartic == "N/A"

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' shsepartic

		// Adds a variable label to this variable 
		la var shsepartic "Participation Rate - Self-Help & Social-Emotional"

	}

	if `: list posof "kr_not_ready" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename kr_not_ready knotready

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' knotready

		// Adds a variable label to this variable 
		la var knotready "# Students Not Ready for Kindergarten"

	}

	if `: list posof "kr_kindergartenready" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename kr_kindergartenready kready

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' kready

		// Adds a variable label to this variable 
		la var kready "# Students Ready for Kindergarten"

	}

	if `: list posof "cog_below_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cog_below_avg cogblw

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cogblw

		// Adds a variable label to this variable 
		la var cogblw "% of Below Average on Cognitive Measures"

	}

	if `: list posof "cog_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cog_avg cogavg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cogavg

		// Adds a variable label to this variable 
		la var cogavg "% of Average on Cognitive Measures"

	}

	if `: list posof "cog_above_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cog_above_avg cogabv

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cogabv

		// Adds a variable label to this variable 
		la var cogabv "% of Above Average on Cognitive Measures"

	}

	if `: list posof "lang_below_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename lang_below_avg lanblw

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' lanblw

		// Adds a variable label to this variable 
		la var lanblw "% of Below Average on Language Measures"

	}

	if `: list posof "lang_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename lang_avg lanavg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' lanavg

		// Adds a variable label to this variable 
		la var lanavg "% of Average on Language Measures"

	}

	if `: list posof "lang_above_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename lang_above_avg lanabv

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' lanabv

		// Adds a variable label to this variable 
		la var lanabv "% of Above Average on Language Measures"

	}

	if `: list posof "phydev_below_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename phydev_below_avg phyblw

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' phyblw

		// Adds a variable label to this variable 
		la var phyblw "% of Below Average on Physical Development Measures"

	}

	if `: list posof "phydev_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename phydev_avg phyavg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' phyavg

		// Adds a variable label to this variable 
		la var phyavg "% of Average on Physical Development Measures"

	}

	if `: list posof "phydev_above_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename phydev_above_avg phyabv

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' phyabv

		// Adds a variable label to this variable 
		la var phyabv "% of Above Average on Physical Development Measures"

	}

	if `: list posof "selfhelp_below_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename selfhelp_below_avg slfblw

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' slfblw

		// Adds a variable label to this variable 
		la var slfblw "% of Below Average on Self-Help Measures"

	}

	if `: list posof "selfhelp_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename selfhelp_avg slfavg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' slfavg

		// Adds a variable label to this variable 
		la var slfavg "% of Average on Self-Help Measures"

	}

	if `: list posof "selfhelp_above_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename selfhelp_above_avg slfabv

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' slfabv

		// Adds a variable label to this variable 
		la var slfabv "% of Above Average on Self-Help Measures"

	}

	if `: list posof "social_emo_below_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename social_emo_below_avg selblw

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' selblw

		// Adds a variable label to this variable 
		la var selblw "% of Below Average on Socio-Emotional Measures"

	}

	if `: list posof "social_emo_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename social_emo_avg selavg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' selavg

		// Adds a variable label to this variable 
		la var selavg "% of Average on Socio-Emotional Measures"

	}

	if `: list posof "social_emo_above_avg" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename social_emo_above_avg selabv

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' selabv

		// Adds a variable label to this variable 
		la var selabv "% of Above Average on Socio-Emotional Measures"

	}

	if 	`: list posof "coop_cd" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename coop_cd coopid 

		// Adds a variable label to this variable 
		la var coopid "Cooperative ID Number"

	}
	
	if ustrregexm(`"`x'"', "cohort_[0-9]{4}") == 1 {
		rename cohort_# cohort#
		cap drop reportyear_2014
		cap rename reportyear_# cohort#
		foreach v of var cohort???? {
			qui: replace `v' = 	cond(upper(`v') == "YES", "1", 				 ///   
								cond(upper(`v') == "NO", "0", 				 ///   
								cond(upper(`v') == "N/A", ".n", 			 ///   
								cond(upper(`v') == "***", ".s", 			 ///   
								cond(upper(`v') == "---", ".d", `v')))))

			// Adds to list of variables that need to be recast as numeric 
			loc torecast `torecast' `v'
		}
		qui: egen nullrecord = rowmiss(cohort*)
		qui: ds cohort*
		qui: drop if nullrecord == `: word count `r(varlist)''
		drop nullrecord		
		// deltargets, st(cohort) pk(fileid schid schyr amogroup) tar(targettype)

	}	
	
	if `: list posof "test_takers_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename test_takers_cnt ntested

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ntested

		// Adds a variable label to this variable 
		la var ntested "# of Students Taking AP Exams"

	}

	if `: list posof "test_takers_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename test_takers_pct pcttested

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pcttested

		// Adds a variable label to this variable 
		la var pcttested "% of Students Taking AP Exams"

	}

	if `: list posof "exam_taken_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename exam_taken_cnt nexams

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nexams

		// Adds a variable label to this variable 
		la var nexams "# of AP Exams Administered"

	}

	if `: list posof "exam_taken_grade3to5_cnt" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename exam_taken_grade3to5_cnt ncredit

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ncredit

		// Adds a variable label to this variable 
		la var ncredit "# of Exams with College Credit Bearing Scores"

	}

	if `: list posof "exam_taken_grade3to5_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename exam_taken_grade3to5_pct pctcredit

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctcredit

		// Adds a variable label to this variable 
		la var pctcredit "% of Exams with College Credit Bearing Scores"

	}
	
		if `: list posof "py_novice_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_novice_pct pnovicepct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pnovicepct

		// Adds a variable label to this variable 
		la var pnovicepct "Prior Year % Novice"

	}

	if `: list posof "py_reduction_target_needed" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename py_reduction_target_needed pynovicetarget

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pynovicetarget

		// Adds a variable label to this variable 
		la var pynovicetarget "Prior Year Reduction Target"

	}

	if `: list posof "cy_novice_pct" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cy_novice_pct cnovicepct

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cnovicepct

		// Adds a variable label to this variable 
		la var cnovicepct "Current Year % Novice"

	}

	if `: list posof "cy_reduction_target_met" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename cy_reduction_target_met cnovicemet

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' cnovicemet

		// Adds a variable label to this variable 
		la var cnovicemet "Current Year Target Met"

	}

	if `: list posof "pct_target_met" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename pct_target_met pctmet

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' pctmet

		// Adds a variable label to this variable 
		la var pctmet "% of Students Meeting Target"

	}

	if `: list posof "points_by_content_area" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename points_by_content_area contentpts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' contentpts

		// Adds a variable label to this variable 
		la var contentpts "Novice Reduction Points by Content Area"

	}

	if `: list posof "points_by_nr" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename points_by_nr nrpts

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nrpts

		// Adds a variable label to this variable 
		la var nrpts "Novice Reduction Points"

	}

	if `: list posof "reading" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename reading rlagap

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' rlagap

		// Adds a variable label to this variable 
		la var rlagap "Gap Summary - Reading"

	}

	if `: list posof "math" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename math mthgap

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' mthgap

		// Adds a variable label to this variable 
		la var mthgap "Gap Summary - Mathematics"

	}

	if `: list posof "science" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename science scigap

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' scigap

		// Adds a variable label to this variable 
		la var scigap "Gap Summary - Science"

	}

	if `: list posof "social_studies" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename social_studies socgap 

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' socgap

		// Adds a variable label to this variable 
		la var socgap "Gap Summary - Social Studies"

	}

	if `: list posof "writing" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename writing wrtgap

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' wrtgap

		// Adds a variable label to this variable 
		la var wrtgap "Gap Summary - Writing"

	}

	if `: list posof "language_mechanics" in x' != 0 {

		// Renames the variable to standardized name 
		qui: rename language_mechanics langap

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' langap

		// Adds a variable label to this variable 
		la var langap "Gap Summary - Language Mechanics"

	}

	if `: list posof "acct_type" in x' != 0 { 

		// Renames the variable to standardized name 
		qui: rename acct_type accttype
		qui: replace accttype = cond(accttype == "GAP", "0", "1")

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' accttype

		// Adds a variable label to this variable 
		la var accttype "Accountability Type"						

	}

	if `: list posof "non_dup_gap" in x' != 0 { 

		// Renames the variable to standardized name 
		qui: rename non_dup_gap ndg

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' ndg

		// Adds a variable label to this variable 
		la var ndg "Non Duplicated Gap Group"

	}

	if `: list posof "novice_reduction" in x' != 0 { 

		// Renames the variable to standardized name 
		qui: rename novice_reduction nr

		// Adds to list of variables that need to be recast as numeric 
		loc torecast `torecast' nr

		// Adds a variable label to this variable 
		la var nr "Novice Reduction Gap"

	}

	// Handles instances of the sch_name variable
	if `: list posof "sch_name" in x' != 0 {
		
		// Renames the school name variable

		// Renames the variable to standardized name 
		qui: rename sch_name schnm 
		
		// Replaces instances of State with the name of the state
		qui: replace schnm = "Kentucky" if ustrregexm(schnm, "state", 1)
		
		// Add School District to the end of the school name for cases where 
		// the school name is not the state and references a school district
		qui: replace schnm = distnm + " School District" if					 ///   
		schid != "999999" & substr(schid, -3, 3) == "999"
		
		// Checks if the same school has multiple names
		qui: egen unschnms = nvals(schnm), by(schid)
		
		// Sort by school id in ascending order and school year in descending order
		gsort schid - schyr
		
		// Replace other names with most recent name if school had multiple names
		qui: replace schnm = schnm[_n - 1] if unschnms > 1 &				 ///   
		schnm[_n - 1] != schnm & schid[_n - 1] == schid
		
		// Drops the variable used to count the number of unique values in the 
		// school name variable
		drop unschnms
		
		// Assigns variable label to the variable

		// Adds a variable label to this variable 
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
		cap char `v'[destring] ""
		cap char `v'[destring_cmd] ""

	} // End Loop	
		
	// If metric variable list is passed this will check for empty records.
	if `"`metricvars'"' != "" {
		
		// Gets the number of metric variables
		loc mvars `: word count `metricvars''
		
		// Creates a new variable with the number of missing values across the 
		// list of metric variables
		qui: egen nullrow = rowmiss(`metricvars')
		
		// Drops records where all metric variables are missing
		qui: drop if nullrow == `mvars'
		
		// Drops the nullrow variable
		qui: drop nullrow
		

	} // End IF BLOCK for handling metricvars arguments
	
	// Check for primary key if user passed values to the parameter
	if `"`primarykey'"' != "" { 
		
		// Tests the primary key constraint
		testpk `: subinstr loc primarykey "fileid" "", all'
		
		// Sort the data based on the values passed to the primary key parameter
		qui: sort `primarykey'
	
		// Keep only variables containing values or identifying information
		if `"`metricvars'"' != "" keep `primarykey' `metricvars'
		
		// Sets the display order of the variables
		order `primarykey' `metricvars'
		

	} // End IF Block for primary key option
	
	// Optimization of storage types/formats
	qui: compress
		
	// Get variable names
	qui: ds
	
	// Store variable list
	loc vars `r(varlist)'
	
	// Call sqltypes program
	sqltypes `vars', `tablename'
	
	// Test for level and grade variable in same file
	if `: list posof "level" in vars' != 0 & `: list posof "grade" in vars' != 0 {
	
		// Impute missing level values with the grade value as needed
		qui: levimpute level, fr(grade)
	
	} // End IF Block to handle missing educational level values
	
	// Store the DDL temporarily
	loc tmp `r(tabledef)'
	
	// Return the result from the call to sqltypes to the end user
	ret loc tabledef `tmp'
	
// End of program	
end		

// Sub process to check for optional primary key definition
prog def testpk, rclass

	// Defines the calling syntax
	syntax varlist [, TABlename(string asis) ]
	
	// Captures result of call to the isid command
	cap isid `varlist'
	
	// If successful print success message on console
	if _rc == 0 di as res "Primary Key: `varlist' confirmed."
	
	// Otherwise print an error message
	else di as err "Primary Key: `varlist' failed."
	
	// Adds string containing primary key definition as a data set characteristic
	char define _dta[primaryKey] `"`: subinstr loc varlist " " ", ", all'"'
	
	// Return the return code from the program
	ret sca _rc = _rc
	
// End the testpk subroutine	
end	

// Subroutine for handling reshaping the delivery targets data 
prog def deltargets

	// Defines calling syntax to subroutine
	syntax, STub(string asis) Pk(varlist) [ TARgettype(string asis) 		 ///   
	i1(string asis) i2(string asis) i3(string asis) j1(string asis) 		 ///   
	j2(string asis) j3(string asis) ]
	
		// If no targettype argument is found define default value
		if `"`targettype'"' == "" loc targettype targettype

		// Tests whether or not the target type variable is a string
		// If so sets a local to specify the string option for the reshape command
		if substr(`"`: type `targettype''"', 1, 3) == "str" loc stringy string
		
		// Or sets a null macro
		else loc stringy 
		
		// Defines default for i1 parameter if no argument passed
		if `"`i1'"' == "" loc i1 `pk' target `targettype'
		
		// Defines default for j1 parameter if no argument is passed
		if `"`j1'"' == "" loc j1 targetyr
		
		// Defines default for i2 parameter if no argument is passed
		if `"`i2'"' == "" loc i2 `pk' targetyr target
		
		// Defines default for j2 parameter if no argument is passed
		if `"`j2'"' == "" loc j2 `targettype'
		
		// Defines default for i3 parameter if no argument is passed
		if `"`i3'"' == "" loc i3 `pk' targetyr
		
		// Defines default for j3 parameter if no argument is passed
		if `"`j3'"' == "" loc j3 target
		
		// Drops the ncesid variable if present in the file and captures error 
		// code if it doesn't
		cap drop ncesid
		
		// Reshapes the data from wide to long (Normalizes)
		qui: reshape long `stub', i(`i1') j(`j1') `stringy'
		
		// Reshapes the data from long to wide (Denormalizes)
		qui: reshape wide `stub', i(`i2') j(`j2')
		
		// Gets the variable list for the stub passed to the program
		qui: ds `stub'*
		
		// Stores the variable list in the local macro x
		loc x `r(varlist)'

		// Tests whether or not the target type variable is a string
		// If so sets a local to specify the string option for the reshape command
		if substr(`"`: type `j3''"', 1, 3) == "str" loc stringy string
		
		// Or sets a null macro
		else loc stringy 
		
		// If there are two variables only
		if `: word count `x'' == 2 {
		
			// Rename these variables n and pct respectively
			rename (`stub'1 `stub'2)(n pct)
			
			// Then reshape the data from long to wide (Denormalize)
			qui: reshape wide n pct, i(`i3') j(`j3') `stringy'
			
		} // End IF Block for two stub variables scenario
		
		// Otherwise
		else {
		
			// Rename the stub variables pct
			rename `stub'* pct
			
			// Create a new variable n to standardize reshape call below using 
			// the smallest sized missing values possible
			qui: g byte n = .
			
			// Reshape the data from long to wide (Denormalize)
			qui: reshape wide n pct, i(`i3') j(`j3') `stringy'
			
			// Drop the variables that we created in this process that begin 
			// with n and have a single character afterwards
			drop n?
			
		} // End ELSE Block
		
		// Defines value labels for meeting/not meeting taget goals
		la def met .n "N/A" 0 "No" 1 "Yes", modify
		
		// Defines a variable label for the variable specified in the j1 parameter

		// Adds a variable label to this variable 
		la var `j1' "Delivery Target Year"
		
		// Gets the list of percentage variables
		qui: ds pct* 
		
		// Stores these variable names in the local macro named targets
		loc targets `r(varlist)'
		
		// If pct1 is a variable name in the variable list
		if `: list posof "pct1" in targets' != 0 {
		
			// Will capture any errors associated with number value targets
			cap {
			
				// Renames the variable to nactual
				rename n1 nactual
				
				// Applies a variable label

				// Adds a variable label to this variable 
				la var nactual "Actual Score # Target"
				
			} // End of first capture block
			
			// Captures any errors related to percentage variables
			cap {
			
				// Renames to pctactual

				// Renames the variable to standardized name 
				qui: rename pct1 pctactual
				
				// Applies a variable label to the variable

				// Adds a variable label to this variable 
				la var pctactual "Actual Score % Target"
				
			} // End of capture block
			
		} // End of Block handling the pct1 variable name in the variable list
		
		if `: list posof "pct2" in targets' != 0 {
			cap {
				rename n2 ndelivery

				// Adds a variable label to this variable 
				la var ndelivery "Delivery Target # Target"
			}
			cap {

				// Renames the variable to standardized name 
				qui: rename pct2 pctdelivery

				// Adds a variable label to this variable 
				la var pctdelivery "Delivery Target % Target"
			}
		}
		
		if `: word count `targets'' == 5 {
		
			if `: list posof "pct3" in targets' != 0 {
				cap {
					rename n3 nnum

					// Adds a variable label to this variable 
					la var nnum "Numerator # Target"
				}
				cap {

					// Renames the variable to standardized name 
					qui: rename pct3 pctnum

					// Adds a variable label to this variable 
					la var pctnum "Numerator % Target"
				}
			}
			
			if `: list posof "pct4" in targets' != 0 {
				cap {
					rename n4 nden

					// Adds a variable label to this variable 
					la var nden "Denominator # Target"
				}
				cap {

					// Renames the variable to standardized name 
					qui: rename pct4 pctden

					// Adds a variable label to this variable 
					la var pctden "Denominator % Target"
				}
			}
			
			if `: list posof "pct5" in targets' != 0 {
				cap {

					// Renames the variable to standardized name 
					qui: rename pct5 met
					qui: compress met
					la val met met

					// Adds a variable label to this variable 
					la var met "Met Target"
					assert pctactual > pctdelivery if met == 1
				}
				cap drop n5
			}
			
		}
		
		else if `: word count `targets'' == 3 {
			cap {

				// Renames the variable to standardized name 
				qui: rename pct5 met
				qui: compress met
				la val met met

				// Adds a variable label to this variable 
				la var met "Met Target"
				assert pctactual > pctdelivery if met == 1
			}
		}
		
end

// Defines subroutine to check for dependencies		
prog def checkdep

	// Defines calling syntax
	syntax anything(name = deps id = "Package dependencies")
	
	// Loop over the dependencies
	foreach v of loc deps {
	
		// Capture/handle any errors
		cap which `v'
		
		// If not installed install from ssc
		if _rc != 0 cap ssc inst `v', replace
	

	} // End Loop over the dependencies
	
// End of subroutine definition
end
	
// Replaces level variable if missing and grade indicates level
prog def levimpute

	// Defines calling syntax
	syntax anything(name = impvar id ="Variable to impute values for"), 	 ///   
	FRom(varname num)

	// Replaces the values of the level variable impvar with the correct mapping 
	// if the grade variable or values in the grade variable are passed as the 
	// from variable
	qui: replace `impvar' = cond(mi(`impvar') & `from' == 93, 1,			 ///   
							cond(mi(`impvar') & `from' == 94, 2,			 ///   
							cond(mi(`impvar') & `from' == 99, 3, `impvar')))	
// End subroutine	
end
