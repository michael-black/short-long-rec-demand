cls
clear all
set more off
// ssc install parmest

// Choose address 
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/Zipcode Income"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output"

*ssc install _gwtmean

// 2001
import excel "`input_path'/Zip01zp44tx.xlsx", sheet("Zip01zp44tx")
drop if _n<=3
drop if _n>=14837
compress
rename B numret
rename E agi
gen lilzip=substr(A,1,5)
replace lilzip=subinstr(lilzip, "Under", "", .)
replace lilzip=subinstr(lilzip, "$10,0", "", .)
replace lilzip=subinstr(lilzip, "$25,0", "", .)
replace lilzip=subinstr(lilzip, "$50,0", "", .)
replace lilzip=subinstr(lilzip, "Zip C", "", .)
replace lilzip=subinstr(lilzip, "Adjus", "", .)
replace lilzip=subinstr(lilzip, "Incom", "", .)
replace lilzip=subinstr(lilzip, "TEXAS", "", .)
replace lilzip=subinstr(lilzip, "10,00", "", .)

keep lilzip A numret agi
drop if _n<=11

drop if agi=="            "
destring lilzip, replace

egen id = seq(), f(1) t(5)
replace lilzip = lilzip[_n-1] if missing(lilzip) & _n > 1 

local vars "numret agi"
foreach x of local vars{
	replace `x'=subinstr(`x', "*", "", .)
	replace `x'=subinstr(`x', "**", "", .)
	replace `x'=subinstr(`x', " ", "", .)
	replace `x'=subinstr(`x', "--", "", .)
	replace `x'=subinstr(`x', "-", "", .)
	replace `x'=subinstr(`x', ",", "", .)
}
destring numret, replace
destring agi, replace

drop if id==1
gen income_class = (agi*1000)/numret
egen wtinc = wtmean(income_class), by(lilzip) weight(numret)
bys lilzip: egen inc = mean(income_class)
keep lilzip wtinc inc
collapse (mean) wtinc inc, by(lilzip)
gen year = 2001
rename lilzip zcta5
save "`temp_path'/income2001.dta", replace

// 2004
clear
import excel "`input_path'/ZIP Code 2004 TX.xls", sheet("txdiscl_test3")
drop if _n<=4
drop if _n>=19309
compress
rename B numret
rename E agi
gen lilzip=substr(A,1,5)
replace lilzip=subinstr(lilzip, "ZIP C", "", .)
replace lilzip=subinstr(lilzip, "SIZE ", "", .)
replace lilzip=subinstr(lilzip, "Gross", "", .)
replace lilzip=subinstr(lilzip, "$10,0", "", .)
replace lilzip=subinstr(lilzip, "$25,0", "", .)
replace lilzip=subinstr(lilzip, "$50,0", "", .)
replace lilzip=subinstr(lilzip, "$75,0", "", .)
replace lilzip=subinstr(lilzip, "$100,", "", .)
replace lilzip=subinstr(lilzip, "Size ", "", .)
replace lilzip=subinstr(lilzip, "Under", "", .)

keep lilzip A numret agi
drop if _n<=13

destring lilzip, replace

egen id = seq(), f(1) t(8)
drop if id==8

replace lilzip = lilzip[_n-1] if missing(lilzip) & _n > 1 

local vars "numret agi"
foreach x of local vars{
	replace `x'=subinstr(`x', "*", "", .)
	replace `x'=subinstr(`x', "**", "", .)
	replace `x'=subinstr(`x', " ", "", .)
	replace `x'=subinstr(`x', "--", "", .)
	replace `x'=subinstr(`x', "-", "", .)
	replace `x'=subinstr(`x', ",", "", .)
}
destring numret, replace
destring agi, replace

drop if id==1
gen income_class = (agi*1000)/numret
egen wtinc = wtmean(income_class), by(lilzip) weight(numret)
bys lilzip: egen inc = mean(income_class)
keep lilzip wtinc inc
collapse (mean) wtinc inc, by(lilzip)
gen year = 2005
rename lilzip zcta5
save "`temp_path'/income2004.dta", replace

// 2005
clear
import delimited "`input_path'/zipcode05.csv"
keep state agi_class zipcode n1 a00100
keep if state == "TX"
gen income_class = (a00100*1000)/n1
egen wtinc = wtmean(income_class), by(zipcode) weight(n1)
bys zipcode: egen inc = mean(income_class)
keep zipcode wtinc inc
collapse (mean) wtinc inc, by(zipcode)
gen year = 2005
rename zipcode zcta5
save "`temp_path'/income2005.dta", replace

// 2009
clear
import delimited "`input_path'/09zpallagi.csv"
keep state agi_stub zipcode n1 a00100
keep if state == "TX"
gen income_class = (a00100*1000)/n1
egen wtinc = wtmean(income_class), by(zipcode) weight(n1)
bys zipcode: egen inc = mean(income_class)
keep zipcode wtinc inc
collapse (mean) wtinc inc, by(zipcode)
gen year = 2009
rename zipcode zcta5
save "`temp_path'/income2009.dta", replace

// 2012 & 2015
forvalues i=12(3)15{
	clear
	import delimited "`input_path'/`i'zpallagi.csv"
	keep state agi_stub zipcode n1 a00100
	keep if state == "TX"
	gen income_class = (a00100*1000)/n1
	egen wtinc = wtmean(income_class), by(zipcode) weight(n1)
	bys zipcode: egen inc = mean(income_class)
	keep zipcode wtinc inc
	collapse (mean) wtinc inc, by(zipcode)
	gen year = 20`i'
	rename zipcode zcta5
	save "`temp_path'/income20`i'.dta", replace
}



use "`temp_path'/income2001.dta", clear
local years "04 09 12 15"
foreach x of local years{
	append using "`temp_path'/income20`x'.dta"
}
rename zcta5 zipcode
save "`output_path'/income.dta", replace
