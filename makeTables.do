loc cover keepus(distnm schnm schtype title1 mingrade maxgrade poc)
loc grinfo keepus(distnm schnm)
loc join qui: merge m:1 schid schyr using newclean/profile.dta, nogen keep(3)
loc getfcps qui: keep if inlist(substr(schid, 1, 3), "165", "999")
loc root /Users/billy/Desktop/kentuckyStateReportCards/updates	

qui: use newclean/profile.dta, clear
`getfcps'
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	cap confirm new file `"`root'/`v'"'
	if _rc == 0 {
		mkdir `"`root'/`v'"'
	}	
	qui: export excel using `"`root'/`v'/reportCardData.xlsx"' if 			 ///   
	schnm == `"`v'"', replace sh("School Profile") firstrow(varl)
}
	
qui: use newclean/acctSummary.dta, clear
`join' `grinfo'
`getfcps'

loc expvars schyr level achievepts achievesc gappts gapsc growthpts growthsc ///   
ccrpts ccrsc gradpts gradsc wgtsum cwgtngl ctotalpr cwgtpr coverall ptotal 	 ///   
pwgtngl ptotalpr pwgtpr poverall

sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Summary")
}

qui: use newclean/acctProfile.dta, clear
`join' `grinfo'
`getfcps'

loc expvars schyr level classification reward baseline overall rank amogain  ///   
amogoal amomet nextpartic gradgoal
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Profile")
}

qui: use newclean/acctGapSummary.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level ptype accttype rlagap mthgap scigap socgap wrtgap 	 ///   
langap totpts ndg nr
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("GAP Summary")
}


qui: use newclean/acctGrowth.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level sgptested sgprla sgpmth sgpboth cattested catrla 	 ///   
catmth catboth
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Growth")
}

qui: use newclean/acctNoviceReduction.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level content amogroup pnovicepct pynovicetarget cnovicepct ///   
cnovicemet pctmet contentpts nrpts
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Novice Reduction")
}

qui: use newclean/ccrHighSchool.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr testnm amogroup diplomas collready caracad cartech cartot	 ///   
nccr pctwobonus pctwbonus
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("HS CCR")
}


qui: use newclean/ccrMiddleSchool.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr testnm amogroup tested totpts actengpct actrlapct actmthpct ///   
actscipct
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("MS CCR")
}


qui: use newclean/acctAchievementGrade.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level grade content amogroup tested novice apprentice 	 ///   
proficient distinguished profdist napd napdbonus
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Achievement Grade")
}


qui: use newclean/acctAchievementLevel.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level content amogroup tested novice apprentice proficient ///   
distinguished profdist napd napdbonus
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Achievement Level")
}


qui: use newclean/acctParticipation.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr amogroup membership tested partic metpartic
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Participation Rates")
}


qui: use newclean/acctAttendance.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr adarate adagoal othamo
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Attendance")
}

qui: use newclean/programReview.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr level totpts totscore ahcia ahassess ahprofdev ahadmin 	 ///   
ahtotpts ahlev k3cia k3assess k3profdev k3admin k3totpts k3lev plcia 		 ///   
plassess plprofdev pladmin pltotpts pllev wlcia wlassess wlprofdev wladmin 	 ///   
wltotpts wllev wrcia wrassess wrprofdev wradmin wrtotpts wrlev
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Program Review")
}


qui: use newclean/assessACT.dta, clear
`join' `grinfo'
`getfcps'
loc expvars testnm schyr schid grade amogroup tested actengsc actengpct 	 ///   
actmthsc actmthpct actrlasc actrlapct actscisc actcmpsc bnchmrktested
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("ACT")
}

qui: use newclean/assessAP.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr schid amogroup ntested pcttested nexams ncredit pctcredit
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Advanced Placement")
}

qui: use newclean/assessKPREP.dta, clear
`join' `grinfo'
`getfcps'
loc expvars testnm schyr level content amogroup grade tested membership 	 ///   
partic novice apprentice proficient distinguished
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("KPREP")
}

qui: use newclean/assessKscreen.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr kstype amogroup cndenr cndtested cndpartic shseenr 		 ///   
shsetested shsepartic knotready kready cogblw cogavg cogabv lanblw lanavg 	 ///   
lanabv phyblw phyavg phyabv slfblw slfavg slfabv selblw selavg selabv
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("K Readiness")
}

qui: use newclean/assessNRT.dta, clear
`join' `grinfo'
`getfcps'
loc expvars testnm schyr grade rlapctile mthpctile scipctile socpctile lanpctile
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("NRT")
}

qui: use newclean/cteCCR.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr grade totenrsrs prepenrsrs collready actwrkkeys asvab 	 ///   
industrycert kossa cartot nccr pctccr
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("CTE CCR")
}

qui: use newclean/ctePathway.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr grade ctepath membership ncert
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("CTE Career Pathways")
}

qui: use newclean/targetCCR.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schid targetyr met pctactual pctdelivery
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Targets CCR")
}

qui: use newclean/targetGradRate.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr target targettype amogroup cohort2013 cohort2014 			 ///   
cohort2015 cohort2016 cohort2017 cohort2018 cohort2019 cohort2020
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Targets Grad Rates")
}

qui: use newclean/targetProfGap.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr content level target amogroup yr2012 yr2013 yr2014 yr2015  ///   
yr2016 yr2017 yr2018 yr2019
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Targets Proficiency Gap")
}

qui: use newclean/targetKScreen.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr kstype target amogroup kscreen2013 kscreen2014 kscreen2015 ///   
kscreen2016 kscreen2017 kscreen2018
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Targets K Readiness")
}

qui: use newclean/targetProgramReview.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr targetyr met nactual ndelivery pctactual pctdelivery
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Targets Program Review")
}

qui: use newclean/envEquity.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr effectivestaff staffsgp pctchurn csnicomp stdconduct 		 ///   
ldrship pctnewtch
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Environment Equity")
}

qui: use newclean/envStudentTeacher.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr grade membership ppe ada adarate nfemale nmale naian 		 ///   
naianf naianm nasian nasianf nasianm nblack nblackf nblackm nhisp nhispf 	 ///   
nhispm nmulti nmultif nmultim npacisl npacislf npacislm nwhite nwhitef 		 ///   
nwhitem nfrl nfreelnch nredlnch ncollege nincollege noutcollege nfailure 	 ///   
nmilitary nparttime nvocational nworkforce councilparent ptconf sbdmvote 	 ///   
volunteertime nnbct nfte femalefte malefte tchexp stdcompratio stdtchratio   ///   
droprate gradrate retrate pctfemale pctmale pctaian pctasian pctblack 		 ///   
pcthisp pctmulti pctpacisl pctwhite pctfrl pctfreelnch pctredlnch pctcollege ///   
pctincollege pctoutcollege pctfailure pctmilitary pctparttime pctvocational  ///   
pctworkforce pctdr pctnothq pctoldcomp pctprovcert pctqualba pctqualma 		 ///   
pctqualrank1 pctqualspecialist pctqualtch
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Environment Student-Teacher")
}

qui: use newclean/envTeachingMethods.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr pedagogy nonsitecls noffsitecte noffsitecol nhomehosp nonline
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Environment Teaching Methods")
}

qui: use newclean/envSafety.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr rpthdr rptln membership totevents nfemale nmale naian 	 ///   
nasian nblack nhisp nmulti npacisl nwhite
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Environment Safety")
}

qui: use newclean/envPrograms.dta, clear
`join' `grinfo'
`getfcps'
loc expvars schyr progtype proggroup membership totpct
sort schnm schyr 
qui: levelsof schnm, loc(schools)
foreach v of loc schools {
	qui: export excel `expvars' using `"`root'/`v'/reportCardData.xlsx"' if  ///   
	schnm == `"`v'"', sheetmodify firstrow(varl) sh("Environment Programs")
}


