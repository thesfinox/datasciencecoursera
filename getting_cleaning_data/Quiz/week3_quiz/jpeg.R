library(jpeg)

# read JPEG
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url, "pic.jpg")
pic <- readJPEG("pic.jpg", native = TRUE)

# read quantile
q <- quantile(pic, probs = c(0.3, 0.8))
print(q)
