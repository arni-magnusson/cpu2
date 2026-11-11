# Plot long-term historical trends

# Before: history.csv (data)
#         history_analysis.csv, history_fit.csv, history.rate.csv (output)
# After:  history_companies_nm.png, history_companies_speed.png,
#         history_data.png, history_fit.png, history_rate.png,
#         history_time.png (report)

library(TAF)

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
plot(nm~Date, history, log="y", type="n", ylim=c(2.6,200), yaxt="n",
     ylab="Process nm")
values <- c(3, 4, 5.8, 7.2, 10, 14, 22, 28, 35, 45, 65, 90, 130, 180)
axis(2, values, round(values), las=1)
points(nm~Date, history, subset=Company=="AMD", pch=19, col=2)
points(nm~Date, history, subset=Company=="Intel", pch=19, col=4)
lines(aggregate(Date~nm, history, min, subset=Company=="AMD")[2:1],
      lwd=2, col=2)
lines(aggregate(Date~nm, history, min, subset=Company=="Intel")[2:1],
      lwd=2, col=4)
legend("topright", legend=c("Intel", "AMD"), pch=19, col=c(4, 2), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

# Intel and AMD speed
taf.png("history_companies_speed", width=1200)
plot(Speed~Date, history, type="n", log="y", ylab=score)
points(Speed~Date, history, subset=Company=="AMD", pch=19, col=2)
points(Speed~Date, history, subset=Company=="Intel", pch=19, col=4)
legend("topleft", legend=c("Intel", "AMD"), pch=19, col=c(4, 2), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

# Intel observations
taf.png("history_data", width=1200)
plot(Speed~Date, history, type="n", log="y", main=intel, ylab=score)
points(Speed~Date, history.analysis, subset=Period=="Early", col=4)
points(Speed~Date, history.analysis, subset=Period=="Late", pch=19, col=4)
legend("topleft", legend=c("Early", "Late"), pch=c(1, 19), col=4, bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

# Intel trends
taf.png("history_fit", width=1200)
plot(Speed~Date, history, type="n", log="y", main=intel, ylab=score)
points(Speed~Date, history.analysis, subset=Period=="Early", col=4)
points(Speed~Date, history.analysis, subset=Period=="Late", pch=19, col=4)
lines(Speed~Date, history.fit, subset=Period=="Early", col=4)
lines(Speed~Date, history.fit, subset=Period=="Late", col=4)
legend("topleft", legend=c("Early", "Late"), pch=c(1, 19), col=4, bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

# Intel annual improvement
taf.png("history_rate", width=1200)
barplot(100*Annual~Period, history.rate, col=5:4, main=intel,
        ylab="Annual improvement (%)")
dev.off()

# Intel doubling time
taf.png("history_time", width=1200)
barplot(Doubling~Period, history.rate, col=5:4, main=intel,
        ylab="Doubling time (yr)")
dev.off()
