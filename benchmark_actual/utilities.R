library(ggplot2)

plot_theme <- function() {
  theme_minimal(base_size=12) +
    theme(panel.grid.major.y=element_blank(),
          panel.grid.minor=element_blank(),
          legend.position=c(0.98, 0.02),
          legend.justification=c(1, 0),
          legend.direction="vertical",
          legend.background=element_rect(fill="white", color=NA),
          plot.title.position="plot",
          plot.title=element_text(face="bold", hjust=0.5,
                                 margin=margin(b=18)),
          axis.title.x=element_text(margin=margin(t=8)),
          axis.title.y=element_text(margin=margin(r=8)))
}
