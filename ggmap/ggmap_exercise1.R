#ggmap Example

library("ggmap")
library("ggplot2")

# If we use the 'stamen map'
us = c(left = -125, bottom = 25.75, right = -67, top = 49)
get_stamenmap(us,zoom=5,maptype = "toner-lite") %>% ggmap()

#use gmplot() in the same way you'd use qplot(), but with a map automatically added in the background:

library("dplyr")
library("forcats")

#define helper
`%notin%` = function(lhs,rhs) ! (lhs %in% rhs)

#reduce crime to violent crimes in downtown houston
violent_crimes = crime %>%
  filter(
    offense %notin% c("auto theft","theft","burglary"),
    -95.3968 <= lon & lon <= -95.34188,
    29.73631 <= lat & lat <= 29.78400
  ) %>%
  mutate(
    offense = fct_drop(offense),
    offense = fct_relevel(offense,c("robbery","aggravated assault","rape","murder"))
    )

# Use qmplot to make a scatterplot on a map
qmplot(lon,lat,data=violent_crimes,maptype="toner-lite",color=I("red"))

robberies = violent_crimes %>% filter(offense =="robbery")

qmplot(lon,lat,data=violent_crimes, geom = "blank",
       zoom = 14, maptype = "toner-background",darken = .7, legend = "topleft"
) + 
  stat_density_2d(aes(fill = ..level..), geom = "polygon", alpha = .3, color=NA )+
  scale_fill_gradient2("Robbery\nPropensity",low="white",mid="yellow",high="red",midpoint=650)

# Do the same thing for the Faceting
qmplot(lon,lat,data=violent_crimes,maptype = "toner-background",color=offense) + 
  facet_wrap(~offense)

### Google Maps and Credentials
ggmap::register_google(key="AIzaSyDUBESnGuUiZW4OH7LRL1ccYHg584iPYp0")
get_googlemap("waco texas",zoom = 12) %>% ggmap()
geocode("1301 S University Parks Dr, Waco, TX 76798")
revgeocode(c(lon=-97.1161, lat = 31.55098))

# There is also a mutate_geocode() that works similarly to dplyr's mutate() functin:
tibble(address = c("white house","","waco texas")) %>%
  mutate_geocode(address)

#Sys.setenv(PATH=paste(Sys.getenv("PATH"),"/Applica#tions/Tex/LaTeXiT.app",sep=";"))
