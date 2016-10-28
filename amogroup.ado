/* 
* Program used to attach text labels to numeric values in a data set:
*/

// Drop the program from memory if already loaded
cap prog drop amogroup

// Defines the amogroup program
prog def amogroup

	// Minimum version of Stata required for this program (should work under 
	// many older versions of Stata as well)
	version 14.1
	
	// Syntax for calling the program
	syntax , [ LAbels(string asis)  LAName(string asis) ]

	// If no new variable name is specified assume the name amogroup
	if `"`laname'"' == "" loc laname amogroup
	
	// If no label variable specified assume disagg_label
	if `"`labels'"' == "" loc labels disagg_label
	
	// Other wise confirm that it is a variable name that was passed
	else qui: confirm v `labels'
	
	// Changes end of line delimiter to semi-colon
	#d ;
	
	// Defines the value labels for student subgroups across all files
	la def `laname' 0 "All Students"
				1 "Asian"
				2 "Black"
				3 "Hispanic"
				4 "American Indian or Alaska Native"
				5 "Native Hawaiian or Other Pacific Islander"
				6 "Two or more races"
				7 "White (Non-Hispanic)"
				8 "Female"
				9 "Male"
				10 "Gap Group (non-duplicated)"
				11 "Migrant"
				12 "Free/Reduced-Price Meals"
				13 "Disability - With Accommodation (not including Alternate)"
				14 "Disability - Alternate Only"
				15 "Disability - With IEP (Total)"
				16 "Disability - With IEP (not including Alternate)"
				17 "Gifted/Talented"
				18 "English Learners"
				19 "Autism"
				20 "Creative or Divergent Thinking"
				21 "Deaf-Blindness"
				22 "Developmental Delay"
				23 "Emotional-Behavioral Disability"
				24 "Functional Mental Disability"
				25 "General Intellectual Ability"
				26 "Hearing Impairment"
				27 "Home Language - Arabic"
				28 "Home Language - Chinese"
				29 "Home Language - Japanese"
				30 "Home Language - Nepali"
				31 "Home Language - Russian"
				32 "Home Language - Somali"
				33 "Home Language - Spanish"
				34 "Home Language - Vietnamese"
				35 "Mild Mental Disability"
				36 "Multiple Disabilities"
				37 "Orthopedic Impairment"
				38 "Other Health Impairment"
				39 "Primary Talent Pool"
				40 "Psychosocial Leadership Skills"
				41 "Specific Academic Aptitude - Language Arts"
				42 "Specific Academic Aptitude - Math"
				43 "Specific Academic Aptitude - Science"
				44 "Specific Academic Aptitude - Social Studies"
				45 "Specific Learning Disability"
				46 "Speech or Language Impairment"
				47 "Traumatic Brain Injury"
				48 "Visual Impairment"
				49 "Visual/Performing Arts - Art"
				50 "Visual/Performing Arts - Dance"
				51 "Visual/Performing Arts - Drama"
				52 "Visual/Performing Arts - Music", modify;

	// Creates the new numerically encoded variable
	qui: g `laname' = 	cond(`labels' == "All Students", 0, 
					cond(`labels' == "African American", 2, 
					cond(`labels' == "Asian", 1, 
					cond(`labels' == "American Indian or Alaska Native", 4, 
					cond(`labels' == "Hispanic", 3, 
					cond(`labels' == "Native Hawaiian or Other Pacific Islander", 5, 
					cond(`labels' == "Two or more races", 6, 
					cond(`labels' == "White (Non-Hispanic)", 7, 
					cond(`labels' == "Female", 8, 
					cond(`labels' == "Male", 9, 
					cond(inlist(`labels', "GAP", "Gap Group (non-duplicated)"), 10, 
					cond(`labels' == "Migrant", 11, 
					cond(`labels' == "Free/Reduced-Price Meals", 12, 
					cond(`labels' == "Disability-With Accommodation (not including Alternate)", 13, 
					cond(`labels' == "Disability-Alternate Only", 14, 
					cond(`labels' == "Disability-With IEP (Total)", 15, 
					cond(`labels' == "Disability-With IEP (not including Alternate)", 16, 
					cond(`labels' == "Gifted/Talented", 17, 
					cond(inlist(`labels', "English Learners", 
						"Limited English Proficiency"), 18, 
					cond(inlist(`labels', "Disability - Alternate Only", 
						"Disability – With Accommodation not including Alternate", 
						"Disability – With IEP not including Alternate"), .d, 
					cond(`labels' == "Autism", 19, 
					cond(`labels' == "Creative or Divergent Thinking", 20, 
					cond(inlist(`labels', "Deaf Blind", "Deaf/Blind"), 21, 
					cond(inlist(`labels', "Developmental Delay", 
						"Developmentally Delayed"), 22, 
					cond(`labels' == "Emotional Behavior Disability", 23, 
					cond(`labels' == "Functional Mental Disability", 24, 
					cond(`labels' == "General Intellectual Ability", 25, 
					cond(inlist(`labels', "Hearing Impaired", 
						"Hearing Impairment"), 26, 
					cond(`labels' == "Home Language-Arabic", 27, 
					cond(`labels' == "Home Language-Chinese", 28, 
					cond(`labels' == "Home Language-Japanese", 29, 
					cond(`labels' == "Home Language-Nepali", 30, 
					cond(`labels' == "Home Language-Russian", 31, 
					cond(`labels' == "Home Language-Somali", 32, 
					cond(`labels' == "Home Language-Spanish", 33, 
					cond(`labels' == "Home Language-Vietnamese", 34, 
					cond(`labels' == "Mild Mental Disability", 35, 
					cond(`labels' == "Multiple Disabilities", 36, 
					cond(inlist(`labels', "Orthopedic Impairment", 
						"Orthopedically Impaired"), 37, 
					cond(`labels' == "Other Health Impaired", 38, 
					cond(`labels' == "Primary Talent Pool", 39, 
					cond(`labels' == "Psychosocial Leadership Skills", 40, 
					cond(`labels' == "Specific Academic Aptitude-Language Arts", 41, 
					cond(`labels' == "Specific Academic Aptitude-Math", 42, 
					cond(`labels' == "Specific Academic Aptitude-Science", 43, 
					cond(`labels' == "Specific Academic Aptitude-Social Studies", 44, 
					cond(inlist(`labels', "Specific Learning Disabilities", 
						"Specific Learning Disability"), 45, 
					cond(inlist(`labels', "Speech Language", 
						"Speech or Language Impairment"), 46, 
					cond(`labels' == "Traumatic Brain Injury", 47, 
					cond(inlist(`labels', "Visual Impairment", 
						"Visually Impaired"), 48, 
					cond(`labels' == "Visual and Performing Arts-Art", 49, 
					cond(`labels' == "Visual and Performing Arts-Dance", 50, 
					cond(`labels' == "Visual and Performing Arts-Drama", 51, 
					cond(`labels' == "Visual and Performing Arts-Music", 52, .u 
					))))))))))))))))))))))))))))))))))))))))))))))))))))));  

	// Changes end of line delimiter back to carriage return				
	#d cr
	
	// Applies value labels to new variable
	la val `laname' `laname'			
	
	// Applies variable label to new variable
	la var `laname' "KDE Reporting Subgroups"
	
	// Drops cases where the demographic label is one of the missing values 
	// specified above
	qui: drop if `laname' == .d
	
	// Drops the old variable from the data set
	qui: drop `labels'
	
// End of program definition	
end

	
