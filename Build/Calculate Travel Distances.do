* Calculate distances between zipcode centroids and fishing locations
clear all
cls
set more off
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"

import excel "`input_path'/US Census Data on Zipcode Centroids.xlsx", sheet("Sheet1") firstrow
drop if missing(GEOID)
drop ALAND AWATER ALAND_SQMI AWATER_SQMI
rename GEOID zipcode
rename INTPTLAT olat
rename INTPTLONG olon
egen ogps=concat(olat olon), punct(", ")

preserve
clear
use "`output_path'/TSAStotal.dta"
sort zipcode
duplicates drop zipcode, force
gen zipcode2=substr(zipcode, 1, 5)
drop zipcode
rename zipcode2 zipcode
keep zipcode
save "`temp_path'/TSASzips.dta", replace
restore

tostring zipcode, replace
merge 1:m zipcode using "`temp_path'/TSASzips.dta"
keep if _merge==3
drop _merge

drop olat olon
save "`output_path'/origins.dta", replace

// Get rid of zipcodes outside the state of Texas
clear
import excel "`input_path'/Three Digit Zip Codes.xlsx", sheet("Sheet3")
keep E F
rename E State
rename F Zip
replace Zip=substr(Zip, 1, 3)
keep if State=="TX"
tempfile temp1
save "`temp1'"
use "`output_path'/origins.dta"
gen Zip=substr(zipcode, 1,3)
merge m:1 Zip using "`temp1'"
keep if _merge==3
drop Zip State _merge
save "`output_path'/origins.dta", replace

// Keep the gps coordinates from ``origins.dta" and ``fishgps.dta" for use in GEODIST
preserve
clear
use "`temp_path'/fishgps.dta"
drop gpsid
save "`temp_path'/tempfishgps.dta", replace
restore

cross using "`temp_path'/tempfishgps.dta"
rename gps dgps

split ogps, parse(,)
split dgps, parse(,)
rename ogps1 olat
rename ogps2 olon
rename dgps1 dlat
rename dgps2 dlon
// gen distlookup = olat + "," + olon + "," + dlat + "," + dlon
duplicates drop
local locs "olat olon dlat dlon"
foreach x of local locs{
	destring `x', replace
}
save "`temp_path'/distancematrix.dta", replace

// Calculate driving distances using osrmtime package
// Install process should be completed before running anything below
// Map preparation should be completed before running anything below
osrmtime olat olon dlat dlon, mapfile("C:\Users\black.michael\Documents\OSRMTIME\texaslatest.osrm") ///
		osrmdir("C:\osrm") nocleanup

// Convert distance from meters to miles
replace distance=distance*0.000621371
				
/*
// Calculate straight-line distances using geodist package
ssc install geodist
destring *at, replace
destring *on, replace
geodist olat olon dlat dlon, gen(dist) miles
*/

keep dgps distance duration jumpdist1 jumpdist2 zipcode
rename dgps gps
merge m:m gps using "`input_path'/locationid.dta"
drop _merge gps
order zipcode wherein locationid distance duration jumpdist1 jumpdist2

sort wherein zipcode distance
gen double mindist=distance
replace mindist=min(mindist, mindist[_n-1]) if zipcode==zipcode[_n-1]

drop if mindist ~= dist
rename wherein destination
drop mindist

save "`output_path'/traveldistances.dta", replace