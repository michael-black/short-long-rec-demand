/*
Michael Black
January 2018
Updated June 2018
*/

/*
The following datasets should be up-to-date before running this do-file (OUTDATED):
FishLoc.dta
waterquality.dta
locationid.dta
TSAStotalgoodspelling.dta
origins.dta
traveldistances.dta
*/

cls
clear all
set more off
// ssc install parmest

// Choose address 
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output"

// First, I merge fish locations with water quality. I make sure ``FishLoc.dta" and ``waterquality.dta" are both updated.
use "`input_path'/FishLoc.dta"
merge m:m sid using "`input_path'/waterquality.dta"
drop _merge

// Create long-term water quality averages, for re-merge at end of script
preserve
	drop gpsid snum loc sid	
	ds gps basin, not
	collapse `r(varlist)' (first) basin, by(gps)
	egen DO_lt = rowmean(DO*)
	egen Temp_lt = rowmean(Temp*)
	egen Trans_lt = rowmean(Trans*)
	egen Cond_lt = rowmean(Cond*)
	egen pH_lt = rowmean(pH*)
	egen DaysLastPrecip_lt = rowmean(DaysLastPrecip*)
	egen Residue_lt = rowmean(Residue*)
	egen Sulfate_lt = rowmean(Sulfate*)
	egen Chloride_lt = rowmean(Chloride*)
	egen Flowseverity_lt = rowmean(Flowseverity*)
	egen Phosphorus_lt = rowmean(Phosphorus*)
	egen Nitrogen_lt = rowmean(Nitrogen*)
	egen Salinity_lt = rowmean(Salinity*)
	egen Ecoli_lt = rowmean(Ecoli*)
	drop *0 *1 *2 *3 *4 *5 *6 *7 *8 *9
	save "`output_path'/long-term_wq.dta", replace
restore

// Now collapse on gps location, and take the average reading across stations for a given location.	
// Note that we can keep additional years, if desired. 			
collapse (mean) DO2001 DO2004 DO2009 DO2012 DO2015 ///
				Temp2001 Temp2004 Temp2009 Temp2012 Temp2015 /// 
				Trans2001 Trans2004 Trans2009 Trans2012 Trans2015 ///
				Cond2001 Cond2004 Cond2009 Cond2012 Cond2015 /// 
				pH2001 pH2004 pH2009 pH2012 pH2015 ///
				DaysLastPrecip2001 DaysLastPrecip2004 DaysLastPrecip2009 DaysLastPrecip2012 DaysLastPrecip2015 ///
				Residue2001 Residue2004 Residue2009 Residue2012 Residue2015 ///
				Sulfate2001 Sulfate2004 Sulfate2009 Sulfate2012 Sulfate2015 ///
				Chloride2001 Chloride2004 Chloride2009 Chloride2012 Chloride2015 /// 
				Flowseverity2001 Flowseverity2004 Flowseverity2009 Flowseverity2012 Flowseverity2015 ///
				Phosphorus2001 Phosphorus2004 Phosphorus2009 Phosphorus2012 Phosphorus2015 ///
				Nitrogen2001 Nitrogen2004 Nitrogen2009 Nitrogen2012 Nitrogen2015 /// 
				Salinity2001 Salinity2004 Salinity2009 Salinity2012 Salinity2015 ///
				Ecoli2001 Ecoli2004 Ecoli2009 Ecoli2012 Ecoli2015, by(gps)
				
// Merge with location id to give each fishing location an id
merge m:m gps using "`input_path'/locationid.dta"
order locationid
drop _merge wherein
save "`temp_path'/fishlocandwq.dta", replace

