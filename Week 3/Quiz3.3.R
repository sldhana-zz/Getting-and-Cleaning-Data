# Load the Gross Domestic Product data for the 190 ranked countries in this data
# set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. How many of the IDs match? Sort
# the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame?
# 
# Original data sources:
# 
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats

setwd('/home/sldhana/Learning/Getting-and-Cleaning-Data/Week 3/')
download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', 'gdp.csv')
gdp <- read.csv("gdp.csv", 
                stringsAsFactors = FALSE, 
                skip=4
                )[, c(1, 2, 4, 5)]
colnames(gdp) <-c("CountryCode", "Ranking", "Economy", "GDP")
# remove empty columns
gdp <- gdp %>%
    select(CountryCode, Economy, Ranking, GDP)
#cast GDP to number
gdp <- mutate(gdp, GDP=as.numeric(gsub(pattern=",", replacement="", x=as.character(GDP))))

gdp <- mutate(gdp, Ranking=as.numeric(Ranking))

gdp <- filter(gdp, Ranking != '' & CountryCode != '')


fed <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv', 'fed.csv')
fed <- read.csv("fed.csv", stringsAsFactors = FALSE)

# merge based on country code
merged <- merge(gdp, fed, by="CountryCode")
nrow(merged) #189

sorted <- arrange(merged, desc(Ranking), CountryCode)
slice(sorted, 13)
# St. Kitts and Nevis St. Kitts and Nevis

#----------------------------------------------------------------------------------------

# What is the average GDP ranking for the "High income: OECD" and "High income:
# nonOECD" group?
high_income_oecd <- filter(sorted, Income.Group == 'High income: OECD')
mean(high_income_oecd$Ranking) # 32.96667

#High income nonOECD
high_income_nonoecd <- filter(sorted, Income.Group == 'High income: nonOECD')
mean(high_income_nonoecd$Ranking) # 91.91304

#----------------------------------------------------------------------------------------
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus
# Income.Group. How many countries
# are Lower middle income but among the 38 nations with highest GDP?

sorted$gdp_groups <- cut(sorted$Ranking, breaks=quantile(sorted$Ranking))
sorted[Income.Group == 'Lower middle income', .N, by=c("Income.Group", "gdp_groups")]

library(Hmisc)
sorted$groups = cut2(sorted$Ranking, g = 5)
table(sorted$Income.Group, sorted$groups)

# [  1, 39) [ 39, 77) [ 77,115) [115,154) [154,190]
# High income: nonOECD         4         5         8         5         1
# High income: OECD           18        10         1         1         0
# Lower middle income          5        13        12         8        16
# Low income                   0         1         9        16        11
# Upper middle income         11         9         8         8         9