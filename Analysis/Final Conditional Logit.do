clear
set more off
set matsize 800

* Set input path to Build/Output
local input_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Analysis/Output"


********************************************************************************
** See Analysis/Code/README for summary of model runs
********************************************************************************

********************************************************************************
** SINGLE RUNS, NO WELFARE
********************************************************************************
eststo clear
** (1) *************************************************************************
/*
// (1)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	eststo Stage1_1: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_1a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_1b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (1alt)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	eststo Stage1_1alt: quietly asclogit choice tc1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_1aalt: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_1balt: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust


// (2)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	keep if tripday<=1
	eststo Stage1_2: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_2a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_2b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
	
// (3)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	keep if distance<=150
	eststo Stage1_3: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)	
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_3a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_3b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
	
// (4)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	gen derr = distance - reportdist
	keep if derr<=100
	eststo Stage1_4: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_4a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_4b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
	
// (5)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	keep if tripcount!=0
	eststo Stage1_5: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)	
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_5a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_5b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
		
// (6)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	keep if river==0
	eststo Stage1_6: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)	
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_6a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_6b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (7)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	keep if river==1
	eststo Stage1_7: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Bosque") altwise vce(cluster id) iter(20)	
	// Generate ASCs
	gen alpha = 0 if destination == "Bosque"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_7a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_7b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (8)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	drop if date==2001
	eststo Stage1_8: quietly asclogit choice tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)	
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_8a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_8b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

esttab Stage1_1 Stage1_1alt Stage1_2 Stage1_3 Stage1_4 Stage1_5 Stage1_6 Stage1_7 Stage1_8 using "`output_path'/Stage1_tt.tex", ///
			se aic r2 ar2 pr2 scalars(ll ll_0) starlevels( * 0.1 ** 0.05 *** 0.01) f ///
			booktabs label replace	
esttab Stage2_1a Stage2_1b Stage2_1aalt Stage2_1balt Stage2_2a Stage2_2b Stage2_3a Stage2_3b Stage2_4a Stage2_4b Stage2_5a Stage2_5b ///
		Stage2_6a Stage2_6b Stage2_7a Stage2_7b Stage2_8a Stage2_8b using "`output_path'/Stage2_tt.tex", se aic r2 ar2 pr2 scalars(ll ll_0) ///
			starlevels( * 0.1 ** 0.05 *** 0.01) f booktabs label replace	
*/

			
** (2) *************************************************************************
eststo clear
/*	
// (1)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	eststo Stage1_1: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_1a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_1b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (1alt)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	eststo Stage1_1alt: quietly asclogit choice_mo tc1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_1aalt: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_1balt: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
	
// (2)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	keep if distance<=150
	eststo Stage1_2: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_2a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_2b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
	
// (3)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	keep if tripcount!=0
	eststo Stage1_3: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_3a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_3b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust
		
// (4)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	keep if river==0
	eststo Stage1_4: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_4a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_4b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (5)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	keep if river==1
	eststo Stage1_5: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Bosque") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Bosque"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_5a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_5b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust

// (6)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	drop if date==2001
	eststo Stage1_6: quietly asclogit choice_mo tcl1 DO pH Cond Trans, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	eststo Stage2_6a: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
	eststo Stage2_6b: quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt i.basin, robust


esttab Stage1_1 Stage1_1alt Stage1_2 Stage1_3 Stage1_4 Stage1_5 Stage1_6 using "`output_path'/Stage1_mo.tex", ///
			se aic r2 ar2 pr2 scalars(ll ll_0) starlevels( * 0.1 ** 0.05 *** 0.01) f ///
			booktabs label replace	
esttab Stage2_1a Stage2_1b Stage2_1aalt Stage2_1balt Stage2_2a Stage2_2b Stage2_3a Stage2_3b Stage2_4a Stage2_4b Stage2_5a Stage2_5b Stage2_6a Stage2_6b ///
			using "`output_path'/Stage2_mo.tex", se aic r2 ar2 pr2 scalars(ll ll_0) ///
			starlevels( * 0.1 ** 0.05 *** 0.01) f booktabs label replace	

*/
			
