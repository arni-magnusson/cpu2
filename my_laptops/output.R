# Extract results of interest, write CSV output tables

# Before: specs.csv, speed_fit.csv (model)
# After:  specs.csv, speed_fit.csv (output)

library(TAF)

mkdir("output")

cp("model/*.csv", "output")
