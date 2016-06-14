# Rob Leggett, June 13th, 2016
# Data Mining and Business Analytics with R by Johannes Ledolter
# Chapter 2: Processing the Information and Getting to Know Your Data

# Example 1: 2006 Birth Data
# 2006 Birth Data comes from 'nutshell' package - 427,323 records and 13 variables
# Variables: 1. DOB_MM - Day of Birth by Month, 
# 2. DOB_WK - Birth by Day of Week
# 3. DBWT - Birth weight of baby
# 4. WTGAIN - Weight gain of mother during pregnancy
# 5. SEX - Sex of Baby
# 6. APGAR5 - APGAR score of baby at birth
# 7. DPLURAL - Whether it was a single or multiple birth
# 8. ESTGEST - Estimated gestation age in weeks

#Useing the 'lattice' package for viz
library(nutshell)
library(lattice)
data(births2006.smpl)
births2006.smpl[1:5,]

#Research Questions: Does the birth frequency, method of delivery, the number of babies 
##delivered from a single patent, and the day of the week show a relationship? 

#dim - Retrieves or set the dimension of an object
dim(births2006.smpl)

#Births by the day of the week - 1=Sunday... 7=Sat.
births.dow=table(births2006.smpl$DOB_WK)
births.dow

#Bar Chart of DOB_WK
barchart(births.dow, ylab="Day of Week", col="black")

#Table of Type of Birth according to the Days of the Week
dob.dm.tbl=table(WK=births2006.smpl$DOB_WK, MM=births2006.smpl$DMETH_REC)
dob.dm.tbl

#Remove "Unknown" from table
dob.dm.tbl=dob.dm.tbl[,-2]

#Use lattice(trellis) graphics to condition density histograms 
trellis.device()
barchart(dob.dm.tbl, ylab="Day of Week")
barchart(dob.dm.tbl, horizontal=FALSE, groups=FALSE, xlab="Day of Week", col="black")

# Answer: Reduction in vaginal births decline as does c-sections during the weekend,
## but c-sections frequencies are reduced by approximately 50% where vaginal delivery
## decreases from roughly 25-30%. Doctors may prefer c-sections, and all deliveries, on weekdays 
## when the time of delivery can be controlled.

#Examining birth weight by the number of babies born, aka twins, trips, etc.
#Histogram with lattice
histogram(~DBWT|DPLURAL, data = births2006.smpl, layout=c(1,5), col="black")

#Examining Birth Weight by Birth Method
histogram(~DBWT|DMETH_REC, data = births2006.smpl, layout=c(1,3), col="black")

#Birth Weight by #Born and Method with lattice density plots and dot plot
densityplot(~DBWT|DPLURAL, data = births2006.smpl, layout=c(1,5), plot.points=FALSE, col="black")
densityplot(~DBWT, groups = DPLURAL, data = births2006.smpl, plot.points=FALSE)
dotplot(~DBWT|DPLURAL, data = births2006.smpl, layout=c(1,5), plot.points=FALSE, col="black")

# Scatter PLots in lattice - birth weight against day of week,
# birth weight against weight gain, and plots stratified multiple births
xyplot(DBWT~DOB_WK, data = births2006.smpl, col = "black")
xyplot(DBWT~DOB_WK|DPLURAL, data = births2006.smpl, layout = c(1,5), col = "black")
xyplot(DBWT~WTGAIN, data = births2006.smpl, col = "black")
xyplot(DBWT~WTGAIN|DPLURAL, data = births2006.smpl, layout = c(1,5), col = "black")

# Smoothed scatter plot indicating little association b/w birth weight and weight gain
# during the course of pregnancy
smoothScatter(births2006.smpl$WTGAIN,births2006.smpl$DBWT)

# Box Plot of birth weight against the APGAR score
# APGAR score is an indication of the health status of a newborn
# The lower the APGAR, the increase of newborn experiencing difficulties
boxplot(DBWT~APGAR5, data = births2006.smpl, ylab="DBWT", xlab="APGAR5")
#Box plot shows strong relationship with birth weight and APGAR score
#Lower weight means lower APGAR

# Box Plot of birth weight against the day of week
boxplot(DBWT~DOB_WK, data = births2006.smpl, ylab="DBWT", xlab="Day of Week")
# No relationship with day of week and APGAR score

#bwplot is the command for lattice box plot
#need to declare the conditioning variables as factors
bwplot(DBWT~factor(APGAR5)|factor(SEX), data = births2006.smpl, xlab="APGAR5")
bwplot(DBWT~factor(DOB_WK), data = births2006.smpl, xlab = "Day of Week")

# Calculate the avg. birth weight as function of multiple births,
# Males and Females separately
# Use na.rm=TRUE to remove missing data from calculations 
fac=factor(births2006.smpl$DPLURAL)
res=births2006.smpl$DBWT
t4=tapply(res,fac,mean,na.rm=TRUE)
t4

#Separate avg. by sex
t5=tapply(births2006.smpl$DBWT, INDEX = list(births2006.smpl$DPLURAL,
                                             births2006.smpl$SEX),
          FUN = mean, na.rm=TRUE)
t5

# Bar plot to illustrate how the avg birth weight decreasing with multiple deliveries
barplot(t4, ylab = "DBWT")

# Bar plot to illustrate how the avg birth weight is higher for males
barplot(t5, beside = TRUE, ylab = "DBWT")

# Illustrate the level plot and contourplot in lattice
## 1st. Create cross-classification of weight gain and estimated gestation period
## by dividing the two cont. variables into 11 nonoverlapping groups
t5=table(births2006.smpl$ESTGEST)
t5

# Calculate avg birth weigh for each resulting group
# 99 is code for 'unknown.' We omit records with unknow gestation periods
new=births2006.smpl[births2006.smpl$ESTGEST !=99,]
t51=table(new$ESTGEST)
t51

# The 11th group = unknown, so levelplot only shows the remaining 10 groups
t6=tapply(new$DBWT, INDEX = list(cut(new$WTGAIN, breaks=10),
                                 cut(new$ESTGEST, breaks=10)),
          FUN = mean, na.rm=TRUE)
t6
levelplot(t6, scales = list(x = list(rot = 90)))

# Contourplot using lattice
contourplot(t6, scales = list(x = list(rot = 90)))

# The graphs show that the birth weight increases with the estimated gestation period,
# but birth weight is minimally affected by weight gain