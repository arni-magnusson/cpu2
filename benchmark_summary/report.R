# Produce plots and tables for report
#
# Before: catage.csv, passmark.csv, regression.csv (output)
# After:  benchmark.png, catage.csv, passmark.csv, regression.csv,
#         regression.png, speed.png (report)

library(TAF)
library(ggplot2)
source("utilities.R")

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

# Match the report style used in the other benchmark workflows
plot_colors <- c(Local="#0072B2", Online="#D55E00",
                 Actual="#0072B2",
                 "Expectation, based on\nlocal synthetic benchmark"="#D55E00")
processor_labels <- c(
  "i7-3740QM"="Dell Precision M4700\nIntel i7-3740QM",
  "i7-10875H"="Lenovo P15 Gen 1\nIntel i7-10875H",
  "i7-1165G7"="Dell Precision 3560\nIntel i7-1165G7",
  "u9-285H"="Lenovo P1 Gen 8\nIntel u9-285H")

# Plot benchmark results
benchmark <- rbind(data.frame(processor=passmark$processor,
                              source="Local", score=passmark$local),
                   data.frame(processor=passmark$processor,
                              source="Online", score=passmark$online))
benchmark$source <- factor(benchmark$source, levels=c("Local", "Online"))
taf.png("benchmark")
print(ggplot(benchmark, aes(x=score, y=processor, fill=source)) +
  geom_col(position=position_dodge(width=0.75, reverse=TRUE), width=0.65) +
  scale_y_discrete(labels=processor_labels) +
  scale_fill_manual(values=plot_colors[c("Local", "Online")],
                    breaks=c("Local", "Online"),
                    labels=c("Local laptop", "Online average"), name=NULL) +
  scale_x_continuous(expand=expansion(mult=c(0, 0.12))) +
  labs(title="Synthetic benchmark results",
       x="Score (PassMark single thread)", y=NULL) +
  plot_theme() +
  theme(legend.position="right"))
dev.off()

# Plot regression results
xlim <- c(0.9, 1.1) * range(regression$passmark)
ylim <- c(0.95, 1.05) * range(regression$actual)
regression.plot <- ggplot(regression, aes(x=passmark, y=actual)) +
  geom_abline(intercept=0, slope=regression$slope[1],
              color=plot_colors["Expectation, based on\nlocal synthetic benchmark"],
              linetype="dashed", linewidth=1) +
  geom_point(color=plot_colors["Actual"], size=2.2) +
  geom_text(aes(label=processor), vjust=-0.7, size=3) +
  coord_cartesian(xlim=xlim, ylim=ylim) +
  labs(title="Actual speed vs. expectation based on synthetic benchmark",
       x="Synthetic benchmark score",
       y="Actual speed (model iterations / sec)") +
  plot_theme()
taf.png("regression")
print(regression.plot)
dev.off()

# Plot speed results
speed <- rbind(data.frame(processor=catage$processor,
                          estimate="Actual", speed=catage$speed),
               data.frame(processor=catage$processor,
                          estimate="Expected",
                          speed=catage$expected))
speed$estimate <- factor(speed$estimate,
                         levels=c("Actual", "Expected"))
taf.png("speed")
print(ggplot(speed, aes(x=speed, y=processor, fill=estimate)) +
  geom_col(position=position_dodge(width=0.75, reverse=TRUE), width=0.65) +
  scale_y_discrete(labels=processor_labels) +
  scale_fill_manual(values=c(Actual=unname(plot_colors["Actual"]),
                             Expected=unname(plot_colors["Expectation, based on\nlocal synthetic benchmark"])),
                    name=NULL) +
  scale_x_continuous(expand=expansion(mult=c(0, 0.12))) +
  labs(title="Actual speed vs. expectation based on synthetic benchmark",
       x="Speed (model iterations / sec)", y=NULL) +
  plot_theme() +
  theme(legend.position="right"))
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
