# Produce plots and tables for report

# Before: passmark.csv (output)
# After:  cpu_benchmark.png, cpu_multicore.png, effective_cores.png,
#         memory_benchmark.png, memory_detail.png (report)

library(TAF)

mkdir("report")

# Read data
info <- read.taf("data/info.csv")
memory.details <- read.taf("data/passmark.csv")
passmark <- read.taf("output/passmark.csv")

# Single thread
single <- passmark[order(passmark$single),]
taf.png("cpu_benchmark")
barplot(single$single, names=single$machine,
        main="Single-thread benchmark", xlab="",
        ylab="Score (PassMark single thread)")
dev.off()

# Multithread
multi <- passmark[order(passmark$multi),]
taf.png("cpu_multicore")
barplot(multi$multi, names=multi$machine,
        main="Multithread benchmark", xlab="",
        ylab="Score (PassMark multithread)")
dev.off()

# Effective cores
effective <- passmark[order(passmark$effcores),]
taf.png("effective_cores")
barplot(effective$physcores, names=effective$machine, col=0,
        ylab="Number of cores")
barplot(effective$effcores, col="lightgray", add=TRUE)
legend("topleft", legend=c("Physical", "Effective index"),
       fill=c("white","lightgray"), bty="n", inset=0.02, y.intersp=1.25)
title(main="Effective core index = multithread score / single-thread score")
dev.off()

# Memory
memory <- merge(memory.details, info[c("machine", "module", "year")])
memory <- memory[order(memory$memory),]
memory <- memory[c("machine", "memory", "database", "readcache", "read",
                   "write", "available", "latency", "threaded", "module",
                   "year")]
labels <- paste0(memory$machine, "\n(", memory$module, ")\n", memory$year)

taf.png("memory_benchmark")
mgp <- c(3, 2.3, 0)
barplot(memory$memory, names=labels, main="Memory benchmark", xlab="",
        ylab="Score", yaxt="n", mgp=mgp)
axis(2)
dev.off()

taf.png("memory_details", 1600, 3600)
par(mfrow=c(3,1))
barplot(memory$read, names=labels, main="Memory (read)", xlab="", col=7,
        ylab="Score", yaxt="n", mgp=mgp)
axis(2)
barplot(memory$write, names=labels, main="Memory (write)", xlab="", col=2,
        ylab="Score", yaxt="n", mgp=mgp)
axis(2)
barplot(memory$latency, names=labels, main="Memory (latency)", xlab="", col=3,
        ylab="Score", yaxt="n", mgp=mgp)
axis(2)
dev.off()
