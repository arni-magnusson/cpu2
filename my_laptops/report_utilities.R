# Shared ggplot style and helpers for report plots

library(ggplot2)

plot_theme <- theme_minimal(base_size=12) +
  theme(panel.grid.minor=element_blank(),
        plot.title.position="plot",
        plot.title=element_text(face="bold", hjust=0.5))

# Preserve the original plot fill coding for laptop form
form_colors <- c(Ultraportable="white", Intermediate="gray", Workstation="black")

plot_points <- function(data, x, y, title, ylab, xlab=NULL,
                        log_x=FALSE, log_y=FALSE, y_limits=NULL,
                        y_breaks=NULL, y_labels=NULL) {
  p <- ggplot(data,
              aes(x=!!rlang::sym(x), y=!!rlang::sym(y), fill=Form)) +
    geom_point(shape=21, color="black", size=2.5, stroke=0.6) +
    scale_fill_manual(values=form_colors, guide="none") +
    labs(title=title, x=xlab, y=ylab) +
    plot_theme +
    coord_cartesian(ylim=y_limits)

  if (log_x)
    p <- p + scale_x_log10()

  if (log_y && !is.null(y_breaks) && !is.null(y_labels)) {
    p <- p + scale_y_log10(breaks=y_breaks, labels=y_labels)
  } else if (log_y && !is.null(y_breaks)) {
    p <- p + scale_y_log10(breaks=y_breaks)
  } else if (log_y) {
    p <- p + scale_y_log10()
  } else if (!is.null(y_breaks) && !is.null(y_labels)) {
    p <- p + scale_y_continuous(breaks=y_breaks, labels=y_labels)
  } else if (!is.null(y_breaks)) {
    p <- p + scale_y_continuous(breaks=y_breaks)
  }

  p
}

save_plot <- function(filename, plot) {
  taf.png(filename)
  print(plot)
  dev.off()
}
