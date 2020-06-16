# read file
dat <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")

# create logical vector
agricultureLogical <- (dat$ACR == 3 & dat$AGS == 6)
which(agricultureLogical)
