/*******************************************************************************
 * Accountability System School Profiles                                       *
 ******************************************************************************/

// Combines all of the accountability profile files/worksheets
kdecombo ACCOUNTABILITY_PROFILE, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Profile Data"' `"ACCOUNTABILITY PROFILE"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')

// Standardizes variable names and value labels
kdestandardize, primarykey(fileid schyr schid level) m(classification reward ///   
baseline overall rank amogain amogoal amomet nextpartic gradgoal)

// Saves the cleaned file
qui: save clean/acctProfile.dta, replace

/*******************************************************************************
 * Accountability System Summary                                               *
 ******************************************************************************/

// Combines all of the accountability summary files/worksheets
kdecombo ACCOUNTABILITY_SUMMARY, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Summary Data"' `"ACCOUNTABILITY SUMMARY"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')

// Standardizes variable names and value labels
kdestandardize, primarykey(fileid schyr schid level) m(achievepts achievesc  ///   
gappts gapsc growthpts growthsc ccrpts ccrsc gradpts gradsc wgtsum cwgtngl 	 ///   
ctotalpr cwgtpr coverall ptotal pwgtngl ptotalpr pwgtpr poverall)

qui: save clean/acctSummary.dta, replace


/*******************************************************************************
 * Accountability System ACT data											   *
 ******************************************************************************/

// Combines all of the ACT files/worksheets
kdecombo ASSESSMENT_ACT, y(2012 2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Public Schools"' `"Public Alternative Programs"' `"ACT Data"' "'  ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actcmpsc bnchmrktested) grade(99)

qui: save clean/assessACT.dta, replace

/*******************************************************************************
 * Accountability System Explore data										   *
 ******************************************************************************/

// Combines all of the ACT EXPLORE files/worksheets
kdecombo ASSESSMENT_EXPLORE, y(2012 2012 2013 2014 2015)	 				 ///   
sheets(`"`"Public Alternate Programs"' `"Public Schools"' `"EXPLORE Data"'"' ///   
`" `"Sheet 1"' `"Sheet 1"'"') 

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actscipct actcmpsc bnchmrktested) grade(100)

qui: save clean/assessExplore.dta, replace

/*******************************************************************************
 * Accountability System Plan data	   *
 ******************************************************************************/

// Combines all of the ACT PLAN files/worksheets
kdecombo ASSESSMENT_PLAN, y(2012 2012 2013 2014 2015)						 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' `"PLAN Data"' "' ///   
`"`"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actscipct actcmpsc bnchmrktested) grade(100) 

qui: save clean/assessPlan.dta, replace

/*******************************************************************************
 * Accountability System KPREP End of Course Assessment Data				   *
 ******************************************************************************/

// Combines all of the KPREP End of Course Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_EOC, y(2012 2012 2013 2014 2015 2016)				 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP-EOC"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(fileid testnm schyr schid content grade amogroup) ///   
m(tested membership partic novice apprentice proficient distinguished) grade(99) 

qui: save clean/assessEOC.dta, replace

/*******************************************************************************
 * Accountability System KPREP Grade Level Assessment Data					   *
 ******************************************************************************/

// Combines all of the KPREP Grade Level Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_GRADE, y(2012 2012 2013 2014 2015 2016)			 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "' 				 ///   
`"`"Assessment KPREP Grades"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(fileid testnm schyr schid level content grade 	 ///   
amogroup) m(tested membership partic novice apprentice proficient distinguished) 

qui: save clean/assessKPREPgr.dta, replace

/*******************************************************************************
 * Accountability System KPREP Educational Level Assessment Data			   *
 ******************************************************************************/

// Combines all of the KPREP Educational Level Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_LEVEL, y(2012 2012 2013 2014 2015 2016)			 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP Level"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(fileid testnm schyr schid level content amogroup  ///   
grade) m(tested membership partic novice apprentice proficient 				 ///   
distinguished) grade(100)

qui: save clean/assessKPREPlevel.dta, replace

qui: append using clean/assessEOC.dta
qui: append using clean/assessKPREPgr.dta
qui: save clean/kprep.dta, replace

/*******************************************************************************
 * Accountability System NRT Assessment Data	   *
 ******************************************************************************/

kdecombo ASSESSMENT_NRT, y(2012 2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' `"SAT-NRT"' "'	 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  

kdestandardize, primarykey(fileid testnm schyr schid grade) 				 ///   
m(rlapctile mthpctile scipctile socpctile lanpctile)

qui: save clean/assessNRT.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - College/Career Readiness Data   *
 ******************************************************************************/
kdecombo CTE_CAREER_CCR, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)

