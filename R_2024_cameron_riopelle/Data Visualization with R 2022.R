# Data Visualization with R/RStudio ---------------------------------------
# 2021-03-22
#
# Cameron Riopelle, PhD, Head of Data Services, University of Miami Libraries
# criopelle@miami.edu

# Index by Line Number-------------------------------------------------------------------

#22: Importing data set as a data frame
#30: The R Plot Function
#41: Histograms
#50: Boxplots
#83: Scatterplot and normality
#159: Dealing with NA Columns
#168: Better histograms
#179: Tiling graphs
#214: Violin Plots
#243: Treemaps
#254: Interactive Visualizations with Plotly
#283: Animated Graphs
#319: Additional Examples

# Importing data set as a data frame --------------------------------------

getwd()
setwd("C:/Users/cxr820/Desktop/R 2022")

gss = read.csv("R_Data 2018.csv", na.strings=(""))


# The R Plot Function -----------------------------------------------------

plot(gss$age)
table(gss$marital)
plot(factor(gss$marital), ylim=c(0,1500))

gss$marital_num[gss$marital=="divorced"]=1
gss$marital_num[gss$marital=="married"]=2
gss$marital_num[gss$marital=="never married"]=3
gss$marital_num[gss$marital=="separated"]=4
gss$marital_num[gss$marital=="widowed"]=5

#plot(gss$marital_num) interprets as continuous information
plot(gss$marital_num)

#factor tells R that variable is categorical
plot(factor(gss$marital_num))


plot(factor(gss$marital), ylim=c(0,1500))

plot(factor(gss$marital), 
     xlab="Marital Status", 
     ylab="Count", 
     col="skyblue", 
     ylim=c(0,1500), 
     main="Count of Marital")


# Histograms --------------------------------------------------------------

hist(gss$age)

#manually defining x axis and y axis tick range
hist(gss$age, xlim=c(0,89), xaxt="n", yaxt="n")

#axis 1 is the x axis
axis(1, at = seq(10, 100, by = 5), las=2)

#axis 2 is the y axis
axis(2, at = seq(0, 1500, by = 50), las=2)


hist(gss$age, xlim=c(0,100), breaks=30)


#plot(x,y, xaxt="n")
#axis(1, at = seq(10, 200, by = 10), las=2)




# Boxplots ----------------------------------------------------------------

boxplot(realrinc ~ marital, data = gss,
        xlab = "Marital Status", ylab = "Income",
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))

# hexadecimal RGB triplets
# https://color.adobe.com/create
# HSV is the standard color model vs RGB computer

boxplot(realrinc ~ marital, data = gss,
        xlab = "Marital Status", ylab = "Income",
        frame = TRUE, col = c("#00AFBB", "#109922", "#FC4E07", "#354DCC", "#747A99"))

#install.packages("gplots")
library("gplots")
plotmeans(realrinc ~ marital, data = gss, frame = FALSE,
          xlab = "Marital Status", ylab = "Income",
          main="Mean Plot with 95% CI") 

plotmeans(realrinc ~ marital, data = gss, frame = T,
          xlab = "Marital Status", connect=FALSE, ylim=c(0,30000), ylab = "Income",
          main="Mean Plot with 95% CI") 


#install.packages("ggplot2")
library(ggplot2)

graph1 = ggplot(gss, aes(age, realrinc))+
  geom_point(color="black")+ 
  ggtitle('Effect of Age on Income') + 
  labs(x="Age", y="Respondent's Income", 
       title="Effect of Age on Income, GSS 2000")

graph1


# Scatterplot and normality -----------------------------------------------

#next, let us make a scatterplot of age and income

plot(x=gss$age, y=gss$realrinc, main="Age ~ Income")

#with smoothed line
scatter.smooth(x=gss$age, y=gss$realrinc, main="Age ~ Income")

#we could also use the log

scatter.smooth(x=log(gss$age), y=log(gss$realrinc), main="Age ~ Income")


#Visualizations of normality
#test on our own data

qqnorm(gss$realrinc)

#Scatterplots color coding by groups

scatterplot1 = ggplot(gss, aes(age, realrinc, color=factor(marital)))+geom_point()
scatterplot1

scatterplot2 = scatterplot1 + labs(color="Marital Status") + xlab("Age") + ylab("Income")+
    labs(title="Income by Marital Status")
scatterplot2

#change color of palette with scale_color_brewer() function
#which is part of ggplot

scatterplot2 + scale_color_brewer(palette="Dark2") 
scatterplot2 + scale_color_brewer(palette="clarity") + theme_classic()

#set ceiling for penalty higher before abbreviating to scientific notation
options(scipen=100000)
scatterplot2 + scale_color_brewer(palette="clarity") 

