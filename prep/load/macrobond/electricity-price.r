# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------

# Austria, AT, Day Base Price, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspotbase
# Austria, AT, Day Base Volume	EEX (European Energy Exchange)	Daily	01.10.2018	atelspotbasevol
# Austria, AT, Day Peak Price, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspotpeak
# Austria, AT, Day Peak Volume	EEX (European Energy Exchange)	Daily	01.10.2018	atelspotpeakvol


c.series = c(
    atelspotbase = "base",
    atelspotpeak = "peak"
)

d.plot = getPrepMacrobondData(c.series, 'price-electricity')

# Save
fwrite(d.plot, file.path(g$d$wd, 'electricity', 'price-daily.csv'))

