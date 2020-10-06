* Download the osrm package from:
* https://www.uni-regensburg.de/wirtschaftswissenschaften/vwl-moeller/forschung/index.html

local osrm_location "C:\Users\black.michael\Documents\OSRMTIME"
cd "`osrm_location'"
net install osrmtime 
net get osrmtime
shell osrminstall.cmd
// Note that on Windows computers, you will need to press any key after the shell prompt

// Prepare OSRM Map
osrmprepare, mapfile("C:\Users\black.michael\Documents\OSRMTIME\texaslatest.osm.pbf") ///
		osrmdir("`osrm_location'") profile(car)