#the viridis color palette library
# see https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

#install.packages("viridis")
library(viridis)

p <- ggplot(
  gss, 
  aes(x = age, y=realrinc, size = prestg80, colour = marital)
) +
  geom_point(show.legend = TRUE, alpha = 0.6) +
  scale_color_viridis_d() +
  scale_size(range = c(1, 5)) +
  scale_x_log10() +
  labs(x = "Age", y = "Income") +
  ggtitle("Age - Income by Marital Status and Occupational Prestige")
p

p1 <- ggplot(
  gss, 
  aes(x = age, y=realrinc, size = prestg80, colour = marital)
) +
  geom_point(show.legend = TRUE, alpha = 0.2) +
  scale_color_viridis_d() +
  scale_size(range = c(1, 8)) +
  scale_x_log10() +
  labs(x = "Age", y = "Income") +
  ggtitle("Age - Income by Marital Status and Occupational Prestige")
p1


p2 <- ggplot(
  gss, 
  aes(x = age, y=realrinc, size = prestg80, colour = marital)
) +
  geom_point(show.legend = TRUE, alpha = 0.3) +
  scale_color_viridis_d() +
  scale_size(range = c(1, 8)) +
  scale_x_log10() +
  labs(x = "Age", y = "Income") +
  ggtitle("Age - Income by Marital Status and Occupational Prestige")
p2

# Dealing with NA Columns -------------------------------------------------

