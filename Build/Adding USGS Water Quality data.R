## Add water quality data from USGS

library(readstata13)
library(dplyr)
library(tidyr)
library(usmap)
library(ggmap)
library(rworldmap)
library(ggplot2)
library(geosphere)
library(foreign)

fishloc <- read.dta13("G:/My Drive/Research/RecDemandWQ/Build/Temp/fishgps.dta")
fishloc <- fishloc %>%
  select(gps) %>%
  separate(gps, c("flat","flon"), sep=", ")

usgs_sids <- read.csv2("G:/My Drive/Research/RecDemandWQ/Build/Input/NWQC_TX_lakes_station.csv", header=T, sep=",")
usgs_sids <- usgs_sids %>%
  select(gs_sid=MonitoringLocationIdentifier,gs_lat=LatitudeMeasure,gs_lon=LongitudeMeasure)

fishloc$useless <- 1
usgs_sids$useless <- 1
total <- full_join(fishloc, usgs_sids, by = "useless") %>%
  select(-useless)

total$flat <- as.numeric(total$flat)
total$flon <- as.numeric(total$flon)
total$gs_lat <- as.numeric(as.character(total$gs_lat))
total$gs_lon <- as.numeric(as.character(total$gs_lon))

total$distance <- distGeo(matrix(c(total$flon,total$flat),ncol=2),matrix(c(total$gs_lon,total$gs_lat),ncol=2))
total$distance <- total$distance*0.000621371

gs_stations <- total %>%
  filter(distance<=5) %>%
  mutate(new_lat=flat,new_lon=flon) %>%
  select(gs_sid,new_lat,new_lon)
  
## Bring in WQ data
# Note that the USGS pcodes of interest are: DO=300, SC=95, ph=400, trans=49701(ft),90077(in),78(in),79(m)

usgs_physchem <- read.csv2("G:/My Drive/Research/RecDemandWQ/Build/Input/NWQC_TX_lakes_physchem.csv", header=T, sep=",")
physchem <- usgs_physchem %>%
  select(gs_sid=MonitoringLocationIdentifier,date=ActivityStartDate,param_name=CharacteristicName,pcode=USGSPCode,value=ResultMeasureValue) %>%
  filter(pcode %in% c(300,95,400,49701,90077,78,79))

# Strangely, the physchem and bio datasets are idential in parameters of interest
# usgs_bio <- read.csv2("G:/My Drive/Research/RecDemandWQ/Build/Input/NWQC_TX_lakes_bio.csv", header=T, sep=",")
# bio <- usgs_bio %>%
#   select(gs_sid=MonitoringLocationIdentifier,date=ActivityStartDate,param_name=CharacteristicName,pcode=USGSPCode,value=ResultMeasureValue) %>%
#   filter(pcode %in% c(300,95,400,49701,90077,78,79))

usgs_wq <- inner_join(gs_stations,physchem, by="gs_sid")
usgs_wq$date <- as.character(usgs_wq$date)
usgs_wq$pcode <- as.numeric(usgs_wq$pcode)
usgs_wq$value <- as.numeric(as.character(usgs_wq$value))

write.dta(usgs_wq, "G:/My Drive/Research/RecDemandWQ/Build/Input/usgs_wq.dta")