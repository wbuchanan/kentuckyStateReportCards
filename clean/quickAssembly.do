/*******************************************************************************
 * Accountability System School Profiles                                       *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_PROFILE, sheets(`"`"Accountability Profile Data"' `"ACCOUNTABILITY PROFILE"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)

// Standardize variable names and value labels
kdestandardize, dropv(category next_yr_score *_py sch_type state_sch_id		 ///   
trend_display) schyrl(2) primaryk(schyr schid level grade)

// Sets the display order (e.g., column order) of the variables
order schyr schid distid schnum cntyid cntynm ncesid coop coopid distnm schnm ///   
overall rank classification reward baseline amogain amogoal amomet nextpartic ///   
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
import excel using raw/2012/ASSESSMENT_ACT.xlsx, first case(lower) clear sheet(`"Public Schools"') allstring
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
import excel using raw/2012/ASSESSMENT_EXPLORE.xlsx, first case(lower) clear sheet(`"Public Alternate Programs"') allstring
tempfile explore
qui: save `explore'.dta, replace
kdecombo ASSESSMENT_EXPLORE, sheets(`"`"Public Schools"' `"EXPLORE Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `explore'.dta
qui: save clean/assessExplore.dta, replace

/*******************************************************************************
 * Accountability System Plan data	   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_PLAN.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
tempfile plan
qui: save `plan'.dta, replace
kdecombo ASSESSMENT_PLAN, sheets(`"`"Public Schools"' `"PLAN Data"' `"Sheet 1"' `"Sheet 1"'"')  y(2012 2013 2014 2015)
append using `plan'.dta
qui: save clean/assessPlan.dta, replace

/*******************************************************************************
 * Accountability System KPREP End of Course Assessment Data				   *
 ******************************************************************************/
import excel using raw/2012/ASSESSMENT_KPREP_EOC.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
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
import excel using raw/2012/ASSESSMENT_KPREP_GRADE.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
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
import excel using raw/2012/ASSESSMENT_KPREP_LEVEL.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
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
import excel using raw/2012/ASSESSMENT_NRT.xlsx, first case(lower) clear sheet(`"Public Alternative Programs"') allstring
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
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"') allstring
qui: save `part12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Participation Rate"') allstring
qui: save `part13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_PARTICIPATION_RATE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `part12'.dta
append using `part13'.dta
save clean/participationRates.dta, replace

/*******************************************************************************
 * Accountability System Daily Attendance Rates								   *
 ******************************************************************************/
tempfile oth12 oth13
import excel using raw/2012/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"') allstring
qui: save `oth12'.dta, replace
import excel using raw/2013/ACCOUNTABILITY_FEDERAL_DATA.xlsx, first case(lower) clear sheet(`"Other Indicators"') allstring
qui: save `oth13'.dta, replace
kdecombo ACCOUNTABILITY_FEDERAL_DATA_ATTENDANCE, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)
append using `oth12'.dta
append using `oth13'.dta
save clean/amoOtherIndicators.dta, replace

