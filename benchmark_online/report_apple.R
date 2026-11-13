# Plot comparison plots for Apple, Intel, and AMD

# Before: apple.csv, companies.csv (data)
#         companies_fit.csv, companies_lag.csv, i7_high.csv,
#         r7_high.csv (output)
# After:  companies_data.png, companies_fit.png, companies_lag.png,
#         companies_macbook.png (report)

library(TAF)
library(ggplot2)
source("utilities.R")

mkdir("report")

# Read tables
apple <- read.taf("data/apple.csv", colClasses=c(Date="Date"))
companies <- read.taf("data/companies.csv", colClasses=c(Date="Date"))
companies.fit <- read.taf("output/companies_fit.csv", colClasses=c(Date="Date"))
companies.lag <- read.taf("output/companies_lag.csv")
i7.high <- read.taf("output/i7_high.csv", colClasses=c(Date="Date"))
r7.high <- read.taf("output/r7_high.csv", colClasses=c(Date="Date"))

# Prepare for plotting
score <- "Score (PassMark single thread)"

# Companies: Apple vs Intel vs AMD
taf.png("companies_data", width=1200)
print(ggplot(companies, aes(x=Date, y=Speed, color=Company)) +
  geom_point(size=2.2, alpha=0.85) +
  scale_y_log10() +
  scale_color_manual(values=company_colors, breaks=c("Apple", "Intel", "AMD"),
                     name=NULL) +
  labs(title="Single-thread CPU performance",
       x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

# Companies with fitted regression lines
taf.png("companies_fit", width=1200)
print(ggplot(companies, aes(x=Date, y=Speed, color=Company)) +
  geom_point(size=2.2, alpha=0.85) +
  geom_line(data=companies.fit,
            aes(group=Company), linewidth=1.1, inherit.aes=TRUE) +
  scale_y_log10() +
  scale_color_manual(values=company_colors, breaks=c("Apple", "Intel", "AMD"),
                     name=NULL) +
  guides(color=guide_legend(override.aes=list(linetype=0, linewidth=0, shape=19, size=2.2))) +
  labs(title="Single-thread performance with fitted trends",
       x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()

# Lag between companies
taf.png("companies_lag", width=1200, height=1200)
companies.lag$Company <- factor(companies.lag$Company,
                                levels=c("Apple", "Intel", "AMD"))
print(ggplot(companies.lag, aes(x=Company, y=Lag, fill=Company)) +
  geom_col(width=0.65) +
  scale_fill_manual(values=company_colors, guide="none") +
  labs(title="Lag until each company reaches the leader",
       x=NULL, y="Lag (years)") +
  plot_theme() +
  theme(panel.grid.major.x=element_blank()))
dev.off()

# MacBook Air vs Pro
taf.png("companies_macbook", width=1200)
apple$Type <- ifelse(grepl("Pro", apple$Model), "Pro", "Air")
apple$Type <- factor(apple$Type, levels=c("Pro", "Air"))
print(ggplot(apple, aes(x=Date, y=Speed, shape=Type)) +
  geom_point(color=company_colors["Apple"], size=2.4, stroke=1) +
  scale_y_log10() +
  scale_shape_manual(values=c(Pro=16, Air=1), name=NULL) +
  labs(title="Apple MacBook performance", x=NULL, y=score) +
  plot_theme() + legend_inside)
dev.off()
