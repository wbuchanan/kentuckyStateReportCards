profiler on

/*******************************************************************************
 * Accountability GAP Level				                                       *
 ******************************************************************************/

// Combines all of the accountability profile files/worksheets
kdecombo ACCOUNTABILITY_GAP_LEVEL, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Gap Level Data"' `"ACCOUNTABILITY GAP LEVEL"' "'	 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid content level) m(tested novice ///   
apprentice proficient distinguished profdist napd)

qui: save newclean/acctGapLevel.dta, replace

/*******************************************************************************
 * Accountability GAP Summary			                                       *
 ******************************************************************************/

kdecombo ACCOUNTABILITY_GAP_SUMMARY, y(2012 2013 2014 2015 2016)			 ///   
sheets(`"`"Accountability Gap Summary Data"' `"GAP Summary"' `"Sheet 1"'"'   ///   
`"`"Sheet 1"' `"Sheet 1"'"')												 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level ptype accttype) m(rlagap ///   
mthgap scigap socgap wrtgap langap totpts ndg nr)

qui: save newclean/acctGapSummary.dta, replace

/*******************************************************************************
 * Accountability Growth				                                       *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_GROWTH, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Growth Data"' `"ACCOUNTABILITY GROWTH"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level) m(sgptested sgprla 	 ///   
sgpmth sgpboth cattested catrla catmth catboth)

qui: save newclean/acctGrowth.dta, replace

/*******************************************************************************
 * Accountability Novice Reduction		                                       *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_NOVICE_REDUCTION, y(2016) sheets(`"`"Sheet 1"'"')	 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level content amogroup) 		 ///   
m(pnovicepct pynovicetarget cnovicepct cnovicemet pctmet contentpts nrpts)

qui: save newclean/acctNoviceReduction.dta, replace

/*******************************************************************************
 * Accountability HS College/Career Ready                                      *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_CCR_HIGHSCHOOL, y(2012 2013 2014 2015 2016) 		 ///   
sheets(`"`"Accountability CCR High School"' "'								 ///   
`"`"Accountability CCR High School"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')	 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid testnm amogroup) m(diplomas 	 ///   
collready caracad cartech cartot nccr pctwobonus pctwbonus)

qui: save newclean/ccrHighSchool.dta, replace

/*******************************************************************************
 * Accountability MS College/Career Ready                                      *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_CCR_MIDDLESCHOOL, y(2012 2013 2014 2015) 			 ///   
sheets(`"`"Accountability CCR Explore"' `"ACCOUNTABILITY CCR EXPLORE MS"' "' ///   
`"`"Sheet 1"' `"Sheet 1"'"')												 ///   
r(/Users/billy/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid testnm amogroup) m(tested 	 ///   
totpts actengpct actrlapct actmthpct actscipct)

qui: save newclean/ccrMiddleSchool.dta, replace

/*******************************************************************************
 * Accountability Grade Level Achievement	                                   *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_ACHIEVEMENT_GRADE, y(2012 2013 2014 2015 2016)		 ///   
sheets(`"`"Acct Achievement Grade Data"' `"ACCT ACHIEVEMENT GRADE"' "'		 ///   
`"`"Sheet1"' `"Sheet1"' `"Sheet 1"'"')										 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level grade content amogroup)	 ///   
m(tested novice apprentice proficient distinguished profdist napd napdbonus)

qui: save newclean/acctAchievementGrade.dta, replace

/*******************************************************************************
 * Accountability Educational Level Achievement	                               *
 ******************************************************************************/
