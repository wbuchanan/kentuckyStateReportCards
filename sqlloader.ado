cap prog drop sqlloader

prog def sqlloader

	version 14.1 
	
	syntax [varlist], COMMents TABle(string asis) dsn(passthru)				 ///   
	[ FLAVor(string asis) CReate INSert * ]
	
	if `"`create'"' != "" & `"`insert'"' != "" {
		di as err "Cannot create a new table and insert into an existing table simulataneously"
		exit 
	}
		
	odbc ins `varlist', table(`table') `options' `create' `insert'
	
	if `"`comments'"' != "" {
		if `"`flavor'"' != "mssql" loc cmnt1 "COMMENT ON COLUMN `table'."
		else loc cmnt1 "EXEC sp_addextendedproperty @name = N'MS_Description', @value = "
		qui: ds `varlist'
		loc vars `r(varlist)'
		foreach v of loc vars {
			if `"`flavor'"' != "mssql" loc comment `"`cmnt1'`v' IS '`: var label `v'''"'
			else loc comment `"`cmnt1' '`: var label `v''', @level0type = "' ///   
			`"N'Schema', @level0name = dbo, @level1type = N'Table', "'		 ///   
			`"@level1name = `table', @level2type = N'Column', @level2name = `v'"'
			odbc exec(`comment'), `dsn'
		}
		
	}
	
end

	
