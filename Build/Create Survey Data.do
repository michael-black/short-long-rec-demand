* This do-file creates .dta files from the raw data obtained from Ditton and team.

* Also note that in some years, race is described over several binary questions (e.g. white | black | indian | etc.).
* In later years, race is captured in two categorical variables: spanish | race.
* I can proceed in two ways: 1) create a single categorical variable for race; 2) create several binary variables.
* On December 6, 2017, I proceed by creating a single categorical variable for race with the following format:
* spanish=1
* white=2
* black=3
* natamer=4
* asian=5
* othrac=6

* Finally, variables should have the following format:
* date		float	%9s
* wherein		str42	%150s
* zipcode		str10	%10s
* age			byte	%8.0g
* gender		byte	%8.0g
* income		byte	%8.0g
* race		float	%9.0g

local path2001 "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/Ditton2001"
local path2004 "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/Ditton2004"
local path2009 "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/Ditton 2009"
local path2012 "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/2012"
local path2015 "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Input/2015"
local temp_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Temp"
local output_path "/Volumes/GoogleDrive/My Drive/Research/RecDemandWQ/Build/Output"

*2001
clear
cd "`path2001'"
import delimited "Survey2001_with_Zip.csv", encoding(ISO-8859-1)
keep wherein age gender income spanish spanishid white black indian asian othrac zipcode month tripday preffw1 pub1 totdayfw ///
			tankday lakeboat lakepier boatriv rivpier totcost miles
rename pub1 mostoft
rename totdayfw tripcount
rename	tankday trips_ponds
rename	lakeboat trips_lakesb
rename	lakepier trips_lakess
rename	boatriv trips_riversb
rename	rivpier trips_riverss
rename totcost reportcost
rename miles reportdist
gen date=2001
gen race=1 if spanish==2
replace race=2 if white==1
replace race=3 if black==1
replace race=4 if indian==1
replace race=5 if asian==1
replace race=6 if othrac==1
drop spanish spanishid white black indian asian othrac
preserve
clear
***Note that for 2001, locations were coded. I decode the "wherein" variable here:
import excel "location decoder.xlsx", sheet("pub") firstrow
rename CODE wherein
rename NAMEOFLAKEORRIVER fishlocname
save "locdecode.dta", replace
clear
restore
merge m:m wherein using "locdecode.dta"
drop _merge
drop wherein
rename fishlocname wherein1
*** Now decode the "mostoft" variable:
rename mostoft wherein
merge m:m wherein using "locdecode.dta"
drop _merge
drop wherein
rename fishlocname mostoft
rename wherein1 wherein
order date wherein  mostoft zipcode age gender income race
*Make sure formatting is consistent
recast str42 wherein
recast str42 mostoft
drop if missing(zipcode)
tostring zipcode, gen(zipcode2)
drop zipcode
rename zipcode2 zipcode
recast str10 zipcode
*Create fish preference indicators
gen catfish=1 if inlist(preffw1, 81, 1069, 86, 91, 449)
replace catfish=0 if missing(catfish)
drop preffw1
*Make reported cost a numeric variable
replace reportcost = subinstr(reportcost, "$", "", .)
replace reportcost = subinstr(reportcost, ",", "", .)
destring reportcost, replace
save "`temp_path'/TSAS_2001.dta", replace
clear

*2004
clear all
cd "`path2004'"
import delimited "2004_fw_data_zip.csv", encoding(ISO-8859-1)
keep q32wherein q37age q38gender q39income q40origin q40spanishid q41white /// 
			q41black q41indian q41asian q41othrac zipcode q29month q31tripday q15fishfw1 q10pub q9daysumfw ///
			q9tankday q9lakeboat q9lakepier q9boatriv q9rivpier q33totcost q30miles
gen date=2004
rename	q32wherein	wherein
rename	q10pub	mostoft
rename	q37age	age
rename	q38gender	gender
rename	q39income	income
rename	q40origin	spanish
rename	q40spanishid	spanishid
rename	q41white	white
rename	q41black	black
rename	q41indian	indian
rename	q41asian	asian
rename	q41othrac	othrac
rename	zipcode	zipcode
rename  q29month month
rename  q31tripday tripday
rename	q9daysumfw	tripcount
rename	q9tankday trips_ponds
rename	q9lakeboat trips_lakesb
rename	q9lakepier trips_lakess
rename	q9boatriv trips_riversb
rename	q9rivpier trips_riverss
rename q33totcost reportcost
rename q30miles reportdist
*Now generate race variable
gen race=1 if spanish==2
replace race=2 if white==1
replace race=3 if black==1
replace race=4 if indian==1
replace race=5 if asian==1
replace race=6 if othrac==1
drop spanish spanishid white black indian asian othrac
order date wherein zipcode age gender income race
*Make sure formatting is consistent
replace wherein = subinstr(wherein, " ", "", .)
replace mostoft = subinstr(mostoft, " ", "", .)
recast str42 wherein
*Create fish preference indicators
rename q15fishfw1 fishpref
replace fishpref=subinstr(fishpref, " ", "", .)
compress
gen catfish=1 if inlist(fishpref, "Appl. Blue Cat", "Blue Catfish", "Catfish", /// 
		"Catfish (any)", "Cats", "Channel Catfish", "Yellow Catfish")
replace catfish=0 if missing(catfish)
*Format reportcost as double
recast double reportcost
save "`temp_path'/TSAS_2004.dta", replace
clear


*2009
clear all
cd "`path2009'"
import delimited "2009 Statewide Angler Survey_Files_MAB.csv", encoding(ISO-8859-1)
keep q33wherein q37age q38gender q39income q40origin q40spanishid q41white ///
		q41black q41indian q41asian q41othrac q41raceid zipcode q30month q32tripday q16fishfw1 q12pubwaterbody q11daysumfw ///
		q11tankday q11lakeboat q911lakepier q11boatriv q11rivpier q34totcost q31miles
