# Load the Gross Domestic Product data for the 190 ranked countries in this data
# set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which the
# end of the fiscal year is available, how many end in June?
# 
# Original data sources:
# 
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats

library(dplyr)
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

gdp <- mutate(gdp, Ranking=as.numeric(Ranking))

gdp <- filter(gdp, Ranking != '' & CountryCode != '')

fed <- download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv', 'fed.csv')
fed <- read.csv("fed.csv", stringsAsFactors = FALSE)

# merge based on country code
merged <- merge(gdp, fed, by="CountryCode")
grep("^Fiscal year end: June*", merged$Special.Notes) #13

                