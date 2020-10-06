/*
Michael Black
December 2017
Updated June 2018

In this do-file, I take the raw data provided by CRP of the TCEQ (in .csv format), and create the
"RawCRPtotal.dta" file used for further manipulation and estimation.
*/
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"

clear
set more off
cd "`input_path'"

// Years that have parameter codes as strings: 2004 2005 2006 2010 2011 (4,5,6 have E)(10,11 have P)
// Years that do not have parameter codes as strings: 2001 2002 2003 2007 2008 2009 2012 2013 2014 2015


local goodyears "2001 2002 2003 2007 2008 2009 2012 2013 2014 2015"
foreach x of local goodyears{
	clear
	import delimited "FullRawDataExtractCRP`x'.csv", encoding(ISO-8859-1)
	keep stationid parametercode value enddate enddepth collectingentity endtime segment
	rename stationid sid
	rename parametercode pcode
	rename value wqval
	rename enddate date
	rename enddepth depth
	rename collectingentity org
	*The following ensures the date variable is in the proper format
	gen date2=date(date, "MDY")
	format date2 %td
	recast int date2
	drop date
	rename date2 date
	order sid pcode date depth wqval org
	save "`temp_path'/RawCRP`x'.dta", replace
}

local Eyears "2004 2005 2006"
foreach x of local Eyears{
	clear
	import delimited "FullRawDataExtractCRP`x'.csv", encoding(ISO-8859-1)
	keep stationid parametercode value enddate enddepth collectingentity endtime segment
	rename stationid sid
	rename parametercode pcode
	rename value wqval
	rename enddate date
	rename enddepth depth
	rename collectingentity org
	*The following ensures the date variable is in the proper format
	gen date2=date(date, "MDY")
	format date2 %td
	recast int date2
	drop date
	rename date2 date
	order sid pcode date depth wqval org
	replace pcode = subinstr(pcode, "E", "",.)
	destring pcode, replace
	save "`temp_path'/RawCRP`x'.dta", replace
}

local Pyears "2010 2011"
foreach x of local Pyears{
	clear
	import delimited "FullRawDataExtractCRP`x'.csv", encoding(ISO-8859-1)
	keep stationid parametercode value enddate enddepth collectingentity endtime segment
	rename stationid sid
	rename parametercode pcode
	rename value wqval
	rename enddate date
	rename enddepth depth
	rename collectingentity org
	*The following ensures the date variable is in the proper format
	gen date2=date(date, "MDY")
	format date2 %td
	recast int date2
	drop date
	rename date2 date
	order sid pcode date depth wqval org
	replace pcode = subinstr(pcode, "P", "",.)
	destring pcode, replace
	save "`temp_path'/RawCRP`x'.dta", replace
}

// The years 2000 and 2016 were added at a later date, and the formatting from TCEQ changed.
// These years must be done outside of a loop
clear
import delimited "FullRawDataExtractCRP2000.csv", encoding(ISO-8859-1)
drop if _n>=280227
compress
keep stationid parametercode value enddate enddepth collectingentity endtime segment
rename stationid sid
rename parametercode pcode
rename value wqval
rename enddate date
rename enddepth depth
rename collectingentity org
*The following ensures the date variable is in the proper format
split date, parse("/")
replace date1 = string(real(date1),"%02.0f")
replace date2 = string(real(date2),"%02.0f")
rename date1 month
rename date2 day
rename date3 year
replace date=month+day+year
gen date2=date(date, "MD20Y")
format date2 %td
recast int date2
drop date month day year 
rename date2 date
order sid pcode date depth wqval org
save "`temp_path'/RawCRP2000.dta", replace

clear
import delimited "FullRawDataExtractCRP2016.csv", encoding(ISO-8859-1)
drop if _n>=328674
compress
keep stationid parametercode value enddate enddepth collectingentity endtime segment
rename stationid sid
rename parametercode pcode
rename value wqval
rename enddate date
rename enddepth depth
rename collectingentity org
*The following ensures the date variable is in the proper format
split date, parse("/")
replace date1 = string(real(date1),"%02.0f")
replace date2 = string(real(date2),"%02.0f")
rename date1 month
rename date2 day
rename date3 year
replace date=month+day+year
gen date2=date(date, "MD20Y")
format date2 %td
recast int date2
drop date month day year 
rename date2 date
order sid pcode date depth wqval org
save "`temp_path'/RawCRP2016.dta", replace

// Append all years

clear all
cd "`temp_path'"
use "RawCRP2000.dta"
local appendyears "2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016"
foreach x of local appendyears{
	append using "RawCRP`x'.dta"
}
save "`output_path'/WQfull.dta", replace
