# Load the Gross Domestic Product data for the 190 ranked countries in this data
# set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average
# them. What is the average?
# 
# Original data sources:
# 
# http://data.worldbank.org/data-catalog/GDP-ranking-table

library(dplyr)
setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 4/')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', 'gdp.csv')
gdp <- read.csv("gdp.csv", 
                stringsAsFactors = FALSE, 
                skip=4
)[, c(1, 2, 4, 5)]
colnames(gdp) <-c("CountryCode", "Ranking", "Economy", "GDP")
# remove empty columns
gdp <- gdp %>%
  select(CountryCode, Economy, Ranking, GDP)

# select 190 rows
gdp <- slice(gdp, 1:190)

#cast GDP to number
gdp <- mutate(gdp, GDP=as.numeric(gsub(pattern=",", replacement="", x=as.character(GDP))))

mean(gdp$GDP) #377652.4

#----------------------------------------------------------------------------------------------------------------
# In the data set from Question 2 what is a regular expression that would allow
# you to count the number of countries whose name begins with "United"? Assume
# that the variable with the country names in it is named countryNames. How many
# countries begin with United?
grep("^United",gdp$Economy), #3