# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------

# Title	Source	Frequency	Start date	Name
# Crude Oil, Future, ICE Brent Crude, 1st Position, Close, USD	Intercontinental Exchange (ICE)	Daily	23.06.1988	b_c1_cl


c.series = c(
    b_c1_cl = "price"
)

d.plot = getPrepMacrobondData(c.series)

# Save
fwrite(d.plot, file.path(g$d$wd, 'others', 'data-brent.csv'))