// Add USGS/EPA water quality data
clear all
use "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/usgs_wq.dta"
tostring new_lat, replace
tostring new_lon, replace
gen gps=new_lat + ", " + new_lon
keep date pcode value gps
gen date2 = date(date, "YMD")
format date2 %td
gen year=year(date2)
drop date*
replace value=value*0.3048 if pcode==49701
replace value=value*0.0254 if inlist(pcode,90077,78)
gen gsDO=value if pcode==300
gen gspH=value if pcode==400
gen gsTrans=value if inlist(pcode,49701,90077,78,79)
gen gsCond=log(value) if pcode==95
replace year=2001 if inlist(year,2000,2002)
replace year=2004 if inlist(year,2003,2005)
replace year=2009 if inlist(year,2008,2010)
replace year=2012 if inlist(year,2011,2013)
replace year=2015 if inlist(year,2014,2016)
drop if inlist(year,2006,2007)
collapse (mean) gsDO gspH gsTrans gsCond, by(gps year)
local params "gsDO gsTrans gsCond gspH"
foreach x of local params{
	preserve
		keep gps year `x'
		reshape wide `x', i(gps) j(year)
		save "`temp_path'/GS_WQ_Levels_`x'_by_year.dta", replace
	restore
}
clear all
use "`temp_path'/GS_WQ_Levels_gsDO_by_year.dta"
local params2 "gsTrans gsCond gspH"
foreach x of local params2{
	merge m:m gps using "`temp_path'/GS_WQ_Levels_`x'_by_year.dta"
	drop _merge
}
merge 1:m gps using "`temp_path'/fishlocandwq.dta"
drop _merge
local params "DO Trans Cond pH"
foreach x of local params{
	egen meanie`x'2001=rowmean(`x'2001 gs`x'2001)
	egen meanie`x'2004=rowmean(`x'2004 gs`x'2004)
	egen meanie`x'2009=rowmean(`x'2009 gs`x'2009)
	egen meanie`x'2012=rowmean(`x'2012 gs`x'2012)
	egen meanie`x'2015=rowmean(`x'2015 gs`x'2015)
	drop `x'*
	drop gs`x'*
	rename meanie`x'2001 `x'2001
	rename meanie`x'2004 `x'2004
	rename meanie`x'2009 `x'2009
	rename meanie`x'2012 `x'2012
	rename meanie`x'2015 `x'2015
}
save "`temp_path'/fishlocandwq.dta", replace

// Merge zipcode centroids with TSAStotalgoodspelling
clear all
use "`input_path'/TSAStotal.dta"
// I only want the first five digits of the zipcode; I have no ability for further origin accuracy
gen zipcode2=substr(zipcode, 1, 5)
drop zipcode
rename zipcode2 zipcode
merge m:m zipcode using "`input_path'/origins.dta"
drop _merge
drop ogps
drop if missing(wherein)
drop if wherein=="3278Masina"
drop if zipcode=="0"
drop if zipcode==" "
drop if zipcode==" 7813"
sort date wherein
gen id=_n

joinby zipcode using "`input_path'/traveldistances.dta"
sort zipcode destination

// Generate choice variables
gen choice=1 if wherein==destination
replace choice=0 if missing(choice)
gen choice_mo=1 if mostoft==destination
replace choice_mo=0 if missing(choice_mo)

// Drop any saltwater sites that still remain (prior oversight)
drop if inlist(wherein, "Copanobay", "Eastbaymatagorda", "Freeport", "Lagunamadre")
drop if inlist(wherein, "Portanoaraspass", "Portisabel", "Portlavaca", "Portmansfield")
drop if inlist(wherein, "Portofbrownsville", "Sanantoniabay", "Southpadre", "Westbay", "Portoconner")
drop if inlist(destination, "Copanobay", "Eastbaymatagorda", "Freeport", "Lagunamadre")
drop if inlist(destination, "Portanoaraspass", "Portisabel", "Portlavaca", "Portmansfield")
drop if inlist(destination, "Portofbrownsville", "Sanantoniabay", "Southpadre", "Westbay", "Portoconner")

merge m:m locationid using "`temp_path'/fishlocandwq.dta"
sort id wherein destination
drop _merge

