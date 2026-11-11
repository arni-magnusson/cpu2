# Produce plots and tables for report

# Before: info.csv (data), m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds (model)
#         summary.csv (output)
# After:  comparison.png, desc.csv, each.png, summary.csv (report)

library(TAF)
source("utilities.R")

mkdir("report")

# Read data
info <- read.taf("data/info.csv")
m4700 <- readRDS("model/m4700.rds")
p1gen8 <- readRDS("model/p1gen8.rds")
p15gen1 <- readRDS("model/p15gen1.rds")
p3560 <- readRDS("model/p3560.rds")
summary <- read.taf("output/summary.csv")

# Prepare plot elements
iter <- seq(1:nrow(m4700$idle))
machines <- list(m4700=m4700, p15gen1=p15gen1, p3560=p3560, p1gen8=p1gen8)

# Smooth m4700
smooth_m4700 <- m4700
smooth_m4700$full$Watt <- mean(m4700$full$Watt)
smooth_m4700$main$Watt <- mean(m4700$main$Watt)
smooth_m4700$single$Watt <- mean(m4700$single$Watt)
smooth_m4700$idle$Watt <- mean(m4700$idle$Watt)

# Smooth p1gen8
smooth_p1gen8 <- p1gen8
smooth_p1gen8$full$Watt <- loess(Watt~iter, p1gen8$full, span=0.4)$fitted
smooth_p1gen8$main$Watt <- loess(Watt~iter, p1gen8$main, span=0.4)$fitted
smooth_p1gen8$single$Watt <- loess(Watt~iter, p1gen8$single, span=0.6)$fitted
smooth_p1gen8$idle$Watt <- mean(p1gen8$idle$Watt)

# Smooth p15gen1
smooth_p15gen1 <- p15gen1
smooth_p15gen1$full$Watt <- loess(Watt~iter, p15gen1$full, span=0.9)$fitted
smooth_p15gen1$main$Watt <- loess(Watt~iter, p15gen1$main, span=0.9)$fitted
smooth_p15gen1$single$Watt <- loess(Watt~iter, p15gen1$single, span=0.9)$fitted
mean(p15gen1$idle$Watt)

# Smooth p3560
smooth_p3560 <- p3560
smooth_p3560$full$Watt <- loess(Watt~iter, p3560$full, span=0.11)$fitted
smooth_p3560$main$Watt <- loess(Watt~iter, p3560$main, span=0.21)$fitted
stable <- replace(p3560$single$Watt, 120:300, mean(p3560$single$Watt[120:300]))
smooth_p3560$single$Watt <- loess(stable~iter, span=0.30)$fitted
smooth_p3560$idle <- mean(p3560$idle$Watt)

# Plot each machine
taf.png("each", 3600, 2400, res=300)
par(mfrow=c(3,4))
plot_machine(m4700, "Freq")
plot_machine(p15gen1, "Freq")
plot_machine(p3560, "Freq")
plot_machine(p1gen8, "Freq")
plot_machine(m4700, "Temp")
plot_machine(p15gen1, "Temp")
plot_machine(p3560, "Temp")
plot_machine(p1gen8, "Temp")
plot_machine(m4700, "Watt")
plot_machine(p15gen1, "Watt")
plot_machine(p3560, "Watt")
plot_machine(p1gen8, "Watt")
dev.off()

# Plot machine comparison
taf.png("comparison", 3600, 2400, res=300)
par(mfrow=c(3,4))
plot_comparison(machines, "idle", "Freq")
plot_comparison(machines, "single", "Freq")
plot_comparison(machines, "main", "Freq")
plot_comparison(machines, "full", "Freq")
plot_comparison(machines, "idle", "Temp")
plot_comparison(machines, "single", "Temp")
plot_comparison(machines, "main", "Temp")
plot_comparison(machines, "full", "Temp")
plot_comparison(machines, "idle", "Watt")
plot_comparison(machines, "single", "Watt")
plot_comparison(machines, "main", "Watt")
plot_comparison(machines, "full", "Watt")
dev.off()

# Round and divide values
summary <- rnd(summary, grep("idle|single|main|full|spike", names(summary)), -2)
summary <- div(summary, grep("idle|single|main|full|spike", names(summary)))
summary <- rnd(summary, grep("watt", names(summary)))

# Compact description
desc <- data.frame(machine=summary$machine,
                   freq.idle=summary$idle,
                   freq.work=paste0(summary$full2, "-", summary$single2),
                   freq.spike=summary$spike,
                   watt.idle=paste0(summary$watt0, "W"),
                   watt.work=paste0(summary$watt2, "-", summary$watt1, "W"),
                   spec=paste0(info$freq, "-", info$turbo),
                   tdp=paste0(info$watt, "W"))

# Write table
write.taf(desc, dir="report")
write.taf(summary, dir="report")
