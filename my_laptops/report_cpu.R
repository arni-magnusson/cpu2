# Plot CPU variables

# Before: specs.csv, speed_fit.csv (output)
# After:  cpu_cache.png, cpu_cores.png, cpu_freq.png, cpu_nm.png,
#         cpu_speed_data.png, cpu_speed_fit.png, cpu_speed_nm.png,
#         cpu_speed_watt.png, cpu_threads.png, cpu_watt.png (report)

library(TAF)

mkdir("report")

# Read data
specs <- read.taf("output/specs.csv", colClasses=c(Date="Date"))
speed.fit <- read.taf("output/speed_fit.csv", colClasses=c(Date="Date"))

# Univariate time series
taf.png("cpu_cache")
plot(Cache~Date, specs, log="y", pch=21, bg=bg, yaxt="n", ylim=c(0.4, 32),
     main="CPU: On-chip memory", ylab="Cache (MB)")
values <- c("0.5", "1", "2", "4", "8", "16", "32")
axis(2, as.numeric(values), values)
dev.off()

taf.png("cpu_cores")
plot(Cores~Date, specs, pch=21, bg=bg, yaxt="n", ylim=c(0.5, 8.5),
     main="CPU: Processing units", ylab="Number of cores")
axis(2, c(1,2,4,6,8))
dev.off()

taf.png("cpu_freq")
plot(Turbo/1000~Date, specs, log="y", pch=21, bg=bg, ylim=c(2,6),
     main="CPU: Maximum frequency", ylab="Turbo (GHz)")
dev.off()

taf.png("cpu_nm")
plot(nm~Date, specs, log="y", pch=21, bg=bg, ylim=c(2.5, 150),
     main="CPU: Semiconductor technology", ylab="Process node (nm)")
dev.off()

taf.png("cpu_speed_data")
plot(Speed~Date, specs, log="y", pch=21, bg=bg, ylim=c(350, 5000),
     main="CPU: Benchmark performance", ylab="Score (PassMark single thread)")
dev.off()

taf.png("cpu_threads")
plot(Threads~Date, specs, pch=21, bg=bg, yaxt="n", ylim=c(0.5, 16.5),
     main="CPU: Parallel processing capacity", ylab="Number of threads")
values <- c(0.9, 2.1, 4, 6, 8, 10, 12, 14, 16)
axis(2, values, round(values))
dev.off()

taf.png("cpu_watt")
plot(W~Date, specs, ylim=lim(W), pch=21, bg=bg,
     main="CPU: Processor power", ylab="Thermal design power (W)")
dev.off()

# Fitted historical trend
taf.png("cpu_speed_fit")
plot(Speed~Date, specs, log="y", pch=21, bg=bg, ylim=c(350, 5000),
     main="CPU: Performance trend", ylab="Score (PassMark single thread)")
lines(Speed~Date, speed.fit)
dev.off()

# Relationships between variables
taf.png("cpu_speed_freq")
plot(Speed~I(Turbo/1000), specs, log="xy", pch=21, bg=bg, ylim=c(350, 5000),
     main="CPU: Frequency and performance", xlab="Turbo (GHz)",
     ylab="Score (PassMark single thread)")
dev.off()

taf.png("cpu_speed_nm")
plot(Speed~sqrt(nm), specs, log="y", pch=21, bg=bg, ylim=c(350, 5000),
     main="CPU: Performance and semiconductor technology",
     xlab="sqrt(Process node)", ylab="Score (PassMark single thread)")
dev.off()

taf.png("cpu_speed_watt_nm")
plot(Speed/W~Date, specs, log="y", pch=21, bg=bg, ylim=c(4.4,160),
     main="CPU: Processor efficiency",
     xlab="sqrt(Process node)", ylab="Single-thread performance per watt")
dev.off()
