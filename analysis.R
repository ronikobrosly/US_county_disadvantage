library(caret)
library(corrplot)
library(maps)
library(mapproj)

# READ IN MERGED COUNTY SOCIOECONOMIC DATASET 
dataset <- read.csv("/Users/kobrosly/Dropbox/county data/Master.csv", header=T)

# ENSURING THAT ALL SOCIOECONOMIC VARIABLES ARE ORDERED IN THE SAME DIRECTION
dataset$population_change_fixed <- (-1 * dataset$population_change)
dataset$non_white_per <- (100 - dataset$white_per)
dataset$bachelors_per_fixed <- (100 - dataset$bachelors_per)
dataset$household_income_75k_per_fixed <- (100 - dataset$household_income_75k_per)
dataset$owner_occupied_per_fixed <- (100 - dataset$owner_occupied_per)

# REMOVE ALL MISSING OBSERVATIONS
dataset <- na.omit(dataset)

# EXAMINE CORRELATIONS AMONG ALL RELEVANT SOCIOECONOMIC VARIABLES
temp <- data.frame(dataset$population_change_fixed, dataset$non_white_per, dataset$latino_per, dataset$bachelors_per_fixed, dataset$household_income_75k_per_fixed, dataset$poverty_per, dataset$infant_death_per_1000_births, dataset$medicare_per_100000, dataset$owner_occupied_per_fixed, dataset$unemploy_rate)
corr.data <- cor(temp)
corrplot(corr.data, order="hclust")

# FACTOR ANALYSIS
test <- factanal(~ population_change_fixed + non_white_per + latino_per + bachelors_per_fixed + household_income_75k_per_fixed + poverty_per + infant_death_per_1000_births + medicare_per_100000 + owner_occupied_per_fixed + unemploy_rate,
factors = 1, data = dataset, scores = "regression", rotation = "promax")

final <- data.frame(dataset$FIPS, dataset$names, test$scores)
colnames(final) <- c("FIPS", "Names", "Disadvantage")


# CREATE CHOROPLETH MAP
pdf("/Users/kobrosly/desktop/map.pdf", width = 11, height = 8)

data(county.fips)

colors = c("#E0CCF5", "#C299EB", "#A366E0", "#8533D6", "#5200A3")
quantile(final$Disadvantage, c(0, 0.2, 0.4, 0.6, 0.8, 1.0))
final$colorBuckets <- as.numeric(cut(final$Disadvantage, c(-5.33, -0.53, 0.068, 0.40, 0.70, 1.79)))
leg.txt <- c("<20% (Advantage)", "20-40%", "40-60%", "60-80%", ">80% (Disadvantage)")

cnty.fips <- county.fips$fips[match(map("county", plot=FALSE)$names,county.fips$polyname)]
colorsmatched <- final$colorBuckets [match(cnty.fips, final$FIPS)]

map("county", col = colors[colorsmatched], fill = TRUE, resolution = 0, lty = 0, projection = "polyconic", mar = c(4.1, 4.1, par("mar")[3], 0.1), myborder = 0.01)
map("state", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2, projection="polyconic", mar = c(4.1, 4.1, par("mar")[3], 0.1), myborder = 0.01)
title("Socioeconomic Disadvantage By US Counties, Based on 2005 Census Data")
legend("bottomleft", leg.txt, horiz = FALSE, fill = colors)

dev.off()
