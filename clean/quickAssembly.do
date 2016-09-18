/*******************************************************************************
 * Accountability System School Profiles                                       *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_PROFILE, sheets(`"`"Accountability Profile Data"' `"ACCOUNTABILITY PROFILE"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)

// Drop variables that either don't have any logical flow or don't contain data
drop category next_yr_score *_py sch_type state_sch_id trend_display

// Make all school codes six digits long
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3

// Standardize district ID numbers
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)

// Standardize non-unique school numbers
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)

// Pull out just the end year from the school year field
qui: replace sch_year = substr(sch_year, 5, 8)

// Use numeric encodings for content_level field
qui: replace content_level = cond(ustrregexm(content_level, "[eE][lL][eE][mM].*") == 1, "1", ///   
							 cond(ustrregexm(content_level, "[mM][iI][dD].*") == 1, "2", "3"))

// Define value labels for the grade span level variable
la def level 1 "Elementary School" 2 "Middle School" 3 "High School", modify

// Use numeric encodings for AMO status
qui: replace amo_met = 	cond(amo_met == "No", "0", cond(amo_met == "Yes", "1", ""))

// Use numeric encodings for participation rate field
qui: replace participation_next_yr = cond(participation_next_yr == "No", "0", ///   
									 cond(participation_next_yr == "Yes", "1", ""))

// Use numeric encodings for graduation rate goal field									 
qui: replace graduation_rate_goal = cond(graduation_rate_goal == "N/A", ".n", ///   
									cond(graduation_rate_goal == "No", "0", ///   
									cond(graduation_rate_goal == "Yes", "1", "")))
						
// Replace all instances of -R with missing value in base year score						
qui: replace base_yr_score = subinstr(base_yr_score, "-R", "", .)						
						
// Recode classification with numeric values						
qui: replace classification = 	cond(classification == `"Distinguished"', "6", ///  
								cond(classification == `"Distinguished/Progressing"', "5", ///  
								cond(classification == `"Needs Improvement"', "1", ///  
								cond(classification == `"Needs Improvement/Progressing"', "2", ///  
								cond(classification == `"Proficient"', "4", ///  
								cond(classification == `"Proficient/Progressing"', "3", ""))))))
								
// Rename variables to remove underscores and standardize across files
rename (amo_met dist_number sch_number sch_year overall_score ky_rank 		 ///   
reward_recognition base_yr_score gain_needed amo_goal content_level 		 ///   
participation_next_yr graduation_rate_goal dist_name sch_name sch_cd cntyno	 ///   
coop_code cntyname) (amomet distid schid schyr overall rank reward baseline  ///   
gain amogoal level nextpartic gradgoal distnm schnm schnum cntyid coopid cntynm)						

// Define numeric encodings for the reward designations
qui: replace reward = 	///   
	cond(reward == `"District of Distinction"', "1", 						 ///
	cond(reward == `"District of Distinction/High Progress District"', "2",  ///
	cond(reward == `"Focus District"', "3", 								 ///
	cond(reward == `"Focus District/High Progress District"', "4", 			 ///
	cond(reward == `"Focus School"', "5", 									 ///
	cond(reward == `"Focus School/High Progress School"', "6", 				 ///
	cond(reward == `"High Performing District"', "7", 						 ///
	cond(reward == `"High Performing District/High Progress District"', "8", ///
	cond(reward == `"High Performing School"', "9", 						 ///
	cond(reward == `"High Performing School/High Progress School"', "10", 	 ///
	cond(reward == `"High Progress District"', "11", 						 ///
	cond(reward == `"High Progress School"', "12", 							 ///
	cond(reward == `"Priority School"', "13", 								 ///
	cond(reward == `"Priority School(Monitoring Only)"', "14", 				 ///
	cond(reward == `"Priority School/High Progress School"', "15", 			 ///
	cond(reward == `"School of Distinction"', "16", 						 ///
	cond(reward == `"School of Distinction/High Progress School"', "17", ""))))))))))))))))) 

// Convert these variables to numeric types	
destring amomet schyr overall rank classification reward baseline gain 		 ///   
amogoal gradgoal nextpartic level, replace

// Define value labels for AMO variable
la def amomet 0 "Did not meet AMOs" 1 "Met AMOs", modify

// Define value labels for school classification variable
la def classification 	1 `"Needs Improvement"'								 ///    
						2 `"Needs Improvement/Progressing"' 				 ///   
						3 `"Proficient/Progressing"' 						 ///   
						4 `"Proficient"' 									 ///   
						5 `"Distinguished/Progressing"' 					 ///    
						6 `"Distinguished"', modify
						
// Define value labels for graduation rate goal variable						
la def gradgoal .n "N/A" 0 "No" 1 "Yes", modify

// Define value labels for participation rate variable
la def nextpartic 0 "No" 1 "Yes", modify

// Define value labels for reward designations
la def reward 	1 `"District of Distinction"'								 ///   
				2 `"District of Distinction/High Progress District"'		 ///   
				3 `"Focus District"' 										 ///   
				4 `"Focus District/High Progress District"' 				 ///   
				5 `"Focus School"'  										 ///   
				6 `"Focus School/High Progress School"' 					 ///   
				7 `"High Performing District"' 								 ///   
				8 `"High Performing District/High Progress District"'		 ///    
				9 `"High Performing School"' 								 ///   
				10 `"High Performing School/High Progress School"' 			 ///   
				11 `"High Progress District"' 								 ///   
				12 `"High Progress School"' 								 ///   
				13 `"Priority School"' 										 ///   
				14 `"Priority School(Monitoring Only)"' 					 ///   
				15 `"Priority School/High Progress School"' 				 ///   
				16 `"School of Distinction"' 								 ///   
				17 `"School of Distinction/High Progress School"', modify

// Loops over the numeric variables that have value labels						
foreach v of var amomet classification reward gradgoal nextpartic level {

	// Applies the value label to the variable
	la val `v' `v'
	
} // End of Loop

/*
	The block below defines variable labels for most of the variables.
*/	
la var schyr "School Year"
la var distid "District ID"
la var schid "School ID"
la var amomet "AMO Status Indicator"
la var schnm "School Name"
la var distnm "District Name" 
la var distid "District ID"
la var schnum "School Number"
la var cntyid "County ID"
la var cntynm "County Name"
la var coop "Cooperative Name"
la var coopid "Cooperative ID Number"
la var ncesid "National Center for Educational Statistics ID Number"
la var level "Educational Level"
la var overall "Overall Points in Accountability Model"
la var rank "Rank across State"
la var classification "Differentiated Accountability Status Indicator"
la var reward "Reward Status Indicator"
la var baseline "Baseline"
la var gain "Gain from Baseline Needed to meet AMOs"
la var amogoal "Annual Measureable Objectives Goal"
la var amomet "Met Annual Measureable Objectives"
la var nextpartic ""
la var gradgoal "Graduation Rate Goal"

