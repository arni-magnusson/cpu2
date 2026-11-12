# Produce plots and tables for report

# Before: passmark.csv (output)
# After:  cpu_benchmark.png, cpu_multicore.png, effective_cores.png,
#         memory_benchmark.png, memory_detail.png (report)

library(TAF)
library(ggplot2)
source("utilities.R")

mkdir("report")

# Read data
info <- read.taf("data/info.csv")
memory.details <- read.taf("data/passmark.csv")
passmark <- read.taf("output/passmark.csv")

# Label machines
machine_labels <- setNames(
  paste(info$name, paste("Intel", gsub(" ", "-", info$processor)), sep="\n"),
  info$machine)
machine_names <- setNames(info$name, info$machine)
quantity_colors <- c(single="#0072B2", multi="#D55E00",
                     physical="#009E73", effective="#C4A000")
machine_order <- c("m4700", "p15gen1", "p3560", "p1gen8")

# Single thread
single <- passmark[order(passmark$single),]
single$machine <- factor(single$machine, levels=machine_order)
taf.png("cpu_benchmark")
print(ggplot(single, aes(x=single, y=machine)) +
  geom_col(fill=quantity_colors["single"], width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  labs(title="Single-thread benchmark",
       x="Score (PassMark single thread)", y=NULL) +
  plot_theme())
dev.off()

# Multithread
multi <- passmark[order(passmark$multi),]
multi$machine <- factor(multi$machine, levels=machine_order)
taf.png("cpu_multicore")
print(ggplot(multi, aes(x=multi, y=machine)) +
  geom_col(fill=quantity_colors["multi"], width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  labs(title="Multithread benchmark",
       x="Score (PassMark multithread)", y=NULL) +
  plot_theme())
dev.off()

# Effective cores
effective <- passmark[order(passmark$effcores),]
effective$machine <- factor(effective$machine, levels=machine_order)
effective_long <- rbind(
  data.frame(machine=effective$machine, type="Physical cores", score=effective$physcores),
  data.frame(machine=effective$machine, type="Effective core index", score=effective$effcores))
effective_long$type <- factor(effective_long$type,
                              levels=c("Physical cores", "Effective core index"))
taf.png("effective_cores")
print(ggplot(effective_long, aes(x=score, y=machine, fill=type)) +
  geom_col(position=position_dodge(width=0.75, reverse=TRUE), width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  scale_fill_manual(values=c(`Physical cores`=unname(quantity_colors["physical"]),
                             `Effective core index`=unname(quantity_colors["effective"])),
                    breaks=c("Physical cores", "Effective core index"), name=NULL) +
  scale_x_continuous(expand=expansion(mult=c(0, 0.22))) +
  labs(title="Effective core index = multithread score / single-thread score",
       x="Cores / index", y=NULL) +
  plot_theme() +
  theme(legend.position=c(0.98, 0.02),
        legend.justification=c(1, 0),
        legend.direction="vertical",
        legend.background=element_rect(fill="white", color=NA)))
dev.off()

# Memory
memory <- merge(memory.details, info[c("machine", "module", "year")])
memory <- memory[order(memory$memory),]
memory <- memory[c("machine", "memory", "database", "readcache", "read",
                   "write", "available", "latency", "threaded", "module",
                   "year")]
labels <- setNames(paste0(machine_names[memory$machine], "\n",
                          memory$module, " (", memory$year, ")"),
                   memory$machine)
memory$machine <- factor(memory$machine, levels=machine_order)

taf.png("memory_benchmark")
print(ggplot(memory, aes(x=memory, y=machine)) +
  geom_col(fill="#0072B2", width=0.65) +
  scale_y_discrete(labels=labels) +
  labs(title="Memory benchmark", x="Score", y=NULL) +
  plot_theme())
dev.off()

memory_long <- reshape(memory,
                       varying=c("read", "write", "latency"),
                       v.names="score", timevar="metric",
                       times=c("Read", "Write", "Latency"),
                       direction="long")
memory_long$metric <- factor(memory_long$metric,
                             levels=c("Read", "Write", "Latency"),
                             labels=c("Read (MB/s)", "Write (MB/s)", "Latency (ns)"))
memory_long$relative <- NA_real_
for (metric in levels(memory_long$metric)) {
  rows <- memory_long$metric == metric
  scores <- memory_long$score[rows]
  memory_long$relative[rows] <- if (metric == "Latency (ns)") {
    min(scores) / scores * 100
  } else {
    scores / max(scores) * 100
  }
}
taf.png("memory_details", 1600, 1200)
print(ggplot(memory_long, aes(x=relative, y=machine, fill=metric)) +
  geom_col(position=position_dodge(width=0.8, reverse=TRUE), width=0.72) +
  geom_text(aes(label=format(score, big.mark=",", scientific=FALSE, trim=TRUE)),
            position=position_dodge(width=0.8, reverse=TRUE),
            hjust=-0.15, size=3.5) +
  scale_y_discrete(labels=labels) +
  scale_fill_manual(values=c("Read (MB/s)"="#0072B2",
                             "Write (MB/s)"="#D55E00",
                             "Latency (ns)"="#009E73"),
                    breaks=c("Read (MB/s)", "Write (MB/s)", "Latency (ns)"),
                    name=NULL) +
  scale_x_continuous(limits=c(0, 125), breaks=seq(0, 100, 20)) +
  labs(title="Memory details",
       x="Relative performance (% of best result)", y=NULL) +
  plot_theme() +
  theme(legend.position="top"))
dev.off()
