# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/entsoe/_shared.r")
# loadPackages()

# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = "load", month.start = month.start, month.end = month.end
    # type = "load", month.start = "2022-02", month.end = "2022-06", check.updates = FALSE
)

# Filter, Aggregate
d.agg = d.base[AreaName == "AT CTY", .(
    value = sum(TotalLoadValue)/10^6/4
), by = .(date = as.Date(DateTime))][order(date)]

# Delete last (most probably incomplete) obs
d.agg = removeLastDays(d.agg, 2)

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, "electricity", "load.csv"))