kdecombo ACCOUNTABILITY_ACHIEVEMENT_LEVEL, y(2012 2013 2014 2015 2016)		 ///   
sheets(`"`"Acct Achievement Level Data"' `"ACCT Achievement Level"' "'		 ///   
`"`"Sheet1"' `"Sheet1"' `"Sheet 1"'"')										 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level content amogroup)		 ///   
m(tested novice apprentice proficient distinguished profdist napd napdbonus)

qui: save newclean/acctAchievementLevel.dta, replace

/*******************************************************************************
 * Accountability System - Accountability Profiles                             *
 ******************************************************************************/

// Combines all of the accountability profile files/worksheets
kdecombo ACCOUNTABILITY_PROFILE, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Profile Data"' `"ACCOUNTABILITY PROFILE"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

// Standardizes variable names and value labels
kdestandardize, primarykey(fileid schyr schid level) m(classification reward ///   
baseline overall rank amogain amogoal amomet nextpartic gradgoal)

// Saves the cleaned file
qui: save newclean/acctProfile.dta, replace

/*******************************************************************************
 * Accountability System Summary                                               *
 ******************************************************************************/

// Combines all of the accountability summary files/worksheets
kdecombo ACCOUNTABILITY_SUMMARY, y(2012 2013 2014 2015 2016) 				 ///   
sheets(`"`"Accountability Summary Data"' `"ACCOUNTABILITY SUMMARY"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

// Standardizes variable names and value labels
kdestandardize, primarykey(fileid schyr schid level) m(achievepts achievesc  ///   
gappts gapsc growthpts growthsc ccrpts ccrsc gradpts gradsc wgtsum cwgtngl 	 ///   
ctotalpr cwgtpr coverall ptotal pwgtngl ptotalpr pwgtpr poverall)

qui: save newclean/acctSummary.dta, replace

/*******************************************************************************
 * Assessment Data - ACT													   *
 ******************************************************************************/

// Combines all of the ACT files/worksheets
kdecombo ASSESSMENT_ACT, y(2012 2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Public Schools"' `"Public Alternative Programs"' `"ACT Data"' "'  ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actcmpsc bnchmrktested) grade(99)

qui: save newclean/assessACT.dta, replace

/*******************************************************************************
 * Assessment Data - Advanced Placement										   *
 ******************************************************************************/

kdecombo ASSESSMENT_ADVANCE_PLACEMENT, y(2013 2014 2015 2016) 				 ///   
sheets(`"`"ADVANCE PLACEMENT Data"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')	 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

drop disagg_order

kdestandardize, primarykey(fileid schyr schid amogroup) m(ntested pcttested  ///   
nexams ncredit pctcredit)

qui: save newclean/assessAP.dta, replace

/*******************************************************************************
 * Assessment Data - ACT Explore											   *
 ******************************************************************************/

// Combines all of the ACT EXPLORE files/worksheets
kdecombo ASSESSMENT_EXPLORE, y(2012 2012 2013 2014 2015)	 				 ///   
sheets(`"`"Public Alternate Programs"' `"Public Schools"' `"EXPLORE Data"'"' ///   
`" `"Sheet 1"' `"Sheet 1"'"') 												 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actscipct actcmpsc bnchmrktested) grade(100)

qui: save newclean/assessExplore.dta, replace

/*******************************************************************************
 * Assessment Data - ACT Plan												   *
 ******************************************************************************/

// Combines all of the ACT PLAN files/worksheets
kdecombo ASSESSMENT_PLAN, y(2012 2012 2013 2014 2015)						 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' `"PLAN Data"' "' ///   
`"`"Sheet 1"' `"Sheet 1"'"')  												 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid grade amogroup) 		 ///   
m(tested actengsc actengpct actmthsc actmthpct actrlasc actrlapct actscisc 	 ///   
actscipct actcmpsc bnchmrktested) grade(100) 

qui: save newclean/assessPlan.dta, replace

/*******************************************************************************
 * Assessment Data - KPREP End of Course Exams								   *
 ******************************************************************************/

// Combines all of the KPREP End of Course Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_EOC, y(2012 2012 2013 2014 2015 2016)				 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP-EOC"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  			 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid content grade amogroup) ///   
m(tested membership partic novice apprentice proficient distinguished) grade(99) 

qui: save newclean/assessEOC.dta, replace

/*******************************************************************************
 * Assessment Data - KPREP Grade Level Exams								   *
 ******************************************************************************/

// Combines all of the KPREP Grade Level Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_GRADE, y(2012 2012 2013 2014 2015 2016)			 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "' 				 ///   
`"`"Assessment KPREP Grades"' `"Sheet1"' `"Sheet1"' `"Sheet 1"'"')  		 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid level content grade 	 ///   
amogroup) m(tested membership partic novice apprentice proficient distinguished) 

qui: save newclean/assessKPREPgr.dta, replace

/*******************************************************************************
 * Assessment Data - KPREP Educational Level Exam Results					   *
 ******************************************************************************/

// Combines all of the KPREP Educational Level Assessment files/worksheets
kdecombo ASSESSMENT_KPREP_LEVEL, y(2012 2012 2013 2014 2015 2016)			 ///    
sheets(`"`"Public Alternative Programs"' `"Public Schools"' "'				 ///   
`"`"Assessment KPREP Level"' `"Sheet1"' `"Sheet1"' `"Sheet 1"'"')  			 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid level content amogroup  ///   
grade) m(tested membership partic novice apprentice proficient 				 ///   
distinguished) grade(100)

qui: save newclean/assessKPREPlevel.dta, replace

qui: append using clean/assessEOC.dta
qui: append using clean/assessKPREPgr.dta
qui: save newclean/assessKPREP.dta, replace

/*******************************************************************************
 * Assessment Data - Kindergarten Readiness Screening Data					   *
 ******************************************************************************/

kdecombo ASSESSMENT_KSCREEN, y(2014 2015 2016) sheets(`"`"Sheet 1"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"'"')  												 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid kstype amogroup) m(cndenr 	 ///   
cndtested cndpartic shseenr shsetested shsepartic knotready kready cogblw 	 ///   
cogavg cogabv lanblw lanavg lanabv phyblw phyavg phyabv slfblw slfavg slfabv ///   
selblw selavg selabv)

qui: save newclean/assessKscreen.dta, replace

/*******************************************************************************
 * Assessment Data - Novice Reduction Testing ???							   *
 ******************************************************************************/

kdecombo ASSESSMENT_NRT, y(2012 2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Public Alternative Programs"' `"Public Schools"' `"SAT-NRT"' "'	 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')  									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid testnm schyr schid grade) 				 ///   
m(rlapctile mthpctile scipctile socpctile lanpctile)

qui: save newclean/assessNRT.dta, replace

/*******************************************************************************
 * Career/Technical Ed - College/Career Readiness Data  					   *
 ******************************************************************************/
kdecombo CTE_CAREER_CCR, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 	 ///   
y(2014 2015 2016) r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid grade) m(totenrsrs prepenrsrs  ///   
collready actwrkkeys asvab industrycert kossa cartot nccr pctccr) grade(99)

