cap prog drop sqlloader

prog def sqlloader

	version 14.1 
	
	syntax [varlist], COMMents TABle(string asis) dsn(passthru)				 ///   
	[ FLAVor(string asis) CReate INSert * ]
	
	if `"`create'"' != "" & `"`insert'"' != "" {
		di as err "Cannot create a new table and insert into an existing table simulataneously"
		exit 
	}
	
	loc cmnt1 "COMMENT ON COLUMN `table'."
	
	odbc ins `varlist', table(`table') `options' `create' `insert'
	
	if `"`comments'"' != "" {
	
		qui: ds `varlist'
		
		loc vars `r(varlist)'
		
		foreach v of loc vars {
		
			odbc exec(`"`cmnt1'`v' IS '`: var label `v'''"'), `dsn'
	
		}
		
	}
	
end

	
