# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/entsoe/_shared.r")
# loadPackages()


# - LOAD/PREP ------------------------------------------------------------------
d.base = loadEntsoeComb(
    # type = "generation", month.start = "2022-07", month.end = "2022-07", check.updates = FALSE
    type = "generation", month.start = month.start, month.end = month.end
)

# unique(d.base$ProductionType)

d.base.f = d.base[AreaTypeCode == "CTY"]
d.base.f[, factor := resToFactor[ResolutionCode]]
# d.base.f[, .(sum = sum(ActualGenerationOutput)), by=.(ProductionType)][order(sum)]
# unique(d.base.f[,. (ResolutionCode, AreaCode, AreaTypeCode, AreaName, MapCode)])


# - AGG -----------------------------------------------------------------------
d.agg = d.base.f[, .(
    value = sum(ActualGenerationOutput*factor)/10^6
), by = .(
    country = MapCode,
    date = as.Date(DateTime),
    source = ProductionType
)][order(date)]

# Delete last (most probably incomplete) obs
d.agg = removeLastDays(d.agg, 2)


# - STORE ----------------------------------------------------------------------
saveToStorages(d.agg, list(
    id = "electricity-generation",
    source = "entsoe",
    format = "csv"
))


nameOthers = "others"

# - GROUP 1
addGroupCol(d.agg, c.sourceGroups1, nameOthers = nameOthers)
# Agg
d.agg.group = d.agg[, .(value = sum(value)), by=.(date, source.group)]
# Store
saveToStorages(d.agg.group, list(
    id = "electricity-generation-g1",
    source = "entsoe",
    format = "csv"
))

# - GROUP 2
addGroupCol(d.agg, c.sourceGroups2, nameOthers = nameOthers)
# Agg
d.agg.group = d.agg[, .(value = sum(value)), by=.(date, source.group)]
# Store
saveToStorages(d.agg.group, list(
    id = "electricity-generation-g2",
    source = "entsoe",
    format = "csv"
))
