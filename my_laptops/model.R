# Run analysis, write model results

# Before: specs.csv (data)
# After:  specs.csv, speed_fit.csv, speed_fm.rds (model)

library(TAF)
source("utilities.R")

mkdir("model")

# Read data
specs <- read.taf("data/specs.csv", colClasses=c(Date="Date"))

# Add columns
specs$Cache <- apply(specs, 1, getCache)
specs$Year <- as.numeric(specs$Date) / 365.25
specs$Form <- ifelse(specs$W > 30, "Workstation",
              ifelse(specs$W > 20, "Intermediate", "Ultraportable"))
specs$bg <- ifelse(specs$Form == "Workstation", "black",
            ifelse(specs$Form == "Intermediate", "gray", "white"))
specs$w <- as.integer(sub("x.*", "", specs$Res))
specs$h <- as.integer(sub(".*x", "", specs$Res))
specs$mp <- specs$w * specs$h / 1e6
specs$ppi <- sqrt(specs$w^2 + specs$h^2) / specs$Disp

# Fit linear model describing long-term speed trend
speed.fm <- lm(log(Speed)~Year, specs)
speed.fit <- data.frame(Date=range(specs$Date),
                        Year=range(specs$Year),
                        Speed=exp(range(speed.fm$fit)))

# Save fitted model
saveRDS(speed.fm, "model/speed_fm.rds")

# Write tables
write.taf(specs, dir="model")
write.taf(speed.fit, dir="model")
