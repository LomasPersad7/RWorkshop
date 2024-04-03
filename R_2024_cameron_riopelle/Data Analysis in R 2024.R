
# Introduction to Data Analysis in R/ R Studio ----------------------------

# Cameron Riopelle, Director, Research Data & Open Scholarship
# University of Miami, Last edited 3/2024


# Introduction to Working with Data in R / R Studio -----------------------

#The data for this workshop comes from the General Social Survey 2000, 
#which is a large survey data set. See http://gss.norc.org/
#for more information. This workshop uses common sense language to describe 
#complex processes. For this reason, please do not consider this an adequate 
#substitute for a semester-long course or textbook. There are detailed guides 
#to R on the internet, so this handout is meant specifically to accompany 
#this presentation. The goal of this handout is to provide details on the 
#content of the presentation and not be comprehensive.

#One comprehensive guide to R is at https://cran.r-project.org/doc/contrib/Owen-TheRGuide.pdf


# R / R Studio ------------------------------------------------------------

#R is an open source, free, data analysis program downloadable from
#https://www.r-project.org/. R Studio is wrapper for R that adds
#enhanced functionality to the existing R interface, downloadable
#from https://posit.co/download/rstudio-desktop/. 

#Both R and R Studio are command line programs which require an
#understanding of the R programming language.

# Sections and Comments----------------------------------------------------

#To insert a new code section you can use the Code -> Insert Section command. 
#Alternatively, any comment line which includes at least four trailing dashes (-), 
#equal signs (=), or pound signs (#) automatically creates a code section. 


# The R Environment -------------------------------------------------------

#R has a script file editor, from which lines can be run, and a command line.
#R Studio has these two frames, as well as an ''environment frame'' which
#contains the data frames in the program.

#There is also the library, which contains installed packages. You can 
#add new packages to the library through the ``Install'' button.

#R scripts can be created through File-->New File-->R Script.

#Lines from scripts can be run by highlighting the relevant block of code
#and hitting CTRL-Enter.


# Tips & Tricks -----------------------------------------------------------

#1. The Up arrow goes backward through your console history. The Down arrow
#goes forward through your console history.

#2. An incomplete line in R is marked by a + sign. 

#3. In R Studio, the Tab button will complete a partially completed suggestion
#of a variable name or such like.

#4 The Escape button will break the execution of a command.

#5. R functions may require packages that are either a) not installed, or
#b) not loaded. You may need to first install and then load the package
#to run the function.

#6. When making objects in R, you can use <- or =.

#7. In a PC, cntrl+ENTER will run a line. In a Mac, it is command-ENTER
#once you have highlighted the line.

# Help in R ---------------------------------------------------------------

help.start() 

# Basic Math --------------------------------------------------------------

#Run the following lines:


2+2

2/2

30-29

log(10)

# Working Directories -----------------------------------------------------

#To view your working directory, run the line:

getwd()

#To set your working directory, you can either do the command line
#or use the menu system. The command line will differ between
#Mac and PC because the directory systems are not the same.
#In windows, use (with your own username):

setwd("C:/Users/cxr820/Downloads")

#You can alternatively use the Session menu, then
#go to Set Working Directory, and copy and paste
#the code for future reference.

#To view the files in the directory,

list.files()

# Data Types --------------------------------------------------------------

#The data types in R are vectors, matrices, data frames, lists, and factors.
#In this workshop, we will talk about vectors, data frames, and factors.

#Vectors

#A vector is a sequence of data elements. To make a vector,

vectorname <- c(1,2,3)

#to view the contents, simply type the vector object's name and run it.

vectorname

#A vector can also contain strings.

vectorname2 = c("red", "blue", "green")

vectorname2

# Storing information as factor, character, numeric, integer...
# Always double check how you store information
# Otherwise, you could ruin everything!

vectorname3 <- c(1, 0, 0, 1, 0)
str(vectorname3)

vectorname4 <- as.factor(vectorname3)
str(vectorname4)

