

setwd("/home/marlon-cabrera/res/pollution")
temp = list.files(pattern="*.csv")
myfiles = lapply(temp, read.delim,sep=",")


#Mean for every station with data
A.mean <- matrix(data=NA,nrow=(length(temp)),ncol=8)




for(i in 1:length(temp)){
  
  A.mean[i,1]=temp[i]
  A.mean[i,2]<-mean((myfiles[[i]])[["ozone"]])
  A.mean[i,3]<-mean((myfiles[[i]])[["particullate_matter"]])
  A.mean[i,4]<-mean((myfiles[[i]])[["carbon_monoxide"]])
  A.mean[i,5]<-mean((myfiles[[i]])[["sulfure_dioxide"]])
  A.mean[i,6]<-mean((myfiles[[i]])[["nitrogen_dioxide"]])
  A.mean[i,7]<-((myfiles[[i]])[1,6])
  A.mean[i,8]<-((myfiles[[i]])[1,7])
  
}



mean.df<-as.data.frame(A.mean)
colnames(mean.df) <- c("File","ozone","particullate_matter","carbon_monoxide","sulfure_dioxide","nitrogen_dioxide","longitude","latitude")
mean.df$ozone<-as.numeric(as.character(mean.df$ozone))
mean.df$particullate_matter<-as.numeric(as.character(mean.df$particullate_matter))
mean.df$latitude<-as.numeric(as.character(mean.df$latitude))
mean.df$longitude<-as.numeric(as.character(mean.df$longitude))

ozone.df<-mean.df[,c(7,8,7)]

api<-readLines("google.api")
register_google(key=api)

aarhus_map_g_str <- get_map(location = "Aarhus", zoom=12)
ggmap(aarhus_map_g_str)

# Sensor Location
ggmap(aarhus_map_g_str, extent = "device") + geom_density2d(data = ozone.df, aes(x = longitude, y = latitude), size = 0.3) + 
  stat_density2d(data = ozone.df, 
                 aes(x = longitude, y = latitude, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)

write.csv(mean.df,"mean_values.csv")
              
