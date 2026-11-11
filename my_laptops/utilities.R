getCache <- function(x)
{
  L3 <- as.numeric(x[["L3"]])
  L2 <- as.numeric(x[["L2"]])
  size <- if(L3 > 0) L3 else L2
  size
}
