# Exercise 1: creating a basemap
library(ggmap)
library(readr)
ggmap::register_google(key="AIzaSyDUBESnGuUiZW4OH7LRL1ccYHg584iPYp0")

# Exercise 1: Get the basemap
myLocation = "California"
myMap = get_googlemap(location = myLocation, zoom=6)
ggmap(myMap)

myMap = get_map(location = myLocation, zoom=6)
ggmap(myMap)

# Exercise 2: Adding operational data layers

# read in the wildfire data to data frame (tibble)
dfWildfires = read_csv("StudyArea_SmallFile.csv",col_names = TRUE)

#select specific columns of information
df = select(dfWildfires, STATE, YEAR_,TOTALACRES,DLATITUDE,DLONGITUDE)
# filter the data frame so that only fires greater than 1,000 acres burned in California are present
df = filter(df,TOTALACRES >=1000 & STATE =="California")

# Use geom_point() to display the points. The x and y properties of the aes() function are used to define
ggmap(myMap) + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE))

# Use mutate() to group the fires by decade
df = mutate(df,DECADE = ifelse(YEAR_ %in% 1980:1989,"1980-1989",
                               ifelse(YEAR_ %in% 1990:1999,"1990-1999",
                                      ifelse(YEAR_ %in% 2000:2009,"2000-2009",
                                             ifelse(YEAR_ %in% 2010:2016,"2010-2016","-99")))))

# Group the fires by decade use the dplyr function
ggmap(myMap) + geom_point(data=df,aes(x=DLONGITUDE, y = DLATITUDE,colour = DECADE,size=TOTALACRES))

# Let's change the map view to focus more on southern California, and in particular the area just north of Los Angeles.
myMap = get_map(location = "Santa Clarita, California",zoom=10)
ggmap(myMap) + geom_point(data=df,aes(x=DLONGITUDE,y=DLATITUDE,colour=DECADE,size=TOTALACRES))

# Add contour and heat layers
myMap = get_map(location = "California",zoom=6)
ggmap(myMap,extent = "device") + geom_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE),size=0.3) +
  stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..,alpha=..level..),size = 0.01, bins=16, geom = "polygon") +  # This one is to add contour
  scale_fill_gradient(low="green",high="red") + scale_alpha(range = c(0,0.3),guide=FALSE)

# Heat map without contours
ggmap(myMap,extent="device")+stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..,alpha=..level..),size=0.01,bins=16,geom="polygon") + 
  scale_fill_gradient(low="green",high="red") + scale_alpha(range = c(0,0.3),guide=FALSE)

# Create facet map
df = filter(df,YEAR_ %in% c(2010,2011,2012,2013,2014,2015,2016))
ggmap(myMap,extent="device") + stat_density2d(data=df,aes(x=DLONGITUDE,y=DLATITUDE,fill=..level..),size=0.01,bins=16,geom = "polygon") +
  scale_fill_gradient(low="green",high = "red") + scale_alpha(range=c(0,0.3),guide=FALSE) + facet_wrap(~YEAR_) 

# Exercise 3: Adding Layers from Shapefiles
library("rgdal")
# open the shapefile that called S_USA.Wilderness
# a number of files with this name, but a different file extension. These files combine to create what is called a shapefile.
wild = readOGR('.','S_USA.Wilderness')

# fortify() function is part of ggplot2
# converts all the individual points that define each boundary into a dataframe
wild = fortify(wild)
montana = qmap("Montana",zoom=6)

# Plot the wilderness boundaries on the basemap
montana + geom_polygon(aes(x=long,y=lat,group=group,alpha=0.25),data=wild,fill='white') +
  geom_polygon(aes(x=long,y=lat,group=group), data=wild,color='black',fill=NA)

#Sys.setenv(PATH=paste(Sys.getenv("PATH"),"/Applicatin/Tex/LaTeXiT.app",sep=";"))

