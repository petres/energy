# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
# atelspotbase	    Daily	Austria, Electricity, AT, Day Base Price, EUR
# atelspotpeak	    Daily	Austria, Electricity, AT, Day Peak Price, EUR
# atelspotbasevol	Daily	Austria, Electricity, AT, Day Base Volume
# atelspotpeakvol	Daily	Austria, Electricity, AT, Day Peak Volume

c.series = c(
    atelspotbase = "base",
    atelspotpeak = "peak"
)

d.raw = getMacrobondData(names(c.series))
setnames(d.raw, names(c.series), c.series)

d.plot = melt(d.raw, id.vars = "date")
d.plot[, (paste0('rm', 7)) := rollmean(value, 7, fill = NA), by=variable]
d.plot = d.plot[date >= "2019-01-01" & !is.na(rm7)]
d.plot[, value := NULL]
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'price-electricity', 'data.csv'))

