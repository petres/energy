# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('export/web-monitor/_shared.r')

mean.length = 28

# - LOAD/PREP ------------------------------------------------------------------
d.base = loadFromStorage(id = "temperature-hdd")

d.plot = d.base[, .(
    date = as.Date(date),
    value = temp
)]

addRollMean(d.plot, mean.length)

d.plot[, year := ifelse(year(date) %in% 1950:2018, 'avg50-18', year(date)), by=date]

d.plot = d.plot[, .(value = mean(get(glue("rm{mean.length}")), na.rm = TRUE)), by=.(
    year, date20 = {t = copy(date); year(t) = 2020; t}
)]

fwrite(d.plot[order(year, date20)], file.path(g$d$wd, 'others', 'temperature.csv'))

