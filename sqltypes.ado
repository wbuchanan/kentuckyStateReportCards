/*******************************************************************************
*                                                                              *
* Title - FILEIDS                                                              *
*                                                                              *
* Description - Program used to generate unique fileid values for KY school    *
*               and district report card data sets that do not overlap over    *
*               file types.                                                    *
*                                                                              *
* Dependencies -                                                               *
*     Internal - none                                                          *
*     External - should only be called by the kdecombo program                 *
*                                                                              *
* Parameters -                                                                 *
*     Required -                                                               *
*         filenm - String containing the file name containing the data.        *
*         sheetname - The worksheet in which the data are located.             *
*         schyr - The academic year ending used to define subdirectories.      *
*         sheetnumber - An iterator used to identify unique files/years/sheets *
*     Optional -                                                               *
*                                                                              *
* Output -                                                                     *
*     Returns a local macro in r(labdef) containing the key/value pair used to *
*     define the value label associated with this specific instance.           *
*                                                                              *
* Usage -                                                                      *
*     called internally by kdecombo only                                       *
*                                                                              *
* Lines - 344                                                                  *
*                                                                              *
*******************************************************************************/

// Drop program from memory if it exists
cap prog drop sqltypes

// Sub routine that defines SQL types for variables and stores them in 
// characteristics
prog def sqltypes, rclass

	// Defines the syntax used to call the program
	syntax varlist [, noDEString ]
	
	// Define string scalar used to store the table definition
	sca mktable = ""
	
	// Loops over the variable list
	foreach v of var `varlist' {
	
		// Gets the storage type of the variable
		loc vtype `: type `v''
				
		// For any text of 1-2045 characters a VARCHAR will be defined
		if ustrregexm(`"`vtype'"', "str[0-9]{1,4}") == 1 {
		
			// Pulls the number from the type and inserts it into the SQL type
			char `v'[sqltype] `"`v' VARCHAR(`: subinstr loc vtype "str" "", all')"'
			
		} // End IF Block for string types
		
		// Handles Binary Large OBject types
		if `"`vtype'"' == "strL" char `v'[sqltype] `"`v' BLOB"'
		
		// Maps a Stata byte to a SQL TINYINT (1 byte integer)
		else if `"`vtype'"' == "byte" char `v'[sqltype] `"`v' TINYINT"'

		// Maps a Stata int to a SQL SMALLINT (2 byte integer)
		else if `"`vtype'"' == "int" char `v'[sqltype] `"`v' SMALLINT"'
		
		// Maps a Stata long to a SQL INT (4 byte integer)
		else if `"`vtype'"' == "long" char `v'[sqltype] `"`v' INT"'
		
		// Maps a Stata float
		else if inlist(`"`vtype'"', "float", "double") == 1 {
			
			// Map all floating point values to SQL DOUBLE PRECISION (8 byte floats)
			char `v'[sqltype] `"`v' DOUBLE PRECISION"'
			
		} // End ELSE IF Block for floating point values	

		// Handles destring option
		if `"`destring'"' != "" {

			// Removes characteristics related to destringing variables
			qui: char `v'[destring] 
			
			// Removes characteristics related to the destring command used
			qui: char `v'[destring_cmd] 
			
		} // End IF Block for destring option	
		
		// Adds variable's sqltype definition to the string scalar
		sca mktable = mktable + `"`: char `v'[sqltype]', "'
		
	} // Ends Loop over the variable list
	
	// Removes trailing comma
	sca mktable = substr(mktable, 1, length(mktable) - 1)
	
	// Returns the string scalar
	ret loc tabledef = mktable
	
// End of program	
end	

