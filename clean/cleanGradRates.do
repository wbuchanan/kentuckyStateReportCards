import excel using raw/2015/DELIVERY_TARGET_GRADUATION_RATE_COHORT.xlsx, 	 ///   
case(l) clear first

rename (sch_year cntyno cntyname dist_number dist_name sch_number sch_name 	 ///   
sch_cd state_sch_id ncesid category target_level cohort_type target_label 	 ///   
disagg_label cohort_2013 cohort_2014 cohort_2015 target_label_sort coop 	 ///   
coop_code)(schyr countyid countynm distid distnm schid schnm schcode kyschid ///   
ncesid outcome level type target amogroup c2013 c2014 c2015 targetsort coop  ///   
coopid)

qui: g leaid = substr(ncesid, 1, 7)
qui: replace schid = "000" if mi(schid)
qui: replace kyschid = countyid + distid + schid if mi(kyschid)
gsort distid - ncesid
bysort distid: replace leaid = leaid[_n - 1] if mi(leaid)
qui: replace ncesid = leaid if mi(ncesid) & !mi(leaid)
qui: replace ncesid = "210000000000" if distnm == "State"
qui: replace ncesid = "2100" + distid + "09999" if mi(ncesid) & mi(countyid)
qui: replace leaid = "2100" + distid if mi(leaid)

qui: replace type = cond(type == "FIVE YEAR", "5", "4")
destring type, replace
la def type 4 "4yr Adjusted Cohort Graduation Rate" 5 "5yr Adjusted Cohort Graduation Rate"
la val type type

qui: replace target = 	cond(target == "Actual Score", "1", ///   
						cond(target == "Delivery Target", "2", ///   
						cond(target == "Numerator Count", "3", ///   
						cond(target == "Denominator Count", "4", "5"))))

						
destring target, replace
la def target 1 "Observed" 2 "Target" 3 "Numerator" 4 "Denominator" 5 "Met Target"
la val target target

qui: replace amogroup = cond(amogroup == "All Students", "1", ///   
						cond(amogroup == "African American", "2", ///   
						cond(amogroup == "American Indian or Alaska Native", "3", ///   
						cond(amogroup == "Asian", "4", ///   
						cond(amogroup == "Hispanic", "5", ///   
						cond(amogroup == "Native Hawaiian or Other Pacific Islander", "6", ///   
						cond(amogroup == "Two or more races", "7", ///   
						cond(amogroup == "White (Non-Hispanic)", "8", ///   
						cond(amogroup == "Female", "9", ///   
						cond(amogroup == "Male", "10", ///   
						cond(amogroup == "Disability-With IEP (Total)", "11", ///   
						cond(amogroup == "Free/Reduced-Price Meals", "12", ///   
						cond(amogroup == "GAP", "13", ///   
						cond(amogroup == "Limited English Proficiency", "14", ///   
						cond(amogroup == "Migrant", "15", "")))))))))))))))

destring amogroup, replace

la def amogroup 1 "All Students" ///   
				2 "African American" ///   
				3 "American Indian or Alaska Native" ///   
				4 "Asian" ///   
				5 "Hispanic" ///   
				6 "Native Hawaiian or Other Pacific Islander" ///   
				7 "Two or more races" ///   
				8 "White" ///   
				9 "Female" ///   
				10 "Male" ///   
				11 "Disability-With IEP (Total)" ///   
				12 "Free/Reduced-Price Meals" ///   
				13 "GAP" ///   
				14 "Limited English Proficiency" ///   
				15 "Migrant", modify
				
la val amogroup amogroup				

forv v = 2013/2015 {
	qui: g double cohort`v' = 	cond(c`v' == "***", .s, ///   
							cond(c`v' == "NO", 0, ///   
							cond(c`v' == "YES", 1, ///   
							cond(c`v' == "N/A", .n, ///   
							cond(ustrregexm(c`v', "[0-9]") == 1, real(c`v'), .x)))))
}

drop schcode level outcome targetsort c2013 c2014 c2015 schyr

reshape long cohort, i(ncesid type target amogroup) j(schyr)

reshape wide cohort, i(ncesid schyr type amogroup) j(target)
rename (cohort1 cohort2 cohort3 cohort4 cohort5)(actual target num den met)
la def actual .s "***" .n "N/A" .x ""
la def target .s "***" .n "N/A" .x ""
la def num .s "***" .n "N/A" .x ""
la def den .s "***" .n "N/A" .x ""
la def met 0 "Did not Meet Target" 1 "Met Target" .x ""
la val actual actual
la val target target
la val num num
la val den den
la val met met
reshape wide actual target num den met, i(ncesid schyr amogroup) j(type)

qui: g stateid = "999"

loc lacoop la var coop "Cooperative Name"
loc ladistnm la var distnm "District Name"
loc laschnm la var schnm "School Name"


