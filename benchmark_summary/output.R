# Extract results of interest, write CSV output tables
#
# Before: catage.csv, passmark.csv, regression.csv (model)
# After:  catage.csv, passmark.csv, regression.csv (output)

library(TAF)

mkdir("output")

cp("model/*.csv", "output")
