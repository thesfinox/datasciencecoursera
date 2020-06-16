library(quantmod)
library(lubridate)

# get symbols
amazon <- getSymbols("AMZN", auto.assign = FALSE)
sampleTimes <- lapply(index(amazon), ymd)

# how many in 2012?
years <- lapply(sampleTimes, year)
print(paste("2012:", sum(years == 2012), sep = " "))

# how many Mondays in 2012?
days <- lapply(sampleTimes, wday)
print(paste("2012 and Mondays:", sum((years == 2012 & days == 2)), sep = " "))
