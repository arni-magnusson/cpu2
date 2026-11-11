# Prepare data, write CSV data tables

# Before: dell_precision_3560.dat, dell_precision_m4700.dat,
#         info.csv, lenovo_p1_gen8.dat, lenovo_p15_gen1.dat (boot/data)
# After:  info.csv, m4700.csv, p1gen8.csv, p15gen1.csv, p3560.csv,
#         passmark.csv (data)

library(TAF)
source("utilities.R")

mkdir("data")

# Read data
info <- read.taf("boot/data/info.csv")
m4700 <- readPass("boot/data/dell_precision_m4700.dat")
p1gen8 <- readPass("boot/data/lenovo_p1_gen8.dat")
p15gen1 <- readPass("boot/data/lenovo_p15_gen1.dat")
p3560 <- readPass("boot/data/dell_precision_3560.dat")

# Combine
passmark <- rbind(
  m4700 <- data.frame(machine="m4700", t(taf2xtab(m4700))),
  p1gen8 <- data.frame(machine="p1gen8", t(taf2xtab(p1gen8))),
  p15gen1 <- data.frame(machine="p15gen1", t(taf2xtab(p15gen1))),
  p3560 <- data.frame(machine="p3560", t(taf2xtab(p3560))))
passmark <- type.convert(passmark, as.is=TRUE)
row.names(passmark) <- NULL

# Write table
write.taf(info, dir="data")
write.taf(m4700, dir="data")
write.taf(p1gen8, dir="data")
write.taf(p15gen1, dir="data")
write.taf(p3560, dir="data")
write.taf(passmark, dir="data")
