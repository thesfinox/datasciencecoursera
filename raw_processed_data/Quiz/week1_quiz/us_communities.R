# Download the 2006 microdata survey about housing for the state of Idaho
url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dest <- "us_communities.csv"

download.file(url, dest, "curl")
dateDownloaded <- date()
print(dateDownloaded)

# How many properties are worth $1,000,000 or more?
data     <- read.csv(dest)
one_mill <- data[data$VAL == 24 & !is.na(data$VAL),]
print(paste("Properties worth > $1000000:", nrow(one_mill), sep = " "))
