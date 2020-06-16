# read data
data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", stringsAsFactors = FALSE, skip = 4, nrows = 190)
data <- data[,c(1,2,4,5)]
colnames(data) <- c("CountryCode", "Rank", "Country", "GDP")

# remove commas
data$GDP <- as.numeric(gsub(",", "", data$GDP))

# compute the mean
print(mean(data$GDP, na.rm = TRUE))
