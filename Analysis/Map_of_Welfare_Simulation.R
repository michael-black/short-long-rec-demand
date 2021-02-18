rm(list=ls())
setwd ("<set working directory here>")
pacman::p_load(rgdal, maptools, ggplot2, dplyr, haven, sf)

texas = read_sf("./Build/Input/TWDB_MRBs_2014.shp")
brw = texas %>% filter(basin_num==12)

clogit <- read_dta("./Analysis/Output/condlogit.dta")
clogit_brw <- clogit %>%
  filter(basin==12) %>%
  select(gps)%>%
  tidyr::separate(gps, c("A", "B"),sep = ", ") %>%
  distinct()

brw_map = ggplot() +
  geom_sf(data = texas, fill = "white", color = "black", size = 0.1) +
  geom_sf(data = brw, fill = "grey50", color = "black", size = 1) +
  geom_point(data = clogit_brw, aes(x = as.numeric(B), y = as.numeric(A)), colour = "black", size = 3, inherit.aes = FALSE, show.legend = FALSE) +
  theme_void()

ggsave("./Analysis/Output/brw.png", brw_map)