la var ncesid "National Center for Education Statistics School ID"
la var leaid "National Center for Education Statistics District ID"
la var schyr "School Year"
la var amogroup "AMO Reporting Group"	
`lacoop'
`ladistnm'
`laschnm'

loc actual "Actual "
loc target "Target "
loc num "Numerator for "
loc den "Denominator for "
loc met "Met Target for "
loc st "Statewide "
loc dist "Districtwide "

foreach v in actual target num den met {
	la var `v'4 `"``v'' 4-Year Adjusted Cohort Graduation Rate"'
	la var `v'5 `"``v'' 5-Year Adjusted Cohort Graduation Rate"'
}

qui: compress
qui: replace schnm = distnm if schnm == "---COOP Total---"
qui: save clean/normalFormGradRates13-15.dta, replace

tempfile state dist

preserve

	qui: keep if schnm == "---State Total---"
	
	qui: keep amogroup schyr actual4 target4 num4 den4 met4 actual5 target5  ///   
	num5 den5 met5 stateid schnm
	
	qui: replace schnm = "State"
	
	qui: rename (actual4 target4 num4 den4 met4 actual5 target5 num5 den5 	 ///   
	met5) (stactual4 sttarget4 stnum4 stden4 stmet4 stactual5 sttarget5 	 ///   
	stnum5 stden5 stmet5)
	
	qui: duplicates drop
	
	qui: save `state'.dta, replace
	
restore, preserve

	qui: keep if schnm == "---District Total---"
	
	qui: keep amogroup schyr actual4 target4 num4 den4 met4 actual5 target5	 ///   
	num5 den5 met5 leaid schnm distnm stateid
	
	qui: replace schnm = distnm
	
	qui: rename (actual4 target4 num4 den4 met4 actual5 target5 num5 den5 met5) ///   
	(distactual4 disttarget4 distnum4 distden4 distmet4 distactual5			 ///   
	disttarget5 distnum5 distden5 distmet5)
	
	qui: drop distnm
	
	qui: duplicates drop
	
	qui: save `dist'.dta, replace
	
restore

qui: drop if inlist(schnm, "---State Total---", "---District Total---")
merge m:1 stateid amogroup schyr using `state'.dta, gen(stmerge)
merge m:1 leaid amogroup schyr using `dist'.dta, gen(distmerge)
foreach v of var actual4 target4 num4 den4 met4 actual5 target5 num5 den5 met5 {
	qui: replace dist`v' = `v' if !mi(coop)
}
drop distmerge stmerge countyid countynm stateid

qui: g long district = real(distid)
qui: g long school = real(kyschid)
qui: g long cooperative = real(coopid)

qui: levelsof distid, loc(d)
loc dlabs la def district 
foreach v of loc d {
	qui: levelsof distnm if distid == `"`v'"', loc(nm)
	loc nm : list clean nm
	loc dlabs `dlabs' `v' `nm'
}
`dlabs'
la val district district

qui: levelsof kyschid, loc(s)
loc slabs la def school 
foreach v of loc s {
	qui: levelsof schnm if kyschid == `"`v'"', loc(nm)
	loc nm : list clean nm
	loc slabs `slabs' `v' `nm'
}
`slabs'
la val school school

qui: levelsof coopid, loc(c)
loc clabs la def cooperative 
foreach v of loc c {
	qui: levelsof coop if coopid == `"`v'"', loc(nm)
	loc nm : list clean nm
	loc clabs `clabs' `v' `nm'
}
`clabs'
la val cooperative cooperative
drop coop distnm schnm coopid distid schid kyschid
rename (district school cooperative)(distnm schnm coop)
destring ncesid leaid, replace

compress
order ncesid leaid coop distnm schnm schyr amogroup stactual4 sttarget4 	 ///   
stnum4 stden4 stmet4 distactual4 disttarget4 distnum4 distden4 distmet4 	 ///   
actual4 target4 num4 den4 met4 stactual5 sttarget5 stnum5 stden5 stmet5 	 ///   
distactual5 disttarget5 distnum5 distden5 distmet5 actual5 target5 num5 	 ///   
den5 met5

foreach v in actual target num den met {
	la var st`v'4 `"`st'``v'' 4-Year Adjusted Cohort Graduation Rate"'
	la var dist`v'4 `"Districtwide ``v'' 4-Year Adjusted Cohort Graduation Rate"'
	la var `v'4 `"School ``v'' 4-Year Adjusted Cohort Graduation Rate"'
	la var st`v'5 `"`st'``v'' 5-Year Adjusted Cohort Graduation Rate"'
	la var dist`v'5 `"Districtwide ``v'' 5-Year Adjusted Cohort Graduation Rate"'
	la var `v'5 `"School ``v'' 5-Year Adjusted Cohort Graduation Rate"'
}

`lacoop'
`ladistnm'
`laschnm'

qui: compress
qui: save clean/denormalizedGradRates13-15.dta, replace
