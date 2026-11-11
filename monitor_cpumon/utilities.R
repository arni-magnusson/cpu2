means <- function(x)
{
  freq <- sapply(x[grep("Freq", names(x))], mean)
  temp <- sapply(x[grep("Temp", names(x))], mean)
  fan <- sapply(x[grep("Fan", names(x))], mean)
  c(freq, temp, fan)
}

plot_comparison <- function(machines, state, variable, main=NULL,
                            xlab="Iteration", ylab="", pch=1, lwd=1.5,
                            col=c(6,2,4,3), type="p", ...)
{
  # Prepare variable and variable1
  variable <- gsub("[0-9]", "", variable)  # Freq
  variable1 <- paste0(variable, "1")       # Freq1

  # Extract data
  x <- sapply(machines, `[`, state)
  x <- sapply(x, `[`, variable1)
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

plot_cores <- function(machine, main=tail(as.character(substitute(machine)), 1),
                       xlab="Core", ylab="Freq", lwd=1.5, col=c(8,1,4,5), ...)
{
  plot(NA, xlim=c(1,nrow(machine)), ylim=lim(unlist(machine)), main=main,
       xlab=xlab, ylab=ylab, xaxt="n", ...)
  axis(1, 1:nrow(machine))
  matlines(machine, lty=1, type="o", pch=16, lwd=lwd, col=col)
  legend("bottomleft", rev(names(machine)), lwd=lwd, col=rev(col),
         bty="n", inset=0.02, y.intersp=1.25)
}

plot_machine <- function(machine, variable,
                         main=paste(deparse(substitute(machine)), variable),
                         xlab="Iteration", ylab="", pch=1, lwd=1.5,
                         col=c(8,1,4,5), type="p", ...)
{
  # Prepare variable and variable1
  variable <- gsub("[0-9]", "", variable)  # Freq
  variable1 <- paste0(variable, "1")       # Freq1

  # Prepare plot elements
  k <- length(machine)
  col <- rep(col, length=k)
  xlim <- c(0, 300)
  ylim <- lim(unlist(lapply(machine, `[[`, variable1)))

  plot(NA, xlim=xlim, ylim=ylim, main=main, xlab=xlab, ylab=ylab, ...)
  for(i in 1:k)
    points(machine[[i]][[variable1]], pch=pch, lwd=lwd, col=col[i], type=type)
  legend("bottomleft", rev(names(machine)), pch=pch, pt.lwd=lwd, col=rev(col),
         bty="n", inset=0.02, y.intersp=1.25)
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
