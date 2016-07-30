# You can use the quantmod (http://www.quantmod.com/) package to get historical
# stock prices for publicly traded companies on the NASDAQ and NYSE. Use the
# following code to download data on Amazon's stock price and get the times the
# data was sampled.
# How many values were collected in 2012? How many values were collected on
# Mondays in 2012?

# xts is an extended time series object

library(quantmod)
library(lubridate)
amzn = getSymbols("AMZN", auto.assign=FALSE)

sampleTimes = index(amzn)
addmargins(table(year(sampleTimes), weekdays(sampleTimes)))

# How many values were collected in 2012?
#amzn_2012 <- amzn["2012"] 
#nrow(amzn_2012) #250

# How many values were collected on Mondays in 2012?
#mondays <- amzn_2012[.indexwday(amzn_2012) == 1]
#nrow(mondays) # 50