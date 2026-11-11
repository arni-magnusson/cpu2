# Prepare data, write CSV data tables

# Before: info.csv (boot/data),
#         cpumon_*.dat (boot/data/dell_precision_m4700)
#         cpumon_*.dat (boot/data/lenovo_p1_gen8)
#         cpumon_*.dat (boot/data/lenovo_p15_gen1)
#         cpumon_*.dat (boot/data/dell_precision_p3560)
# After:  info.csv,
#         m4700_*.csv, m4700.rds,
#         p1gen8_*.csv, p1gen8.rds,
#         p15gen1_*.csv, p15gen1.rds,
#         p3560_*.csv, p3560.rds (data)

library(TAF)

mkdir("data")

# Read data
info <- read.csv("boot/data/info.csv")
m4700 <- list()
m4700$idle <- read.taf("boot/data/dell_precision_m4700/cpumon_0.csv")
m4700$single <- read.taf("boot/data/dell_precision_m4700/cpumon_1.csv")
m4700$main <- read.taf("boot/data/dell_precision_m4700/cpumon_4.csv")
m4700$full <- read.taf("boot/data/dell_precision_m4700/cpumon_8.csv")
p1gen8 <- list()
p1gen8$idle <- read.taf("boot/data/lenovo_p1_gen8/cpumon_0.csv")
p1gen8$single <- read.taf("boot/data/lenovo_p1_gen8/cpumon_1.csv")
p1gen8$main <- read.taf("boot/data/lenovo_p1_gen8/cpumon_6.csv")
p1gen8$full <- read.taf("boot/data/lenovo_p1_gen8/cpumon_16.csv")
p15gen1 <- list()
p15gen1$idle <- read.taf("boot/data/lenovo_p15_gen1/cpumon_0.csv")
p15gen1$single <- read.taf("boot/data/lenovo_p15_gen1/cpumon_1.csv")
p15gen1$main <- read.taf("boot/data/lenovo_p15_gen1/cpumon_8.csv")
p15gen1$full <- read.taf("boot/data/lenovo_p15_gen1/cpumon_16.csv")
p3560 <- list()
p3560$idle <- read.taf("boot/data/dell_precision_3560/cpumon_0.csv")
p3560$single <- read.taf("boot/data/dell_precision_3560/cpumon_1.csv")
p3560$main <- read.taf("boot/data/dell_precision_3560/cpumon_4.csv")
p3560$full <- read.taf("boot/data/dell_precision_3560/cpumon_8.csv")

# Remove nonexistent Fan3
p1gen8$idle$Fan3 <- NULL
p1gen8$single$Fan3 <- NULL
p1gen8$main$Fan3 <- NULL
p1gen8$full$Fan3 <- NULL

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
