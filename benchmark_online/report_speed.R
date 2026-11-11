# Plot speed (single thread) over time

# Before: i7_high.csv, i7_low.csv, i7_medium.csv, r7_high.csv,
#         r7_low.csv (output)
# After:  speed_all.png, speed_high.png, speed_low.png,
#         speed_medium.png (report)

library(TAF)

mkdir("report")

# Read tables
i7.high <- read.taf("output/i7_high.csv", colClasses=c(Date="Date"))
i7.medium <- read.taf("output/i7_medium.csv", colClasses=c(Date="Date"))
i7.low <- read.taf("output/i7_low.csv", colClasses=c(Date="Date"))
r7.high <- read.taf("output/r7_high.csv", colClasses=c(Date="Date"))
r7.low <- read.taf("output/r7_low.csv", colClasses=c(Date="Date"))

# Prepare for plotting
score <- "Score (PassMark single thread)"

# Plot speed over time
taf.png("speed_all", width=1200)
plot(Speed~Date, i7.high[-1,], log="y", type="o", col=4, ylab=score,
     xlim=as.Date(c("2010-01-01", "2027-01-01")), ylim=c(700, 4400))
title("Intel and AMD (high/medium/low power)")
lines(Speed~Date, r7.high, type="o", col=2)
lines(Speed~Date, i7.medium, type="o", col=4)
lines(Speed~Date, i7.low[-1,], type="o", col=4)
lines(Speed~Date, r7.low, type="o", col=2)
legend("topleft", legend=c("Intel", "AMD"), lty=1, pch=1, col=c(4,2), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

taf.png("speed_high", width=1200)
plot(Speed~Date, i7.high[-1,], log="y", type="o", col=4, ylab=score,
     xlim=as.Date(c("2010-01-01", "2027-01-01")), ylim=c(700, 4400))
title("Intel and AMD (high power)")
lines(Speed~Date, r7.high, type="o", col=2)
legend("topleft", legend=c("Intel", "AMD"), lty=1, pch=1, col=c(4,2), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

taf.png("speed_low", width=1200)
plot(Speed~Date, i7.low[-1,], log="y", type="o", col=4, ylab=score,
     xlim=as.Date(c("2010-01-01", "2027-01-01")), ylim=c(700, 4400))
title("Intel and AMD (low power)")
lines(Speed~Date, r7.low, type="o", col=2)
legend("topleft", legend=c("Intel", "AMD"), lty=1, pch=1, col=c(4,2), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

taf.png("speed_medium", width=1200)
plot(Speed~Date, i7.medium[-1,], log="y", type="o", col=4, ylab=score,
     xlim=as.Date(c("2010-01-01", "2027-01-01")), ylim=c(700, 4400))
title("Intel (medium power)")
legend("topleft", legend=c("Intel"), lty=1, pch=1, col=c(4), bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()
