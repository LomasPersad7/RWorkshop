# Intermediate R / R Studio----------------------------------------------------------

#Cameron Riopelle, PhD, Head of Data Services, University of Miami, 2022

getwd()

setwd("C://Users//criopelle//Desktop//")

gss = read.csv("R_Data 2018.csv", na.strings=c("", " "))


# Descriptive Statistics (Recap) ------------------------------------------

#for continuous variables

install.packages("Hmisc")

library(Hmisc)

describe(gss$age)

summary(gss$age)

#for categorical variables

install.packages("descr")

library(descr)

freq(gss$wrkstat)

#crosstab

table(gss$wrkstat, gss$sex)

#alternatively,

crosstab(gss$marital, gss$sex)

# Subsetting data

keep_list = c("age","emailhr","realrinc","realinc")
gss_subset = gss[keep_list]


# Aggregation -------------------------------------------------------------

#using aggregate

aggregate(hrs1 ~ marital + sex, gss, mean)

agg1 = aggregate(hrs1 ~ marital + sex, gss, mean)

View(agg1)

summary(agg1$hrs1)

write.csv(agg1, file="agg1.csv")

#Using tapply
#"The tapply function is useful when we need to break up a vector into groups defined by some classifying factor, compute a function on the subsets, and return the results in a convenient form. You can even specify multiple factors as the grouping variable, for example treatment and sex, or team and handedness. "
#see https://www.r-bloggers.com/r-function-of-the-day-tapply-2/

tapply(gss$realrinc, gss$marital, mean)

#taking missing values into account
tapply(gss$realrinc, gss$marital, mean, na.rm=T) 

tapply(gss$realrinc, list(gss$marital, gss$wrkstat), mean, na.rm=T) 

#tapply with different function

tapply(gss$realrinc, gss$marital, max, na.rm=T) 

# Custom Tables in Dplyr --------------------------------------------------

#Dply uses a pipe %>% which passes results from left to right.
#This package is good for making tables, subsetting data, and aggregating data.

install.packages("glue")
install.packages("dplyr")
library(dplyr)

table1 = gss %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE))

View(table1)

#let's say you wanted the same table, selecting only people who were married

freq(gss$marital)

table2 = gss %>% filter(marital=="married") %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE))

View(table2)

#let's say you wanted the n as well!

table3 = gss %>% group_by(sex) %>% summarize(mean=mean(realrinc, na.rm = TRUE), n=n())

View(table3)

#What if you wanted to group by multiple categories?

table4 = gss %>% group_by(sex, marital) %>% summarize(mean=mean(realrinc, na.rm = TRUE), n=n())

View(table4)

# Chi Square Test ---------------------------------------------------------


#The chi-square test contrasts observed with expected cell counts for two categorical variables.
#The null hypothesis is that the two variables are independent.

crosstab(gss$wrkstat, gss$sex)

crosstab(gss$wrkstat, gss$sex, chisq = TRUE)

#From the p value, we can reject the null and suppor the alternative.


# Scatterplots and Bivariate Correlation ------------------------------------------

#to do a scatterplot of two continuous variables,

plot(gss$age, gss$realrinc)

#for a better versionm,

plot(gss$age, gss$realrinc, cex=.5, pch=19)

#to assess if there is a linear relationship, you can do a bivariate correlation:

library(Hmisc)

rcorr(gss$age, gss$realrinc)

#There is a weak positive linear relationship between the two variables.

#Lomas

# Independent Samples T-Test ----------------------------------------------



#The independent-samples t test is a means comparison test
#that compares the means between two groups to see if the
#difference is meaningful at the population level.

#First, we must do the Levene's test for homogeneity of variances.

install.packages("car")
library(car)

#the null hypothesis is that the variances are equal.;

leveneresults = leveneTest(gss$realrinc, gss$sex)

leveneresults

#The test is significant, so we reject the null and 
#support the idea that the variances are unequal.

