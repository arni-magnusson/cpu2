# Produce plots and tables for report

# Before: catage.csv (output)
# After:  speed.csv, speed.png (report)

library(TAF)

mkdir("report")

# Read data
catage <- read.taf("output/catage.csv")

# Reorder machines
catage$machine <- reorder(catage$machine, catage$speed, median)

# Prepare plot
labels <- c("Short", "Sustained")

# Barplot
taf.png("speed")
barplot(xtabs(speed~job+machine, catage), beside=TRUE, legend=TRUE,
        args.legend=list(x="topleft", legend=labels, bty="n", inset=0.02),
        main="Speed measurements", ylab="Speed (model iterations / sec)")
dev.off()

# Prepare summary table
speed <- aggregate(speed~machine, catage, mean)
speed$relative <- speed$speed / min(speed$speed)
speed <- rnd(speed, 2:3, 1:2)

# Write table
write.taf(speed, dir="report")
