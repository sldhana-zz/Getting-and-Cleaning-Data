# The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the
# state of Idaho using download.file() from here:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is
# here:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# How many properties are worth $1,000,000 or more?
library(dplyr)
setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/')
housing_data <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 'housing.csv')
housing_tb <- tbl_df(read.csv("housing.csv", stringsAsFactors = FALSE))
housing_tb <- housing_tb %>%
  filter(VAL==24) 
nrow(housing_tb) #53


# Use the data you loaded from Question 1. Consider the variable FES in the code
# book. Which of the "tidy data" principles does this variable violate?
# tidy data has one variable per column - gender, marital status and empoloyement status in FES



# Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx

install.packages("xlsx")
library("xlsx")
setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 1/')
gas <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx', 'gas.xlsx')

# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called dat
dat <-  tbl_df(read.xlsx("gas.xlsx", 1, rowIndex=18:23))
sum(dat$Zip*dat$Ext,na.rm=T) #36534720


# Read the XML data on Baltimore restaurants from here:
#   
#   https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
# 
# How many restaurants have zipcode 21231?
library("XML")
library(RCurl)

data <- getURL("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml")
xml_data <- xmlParse(data)
root <- xmlRoot(xml_data)
table(xpathSApply(root, "//zipcode", xmlValue) == "21231") #127


# The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the
# state of Idaho using download.file() from here:
# 
# 
# 
# using the fread() command load the data into an R object
install.packages("data.table")
library(data.table)
comm <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv', "comm.csv")
DT <- fread("comm.csv")
system.time({
  tapply(DT$pwgtp15, DT$SEX, mean)
})

system.time({
  mean(DT$pwgtp15,by=DT$SEX)
})

system.time({
  sapply(split(DT$pwgtp15,DT$SEX),mean)
})

system.time({
  mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
})


system.time({
  rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
})

system.time({
  DT[,mean(pwgtp15),by=SEX]
})




