library(dplyr)

# Read the downloaded data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Select only coal related emissions (get a logical vector, subset and return the codes)
coal.emissions <- grepl("coal", SCC$Short.Name, ignore.case = TRUE)
SCC.Coal       <- SCC[coal.emissions,]$SCC

# Subset and group by year and compute total emissions
NEI <- NEI %>%
       subset(SCC %in% SCC.Coal) %>%
       group_by(year) %>%
       summarise(Total.Emissions = sum(Emissions))

# Bar plot the results
png(file = "plot4.png", width = 860, height = 640)
barplot(NEI$Total.Emissions,
        names.arg = NEI$year,
        ylab = "Emissions of PM2.5 [tons]",
        main = "Total emissions of PM2.5 by coal related sources per year"
       )
dev.off()
