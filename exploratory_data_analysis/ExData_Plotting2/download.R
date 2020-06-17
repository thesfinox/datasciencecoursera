# Download the assignments files
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
out <- "exdata.zip"

if(!file.exists(out)) { download.file(url, out, method = "curl") }
unzip(out)