// Sets the display order (e.g., column order) of the variables
order schyr schid distid schnum cntyid cntynm ncesid coop coopid distnm schnm ///   
overall rank classification reward baseline gain amogoal amomet nextpartic 	 ///   
gradgoal

// Saves the cleaned file
qui: save clean/acctProfile.dta, replace

/*******************************************************************************
 * Accountability System Summary                                               *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_SUMMARY, sheets(`"`"Accountability Summary Data"' `"ACCOUNTABILITY SUMMARY"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/acctSummary.dta, replace


/*******************************************************************************
 * Accountability System ACT data											   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_ACT.xlsx, first case(lower) clear sheet(`"Public Schools"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile act1
qui: save `act1'.dta, replace
kdecombo ASSESSMENT_ACT, sheets(`"`"Public Alternative Programs"' `"ACT Data"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
append using `act1'.dta
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 4, 6) if mi(sch_number)
qui: replace sch_year = substr(sch_year, 5, 8)

amogroup disagg_order, la(disagg_label) lan(amogroup)
destring schyr

qui: save clean/assessACT.dta, replace

/*******************************************************************************
 * Accountability System Explore data										   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_EXPLORE.xlsx, first case(lower) clear sheet(`"Public Alternate Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile explore
qui: save `explore'.dta, replace
kdecombo ASSESSMENT_EXPLORE, sheets(`"`"Public Schools"' `"EXPLORE Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `explore'.dta
qui: save clean/assessExplore.dta, replace

/*******************************************************************************
 * Accountability System Plan data	   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_PLAN.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile plan
qui: save `plan'.dta, replace
kdecombo ASSESSMENT_PLAN, sheets(`"`"Public Schools"' `"PLAN Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `plan'.dta
qui: save clean/assessPlan.dta, replace

/*******************************************************************************
 * Accountability System KPREP End of Course Assessment Data				   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_EOC.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile keoc
qui: save `keoc'.dta, replace
kdecombo ASSESSMENT_KPREP_EOC, sheets(`"`"Public Schools"' `"Assessment KPREP-EOC"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `keoc'.dta

achgrfmt, v(disagg_order) la(disagg_label) lan(amogroup) dis(1)
drop dist_name sch_name sch_type category cntyno cntyname ncesid enrollment  ///   
state_sch_id particip_rate coop coop_code sch_cd proficient_distinguished
rename (dist_number sch_number test_type content_type sch_year content_level grade_level)(distid schid testnm content schyr schlev grade)
order distid schid schyr schlev content testnm grade amogroup tested novice apprentice proficient distinguished

isid distid schid schyr content grade amogroup
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
la var testnm "Test Name" 
la var grade "Grade Level of Test" 

qui: save clean/assessEOC.dta, replace

/*******************************************************************************
 * Accountability System KPREP Grade Level Assessment Data					   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_GRADE.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile kgr
qui: save `kgr'.dta, replace
kdecombo ASSESSMENT_KPREP_GRADE, sheets(`"`"Public Schools"' `"Assessment KPREP Grades"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `kgr'.dta

achgrfmt, v(disagg_order) la(disagg_label) lan(amogroup) dis(1)
drop dist_name sch_name sch_type category cntyno cntyname ncesid enrollment  ///   
state_sch_id particip_rate coop coop_code sch_cd proficient_distinguished
rename (grade_level dist_number sch_number test_type content_level content_type sch_year)(grade distid schid testnm schlev content schyr)
order distid schid schyr schlev content testnm grade amogroup tested novice apprentice proficient distinguished
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
la var testnm "Test Name" 
la var grade "Grade Level of Test" 
isid distid schid schyr content grade amogroup

qui: save clean/assessKPREPgr.dta, replace

/*******************************************************************************
 * Accountability System KPREP Educational Level Assessment Data			   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_LEVEL.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile klev
qui: save `klev'.dta, replace
kdecombo ASSESSMENT_KPREP_LEVEL, sheets(`"`"Public Schools"' `"Assessment KPREP Level"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `klev'.dta

achgrfmt, v(disagg_order) la(disagg_label) lan(amogroup) dis(0) nogr
drop sch_cd dist_name sch_name sch_type category proficient_distinguished 	 ///   
cntyno cntyname state_sch_id ncesid enrollment particip_rate coop coop_code
rename (grade_level dist_number sch_number test_type content_level content_type sch_year)(grade distid schid testnm schlev content schyr)
order distid schid schyr schlev content testnm grade amogroup tested novice apprentice proficient distinguished
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
la var testnm "Test Name" 
la var grade "Grade Level of Test" 

qui: save clean/assessKPREPlevel.dta, replace

qui: append using clean/assessEOC.dta
qui: append using clean/assessKPREPgr.dta
sort distid schid schlev content grade amogroup schyr
qui: egen x = rowmiss(novice apprentice proficient distinguished tested)
qui: drop if x == 5
qui: drop x
qui: save clean/kprep.dta, replace

/*******************************************************************************
 * Accountability System NRT Assessment Data	   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_NRT.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
tempfile nrt
qui: save `nrt'.dta, replace
kdecombo ASSESSMENT_NRT, sheets(`"`"Public Schools"' `"SAT-NRT"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `nrt'.dta

qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace sch_number = substr(sch_cd, 1, 3) if mi(sch_number)
drop category sch_cd dist_name sch_name cntyno cntyname state_sch_id 		 ///   
ncesid coop coop_code sch_type
qui: replace sch_year = substr(sch_year, 5, 8)
rename (reading_percentile mathematics_percentile science_percentile social_percentile language_mechanics_percentile sch_year test_type dist_number sch_number)(pctile3 pctile2 pctile4 pctile5 pctile1 schyr testnm distid schid)
qui: replace testnm = "6"
foreach v of var pctile* {
	qui: replace `v' = ".s" if `v' == "***"
}
destring pctile* grade* testnm schyr, replace
reshape long pctile, i(distid schid schyr grade) j(content)
la def content 1 "Language Mechanics" 2 "Mathematics" 3 "Reading" 4 "Science" 5 "Social Studies" 6 "Writing" 7 "Algebra II" 8 "Biology" 9 "English II" 10 "U.S. History", modify


qui: save clean/assessNRT.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - College/Career Readiness Data   *
 ******************************************************************************/
