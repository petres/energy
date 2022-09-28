# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/entsoe/_shared.r')
# loadPackages()

# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = 'load', month.start = month.start, month.end = month.end
    # type = 'load', month.start = "2022-08", month.end = month.end, check.updates = FALSE
)

# sort(unique(d.base$AreaName))

# Filter, Aggregate
d.agg = d.base[AreaName == "AT CTY", .(
    value = sum(TotalLoadValue)/10^6/4
), by = .(date = as.Date(DateTime))][order(date)]

# Remove latest two days
d.agg = d.agg[1:(nrow(d.agg) - 2), ]

# d.base[MapCode == 'AT', .(load = sum(TotalLoadValue)) , by = .(AreaTypeCode, AreaName, MapCode)]


# Save
fwrite(d.agg, file.path(g$d$o, 'load.csv'))

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'load', 'data.csv'))

