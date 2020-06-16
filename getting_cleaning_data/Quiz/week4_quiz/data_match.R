# read data
gdp <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", nrows = 190, skip = 5)
gdp <- gdp[,c(1,2,4,5)]
colnames(gdp) <- c("CountryCode", "Rank", "Country", "GDP")

edu <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")

# match data
merged <- merge(gdp, edu, by.x="CountryCode", by.y="CountryCode")

# end of fiscal year by June 30th
fiscal <- merged[grep("Fiscal year end: June", merged$Special.Notes),]
print(paste("End of fiscal year in June:", dim(fiscal)[1], sep = " "))
