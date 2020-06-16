# read file
data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", stringsAsFactors = FALSE)

# apply strsplit
splits <- strsplit(names(data), "wgtp")
print(splits[123])
