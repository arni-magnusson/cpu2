# Run analysis, write model results

# Before: m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds (data)
# After:  m4700_Repairs.png, m4700.rds,
#         p1gen8_Repairs.png, p1gen8.rds,
#         p15gen1_Repairs.png, p15gen1.rds,
#         p3560_Repairs.png, p3560.rds,
#         summary.csv (model)

library(TAF)
source("utilities.R")

mkdir("model")

# Read data
m4700 <- readRDS("data/m4700.rds")
p1gen8 <- readRDS("data/p1gen8.rds")
p15gen1 <- readRDS("data/p15gen1.rds")
p3560 <- readRDS("data/p3560.rds")

taf.png("model/m4700_Repairs")
par(mfrow=c(1, 4))
x <- m4700$idle$Freq
m4700$idle$Freq <- outliers(x, dist=600, plot=TRUE, main="Idle Freq")$repaired
x <- m4700$idle$Watt
m4700$idle$Watt <- outliers(x, dist=0.3, plot=TRUE, main="Idle Watt")$repaired
dev.off()

taf.png("model/p1gen8_Repairs")
par(mfrow=c(1, 4))
x <- p1gen8$main$Watt
p1gen8$main$Watt <- outliers(x, dist=20, plot=TRUE)$repaired
dev.off()

taf.png("model/p15gen1_Repairs")
par(mfrow=c(1, 4))
x <- p15gen1$idle$Watt
p15gen1$idle$Watt <- outliers(x, dist=0.2, plot=TRUE)$repaired
dev.off()

taf.png("model/p3560_Repairs")
par(mfrow=c(1, 4))
x <- p3560$single$Watt
p3560$single$Watt <- outliers(x, span=0.3, dist=0.5, plot=TRUE)$repaired
x <- p3560$idle$Watt
p3560$idle$Watt <- outliers(x, dist=5, plot=TRUE)$repaired
dev.off()

# Combine into list
machines <- list(m4700=m4700, p15gen1=p15gen1, p3560=p3560, p1gen8=p1gen8)

# Freq (idle)
idle <- sapply(machines, `[`, "idle")
idle <- sapply(idle, `[`, "Freq")
idle <- sapply(idle, mean)

# Freq (single)
single <- sapply(machines, `[`, "single")
single <- sapply(single, `[`, "Freq")
single1 <- lapply(single, head, 30)  # initial
single1 <- sapply(single1, mean)
single2 <- lapply(single, tail, 120)  # sustained
single2 <- sapply(single2, mean)

# Freq (main)
main <- sapply(machines, `[`, "main")
main <- sapply(main, `[`, "Freq")
main1 <- lapply(main, head, 30)  # initial
main1 <- sapply(main1, mean)
main2 <- lapply(main, tail, 120)  # sustained
main2 <- sapply(main2, mean)

# Freq (full)
full <- sapply(machines, `[`, "full")
full <- sapply(full, `[`, "Freq")
full1 <- lapply(full, head, 30)  # initial
full1 <- sapply(full1, mean)
full2 <- lapply(full, tail, 120)  # sustained
full2 <- sapply(full2, mean)

# Freq (spike)
spike <- sapply(machines, `[`, "single")
spike <- sapply(spike, `[`, "Freq")
spike <- sapply(spike, max)

# Watt
watt <- sapply(machines, `[`, "full")
watt <- sapply(watt, `[`, "Watt")
watt0 <- sapply(machines, `[`, "idle")
watt0 <- sapply(watt0, `[`, "Watt")
watt0 <- sapply(watt0, mean)
watt1 <- sapply(watt, max)  # maximum spike
watt2 <- lapply(watt, tail, 120)  # sustained
watt2 <- sapply(watt2, mean)

# Summary table
summary <- data.frame(machine=names(machines), idle, single1, single2, main1,
                      main2, full1, full2, spike, watt0, watt1, watt2,
                      row.names=NULL)

# Save RDS objects
saveRDS(m4700, "model/m4700.rds")
saveRDS(p1gen8, "model/p1gen8.rds")
saveRDS(p15gen1, "model/p15gen1.rds")
saveRDS(p3560, "model/p3560.rds")

# Save table
write.taf(summary, dir="model")
