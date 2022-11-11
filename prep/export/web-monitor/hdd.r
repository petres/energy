# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('export/web-monitor/_shared.r')


# - LOAD/PREP ------------------------------------------------------------------
d.base = loadFromStorage(id = "temperature-hdd")

d.plot = d.base[, .(
    date = as.Date(date), value = hdd
)]

addRollMean(d.plot, 28)
addCum(d.plot)

d.plot = meltAndRemove(d.plot)
dates2PlotDates(d.plot)

fwrite(d.plot, file.path(g$d$wd, "others", "hdd.csv"))
