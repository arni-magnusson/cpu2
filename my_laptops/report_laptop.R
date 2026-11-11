# Plot laptop variables

# Before: specs.csv (output)
# After:  laptop_display.png, laptop_memory.png, laptop_power.png,
#         laptop_storage.png, laptop_thick.png, laptop_weight.png,
#         screen_density.png, screen_pixels.png, specs.csv, specs.md,
#         storage_memory_prop.png, storage_memory_text.png (report)

library(TAF)
library(knitr)

mkdir("report")

# Read data
specs <- read.taf("output/specs.csv", colClasses=c(Date="Date"))

# Plot laptop variables
taf.png("laptop_display")
plot(Disp~Date, specs, pch=21, bg=bg, yaxt="n", ylim=c(13,16.2),
     main="Laptop: Display", ylab="Screen size (in)")
axis(2, c(13, 14, 15, 16))
dev.off()

taf.png("laptop_memory")
plot(RAM~Date, specs, log="y", pch=21, bg=bg, yaxt="n", ylim=c(0.4, 75),
     main="Laptop: Memory", ylab="Memory (GB)")
values <- c("0.5", "1", "2", "4", "8", "16", "32", "64")
axis(2, as.numeric(values), values)
dev.off()

taf.png("laptop_power")
plot(Power~Date, specs, ylim=lim(Power), pch=21, bg=bg,
     main="Laptop: Power adapter", ylab="Power (W)")
dev.off()

taf.png("laptop_storage")
plot(Storage~Date, specs, log="y", pch=21, bg=bg, yaxt="n", ylim=c(0.03, 4),
     main="Laptop: Storage drive", ylab="Storage (TB)")
values <- c("0.05", "0.1", "0.2", "0.5", "1", "2", "4")
axis(2, as.numeric(values), values)
dev.off()

taf.png("laptop_thick")
plot(Height~Date, specs, ylim=lim(Height), pch=21, bg=bg, yaxs="i",
     main="Laptop: Thickness", ylab="Height (cm)")
dev.off()

taf.png("laptop_weight")
plot(Weight~Date, specs, ylim=lim(Weight), pch=21, bg=bg,
     main="Laptop: Weight", ylab="Weight (kg)")
dev.off()

# Plot screen variables
taf.png("screen_density")
plot(ppi~Date, specs, log="y", pch=21, bg=bg, ylim=c(80, 300),
     main="Laptop: Pixel density", ylab="Density (PPI)")
dev.off()

taf.png("screen_pixels")
plot(h~Date, specs, log="y", pch=21, bg=bg, yaxt="n", ylim=c(720, 2550),
     main="Laptop: Screen resolution", ylab="Vertical pixels")
axis(2, c(768, 1080, 1440, 2400))
dev.off()

# Relationship between variables
taf.png("storage_memory_prop")
specs$Percentage <- specs$RAM / (1000*specs$Storage)
plot(Percentage~Date, specs, pch=21, bg=bg, ylim=lim(Percentage, 1.15),
     main="Memory tends to be around 2% of storage", ylab="Memory / Storage")
dev.off()

taf.png("storage_memory_text")
specs$Percentage <- specs$RAM / (1000*specs$Storage)
plot(Percentage~Date, specs, pch=21, bg=bg, ylim=lim(Percentage, 1.15),
     main="Memory tends to be around 2% of storage", ylab="Memory / Storage")
abline(h=0.02, lty=3)
n <- nrow(specs)
text(specs$Date[1]+130, specs$Percentage[1]+0.004, "512 MB\nRAM", cex=0.9,
     col="darkgray")
text(specs$Date[1]+120, specs$Percentage[1]-0.004, "40 GB\nHDD", cex=0.9,
     col="darkgray")
text(specs$Date[2], specs$Percentage[2]+0.004, "4 GB\nRAM", cex=0.9,
     col="darkgray")
text(specs$Date[2], specs$Percentage[2]-0.004, "100 GB\nHDD", cex=0.9,
     col="darkgray")
text(specs$Date[n]-80, specs$Percentage[n]+0.004, "64 GB\nRAM", cex=0.9,
     col="darkgray")
text(specs$Date[n]-30, specs$Percentage[n]-0.004, "2 TB\nSSD", cex=0.9,
     col="darkgray")
dev.off()

taf.png("thick_watt")
plot(W~Height, specs, pch=21, bg=bg,
     main="Processor power and laptop thickness", xlab="Thickness (cm)",
     ylab="Thermal design power (W)")
abline(lm(W~Height, specs))
p1gen8 <- specs[specs$Laptop == "Lenovo-P1-Gen8",]
t61 <- specs[specs$Laptop == "Lenovo-ThinkPad-T61",]
text(p1gen8$Height, p1gen8$W+6, "new\npremium\naluminium", cex=0.9,
     col="darkgray")
text(t61$Height, t61$W-6, "old\nworkstation\nplastic", cex=0.9, col="darkgray")
dev.off()

# Format specs
specs$Hybrid[specs$Hybrid == "-"] <- ""
specs$Cores <- paste0(specs$Cores, specs$Hybrid)
cols <- c("Date", "Laptop", "Model", "Cores", "Turbo", "RAM", "Storage","W")
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