** (3) *************************************************************************
eststo clear
/*
// (1)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_tt == 0
	local params "DO pH Cond Trans"
	foreach x of local params{
		gen `x'2=`x'^2
		qui sum `x'
		scalar m`x' = r(mean)
		scalar min`x' = r(min)
		scalar max`x' = r(max)
	}

	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		gen `x'2=`x'^2
		qui sum `x'
		scalar m`x' = r(mean)
		scalar min`x' = r(min)
		scalar max`x' = r(max)
	}

	eststo Stage1_1: quietly asclogit choice tcl1 DO DO2 pH pH2 Cond Cond2 Trans Trans2, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	local params "DO pH Cond Trans"
	foreach x of local params{
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*min`x'
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*m`x'
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*max`x'
	}
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin DO_lt2 pH_lt2 Cond_lt2 Trans_lt2, by(destination)

	// Stage 2
	eststo Stage2_1a: quietly reg alpha DO_lt DO_lt2 pH_lt pH_lt2 Cond_lt Cond_lt2 Trans_lt Trans_lt2, robust
	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		lincom _b[`x'] + 2*_b[`x'2]*min`x'
		lincom _b[`x'] + 2*_b[`x'2]*m`x'
		lincom _b[`x'] + 2*_b[`x'2]*max`x'
	}
	eststo Stage2_1b: quietly reg alpha DO_lt DO_lt2 pH_lt pH_lt2 Cond_lt Cond_lt2 Trans_lt Trans_lt2 i.basin, robust
	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		lincom _b[`x'] + 2*_b[`x'2]*min`x'
		lincom _b[`x'] + 2*_b[`x'2]*m`x'
		lincom _b[`x'] + 2*_b[`x'2]*max`x'
	}
	
// (2)
	use "`output_path'/condlogit_small.dta", clear
	drop if good_mo == 0
	local params "DO pH Cond Trans"
	foreach x of local params{
		gen `x'2=`x'^2
		qui sum `x'
		scalar m`x' = r(mean)
		scalar min`x' = r(min)
		scalar max`x' = r(max)
	}

	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		gen `x'2=`x'^2
		qui sum `x'
		scalar m`x' = r(mean)
		scalar min`x' = r(min)
		scalar max`x' = r(max)
	}

	eststo Stage1_2: quietly asclogit choice_mo tcl1 DO DO2 pH pH2 Cond Cond2 Trans Trans2, case(id) ///
		alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
	local params "DO pH Cond Trans"
	foreach x of local params{
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*min`x'
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*m`x'
		lincom _b[destination:`x'] + 2*_b[destination:`x'2]*max`x'
	}
	// Generate ASCs
	gen alpha = 0 if destination == "Aquillalake"
		levelsof destination, local(levels)
		foreach x of local levels{
			capture replace alpha = _b[`x':_cons] if destination == "`x'"
	}
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin DO_lt2 pH_lt2 Cond_lt2 Trans_lt2, by(destination)

	// Stage 2
	eststo Stage2_2a: quietly reg alpha DO_lt DO_lt2 pH_lt pH_lt2 Cond_lt Cond_lt2 Trans_lt Trans_lt2, robust
	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		lincom _b[`x'] + 2*_b[`x'2]*min`x'
		lincom _b[`x'] + 2*_b[`x'2]*m`x'
		lincom _b[`x'] + 2*_b[`x'2]*max`x'
	}
	eststo Stage2_2b: quietly reg alpha DO_lt DO_lt2 pH_lt pH_lt2 Cond_lt Cond_lt2 Trans_lt Trans_lt2 i.basin, robust
	local params "DO_lt pH_lt Cond_lt Trans_lt"
	foreach x of local params{
		lincom _b[`x'] + 2*_b[`x'2]*min`x'
		lincom _b[`x'] + 2*_b[`x'2]*m`x'
		lincom _b[`x'] + 2*_b[`x'2]*max`x'
	}

esttab Stage1_1 Stage1_2 using "`output_path'/Stage1_quad.tex", ///
			se aic r2 ar2 pr2 scalars(ll ll_0) starlevels( * 0.1 ** 0.05 *** 0.01) f ///
			booktabs label replace	
esttab Stage2_1a Stage2_1b Stage2_2a Stage2_2b  ///
			using "`output_path'/Stage2_quad.tex", se aic r2 ar2 pr2 scalars(ll ll_0) ///
			starlevels( * 0.1 ** 0.05 *** 0.01) f booktabs label replace	
*/
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************
** Single-run welfare distribution over anglers
******************************************************************************
** See README for model descriptions
******************************************************************************
		

// (1) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 1
save "`temp_path'/tt1.dta", replace

// (2) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
quietly asclogit choice tc1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tc1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tc1*tc1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tc1*tc1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tc1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tc1*tc1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tc1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 2
save "`temp_path'/tt2.dta", replace

// (3) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
keep if tripday <= 1
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 3
save "`temp_path'/tt3.dta", replace

// (4) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
keep if distance <= 150
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 4
save "`temp_path'/tt4.dta", replace

// (5) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
gen derr = distance - reportdist
keep if derr<=100
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 5
save "`temp_path'/tt5.dta", replace

// (6) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
drop if tripcount==0
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 6
save "`temp_path'/tt6.dta", replace

// (7) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
keep if river == 0
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 7
save "`temp_path'/tt7.dta", replace

// (8) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
keep if river == 1
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Bosque") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Bosque"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 8
save "`temp_path'/tt8.dta", replace

// (9) **********************************************************************
use "`output_path'/condlogit_small.dta", clear

