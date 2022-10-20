# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(stringr)

# - DATA -----------------------------------------------------------------------
# LOAD/PREP HDD
# d.hdd.old = fread(file.path(g$d$o, 'heating-degree-days.csv'))[, .(
#     date = as.Date(time),
#     hdd = `0`
# )]

d.hdd.new = fread(file.path(g$d$o, 'temp-hdd.csv'))[, `:=`(
    date = as.Date(date)
)]

# CHECK
# merge(d.hdd, d.hdd2, by='date')

d.hdd = d.hdd.new


# LOAD/PREP GAS CONS
d.consumption = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, .(
    date = as.Date(date),
    value = value
)]

# MERGE
d.comb = merge(d.consumption, d.hdd, by = "date")

# AUGMENT
d.comb[, `:=`(
    year = year(date),
    day = yday(date),
    wday = factor(weekdays(date, abbreviate = TRUE),
        c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
)]

d.comb[, `:=`(
    workday = ifelse(wday %in% c("Sat", "Sun"), wday, "Working day"),
    # sinc  = sin(2*pi*day/365),
    # cosc  = cos(2*pi*day/365),
    temp2  = temp^2,
    tempL1 = shift(temp, 1),
    hdd2  = hdd^2,
    hddL2 = shift(hdd, 1) + shift(hdd, 2),
    # hdd_s_10 = ifelse(hdd<10, hdd, 0),
    # hdd_l_10 = ifelse(hdd>=10, hdd, 0),
    week = str_pad(week(date), 2, pad = "0")
    # month = as.character(month(date))
),]

# d.comb[, `:=`(
#     hdd_l_10_2 = hdd_l_10*hdd_l_10,
#     hdd_l_10_log = log(hdd_l_10+1)
# )]


# - MODEL ----------------------------------------------------------------------
# temperature correction with linear model

d.train = d.comb[year %in% (min(year):(max(year) - 1)), ]
d.pred = copy(d.comb)

# m.linear = lm(value ~ wday + hdd_s_10 + hdd_l_10 + week, data = d.train)
m.linear = lm(value ~ wday + temp + temp2 + tempL1 + hdd + hdd2 + hddL2 + week + year, data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]

# - OUTPUT ---------------------------------------------------------------------
d.all = melt(d.pred, variable.name = 'type',
    id.vars = c('date'), measure.vars = c('value', 'prediction'))

# c.names = c(
#     value = "Beobachtung",
#     prediction = "Nachfrage geschätzt mit Klima von 2022\n Modell trainiert auf Daten 2019-2021"
# )



addRollMean(d.all, 7, 'type')
addCum(d.all)
d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
dates2PlotDates(d.plot)

fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))

#proposal for visualization
# loadPackages('tidyverse')
# ggplot(d.all, aes(x=date, y=rm10)) +
#    geom_line(aes(linetype = type, color = year))


# addRollMean(d.all, 7)
# addCum(d.all)
# d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
# dates2PlotDates(d.plot)
