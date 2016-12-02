discard
clear
cls
cap prog drop mkddl
prog def mkddl, rclass
	syntax anything(name = tablename id = "Need to specify table name")
	qui: ds
	loc vars `r(varlist)'
	sca ddl = "CREATE TABLE public.`tablename' ("
	foreach v of loc vars { 
		sca ddl = ddl + `"`: char `v'[sqltype]', "'
	}
	loc pkvars `: char _dta[primaryKey]'
	sca ddl = ddl + `"CONSTRAINT pk_`tablename' PRIMARY KEY (`: subinstr loc pkvars "fileid, " "", all'))"'
	char def _dta[ddl] `= ddl'
	ret loc ddl = ddl
end
	
loc flavor pg
loc files acctAchievementGrade.dta acctAchievementLevel.dta acctAttendance.dta acctGapLevel.dta acctGapSummary.dta acctGrowth.dta acctNoviceReduction.dta acctParticipation.dta acctProfile.dta acctSummary.dta assessACT.dta assessAP.dta assessEOC.dta assessExplore.dta assessKPREP.dta assessKPREPgr.dta assessKPREPlevel.dta assessKscreen.dta assessNRT.dta assessPlan.dta ccrHighSchool.dta ccrMiddleSchool.dta cteCCR.dta ctePathway.dta ctePerkins.dta envEquity.dta envPrograms.dta envSafety.dta envStudentTeacher.dta envTeachingMethods.dta finance.dta  programReview.dta targetCCR.dta targetGradRate.dta targetKScreen.dta targetProfGap.dta targetProgramReview.dta

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

