# Extract results of interest, write CSV output tables

# Before: catage.csv (model)
# After:  catage.csv (output)

library(TAF)

mkdir("output")

# Read data
catage <- read.taf("model/catage.csv")

# Remove unnecessary columns
catage$mcmc <- catage$mcsave <- catage$sec <- NULL

# Write table
write.taf(catage, dir="output")
