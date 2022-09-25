# - INIT -----------------------------------------------------------------------
source('_shared.r')
loadPackages(
    stenevang/sftp
)


month.start = "2018-12"
month.end = substring(Sys.Date(), 1, 7)

# - OTHE -----------------------------------------------------------------------
source("load/entsoe/_functions.R")

