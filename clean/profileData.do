kdecombo PROFILE, sheets(`"`"School District Profile Data"' `"School District Profile Data"' `"Sheet 1"' `"Sheet 1"' `"Sheet 1"'"') y(2012 2013 2014 2015 2016)
preserve
	keep dist_name cntyno cntyname
	drop if mi(cntyno)
	duplicates drop
	isid dist_name
	rename (cntyno cntyname)(conum coname)
	tempfile cnty
	qui: save `cnty'.dta, replace
restore
merge m:1 dist_name using `cnty'.dta, nogen
qui: replace dist_number = substr(sch_cd, 1, 3) if mi(dist_number)
qui: replace title1_status = trim(itrim(proper(subinstr(title1_status, "1", "I", .))))
qui: replace sch_number = "999" if mi(sch_number)
qui: replace state_sch_id = conum + dist_number + sch_number if mi(state_sch_id)
qui: replace ncesid = strofreal(nces_cd, "%12.0f") if mi(ncesid)
drop cntyno cntyname nces_cd
qui: replace low_grade = subinstr(subinstr(subinstr(subinstr(low_grade, "th", "", .), "rd", "", .), "nd", "", .), "st", "", .)
qui: replace high_grade = subinstr(subinstr(subinstr(subinstr(high_grade, "th", "", .), "rd", "", .), "nd", "", .), "st", "", .)
qui: replace sch_name = cond(ustrregexm(sch_name, "--") == 1 & sch_number == "999" & dist_number != "999", "District", sch_name)
replace sch_year = substr(sch_year, 5, 8)
replace sch_name = "Kentucky" if ustrregexm(sch_name, "[sS][tT][aA][tT][eE]")
replace dist_name = "Kentucky" if sch_name == "Kentucky"
qui: replace sch_cd = sch_cd + "999" if length(sch_cd) == 3
destring sch_year enrollment membership, replace ignore(", ")
qui: g double lat = real(ustrregexra(latitude, "[\t\r\n\s ]", ""))
qui: g double lon = real(ustrregexra(longitude, "[\t\r\n\s ]", ""))
