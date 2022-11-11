# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/entsoe/_shared.r")
# loadPackages()

# - DOIT -----------------------------------------------------------------------
d.base = loadEntsoeComb(
    type = "load", month.start = month.start, month.end = month.end
    # type = "load", month.start = "2019-12", month.end = month.end, check.updates = TRUE
)


# d.t = unique(d.base[, .(ResolutionCode, AreaCode, AreaTypeCode, AreaName, MapCode)])
# d.t = unique(d.base[AreaTypeCode == "CTY", .(ResolutionCode, AreaCode, AreaName, MapCode)])


d.base.f = d.base[AreaTypeCode == "CTY"]

# sort(unique(d.base.f$ResolutionCode))


d.base.f[, factor := resToFactor[ResolutionCode]]
d.base.f[, value := factor*TotalLoadValue]

# Filter, Aggregate
d.agg = d.base.f[, .(
    value = sum(value)/10^3
), by = .(country = MapCode, date = as.Date(DateTime))][order(date)]

# Delete last (most probably incomplete) obs
d.agg = removeLastDays(d.agg, 2)

# - STORAGE --------------------------------------------------------------------
saveToStorages(d.agg, list(
    id = "electricity-load",
    source = "entsoe",
    format = "csv"
))

# Plot, Preparation

prep = function(di, l = 7, g = character(0)) {
    d = copy(di)

    d[, (paste0("rm", l)) := rollmean(value, l, fill = NA, align = "right"), by=c(g)]

    d[, year := year(date)]
    d[, cum := cumsum(value), by=c("year", g)]
    d[, year := NULL]

    d = melt(d, id.vars = c(g, "date"))[!is.na(value)][date >= "2019-01-01"]

    c.date20 = copy(d$date)
    year(c.date20) = 2020

    d[, `:=`(
        day = yday(date),
        year = year(date),
        date20 = c.date20
    )]

    d[]
}

d.plot = prep(d.agg, l = 7, g = "country")
d.plot = d.plot[variable %in% c("rm7")]
# d.plot = d.plot[country %in% c("AT", "DE", "PT", "FR") & date >= "2022-01-01"]
# d.plot = d.plot[as.integer(date - min(date)) %% 5 == 0]


# Save
fwrite(d.plot, file.path(g$d$wd, "electricity", "load-international.csv"))



# loadPackages(countrycode, jsonlite)
#
# d.countries = data.table(iso2 = unique(d.plot$country), selected = FALSE)
# d.countries[, name := countrycode(iso2, "iso2c", "country.name.de")]
# d.countries[iso2 == "XK", name := "Kosovo"]
#
# d.countries = d.countries[order(name)]
#
# d.countries[iso2 %in% c("AT", "DE", "IT", "FR", "CH", "HU"), selected := TRUE]
#
# j = toJSON(sapply(as.character(d.countries$iso2), function(c) list(
#     name = d.countries[iso2 == c]$name,
#     visible = d.countries[iso2 == c]$selected
# ), simplify = FALSE), auto_unbox = TRUE, pretty = 4)

# writeLines(j, "clipboard")

# d.plot[, country := factor(country, levels = d.countries[order(name)]$iso2)]
# d.plot = d.plot[order(country, date)]




