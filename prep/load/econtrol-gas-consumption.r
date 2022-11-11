# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
# Load
d.base = fread("https://www.e-control.at/documents/1785851/10140531/gas_dataset_h.csv", skip=11, dec=",")

# Filter, Aggregate
d.agg = d.base[, .(
    date = as.Date(Kategorie),
    value = Verwendungskomponenten
)][, .(value = sum(value)/10^6), by = date][order(date)]

# Latest day, i.e. the first day of the new month, contains only 5 h and is therefore wrong.
d.final = removeLastDays(d.agg)


# - STORAGE --------------------------------------------------------------------
saveToStorages(d.final, list(
    id = "consumption-gas-econtrol",
    source = "econtrol",
    format = "csv"
))


# - PLOT -----------------------------------------------------------------------
# Prepare
addRollMean(d.final, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot[date >= '2019-01-01'], file.path(g$d$wd, 'gas', 'consumption-econtrol.csv'))