vectorname5 <- factor(vectorname3)
vectorname6 <- as.character(vectorname3)
vectorname7 <- as.integer(vectorname3)

# Why did factor and as.factor store level 0s as 1 and 1s as 2? This is a common error 
# when converting from numeric to factor (e.g., to specify
# categorical information in models and visualizations)

# R numbers factor levels from 1, not 0. There are complicated workarounds
# but just keep in mind the way your data are stored.

# Note the difference between the environment preview and the 
# head() preview.

head(vectorname5)

# Oh no! When I convert it back, 0 back 1 and 1 became 2!
mean(as.numeric(vectorname5))

head(as.numeric(vectorname5))

# Careful with converting your variables from factor back to numeric.

vectorname8 <- as.numeric(as.character(vectorname5))

head(vectorname8)

#Data Frames

#While it is possible to make a matrix in R using matrix(), it is more 
#common to use data frames for analysis. 

a1 = c(1,2,3,1,2,3)
a2 = c("a","b","c","d","e","f")
DataFrame = data.frame(a1,a2)
View(DataFrame)


str(a2)

str(a1)

#Supplemental section: Editing a dataframe -----

#To edit an individual observation in a data frame:

#data.frame[rownumber, columnnumber] = newvalue

DataFrame[1,1]=9 

View(DataFrame)

DataFrame[1,2]="d"

View(DataFrame)

#To replace specific values in a data frame with NA for missing. Let's say that value 9
#represents missing values

DataFrame[DataFrame=="9"]=NA

View(DataFrame)

str(a1)

#We use factors to tell R that a numeric variable is categorical.
#This is often used after importing data for when models require a variable to 
#be treated as a factor.'

factora1 = factor(a1)

str(factora1)

#Changing Column Headers

colnames(DataFrame)

colnames(DataFrame)[2] = "Var2"

#Removing an object from the environment

rm(a1)

## Queries

age = c(1,2,10,11)
id = c(1,2,3,4)
icd = c("Q0700", "Q0701", "Q0702", "Q0703")
df = data.frame(id, age, icd)

View(df)

which(df$age>=5)

list(df$icd[df$age>=5])


# Importing Data ----------------------------------------------------------

#The read.csv function imports .csv files. There several options possible.
#You can also import files through the Files pane of the GUI, by clicking
#on the .csv file and installing a certain package and following the instructions.

gss <- read.csv("R_Data 2018.csv", na.strings=c(" ",""))

# the option na.strings is telling the function read.csv to import cells with a 
# single space in them " " and cells with nothing inside "" to be read as
# system missing, or NA.

#In R, you can use fix(gss) to view the data.
#In R Studio, you can use View(gss)

View(gss)

# Viewing Data and Variables ----------------------------------------------

#The names() function can display the variable names in the data.

names(gss)

#If you want to import data from other statistical software programs,
#you can use the foreign library.

#you can use the head() function to see the first six rows of the dataset.

head(gss)

# Targeting variables in data frames --------------------------------------

#You can use the $ sign to specify a variable within the data for analysis.

head(gss$age)

#to view the structure of a variable,

str(gss$age)

#to view the structure of all variables,

str(gss)


# Descriptive Statistics --------------------------------------------------

#For continuous or quantitative variables, you would want mean and std.

#For categorical or qualitative variables, you would want a frequency table.

#For two categorical variables, you would want a 2x2 contingency table
#known as a cross-tabulation.

#describe() summarizes a variable. It is found in the package psych
#First you need to install the library psych, then you must turn it
#on either with the library() function, or by clicking it in the 
#user library pane.

# install.packages("psych")

library(psych)

describe(gss$age)

#Another option is summary(), a default R function.

summary(gss$realrinc)

# A common issue with packages is masking errors, when you have 
# two or more identically named function
# and the program can't tell which to use.
# to solve this problem, you can first name the library, then
# two colons ::, then the function
# the default is order of loading

# install.packages("Hmisc")
library(Hmisc)