qui: save newclean/cteCCR.dta, replace

/*******************************************************************************
 * Career/Technical Ed - Career Pathways Data	 							   *
 ******************************************************************************/
kdecombo CTE_CAREER_PATHWAYS,  y(2014 2015 2016)							 ///   
sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')								 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid grade ctepath) m(membership 	 ///   
ncert) grade(99)

qui: save newclean/ctePathway.dta, replace

/*******************************************************************************
 * Career/Technical Ed - Perkins Program Data			 					   *
 ******************************************************************************/
kdecombo CTE_CAREER_PERKINS, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') ///   
y(2014 2015 2016) r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid prknsmeasure) m(membership 	 ///   
bnchmrkprkns prknsgoal)

qui: save newclean/ctePerkins.dta, replace

/*******************************************************************************
 * Delivery Targets - College & Career Readiness	 						   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_CCR, y(2012 2013 2014 2015 2016)					 ///   
sheets(`"`"Delivery Target CCR"' `"Delivery Target CCR"' `"Sheet 1"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"'"') 												 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schid schyr targetyr) m(met pctactual 	 ///   
pctdelivery)

qui: save newclean/targetCCR.dta, replace

/*******************************************************************************
 * Delivery Targets - Graduation Rate Data	  								   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_GRADUATION_RATE_COHORT, y(2013 2014 2015 2016) 	 ///   
sheets(`"`"Delivery Target Cohort Data"' `"Sheet 1"' `"Sheet 1"' "'			 ///   
`"`"Sheet 1"'"') r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid target targettype amogroup)  	 ///   
m(cohort2013 cohort2014 cohort2015 cohort2016 cohort2017 cohort2018 		 ///   
cohort2019 cohort2020)

qui: save newclean/targetGradRate.dta, replace

/*******************************************************************************
 * Delivery Targets - Proficiency Gap Data		 							   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_PROFICIENCY_GAP, y(2012 2013 2014 2015 2016) 		 ///   
sheets(`"`"Delivery Target ProficiencyGap"' "'								 ///   
`"`"Delivery Target Proficiency Gap"' `"Sheet1"' `"Sheet1"' `"Sheet 1"'"')   ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

drop target_type dist_name sch_name category cntyno cntyname dist_number 	 ///   
sch_number state_sch_id ncesid coop coop_code

kdestandardize, primarykey(fileid schyr schid content level target amogroup) ///   
m(yr2012 yr2013 yr2014 yr2015 yr2016 yr2017 yr2018 yr2019)

qui: save newclean/targetProfGap.dta, replace

/*******************************************************************************
 * Financial Data		 													   *
 ******************************************************************************/
