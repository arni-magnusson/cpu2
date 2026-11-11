# Prepare data, write CSV data tables

# Before: catage.dat (boot/data)
# After:  catage.csv (data)

library(TAF)

mkdir("data")

# Read data
catage <- read.table("boot/data/catage.dat", header=TRUE)

# Write table
write.taf(catage, dir="data")
