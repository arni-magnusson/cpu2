# Produce plots and tables for report
#
# Before: catage.csv, passmark.csv, regression.csv (output)
# After:  benchmark.png, catage.csv, passmark.csv, regression.csv,
#         regression.png, speed.png (report)

library(TAF)

mkdir("report")

# Read data
catage <- read.taf("output/catage.csv")
passmark <- read.taf("output/passmark.csv")
regression <- read.taf("output/regression.csv")

# Establish processor order
ord <- catage$processor[order(catage$speed)]
catage <- catage[match(ord, catage$processor),]
passmark <- passmark[match(ord, passmark$processor),]
regression <- regression[match(ord, regression$processor),]
catage$processor <- ordered(catage$processor, catage$processor)
passmark$processor <- ordered(passmark$processor, passmark$processor)
regression$processor <- ordered(regression$processor, regression$processor)

# Plot benchmark results
taf.png("benchmark")
z <- barplot(local~processor, passmark, main="Synthetic benchmark results",
             xlab="", ylab="Score (PassMark single thread)")
x1 <- z - 0.2
x2 <- z + 0.2
segments(x1, passmark$online, x2, passmark$online, lwd=3)
legend("topleft", c("Local", "Online"), fill=c("gray", "white"),
       border=c("black", "white"), lty=c(0, 1), pch=c(NA, NA), lwd=2, bty="n",
       inset=0.02, y.intersp=1.25)
dev.off()

# Plot regression results
xlim <- c(0.9, 1.1) * range(regression$passmark)
ylim <- c(0.95, 1.05) * range(regression$actual)
taf.png("regression")
plot(actual~passmark, regression, pch=19, xlim=xlim, ylim=ylim,
     main="Actual speed vs. expectation based on synthetic benchmark",
     xlab="Synthetic benchmark score",
     ylab="Actual speed (model iterations / sec)")
abline(a=0, b=regression$slope[1], lty=2)
text(actual~passmark, regression, processor, pos=3, cex=0.8)
dev.off()

# Plot speed results
taf.png("speed")
z <- barplot(speed~processor, catage,
             main="Actual speed vs. expectation based on synthetic benchmark",
             xlab="", ylab="Speed (model iterations / sec)")
x1 <- z - 0.2
x2 <- z + 0.2
segments(x1, catage$expected, x2, catage$expected, lwd=3)
legend("topleft", c("Actual",
                    "Expectation, based on\nlocal synthetic benchmark"),
       fill=c("gray", "white"), border=c("black", "white"), lty=c(0, 1),
       pch=c(NA, NA), lwd=2, bty="n", inset=0.02, y.intersp=1.25)
dev.off()

# Round tables
catage <- rnd(catage, 2:4, c(1,1,2))
catage$difference <- paste0(100 * catage$difference, "%")
passmark <- rnd(passmark, "difference", 2)
passmark$difference <- paste0(100 * passmark$difference, "%")
regression <- rnd(regression, c(2,4,5), c(1, 5, 1))

# Write tables
write.taf(catage, dir="report")
write.taf(passmark, dir="report")
write.taf(regression, dir="report")