#With equal variances assumed, we do var.equal=TRUE for the assumption 
#in the code. With not assumed, we do var.equal=FALSE.

#With var-equal=FALSE, we do a Welch's t-test.

t.test(gss$realrinc ~ gss$sex, var.equal=FALSE)

#the test is significant, letting us reject the  null
#and support the alternative.


# One-Way ANOVA -----------------------------------------------------------

#When you are dealing with an independent categorical variable of >2
#categories, assuming the assumptions are met, you can do a one-way
#ANOVA to compare means for a continuous dependent variable.

#Two visualizations

boxplot(realrinc ~ marital, data = gss,
        xlab = "Marital Status", ylab = "Income",
        frame = FALSE, col = c("#00AFBB", "#E7B800", "#FC4E07"))

install.packages("gplots")
library("gplots")
plotmeans(realrinc ~ marital, data = gss, frame = FALSE,
          xlab = "Marital Status", ylab = "Income",
          main="Mean Plot with 95% CI") 


#First, we like to do a Levene's Test for Homogeneity of Variance

install.packages("car")
library("car")

leveneTest(realrinc ~ marital, data=gss)

#if the assumption is not rejected:

anova1 = aov(realrinc ~ marital, data = gss)

summary(anova1)

#if the assumption is rejected:

oneway.test(realrinc ~ marital, data=gss, var.equal=FALSE)

#at this point you would do pairwise post hoc comparisons

pairwise.t.test(gss$realrinc, gss$marital, p.adj = "bonf")

# Graphs ---------------------------------------------------------------

#ggplot2

install.packages("ggplot2")
library(ggplot2)

graph1 = ggplot(gss, aes(age, realrinc))+geom_point(color="firebrick")+ ggtitle('Effect of Age on Income') + labs(x="Age", y="Respondent's Income", title="Effect of Age on Income, GSS 2000")

graph1

#Color coding by groups

scatterplot1 = graph4 + labs(x="Age", y="Respondent's Income", title="Effect of Age on Income Grouping by Marital Status, GSS 2000")
scatterplot1

# Linear Regression -------------------------------------------------------


#first, let us make a scatterplot of age and income

scatter.smooth(x=gss$age, y=gss$realrinc, main="Age ~ Income")

#Ideally, this would be a better fit

#test for normality

#sample test for simulated normal data
#null hypothesis--sample comes from normal distribution
shapiro.test(rnorm(100, mean = 5, sd = 3))

#test on our own data
shapiro.test(gss$realrinc)

qqnorm(gss$realrinc)

#how seriously to take this type of test is highly debated
#see https://stackoverflow.com/questions/7781798/seeing-if-data-is-normally-distributed-in-r/7788452#7788452


#now let's redo our correlation

library(Hmisc)

rcorr(gss$age, gss$realrinc)

#now we will do our linear model

lmresults = lm(realrinc ~ age, data=gss)

#brief summary with coefficients and intercept
print(lmresults)

#better summary with significance, coefficients, and fit stats
summary(lmresults)

#to get AIC and BIC

AIC(lmresults)

BIC(lmresults)

#stepwise regression

lmresults2 = lm(realrinc ~ age + postlife + sex, data=gss)
summary(lmresults2)

step(lmresults2, direction=c("backward"), steps=1000)

# Logistic Regression Model -----------------------------------------------

#logistic regressions use the glm function

table(gss$postlife)

logitresults = glm(postlife ~ age + realrinc + sex,family=binomial(link='logit'),data=gss)

summary(logitresults)

#for the sake of time, I am omitting ROC curves, which are generally used 

#often we like to predict probabilities from models like this

exp(coef(logitresults))

# Saving ------------------------------------------------------------------

#You can use write.csv() to export a csv file of your data.

write.csv(gss, file="gss2.csv")

#You can save the script file as a .R file, which can be
#opened with a text file editor, or in R.