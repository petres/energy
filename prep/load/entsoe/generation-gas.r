# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/entsoe/_shared.r")
# loadPackages()


# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = "generation", month.start = month.start, month.end = month.end,
    # type = "generation", month.start = "2022-07", month.end = "2022-08", check.updates = FALSE
)

# Filter, Aggregate
d.agg = d.base[AreaName == "AT CTY" & ResolutionCode == "PT15M" & ProductionType == "Fossil Gas", .(
    value = sum(ActualGenerationOutput)/4/10^6
), by = .(date = as.Date(DateTime))][order(date)]

# Delete last (most probably incomplete) obs
d.agg = removeLastDays(d.agg, 2)

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, "electricity", "generation-gas.csv"))

