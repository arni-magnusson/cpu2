# Run analysis, write model results

# Before: info.csv, passmark.csv (data)
# After:  info.csv, passmark.csv (model)

library(TAF)

mkdir("model")

# Read data
info <- read.taf("data/info.csv")
passmark <- read.taf("data/passmark.csv")

# Select and rename columns
passmark <- passmark[c("machine", "single", "cpu", "memory")]
names(passmark)[names(passmark) == "cpu"] <- "multi"

# Count physical cores
info$physcores <- info$cores
info$physcores <- sub("HT", "", info$physcores)
info$physcores <- sapply(info$physcores, function(x) eval(parse(text=x)))

# Compare multicore and single-core performance
passmark <- merge(passmark, info[c("machine", "physcores")])
passmark$effcores <- passmark$multi / passmark$single

# Write table
write.taf(info, dir="model")
write.taf(passmark, dir="model")
