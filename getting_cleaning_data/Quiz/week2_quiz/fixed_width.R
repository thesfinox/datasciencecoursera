# read the file
dat <- readLines("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for")
dat <- dat[-(1:4)] # skip first four lines

# adjust width
col1 <- substr(dat, 2, 10)
col2 <- substr(dat, 16, 19)
col3 <- substr(dat, 21, 23)
col4 <- substr(dat, 29, 32)

data <- data.frame(Name = col1, SST = col4)
print(sum(as.numeric(data$SST)))
