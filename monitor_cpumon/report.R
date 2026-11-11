# Produce plots and tables for report

# Before: info.csv (data)
#         cores.rds, m4700.rds, p1gen8.rds, p15gen1.rds, p3560.rds (model)
#         summary.csv (output)
# After:  comparison.png, cores.png, desc.csv, each.png, summary.csv (report)

library(TAF)
source("utilities.R")

mkdir("report")

# Read data
info <- read.taf("data/info.csv")
cores <- readRDS("model/cores.rds")
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
taf.png("comparison", 3600, 2400, res=300)
comparison <- comparison_data(machines)
print(plot_comparison(comparison, machine_labels))
dev.off()

# Plot cores
taf.png("cores", 1600, 1600)
print(plot_cores(core_data(cores), machine_names))
dev.off()

# Plot each machine
taf.png("each", 3600, 2400, res=300)
print(plot_each(each_data(machines, machine_names)))
dev.off()

# Round and divide values
summary <- rnd(summary, grep("idle|single|main|full|spike", names(summary)), -2)
summary <- div(summary, grep("idle|single|main|full|spike", names(summary)))

# Compact description
desc <- data.frame(machine=summary$machine,
                   rest=paste0(format(summary$idle1), "-",
                               format(summary$idle2)),
                   work=paste0(format(summary$main2), "-",
                               format(summary$single2)),
                   spike=summary$spike,
                   spec=paste0(format(info$freq), "-",
                               format(info$turbo)))

# Write tables
write.taf(desc, dir="report")
write.taf(summary, dir="report")