local params "DO pH Cond Trans"
foreach x of local params{
	bys destination: egen lt`x' = mean(`x') 
	bys destination: egen sd`x' = sd(`x')
}
egen stdvDO = mean(sdDO) if basin==12
egen stdvpH = mean(sdpH) if basin==12
egen stdvCond = mean(sdCond) if basin==12
egen stdvTrans = mean(sdTrans) if basin==12

drop if good_tt == 0
drop if date == 2001
quietly asclogit choice tcl1 DO pH Cond Trans, case(id) alternative(destination) base("Aquillalake") altwise vce(cluster id) iter(20)
// Keep first stage coefficients
local params "tcl1 DO pH Cond Trans"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
// Generate ASCs
gen alpha = 0 if destination == "Aquillalake"
	levelsof destination, local(levels)
	foreach x of local levels{
		capture replace alpha = _b[`x':_cons] if destination == "`x'"
}
preserve
	collapse (first) DO_lt pH_lt Cond_lt Trans_lt alpha basin, by(destination)
	// Stage 2
	quietly reg alpha DO_lt pH_lt Cond_lt Trans_lt, robust
restore
// Keep second stage coefficients
local params "DO_lt pH_lt Cond_lt Trans_lt"
foreach x of local params{
	scalar b_`x'=_b[`x']
}
scalar bL_cons = _b[_cons]
// Generate residual ASC
gen asc_new = alpha - b_DO_lt*DO_lt - b_pH_lt*pH_lt - b_Cond_lt*Cond_lt - b_Trans_lt*Trans_lt - bL_cons

// Status-quo IV
bys id: gen altIV=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*Trans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV=total(altIV)
bys id: gen sqIV=log(sumIV)

// Improvement in short-term transparency
gen newTrans = Trans + (stdvTrans) if basin ==12
replace newTrans = Trans if missing(newTrans)

// New short-term conditions IV
bys id: gen altIV2=exp(alpha+b_tcl1*tcl1+b_DO*DO+b_Trans*newTrans+b_Cond*Cond+b_pH*pH)
bys id: egen sumIV2=total(altIV2)
bys id: gen stIV=log(sumIV2)

// WTP for new short-term conditions
gen st_wtp = -(stIV - sqIV) / b_tcl1

// Improvement in long-term WQ
gen ltnewTrans = Trans_lt + (stdvTrans) if basin ==12
replace ltnewTrans = Trans_lt if missing(ltnewTrans)

// New long-term conditions IV
bys id: gen altIV3=exp(bL_cons + asc_new + b_DO_lt*DO_lt + b_pH_lt*pH_lt + b_Cond_lt*Cond_lt + b_Trans_lt*ltnewTrans + ///
	b_tcl1*tcl1 + b_DO*DO + b_Trans*Trans + b_Cond*Cond + b_pH*pH)
bys id: egen sumIV3=total(altIV3)
bys id: gen ltIV=log(sumIV3)

// WTP for new long-term conditions
gen lt_wtp = -(ltIV - sqIV) / b_tcl1

// Save results to separate dataset
keep id st_wtp lt_wtp
duplicates drop
gen run = 9
save "`temp_path'/tt9.dta", replace


******************************************************************************
** Plot wtp distributions
******************************************************************************
use "`temp_path'/tt1", clear
append using "`temp_path'/tt2"
append using "`temp_path'/tt3"
append using "`temp_path'/tt4"
append using "`temp_path'/tt5"
append using "`temp_path'/tt6"
append using "`temp_path'/tt7"
append using "`temp_path'/tt8"
append using "`temp_path'/tt9"

save "`output_path'/wtp_anglers.dta", replace

// You can try to plot the densities here, but R is FAR SUPERIOR.
// Stata, for example, cannot easily truncate a figure to not plot outliers. Come on.
/*
kdensity st_wtp if run==1, addplot(kdensity st_wtp if run==2 || ///
			kdensity st_wtp if run==4 || ///
			kdensity st_wtp if run==5 || ///
			kdensity st_wtp if run==6 || ///
			kdensity lt_wtp if run==1, clpattern(dash) || ///
			kdensity lt_wtp if run==2, clpattern(dash) || ///
			kdensity lt_wtp if run==4, clpattern(dash) || ///
			kdensity lt_wtp if run==5, clpattern(dash) || ///
			kdensity lt_wtp if run==6, clpattern(dash) ) ///
			legend(ring(0) pos(2) label(1 "No Restriction") label(2 "Day Trip Only") ///
			label(3 "Distance error less than 100 miles") label(4 "Positive Trips") ///
			label(5 "Quadratic Preferences") ///
			label(6 "Long Term No Restriction") ///
			label(7 "Long Term Day Trip Only") ///
			label(8 "Long Term Distance error less than 100 miles") ///
			label(9 "Long Term Positive Trips") ///
			label(10 "Long Term Quadratic Preferences")) 


