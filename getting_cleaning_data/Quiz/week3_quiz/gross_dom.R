library(plyr)
library(Hmisc)

# read data
gdp <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", stringsAsFactors = FALSE, skip=5, nrows=190, header = FALSE)
edu <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", stringsAsFactors = FALSE)

# handle data
gdp <- gdp[, c(1,2,4,5)]
colnames(gdp) <- c("CountryCode", "Ranking", "Country.Name", "GDP.Value")
gdp$GDP.Value <- as.numeric(gsub(",", "", gdp$GDP.Value))

# merge
merged <- merge(gdp, edu, by.x="CountryCode", by.y="CountryCode")
print(paste("No. of matches:", dim(merged)[1], sep = " "))

# sort data
print(arrange(merged, desc(Ranking))[13,3])

# get high income groups
mean <- tapply(merged$Ranking, merged$Income.Group, mean)
print(mean)

# create cuts
merged$Ranking.Groups <- cut2(merged$Ranking, g=5)
print(table(merged$Income.Group, merged$Ranking.Groups))