gen date=2009
rename	q33wherein	wherein
rename	q12pubwaterbody mostoft
rename	q37age	age
rename	q38gender	gender
rename	q39income	income
rename	q40origin	spanish
rename	q40spanishid	spanishid
rename	q41white	white
rename	q41black	black
rename	q41indian	indian
rename	q41asian	asian
rename	q41othrac	othrac
rename	q41raceid	raceid
rename	zipcode	zipcode
rename  q30month month
rename  q32tripday tripday
rename	q11daysumfw tripcount
rename	q11tankday trips_ponds
rename	q11lakeboat trips_lakesb
rename	q911lakepier trips_lakess
rename	q11boatriv trips_riversb
rename	q11rivpier trips_riverss
rename q34totcost reportcost
rename q31miles reportdist
*Now generate race variable
gen race=1 if spanish==2
replace race=2 if white==1
replace race=3 if black==1
replace race=4 if indian==1
replace race=5 if asian==1
replace race=6 if othrac==1
drop spanish spanishid white black indian asian othrac raceid
order date wherein zipcode age gender income race
*Make sure formatting is consistent
tostring zipcode, gen(zipcode2)
drop zipcode
rename zipcode2 zipcode
recast str10 zipcode
replace month="" if month=="-9"
replace month="" if month=="Spring"
replace month="" if month=="varies"
replace month="" if month=="all year"
destring month, replace
*Create fish preference indicators
rename q16fishfw1 fishpref
replace fishpref="" if inlist(fishpref, "--9", "-9")
destring fishpref, replace
gen catfish=1 if inlist(fishpref, 81, 1069, 86, 91)
replace catfish=0 if missing(catfish)
drop fishpref
* Format reported cost as double
recast double reportcost
save "`temp_path'/TSAS_2009.dta", replace

*2012
clear all
cd "`path2012'"
import delimited "2012_TPWD_SAMPLE_AGE_CODED_WEIGHTED.csv", encoding(ISO-8859-1)
keep a34_text a37 a38 a39 a40 a40_text a41 a41_text a42_1_text a31 a33 a18_5_group a18_6_group a18_7_group a15 a14_1 a14_2 a14_3 a14_4 a14_5 ///
		a35_1 a35_2 a35_3 a35_4 a35_5 a35_6 a35_7 a35_8 a35_9 a35_10 a35_11 a32
gen date=2012
rename	a34_text	wherein
rename	a15	mostoft
rename	a37	age
rename	a38	gender
rename	a39	income
rename	a40 spanish
rename	a41 raceid
rename	a42_1_text zipcode
rename	a31 month
rename	a33 tripday
rename	a14_1 trips_ponds
rename	a14_2 trips_lakesb
rename	a14_3 trips_lakess
rename	a14_4 trips_riversb
rename	a14_5 trips_riverss
rename a32 reportdist
replace reportdist="" if reportdist=="1--4"
replace reportdist="" if reportdist=="1---8"
destring reportdist, replace
local trips "trips_ponds trips_lakesb trips_lakess trips_riversb trips_riverss"
foreach x of local trips{
	gen `x'_2=real(`x')
	drop `x'
	rename `x'_2 `x'
}
*Now generate race variable, this year we have the raceid variable
gen race=1 if spanish==2
replace race=2 if raceid==1
replace race=3 if raceid==2
replace race=4 if raceid==3
replace race=5 if raceid==4
replace race=6 if raceid==5
drop spanish raceid a40_text a41_text
order date wherein zipcode age gender income race
*Make sure formatting is consistent
recast str42 wherein
recast str42 mostoft
replace age = subinstr(age, ",", "", .)
destring age, gen(age2)
drop age
rename age2 age
replace age=. if inlist(age, 999, 1960)
recast byte age
replace income=. if inlist(income, 99, 999)
recast byte income
recast byte gender
replace tripday="1.5" if tripday=="1--2"
replace tripday="1.5" if tripday=="1 or 2"
replace tripday="3.5" if tripday=="2 to 5"
replace tripday="2.5" if tripday=="1---4"
replace tripday="0.1" if tripday=="2hours"
replace tripday="0.5" if tripday=="less than 1"
replace tripday="3.5" if tripday=="3 to 4"
destring tripday, replace
*recast byte tripday
*Create fishing preference indicator
gen catfish=1 if a18_5_group==1 | a18_6_group==1 | a18_7_group==1
replace catfish=0 if missing(catfish)
* Generate and format reported costs
local costqs "1 2 3 4 5 6 7 8 9 10 11"
foreach x of local costqs{
	replace a35_`x' = subinstr(a35_`x', ",", "", .)
	replace a35_`x' = "0.00" if a35_`x' == "99999.00"
	destring a35_`x', replace
	recast double a35_`x'
	replace a35_`x' = 0 if inlist(a35_`x', -9, 999, 9999, 99999)
}
gen reportcost = a35_1 + a35_2 + a35_3 + a35_4 + a35_5 + a35_6 + a35_7 + a35_8 + a35_9 + a35_10 + a35_11
drop a35_*
save "`temp_path'/TSAS_2012.dta", replace
clear

*2015
clear all
cd "`path2015'"
import delimited "tpwd_statewide_2015_shortlabels.csv", encoding(ISO-8859-1)
keep typicaltripwaterbody yourageyears yourgender1male2female yourhouseholdincomebeforetaxes /// 
		areyouofspanishhispanicorigin areyouofspanishhispanicoriginspe yourracewhite /// 
		yourraceblackorafricanamerican yourraceamericanindianoralaskann yourraceasianorpacificislander /// 
		yourracesomeotherrace yourracesomeotherracespecify homeaddresszipcode typicaltripmonthofyear /// 
		typicaltripdaysonthetrip freshwatermostpreferredchannelca freshwatermostpreferredbluecatfi /// 
		freshwatermostpreferredflatheadc nameofpublicwaterbodywhereyoufis mostrecenttripwaterbody ///
		freshwaterponddays freshwaterlakedaysboat freshwaterlakedaysshore freshwaterriverdaysboat ///
		freshwaterriverdaysshore ///
		typicaltripspendingautomobiletra typicaltripspendingothertranspor typicaltripspendingboatrental ///
		typicaltripspendingboatoperation typicaltripspendingboatlaunchfee typicaltripspendingentranceparki ///
		typicaltripspendinglodging typicaltripspendingfooddrinksice typicaltripspendingbaittackle ///
		typicaltripspendingcharterorguid typicaltripspendinganythingelsef typicaltriponewaymilestraveled
