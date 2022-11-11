# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/aggm/_shared.r')


# - CONF -----------------------------------------------------------------------
historic.data.file = file.path(g$d$o, 'consumption-gas-aggm-historic.csv')
if (!file.exists(historic.data.file)) {
    d.historic = getGasConsumption('2018-12-30', '2022-01-02')
    d.t0 = d.historic[, .(
        value = sum(value)/10^9
    ), by=.(date = as.Date(from))][year(date) %in% 2019:2021]

    d.historic = getGasConsumption('2015-12-30', '2019-01-02')
    d.t1 = d.historic[, .(
        value = sum(value)/10^9
    ), by=.(date = as.Date(from))][year(date) %in% 2016:2018]

    d.historic = getGasConsumption('2012-12-30', '2016-01-02')
    d.t2 = d.historic[, .(
        value = sum(value)/10^9
    ), by=.(date = as.Date(from))][year(date) %in% 2013:2015]

    fwrite(rbind(d.t0, d.t1, d.t2)[order(date)][!is.na(value)], historic.data.file)
    rm(d.historic, d.t0, d.t1, d.t2)
}


d.base = getGasConsumption('2021-12-30')

# - AGG/SAVE -------------------------------------------------------------------
d.agg = d.base[, .(
    value = sum(value)/10^9
), by=.(date = as.Date(from))][order(date)]


d.plot = copy(d.agg)

# Plot, Preparation
addRollMean(d.plot, 7)
addCum(d.plot)
d.plot = meltAndRemove(d.plot)
dates2PlotDates(d.plot)

# Save plot data
fwrite(d.plot, file.path(g$d$wd, 'gas', 'consumption-aggm.csv'))

# Save full for reg
d.historic = fread(historic.data.file)[, `:=`(date = as.Date(date))]
d.full = rbind(d.historic, d.agg[date > max(d.historic$date)])


file = file.path(g$d$o, 'consumption-gas-aggm.csv')
fwrite(d.full, file)
uploadGoogleDrive(file)
