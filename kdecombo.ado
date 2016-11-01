/*******************************************************************************
*                                                                              *
* Title - KDECOMBO                                                             *
*                                                                              *
* Description - Program used to combine data set files from the KDE school and *
*               district report card data sets.  This handles performing the   *
*               equivalent of a union operation on the data from the files and *
*               corresponding worksheets.                                      *
*                                                                              *
* Dependencies -                                                               *
*     Internal - fileids.ado                                                   *
*     External - none                                                          *
*                                                                              *
* Parameters -                                                                 *
*     Required -                                                               *
*         filenm - String containing the file name containing the data.        *
*         sheets - The worksheets in which the data are stored.                *
*         years - The academic year ending used to define subdirectories.      *
*     Optional -                                                               *
*         root - The parent directory where annual subdirectories are found.   *
*                                                                              *
* Output -                                                                     *
*     Leaves a data set in memory containing the resulting union of data sets  *
*     identified by the parameters passed to the command.                      *
*                                                                              *
* Usage -                                                                      *
*     kdecombo CTE_CAREER_PERKINS, sheets(`"`"Sheet 1"' `"Sheet 1"'"')     /// *
*     y(2014 2015) r(~/Desktop/kentuckyStateReportCards/newdl)                 *
*                                                                              *
* Lines - 105                                                                  *
*                                                                              *
*******************************************************************************/

// Capture any errors when trying to drop the program from memory
cap prog drop kdecombo

// Define a program
prog def kdecombo

	// Specify the version of Stata required for the program
	version 14.1
	
	// Define the syntax used to call the program
	syntax anything(name=filenm id="Need file name"), SHeets(string) 		 ///   
	Years(string asis) [ Root(string asis) ]

	// Load first year of data	
	qui: import excel using `"`root'/`: word 1 of `years''/`filenm'.xlsx"',  ///   
	first case(l) clear  sheet(`"`: word 1 of `sheets''"') allstring
	
	// Defines value label for file ID variable
	fileids `filenm', s(`: word 1 of `years'') sheetnu(1)					 ///   
	sheetna(`"`: word 1 of `sheets''"') 

	loc fileid `r(labdef)'
	
	// For values 2 through the number of values passed to the years parameter
	forv y = 2/`: word count `years'' {

		// Preserve the current data in memory
		preserve
		
			// Reserve namespace for a temp file
			tempfile x`y'
			
			// Stores the local macro containing the year value
			loc year `: word `y' of `years''
			
			// Stores the local macro containing the sheet name
			loc sheetname `: word `y' of `sheets''
			
			// import the data for the next year headers in the first row, 
			// make all variable names lower cased, clear data from memory, and 
			// pull the correct word for this file to identify the worksheet
			import excel using `"`root'/`year'/`filenm'.xlsx"', ///   
			first case(l) clear sheet("`sheetname'") allstring
			
			// Defines value label for file ID variable
			fileids `filenm', s(`year') sheetnu(`y') sheetna("`sheetname'") 

			// Adds the key value pair used to define the value label
			loc fileid `fileid' `r(labdef)'
		
			// Save the data to the tempfile
			qui: save `x`y''.dta, replace
			
		// Restore the data to it's previous state	
		restore
		
		// Unions the most recently processed file with the first file
		qui: append using `x`y''.dta

	} // Move to the next value
	
	// Defines the value labels for the fileid variable
	la def fileid `fileid', modify
	
	// Label the file ID values
	la val fileid fileid 
	
	// Label the file ID variable
	la var fileid "Source Workbook and Worksheets for the Data"

// End of program	
end

