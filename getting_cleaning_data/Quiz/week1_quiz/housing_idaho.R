library(data.table)

# download the file
file <- "housing_idaho.csv"

if(!file.exists(file)) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", file)
}

# read the file
DT <- fread("housing_idaho.csv")

# compute system time
M <- DT[, mean(pwgtp15), by=SEX]
print(system.time(DT[, mean(pwgtp15), by=SEX]))
print(M)
