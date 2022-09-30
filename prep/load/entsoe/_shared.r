# - INIT -----------------------------------------------------------------------
source('_shared.r')
loadPackages(
    stenevang/sftp
)

month.start = "2018-12"
month.end = substring(Sys.Date(), 1, 7)


c.sourceGroups1 = list(
    "Hydro"   = c("Hydro Run-of-river and poundage", "Hydro Water Reservoir", "Hydro Pumped Storage"),
    "Wind"    = c("Wind Onshore", "Wind Offshore"),
    "Gas"     = c("Fossil Gas"),
    "Solar"   = c("Solar"),
    "Nuclear" = c("Nuclear"),
    "Coal"    = c("Fossil Brown coal/Lignite", "Fossil Hard coal", "Fossil Coal-derived gas", "Fossil Peat"),
    "Oil"     = c("Fossil Oil", "Fossil Oil shale"),
    "Waste"   = c("Waste")
)

c.sourceGroups2 = list(
    "Renewable" = c(
        c.sourceGroups1$Hydro, c.sourceGroups1$Solar, c.sourceGroups1$Wind,
        "Biomass", "Geothermal", "Other renewable", "Marine"
    ),
    "Nuclear" = c(c.sourceGroups1$Nuclear),
    "Non-Renewable" = c(c.sourceGroups1$Oil, c.sourceGroups1$Coal, c.sourceGroups1$Waste, c.sourceGroups1$Gas)
)

addGroupCol = function(d, mapping, sourceCol = "source", groupCol = "source.group", nameOthers = 'others') {
    c.sourceGroupsMap  = unlist(
        lapply(names(mapping), function(gn) { ge = mapping[[gn]]; t = rep(gn, length(ge)); names(t) = ge; t})
    )

    d[, (groupCol) := c.sourceGroupsMap[get(sourceCol)]]
    d[is.na(source.group), (groupCol) := nameOthers]
    d
}


# - OTHE -----------------------------------------------------------------------
source("load/entsoe/_functions.R")

