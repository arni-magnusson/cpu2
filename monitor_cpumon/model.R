# Run analysis, write model results

# Before: m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds (data)
# After:  m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds, summary.csv (model)

library(TAF)
source("utilities.R")  # means, remove_first, summary_machine

mkdir("model")

# Read data
m4700 <- readRDS("data/m4700.rds")
p1gen8 <- readRDS("data/p1gen8.rds")
p15gen1 <- readRDS("data/p15gen1.rds")
p3560 <- readRDS("data/p3560.rds")

# Remove first measurements, keep 300 measurements
m4700 <- mapply(remove_first, m4700, burn=c(3,1,1,1), SIMPLIFY=FALSE)
p1gen8 <- mapply(remove_first, p1gen8, burn=c(0,1,1,1), SIMPLIFY=FALSE)
p15gen1 <- mapply(remove_first, p15gen1, burn=c(0,0,0,1), SIMPLIFY=FALSE)
p3560 <- mapply(remove_first, p3560, burn=c(0,1,1,0), SIMPLIFY=FALSE)

# Prepare p15gen1 repairs
na.begin <- 257
na.count <- 300 - na.begin + 1
iter <- 1:300

# Repair p15gen1$idle$Freq1
steady.freq.begin <- 100
freq.measurements <- p15gen1$idle$Freq1[steady.freq.begin:(na.begin-1)]
set.seed(2)
freq.noise <- sample(freq.measurements, na.count)
p15gen1$idle$Freq1[na.begin:300] <- freq.noise

# Repair p15gen1$idle$Temp1
cool.begin <- 228
temp.coef <- coef(lm(Temp1~iter, p15gen1$idle, subset=cool.begin:na.begin))
temp.fit <- temp.coef[[1]] + temp.coef[[2]] * iter
set.seed(0)
temp.noise <- round(temp.fit + rnorm(300, 0, 0.3))
p15gen1$idle$Temp1[na.begin:300] <- temp.noise[na.begin:300]

# Repair p15gen1$idle$Fan1
steady.fan.begin <- 234
fan.measurements <- p15gen1$idle$Fan1[steady.fan.begin:(na.begin-1)]
fan.noise <- sample(fan.measurements, na.count, replace=TRUE)
p15gen1$idle$Fan1[na.begin:300] <- fan.noise

# Repair p15gen1$single
p15gen1$single$Freq1 <- c(4693, 4690)
p15gen1$single$Temp1 <- c(100, 100)
p15gen1$single$Fan1 <- c(3937, 3938)

# Combine into list
machines <- list(m4700=m4700, p15gen1=p15gen1, p3560=p3560, p1gen8=p1gen8)

# Freq (idle)
idle <- sapply(machines, `[`, "idle")
idle1 <- sapply(idle, `[`, "Freq4")
idle1 <- sapply(idle1, mean, na.rm=TRUE)
idle2 <- sapply(idle, `[`, "Freq1")
idle2 <- sapply(idle2, mean)

# Freq (single)
single <- sapply(machines, `[`, "single")
single <- sapply(single, `[`, "Freq1")
single1 <- lapply(single, head, 30)  # initial
single1 <- sapply(single1, mean)
single2 <- lapply(single, tail, 120)  # sustained
single2 <- sapply(single2, mean)

# Freq (main)
main <- sapply(machines, `[`, "main")
main <- sapply(main, `[`, "Freq4")
main1 <- lapply(main, head, 30)  # initial
main1 <- sapply(main1, mean)
main2 <- lapply(main, tail, 120)  # sustained
main2 <- sapply(main2, mean)

# Freq (full)
full <- sapply(machines, `[`, "full")
full <- sapply(full, `[`, "Freq4")
full1 <- lapply(full, head, 30)  # initial
full1 <- sapply(full1, mean)
full2 <- lapply(full, tail, 120)  # sustained
full2 <- sapply(full2, mean)

# Spike (single)
spike <- sapply(machines, `[`, "single")
spike <- sapply(spike, `[`, "Freq1")
spike <- sapply(spike, max)

# Differences between cores
cores <- list(m4700=data.frame(idle=colMeans(m4700$idle[1+(1:4)]),
                               single=colMeans(m4700$single[1+(1:4)]),
                               main=colMeans(m4700$main[1+(1:4)]),
                               full=colMeans(m4700$full[1+(1:4)])),
              p1gen8=data.frame(idle=colMeans(p1gen8$idle[1+(1:16)]),
                                single=colMeans(p1gen8$single[1+(1:16)]),
                                main=colMeans(p1gen8$main[1+(1:16)]),
                                full=colMeans(p1gen8$full[1+(1:16)])),
              p15gen1=data.frame(idle=colMeans(p15gen1$idle[1+(1:8)],
                                               na.rm=TRUE),
                                 single=colMeans(p15gen1$single[1+(1:8)],
                                                 na.rm=TRUE),
                                 main=colMeans(p15gen1$main[1+(1:8)]),
                                 full=colMeans(p15gen1$full[1+(1:8)])),
              p3560=data.frame(idle=colMeans(p3560$idle[1+(1:4)]),
                               single=colMeans(p3560$single[1+(1:4)]),
                               main=colMeans(p3560$main[1+(1:4)]),
                               full=colMeans(p3560$full[1+(1:4)])))

# Summary table
summary <- data.frame(machine=names(machines), idle1, idle2, single1, single2,
                      main1, main2, full1, full2, spike, row.names=NULL)
# Save RDS objects
saveRDS(cores, "model/cores.rds")
saveRDS(m4700, "model/m4700.rds")
saveRDS(p1gen8, "model/p1gen8.rds")
saveRDS(p15gen1, "model/p15gen1.rds")
saveRDS(p3560, "model/p3560.rds")

# Write table
write.taf(summary, dir="model")
