// Drops the program from memory if already loaded
cap prog drop sqlloader

// Defines the program
prog def sqlloader

	// Minimum version required
	version 14.1 
	
	// Defines the syntax used to call the program
	syntax [varlist], COMMents [ SCHEma(string asis) FLAVor(string asis) 	 ///   
	CReate INSert TABle(string asis) dsn(passthru) noUPper * ]
	
	// Stores the apostrophe character in a local macro
	loc apost "`=char(39)'"

	// Tests for the schema/SQL flavor/type and sets schema to dbo for SQL Server 
	// if no schema is provided
	if `"`schema'"' == "" & `"`flavor'"' == "mssql" loc schema dbo

	
	if `"`create'"' != "" & `"`insert'"' != "" {
		di as err "Cannot create a new table and insert into an existing table simulataneously"
		exit 
	}
		
	if `"`create'"' != "" | `"`insert'"' != "" {
	
		odbc ins `varlist', table(`table') `options' `create' `insert'
	
	}
	
	if `"`comments'"' != "" {
		if `"`flavor'"' != "mssql" loc cmnt1 "COMMENT ON COLUMN `table'."
		else loc cmnt1 "EXEC sp_addextendedproperty @name = N'MS_Description', @value = "
		foreach v of loc varlist {
			sca vlab = subinstr(`"`: var label `v''"', `"`= char(39)'"', `"`= char(39)'`= char(39)'"', .)
			loc vlab `: di vlab'
			if `"`noupper'"' != "" loc column `v'
			else loc column `: di upper("`v'")'
			if `"`flavor'"' != "mssql" loc comment `"`cmnt1'`v' IS '`vlab''"'
			else {
				loc start "EXEC sp_addextendedproperty @name = N'MS_Description'"
				loc meta "@value = '`vlab''"
				loc lev0t "@level0type = N'Schema'"
				loc lev0n "@level0name = '`schema''"
				loc lev1t "@level1type = N'Table'"
				loc lev1n "@level1name = '`table''"
				loc lev2t "@level2type = N'Column'"
				loc lev2n "@level2name = '`column''"
				loc comment `start', `meta', `lev0t', `lev0n', `lev1t', `lev1n', `lev2t', `lev2n'
				di as res `"`comment'"'
				odbc exec(`"`comment'"'), `dsn'
			}
		}
		
	}
	
end

	
