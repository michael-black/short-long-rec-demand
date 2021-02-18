rm(list = ls())
pacman::p_load(readstata13, dplyr, tidyr, usmap, ggmap, rworldmap, ggplot2, 
               geosphere, foreign, rgdal, maptools, grid, ggpubr, maps, gridExtra, lattice)

setwd("<set working directory here>")

##Import final dataset used in estimation
clogit <- read.dta13("./Analysis/Output/condlogit.dta")

########################################################################################################################
########################################################################################################################
##Tidy data
clogit_small <- clogit %>% filter(!is.na(DO), !is.na(Trans), !is.na(pH), !is.na(Cond), !is.na(travcost))
wq_dest <- clogit_small %>% group_by(date, locationid) %>% select(DO, Temp, Trans, Cond, pH, destination, date, locationid, gps) %>% distinct()

########################################################################################################################
########################################################################################################################
# Get top five visited sites
pop_sites <- clogit_small %>% filter(choice_mo==1) %>% group_by(mostoft) %>% summarise(count = n()) %>% arrange(desc(count)) %>% top_n(5)
pop_sites <- as.list(pop_sites$mostoft)

pop_sites_wq <- wq_dest %>% select(-Temp) %>% filter(destination %in% c(pop_sites))

#Remove duplicate entry
pop_sites_wq <- pop_sites_wq %>% mutate(temp=as.character(Trans)) %>% filter(temp!="0.0231737643480301") %>% dplyr::select(-temp)

pop_sites_wq <- pop_sites_wq %>% group_by(date, destination) %>%
  summarise(DO = mean(DO),
            Trans = mean(Trans),
            Cond = mean(Cond),
            pH = mean(pH))

# Create plots
# DO
DO.time.plot <- ggplot(pop_sites_wq, aes(x=date, y=DO, shape = destination)) +
  geom_smooth(size = 0.4, color = "black", method = NULL)+
  geom_point(size = 4) +
  scale_x_continuous(breaks = c(2001, 2004, 2009, 2012, 2015)) +
  scale_shape_discrete(name = "",
                       labels = c("Lake Conroe", "Toledo Bend Reservoir", "Lake Fork", "Lake Sam Rayburn", "Lake Sommerville"))+
  theme_classic() +
  labs(x = "Year",
       y = "Dissolved Oxygen (mg/L)")

# Transparency
Trans.time.plot <- ggplot(pop_sites_wq, aes(x=date, y=Trans, shape = destination)) +
  geom_smooth(size = 0.4, color = "black", method = NULL)+
  geom_point(size = 4) +
  scale_x_continuous(breaks = c(2001, 2004, 2009, 2012, 2015)) +
  scale_shape_discrete(name = "",
                       labels = c("Lake Conroe", "Toledo Bend Reservoir", "Lake Fork", "Lake Sam Rayburn", "Lake Sommerville"))+
  theme_classic() +
  labs(x = "Year",
       y = "Transparency (Secchi depth, meters)")
  
# pH
pH.time.plot <- ggplot(pop_sites_wq, aes(x=date, y=pH, shape = destination)) +
  geom_smooth(size = 0.4, color = "black", method = NULL)+
  geom_point(size = 4) +
  scale_x_continuous(breaks = c(2001, 2004, 2009, 2012, 2015)) +
  scale_shape_discrete(name = "",
                       labels = c("Lake Conroe", "Toledo Bend Reservoir", "Lake Fork", "Lake Sam Rayburn", "Lake Sommerville"))+
  theme_classic() +
  labs(x = "Year",
       y = "pH (Standard Scale")
# Conductance
Cond.time.plot <- ggplot(pop_sites_wq, aes(x=date, y=Cond, shape = destination)) +
  geom_smooth(size = 0.4, color = "black", method = NULL)+
  geom_point(size = 4) +
  scale_x_continuous(breaks = c(2001, 2004, 2009, 2012, 2015)) +
  scale_shape_discrete(name = "",
                       labels = c("Lake Conroe", "Toledo Bend Reservoir", "Lake Fork", "Lake Sam Rayburn", "Lake Sommerville"))+
  theme_classic() +
  labs(x = "Year",
       y = expression(paste("Log Specific Conductance (", mu, "s/CM) at 25C")))
ggsave("./Analysis/Output/DOtime.png", DO.time.plot, width = 6.65, height = 6.41)
ggsave("./Analysis/Output/Transtime.png", Trans.time.plot, width = 6.65, height = 6.41)
ggsave("./Analysis/Output/Condtime.png", Cond.time.plot, width = 6.65, height = 6.41)
ggsave("./Analysis/Output/pHtime.png", pH.time.plot, width = 6.65, height = 6.41)

wq_pop_time_facet <- ggarrange(DO.time.plot, pH.time.plot, Cond.time.plot, Trans.time.plot, ncol = 2, nrow = 2, common.legend = T, legend = "bottom")
ggsave("./Analysis/Output/wq_pop_time_facet.png", wq_pop_time_facet)

########################################################################################################################
########################################################################################################################
## Create Map of location of 5 most popular sites
# Get coordinates for popular sites
pop_sites_map <- wq_dest %>% select(-Temp) %>% filter(destination %in% c(pop_sites)) %>% group_by(destination) %>% select(gps, destination) %>% distinct() %>% separate(gps, c("Lat", "Long"), ", ")
# Get Texas map
usa <- map_data("state")
tx <- subset(usa, region %in% c("texas"))
cities <- get("world.cities")
cities <- cities[cities$country.etc == 'USA', ]
cities <- cities %>% filter(name == "Austin" | name == "Dallas" | name == "Houston" )

# Make map
pop.map <- ggplot() +
  geom_polygon(data=tx, aes(x = long, y = lat, fill=region, group=group), color="black", fill="grey70") +
  coord_map("gilbert") +
  geom_point(data = pop_sites_map, aes(x = as.numeric(Long), y = as.numeric(Lat), shape = destination), size = 4) +
  geom_point(data = cities, aes(x = as.numeric(long), y = as.numeric(lat)), size = 3, color = "black", shape = 21)+
  geom_text(data = cities, aes(x = as.numeric(long), y = as.numeric(lat), label = name), hjust = 1, vjust = 1.5)+
  scale_shape_discrete(name = "",
                       labels = c("Lake Conroe", "Toledo Bend Reservoir", "Lake Fork", "Lake Sam Rayburn", "Lake Sommerville"))+
  theme_void() +
  labs(x = "",
       y = "")

ggsave("./Analysis/Output/pop_map.png", pop.map)

a <- ggarrange(DO.time.plot, pH.time.plot, Cond.time.plot, Trans.time.plot, ncol = 2, nrow = 2, 
               common.legend = T, legend="bottom")
pretty <- ggarrange(pop.map, a, ncol = 1, heights = c(1, 2))
ggsave("./Analysis/Output/wq_sites_pretty.png", pretty, width = 10, height = 10)             