ggplot(gss) + aes(x=factor(marital),y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")

ggplot(subset(gss, !is.na(marital))) + aes(x=factor(marital),y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")

ggplot(subset(gss, !is.na(marital))) + aes(fill=factor(sex), x=marital,y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")


# Better histograms -------------------------------------------------------


#overlapping and transparent

library(ggplot2)
ggplot(gss, aes(x=realrinc, fill=sex))+geom_histogram(position="identity")

ggplot(gss, aes(x=realrinc, fill=sex))+geom_histogram(position="identity", alpha=0.4)


# Tiling graphs -----------------------------------------------------------

#install.packages('gridExtra')
library(gridExtra)

table(gss$wrkstat)
table(gss$marital)

h1 = ggplot(subset(gss, wrkstat=="working fulltime"), aes(x=realrinc))+geom_histogram(position="identity")
h2 = ggplot(subset(gss, wrkstat=="working parttime"), aes(x=realrinc))+geom_histogram(position="identity")
h3 = ggplot(subset(gss, marital=="married"), aes(x=realrinc))+geom_histogram(position="identity")
h4 = ggplot(subset(gss, marital=="divorced"), aes(x=realrinc))+geom_histogram(position="identity")

h1
h2
h3
h4

grid.arrange(h1, h2, h3, h4, top="Histograms of Realrinc")

h11 = ggplot(subset(gss, wrkstat=="working fulltime"), aes(x=realrinc))+ggtitle("Working Fulltime")+geom_histogram(position="identity")+
    theme(plot.title = element_text(size = 8, face = "bold"))+
  ylim(0,300)+xlim(0,300000)

h21 = ggplot(subset(gss, wrkstat=="working parttime"), aes(x=realrinc))+ggtitle("Working Parttime")+geom_histogram(position="identity")+
    theme(plot.title = element_text(size = 8, face = "bold"))+
  ylim(0,300)

h31 = ggplot(subset(gss, marital=="married"), aes(x=realrinc))+ggtitle("Married")+geom_histogram(position="identity")+
    theme(plot.title = element_text(size = 8, face = "bold"))+
  ylim(0,300)

h41 = ggplot(subset(gss, marital=="divorced"), aes(x=realrinc))+ggtitle("Divorced")+geom_histogram(position="identity")+
    theme(plot.title = element_text(size = 8, face = "bold"))+
  ylim(0,300)

grid.arrange(h11, h21, h31, h41, top="Histograms of Income")


# Violin Plots -------------------------------------------------------------

library(ggplot2)

graph2 = ggplot(subset(gss, !is.na(marital)), aes(x=marital, y=realrinc))+geom_violin()
graph2

#coord flip rotates ggplot objects
graph2_rotated = graph2 + coord_flip()
graph2_rotated

graph2_rotated + stat_summary(fun.y=mean, geom="point")

graph2_rotated + stat_summary(fun.y=mean, geom="point", shape=13)

graph2_rotated + stat_summary(fun.data="mean_sdl", mult=1, geom="pointrange", width=0.1, color="red")

graph2_rotated + stat_summary(fun.data="mean_sdl", mult=1, geom="crossbar", width=0.1, color="blue")

gss_subset = subset(gss, !is.na(marital))

graph2.1 = ggplot(gss_subset, aes(x=marital, y=emailhr, color=marital))+geom_violin(trim=T)                    
graph2.1

#Adding R Color Brewer Palettes
graph2.1 + scale_color_brewer(palette="Dark")
graph2.1 + scale_color_brewer(palette="Dark2")
graph2.1 + scale_color_grey() + theme_classic()


# Treemaps ----------------------------------------------------------------

#install.packages("treemap")
library(treemap)

treemap(index=gss$marital, vSize=gssrealrinc)
treemap(gss, index=c("marital","sex"), vSize="realrinc")

treemap(gss, index=c("marital","sex"), vSize="realrinc", palette="Set3", bg.labels=c("blue"))


# Saving Plots ------------------------------------------------------------
#png, pdf, jpeg, etc. are all functions
jpeg(filename="plotmeans.jpeg")

plotmeans(realrinc ~ marital, data = gss, frame = FALSE,
          xlab = "Marital Status", ylab = "Income",
          main="Mean Plot with 95% CI") 

dev.off()

#You can adjust attributes
pdf("plotmeans.pdf",
    width=8,
    height=6,
    bg="white",
    colormodel = "cmyk",
    paper="A4")

plotmeans(realrinc ~ marital, data = gss, frame = FALSE,
          xlab = "Marital Status", ylab = "Income",
          main="Mean Plot with 95% CI") 

dev.off()


# Interactive Visualizations with Plotly ----------------------------------

#Initialization for offline plotting

#Following https://plot.ly/r/getting-started/

#install.packages("plotly")
library(plotly)

View(midwest)

p <- plot_ly(midwest, x = ~percollege, color = ~state, type = "box")
p

#you can host on server 
#download html through export

View(economics)

p2 <- plot_ly(economics, x = ~date, y = ~unemploy / pop)
p2

#adding titles
p3 = plot_ly(economics, x = ~date, y = ~unemploy / pop) %>%
    layout(title = "Unemployment / population 1967-2015", xaxis= list(title="Year"))
p3


# Animated Graphs ---------------------------------------------------------

#install.packages("gganimate")
#install.packages("gapminder")

library(gganimate)
library(ggplot2)
library(gapminder)

#Example from https://gganimate.com/
animated1 = ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animated1

#the animation won't work without a package that combines images into videos 
#such as gifski

install.packages('gifski')
library(gifski)

#let's try changing the fps
animate(animated1, fps=50)

#To save the animated image, you can go to "Viewer"
#and either "save as" or click the "Show in new window"
#to open the file in a web browser

# Additional Examples -----------------------------------------------------

#Additional Example: Labelling Points in Scatterplots
#Following https://www.statmethods.net/advgraphs/axes.html

attach(mtcars)
View(mtcars)

plot(wt, mpg, main="Milage vs. Car Weight",
     xlab="Weight", ylab="Mileage", pch=18, col="blue")
text(wt, mpg, cyl, cex=0.6, pos=4, col="red") 


#Additional Example: Raster data
#from https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html

#install.packages("rasterVis")
#install.packages("httr")
#install.packages("rgdal")
library(raster)
library(rasterVis)
library(httr)
library(rgdal)
par(mfrow=c(1,1), mar=rep(0.5, 4))
temp_raster <- "http://ftp.cpc.ncep.noaa.gov/GIS/GRADS_GIS/GeoTIFF/TEMP/us_tmax/us.tmax_nohads_ll_20150219_float.tif"
try(GET(temp_raster,
        write_disk("us.tmax_nohads_ll_20150219_float.tif")), silent=TRUE)
us <- raster("us.tmax_nohads_ll_20150219_float.tif")
image(us, col=inferno(256), asp=1, axes=FALSE, xaxs="i", xaxt='n', yaxt='n', ann=FALSE)

#projected
us1 <- projectRaster(us, crs="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
image(us1, col=inferno(256), asp=1, axes=FALSE, xaxs="i", xaxt='n', yaxt='n', ann=FALSE)

#Additional Example: Correlation heatmap

#following http://www.sthda.com/english/wiki/ggplot2-quick-correlation-matrix-heatmap-r-software-and-data-visualization

#install.packages("ggplot2")
#install.packages("reshape2")

library(reshape2)

data(mtcars)

View(mtcars)

mydata=mtcars

head(mydata)

cormat <- round(cor(mydata),2)

head(cormat)

#"melt" data so that each row is a unique id-variable combination, see https://www.statmethods.net/management/reshape.html
melted_cormat <- melt(cormat)

head(melted_cormat)

library(ggplot2)

ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()

get_lower_tri<-function(cormat){
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}

get_upper_tri <- function(cormat){
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}

upper_tri <- get_upper_tri(cormat)
upper_tri

melted_cormat <- melt(upper_tri, na.rm = TRUE)


ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed()
