# Extract results of interest, write CSV output tables

# Before: cores.rds, m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds,
#         summary.csv (model)
# After:  cores.csv, m4700_*.csv, p1gen8_*.csv, p15gen1_*.csv, p3560_*.csv,
#         summary.csv (output)

library(TAF)

mkdir("output")

# Read data
cores <- readRDS("model/cores.rds")
m4700 <- readRDS("model/m4700.rds")
p1gen8 <- readRDS("model/p1gen8.rds")
p15gen1 <- readRDS("model/p15gen1.rds")
p3560 <- readRDS("model/p3560.rds")

# Copy summary
cp("model/summary.csv", "output")

# Combine list of cores into one table
cores <- lapply(cores, xtab2taf, "core")
cores <- xtab2taf(do.call(rbind, cores), "machine")
cores$machine <- sub("\\..*", "", cores$machine)
cores$core <- sub("Freq", "", cores$core)

# Write full results
write.taf(cores, dir="output")
write.taf(m4700$idle, "output/m4700_idle.csv")
write.taf(m4700$single, "output/m4700_single.csv")
write.taf(m4700$main, "output/m4700_main.csv")
write.taf(m4700$full, "output/m4700_full.csv")
write.taf(p1gen8$idle, "output/p1gen8_idle.csv")
write.taf(p1gen8$single, "output/p1gen8_single.csv")
write.taf(p1gen8$main, "output/p1gen8_main.csv")
write.taf(p1gen8$full, "output/p1gen8_full.csv")
write.taf(p15gen1$idle, "output/p15gen1_idle.csv")
write.taf(p15gen1$single, "output/p15gen1_single.csv")
write.taf(p15gen1$main, "output/p15gen1_main.csv")
write.taf(p15gen1$full, "output/p15gen1_full.csv")
write.taf(p3560$idle, "output/p3560_idle.csv")
write.taf(p3560$single, "output/p3560_single.csv")
write.taf(p3560$main, "output/p3560_main.csv")
write.taf(p3560$full, "output/p3560_full.csv")
