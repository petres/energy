# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/entsoe/_shared.r')
loadPackages(ggplot2)

# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = 'load', month.start = month.start, month.end = month.end
    # type = 'load', month.start = "2022-08", month.end = month.end, check.updates = FALSE
)

# unique(d.base[AreaName == "AT CTY", .(
#     ResolutionCode,
#     AreaCode,
#     AreaTypeCode,
#     AreaName,
#     MapCode
# )])

d = d.base[AreaName == "AT CTY", .(
    dateTime = DateTime, load = TotalLoadValue
)]

rm(d.base)

# Filter, Aggregate
d.agg = d[, .(
    value = mean(load)/10^3/4
), by = .(year = year(dateTime), hour = hour(dateTime))][year > 2018][order(year, hour)]

ggplot(d.agg, aes(y = value, group = year, x = hour, color = year)) +
    geom_line()

# Save
fwrite(d.agg, file.path(g$d$wd, 'electricity/load', 'data-hourly.csv'))

