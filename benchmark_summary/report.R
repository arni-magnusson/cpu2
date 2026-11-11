# Produce plots and tables for report
#
# Before: catage.csv, passmark.csv, regression.csv (output)
# After:  benchmark.png, catage.csv, passmark.csv, regression.csv,
#         regression.png, speed.png (report)

library(TAF)
library(ggplot2)

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
benchmark <- rbind(data.frame(processor=passmark$processor,
                              source="Local", score=passmark$local),
                   data.frame(processor=passmark$processor,
                              source="Online", score=passmark$online))
benchmark$source <- factor(benchmark$source, levels=c("Local", "Online"))
benchmark.plot <- ggplot(benchmark, aes(x=processor, y=score, fill=source)) +
  geom_col(position=position_dodge(width=0.8), width=0.7, colour="black") +
  scale_fill_manual(values=c(Local="gray", Online="white")) +
  labs(title="Synthetic benchmark results", x=NULL,
       y="Score (PassMark single thread)", fill=NULL) +
  theme_minimal() +
  theme(legend.position="top")
taf.png("benchmark")
print(benchmark.plot)
dev.off()

# Plot regression results
xlim <- c(0.9, 1.1) * range(regression$passmark)
ylim <- c(0.95, 1.05) * range(regression$actual)
regression.plot <- ggplot(regression, aes(x=passmark, y=actual)) +
  geom_abline(intercept=0, slope=regression$slope[1], linetype="dashed") +
  geom_point() +
  geom_text(aes(label=processor), vjust=-0.7, size=3) +
  coord_cartesian(xlim=xlim, ylim=ylim) +
  labs(title="Actual speed vs. expectation based on synthetic benchmark",
       x="Synthetic benchmark score",
       y="Actual speed (model iterations / sec)") +
  theme_minimal()
taf.png("regression")
print(regression.plot)
dev.off()

# Plot speed results
speed <- rbind(data.frame(processor=catage$processor,
                          estimate="Actual", speed=catage$speed),
               data.frame(processor=catage$processor,
                          estimate="Expectation, based on\nlocal synthetic benchmark",
                          speed=catage$expected))
speed$estimate <- factor(speed$estimate,
                         levels=c("Actual",
                                  "Expectation, based on\nlocal synthetic benchmark"))
speed.plot <- ggplot(speed, aes(x=processor, y=speed, fill=estimate)) +
  geom_col(position=position_dodge(width=0.8), width=0.7, colour="black") +
  scale_fill_manual(values=c("Actual"="gray",
                             "Expectation, based on\nlocal synthetic benchmark"="white")) +
  labs(title="Actual speed vs. expectation based on synthetic benchmark",
       x=NULL, y="Speed (model iterations / sec)", fill=NULL) +
  theme_minimal() +
  theme(legend.position="top")
taf.png("speed")
print(speed.plot)
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
