# Plot laptop variables
#
# Before: specs.csv (output)
# After:  laptop_display.png, laptop_memory.png, laptop_power.png,
#         laptop_storage.png, laptop_thick.png, laptop_weight.png,
#         screen_density.png, screen_pixels.png, specs.csv, specs.md,
#         storage_memory_prop.png, storage_memory_text.png (report)

library(TAF)
library(knitr)
source("report_utilities.R")

mkdir("report")

# Read data
specs <- read.taf("output/specs.csv", colClasses=c(Date="Date"))

# Plot laptop variables
save_plot("laptop_display",
  plot_points(specs, "Date", "Disp", "Laptop: Display",
              "Screen size (in)", y_limits=c(13, 16.2),
              y_breaks=c(13, 14, 15, 16)))

memory_breaks <- c("0.5", "1", "2", "4", "8", "16", "32", "64")
save_plot("laptop_memory",
  plot_points(specs, "Date", "RAM", "Laptop: Memory", "Memory (GB)",
              log_y=TRUE, y_limits=c(0.4, 75),
              y_breaks=as.numeric(memory_breaks), y_labels=memory_breaks))

save_plot("laptop_power",
  plot_points(specs, "Date", "Power", "Laptop: Power adapter",
              "Power (W)", y_limits=lim(specs$Power)))

storage_breaks <- c("0.05", "0.1", "0.2", "0.5", "1", "2", "4")
save_plot("laptop_storage",
  plot_points(specs, "Date", "Storage", "Laptop: Storage drive",
              "Storage (TB)", log_y=TRUE, y_limits=c(0.03, 4),
              y_breaks=as.numeric(storage_breaks), y_labels=storage_breaks))

save_plot("laptop_thick",
  plot_points(specs, "Date", "Height", "Laptop: Thickness", "Height (cm)",
              y_limits=lim(specs$Height), y_breaks=pretty(specs$Height)))

save_plot("laptop_weight",
  plot_points(specs, "Date", "Weight", "Laptop: Weight", "Weight (kg)",
              y_limits=lim(specs$Weight)))

# Plot screen variables
save_plot("screen_density",
  plot_points(specs, "Date", "ppi", "Laptop: Pixel density",
              "Density (PPI)", log_y=TRUE, y_limits=c(80, 300)))

pixel_breaks <- c(768, 1080, 1440, 2400)
save_plot("screen_pixels",
  plot_points(specs, "Date", "h", "Laptop: Screen resolution",
              "Vertical pixels", log_y=TRUE, y_limits=c(720, 2550),
              y_breaks=pixel_breaks))

# Relationship between variables
specs$Percentage <- specs$RAM / (1000 * specs$Storage)
percentage_limits <- lim(specs$Percentage, 1.15)
save_plot("storage_memory_prop",
  plot_points(specs, "Date", "Percentage",
              "Memory tends to be around 2% of storage",
              "Memory / Storage", y_limits=percentage_limits))

storage_memory_text <- plot_points(
  specs, "Date", "Percentage",
  "Memory tends to be around 2% of storage", "Memory / Storage",
  y_limits=percentage_limits) +
  geom_hline(yintercept=0.02, linetype=3) +
  geom_text(data=data.frame(
    Date=c(specs$Date[1] + 130, specs$Date[1] + 120,
           specs$Date[2], specs$Date[2],
           specs$Date[nrow(specs)] - 80, specs$Date[nrow(specs)] - 30),
    Percentage=c(specs$Percentage[1] + 0.004, specs$Percentage[1] - 0.004,
                 specs$Percentage[2] + 0.004, specs$Percentage[2] - 0.004,
                 specs$Percentage[nrow(specs)] + 0.004,
                 specs$Percentage[nrow(specs)] - 0.004),
    label=c("512 MB\nRAM", "40 GB\nHDD", "4 GB\nRAM", "100 GB\nHDD",
            "64 GB\nRAM", "2 TB\nSSD")),
    aes(x=Date, y=Percentage, label=label), inherit.aes=FALSE,
    color="darkgray", size=3.5)
save_plot("storage_memory_text", storage_memory_text)

thick_watt <- plot_points(
  specs, "Height", "W", "Processor power and laptop thickness",
  "Thermal design power (W)", xlab="Thickness (cm)") +
  geom_abline(intercept=coef(lm(W ~ Height, specs))[1],
              slope=coef(lm(W ~ Height, specs))[2], color="#0072B2",
              linewidth=0.9) +
  geom_text(data=rbind(
    data.frame(Height=specs$Height[specs$Laptop == "Lenovo-P1-Gen8"],
               W=specs$W[specs$Laptop == "Lenovo-P1-Gen8"] + 6,
               label="new\npremium\naluminium"),
    data.frame(Height=specs$Height[specs$Laptop == "Lenovo-ThinkPad-T61"],
               W=specs$W[specs$Laptop == "Lenovo-ThinkPad-T61"] - 6,
               label="old\nworkstation\nplastic")),
    aes(x=Height, y=W, label=label), inherit.aes=FALSE,
    color="darkgray", size=3.5)
save_plot("thick_watt", thick_watt)

# Format specs
specs$Hybrid[specs$Hybrid == "-"] <- ""
specs$Cores <- paste0(specs$Cores, specs$Hybrid)
cols <- c("Date", "Laptop", "Model", "Cores", "Turbo", "RAM", "Storage", "W")
specs <- specs[cols]
names(specs)[names(specs) == "Date"] <- "Year"
names(specs)[names(specs) == "Model"] <- "Processor"
names(specs)[names(specs) == "RAM"] <- "Memory"
specs$Year <- as.integer(format(specs$Year, "%Y"))
specs$Turbo <- format(round(specs$Turbo / 1000, 1))
specs$Memory <- formatC(specs$Memory)
specs$Storage <- formatC(specs$Storage)

# Write to Markdown format
specs.md <- kable(specs, "pipe", align="lllrrrrr")
writeLines(specs.md, "report/specs.md")

# Write tables
write.taf(specs, dir="report")
