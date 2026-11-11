readPass <- function(file)
{
  # Read text
  x <- readLines(file)

  # Trim
  x <- trimws(x)
  x <- x[grep("CPU Mark", x):length(x)]
  x <- x[x != ""]

  # Use comma separator
  x <- sub(":", "", x)
  x <- sub("  +", ",", x)

  # Read into data frame
  x <- read.table(text=x, sep=",", col.names=c("Variable", "Value"))

  # Simplify variable names
  x$Variable[x$Variable == "CPU Mark"] <- "cpu"
  x$Variable[x$Variable == "Integer Math"] <- "int"
  x$Variable[x$Variable == "Floating Point Math"] <- "float"
  x$Variable[x$Variable == "Prime Numbers"] <- "prime"
  x$Variable[x$Variable == "Sorting"] <- "sort"
  x$Variable[x$Variable == "Encryption"] <- "encrypt"
  x$Variable[x$Variable == "Compression"] <- "compress"
  x$Variable[x$Variable == "CPU Single Threaded"] <- "single"
  x$Variable[x$Variable == "Physics"] <- "physics"
  x$Variable[x$Variable == "Extended Instructions (SSE)"] <- "sse"
  x$Variable[x$Variable == "Memory Mark"] <- "memory"
  x$Variable[x$Variable == "Database Operations"] <- "database"
  x$Variable[x$Variable == "Memory Read Cached"] <- "readcache"
  x$Variable[x$Variable == "Memory Read Uncached"] <- "read"
  x$Variable[x$Variable == "Memory Write"] <- "write"
  x$Variable[x$Variable == "Available RAM"] <- "available"
  x$Variable[x$Variable == "Memory Latency"] <- "latency"
  x$Variable[x$Variable == "Memory Threaded"] <- "threaded"

  # Simplify values
  x$Value <- sub(" .*", "", x$Value)
  x$Value <- type.convert(x$Value, as.is=TRUE)

  x
}
