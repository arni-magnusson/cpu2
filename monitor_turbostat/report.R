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
machines <- list(m4700=m4700, p15gen1=p15gen1, p3560=p3560, p1gen8=p1gen8)
machine_names <- setNames(info$name, info$machine)
machine_labels <- setNames(
  paste(info$name, paste("Intel", gsub(" ", "-", info$processor)), sep="\n"),
  info$machine)

# Plot machine comparison
comparison <- comparison_data(machines)
taf.png("comparison", 3600, 2400, res=300)
print(plot_comparison(comparison, machine_labels))
dev.off()

# Plot each machine
taf.png("each", 3600, 2400, res=300)
print(plot_each(each_data(machines, machine_names)))
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

# Write tables
write.taf(desc, dir="report")
write.taf(summary, dir="report")
