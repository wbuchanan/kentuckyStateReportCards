
// Capture any errors when trying to drop the program from memory
cap prog drop kdecombo

// Define a program
prog def kdecombo

	// Specify the version of Stata required for the program
	version 14.1
	
	// Define the syntax used to call the program
	syntax anything(name=filenm id="Need file name"), SHeets(string) 		 ///   
	Years(string asis)

	// Load first year of data	
	qui: import excel using raw/`: word 1 of `years''/`filenm'.xlsx, 		 ///   
	first case(l) clear  sheet(`"`: word 1 of `sheets''"') allstring
	
	// Defines value label for file ID variable
	la def fileid 1 `"`: word 1 of `years''/`filenm'.xlsx -- `: word 1 of `sheets''"', modify
	
	// Creates a file ID variable to verify the number of workbooks & worksheets
	// loaded into this data set
	qui: g byte fileid = 1
	
	// For values 2 through the total number of values passed to the years parameter
	forv y = 2/`: word count `years'' {

		// Adds file name to file ID value labels
		la def fileid `y' `"`: word `y' of `years''/`filenm'.xlsx -- `: word `y' of `sheets''"', modify
			
		// Preserve the current data in memory
		preserve
		
			// Reserve namespace for a temp file
			tempfile x`y'
			
			// import the data for the next year headers in the first row, 
			// make all variable names lower cased, clear data from memory, and 
			// pull the correct word for this file to identify the worksheet
			import excel using raw/`: word `y' of `years''/`filenm'.xlsx, 	 ///   
			first case(l) clear sheet(`"`: word `y' of `sheets''"') allstring
			
			// Adds a new file ID 
			qui: g byte fileid = `y'
			
			// Save the data to the tempfile
			qui: save `x`y''.dta, replace
			
		// Restore the data to it's previous state	
		restore
		
		// Add the data from the step above in this loop to the original data set
		qui: append using `x`y''.dta

	} // Move to the next value
	
	// Label the file ID values
	la val fileid fileid 
	
	// Label the file ID variable
	la var fileid "Source Workbook and Worksheets for the Data"

// End of program	
end

