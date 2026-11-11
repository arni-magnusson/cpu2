# Run analysis, write model results

# Before: companies.csv, history.csv, i7_high.csv, i7_low.csv, i7_medium.csv,
#         r7_high.csv, r7_low.csv (data)
# After:  companies_fit.csv,  companies_fm.rds, companies_lag.csv,
#         history_analysis.csv, history_fit.csv, history_fm.RData,
#         history_rate.csv, i7_high.csv,
#         i7_low.csv, i7_medium.csv, r7_high.csv, r7_low.csv (model)

library(TAF)

mkdir("model")

# Read tables
companies <- read.taf("data/companies.csv", colClasses=c(Date="Date"))
history <- read.taf("data/history.csv", colClasses=c(Date="Date"))
i7.high <- read.taf("data/i7_high.csv")
i7.medium <- read.taf("data/i7_medium.csv")
i7.low <- read.taf("data/i7_low.csv")
r7.high <- read.taf("data/r7_high.csv")
r7.low <- read.taf("data/r7_low.csv")

# Calculate relative speed improvement
improve <- function(x) c(NA, x$Speed[-1] / x$Speed[-nrow(x)]) - 1
i7.high$Improve <- improve(i7.high)
i7.medium$Improve <- improve(i7.medium)
i7.low$Improve <- improve(i7.low)
r7.high$Improve <- improve(r7.high)
r7.low$Improve <- improve(r7.low)

# Fit ancova model comparing companies: Apple, Intel, AMD
start <- as.Date("2018-07-01")
companies.fm <- lm(log(Speed)~-1+Company+Date, companies, subset=Date>start)
x0 <- -coef(companies.fm)[1:3] / coef(companies.fm)[4]
names(x0) <- sub("Company", "", names(x0))
companies.lag <- data.frame(Company=names(x0), Intercept=as.Date(x0),
                            Lag=(x0-min(x0))/365.25)
companies.fit <- expand.grid(Company=c("AMD", "Apple", "Intel"),
                             Date=c(start, max(companies$Date)))
companies.fit$Speed <- exp(predict(companies.fm, companies.fit))

# Fit linear model to describe historical speed improvement
history.analysis <- history[history$Company == "Intel",]
history.analysis$Year <- as.numeric(history.analysis$Date) / 365.25
history.analysis$Period <- ifelse(history.analysis$Date < "2010-01-01",
                                  "Early", "Late")
early.fm <- lm(log(Speed)~Year, history.analysis, subset=Period=="Early")
late.fm <- lm(log(Speed)~Year, history.analysis, subset=Period=="Late")
slope <- c(coef(early.fm)[[2]], coef(late.fm)[[2]])
history.rate <- data.frame(Period=c("Early", "Late"), Annual=exp(slope)-1,
                           Doubling=log(2) / slope)
history.fit <- data.frame(
  Period=c("Early", "Early", "Late", "Late"),
  Date=c(range(history.analysis$Date[history.analysis$Period=="Early"]),
         range(history.analysis$Date[history.analysis$Period=="Late"])))
history.fit$Year <- as.numeric(history.fit$Date) / 365.25
history.fit$Speed <-
  c(exp(predict(early.fm, history.fit[history.fit$Period == "Early",])),
    exp(predict(late.fm, history.fit[history.fit$Period == "Late",])))

# Save fitted models
saveRDS(companies.fm, "model/companies_fm.rds")
save(early.fm, late.fm, file="model/history_fm.RData")

# Save tables
write.taf(companies.fit, dir="model")
write.taf(companies.lag, dir="model")
write.taf(history.analysis, dir="model")
write.taf(history.fit, dir="model")
write.taf(history.rate, dir="model")
write.taf(i7.high, dir="model")
write.taf(i7.medium, dir="model")
write.taf(i7.low, dir="model")
write.taf(r7.high, dir="model")
write.taf(r7.low, dir="model")
