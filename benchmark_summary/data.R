# Prepare data, write CSV data tables
#
# Before: catage.dat, my_laptops.dat, passmark/*.dat (boot/data)
# After:  catage.csv, passmark.csv (data)

library(TAF)
source("boot/software/utilities.R")

mkdir("data")

# Read data
catage <- read.table("boot/data/catage.dat", header=TRUE)
m4700 <- readPass("boot/data/passmark/data/dell_precision_m4700.dat")
p1gen8 <- readPass("boot/data/passmark/data/lenovo_p1_gen8.dat")
p15gen1 <- readPass("boot/data/passmark/data/lenovo_p15_gen1.dat")
p3560 <- readPass("boot/data/passmark/data/dell_precision_3560.dat")
passmark.online <- read.table("boot/data/passmark_online/specs.dat",
                              header=TRUE)

# Create lookup table to convert labels to processor name
lookup <- data.frame(
  machine = c("m4700", "p1gen8", "p15gen1", "p3560"),
  processor = c("i7-3740QM", "u9-285H", "i7-10875H", "i7-1165G7"))

# Format catage measurements
catage <- catage[catage$mcmc==1e7,]
catage <- merge(catage, lookup)
catage <- catage[c("processor", "mcmc", "sec")]
catage <- catage[order(catage$processor),]

# Format local PassMark measurements
passmark.local <- data.frame(m4700=m4700$Value[m4700$Variable=="single"],
                             p1gen8=p1gen8$Value[p1gen8$Variable=="single"],
                             p15gen1=p15gen1$Value[p15gen1$Variable=="single"],
                             p3560=p3560$Value[p3560$Variable=="single"])
passmark.local <- data.frame(machine=names(passmark.local),
                             local=unlist(passmark.local), row.names=NULL)
passmark.local <- merge(passmark.local, lookup)
passmark.local <- passmark.local[c("processor", "local")]

# Format online PassMark measurements
passmark.online <- data.frame(processor=passmark.online$Model,
                              online=passmark.online$Single)

# Combine local and online PassMark measurements
passmark <- merge(passmark.online, passmark.local)

# WriRead catage run times
write.taf(catage, dir="data")
write.taf(passmark, dir="data")
