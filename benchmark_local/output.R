# Extract results of interest, write CSV output tables

# Before: info.csv, passmark.csv (model)
# After:  info.csv, passmark.csv (output)

library(TAF)

mkdir("output")

cp("model/*.csv", "output")
