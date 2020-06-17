library(dplyr)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")

# Group by year and compute total emissions
NEI <- NEI %>%
       filter(fips == "24510") %>%
       group_by(year) %>%
       summarise(Total.Emissions.Baltimore = sum(Emissions))

# Bar plot the results
png(file = "plot2.png", width = 860, height = 640)
barplot(NEI$Total.Emissions.Baltimore,
        names.arg = NEI$year,
        ylab = "Emissions of PM2.5 [tons]",
        main = "Total emissions of PM2.5 in Baltimore per year"
       )
dev.off()

