# Plot comparison plots for Apple, Intel, and AMD

# Before: apple.csv, companies.csv (data)
#         companies_fit.csv, companies_lag.csv, i7_high.csv, r7_high (output)
# After:  companies_data.png, companies_fit.png, companies_lag.png,
#         companies_macbook.png (report)

library(TAF)

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
lwd <- 2

# Companies: Apple vs Intel vs AMD
taf.png("companies_data", width=1200)
plot(Speed~Date, companies, type="n", log="y", ylab=score)
points(Speed~Date, companies, subset=Company=="Apple", pch=19, col=1)
points(Speed~Date, companies, subset=Company=="Intel", pch=19, col=4)
points(Speed~Date, companies, subset=Company=="AMD", pch=19, col=2)
legend("topleft", legend=c("Apple", "Intel", "AMD"), pch=19, col=c(1,4,2),
       bty="n", inset=0.02, y.intersp=1.25)
dev.off()

# Companies with fitted regression lines
taf.png("companies_fit", width=1200)
plot(Speed~Date, companies, type="n", log="y", ylab=score)
points(Speed~Date, companies, subset=Company=="Apple", pch=19, col=1)
points(Speed~Date, companies, subset=Company=="Intel", pch=19, col=4)
points(Speed~Date, companies, subset=Company=="AMD", pch=19, col=2)
lines(Speed~Date, companies.fit, subset=Company=="Apple", lwd=lwd, col=1)
lines(Speed~Date, companies.fit, subset=Company=="Intel", lwd=lwd, col=4)
lines(Speed~Date, companies.fit, subset=Company=="AMD", lwd=lwd, col=2)
legend("topleft", legend=c("Apple", "Intel", "AMD"), pch=19, col=c(1,4,2),
       bty="n", inset=0.02, y.intersp=1.25)
dev.off()

# Lag between companies
taf.png("companies_lag")
companies.lag$Company <- reorder(companies.lag$Company, companies.lag$Lag)
barplot(Lag~Company, companies.lag, xlab="", ylab="Lag (yrs)", col=0, border=NA)
grid(NA, NULL, lty=1)
barplot(Lag~Company, companies.lag, add=TRUE, col=c(1,4,2))
title(main="Lag until company reaches the CPU performance of the best company")
dev.off()

# MacBook Air vs Pro
taf.png("companies_macbook", width=1200)
plot(Speed~Date, apple, log="y", pch=c(1,19), ylab=score, main="Apple MacBook")
legend("topleft", legend=c("Pro", "Air"), pch=c(19,1), bty="n", inset=0.02,
       y.intersp=1.25)
dev.off()
