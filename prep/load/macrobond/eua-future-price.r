# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------

# Title	Source	Frequency	Start date	Name
# EUA Future - Daily, 1st Position	NASDAQ OMX Commodities	Daily	10.10.2013	ned_c1_st

c.series = c(
    ned_c1_st = "value"
)

d.plot = getPrepMacrobondData(c.series)

# Save
fwrite(d.plot, file.path(g$d$wd, 'others', 'eua-future-price-daily.csv'))

