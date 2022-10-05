# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/entsoe/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = 'generation', month.start = month.start, month.end = month.end,
    # type = 'generation', month.start = "2022-07", month.end = "2022-08", check.updates = FALSE
)

# Filter, Aggregate
d.agg = d.base[AreaName == "AT CTY" & ResolutionCode == "PT15M" & ProductionType == "Fossil Gas", .(
    value = sum(ActualGenerationOutput)/4/10^6
), by = .(date = as.Date(DateTime))][order(date)]

# Save
fwrite(d.agg, file.path(g$d$o, 'generation-gas.csv'))
# d.agg = loadData(file.path(g$d$o, 'generation-gas.csv'))

# Delete last (most probably incomplete) obs
d.agg = d.agg[1:(nrow(d.agg) - 2), ]

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'generation-gas', 'data.csv'))

