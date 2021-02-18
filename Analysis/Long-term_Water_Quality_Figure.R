rm(list = ls())
pacman::p_load(readstata13, dplyr, tidyr, usmap, ggmap, rworldmap, ggplot2, mapproj, ggpubr)

setwd("<set working directory here>")

wq <- read.dta13("./Build/Output/WQfull.dta")
stations <- read.csv2("./Build/Input/stationlist.csv")
gps <- read.dta13("./Build/Input/FishLoc.dta")
wq <- inner_join(wq, stations)
wq <- inner_join(wq, gps) %>% select(sid, pcode, date, depth, wqval, org, segmentid, endtime, gps, loc)

usa <- map_data("state")
tx <- subset(usa, region %in% c("texas"))

DO <- wq %>%
  filter(pcode=="300") %>%
  group_by(gps) %>%
  summarise(value=mean(wqval, na.rm=T)) %>%
  separate(gps, c("lat","lon"), sep=", ")
DO$lat <- as.numeric(DO$lat)
DO$lon <- as.numeric(DO$lon)

Trans <- wq %>%
  filter(pcode=="78") %>%
  group_by(gps) %>%
  summarise(value=mean(wqval, na.rm=T)) %>%
  separate(gps, c("lat","lon"), sep=", ")
Trans$lat <- as.numeric(Trans$lat)
Trans$lon <- as.numeric(Trans$lon)

Cond <- wq %>%
  filter(pcode=="94") %>%
  group_by(gps) %>%
  summarise(value=log(mean(wqval, na.rm=T))) %>%
  separate(gps, c("lat","lon"), sep=", ")
Cond$lat <- as.numeric(Cond$lat)
Cond$lon <- as.numeric(Cond$lon)

pH <- wq %>%
  filter(pcode=="400") %>%
  group_by(gps) %>%
  summarise(value=mean(wqval, na.rm=T)) %>%
  separate(gps, c("lat","lon"), sep=", ")
pH$lat <- as.numeric(pH$lat)
pH$lon <- as.numeric(pH$lon)

## DO Plot
DO_plot <- ggplot() + 
  geom_polygon(data=tx, aes(x = long, y = lat, fill=region, group=group), color="black", fill="grey40") + 
  guides(fill=FALSE) +
  coord_map("gilbert")+
  geom_point(aes(x = DO$lon, y = DO$lat, colour = DO$value)) +
  labs(color="Dissolved Oxygen (mg/L)")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_void()+
  scale_color_gradient2(low="red", mid="yellow", high="green", midpoint=7)

## Transparency Plot
Trans_plot <- ggplot() + 
  geom_polygon(data=tx, aes(x = long, y = lat, fill=region, group=group), color="black", fill="grey40") + 
  guides(fill=FALSE) +
  coord_map("gilbert")+
  geom_point(aes(x = Trans$lon, y = Trans$lat, colour=Trans$value)) +
  labs(color="Transparency (m)")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_void()+
  scale_color_gradient2(low="red", mid="yellow", high="green", midpoint=1.5)

## Conductivity Plot
Cond_plot <- ggplot() + 
  geom_polygon(data=tx, aes(x = long, y = lat, fill=region, group=group), color="black", fill="grey40") + 
  guides(fill=FALSE) +
  coord_map("gilbert")+
  geom_point(aes(x = Cond$lon, y = Cond$lat, colour=Cond$value)) +
  labs(color=expression(paste("Specific Conductance (log(", mu, "s/CM) at 25C)")))+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_void()+
  scale_color_gradient2(low="red", mid="yellow", high="green", midpoint=8)

##pH plot 
pH_plot <- ggplot() + 
  geom_polygon(data=tx, aes(x = long, y = lat, fill=region, group=group), color="black", fill="grey40") + 
  guides(fill=FALSE) +
  coord_map("gilbert")+
  geom_point(aes(x = pH$lon, y = pH$lat, colour=pH$value)) +
  labs(color="pH (standard scale)")+
  xlab("Longitude")+
  ylab("Latitude")+
  theme_void()+
  scale_color_gradient2(low="red", mid="yellow", high="green", midpoint=7.5)

## Save plots
ggsave("./Analysis/Output/DO_plot.png", plot=DO_plot)
ggsave("./Analysis/Output/Trans_plot.png", plot=Trans_plot)
ggsave("./Analysis/Output/Cond_plot.png", plot=Cond_plot)
ggsave("./Analysis/Output/pH_plot.png", plot=pH_plot)

wq_spatial <- ggarrange(DO_plot, pH_plot, Cond_plot, Trans_plot, ncol = 2, nrow = 2, common.legend = F, legend = "bottom")
ggsave("./Analysis/Output/wq_spatial.png", wq_spatial)
