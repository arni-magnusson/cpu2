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

plot_comparison <- function(machines, state, variable, main=NULL,
                            xlab="Iteration", ylab="", pch=1, lwd=1.5,
                            col=c(6,2,4,3), type="p", ...)
{
  # Extract data
  x <- sapply(machines, `[`, state)
  x <- sapply(x, `[`, variable)
  names(x) <- names(machines)

  # Prepare plot elements
  k <- length(x)
  col <- rep(col, length=k)
  xlim <- c(0, max(sapply(x, length)))
  ylim <- lim(unlist(x))
  if(is.null(main))
    main <- paste0(variable, " (", state, ")")

  # Plot
  plot(NA, xlim=xlim, ylim=ylim, main=main, xlab=xlab, ylab=ylab, ...)
  for(i in 1:k)
    points(x[[i]], pch=pch, lwd=lwd, col=col[i], type=type)
  legend("bottomleft", rev(names(x)), pch=pch, pt.lwd=lwd, col=rev(col),
         bty="n", inset=0.02, y.intersp=1.25)
}

plot_machine <- function(machine, variable,
                         main=paste(deparse(substitute(machine)), variable),
                         xlab="Iteration", ylab="", pch=1, lwd=1.5,
                         col=c(8,1,4,5), type="p", ...)
{
  # Prepare plot elements
  k <- length(machine)
  col <- rep(col, length=k)
  xlim <- c(0, max(sapply(machine, nrow)))
  ylim <- lim(unlist(lapply(machine, `[[`, variable)))

  # Plot
  plot(NA, xlim=xlim, ylim=ylim, main=main, xlab=xlab, ylab=ylab, ...)
  for(i in 1:k)
    points(machine[[i]][[variable]], pch=pch, lwd=lwd, col=col[i], type=type)
  legend("bottomleft", rev(names(machine)), pch=pch, pt.lwd=lwd, col=rev(col),
         bty="n", inset=0.02, y.intersp=1.25)
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
