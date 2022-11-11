# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/aggm/_shared.r')

historic.file.name = file.path(g$d$tmp, 'consumption-gas-aggm-historic.csv')

agg = function(d) d[, .(
    value = sum(value)/10^9
), by=.(date = as.Date(from))]


# - LOAD -----------------------------------------------------------------------
if (!file.exists(historic.file.name)) {
    # Split data range (else would be slow or not work)
    d.historic = getGasConsumption('2018-12-30', '2022-01-02')
    d.t0 = agg(historic)[year(date) %in% 2019:2021]

    d.historic = getGasConsumption('2015-12-30', '2019-01-02')
    d.t1 = agg(historic)[year(date) %in% 2016:2018]

    d.historic = getGasConsumption('2012-12-30', '2016-01-02')
    d.t2 = agg(historic)[year(date) %in% 2013:2015]

    fwrite(rbind(d.t0, d.t1, d.t2)[order(date)][!is.na(value)], historic.file.name)

    rm(d.historic, d.t0, d.t1, d.t2)
}

d.historic = fread(historic.file.name)[, date := as.Date(date)]
d.base = agg(getGasConsumption(startDate = '2021-12-30'))[order(date)]

# Combine
d.full = rbind(d.historic, d.base[date > max(d.historic$date)])


# - STORAGE --------------------------------------------------------------------
saveToStorages(d.full, list(
    id = "consumption-gas-aggm",
    source = "aggm",
    format = "csv"
))


# - PLOT -----------------------------------------------------------------------
d.plot = copy(d.full)

# Plot, Preparation
addRollMean(d.plot, 7)
addCum(d.plot)
d.plot = meltAndRemove(d.plot)
dates2PlotDates(d.plot)

# Save plot data
fwrite(d.plot, file.path(g$d$wd, 'gas', 'consumption-aggm.csv'))

