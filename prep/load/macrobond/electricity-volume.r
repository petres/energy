# # - INIT -----------------------------------------------------------------------
# rm(list = ls())
# source("load/macrobond/_shared.r")
# # loadPackages()
#
#
# # - DOIT -----------------------------------------------------------------------
# c.series = c(
#     atelspotbasevol = "base",
#     atelspotpeakvol = "peak"
# )
#
# d.plot = getPrepMacrobondData(c.series)
#
# # Save
# fwrite(d.plot, file.path(g$d$wd, "electricity", "volume.csv"))
#
