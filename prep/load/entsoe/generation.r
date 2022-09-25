# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('load/entsoe/_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    #type = 'generation', month.start = "2022-01", month.end = "2022-01"
    type = 'generation', month.start = month.start, month.end = month.end
)

d.base[, .(sum = sum(ActualGenerationOutput)), by=.(ProductionType)][order(sum)]

# Filter, Aggregate
# unique(d.base$ProductionType)
d.agg = d.base[AreaName == "AT CTY" & ResolutionCode == "PT15M", .(
    value = sum(ActualGenerationOutput)/4/10^6
), by = .(date = {t = as.Date(DateTime); day(t) = 1; t}, source = ProductionType)][order(date)]

# Save
fwrite(d.agg, file.path(g$d$o, 'generation.csv'))

# Group
nameOthers = "others"
#d.agg[, .(sum = sum(generation)), by=.(source)][order(sum)]
d.base[, .(sum = sum(ActualGenerationOutput, na.rm = TRUE)), by=.(ProductionType)][order(sum)]

c.sourceGroups = list(
    "Hydro" = c("Hydro Run-of-river and poundage", "Hydro Water Reservoir", "Hydro Pumped Storage"),
    "Wind" = c("Wind Onshore", "Wind Offshore"),
    "Gas" = c("Fossil Gas"),
    "Solar" = c("Solar"),
    "Nuclear" = c("Nuclear"),
    "Coal" = c("Fossil Brown coal/Lignite", "Fossil Hard coal", "Fossil Coal-derived gas", "Fossil Peat"),
    "Oil" = c("Fossil Oil", "Fossil Oil shale"),
    "Waste" = c("Waste")
)

c.sourceGroups2 = list(
    "Renewable" = c(
        c.sourceGroups$Hydro, c.sourceGroups$Solar, c.sourceGroups$Wind,
        "Biomass", "Geothermal", "Other renewable", "Marine"
    ),
    "Nuclear" = c(c.sourceGroups$Nuclear),
    "Non-Renewable" = c(c.sourceGroups$Oil, c.sourceGroups$Coal, c.sourceGroups$Waste, c.sourceGroups$Gas)
)

setdiff(unique(d.base$ProductionType), unlist(c.sourceGroups))


c.sourceGroupsMap  = unlist(
    lapply(names(c.sourceGroups), function(gn) { ge = c.sourceGroups[[gn]]; t = rep(gn, length(ge)); names(t) = ge; t})
)

d.agg[, source.group := c.sourceGroupsMap[source]]
d.agg[is.na(source.group), source.group := nameOthers]
d.agg[, source := NULL]

d.agg.group = d.agg[, .(value = sum(value)), by=.(date, source.group)]


# Plot
c.order = d.agg.group[, .(value = sum(value)), by=source.group][order(-value)]$source.group
c.order = c(c.order[c.order != nameOthers], nameOthers)

d.agg.group[, source.group := factor(source.group, c.order, c.order)]
d.agg.group = d.agg.group[order(date, source.group)]

fwrite(d.agg.group, file.path(g$d$wd, 'generation', 'data.csv'))
