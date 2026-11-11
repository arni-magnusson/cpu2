# Prepare data, write CSV data tables

# Before: info.csv (boot/data),
#         turbo_*.dat (boot/data/dell_precision_m4700)
#         turbo_*.dat (boot/data/lenovo_p1_gen8)
#         turbo_*.dat (boot/data/lenovo_p15_gen1)
#         turbo_*.dat (boot/data/dell_precision_p3560)
# After:  info.csv,
#         m4700_*.csv, m4700.rds,
#         p1gen8_*.csv, p1gen8.rds,
#         p15gen1_*.csv, p15gen1.rds,
#         p3560_*.csv, p3560.rds (data)

library(TAF)
source("utilities.R")

mkdir("data")

# Read data
info <- read.csv("boot/data/info.csv")
m4700 <- list()
m4700$idle <- read_turbostat("boot/data/dell_precision_m4700/turbo_0.dat")
m4700$single <- read_turbostat("boot/data/dell_precision_m4700/turbo_1.dat")
m4700$main <- read_turbostat("boot/data/dell_precision_m4700/turbo_4.dat")
m4700$full <- read_turbostat("boot/data/dell_precision_m4700/turbo_8.dat")
p1gen8 <- list()
p1gen8$idle <- read_turbostat("boot/data/lenovo_p1_gen8/turbo_0.dat")
p1gen8$single <- read_turbostat("boot/data/lenovo_p1_gen8/turbo_1.dat")
p1gen8$main <- read_turbostat("boot/data/lenovo_p1_gen8/turbo_6.dat")
p1gen8$full <- read_turbostat("boot/data/lenovo_p1_gen8/turbo_16.dat")
p15gen1 <- list()
p15gen1$idle <- read_turbostat("boot/data/lenovo_p15_gen1/turbo_0.dat")
p15gen1$single <- read_turbostat("boot/data/lenovo_p15_gen1/turbo_1.dat")
p15gen1$main <- read_turbostat("boot/data/lenovo_p15_gen1/turbo_8.dat")
p15gen1$full <- read_turbostat("boot/data/lenovo_p15_gen1/turbo_16.dat")
p3560 <- list()
p3560$idle <- read_turbostat("boot/data/dell_precision_3560/turbo_0.dat")
p3560$single <- read_turbostat("boot/data/dell_precision_3560/turbo_1.dat")
p3560$main <- read_turbostat("boot/data/dell_precision_3560/turbo_4.dat")
p3560$full <- read_turbostat("boot/data/dell_precision_3560/turbo_8.dat")

# Write tables
write.taf(info, dir="data")
write.taf(m4700$idle, "data/m4700_idle.csv")
write.taf(m4700$single, "data/m4700_single.csv")
write.taf(m4700$main, "data/m4700_main.csv")
write.taf(m4700$full, "data/m4700_full.csv")
write.taf(p1gen8$idle, "data/p1gen8_idle.csv")
write.taf(p1gen8$single, "data/p1gen8_single.csv")
write.taf(p1gen8$main, "data/p1gen8_main.csv")
write.taf(p1gen8$full, "data/p1gen8_full.csv")
write.taf(p15gen1$idle, "data/p15gen1_idle.csv")
write.taf(p15gen1$single, "data/p15gen1_single.csv")
write.taf(p15gen1$main, "data/p15gen1_main.csv")
write.taf(p15gen1$full, "data/p15gen1_full.csv")
write.taf(p3560$idle, "data/p3560_idle.csv")
write.taf(p3560$single, "data/p3560_single.csv")
write.taf(p3560$main, "data/p3560_main.csv")
write.taf(p3560$full, "data/p3560_full.csv")

# Save RDS objects
saveRDS(m4700, "data/m4700.rds")
saveRDS(p1gen8, "data/p1gen8.rds")
saveRDS(p15gen1, "data/p15gen1.rds")
saveRDS(p3560, "data/p3560.rds")
