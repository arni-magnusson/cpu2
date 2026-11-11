# Plot speed (single thread) over time

# Before: i7_high.csv, i7_low.csv, i7_medium.csv, r7_high.csv,
#         r7_low.csv (output)
# After:  speed_all.png, speed_high.png, speed_low.png,
#         speed_medium.png (report)

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

# Prepare for plotting
score <- "Score (PassMark single thread)"
date_limits <- as.Date(c("2010-01-01", "2027-01-01"))
date_breaks <- seq(date_limits[1], date_limits[2], by="2 years")

plot_speed <- function(data, title) {
  ggplot(data, aes(x=Date, y=Speed, color=Company, group=Company)) +
    geom_line(linewidth=0.9) +
    geom_point(size=1.8) +
    scale_x_date(limits=date_limits, breaks=date_breaks, date_labels="%Y",
                 expand=expansion(mult=0)) +
    scale_y_log10() +
    coord_cartesian(ylim=c(700, 4400)) +
    scale_color_manual(values=company_colors, name=NULL) +
    labs(title=title, x=NULL, y=score) +
    plot_theme() + legend_inside
}

# Plot speed over time
speed_all_data <- rbind(
  transform(i7.high[-1,], Company="Intel", Power="High"),
  transform(r7.high, Company="AMD", Power="High"),
  transform(i7.medium, Company="Intel", Power="Medium"),
  transform(i7.low[-1,], Company="Intel", Power="Low"),
  transform(r7.low, Company="AMD", Power="Low"))
speed_all_data$Power <- factor(speed_all_data$Power,
                               levels=c("High", "Medium", "Low"))
taf.png("speed_all", width=1200)
print(ggplot(speed_all_data,
             aes(x=Date, y=Speed, color=Company,
                 linetype=Power, group=interaction(Company, Power))) +
  geom_line(linewidth=0.9) +
  geom_point(size=1.8) +
  scale_x_date(limits=date_limits, breaks=date_breaks, date_labels="%Y",
               expand=expansion(mult=0)) +
  scale_y_log10() +
  coord_cartesian(ylim=c(700, 4400)) +
  scale_color_manual(values=company_colors, name="Company") +
  scale_linetype_manual(values=c(High="solid", Medium="dashed", Low="dotted"),
                        name="Power class") +
  labs(title="Intel and AMD (high/medium/low power)",
       x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

taf.png("speed_high", width=1200)
high_data <- rbind(transform(i7.high[-1,], Company="Intel"),
                   transform(r7.high, Company="AMD"))
print(plot_speed(high_data, "Intel and AMD (high power)"))
dev.off()

taf.png("speed_low", width=1200)
low_data <- rbind(transform(i7.low[-1,], Company="Intel"),
                  transform(r7.low, Company="AMD"))
print(plot_speed(low_data, "Intel and AMD (low power)"))
dev.off()

taf.png("speed_medium", width=1200)
medium_data <- transform(i7.medium[-1,], Company="Intel")
print(plot_speed(medium_data, "Intel (medium power)"))
dev.off()
