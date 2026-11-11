# Produce plots and tables for report

# Before: passmark.csv (output)
# After:  cpu_benchmark.png, cpu_multicore.png, effective_cores.png,
#         memory_benchmark.png, memory_detail.png (report)

library(TAF)
library(ggplot2)

mkdir("report")

# Read data
info <- read.taf("data/info.csv")
memory.details <- read.taf("data/passmark.csv")
passmark <- read.taf("output/passmark.csv")

# Label machines
machine_labels <- setNames(paste(info$name, info$processor, sep="\n"),
                           info$machine)
plot_theme <- theme_minimal(base_size=12) +
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor=element_blank(),
        plot.title=element_text(face="bold", hjust=0.5))

# Single thread
single <- passmark[order(passmark$single),]
single$machine <- reorder(single$machine, single$single)
taf.png("cpu_benchmark")
print(ggplot(single, aes(x=single, y=machine)) +
  geom_col(fill="#0072B2", width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  labs(title="Single-thread benchmark",
       x="Score (PassMark single thread)", y=NULL) +
  plot_theme)
dev.off()

# Multithread
multi <- passmark[order(passmark$multi),]
multi$machine <- reorder(multi$machine, multi$multi)
taf.png("cpu_multicore")
print(ggplot(multi, aes(x=multi, y=machine)) +
  geom_col(fill="#0072B2", width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  labs(title="Multithread benchmark",
       x="Score (PassMark multithread)", y=NULL) +
  plot_theme)
dev.off()

# Effective cores
effective <- passmark[order(passmark$effcores),]
effective$machine <- factor(effective$machine, levels=effective$machine)
effective_long <- rbind(
  data.frame(machine=effective$machine, type="Physical", score=effective$physcores),
  data.frame(machine=effective$machine, type="Effective index", score=effective$effcores))
effective_long$type <- factor(effective_long$type,
                              levels=c("Physical", "Effective index"))
taf.png("effective_cores")
print(ggplot(effective_long, aes(x=score, y=machine, fill=type)) +
  geom_col(position=position_dodge(width=0.75, reverse=TRUE), width=0.65) +
  scale_y_discrete(labels=machine_labels) +
  scale_fill_manual(values=c(Physical="#0072B2", `Effective index`="#D55E00"),
                    breaks=c("Physical", "Effective index"), name=NULL) +
  scale_x_continuous(expand=expansion(mult=c(0, 0.22))) +
  labs(title="Effective core index = multithread score / single-thread score",
       x="Cores / index", y=NULL) +
  plot_theme +
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
labels <- setNames(paste0(machine_labels[memory$machine], "\n",
                          memory$module, " - ", memory$year), memory$machine)
memory$machine <- factor(memory$machine, levels=memory$machine)

taf.png("memory_benchmark")
print(ggplot(memory, aes(x=memory, y=machine)) +
  geom_col(fill="#0072B2", width=0.65) +
  scale_y_discrete(labels=labels) +
  labs(title="Memory benchmark", x="Score", y=NULL) +
  plot_theme)
dev.off()

memory_long <- reshape(memory,
                       varying=c("read", "write", "latency"),
                       v.names="score", timevar="metric",
                       times=c("Read", "Write", "Latency"),
                       direction="long")
memory_long$metric <- factor(memory_long$metric,
                             levels=c("Read", "Write", "Latency"))
taf.png("memory_details", 1600, 3600)
print(ggplot(memory_long, aes(x=score, y=machine)) +
  geom_col(fill="#0072B2", width=0.65) +
  scale_y_discrete(labels=labels) +
  facet_wrap(~metric, ncol=1, scales="free_x") +
  labs(title="Memory details", x="Score", y=NULL) +
  plot_theme +
  theme(strip.text=element_text(face="bold"),
        strip.background=element_blank()))
dev.off()
