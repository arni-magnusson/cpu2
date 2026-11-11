# Run analysis, write model results

# Before: catage.csv (data)
# After:  catage.csv (model)

library(TAF)

mkdir("model")

# Read data
catage <- read.taf("data/catage.csv")

# Calculate speed (thousands of MCMC iterations/sec)
catage$job <- ifelse(catage$mcmc == 1e5, "short", "sustained")
catage$speed <- catage$mcmc / catage$sec / 1000

# Write table
write.taf(catage, dir="model")