describe(gss$age)
psych::describe(gss$age)
Hmisc::describe(gss$age)

#For qualitative or categorical variables, you could do a frequency table
#using the library descr.

#install.packages("descr")

library(descr)

freq(gss$wrkstat)
table(gss$wrkstat)
#For contingency tables, you can use the function table()

table(gss$wrkstat, gss$sex)

#For better tables, you can use the function crosstab() from the library descr.

crosstab(gss$marital, gss$sex, expected=T)

# For grouped means...

# Descr also has a function for calculating means of 
# a numeric vector based on a factor

compmeans(gss$age, gss$wrkstat)

# Computing and Recoding Variables ----------------------------------------

#To duplicate an existing variable,

gss$agedup <- gss$age

View(gss)

#To compute a new variable from a mathematical transformation:

gss$age2 = gss$age^2

summary(gss$age)
summary(gss$age2)

#Recoding variables makes new variables out of existing variables.

#Let's making a variable ''working'' out of the variable wrkstat, where
#working is if the person was working vs not working.

freq(gss$wrkstat)

gss$working=NA
gss$working[gss$wrkstat=="keeping house"]=0
gss$working[gss$wrkstat=="other"]=0
gss$working[gss$wrkstat=="retired"]=0
gss$working[gss$wrkstat=="school"]=0
gss$working[gss$wrkstat=="temp not working"]=0
gss$working[gss$wrkstat=="unempl, laid off"]=0
gss$working[gss$wrkstat=="working fulltime"]=1
gss$working[gss$wrkstat=="working parttime"]=1

freq(gss$working)

str(gss$working)

#Recoding Age into Age Groups <30=1, 30-40=2, >40=3


gss$age_cat[gss$age<30]=1
gss$age_cat[gss$age>=30 & gss$age<=40]=2
gss$age_cat[gss$age>40]=3

table(gss$age_cat)

# Chi Square Test ---------------------------------------------------------


#The chi-square test contrasts observed with expected cell counts for two categorical variables.
#The null hypothesis is that the two variables are independent.

crosstab(gss$wrkstat, gss$sex)

crosstab(gss$wrkstat, gss$sex, chisq = TRUE)

#From the p value, we can reject the null and support the alternative.


# Scatterplots and Bivariate Correlation ------------------------------------------

#to do a scatterplot of two continuous variables,

plot(gss$age, gss$realrinc)

#for a better version,

plot(gss$age, gss$realrinc, cex=.5, pch=19)

#to assess if there is a linear relationship, you can do a bivariate correlation:

library(Hmisc)

rcorr(gss$age, gss$realrinc)


#There is a weak positive linear relationship between the two variables.

# Make a Pearson's correlation matrix 
# This code uses rcorr from Hmisc

library(dplyr)
#library(Hmisc)

gss_corr_subset <- gss %>%
  select(age, hrs1, agekdbrn, chathr, emailhr, realinc, realrinc)

gss_corrmat <- rcorr(as.matrix(gss_corr_subset))

gss_corrmat

# correlation coeficients
gss_corrmat$r

# p values
gss_corrmat$P

# Correlation plots
# See http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
# for more info

#install.packages("corrplot")
library(corrplot)

corrplot(gss_corrmat$r)

corrplot(gss_corrmat$r, p.mat=gss_corrmat$P, insig="blank")

corrplot(gss_corrmat$r, type="upper", p.mat=gss_corrmat$P, insig="blank")

# Another plot

# install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

#note this one uses the subset data

jpeg("Correlation Matrix 2.jpg")

chart.Correlation(gss_corr_subset, histogram = T, pch=19)

dev.off()
# Last correlation plot for the day
col1<- colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = gss_corrmat$r, col= col1, symm = TRUE)

# Graphs ---------------------------------------------------------------

#Bar plot
table(gss$marital)
countmarital <- table(gss$marital)
View(countmarital)
barplot(countmarital, main="Distribution of Marital", xlab="Marital Status", ylim=c(0,1600))

# Histogram
#A histogram shows the distribution of one variable.