gen date=2015
rename	typicaltripwaterbody	wherein
rename	nameofpublicwaterbodywhereyoufis	mostoft
rename	mostrecenttripwaterbody mostrecent
rename	yourageyears	age
rename	yourgender1male2female	gender
rename	yourhouseholdincomebeforetaxes	income
rename	areyouofspanishhispanicorigin	spanish
rename	areyouofspanishhispanicoriginspe	spanishid
rename	yourracewhite	white
rename	yourraceblackorafricanamerican	black
rename	yourraceamericanindianoralaskann	indian
rename	yourraceasianorpacificislander	asian
rename	yourracesomeotherrace	othrac
rename	yourracesomeotherracespecify	raceid
rename	homeaddresszipcode	zipcode
rename  typicaltripmonthofyear month
rename  typicaltripdaysonthetrip tripday
rename 	freshwaterponddays trips_ponds
rename	freshwaterlakedaysboat trips_lakesb
rename	freshwaterlakedaysshore trips_lakess
rename	freshwaterriverdaysboat trips_riversb
rename	freshwaterriverdaysshore trips_riverss
rename typicaltripspendingautomobiletra cost1
rename typicaltripspendingothertranspor cost2
rename typicaltripspendingboatrental cost3
rename typicaltripspendingboatoperation cost4
rename typicaltripspendingboatlaunchfee cost5
rename typicaltripspendingentranceparki cost6
rename typicaltripspendinglodging cost7
rename typicaltripspendingfooddrinksice cost8 
rename typicaltripspendingbaittackle cost9
rename typicaltripspendingcharterorguid cost10
rename typicaltripspendinganythingelsef cost11
rename typicaltriponewaymilestraveled reportdist
*Now generate race variable
gen race=1 if spanish==2
replace race=2 if white==1
replace race=3 if black==1
replace race=4 if indian==1
replace race=5 if asian==1
replace race=6 if othrac==1
drop spanish spanishid white black indian asian othrac raceid
order date wherein zipcode age gender income race
*Make sure formatting is consistent
replace wherein = subinstr(wherein, " ", "", .)
replace mostoft = subinstr(mostoft, " ", "", .)
replace mostrecent = subinstr(mostrecent, " ", "", .)
recast str42 wherein
recast str42 mostoft
recast str42 mostrecent
tostring zipcode, gen(zipcode2)
drop zipcode
rename zipcode2 zipcode
recast str10 zipcode
gen month_num=month(date(month,"M"))
drop month
rename month_num month
* Create fishing preferences indicator
gen catfish=1 if freshwatermostpreferredchannelca==1 | freshwatermostpreferredbluecatfi==1 | ///
	freshwatermostpreferredflatheadc==1
replace catfish=0 if missing(catfish)
* Generate and format reported costs
local costqs "1 2 3 4 5 6 7 8 9 10 11"
foreach x of local costqs{
	recast double cost`x'
	replace cost`x' = 0 if inlist(cost`x', -9, 999, 9999, 99999)
}
gen reportcost = cost1 + cost2 + cost3 + cost4 + cost5 + cost6 + cost7 + cost8 + cost9 + cost10 + cost11
drop cost*
save "`temp_path'/TSAS_2015.dta", replace
clear

/* 
Now all survey responses should be in the same format. Next, I append all surveys into one dataset:
*/

clear all
cd "`temp_path'"
use "TSAS_2001.dta"
local years "2004 2009 2012 2015"
foreach x of local years{
	append using "TSAS_`x'.dta"
}

/*
You now have all TSAS surveys appended into one database. Now all characters and spaces from wherein must be removed for matching.
*/
replace wherein = subinstr(wherein, "/", "", .)
replace wherein = subinstr(wherein, " ", "", .)
replace wherein = subinstr(wherein, "-", "", .)
replace wherein = subinstr(wherein, ".", "", .)
replace wherein = subinstr(wherein, "&", "", .)
replace wherein = subinstr(wherein, "(", "", .)
replace wherein = subinstr(wherein, ")", "", .)
replace wherein = subinstr(wherein, ",", "", .)
replace wherein = subinstr(wherein, "'", "", .)
replace wherein=proper(wherein)

replace mostoft = subinstr(mostoft, "/", "", .)
replace mostoft = subinstr(mostoft, " ", "", .)
replace mostoft = subinstr(mostoft, "-", "", .)
replace mostoft = subinstr(mostoft, ".", "", .)
replace mostoft = subinstr(mostoft, "&", "", .)
replace mostoft = subinstr(mostoft, "(", "", .)
replace mostoft = subinstr(mostoft, ")", "", .)
replace mostoft = subinstr(mostoft, ",", "", .)
replace mostoft = subinstr(mostoft, "'", "", .)
replace mostoft=proper(mostoft)

replace mostrecent = subinstr(mostrecent, "/", "", .)
replace mostrecent = subinstr(mostrecent, " ", "", .)
replace mostrecent = subinstr(mostrecent, "-", "", .)
replace mostrecent = subinstr(mostrecent, ".", "", .)
replace mostrecent = subinstr(mostrecent, "&", "", .)
replace mostrecent = subinstr(mostrecent, "(", "", .)
replace mostrecent = subinstr(mostrecent, ")", "", .)
replace mostrecent = subinstr(mostrecent, ",", "", .)
replace mostrecent = subinstr(mostrecent, "'", "", .)
replace mostrecent=proper(mostrecent)

