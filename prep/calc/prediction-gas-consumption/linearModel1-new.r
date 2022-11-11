# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
source('calc/prediction-gas-consumption/_functions.r')
loadPackages(stringr, tidyverse)


# - DATA -----------------------------------------------------------------------
# LOAD TEMP/HDD
d.hdd = fread(file.path(g$d$o, 'temp-hdd.csv'))[, `:=`(
    date = as.Date(date)
)]

# LOAD GAS CONS
d.consumption = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, .(
    date = as.Date(date),
    value = value
)]

# LOAD HOLIDAYS
d.holidays = fread(file.path(g$d$o, 'holidays.csv'))[, `:=`(
    date = as.Date(date)
    # holiday.name = ifelse(holiday.name == "", NA, holiday.name),
    # vacation.name = ifelse(vacation.name == "", NA, vacation.name)
)]

# MERGE
d.comb = merge(d.consumption, d.hdd, by = "date")
d.comb = merge(d.comb, d.holidays, by = "date")


d.economic.activity = read.economic.activity()
# d.comb[, `:=`(
#     temp = temp.vienna,
#     hdd = hdd.vienna
# )]

# AUGMENT
d.comb[, `:=`(
    t = as.integer(date - min(date)),
    year = year(date),
    day = yday(date),
    week = week(date),
    month = month(date),
    wday = factor(
        weekdays(date, abbreviate = TRUE),
        c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    ),
    temp.15 = ifelse(temp < 15, 15 - temp, 0),
    temp.squared  = temp^2,
    temp.lag = shift(temp, 1),
    # AR TERMS, ONLY TESTING
    value.lag = shift(value, 1),
    value.lag2 = shift(value, 2)
)]

d.comb[, `:=`(
    t.squared = t^2,
    workday = ifelse(wday %in% c("Sat", "Sun"), wday, "Working day"),
    week = str_pad(week, 2, pad = "0"),
    temp.15.squared = temp.15^2,
    temp.15.lag = shift(temp.15, 1),
    year_character = as.character(year),
    # temp.f = cut(temp, quantile(temp, 0:20/20), all.inside = TRUE),
    temp.f = cut(temp, seq(min(temp), max(temp), length = 10), all.inside = TRUE)
)]

train.years = c(2013:2020)

d.train = d.comb[year %in% train.years]
d.pred = copy(d.comb)

m.linear = lm(
    value ~ t + t.squared +
        # value.lag + value.lag2 + # AR TERMS
        temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
        # temp * as.factor(temp.f) +
        wday + is.holiday + as.factor(vacation.name) + as.factor(month)
    , data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]

d.plot = melt(d.pred, id.vars = 'date', measure.vars = c('value', 'prediction'))[, `:=`(
    date = yday(date),
    year = as.factor(year(date))
)]

ggplot(d.plot[year == "2021"], aes(x = date, y = value)) +
    geom_line(aes(linetype = variable, group = paste(variable, year), color = year))




# - OUTPUT ---------------------------------------------------------------------
# d.all = melt(d.pred, variable.name = 'type',
#              id.vars = c('date'), measure.vars = c('value', 'prediction')
# )

# # PREP FOR PLOT
# addRollMean(d.all, 7, 'type')
# addCum(d.all, 'type')
# d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
# dates2PlotDates(d.plot)

# # SAVE
# fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))



d.month = d.pred[, .(
    value = sum(value),
    prediction = sum(prediction)
) , by = .(month, year)]

d.month[, diff := prediction - value]

# d.month = melt(d.month, variable.name = 'type',
#              id.vars = c('year', 'month'), measure.vars = c('value', 'prediction', 'diff')
# )


ggplot(d.month, aes(x = as.Date(glue("{year}-{month}-15")), y = diff)) + geom_line()