kdecombo FINANCE, y(2014 2014 2014 2015 2016) sheets(`"`"2011-2012"' "'		 ///   
`"`"2012-2013"' `"2013-2014"' `"Sheet 1"' `"Sheet 1"'"')					 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid fintype finlabel) m(finvalue finrank)

qui: encode finlabel, gen(x)
drop finlabel
mata: vals = J(0, 0, .)
mata: labs = J(0, 0, "")
mata: st_vlload("x", vals, labs)

reshape wide finvalue finrank, i(fileid schyr schid fintype) j(x)

mata:
for (i = 1; i <= 58; i++) {
	st_varlabel("finvalue" + strofreal(i), "$ for " + labs[i, 1])
	st_varlabel("finrank" + strofreal(i), "Rank for " + labs[i, 1])
}
end
foreach v of var finvalue* {
	qui: replace `v' = cond(`v' == "Yes", "1", cond(`v' == "No", "0", `v'))
	qui: destring `v', replace ignore ("*,R %$")
}

loc chngs ReS_Xij_n ReS_Xij_long1 ReS_Xij_long2 ReS_Xij_wide1 ReS_Xij_wide2 ///   
ReS_i ReS_ver ReS_j ReS_str ReS_Xij __JValLabName __JValLab __JVarLab ///   
__XijVarLabfinvalue __XijVarLabfinrank
foreach v of loc chngs {
	char _dta[`v'] ""
}
char li

char _dta[primaryKey] "schyr, schid, fintype"
qui: ds
sqltypes `r(varlist)', tab(finance)

qui: save newclean/finance.dta, replace

/*******************************************************************************
 * Delivery Targets - Kindergarten Readiness Screening  					   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_KSCREEN, y(2014 2015 2016) 						 ///   
sheets(`"`"Sheet1"' `"Sheet1"' `"Sheet1"'"')								 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid kstype target amogroup)		 ///   
m(kscreen2013 kscreen2014 kscreen2015 kscreen2016 kscreen2017 kscreen2018)

qui: save newclean/targetKScreen.dta, replace

/*******************************************************************************
 * Delivery Targets - Program Review										   *
 ******************************************************************************/
kdecombo DELIVERY_TARGET_PROGRAM_REVIEW, y(2014 2015 2016) 					 ///   
sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')								 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid targetyr) m(met nactual 		 ///   
ndelivery pctactual pctdelivery)

qui: save newclean/targetProgramReview.dta, replace

/*******************************************************************************
 * Learning Environment - Student-Teacher Data	  							   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_STUDENTS-TEACHERS, y(2012 2013 2014 2015 2016) ///   
sheets(`"`"Sheet1"' `"Sheet1"' `"Student-Teacher Detail"' "'				 ///   
`"`"Student - Teacher Detail"' `"Student-Teacher Detail"'"')				 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

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

qui: save newclean/envStudentTeacher.dta, replace

/*******************************************************************************
 * Learning Environment - Teaching Methods Data	  							   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_TEACHING_METHODS, y(2013 2014 2015 2016) 		 ///   
sheets(`"`"TEACHING METHODS"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 		 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid pedagogy) m(nonsitecls 		 ///   
noffsitecte noffsitecol nhomehosp nonline)

qui: save newclean/envTeachingMethods.dta, replace

/*******************************************************************************
 * Learning Environment - Safety Data			  							   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_SAFETY, y(2012 2013 2014 2015 2016) 			 ///   
sheets(`"`"Safety Data"' `"Safety Data"' `"Sheet 1"' `"Sheet 1"' "'			 ///   
`"`"Sheet 1"'"') r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid rpthdr rptln) m(membership	 ///   
totevents nfemale nmale naian nasian nblack nhisp nmulti npacisl nwhite)

qui: save newclean/envSafety.dta, replace

/*******************************************************************************
 * Learning Environment - Special Programs Data	  							   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_PROGRAMS, y(2013 2013 2013 2013 2014 2014 2014 ///   
2014 2015 2015 2015 2015 2016 2016 2016 2016 2016)							 ///   
sheets(`"`"Gifted and Talented"' `"Migrant"' "'								 ///   
`"`"English Language Learners (ELL)"' `"Special Education"' `"Gifted"' "' 	 ///   
`"`"Migrant"' `"ELL"' `"Special Ed"' `"Gifted"' `"Migrant"' `"ELL"' "' 		 ///   
`"`"Special Ed"' `"EL"' `"Gifted & Talented"' `"Homeless"' `"Migrant"' "'	 ///   
`"`"Special_Education"'"') r(~/Desktop/kentuckyStateReportCards/newdl)

rename disagg_label program_label
kdestandardize, primarykey(fileid schyr schid progtype proggroup) m(membership totpct)

qui: save newclean/envPrograms.dta, replace

/*******************************************************************************
 * School Profile Data														   *
 ******************************************************************************/

kdecombo PROFILE, y(2012 2013 2014 2015 2016) 								 ///   
sheets(`"`"School District Profile Data"' `"School District Profile Data"'"' ///   
`" `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

qui: replace membership = enrollment if mi(membership) & !mi(enrollment)
qui: drop enrollment

kdestandardize, primarykey(fileid schyr schid) m(cntyid coopid leaid distid  ///   
ncesid cntynm coop distnm schnm schtype title1 mingrade maxgrade membership  ///   
poc addy addy2 pobox city state zip phone fax lat lon)

qui: save newclean/profile.dta, replace

/*******************************************************************************
 * Program Review Data														   *
 ******************************************************************************/
kdecombo PROGRAM_REVIEW, sheets(`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') 	 ///   
y(2014 2015 2016) r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid level) m(totpts totscore ahcia ///   
ahassess ahprofdev ahadmin ahtotpts ahlev k3cia k3assess k3profdev k3admin	 ///   
k3totpts k3lev plcia plassess plprofdev pladmin pltotpts pllev wlcia 		 ///   
wlassess wlprofdev wladmin wltotpts wllev wrcia wrassess wrprofdev wradmin 	 ///   
wrtotpts wrlev)

qui: save newclean/programReview.dta, replace

/*******************************************************************************
 * Accountability System - Participation Rates								   *
 ******************************************************************************/

// Created soft dynamic links to ACCOUNTABILITY_FEDERAL_DATA to map to the same
// file name used below for the 2012 and 2013 school years
kdecombo ACCOUNTABILITY_FEDERAL_DATA_PARTICIPATION_RATE,  y(2012 2013 2014 	 ///   
2015 2016) sheets(`"`"Participation Rate"' `"Participation Rate"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"')									 ///   
r(~/Desktop/kentuckyStateReportCards/newdl)

qui: replace disagg_label = "Gap Group (non-duplicated)" if disagg_label == "GAP"
qui: replace disagg_order = "17" if disagg_label == "Gap Group (non-duplicated)"

kdestandardize, primarykey(fileid schyr schid amogroup) m(membership tested  ///   
partic metpartic)

qui: save newclean/acctParticipation.dta, replace

/*******************************************************************************
 * Accountability System - Daily Attendance Rates							   *
 ******************************************************************************/

 // Created soft dynamic links to ACCOUNTABILITY_FEDERAL_DATA to map to the same
// file name used below for the 2012 and 2013 school years
kdecombo ACCOUNTABILITY_FEDERAL_DATA_ATTENDANCE,  y(2012 2013 2014 2015 	 ///   
2016) sheets(`"`"Other Indicators"' `"Other Indicators"' `"Sheet 1"' "'		 ///   
`"`"Sheet 1"' `"Sheet 1"'"') r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid) m(adarate adagoal othamo)

qui: save newclean/acctAttendance.dta, replace

/*******************************************************************************
 * Learning Environment - Equity Data	  									   *
 ******************************************************************************/
kdecombo LEARNING_ENVIRONMENT_EQUITY, y(2015 2016) sheets(`"`"Sheet 1"'"' 	 ///   
`" `"Sheet 1"'"') r(~/Desktop/kentuckyStateReportCards/newdl)

kdestandardize, primarykey(fileid schyr schid) m(effectivestaff staffsgp 	 ///   
pctchurn csnicomp stdconduct ldrship pctnewtch)

qui: save newclean/envEquity.dta, replace

profiler report
profiler clear