kdestandardize, primarykey(fileid schyr schid grade) m(totenrsrs prepenrsrs  ///   
collrdy actwrkkeys asvab industrycert kossa carrdy ccrn ccrpct) grade(99)

qui: save clean/cteCCR.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Career Pathways Data	   *
 ******************************************************************************/
kdecombo CTE_CAREER_PATHWAYS,  y(2014 2015 2016)							 ///   
sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')

kdestandardize, primarykey(fileid schyr schid grade ctepath) m(membership 	 ///   
ncert) grade(99)

qui: save clean/ctePathway.dta, replace

/*******************************************************************************
 * Accountability System Career/Technical Ed - Perkins Program Data			   *
 ******************************************************************************/
kdecombo CTE_CAREER_PERKINS, sheets(`"`"Sheet 1"' `"Sheet 1"'"') y(2014 2015)

kdestandardize, primarykey(fileid schyr schid prknsmeasure) m(membership 	 ///   
bnchmrkprkns prknsgoal)

qui: save clean/ctePerkins.dta, replace

/*******************************************************************************
 * Accountability System Delivery Targets - College & Career Readiness	 	   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_CCR, y(2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Delivery Target CCR"' `"Delivery Target CCR"' `"Sheet 1"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"'"') 

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
kdecombo LEARNING_ENVIRONMENT_STUDENTS-TEACHERS, y(2012 2013 2014 2015 2016) ///   
sheets(`"`"Sheet1"' `"Sheet1"' `"Student-Teacher Detail"' "'				 ///   
`"`"Student-Teacher Detail"' `"Student - Teacher Detail"'"')

kdestandardize, primarykey(fileid schyr schid grade) m(membership ppe ada 	 ///   
adarate nfemale nmale naian naianf naianm nasian nasianf nasianm nblack 	 ///   
nblackf nblackm nhisp nhispf nhispm nmulti nmultif nmultim npacisl npacislf  ///   
npacislm nwhite nwhitef nwhitem nfrl nfreelnch nredlnch ncollege nincollege  ///   
noutcollege nfailure nmilitary nparttime nvocational nworkforce 			 ///   
councilparent ptconf sbdmvote volunteertime nnbct nfte femalefte malefte 	 ///   
tchexp stdcompratio stdtchratio droprate gradrate retrate pctfemale pctmale  ///   
pctaian pctasian pctblack pcthisp pctmulti pctpacisl pctwhite pctfrl 		 ///   
pctfreelnch pctredlnch pctcollege pctincollege pctoutcollege pctfailure 	 ///   
pctmilitary pctparttime pctvocational pctworkforce pctdr pctnothq pctoldcomp ///   
pctprovcert pctqualba pctqualma pctqualrank1 pctqualspecialist pctqualtch)

drop if mi(membership)

qui: save clean/envStudentTeacher.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Teaching Methods Data			   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_TEACHING_METHODS, y(2013 2014 2015 2016) 		 ///   
sheets(`"`"TEACHING METHODS"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 


qui: save clean/envTeachingMethods.dta, replace

/*******************************************************************************
 * Accountability System Learning Environment Safety Data					   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_SAFETY, sheets(`"`"Safety Data"' `"Safety Data"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015)
qui: save clean/safety.dta, replace

/*******************************************************************************
 * Accountability System School Profiles									   *
 ******************************************************************************/

kdecombo PROFILE, y(2012 2013 2014 2015 2016) 								 ///   
sheets(`"`"School District Profile Data"' `"School District Profile Data"'"' ///   
`" `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 
qui: replace membership = enrollment if mi(membership) & !mi(enrollment)
qui: drop enrollment

kdestandardize, primarykey(fileid schyr schid) m(cntyid coopid leaid distid  ///   
ncesid cntynm coop distnm schnm schtype title1 mingrade maxgrade membership  ///   
poc addy addy2 pobox city state zip phone fax lat lon)


/*******************************************************************************
 * Accountability System Program Review	Data								   *
 ******************************************************************************/
kdecombo PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 	 ///   
y(2014 2015 2016)

kdestandardize, primarykey(fileid schyr schid level) m(totpts totscore ahcia ///   
ahassess ahprofdev ahadmin ahtotpts ahlev k3cia k3assess k3profdev k3admin	 ///   
k3totpts k3lev plcia plassess plprofdev pladmin pltotpts pllev wlcia 		 ///   
wlassess wlprofdev wladmin wltotpts wllev wrcia wrassess wrprofdev wradmin 	 ///   
wrtotpts wrlev)

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

