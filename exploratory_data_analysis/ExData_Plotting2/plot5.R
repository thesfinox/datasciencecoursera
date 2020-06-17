library(dplyr)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Select only motor vehicles (category == "onroad")
SCC.Motor <- SCC[SCC$Data.Category == "Onroad",]$SCC

# Subset and group by year and compute total emissions
NEI <- NEI %>%
       subset(SCC %in% SCC.Motor) %>%
       filter(fips == "24510") %>%
       group_by(year) %>%
       summarise(Total.Emissions = sum(Emissions))

# Bar plot the results
png(file = "plot5.png", width = 860, height = 640)
barplot(NEI$Total.Emissions,
        names.arg = NEI$year,
        ylab = "Emissions of PM2.5 [tons]",
        main = "Total emissions of PM2.5 by motor vehicles (i.e. on-road) in Baltimore per year"
       )
dev.off()
