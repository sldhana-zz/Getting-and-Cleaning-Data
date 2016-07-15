# Read this data set into R and report the sum of the numbers in the fourth of
# the nine columns.
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# 
# Original source of the data:
# http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# 
# (Hint this is a fixed width file format)
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
data <- read.fwf(file=url, skip=4, widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4), header = FALSE)
data[,4] <- as.numeric(data[, 4])
sum(data[, 4], na.rm=TRUE) #32426.7
