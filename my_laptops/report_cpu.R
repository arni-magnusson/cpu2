# Plot CPU variables
#
# Before: specs.csv, speed_fit.csv (output)
# After:  cpu_cache.png, cpu_cores.png, cpu_freq.png, cpu_nm.png,
#         cpu_speed_data.png, cpu_speed_fit.png, cpu_speed_nm.png,
#         cpu_speed_watt_nm.png, cpu_threads.png, cpu_watt.png (report)

library(TAF)
source("report_utilities.R")

mkdir("report")

# Read data
specs <- read.taf("output/specs.csv", colClasses=c(Date="Date"))
speed.fit <- read.taf("output/speed_fit.csv", colClasses=c(Date="Date"))
specs$TurboGHz <- specs$Turbo / 1000
specs$SqrtNm <- sqrt(specs$nm)
specs$Efficiency <- specs$Speed / specs$W

# Univariate time series
cache_breaks <- c("0.5", "1", "2", "4", "8", "16", "32")
save_plot("cpu_cache",
  plot_points(specs, "Date", "Cache", "CPU: On-chip memory",
              "Cache (MB)", log_y=TRUE, y_limits=c(0.4, 32),
              y_breaks=as.numeric(cache_breaks), y_labels=cache_breaks))

save_plot("cpu_cores",
  plot_points(specs, "Date", "Cores", "CPU: Processing units",
              "Number of cores", y_limits=c(0.5, 8.5),
              y_breaks=c(1, 2, 4, 6, 8)))

save_plot("cpu_freq",
  plot_points(specs, "Date", "TurboGHz", "CPU: Maximum frequency",
              "Turbo (GHz)", log_y=TRUE, y_limits=c(2, 6)))

save_plot("cpu_nm",
  plot_points(specs, "Date", "nm", "CPU: Semiconductor technology",
              "Process node (nm)", log_y=TRUE, y_limits=c(2.5, 150)))

save_plot("cpu_speed_data",
  plot_points(specs, "Date", "Speed", "CPU: Benchmark performance",
              "Score (PassMark single thread)", log_y=TRUE,
              y_limits=c(350, 5000)))

thread_breaks <- c(0.9, 2.1, 4, 6, 8, 10, 12, 14, 16)
save_plot("cpu_threads",
  plot_points(specs, "Date", "Threads", "CPU: Parallel processing capacity",
              "Number of threads", y_limits=c(0.5, 16.5),
              y_breaks=thread_breaks, y_labels=round(thread_breaks)))

save_plot("cpu_watt",
  plot_points(specs, "Date", "W", "CPU: Processor power",
              "Thermal design power (W)", y_limits=lim(specs$W)))

# Fitted historical trend
speed_fit_plot <- plot_points(
  specs, "Date", "Speed", "CPU: Performance trend",
  "Score (PassMark single thread)", log_y=TRUE, y_limits=c(350, 5000)) +
  geom_line(data=speed.fit, aes(x=Date, y=Speed), inherit.aes=FALSE,
            color="#0072B2", linewidth=0.9)
save_plot("cpu_speed_fit", speed_fit_plot)

# Relationships between variables
save_plot("cpu_speed_freq",
  plot_points(specs, "TurboGHz", "Speed", "CPU: Frequency and performance",
              "Score (PassMark single thread)", xlab="Turbo (GHz)",
              log_x=TRUE, log_y=TRUE, y_limits=c(350, 5000)))

save_plot("cpu_speed_nm",
  plot_points(specs, "SqrtNm", "Speed",
              "CPU: Performance and semiconductor technology",
              "Score (PassMark single thread)", xlab="sqrt(Process node)",
              log_y=TRUE, y_limits=c(350, 5000)))

save_plot("cpu_speed_watt_nm",
  plot_points(specs, "Date", "Efficiency", "CPU: Processor efficiency",
              "Single-thread performance per watt", xlab="Year",
              log_y=TRUE, y_limits=c(4.4, 160)))
