/*
Michael Black
July 2018
For detailed notes/comments and original code, see "Specify Water Quality Data.do"
*/

clear all
set more off
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"

use "`output_path'/WQfull.dta"

// Keep relevant parameters. See dictionary for larger list.
keep if inlist(pcode, 300, 89857, 301, 10, 209, 20, 78, 82078, 82079, 20424, ///
			88842, 89969, 94, 212, 400, 403, 72053, 530, 945, 940, 1351, 665, 610, 480, 31699)
gen year=year(date)
gen month=month(date)

// Keep only relevant stations
preserve
	clear
	import delimited "`input_path'/stationlist.csv", encoding(ISO-8859-1)
	save "`temp_path'/stationlist.dta", replace
restore
merge m:m sid using "`temp_path'/stationlist.dta"
drop if _merge==1 | _merge==2
drop _merge

// Create water quality variables //
// DO and related measures
gen DO=wqval if pcode==300
gen DO_24hravg=wqval if pcode==89857
gen DO_per_sat=wqval if pcode==301
// Temperature and related measures
gen Temp=wqval if pcode==10
gen Temp_24hravg=wqval if pcode==209
gen Temp_air=wqval if pcode==20
// Transparency and related measures
gen Trans=wqval if pcode==78
gen Turb_field=wqval if pcode==82078
gen Turb_lab=wqval if pcode==82079
gen Clairity=wqval if pcode==20424
gen Turb=wqval if pcode==88842
gen Water_color=wqval if pcode==89969
// Conductance and related measures - replaced with log values
gen Cond=wqval if pcode==94
gen Cond_24hravg=wqval if pcode==212
replace Cond=log(Cond)
replace Cond_24hravg=log(Cond_24hravg)
// pH and related measures
gen pH=wqval if pcode==400
gen pH_lab=wqval if pcode==403
// Other measures
gen DaysLastPrecip=wqval if pcode==72053
gen Residue=wqval if pcode==530
gen Sulfate=wqval if pcode==945
gen Chloride=wqval if pcode==940
gen Flowseverity=wqval if pcode==1351
gen Phosphorus=wqval if pcode==665
gen Nitrogen=wqval if pcode==610
gen Salinity=wqval if pcode==480
gen Ecoli=wqval if pcode==31699

drop pcode

// Generate a time of observation variable
split endtime, parse(":")
destring endtime1, replace
rename endtime1 time
drop endtime*

// Before any imputation, replace missing hourly measurements with daily measurement
local avglist "DO Temp Cond"
foreach x of local avglist{
	replace time=12 if ~missing(`x'_24hravg)
}
foreach x of local avglist{
	replace `x'=`x'_24hravg if missing(`x') & ~missing(`x'_24hravg)
}

// Keep measurements only during the day
keep if inlist(time, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19)

// Keep fishing months
// keep if inlist(month, 3, 4, 5, 6, 7, 8, 9, 10)

// Group stations by basin
replace segment=segmentid if missing(segment) & ~missing(segmentid)
drop segmentid
local letters "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
foreach x of local letters{
	replace segment = subinstr(segment, "`x'", "",.) 
}
gen str segment2 = string(real(segment),"%04.0f")
drop segment
rename segment2 segment
gen basin=substr(segment, 1, 2)
destring basin, replace
drop segment date org

// Clump peripheral months into survey years to account for:
	// 1. Slow change of pace in water quality
	// 2. Preference formation using prior information
replace year=2001 if year==2000 & inlist(month, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
replace year=2001 if year==2002 & inlist(month, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)	

replace year=2004 if year==2003 & inlist(month, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
replace year=2004 if year==2005 & inlist(month, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)	
	
replace year=2009 if year==2008 & inlist(month, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
replace year=2009 if year==2010 & inlist(month, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

replace year=2012 if year==2011 & inlist(month, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
replace year=2012 if year==2013 & inlist(month, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

replace year=2015 if year==2014 & inlist(month, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
replace year=2015 if year==2016 & inlist(month, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Reformat data into wide-form and save
local params "DO Temp Trans Cond pH DaysLastPrecip Residue Sulfate Chloride Flowseverity Phosphorus Nitrogen Salinity Ecoli"
foreach x of local params{
	preserve
	keep sid year `x' basin
		collapse (mean) `x', by(sid year basin)
		sort sid
		reshape wide `x', i(sid) j(year)
		save "`temp_path'/WQ_Levels_`x'_by_year.dta", replace
	restore
}
clear all
use "`temp_path'/WQ_Levels_DO_by_year.dta"
local params2 "Temp Trans Cond pH DaysLastPrecip Residue Sulfate Chloride Flowseverity Phosphorus Nitrogen Salinity Ecoli"
foreach x of local params2{
	merge m:m sid using "`temp_path'/WQ_Levels_`x'_by_year.dta"
	drop _merge
}
save "`output_path'/waterquality.dta", replace

/*
eststo clear
levelsof basin, local(levels)
foreach x of local levels{
	eststo basin_`x': quietly reg DO depth month time Temp Trans if basin==`x'
}
estout using "`output_path'/example.rtf", cells(b se p) replace
*/
