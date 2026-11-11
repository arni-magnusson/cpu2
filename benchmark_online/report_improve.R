# Plot relative improvement for each processor generation

# Before: i7_high.csv, i7_low.csv, i7_medium.csv, r7_high.csv,
#         r7_low.csv (output)
# After:  improve_amd_high.png, improve_amd_low.png, improve_intel_high.png,
#         improve_intel_low.png, improve_intel_medium.png (report)

library(TAF)
library(ggplot2)
source("utilities.R")

mkdir("report")

# Read tables
i7.high <- read.taf("output/i7_high.csv", colClasses=c(Date="Date"))
i7.medium <- read.taf("output/i7_medium.csv", colClasses=c(Date="Date"))
i7.low <- read.taf("output/i7_low.csv", colClasses=c(Date="Date"))
r7.high <- read.taf("output/r7_high.csv", colClasses=c(Date="Date"))
r7.low <- read.taf("output/r7_low.csv", colClasses=c(Date="Date"))

# Plot improvement
taf.png("improve_amd_high")
print(implot(r7.high[-1,], title="AMD (high power)",
             fill=company_colors["AMD"]))
dev.off()

taf.png("improve_amd_low")
print(implot(r7.low, title="AMD (low power)", fill=company_colors["AMD"]))
dev.off()

taf.png("improve_intel_high")
print(implot(i7.high[-1,], title="Intel (high power)",
             fill=company_colors["Intel"]))
dev.off()

taf.png("improve_intel_low")
print(implot(i7.low[-1,], title="Intel (low power)",
             fill=company_colors["Intel"]))
dev.off()

taf.png("improve_intel_medium")
print(implot(i7.medium, title="Intel (medium power)",
             fill=company_colors["Intel"]))
dev.off()
