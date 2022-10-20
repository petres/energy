# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(stringr)


# - DATA -----------------------------------------------------------------------
d.hdd = fread(file.path(g$d$o, 'temp-hdd.csv'))[, `:=`(
    date = as.Date(date)
)]

# LOAD/PREP GAS CONS
d.consumption = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, .(
    date = as.Date(date),
    value = value
)]

# MERGE
d.comb = merge(d.consumption, d.hdd, by = "date")

# AUGMENT
d.comb[, `:=`(
    t = as.integer(date - min(date)),
    year = year(date),
    day = yday(date),
    week = week(date),
    wday = factor(
        weekdays(date, abbreviate = TRUE),
        c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    ),
    temp.15 = ifelse(temp < 15, 15 - temp, 0),
    temp.squared  = temp^2,
    temp.lag = shift(temp, 1)
)]

d.comb[, `:=`(
    t.squared = t^2,
    workday = ifelse(wday %in% c("Sat", "Sun"), wday, "Working day"),
    week = str_pad(week, 2, pad = "0"),
    temp.15.squared = temp.15^2,
    temp.15.lag = shift(temp.15, 1)
)]


# - MODEL ----------------------------------------------------------------------
d.train = d.comb[year %in% (min(year):(max(year) - 1)), ]
d.pred = copy(d.comb)

m.linear = lm(
    value ~ t + t.squared +
        temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
        wday + week
, data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]


# - OUTPUT ---------------------------------------------------------------------
d.all = melt(d.pred, variable.name = 'type',
    id.vars = c('date'), measure.vars = c('value', 'prediction')
)

# PREP FOR PLOT
addRollMean(d.all, 7, 'type')
addCum(d.all)
d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
dates2PlotDates(d.plot)

# SAVE
fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))
