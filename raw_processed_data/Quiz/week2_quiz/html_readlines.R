# read URL
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
lines <- readLines(url)
print(sapply(lines[c(10,20,30,100)], nchar))
