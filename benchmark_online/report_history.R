# Plot long-term historical trends

# Before: history.csv (data)
#         history_analysis.csv, history_fit.csv, history.rate.csv (output)
# After:  history_companies_nm.png, history_companies_speed.png,
#         history_data.png, history_fit.png, history_rate.png,
#         history_time.png (report)

library(TAF)
library(ggplot2)
source("utilities.R")

mkdir("report")

# Read data
history <- read.taf("data/history.csv", colClasses=c(Date="Date"))
history.analysis <- read.taf("output/history_analysis.csv",
                             colClasses=c(Date="Date"))
history.fit <- read.taf("output/history_fit.csv", colClasses=c(Date="Date"))
history.rate <- read.taf("output/history_rate.csv")

# Prepare for plotting
score <- "Score (PassMark single thread)"
intel <- "History (Intel)"
lwd <- 2

# Intel and AMD process
taf.png("history_companies_nm", width=1200)
values <- c(3, 4, 5.8, 7.2, 10, 14, 22, 28, 35, 45, 65, 90, 130, 180)
amd_nm <- aggregate(Date~nm, history, min, subset=Company=="AMD")
intel_nm <- aggregate(Date~nm, history, min, subset=Company=="Intel")
print(ggplot(history, aes(x=Date, y=nm, color=Company)) +
  geom_point(size=2.1, alpha=0.85) +
  geom_line(data=amd_nm, aes(x=Date, y=nm, group=1, color="AMD"),
            inherit.aes=FALSE, linewidth=1) +
  geom_line(data=intel_nm, aes(x=Date, y=nm, group=1, color="Intel"),
            inherit.aes=FALSE, linewidth=1) +
  scale_y_log10(breaks=values, labels=round(values)) +
  scale_color_manual(values=company_colors, breaks=c("Intel", "AMD"), name=NULL) +
  coord_cartesian(ylim=c(2.6, 200)) +
  labs(title="Process size over time", x=NULL, y="Process (nm)") +
  plot_theme() +
  theme(legend.position=c(0.98, 0.98),
        legend.justification=c(1, 1),
        legend.background=element_rect(fill="white", color=NA)))
dev.off()

# Intel and AMD speed
taf.png("history_companies_speed", width=1200)
print(ggplot(history, aes(x=Date, y=Speed, color=Company)) +
  geom_point(size=2.1, alpha=0.85) +
  scale_y_log10() +
  scale_color_manual(values=company_colors, breaks=c("Intel", "AMD"), name=NULL) +
  labs(title="Historical Intel and AMD performance", x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

# Intel observations
taf.png("history_data", width=1200)
history.analysis$Period <- factor(history.analysis$Period, levels=c("Early", "Late"))
print(ggplot(history.analysis, aes(x=Date, y=Speed, shape=Period)) +
  geom_point(color=company_colors["Intel"], size=2.2, stroke=1) +
  scale_y_log10() +
  scale_shape_manual(values=c(Early=1, Late=16), name=NULL) +
  labs(title=intel, x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

# Intel trends
taf.png("history_fit", width=1200)
history.fit$Period <- factor(history.fit$Period, levels=c("Early", "Late"))
print(ggplot(history.analysis, aes(x=Date, y=Speed, shape=Period)) +
  geom_point(color=company_colors["Intel"], size=2.2, stroke=1) +
  geom_line(data=history.fit, aes(group=Period), inherit.aes=TRUE,
            color=company_colors["Intel"], linewidth=1) +
  scale_y_log10() +
  scale_shape_manual(values=c(Early=1, Late=16), name=NULL) +
  labs(title=intel, x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

# Intel annual improvement
taf.png("history_rate", width=1200)
history.rate$Period <- factor(history.rate$Period, levels=c("Early", "Late"))
history.rate$AnnualPercent <- 100*history.rate$Annual
print(ggplot(history.rate, aes(x=Period, y=AnnualPercent, fill=Period)) +
  geom_col(width=0.65) +
  scale_fill_manual(values=c(Early="#56B4E9", Late="#0072B2"), guide="none") +
  labs(title=intel, x=NULL, y="Annual improvement (%)") +
  plot_theme() + theme(panel.grid.major.x=element_blank()))
dev.off()

# Intel doubling time
taf.png("history_time", width=1200)
print(ggplot(history.rate, aes(x=Period, y=Doubling, fill=Period)) +
  geom_col(width=0.65) +
  scale_fill_manual(values=c(Early="#56B4E9", Late="#0072B2"), guide="none") +
  labs(title=intel, x=NULL, y="Doubling time (years)") +
  plot_theme() + theme(panel.grid.major.x=element_blank()))
dev.off()
