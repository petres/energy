# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')

d.base <- fread("data/output/heating-degree-days.csv")

d.hdd = d.base[, .(
    date = as.Date(time),
    value = `0`
)]

addRollMean(d.hdd, 28)
addCum(d.hdd)

d.plot = meltAndRemove(d.hdd)
dates2PlotDates(d.plot)

fwrite(d.plot, file.path(g$d$wd, 'heating-degree-days', 'hdd.csv'))

# d.plot = fread(file.path(g$d$wd, 'heating-degree-days', 'hdd.csv'))
# d.hdd = d.plot[variable == 'value', .(date, value)]


####test using ggplot
# loadPackages(tidyverse)
# d.plot %>%
#    filter(year>2018) %>%
#    ggplot(aes(x=day, y=value)) +
#    geom_line(aes(col=as.character(year))) +
#    facet_wrap(.~variable,scale="free")
#
#
