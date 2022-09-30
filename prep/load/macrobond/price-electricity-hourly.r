# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
loadPackages(stringi)


# - DOIT -----------------------------------------------------------------------
d.vars = data.table(
    hour = 0:23
)
d.vars[, id := paste0('atelspot', stri_pad(0:23, width = 2, pad = "0"))]

d.raw = getMacrobondData(d.vars$id)
d = melt(d.raw, id.vars = "date")

d.m = merge(d, d.vars, by.x = "variable", by.y ="id")
d.m[, year := year(date)]

d.plot = d.m[year > 2018, .(
    value = mean(value)
), by=.(year, hour)][order(year, hour)]


# Save
fwrite(d.plot, file.path(g$d$wd, 'electricity', 'price-hourly.csv'))

