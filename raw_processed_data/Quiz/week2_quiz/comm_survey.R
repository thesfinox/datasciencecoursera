library(sqldf)

# download file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv", "comm_survey.R")

# read file
acs <- read.csv("comm_survey.R")
query1 <- sqldf("SELECT pwgtp1 FROM acs WHERE AGEP < 50")
query2 <- sqldf("SELECT DISTINCT AGEP FROM acs")
print(query1)
print(query2)
