library(dplyr)
library(ggplot2)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")

# Group by year and type, and compute total emissions
NEI <- NEI %>%
       filter(fips == "24510") %>%
       group_by(year, type) %>%
       summarise(Total.Emissions.Baltimore = sum(Emissions))

# Line plot the results
png(file = "plot3.png", width = 860, height = 640)
g <- ggplot(data = NEI, aes(x = year, y = Total.Emissions.Baltimore, color = type)) +
     geom_line() +
     labs(x = "Years", y = "Total PM2.5 emissions [tons]") +
     ggtitle("PM2.5 emissions in Baltimore") + 
     theme(plot.title = element_text(size = 40, face = "bold"))
print(g)
dev.off()
