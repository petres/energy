# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/entsoe/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = 'generation', month.start = "2022-07", month.end = "2022-07"
    # type = 'generation', month.start = month.start, month.end = month.end
)

# d.base[, .(sum = sum(ActualGenerationOutput)), by=.(ProductionType)][order(sum)]

# Filter, Aggregate
# unique(d.base$ProductionType)
d.agg = d.base[AreaName == "AT CTY" & ResolutionCode == "PT15M", .(
    value = mean(ActualGenerationOutput)/4/10^3
), by = .(year = year(DateTime), hour = hour(DateTime), source = ProductionType)][order(year, hour)]

d.agg = d.agg[year >= 2022]

# Save
fwrite(d.agg, file.path(g$d$o, 'generation-hourly.csv'))
# d.agg = fread(file.path(g$d$o, 'generation.csv'))

# Group
nameOthers = "others"
addGroupCol(d.agg, c.sourceGroups1, nameOthers = nameOthers)
# Agg
d.agg.group = d.agg[, .(value = sum(value)), by=.(year, hour, source.group)]


# Plot
c.order = d.agg.group[, .(value = sum(value)), by=source.group][order(-value)]$source.group
c.order = c(c.order[c.order != nameOthers], nameOthers)

d.agg.group[, source.group := factor(source.group, c.order, c.order)]
d.agg.group = d.agg.group[order(year, hour, source.group)]

fwrite(d.agg.group, file.path(g$d$wd, 'generation', 'data-hourly.csv'))
