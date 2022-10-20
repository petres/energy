# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/aggm/_shared.r')


# - CONF -----------------------------------------------------------------------
historic.data.file = file.path(g$d$o, 'consumption-gas-aggm-historic.csv')
if (!file.exists(historic.data.file)) {
    d.historic = getGasConsumption('2015-12-30', '2019-01-02')
    d.t1 = d.historic[, .(
        value = sum(value)/10^9
    ), by=.(date = as.Date(from))][year(date) %in% 2016:2018]

    d.historic = getGasConsumption('2012-12-30', '2016-01-02')
    d.t2 = d.historic[, .(
        value = sum(value)/10^9
    ), by=.(date = as.Date(from))][year(date) %in% 2013:2015]

    fwrite(rbind(d.t1, d.t2)[order(date)][!is.na(value)], historic.data.file)
    rm(d.historic, d.t1, d.t2)
}
# fwrite(d.agg, file.path(g$d$o, 'consumption-gas-aggm-12.csv'))
# d.agg = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, `:=`(
#     date = as.Date(date)
# )]


d.base = getGasConsumption('2018-12-15')

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
fwrite(d.plot, file.path(g$d$wd, 'gas/consumption', 'data-aggm.csv'))

# Save full for reg
d.historic = fread(historic.data.file)[, `:=`(date = as.Date(date))]
d.full = rbind(d.historic, d.agg[date >= '2019-01-01'])
fwrite(d.full, file.path(g$d$o, 'consumption-gas-aggm.csv'))
