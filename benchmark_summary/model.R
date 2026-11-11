# Run analysis, write model results
#
# Before: catage.csv, passmark.csv (data)
# After:  catage.csv, passmark.csv, regression.csv (model)

library(TAF)

mkdir("model")

# Read data
catage <- read.taf("data/catage.csv")
passmark <- read.taf("data/passmark.csv")

# Calculate speed in catage results
catage$speed <- catage$mcmc / catage$sec / 1000
catage <- catage[c("processor", "speed")]

# Calculate difference between online and local PassMark score
passmark$difference <- passmark$local / passmark$online - 1

# Fit regression model to predict expected speed based on PassMark score
regression <- merge(catage, passmark[c("processor", "local")])
names(regression)[names(regression) == "speed"] <- "actual"
names(regression)[names(regression) == "local"] <- "passmark"
fm <- lm(actual~-1+passmark, regression)
slope <- coef(fm)[[1]]
regression$slope <- slope
regression$expected <- slope * regression$passmark

# Add expected speed to catage table
catage <- merge(catage, regression[c("processor", "expected")])
catage$difference <- catage$speed / catage$expected - 1

# Write tables
write.taf(catage, dir="model")
write.taf(passmark, dir="model")
write.taf(regression, dir="model")