hist(gss$realrinc, main="Histogram of Income", ylim=c(0,600))


#Box Plots

boxplot(gss$realrinc ~ gss$marital)

#ggplot2

#install.packages("ggplot2")
library(ggplot2)

graph = ggplot(gss, aes(age, realrinc))+geom_point(color="firebrick")

graph

#Titling the graph

graph2 = graph + ggtitle('Effect of Age on Income')

graph2

#Adding axis labels

graph3 = graph2 + labs(x="Age", y="Respondent's Income", title="Effect of Age on Income, GSS 2000")

graph3

#Color coding by groups

str(gss$marital)

graph4 = ggplot(gss, aes(age, realrinc, color=factor(marital)))+geom_point()

graph4

graph5 = graph4 + labs(x="Age", y="Respondent's Income", title="Effect of Age on Income Grouping by Marital Status, GSS 2000")

graph5

options(scipen=10000)

#Bivariate bar graph

gss$marital2=gss$marital
gss$marital2[gss$marital=="NA"]=NA

ggplot(gss) + aes(x=factor(marital2),y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")

ggplot(subset(gss, !is.na(marital2))) + aes(x=factor(marital2),y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")

ggplot(subset(gss, !is.na(marital2))) + aes(fill=factor(sex), x=marital,y=realrinc)+geom_bar(position="dodge", stat = "summary", fun.y = "mean")


#You can export graphs to image or pdf using the export button in the bottom right pane.

# Writing plots to your working directory

jpeg(filename="Scatterplot_demo2.jpg", units="in", width=5, height=5, res=600)

graph5 #note your graph code can go here. In my case I'm just recalling the graph that was stored earlier

dev.off()

# Custom Tables in Dplyr --------------------------------------------------

#Dply uses a pipe %>% which passes results from left to right.
#This package is good for making tables, subsetting data, and aggregating data.

#install.packages("glue")
#install.packages("dplyr")
library(dplyr)

table1 <- gss %>% group_by(sex) %>% summarize(Average=mean(realrinc, na.rm=T))

View(table1)

#let's say you wanted the same table, selecting only people who were married

library(descr)

freq(gss$marital)

table2 = gss %>% filter(marital=="married") %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE))

View(table2)

#let's say you wanted the n as well!

table3 = gss %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE), n=n())

View(table3)

table4 = gss %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE), standdev=sd(realrinc, na.rm=T), n=n())

View(table4)

#What if you wanted to group by multiple categories?

table5 = gss %>% group_by(sex, marital) %>% summarize(mean=mean(realrinc, na.rm = TRUE), n=n())

View(table5)


# Writing Functions -------------------------------------------------------

# You can write your own functions which work just like functions within packages
# In fact, you can write your own packages and place them online.

# install.packages("moments")
library(moments)

desc_cat <- function(dfname, varname) {
  varname2 <- eval(substitute(varname), dfname) #reading in variable name within data frame name
  pltitle <- substitute(paste("Boxplot of ", dfname, "$", varname)) # building the plot title
  boxplot(varname2, main=pltitle) #boxplot with adaptive title
  print(summary(varname2)) #summary statistics
  print(kurtosis(varname2, na.rm=T)) #kurtosis from moments package
  print(paste0("IQR= ",IQR(varname2, na.rm=T))) #IQR
  
  if (kurtosis(varname2, na.rm=T)<=3) { #example if else
    print("Playkurtic")
  } else {
    print("Leptokurtic -- watch out for outliers!")
  }
}

desc_cat(gss, age)
desc_cat(gss, realrinc)

# Saving ------------------------------------------------------------------

#Command history

history() #Last 25 commands
history(max.show=Inf) #All commands during session
savehistory(file="IntroR")
getwd()

#You can use write.csv() to export a csv file of your data.

write.csv(table5, "table5.csv")

write.csv(gss, file="gss2.csv",row.names = F)

#You should save the script file as a .R file, which can be
#opened with a text file editor, or in R.

