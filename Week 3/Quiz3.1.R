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
# Create a logical vector that identifies the households on greater than 10
# acres who sold more than $10,000 worth of agriculture products. Assign that
# logical vector to the variable agricultureLogical. Apply the which() function
# like this to identify the rows of the data frame where the logical vector is
# TRUE.
# 
# which(agricultureLogical)
# 
# What are the first 3 values that result?

library(dplyr)
setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 3/')
housing_data <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv', 'housing.csv')
housing_tb <- tbl_df(read.csv("housing.csv", stringsAsFactors = FALSE))
agricultureLogical <- housing_tb$ACR==3 & housing_tb$AGS==6
which(agricultureLogical) #      125  238  262               