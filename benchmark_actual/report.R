# Produce plots and tables for report

# Before: catage.csv (output)
# After:  speed.csv, speed.png (report)

library(TAF)
library(ggplot2)

mkdir("report")

# Read data
catage <- read.taf("output/catage.csv")

# Reorder machines
catage$machine <- reorder(catage$machine, catage$speed, median)

# Prepare plot
labels <- c("Short", "Sustained")

# Bar plot
taf.png("speed")
print(ggplot(catage, aes(x=machine, y=speed, fill=job)) +
  geom_col(position=position_dodge()) +
  scale_fill_discrete(name=NULL, labels=labels) +
  labs(title="Speed measurements", y="Speed (model iterations / sec)", x=NULL) +
  theme(legend.position=c(0.05, 0.95),
        legend.justification=c(0, 1),
        legend.background=element_blank()))
dev.off()

# Prepare summary table
speed <- aggregate(speed~machine, catage, mean)
speed$relative <- speed$speed / min(speed$speed)
speed <- rnd(speed, 2:3, 1:2)

# Write table
write.taf(speed, dir="report")
