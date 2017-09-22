discard
clear
cls

// Drops program if already defined in memory
cap prog drop mkddl

// Defines the program mkddl as an R-class program
prog def mkddl, rclass

	// Sets the minimum version required
	version 14.0

	// Defines the syntax used to call the program (the name for the table is 
	// required, but will default to public (for PostgreSQL) or dbo (for SQL 
	// Server)
	syntax anything(name = tablename id = "Need to specify table name"), /// 
	[ FLAvor(string asis) SCHema(string asis) ]
	
	// Check for optional arguments
	if `"`flavor'`schema'"' == "" loc schema dbo
	
	// Sets the schema for PostgreSQL instances
	else if `"`flavor'"' == "postgres" & `"`schema'"' == "" loc schema public 
	
	// Sets the schema for SQL Server
	else if `"`flavor'"' == "sql" & `"`schema'"' == "" loc schema dbo
	
	// If schema specified do nothing:
	else if `"`schema'"' != "" continue
	
	// Otherwise throw an error
	else err 198
	
	// Gets the full list of variable names
	qui: ds
	
	// Stores the variable names in the local macro vars
	loc vars `r(varlist)'
	
	// Creates a string scalar 
	sca ddl = "CREATE TABLE `schema'.`tablename' ("
	
	// Loop over the variables
	foreach v of loc vars { 
	
		// Adds the SQL definition of the storage type to the existing DDL 
		sca ddl = ddl + `"`: char `v'[sqltype]', "'
		
	} // End of Loop
	
	// Gets the list of variables that form the primary key constraint
	loc pkvars `: char _dta[primaryKey]'
	
	// Test for missing primary key definition
	if `"`pkvars'"' == "" {
		
		// Display error message
		di as err "WARNING: This file does not have a primary key defined.  " ///   
		"This may lead to errors inserting into existing tables and/or " ///   
		"a violation of the primary key constraint that should exist."
		
	} // End IF Block 
	
	// If there is a primary key defined add the PK to the table definition
	else sca ddl = ddl + `"CONSTRAINT pk_`tablename' PRIMARY KEY (`: subinstr loc pkvars "fileid, " "", all'))"'
	
	// Defines a characteristic with the DDL for this file into a characteristic
	char def _dta[ddl] `= ddl'
	
	// Returns the string in a local macro (assuming the string is short enough
	ret loc ddl = ddl
	
// End of program	
end
	
loc flavor pg
loc files acctAchievementGrade.dta acctAchievementLevel.dta acctAttendance.dta acctGapLevel.dta acctGapSummary.dta acctGrowth.dta acctNoviceReduction.dta acctParticipation.dta acctProfile.dta acctSummary.dta assessACT.dta assessAP.dta assessEOC.dta assessExplore.dta assessKPREP.dta assessKPREPgr.dta assessKPREPlevel.dta assessKscreen.dta assessNRT.dta assessPlan.dta ccrHighSchool.dta ccrMiddleSchool.dta cteCCR.dta ctePathway.dta ctePerkins.dta envEquity.dta envPrograms.dta envSafety.dta envStudentTeacher.dta envTeachingMethods.dta finance.dta  programReview.dta targetCCR.dta targetGradRate.dta targetKScreen.dta targetProfGap.dta targetProgramReview.dta

// 
loc cmd odbc exec(`"\`: char _dta[ddl]'"'), dsn(pggeo)

use newclean/profile.dta, clear

mkddl kde_profile
if `"`flavor'"' == "pg" loc exec `= ustrregexra(`"`cmd'"', "TINYINT", "SMALLINT")'
else loc exec `cmd'
`exec'
qui: ds
sqlloader `r(varlist)', table(kde_profile) flav(`flavor') ins comm dsn(pggeo)

foreach v of loc files {
	use newclean/`v', clear
	mkddl `: subinstr loc v ".dta" "", all'
	if `"`flavor'"' == "pg" loc exec `= ustrregexra(`"`cmd'"', "TINYINT", "SMALLINT")'
	else loc exec `cmd'
	`exec'
	qui: ds
	sqlloader `r(varlist)', table(`: subinstr loc v ".dta" "", all') flav(`flavor') ins comm  dsn(pggeo)
}