kdecombo CTE_CAREER_CCR, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/cteCCR.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Career Pathways Data	   *
 ******************************************************************************/
kdecombo CTE_CAREER_PATHWAYS, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/ctePathway.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Perkins Program Data			   *
 ******************************************************************************/
kdecombo CTE_CAREER_PERKINS, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/ctePerkins.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - College & Career Readiness	 	   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_CCR, sheets(`"`"Delivery Target CCR"' `"Delivery Target CCR"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/targetCCR.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Graduation Rate Data	  		   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_GRADUATION_RATE_COHORT, sheets(`"`"Delivery Target Cohort Data"' `"Sheet 1"' `"Sheet 1"'"') y(2013 2014 2015)
qui: save clean/targetGradRate.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Proficiency Gap Data		 	   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_PROFICIENCY_GAP, sheets(`"`"Delivery Target ProficiencyGap"' `"Delivery Target Proficiency Gap"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/targetProfGap.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Kindergarten Readiness Screening   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_KSCREEN, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/targetKScreen.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - Program Review					   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/targetProgramReview.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Student-Teacher Data	   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_STUDENTS-TEACHERS, sheets(`"`"Sheet1"' `"Sheet1"' `"Student-Teacher Detail"' `"Student-Teacher Detail"'"') y(2012 2013 2014 2015)
qui: save clean/envStudentTeacher.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Teaching Methods Data			   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_TEACHING_METHODS, sheets(`"`"TEACHING METHODS"' `"Sheet 1"' `"Sheet 1"'"') y(2013 2014 2015)
qui: save clean/envTeachingMethods.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Safety Data					   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_SAFETY, sheets(`"`"Safety Data"' `"Safety Data"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/safety.dta, replace

/*******************************************************************************
 * Accountability System Program Review	Data								   *
 ******************************************************************************/
kdecombo PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
qui: save clean/programReview.dta, replace

/*******************************************************************************
 * Accountability System Participation Rates								   *
 ******************************************************************************/
tempfile part12 part13
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
qui: save `part12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
qui: save `part13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_PARTICIPATION_RATE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `part12'.dta
append using `part13'.dta
save clean/participationRates.dta, replace

/*******************************************************************************
 * Accountability System Daily Attendance Rates								   *
 ******************************************************************************/
tempfile oth12 oth13
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
qui: save `oth12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"')
qui: ds, not(type string)
qui: tostring `r(varlist)', replace
qui: save `oth13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_ATTENDANCE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `oth12'.dta
append using `oth13'.dta
save clean/amoOtherIndicators.dta, replace

