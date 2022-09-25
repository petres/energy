# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
# Load
d.base = as.data.table(fread("https://www.e-control.at/documents/1785851/10140531/gas_dataset_h.csv", skip=11, dec=","))

# Filter, Aggregate
d.agg = d.base[, .(
    date = as.Date(Kategorie),
    value = Verwendungskomponenten
)][, .(value = sum(value)/10^6), by = date][order(date)]

# Save
fwrite(d.agg, file.path(g$d$o, 'consumption-gas.csv'))

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'consumption-gas', 'data.csv'))