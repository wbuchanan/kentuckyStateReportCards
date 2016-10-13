// Drops program if already loaded in memory
cap prog drop

// Define program for generating static file IDs across file types
prog def fileids, rclass

	// Defines the syntax used to call the program
	syntax anything(name = filenm id = "Must pass file name"), 				 ///   
	Schyr(integer) SHEETNAme(string) SHEETNUmber(integer)

	// For school profile files the series is 200 followed by the school year 
	// and a sheet number
	if "`filenm'" == "PROFILE" {
		loc fileid `= real("200`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 300 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_ACHIEVEMENT_GRADE" {
		loc fileid `= real("300`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 301 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_ACHIEVEMENT_LEVEL" {
		loc fileid `= real("301`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 302 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_CCR_HIGHSCHOOL" {
		loc fileid `= real("302`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 303 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_CCR_MIDDLESCHOOL" {
		loc fileid `= real("303`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 304 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_FEDERAL_DATA_ATTENDANCE" {
		loc fileid `= real("304`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 305 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_FEDERAL_DATA_PARTICIPATION_RATE" {
		loc fileid `= real("305`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 306 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_GAP_LEVEL" {
		loc fileid `= real("306`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 307 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_GAP_SUMMARY" {
		loc fileid `= real("307`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 308 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_GROWTH" {
		loc fileid `= real("308`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 309 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_NOVICE_REDUCTION" {
		loc fileid `= real("309`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 310 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_PROFILE" {
		loc fileid `= real("310`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 311 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ACCOUNTABILITY_SUMMARY" {
		loc fileid `= real("311`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 312 followed by the school year 
	// and a sheet number
	if "`filenm'" == "PROGRAM_REVIEW" {
		loc fileid `= real("312`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 400 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_ACT" {
		loc fileid `= real("400`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 401 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_ADVANCE_PLACEMENT" {
		loc fileid `= real("401`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 402 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_EXPLORE" {
		loc fileid `= real("402`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 403 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_PLAN" {
		loc fileid `= real("403`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 404 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_KPREP_EOC" {
		loc fileid `= real("404`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 405 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_KPREP_GRADE" {
		loc fileid `= real("405`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 406 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_KPREP_LEVEL" {
		loc fileid `= real("406`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 407 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_KSCREEN" {
		loc fileid `= real("407`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 408 followed by the school year 
	// and a sheet number
	if "`filenm'" == "ASSESSMENT_NRT" {
		loc fileid `= real("408`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 500 followed by the school year 
	// and a sheet number
	if "`filenm'" == "CTE_CAREER_CCR" {
		loc fileid `= real("500`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 501 followed by the school year 
	// and a sheet number
	if "`filenm'" == "CTE_CAREER_PATHWAYS" {
		loc fileid `= real("501`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 502 followed by the school year 
	// and a sheet number
	if "`filenm'" == "CTE_CAREER_PERKINS" {
		loc fileid `= real("502`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 600 followed by the school year 
	// and a sheet number
	if "`filenm'" == "DELIVERY_TARGET_CCR" {
		loc fileid `= real("600`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 601 followed by the school year 
	// and a sheet number
	if "`filenm'" == "DELIVERY_TARGET_GRADUATION_RATE_COHORT" {
		loc fileid `= real("601`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 602 followed by the school year 
	// and a sheet number
	if "`filenm'" == "DELIVERY_TARGET_KSCREEN" {
		loc fileid `= real("602`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 603 followed by the school year 
	// and a sheet number
	if "`filenm'" == "DELIVERY_TARGET_PROFICIENCY_GAP" {
		loc fileid `= real("603`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files the series is 604 followed by the school year 
	// and a sheet number
	if "`filenm'" == "DELIVERY_TARGET_PROGRAM_REVIEW" {
		loc fileid `= real("604`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For Finance files the series is 700 followed by the school year 
	// and a sheet number
	if "`filenm'" == "FINANCE" {
		loc fileid `= real("700`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For files in the Learning Environment the series is 8##
	
	// For the Equity file the series is 800 followed by the school year 
	// and a sheet number
	if "`filenm'" == "LEARNING_ENVIRONMENT_EQUITY" {
		loc fileid `= real("800`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For the Student/Teacher demographic file the series is 801 
	// followed by the school year and a sheet number
	if "`filenm'" == "LEARNING_ENVIRONMENT_STUDENTS-TEACHERS" {
		loc fileid `= real("801`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For the teaching methods file the series is 802 followed by the school 
	// year and a sheet number
	if "`filenm'" == "LEARNING_ENVIRONMENT_TEACHING_METHODS" {
		loc fileid `= real("802`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For the Safety file the series is 803 followed by the school year 
	// and a sheet number
	if "`filenm'" == "LEARNING_ENVIRONMENT_SAFETY" {
		loc fileid `= real("803`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// For the special programs file the series is 804 followed by the school 
	// year and a sheet number
	if "`filenm'" == "LEARNING_ENVIRONMENT_PROGRAMS" {
		loc fileid `= real("804`schyr'`sheetnumber'")'
		loc fiddef `fiddef'  `fileid' `"`schyr'/`filenm'.xlsx -- `sheetname'"'
		qui: g fileid = `fileid'
	}

	// Defines the local macro that is returned by this program
	ret loc labdef `fiddef'
	
end	
