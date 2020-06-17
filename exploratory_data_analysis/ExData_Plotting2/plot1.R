library(dplyr)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")

# Group by year and compute total emissions
NEI <- NEI %>% group_by(year) %>% summarise(Total.Emissions = sum(Emissions))

# Bar plot the results
png(file = "plot1.png", width = 860, height = 640)
barplot(NEI$Total.Emissions,
        names.arg = NEI$year,
        ylab = "Emissions of PM2.5 [tons]",
        main = "Total emissions of PM2.5 per year"
       )
dev.off()