// Now I create a single variable for each water quality parameter included in "waterquality.dta"
local params "DO Temp Trans Cond pH DaysLastPrecip Residue Sulfate Chloride Flowseverity Phosphorus Nitrogen Salinity Ecoli"
foreach i of local params{
	gen `i'=`i'2001 if date==2001
	local years "2004 2009 2012 2015"
	foreach x of local years{
		replace `i'=`i'`x' if date==`x'
	}
}
drop *01 *04 *09 *12 *15
order id

/*
Now I modify the income variable (which is categorical and the category definitions differ by year) to reflect 
dollar values. This measurement of income is an approximation from a self-reported value.
*/
replace	income=	5000	if	income==	1	&	date	==	2001
replace	income=	15000	if	income==	2	&	date	==	2001
replace	income=	25000	if	income==	3	&	date	==	2001
replace	income=	35000	if	income==	4	&	date	==	2001
replace	income=	45000	if	income==	5	&	date	==	2001
replace	income=	55000	if	income==	6	&	date	==	2001
replace	income=	65000	if	income==	7	&	date	==	2001
replace	income=	75000	if	income==	8	&	date	==	2001
replace	income=	85000	if	income==	9	&	date	==	2001
replace	income=	95000	if	income==	10	&	date	==	2001
replace	income=	105000	if	income==	11	&	date	==	2001

replace	income=	5000	if	income==	1	&	date	==	2004
replace	income=	15000	if	income==	2	&	date	==	2004
replace	income=	25000	if	income==	3	&	date	==	2004
replace	income=	35000	if	income==	4	&	date	==	2004
replace	income=	45000	if	income==	5	&	date	==	2004
replace	income=	55000	if	income==	6	&	date	==	2004
replace	income=	65000	if	income==	7	&	date	==	2004
replace	income=	75000	if	income==	8	&	date	==	2004
replace	income=	85000	if	income==	9	&	date	==	2004
replace	income=	95000	if	income==	10	&	date	==	2004
replace	income=	105000	if	income==	11	&	date	==	2004

replace	income=	10000	if	income==	1	&	date	==	2009
replace	income=	30000	if	income==	2	&	date	==	2009
replace	income=	50000	if	income==	3	&	date	==	2009
replace	income=	70000	if	income==	4	&	date	==	2009
replace	income=	90000	if	income==	5	&	date	==	2009
replace	income=	110000	if	income==	6	&	date	==	2009

replace	income=	10000	if	income==	1	&	date	==	2012
replace	income=	30000	if	income==	2	&	date	==	2012
replace	income=	50000	if	income==	3	&	date	==	2012
replace	income=	70000	if	income==	4	&	date	==	2012
replace	income=	90000	if	income==	5	&	date	==	2012
replace	income=	110000	if	income==	6	&	date	==	2012
replace	income=	130000	if	income==	7	&	date	==	2012
replace	income=	150000	if	income==	8	&	date	==	2012
replace	income=	170000	if	income==	9	&	date	==	2012

replace	income=	10000	if	income==	1	&	date	==	2015
replace	income=	30000	if	income==	2	&	date	==	2015
replace	income=	50000	if	income==	3	&	date	==	2015
replace	income=	70000	if	income==	4	&	date	==	2015
replace	income=	90000	if	income==	5	&	date	==	2015
replace	income=	110000	if	income==	6	&	date	==	2015
replace	income=	130000	if	income==	7	&	date	==	2015
replace	income=	150000	if	income==	8	&	date	==	2015
replace	income=	170000	if	income==	9	&	date	==	2015

replace income=. if inlist(income, -9)

/*
Income data created in "Get Income Data.dta"
Source: https://www.irs.gov/statistics/soi-tax-stats-individual-income-tax-statistics-zip-code-data-soi
wtinc is weighted average income by zipcode
inc is simple average income by zipcode
*/
gen year = date
destring zipcode, replace
merge m:m zipcode year using "`output_path'/income.dta"
drop _merge

//Adjust for inflation, 2015 dollars
replace income=income*1.3383 if date==2001
replace income=income*1.2547 if date==2004
replace income=income*1.1048 if date==2009
replace income=income*1.0323 if date==2012

local incs "wtinc inc"
foreach x of local incs{
	replace `x'=`x'*1.3383 if date==2001
	replace `x'=`x'*1.2547 if date==2004
	replace `x'=`x'*1.1048 if date==2009
	replace `x'=`x'*1.0323 if date==2012
}

// Generate a variable for the cost-per mile.
// From: https://fred.stlouisfed.org/graph/?g=lls
// Assume 10k miles driven/person/year
// Assume small engine utility vehicle from AAA estimates
gen permilecost=0.652*1.3383 if date==2001
replace permilecost=0.727*1.2547 if date==2004
replace permilecost=0.897*1.1048 if date==2009
replace permilecost=0.985*1.0323 if date==2012
replace permilecost=0.926 if date==2015

//Now I create the travel cost variable: from Parsons (2017) (adapted for daily wages)
gen travcost=(0.33*(income/250)*1)+(permilecost*2*dist)
gen travcost_zip_w_inc=(0.33*(wtinc/250)*1)+(permilecost*2*dist)
gen travcost_zip_inc=(0.33*(inc/250)*1)+(permilecost*2*dist)

//Travel cost using Lupi et al 2020 specification
gen tc_lupi=(0.33*(income/2000)*(2*duration/60/60))+(permilecost*2*dist)
gen tc_lupi_zip_w_inc=(0.33*(wtinc/2000)*(2*duration/60/60))+(permilecost*2*dist)
gen tc_lupi_zip_inc=(0.33*(inc/2000)*(2*duration/60/60))+(permilecost*2*dist)


// Tag individuals who choose none of the available choice set
egen cbad = total(choice == 1), by(id)
egen cmobad = total(choice_mo == 1), by(id)

// Create indicatos for rivers and lakes, and drop any potentially salt-water sites
preserve
	clear
	import excel "`input_path'/Indicators for Lakes and Rivers.xlsx", sheet("Sheet1") firstrow clear
	rename A destination
	replace River=0 if missing(River)
	replace Lake=0 if missing(Lake)
	replace Salt=0 if missing(Salt)
	replace Salt=1 if Salt==8
	rename River river
	rename Lake lake
	rename Salt salt
	save "`temp_path'/river_lake_indicators.dta", replace
restore
merge m:1 destination using "`temp_path'/river_lake_indicators.dta"
drop _merge
drop if salt==1
drop salt

merge m:1 gps using "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output/long-term_wq.dta"
drop _merge

save "`output_path'/condlogit.dta", replace

********************************************************************************
** Create small version of final dataset to preserve memory
********************************************************************************

// Drop data that would be dropped anyways with the clogit process
drop if missing(id)

// Keep minimal data in memory
keep id choice choice_mo travcos* tc* destination locationid ///
		DO pH Cond Trans DaysLastPrecip Residue Sulfate Chloride Flowseverity Phosphorus Nitrogen Salinity Ecoli *_lt///
		basin date tripcount distance reportdist tripday river
// Recode tripday
replace tripday=. if inlist(tripday, -9, 999)
replace reportdist=. if inlist(reportdist, 99999, -9)

drop if missing(DO) | missing(pH) | missing(Cond) | missing(Trans)

// Use locationid as fixed effect instead of string destination
split locationid, p(".")
destring locationid1, replace

// Tag anglers who make no choice
bys id: egen good_tt = sum(choice == 1)
bys id: egen good_mo = sum(choice == 1)

// Drop locations that (after the above alt-wise deletion) are never chosen
drop if inlist(locationid1, 46, 64, 186, 202, 277)

// RENAME TRAVEL COST VARIABLES
rename travcost tc1
rename travcost_zip_w_inc tc2
rename travcost_zip_inc tc3

rename tc_lupi tcl1
rename tc_lupi_zip_w_inc tcl2
rename tc_lupi_zip_inc tcl3

save "`output_path'/condlogit_small.dta", replace


