# load XML library
library(XML)

# Read the XML data on Baltimore restaurants
url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
dest <- "baltimore_res.xml"

download.file(url, dest, "curl")
dateDownloaded <- date()
print(dateDownloaded)

# Get XML nodes
data     <- xmlTreeParse(dest, useInternalNodes = TRUE)
rootNode <- xmlRoot(data)
listNode <- rootNode[[1]][[1]]

#How many restaurants have zipcode 21231?
zipcodes <- xpathSApply(listNode, "//zipcode", xmlValue)
n_rest   <- sum(as.numeric(zipcodes == 21231))
print(paste("No. of restaurants with zipcode 21231:", n_rest, sep = " "))
