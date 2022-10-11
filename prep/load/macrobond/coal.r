# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/macrobond/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------

# Title	Source	Frequency	Start date	Name
# 1st Position, Close, USD	Intercontinental Exchange (ICE)	Daily	18.08.2006	atw_c1_cl



c.series = c(
    atw_c1_cl = "price"
)

d.plot = getPrepMacrobondData(c.series, 'price-coal')

# Save
fwrite(d.plot, file.path(g$d$wd, 'others', 'data-coal.csv'))

