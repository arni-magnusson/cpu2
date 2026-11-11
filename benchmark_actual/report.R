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
machine_labels <- c(
  m4700 = "Dell Precision M4700\nIntel i7-3740QM",
  p15gen1 = "Lenovo P15 Gen 1\nIntel i7-10875H",
  p3560 = "Dell Precision 3560\nIntel i7-1165G7",
  p1gen8 = "Lenovo P1 Gen 8\nIntel u9-285H"
)
job_labels <- c(short = "Short", sustained = "Sustained")
job_colors <- c(short = "#0072B2", sustained = "#D55E00")

# Bar plot
taf.png("speed")
print(ggplot(catage, aes(x=speed, y=machine, fill=job)) +
  geom_col(position=position_dodge(width=0.75, reverse=TRUE), width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  scale_fill_manual(values=job_colors, breaks=names(job_labels),
                    labels=job_labels, name=NULL) +
  scale_x_continuous(expand=expansion(mult=c(0, 0.12))) +
  labs(title="Speed measurements",
       x="Speed (model iterations / sec)", y=NULL) +
  theme_minimal(base_size=12) +
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor=element_blank(),
        legend.position=c(0.98, 0.02),
        legend.justification=c(1, 0),
        legend.direction="vertical",
        legend.background=element_rect(fill="white", color=NA),
        plot.title.position="plot",
        plot.title=element_text(face="bold", hjust=0.5)))
dev.off()

# Prepare summary table
speed <- aggregate(speed~machine, catage, mean)
speed$relative <- speed$speed / min(speed$speed)
speed <- rnd(speed, 2:3, 1:2)

# Write table
write.taf(speed, dir="report")
