library(ggplot2)

company_colors <- c(Apple="#009E73", Intel="#0072B2", AMD="#D55E00")

plot_theme <- function() {
  theme_minimal(base_size=12) +
    theme(panel.grid.minor=element_blank(),
          plot.title=element_text(face="bold", hjust=0.5),
          plot.title.position="plot")
}

legend_inside <- theme(legend.position=c(0.02, 0.98),
                       legend.justification=c(0, 1),
                       legend.background=element_rect(fill="white", color=NA))

# Plot improvement
implot <- function(x, fill="#0072B2", title=NULL, xlim=c(0,35)) {
  x <- x[-1,]
  labels <- paste0(x$Model, " (", format(x$Date, "%Y"), ")")
  x$Model <- factor(labels, levels=labels)

  ggplot(x, aes(x=100*Improve, y=Model)) +
    geom_col(fill=fill, width=0.65) +
    scale_x_continuous(expand=expansion(mult=c(0, 0))) +
    coord_cartesian(xlim=xlim) +
    labs(title=title, x="Speed improvement (%)", y=NULL) +
    plot_theme()
}
