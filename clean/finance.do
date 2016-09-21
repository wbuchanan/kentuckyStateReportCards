loc sheets "2011-2012" "2012-2013" "2013-2014" "2014-2015"

// Load first year of data	
qui: import excel using raw/2015/FINANCE.xlsx, 	 ///   
first case(l) clear  sheet(`"`: word 1 of "`sheets'"'"')

// Load subsequent years and append them to first dataset
forv i = 2/4 {
	preserve
		tempfile x`i'
		import excel using raw/2015/FINANCE.xlsx, 	 ///   
		first case(l) clear sheet(`"`: word `i' of "`sheets'"'"')
		qui: save `x`i''.dta, replace
	restore
	append using `x`i''.dta
}

tostring sch_number sch_year, replace
qui: replace sch_number = "999"
qui: replace sch_year = substr(sch_year, 5, 8)

rename (sch_year dist_number sch_number finance_value finance_rank)(schyr distid schid value rank)

encode finance_type, gen(type)  
encode finance_label, gen(label)

drop coop coop_code cntyno cntyname dist_name sch_name sch_cd state_sch_id 	 ///   
ncesid finance_type finance_label

qui: destring schyr rank, replace
qui: drop if mi(value) & mi(rank)
qui: replace value = subinstr(subinstr(subinstr(value, "\$", "", .), ",", "", .), "%", "", .)

preserve
	qui: keep if label == 2
	qui: replace value = cond(value == "Yes", "1", "0")
	destring value, replace
	la def aar 0 "< 4% or Adopted Rate" 1 ">= 4% or Adopted Rate", modify
	la val value aar
	rename value aar
	la var aar "At or Above Adopted Rate"
	drop type rank label
	tempfile aar
	qui: save `aar'.dta, replace
restore
drop if label == 2
destring value, replace
merge m:1 schyr distid schid using `aar'.dta, nogen

qui: save clean/finance.dta, replace



