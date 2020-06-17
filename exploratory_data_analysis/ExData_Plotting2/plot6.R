library(dplyr)
library(ggplot2)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Select only motor vehicles (category == "onroad")
SCC.Motor <- SCC[SCC$Data.Category == "Onroad",]$SCC

# Subset and group by year and compute total emissions
NEI <- NEI %>%
       subset(SCC %in% SCC.Motor) %>%
       filter(fips == "24510" | fips == "06037") %>%
       group_by(year, fips) %>%
       summarise(Total.Emissions = sum(Emissions))

# correct the name of the cities ("fips") in human readable format
cities         <- factor(NEI$fips)
levels(cities) <- c("Los Angeles", "Baltimore")
NEI$fips       <- cities
colnames(NEI)[colnames(NEI) == "fips"] <- "City"

# Bar plot the results
png(file = "plot6.png", width = 860, height = 640)
g <- ggplot(data = NEI, aes(x = year, y = Total.Emissions, fill = City)) +
     geom_bar(stat = "identity", position = "dodge") +
     scale_x_continuous(breaks = unique(NEI$year)) +
     labs(x = "Years", y = "Total PM2.5 emissions [tons]") +
     ggtitle("PM2.5 by motor vehicles in LA and Baltimore") +
     theme(plot.title = element_text(size = 24, face = "bold"))

print(g)
dev.off()
