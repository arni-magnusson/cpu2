library(ggplot2)

machine_order <- c("p1gen8", "p15gen1", "p3560", "m4700")
machine_colors <- c(p1gen8="#0072B2", p15gen1="#D55E00",
                    p3560="#009E73", m4700="#C4A000")
workload_order <- c("idle", "single", "main", "full")
workload_labels <- c(idle="Idle", single="Single-thread",
                     main="Main", full="Full")
workload_colors <- c(idle="#999999", single="#0072B2",
                     main="#D55E00", full="#009E73")
metric_order <- c("Freq", "Temp", "Fan")
metric_labels <- c(Freq="Frequency (MHz)", Temp="Temperature (°C)",
                   Fan="Fan speed (RPM)")

monitor_theme <- function() {
  theme_minimal(base_size=12) +
    theme(panel.grid.minor=element_blank(),
          plot.title=element_text(face="bold", hjust=0.5,
                                 margin=margin(b=12)),
          plot.title.position="plot",
          strip.text=element_text(face="bold"),
          legend.title=element_blank(),
          legend.position="bottom")
}

comparison_data <- function(machines) {
  rows <- list()
  i <- 0
  for (metric in metric_order) {
    for (workload in workload_order) {
      for (machine in machine_order) {
        values <- machines[[machine]][[workload]][[paste0(metric, "1")]]
        i <- i + 1
        rows[[i]] <- data.frame(machine=machine, workload=workload,
                                metric=metric,
                                iteration=seq_along(values), value=values)
      }
    }
  }
  out <- do.call(rbind, rows)
  panels <- unlist(lapply(metric_order, function(metric) {
    paste(metric, workload_order, sep="|")
  }))
  labels <- setNames(unlist(lapply(metric_order, function(metric) {
    paste(metric_labels[[metric]], workload_labels[workload_order], sep="\n")
  })), panels)
  out$panel <- factor(paste(out$metric, out$workload, sep="|"), levels=panels)
  attr(out, "panel_labels") <- labels
  out$machine <- factor(out$machine, levels=machine_order)
  out
}

each_data <- function(machines, machine_names) {
  rows <- list()
  i <- 0
  for (metric in metric_order) {
    for (machine in machine_order) {
      for (workload in workload_order) {
        values <- machines[[machine]][[workload]][[paste0(metric, "1")]]
        i <- i + 1
        rows[[i]] <- data.frame(machine=machine, workload=workload,
                                metric=metric,
                                iteration=seq_along(values), value=values)
      }
    }
  }
  out <- do.call(rbind, rows)
  panels <- unlist(lapply(metric_order, function(metric) {
    paste(metric, machine_order, sep="|")
  }))
  labels <- setNames(unlist(lapply(metric_order, function(metric) {
    paste(metric_labels[[metric]], machine_names[machine_order], sep="\n")
  })), panels)
  out$panel <- factor(paste(out$metric, out$machine, sep="|"), levels=panels)
  attr(out, "panel_labels") <- labels
  out$workload <- factor(out$workload, levels=workload_order)
  out
}

core_data <- function(cores) {
  rows <- list()
  i <- 0
  for (machine in machine_order) {
    for (workload in workload_order) {
      values <- cores[[machine]][[workload]]
      i <- i + 1
      rows[[i]] <- data.frame(machine=machine, core=seq_along(values),
                              workload=workload, value=values)
    }
  }
  out <- do.call(rbind, rows)
  out$machine <- factor(out$machine, levels=machine_order)
  out$workload <- factor(out$workload, levels=workload_order)
  out
}

plot_comparison <- function(data, machine_labels) {
  ggplot(data, aes(x=iteration, y=value, color=machine)) +
    geom_point(size=0.45, alpha=0.7, key_glyph=draw_key_path) +
    facet_wrap(~panel, ncol=4, scales="free_y",
               labeller=as_labeller(attr(data, "panel_labels"))) +
    scale_color_manual(values=machine_colors, breaks=machine_order,
                       labels=machine_labels[machine_order]) +
    guides(color=guide_legend(override.aes=list(linetype=1,
                                                linewidth=1.2, alpha=1))) +
    scale_x_continuous(limits=c(0, 300), breaks=seq(0, 300, 100)) +
    labs(title="CPU monitoring by machine and workload",
         x="Iteration", y=NULL) +
    monitor_theme() +
    theme(strip.text.x=element_text(face="bold", margin=margin(b=10)),
          panel.spacing.y=grid::unit(1.25, "lines"))
}

plot_cores <- function(data, machine_names) {
  ggplot(data, aes(x=core, y=value, color=workload, group=workload)) +
    geom_line(linewidth=0.75) +
    geom_point(size=1.2, show.legend=FALSE) +
    facet_wrap(~machine, ncol=2, scales="free",
               labeller=as_labeller(machine_names[machine_order])) +
    scale_color_manual(values=workload_colors, breaks=workload_order,
                       labels=workload_labels[workload_order]) +
    labs(title="Frequency by core and workload",
         x="Core", y="Frequency (MHz)") +
    monitor_theme() +
    theme(strip.text.x=element_text(face="bold", margin=margin(b=10)),
          panel.spacing.y=grid::unit(1.25, "lines"),
          plot.margin=margin(t=5.5, r=5.5, b=5.5, l=28))
}

plot_each <- function(data) {
  ggplot(data, aes(x=iteration, y=value, color=workload)) +
    geom_point(size=0.45, alpha=0.7, key_glyph=draw_key_path) +
    facet_wrap(~panel, ncol=4, scales="free_y",
               labeller=as_labeller(attr(data, "panel_labels"))) +
    scale_color_manual(values=workload_colors, breaks=workload_order,
                       labels=workload_labels[workload_order]) +
    guides(color=guide_legend(override.aes=list(linetype=1,
                                                linewidth=1.2, alpha=1))) +
    scale_x_continuous(limits=c(0, 300), breaks=seq(0, 300, 100)) +
    labs(title="Machine measurements by workload",
         x="Iteration", y=NULL) +
    monitor_theme() +
    theme(strip.text.x=element_text(face="bold", margin=margin(b=10)),
          panel.spacing.y=grid::unit(1.25, "lines"))
}

means <- function(x)
{
  freq <- sapply(x[grep("Freq", names(x))], mean)
  temp <- sapply(x[grep("Temp", names(x))], mean)
  fan <- sapply(x[grep("Fan", names(x))], mean)
  c(freq, temp, fan)
}

remove_first <- function(x, burn=0, length=300)
{
  x <- x[(1:length)+burn,]
  x$Time <- x$Time - min(x$Time)
  row.names(x) <- NULL
  x
}

summary_machine <- function(x, machine=deparse(substitute(x)))
{
  peak <- function(y)
  {
    c(freq=mean(y$Freq1),
      temp=mean(y$Temp1),
      fan=mean(y$Fan1))
  }
  out <- sapply(x, peak)
  out <- xtab2taf(t(out), "state")
  out <- data.frame(machine=machine, out)
  out
}
