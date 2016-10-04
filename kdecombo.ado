
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
	
	// For values 2 through the total number of values passed to the years parameter
	forv y = 2/`: word count `years'' {

		// Preserve the current data in memory
		preserve
		
			// Reserve namespace for a temp file
			tempfile x`y'
			
			// import the data for the next year headers in the first row, 
			// make all variable names lower cased, clear data from memory, and 
			// pull the correct word for this file to identify the worksheet
			import excel using raw/`: word `y' of `years''/`filenm'.xlsx, 	 ///   
			first case(l) clear sheet(`"`: word `y' of `sheets''"') allstring
			
			// Save the data to the tempfile
			qui: save `x`y''.dta, replace
			
		// Restore the data to it's previous state	
		restore
		
		// Add the data from the step above in this loop to the original data set
		qui: append using `x`y''.dta

	} // Move to the next value

// End of program	
end

