# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/entsoe/_shared.r")
# loadPackages()


# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    # type = "generation", month.start = "2022-07", month.end = "2022-07"
    type = "generation", month.start = month.start, month.end = month.end
)

d.base[, .(sum = sum(ActualGenerationOutput)), by=.(ProductionType)][order(sum)]

# Filter, Aggregate
# unique(d.base$ProductionType)
d.agg = d.base[AreaName == "AT CTY" & ResolutionCode == "PT15M", .(
    value = sum(ActualGenerationOutput)/4/10^6
), by = .(date = {t = as.Date(DateTime); day(t) = 1; t}, source = ProductionType)][order(date)]


# Group
nameOthers = "others"
addGroupCol(d.agg, c.sourceGroups1, nameOthers = nameOthers)
# Agg
d.agg.group = d.agg[, .(value = sum(value)), by=.(date, source.group)]


# Plot
c.order = d.agg.group[, .(value = sum(value)), by=source.group][order(-value)]$source.group
c.order = c(c.order[c.order != nameOthers], nameOthers)

d.agg.group[, source.group := factor(source.group, c.order, c.order)]
d.agg.group = d.agg.group[order(date, source.group)]

fwrite(d.agg.group, file.path(g$d$wd, "electricity", "generation.csv"))
