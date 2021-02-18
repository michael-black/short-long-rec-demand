**** Must create condlogit_small.dta prior to running this do-file

/*

Set input path to Build/Output
Set optional local path.

*/

******************************************************************************
** Simulation (bootstrap) to recover CIs for WTP
******************************************************************************
* clear all
* set more off
* set matsize 800
* //ssc install parmest

* local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"
* local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Temp"
* local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output"
* local local_path "/Users/michaelblack/Documents/condlogit"

* use "`output_path'/condlogit_small.dta", clear
* save "`local_path'/condlogit_small.dta", replace 
* cd "`local_path'"

* capture prog drop bootie
* program bootie, rclass
* 	use condlogit_small, clear
* 	drop if good_tt == 0
* 	bsample, cluster(id) idcluster(newid)
* 	local params "DO pH Cond Trans"
* 	foreach x of local params{
* 	bys destination: egen lt`x' = mean(`x') 
* 	bys destination: egen sd`x' = sd(`x')
* 	}
* 	egen stdvDO = mean(sdDO) if basin==12
* 	egen stdvpH = mean(sdpH) if basin==12
* 	egen stdvCond = mean(sdCond) if basin==12
* 	egen stdvTrans = mean(sdTrans) if basin==12

* 	drop if good_tt == 0
* 	quietly asclogit choice tcl1 DO pH Cond Trans, case(newid) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
* 	// Keep first stage coefficients
* 	local params "tcl1 DO pH Cond Trans"
* 	foreach x of local params{
* 	scalar b_`x'=_b[`x']
* 	}
* 	// Generate ASCs
* 	gen alpha = 0 if destination == "Aquillalake"
* 	levelsof destination, local(levels)
* 	foreach x of local levels{
* 		capture replace alpha = _b[`x':_cons] if destination == "`x'"
* 	}
* 	preserve
* 	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
* 	// Stage 2
* 	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
* 	restore
* 	// Keep second stage coefficients
* 	local params "DO_lt pH_lt Cond_lt Trans_lt"
* 	foreach x of local params{
* 	scalar b_`x'=_b[`x']
* 	}
* 	scalar bL_cons = _b[_cons]
* 	// Generate residual ASC
* 	gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

* 	// Status-quo IV
* 	bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
* 	bys id: egen sumIV=total(altIV)
* 	bys id: gen sqIV=log(sumIV)

* 	// Improvement in short-term transparency
* 	gen newTrans = Trans + (stdvTrans) if basin ==12
* 	replace newTrans = Trans if missing(newTrans)

* 	// New short-term conditions IV
* 	bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
* 	bys id: egen sumIV2=total(altIV2)
* 	bys id: gen stIV=log(sumIV2)

* 	// WTP for new short-term conditions
* 	gen st_wtp = -(stIV - sqIV) / b_tcl1

* 	// Improvement in long-term WQ
* 	gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
* 	replace ltnewTrans = Trans_lt if missing(ltnewTrans)

* 	// New long-term conditions IV
* 	bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
* 	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
* 	bys id: egen sumIV3=total(altIV3)
* 	bys id: gen ltIV=log(sumIV3)

* 	// WTP for new long-term conditions
* 	gen lt_wtp = -(ltIV - sqIV) / b_tcl1

* 	// Mean and median short-term WTP across anglers
* 	qui sum st_wtp, d
* 	return scalar at_mean = r(mean)
* 	return scalar at_med = r(p50)
* 	// Mean and median long-term WTP across anglers
* 	qui sum lt_wtp, d
* 	return scalar ct_mean = r(mean)
* 	return scalar ct_med = r(p50)
* 	// Seasonal measures
* 	gen acute_season = st_wtp*tripcount
* 	qui sum acute_season, d
* 	return scalar as_mean = r(mean)
* 	return scalar as_med = r(p50)
* 	gen chronic_season = lt_wtp*tripcount
* 	qui sum chronic_season, d
* 	return scalar cs_mean = r(mean)
* 	return scalar cs_med = r(p50)
* end

* simulate at_mean=r(at_mean) at_med=r(at_med) ct_mean=r(ct_mean) ct_med=r(ct_med) ///
* 			as_mean=r(as_mean) as_med=r(as_med) cs_mean=r(cs_mean) cs_med=r(cs_med), saving(welfare_CI_107, replace) reps(50): bootie

******************************************************************************
** Get CIs
******************************************************************************

clear all
set more off
set matsize 800

local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output"
local local_path "/Users/michaelblack/Documents/condlogit"

cd "`local_path'"

use "welfare_CI_928.dta", clear
append using "welfare_CI_929.dta"
append using "welfare_CI_101.dta"
append using "welfare_CI_102.dta"
append using "welfare_CI_106.dta"




