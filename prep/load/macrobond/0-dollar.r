# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# Title	Source	Frequency	Start date	Name
# ICE U.S. Dollar per Euro, 1st Position, Close	Intercontinental Exchange (ICE)	Daily	07.01.1986	eo_c1_cl

# - DOIT -----------------------------------------------------------------------
c.series = c(
    eo_c1_cl = "price"
)

d.plot = getPrepMacrobondData(c.series, 'price-dollar')

# Save
fwrite(d.plot, file.path(g$d$wd, 'others', 'data-dollar.csv'))

