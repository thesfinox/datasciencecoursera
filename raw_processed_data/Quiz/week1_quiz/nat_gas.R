library(openxlsx)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "nat_gas.xlsx")

# read the file
dat <- read.xlsx("nat_gas.xlsx", rows = 18:23, cols = 7:15)

# compute given value
dat_sum <- sum(dat$Zip * dat$Ext, na.rm = T)
print(dat_sum)
