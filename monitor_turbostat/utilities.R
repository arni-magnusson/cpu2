library(ggplot2)

machine_order <- c("m4700", "p15gen1", "p3560", "p1gen8")
machine_colors <- c(p1gen8="#0072B2", p15gen1="#D55E00",
                    p3560="#009E73", m4700="#C4A000")
workload_order <- c("idle", "single", "main", "full")
workload_labels <- c(idle="Idle", single="Single-thread",
                     main="Main", full="Full")
workload_colors <- c(idle="#999999", single="#0072B2",
                     main="#D55E00", full="#009E73")
metric_order <- c("Freq", "Temp", "Watt")
metric_labels <- c(Freq="Frequency (MHz)", Temp="Temperature (°C)",
                   Watt="Package power (W)")

monitor_theme <- function() {
  theme_minimal(base_size=12) +
    theme(panel.grid.minor=element_blank(),
          plot.title=element_text(face="bold", hjust=0.5,
                                 margin=margin(b=18)),
          plot.title.position="plot",
          axis.title.x=element_text(margin=margin(t=8)),
          axis.title.y=element_text(margin=margin(r=8)),
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
        values <- machines[[machine]][[workload]][[metric]]
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
        values <- machines[[machine]][[workload]][[metric]]
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
    scale_y_continuous(limits=c(0, NA), expand=expansion(mult=c(0, 0.05))) +
    labs(title="CPU monitoring by machine and workload",
         x="Iteration", y=NULL) +
    monitor_theme() +
    theme(strip.text.x=element_text(face="bold", margin=margin(b=10)),
          panel.spacing.y=grid::unit(1.25, "lines"))
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
    scale_y_continuous(limits=c(0, NA), expand=expansion(mult=c(0, 0.05))) +
    labs(title="Machine measurements by workload",
         x="Iteration", y=NULL) +
    monitor_theme() +
    theme(strip.text.x=element_text(face="bold", margin=margin(b=10)),
          panel.spacing.y=grid::unit(1.25, "lines"))
}

outliers <- function(x, span=0.75, dist=0.5, plot=FALSE, xlab="", ylab="", ...)
{
  # Fit loess model
  iter <- 1:length(x)
  trend <- loess(x~iter, span=span)$fitted

  # Calculate absolute residual
  absresid <- abs(x - trend)

  # Identify outliers
  index <- which(absresid > dist)
  values <- x[index]
  expected <- trend[index]

  # Repair outliers
  repaired <- replace(x, index, expected)

  # Plot
  if(plot)
  {
    plot(x, xlab=xlab, ylab=ylab, ...)
    lines(trend, lwd=2, ...)
    points(index, values, pch=4, cex=1.5, lwd=3, col=2)
    points(index, expected, pch=16, cex=1.5, col=3)
  }

  out <- list(trend=trend, repaired=repaired, index=index, values=values,
              expected=expected)
  out
}

read_turbostat <- function(file, n=300, burn=0)
{
  # Parse args
  if(length(burn) == 1)
    burn <- c(burn, 0)  # first and last rows to remove

  # Read file
  txt <- readLines(file)
  beg <- grep("^Avg_MHz", txt)
  out <- read.table(text=txt, header=TRUE, skip=beg-1)

  # Subset cols
  out <- out[c("Bzy_MHz", "PkgTmp", "PkgWatt")]
  names(out) <- c("Freq", "Temp", "Watt")

  # Subset rows
  if(burn[1] > 0)
    out <- tail(out, -burn[1])  # remove first rows
  if(burn[2] > 0)
    out <- head(out, -burn[2])  # remove last rows
  if(is.numeric(n) && n > 0 && is.finite(n))  # return n rows
    out <- out[1:n,]

  out
}