compress mostoft wherein mostrecent
*Now save this dataset, which is ready to merge
save "`output_path'/TSAStotal.dta", replace

/*
The survey data has many spelling errors, either because of data entry or respondent error.
Because of this, the following establishes one correct spelling for each fishing location. 
It is not elegant, but it allows for easier analysis later
*/
local dest "wherein mostoft mostrecent"
foreach x of local dest{
	sort `x'
	replace	`x'	=	"Amistad"	if 	`x'	==	"Amistadlake"
	replace	`x'	=	"Amistad"	if 	`x'	==	"Amistaid"
	replace	`x'	=	"Amistad"	if 	`x'	==	"Amistadresevoir"
	replace	`x'	=	"Amoncarter"	if 	`x'	==	"Amongcarter"
	replace	`x'	=	"Angelinariver"	if 	`x'	==	"Angelinasamrayburn"
	replace	`x'	=	"Amoncarter"	if 	`x'	==	"Anongcarter"
	replace	`x'	=	"Aquillalake"	if 	`x'	==	"Aquilla"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Aransas"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Aransasbay"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Aransaspass"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Arkansaspass"
	replace	`x'	=	"Arlington"	if 	`x'	==	"Arlingtonlake"
	replace	`x'	=	"Amoncarter"	if 	`x'	==	"Armoncarterlake"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Aroundaransaspass"
	replace	`x'	=	"Arroyocity"	if 	`x'	==	"Arroyo"
	replace	`x'	=	"Athenslake"	if 	`x'	==	"Athens"
	replace	`x'	=	"Baffin"	if 	`x'	==	"Baffinbay"
	replace	`x'	=	"Baffin"	if 	`x'	==	"Baffonbay"
	replace	`x'	=	"Bardwelllake"	if 	`x'	==	"Bardwellorpurtiscreeklake"
	replace	`x'	=	"Bastrop"	if 	`x'	==	"Bastroplake"
	replace	`x'	=	"Belton"	if 	`x'	==	"Beltonlake"
	replace	`x'	=	"Benbrook"	if 	`x'	==	"Benbrooklake"
	replace	`x'	=	"Blanco"	if 	`x'	==	"Blancoriver"
	replace	`x'	=	"Bocachica"	if 	`x'	==	"Bocachicabeach"
	replace	`x'	=	"Baffin"	if 	`x'	==	"Boffin"
	replace	`x'	=	"Bonham"	if 	`x'	==	"Bonhamstatepark"
	replace	`x'	=	"Bosque"	if 	`x'	==	"Bosqueriver"
	replace	`x'	=	"Bosque"	if 	`x'	==	"Bosqueriverabovelakewaco"
	replace	`x'	=	"Brady"	if 	`x'	==	"Bradylake"
	replace	`x'	=	"Brady"	if 	`x'	==	"Brandybranch"
	replace	`x'	=	"Brady"	if 	`x'	==	"Brandybranchres"
	replace	`x'	=	"Brady"	if 	`x'	==	"Bradyresevoir"
	replace	`x'	=	"Braunig"	if 	`x'	==	"Brauniglake"
	replace	`x'	=	"Braunig"	if 	`x'	==	"Rrauning"
	replace	`x'	=	"Brazosriver"	if 	`x'	==	"Brazosriver"
	replace	`x'	=	"Brazosriver"	if 	`x'	==	"Brazos"
	replace	`x'	=	"Brazosriver"	if 	`x'	==	"Brazosrivergranburylakeweatherfodlake"
	replace	`x'	=	"Brazosriver"	if 	`x'	==	"Brazosriverwhitney"
	replace	`x'	=	"Bridgeport"	if 	`x'	==	"Bridgport"
	replace	`x'	=	"Brownwood"	if 	`x'	==	"Brownwoodlake"
	replace	`x'	=	"Brushycreekhuttotx"	if 	`x'	==	"Brushycreekhuttotx"
	replace	`x'	=	"Brushycreekhuttotx"	if 	`x'	==	"Brushycreek"
	replace	`x'	=	"Lakebryan"	if 	`x'	==	"Bryan"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Buchananlake"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Buchannan"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Buchanon"
	replace	`x'	=	"Bueochesatateponklake"	if 	`x'	==	"Buescherlake"
	replace	`x'	=	"Bueochesatateponklake"	if 	`x'	==	"Buescherpark"
	replace	`x'	=	"Bueochesatateponklake"	if 	`x'	==	"Buesherandriver"
	replace	`x'	=	"Bueochesatateponklake"	if 	`x'	==	"Buescherstatepark"
	replace	`x'	=	"Buffalobayou"	if 	`x'	==	"Buffalocampbayou"
	replace	`x'	=	"Caddo"	if 	`x'	==	"Caddolake"
	replace	`x'	=	"Caddo"	if 	`x'	==	"Caddolakestatepark"
	replace	`x'	=	"Caddo"	if 	`x'	==	"Caddonatlgrasslands"
	replace	`x'	=	"Calavareaslake"	if 	`x'	==	"Calaveras"
	replace	`x'	=	"Calavareaslake"	if 	`x'	==	"Calaveraslake"
	replace	`x'	=	"Canyondamoncanyonlake"	if 	`x'	==	"Canyon"
	replace	`x'	=	"Canyondamoncanyonlake"	if 	`x'	==	"Canyondam"
	replace	`x'	=	"Canyondamoncanyonlake"	if 	`x'	==	"Canyondamoncanyonlake"
	replace	`x'	=	"Canyondamoncanyonlake"	if 	`x'	==	"Canyonlake"
	replace	`x'	=	"Cedarcreek"	if 	`x'	==	"Cedarcreekandbardwell"
	replace	`x'	=	"Cedarcreek"	if 	`x'	==	"Cedarcreeklake"
	replace	`x'	=	"Cedarcreek"	if 	`x'	==	"Cedarcreekreservoir"
	replace	`x'	=	"Champion"	if 	`x'	==	"Championcreek"
	replace	`x'	=	"Champion"	if 	`x'	==	"Championcreekresevoir"
	replace	`x'	=	"Choke"	if 	`x'	==	"Choc"
	replace	`x'	=	"Choke"	if 	`x'	==	"Chokecanyon"
	replace	`x'	=	"Choke"	if 	`x'	==	"Chokecanyonreservoir"
	replace	`x'	=	"Citylake"	if 	`x'	==	"Citylakemarlin"
	replace	`x'	=	"Clearlake"	if 	`x'	==	"Clearlakearea"
	replace	`x'	=	"Coffeemilllake"	if 	`x'	==	"Coffeemill"
	replace	`x'	=	"Coletocreek"	if 	`x'	==	"Coletocreekreservoir"
	replace	`x'	=	"Coletocreek"	if 	`x'	==	"Coletolake"
	replace	`x'	=	"Coletocreek"	if 	`x'	==	"Coletoresivor"
	replace	`x'	=	"Coletocreek"	if 	`x'	==	"Coletocreekresevoir"
	replace	`x'	=	"Colorado"	if 	`x'	==	"Coloradoriver"
	replace	`x'	=	"Coloradobend"	if 	`x'	==	"Coloradobendstatepark"
	replace	`x'	=	"Comacriver"	if 	`x'	==	"Comelriver"
	replace	`x'	=	"Conroe"	if 	`x'	==	"Conrof"
	replace	`x'	=	"Cooper"	if 	`x'	==	"Cooperlake"
	replace	`x'	=	"Cooper"	if 	`x'	==	"Cooperlakedam"
	replace	`x'	=	"Cooper"	if 	`x'	==	"Cooperlakestatepark"
	replace	`x'	=	"Copanobay"	if 	`x'	==	"Coponobaffin"
	replace	`x'	=	"Decker"	if 	`x'	==	"Deckerlake"
	replace	`x'	=	"Devilsriver"	if 	`x'	==	"Devrlsriver"
	replace	`x'	=	"Eaglemountain"	if 	`x'	==	"Eaglemountainlake"
	replace	`x'	=	"Eaglemountain"	if 	`x'	==	"Eaglemountian"
	replace	`x'	=	"Eaglemountain"	if 	`x'	==	"Eaglenestlake"
	replace	`x'	=	"Fairfield"	if 	`x'	==	"Fairfieldlake"
	replace	`x'	=	"Falcon"	if 	`x'	==	"Falconlake"
	replace	`x'	=	"Falcon"	if 	`x'	==	"Falconlane"
	replace	`x'	=	"Falcon"	if 	`x'	==	"Falconinternationalresevoir"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayetteville"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettevillereservoir"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettville"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettvillelake"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayette"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettecounty"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettecountyresevoir"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Fayettecountyresourvor"
	replace	`x'	=	"Freeport"	if 	`x'	==	"Freeportgalveston"
	replace	`x'	=	"Freeport"	if 	`x'	==	"Freeportjetty"
	replace	`x'	=	"Georgetownlake"	if 	`x'	==	"Georgetown"
	replace	`x'	=	"Gibbonscreek"	if 	`x'	==	"Gibbonscreekreservoir"
	replace	`x'	=	"Gladewaterlake"	if 	`x'	==	"Gladewater"
	replace	`x'	=	"Gonzaleslake"	if 	`x'	==	"Gonzales"
	replace	`x'	=	"Granbury"	if 	`x'	==	"Granburylake"
	replace	`x'	=	"Granbury"	if 	`x'	==	"Grandbury"
	replace	`x'	=	"Grangelake"	if 	`x'	==	"Granger"
	replace	`x'	=	"Greenbelt"	if 	`x'	==	"Greenbeltlake"
	replace	`x'	=	"Greenbelt"	if 	`x'	==	"Greenbeltresevoir"
	replace	`x'	=	"Greenbelt"	if 	`x'	==	"Greenvilleresevoirs"
	replace	`x'	=	"Gradaluperiver"	if 	`x'	==	"Guadalupe"
	replace	`x'	=	"Gradaluperiver"	if 	`x'	==	"Guadaluperiver"
	replace	`x'	=	"Hawkinslake"	if 	`x'	==	"Hawkins"
	replace	`x'	=	"Highlandsreservoir"	if 	`x'	==	"Highlandsnorthponds"
	replace	`x'	=	"Highlandsreservoir"	if 	`x'	==	"Highlandsresevoir"
	replace	`x'	=	"Hordscreek"	if 	`x'	==	"Horoscreek"
	replace	`x'	=	"Hordscreek"	if 	`x'	==	"Hordscreeklake"
	replace	`x'	=	"Houston"	if 	`x'	==	"Houstoncounty"
	replace	`x'	=	"Houston"	if 	`x'	==	"Houstoncountylake"
	replace	`x'	=	"Hubbard"	if 	`x'	==	"Hubbardcreek"
	replace	`x'	=	"Hubbard"	if 	`x'	==	"Hubbardcreekallenhenry"
	replace	`x'	=	"Hubbard"	if 	`x'	==	"Hubbardcreeklake"
	replace	`x'	=	"Hubbard"	if 	`x'	==	"Hubbardcreekreservoir"
	replace	`x'	=	"Huntsvillepark"	if 	`x'	==	"Hunstvillestatepark"
	replace	`x'	=	"Inks"	if 	`x'	==	"Inkslake"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Ivie"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Iviereservoir"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Ivy"
	replace	`x'	=	"Jacksboro"	if 	`x'	==	"Jacksborolake"
	replace	`x'	=	"Joepool"	if 	`x'	==	"Joepoole"
	replace	`x'	=	"Joepool"	if 	`x'	==	"Joepoollake"
	replace	`x'	=	"Ladybirdlake"	if 	`x'	==	"Ladybirdjohnsonmunicipalpark"
	replace	`x'	=	"Ladybirdlake"	if 	`x'	==	"Ladybirdjohnsonparkresevoir"
	replace	`x'	=	"Ladybirdlake"	if 	`x'	==	"Ladybirdlakeaustintx"
	replace	`x'	=	"Lagunamadre"	if 	`x'	==	"Laguna"
	replace	`x'	=	"Lagunamadre"	if 	`x'	==	"Lagunabay"
	replace	`x'	=	"Lagunamadre"	if 	`x'	==	"Lagunnamadre"
	replace	`x'	=	"Alanhenry"	if 	`x'	==	"Lakealanhenny"
	replace	`x'	=	"Alanhenry"	if 	`x'	==	"Lakealanhenry"
	replace	`x'	=	"Amistad"	if 	`x'	==	"Lakeamistad"
	replace	`x'	=	"Amoncarter"	if 	`x'	==	"Lakeamoncarter"
	replace	`x'	=	"Amoncarter"	if 	`x'	==	"Lakeamongcarter"
	replace	`x'	=	"Aquillalake"	if 	`x'	==	"Lakeaquilla"
	replace	`x'	=	"Arlington"	if 	`x'	==	"Lakearlington"
	replace	`x'	=	"Athenslake"	if 	`x'	==	"Lakeathens"
	replace	`x'	=	"Bastrop"	if 	`x'	==	"Lakebastrop"
	replace	`x'	=	"Bastrop"	if 	`x'	==	"Lakebastvp"
	replace	`x'	=	"Belton"	if 	`x'	==	"Lakebelton"
	replace	`x'	=	"Bobsandlin"	if 	`x'	==	"Lakebobsandlin"
	replace	`x'	=	"Bobsandlin"	if 	`x'	==	"Lakebobsandline"
	replace	`x'	=	"Bonham"	if 	`x'	==	"Lakebonham"
	replace	`x'	=	"Bridgeport"	if 	`x'	==	"Lakebridgeport"
	replace	`x'	=	"Bridgeport"	if 	`x'	==	"Lakebridgeportrunawaybay"
	replace	`x'	=	"Brownwood"	if 	`x'	==	"Lakebrownwood"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Lakebucannon"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Lakebuchanan"
	replace	`x'	=	"Buchanan"	if 	`x'	==	"Lakebuchannan"
	replace	`x'	=	"Caddo"	if 	`x'	==	"Lakecaddo"
	replace	`x'	=	"Calavareaslake"	if 	`x'	==	"Lakecalaveras"
	replace	`x'	=	"Cantoncitylake"	if 	`x'	==	"Lakecanton"
	replace	`x'	=	"Coleman"	if 	`x'	==	"Lakecoleman"
	replace	`x'	=	"Conroe"	if 	`x'	==	"Lakeconroe"
	replace	`x'	=	"Cooper"	if 	`x'	==	"Lakecooper"
	replace	`x'	=	"Cypresssprings"	if 	`x'	==	"Lakecypresssprings"
	replace	`x'	=	"Falcon"	if 	`x'	==	"Lakefalcon"
	replace	`x'	=	"Fayeteville"	if 	`x'	==	"Lakefayette"
	replace	`x'	=	"Fork"	if 	`x'	==	"Lakefork"
	replace	`x'	=	"Fork"	if 	`x'	==	"Lakeforkcreek"
	replace	`x'	=	"Fork"	if 	`x'	==	"Lakeforkreservoir"
	replace	`x'	=	"Georgetownlake"	if 	`x'	==	"Lakegeorgetown"
	replace	`x'	=	"Glimerlake"	if 	`x'	==	"Lakegilmer"
	replace	`x'	=	"Grahamlake"	if 	`x'	==	"Lakegraham"
	replace	`x'	=	"Granbury"	if 	`x'	==	"Lakegranbury"
	replace	`x'	=	"Granbury"	if 	`x'	==	"Lakegranbvry"
	replace	`x'	=	"Granbury"	if 	`x'	==	"Lakegrandbury"
	replace	`x'	=	"Greenbelt"	if 	`x'	==	"Lakegreenbelt"
	replace	`x'	=	"Houston"	if 	`x'	==	"Lakehouston"
	replace	`x'	=	"Houston"	if 	`x'	==	"Lakehoustondame"
	replace	`x'	=	"Houston"	if 	`x'	==	"Lakehoustondamn"
	replace	`x'	=	"Hubbard"	if 	`x'	==	"Lakehubbard"
	replace	`x'	=	"Inks"	if 	`x'	==	"Lakeinks"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Lakeivie"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Lakeivy"
	replace	`x'	=	"Jacksboro"	if 	`x'	==	"Lakejacksboro"
	replace	`x'	=	"Jacksonvillelake"	if 	`x'	==	"Lakejacksonvile"
	replace	`x'	=	"Jacksonvillelake"	if 	`x'	==	"Lakejacksonville"
	replace	`x'	=	"Jbthomas"	if 	`x'	==	"Lakejbthomas"
	replace	`x'	=	"Joepool"	if 	`x'	==	"Lakejoepool"
	replace	`x'	=	"Lakelavon"	if 	`x'	==	"Lakelevon"
	replace	`x'	=	"Lakelimestone"	if 	`x'	==	"Lakeliveston"
	replace	`x'	=	"Lakelimestone"	if 	`x'	==	"Lakelinestone"
	replace	`x'	=	"Lakemcclellan"	if 	`x'	==	"Lakemclellan"
	replace	`x'	=	"Lakemurval"	if 	`x'	==	"Lakemurray"
	replace	`x'	=	"Lakemurval"	if 	`x'	==	"Lakemurvaul"
	replace	`x'	=	"Lakenocona"	if 	`x'	==	"Lakeoconner"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeofthepines"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeofthepines`"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeofthewoods"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Lakeohivie"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeopine"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeopines"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Lakeothepines"
	replace	`x'	=	"Lakepalestine"	if 	`x'	==	"Lakepalestinetx"
	replace	`x'	=	"Lakerayhubbad"	if 	`x'	==	"Lakerayhubbard"
	replace	`x'	=	"Lakerayroberts"	if 	`x'	==	"Lakeroberts"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Lakesomervillebelowdam"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Lakesomeville"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Lakesommerville"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Laketawakoni"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Laketawokani"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Laketawokoni"
	replace	`x'	=	"Laketexana"	if 	`x'	==	"Laketexananavidadriver"
	replace	`x'	=	"Laketexana"	if 	`x'	==	"Laketexanastatepark"
	replace	`x'	=	"Laketexana"	if 	`x'	==	"Laketexarkana"
	replace	`x'	=	"Laketexhoma"	if 	`x'	==	"Laketexoma"
	replace	`x'	=	"Laketexhoma"	if 	`x'	==	"Laketexome"
	replace	`x'	=	"Laketyler"	if 	`x'	==	"Laketylereast"
	replace	`x'	=	"LakewoodGonzalestx"	if 	`x'	==	"Lakewood"
	replace	`x'	=	"LakewoodGonzalestx"	if 	`x'	==	"Lakewoodgonzalestx"
	replace	`x'	=	"Lakewrightpatman"	if 	`x'	==	"Lakewrightpatrontn"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Landopines"
	replace	`x'	=	"Lakelavon"	if 	`x'	==	"Lavon"
	replace	`x'	=	"Lakelavon"	if 	`x'	==	"Lavondam"
	replace	`x'	=	"Lakelavon"	if 	`x'	==	"Lavonlake"
	replace	`x'	=	"Lakelbj"	if 	`x'	==	"Lbj"
	replace	`x'	=	"Lakelbj"	if 	`x'	==	"Lbjlake"
	replace	`x'	=	"Laketravis"	if 	`x'	==	"Lketravis"
	replace	`x'	=	"Mouthofsanbernardriver"	if 	`x'	==	"Mouthbernard"
	replace	`x'	=	"Lakemurval"	if 	`x'	==	"Mruvaul"
	replace	`x'	=	"Lakemurval"	if 	`x'	==	"Murval"
	replace	`x'	=	"Lakemurval"	if 	`x'	==	"Murvaul"
	replace	`x'	=	"Lakenacogdoches"	if 	`x'	==	"Nacogdoches"
	replace	`x'	=	"Navarro"	if 	`x'	==	"Navarromills"
	replace	`x'	=	"Neches"	if 	`x'	==	"Nechesriver"
	replace	`x'	=	"Neches"	if 	`x'	==	"Nuecesriver"
	replace	`x'	=	"Oakcreek"	if 	`x'	==	"Oakcreeklake"
	replace	`x'	=	"Ocfisherlake"	if 	`x'	==	"Ocfishernasworthy"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Ohivey"
	replace	`x'	=	"Ivey"	if 	`x'	==	"Ohivie"
	replace	`x'	=	"Palodurolake"	if 	`x'	==	"Paloduro"
	replace	`x'	=	"Pathayes"	if 	`x'	==	"Patmayes"
	replace	`x'	=	"Pathayes"	if 	`x'	==	"Patmayse"
	replace	`x'	=	"Pathayes"	if 	`x'	==	"Patmayselake"
	replace	`x'	=	"Lowerpecosriver"	if 	`x'	==	"Pecosriver"
	replace	`x'	=	"Pedernales"	if 	`x'	==	"Pedeneralesriver"
	replace	`x'	=	"Pedernales"	if 	`x'	==	"Pedernalesriver"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Pines"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransas"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransasarea"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransasbay"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransasbaygulfoutofingleside"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransasgulf"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransasjetty"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransaspass"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portaransastx"
	replace	`x'	=	"Portanoaraspass"	if 	`x'	==	"Portarkansas"
	replace	`x'	=	"Portlavaca"	if 	`x'	==	"Portlavacabay"
	replace	`x'	=	"Portoconner"	if 	`x'	==	"Portoconnerjettes"
	replace	`x'	=	"Portoconner"	if 	`x'	==	"Portoconnor"
	replace	`x'	=	"Portoconner"	if 	`x'	==	"Portoconnorjetty"
	replace	`x'	=	"Possumkingdom"	if 	`x'	==	"Possumkindom"
	replace	`x'	=	"Possumkingdom"	if 	`x'	==	"Possumkingdomlake"
	replace	`x'	=	"Lakeproctor"	if 	`x'	==	"Proctor"
	replace	`x'	=	"Lakeproctor"	if 	`x'	==	"Proctorlake"
	replace	`x'	=	"Lakesamrayburn"	if 	`x'	==	"Rayburn"
	replace	`x'	=	"Lakesamrayburn"	if 	`x'	==	"Rayburnlake"
	replace	`x'	=	"Lakesamrayburn"	if 	`x'	==	"Rayburntoleodbend"
	replace	`x'	=	"Lakerayhubbad"	if 	`x'	==	"Rayhubard"
	replace	`x'	=	"Lakerayhubbad"	if 	`x'	==	"Rayhubbard"
	replace	`x'	=	"Redriver"	if 	`x'	==	"Redrivertexoma"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richalndchambers"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richardchambers"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richlandchamberlake"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richlandchambers"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richlandchamberslake"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richlandchambersres"
	replace	`x'	=	"Lakerichlandchambers"	if 	`x'	==	"Richlandchambersreservoir"
	replace	`x'	=	"Rockpont"	if 	`x'	==	"Rockport"
	replace	`x'	=	"Rockpont"	if 	`x'	==	"Rockportaransasportmansfield"
	replace	`x'	=	"Rockpont"	if 	`x'	==	"Rockportportaransas"
	replace	`x'	=	"Rockpont"	if 	`x'	==	"Rockportportmansfield"
	replace	`x'	=	"Lakeproctor"	if 	`x'	==	"Roctorlake"
	replace	`x'	=	"RollOverpass"	if 	`x'	==	"Rolloverpass"
	replace	`x'	=	"RollOverpass"	if 	`x'	==	"Rolloverpassgalvestonco"
	replace	`x'	=	"Rockpont"	if 	`x'	==	"Rookport"
	replace	`x'	=	"Lakesabine"	if 	`x'	==	"Sabine"
	replace	`x'	=	"Lakesabine"	if 	`x'	==	"Sabinelake"
	replace	`x'	=	"Lakesabine"	if 	`x'	==	"Sabineorlittlecyress"
	replace	`x'	=	"Lakesabine"	if 	`x'	==	"Sabinepass"
	replace	`x'	=	"Lakesamrayburn"	if 	`x'	==	"Samrayburn"
	replace	`x'	=	"Lakesamrayburn"	if 	`x'	==	"Samrayburnlake"
	replace	`x'	=	"Sanantoniabay"	if 	`x'	==	"Sanantoniobay"
	replace	`x'	=	"Bobsandlin"	if 	`x'	==	"Sandlin"
	replace	`x'	=	"Sangabriel"	if 	`x'	==	"Sangabrielriver"
	replace	`x'	=	"Sanjacinotriver"	if 	`x'	==	"Sanjacintoriver"
	replace	`x'	=	"Sanjacinotriver"	if 	`x'	==	"Sanjacintoriverbehindlakehouston"
	replace	`x'	=	"Sanjacinotriver"	if 	`x'	==	"Sanjack"
	replace	`x'	=	"Sanjacinotriver"	if 	`x'	==	"Sanjacriver"
	replace	`x'	=	"Sanmarcosriver"	if 	`x'	==	"Sanmarcos"
	replace	`x'	=	"Sheldonlake"	if 	`x'	==	"Sheldon"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Somerville"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Somervillelake"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Sommervillelake"
	replace	`x'	=	"Bosque"	if 	`x'	==	"Southbosqueriver"
	replace	`x'	=	"Southllanoriverstatepark"	if 	`x'	==	"Southllamo"
	replace	`x'	=	"Southpadre"	if 	`x'	==	"Southpadreisland"
	replace	`x'	=	"Southpadre"	if 	`x'	==	"Southpadreislandbay"
	replace	`x'	=	"Southpadre"	if 	`x'	==	"Spadreisland"
	replace	`x'	=	"Springcreek"	if 	`x'	==	"Springcreeksanangelotx"
	replace	`x'	=	"Squawcreekresevoir"	if 	`x'	==	"Squawcreek"
	replace	`x'	=	"Lakestamford"	if 	`x'	==	"Stamfordlake"
	replace	`x'	=	"Lakestamford"	if 	`x'	==	"Stamfordtx"
	replace	`x'	=	"Lakestamford"	if 	`x'	==	"Stanford"
	replace	`x'	=	"Lakestamford"	if 	`x'	==	"Stanfordlake"
	replace	`x'	=	"Stillhouse"	if 	`x'	==	"Stillhousehollow"
	replace	`x'	=	"Stillhouse"	if 	`x'	==	"Stillhousehollowlake"
	replace	`x'	=	"Stillhouse"	if 	`x'	==	"Stillhousehollowreservoir"
	replace	`x'	=	"Stillhouse"	if 	`x'	==	"Stillhouselakelampasasriver"
	replace	`x'	=	"Lakesomerville"	if 	`x'	==	"Summerville"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Takowani"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Tawakani"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Tawakoni"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Tawankni"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Tawokonilake"
	replace	`x'	=	"Laketexhoma"	if 	`x'	==	"Texhoma"
	replace	`x'	=	"Laketexhoma"	if 	`x'	==	"Texoma"
	replace	`x'	=	"Lakeofpines"	if 	`x'	==	"Thepines"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toldeobend"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toledo"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toledobend"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toledobendlake"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toledobendreservoir"
	replace	`x'	=	"Easttoledobend"	if 	`x'	==	"Toledobendtx"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Towanka"
	replace	`x'	=	"Laketawakine"	if 	`x'	==	"Towokonilake"
	replace	`x'	=	"Tradehouselake"	if 	`x'	==	"Tradinghousecreek"
	replace	`x'	=	"Trinityriver"	if 	`x'	==	"Trintiyriver"
	replace	`x'	=	"Trinityriver"	if 	`x'	==	"Trintyriver"
	replace	`x'	=	"Lakewichita"	if 	`x'	==	"Wichita"
	replace	`x'	=	"Wolfcreekparkonlakelivingston"	if 	`x'	==	"Wolfcreekpark"
	replace	`x'	=	"Lakewrightpatman"	if 	`x'	==	"Wrightpatman"
	replace	`x'	=	"Lakewrightpatman"	if 	`x'	==	"Wrightpatmanlake"
}

drop fishpref a18_5_group a18_6_group a18_7_group freshwatermostpreferredchannelca /// 
	freshwatermostpreferredbluecatfi freshwatermostpreferredflatheadc

// Create trip counts
local trips "trips_ponds trips_lakesb trips_lakess trips_riversb trips_riverss tripcount"
foreach x of local trips{
	replace `x'=. if `x'==-9
	replace `x'=. if `x'==999
}
egen tripcount2=rsum(trips_ponds trips_lakesb trips_lakess trips_riversb trips_riverss)
replace tripcount=tripcount2 if missing(tripcount)
drop tripcount2	
	
save "`output_path'/TSAStotal.dta", replace

