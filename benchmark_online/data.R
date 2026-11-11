# Prepare data, write CSV data tables

# Before: apple.dat, i7_high.dat, i7_low.dat, i7_medium.dat, prehistory.dat,
#         r7_high.dat, r7_low.dat (boot/data)
# After:  apple.csv, companies.csv, history.csv, i7_high.csv, i7_low.csv,
#         i7_medium.csv, r7_high.csv, r7_low.csv (data)

library(TAF)

mkdir("data")

# Read initial data
apple <- read.table("boot/data/apple.dat", header=TRUE, fill=TRUE)
i7.high <- read.table("boot/data/i7_high.dat", header=TRUE, fill=TRUE)
i7.medium <- read.table("boot/data/i7_medium.dat", header=TRUE, fill=TRUE)
i7.low <- read.table("boot/data/i7_low.dat", header=TRUE, fill=TRUE)
prehistory <- read.table("boot/data/prehistory.dat", header=TRUE, fill=TRUE)
r7.high <- read.table("boot/data/r7_high.dat", header=TRUE, fill=TRUE)
r7.low <- read.table("boot/data/r7_low.dat", header=TRUE, fill=TRUE)

# Remove column
apple$Laptop <- NULL
i7.high$Laptop <- NULL
i7.medium$Laptop <- NULL
i7.low$Laptop <- NULL
prehistory$Laptop <- NULL
r7.high$Laptop <- NULL
r7.low$Laptop <- NULL

# Rename column
names(apple)[names(apple) == "Single"] <- "Speed"
names(i7.high)[names(i7.high) == "Single"] <- "Speed"
names(i7.medium)[names(i7.medium) == "Single"] <- "Speed"
names(i7.low)[names(i7.low) == "Single"] <- "Speed"
names(prehistory)[names(prehistory) == "Single"] <- "Speed"
names(r7.high)[names(r7.high) == "Single"] <- "Speed"
names(r7.low)[names(r7.low) == "Single"] <- "Speed"

# Replace outlier with prediction
basis <- apple[-grep("M3", apple$Model),]
air <- basis$Speed[grep("[0-9]$", basis$Model)]
pro <- basis$Speed[grep("Pro", basis$Model)]
# Relationship between Air and Pro tends to be around 97%
pred <- round(apple$Speed[apple$Model == "M3-Pro"] * mean(air) / mean(pro))
apple$Speed[apple$Model == "M3"] <- pred

# Combine companies for analysis
pro <- apple[grep("Pro", apple$Model),]
pro$Company <- "Apple"
intel <- transform(i7.high, Company="Intel")
amd <- transform(r7.high, Company="AMD")
companies <- rbind(pro, intel, amd)

# Combine prehistoric and recent processors
history.amd <- rbind(prehistory[prehistory$Company == "AMD",],
                     cbind(Company="AMD", r7.high))
history.intel <- rbind(prehistory[prehistory$Company == "Intel",],
                       cbind(Company="Intel", i7.high[-1,]))
history <- rbind(history.amd, history.intel)

# Save tables
write.taf(apple, dir="data")
write.taf(companies, dir="data")
write.taf(history, dir="data")
write.taf(i7.high, dir="data")
write.taf(i7.medium, dir="data")
write.taf(i7.low, dir="data")
write.taf(r7.high, dir="data")
write.taf(r7.low, dir="data")
