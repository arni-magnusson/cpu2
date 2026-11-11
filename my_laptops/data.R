# Prepare data, write CSV data tables

# Before: specs.dat (boot/data)
# After:  specs.csv (data)

library(TAF)

mkdir("data")

# Read data
specs <- read.table("boot/data/specs.dat", header=TRUE)

# Rename columns
names(specs)[names(specs) == "Single"] <- "Speed"

# Write table
write.taf(specs, dir="data")
