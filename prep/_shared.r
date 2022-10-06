# - INIT -----------------------------------------------------------------------
if (!'librarian' %in% rownames(installed.packages()))  install.packages("librarian")
loadPackages = librarian::shelf

loadPackages(
    'data.table', 'zoo', 'glue', 'lubridate', 'jsonlite', 'httr', 'xml2'
)

l = function (..., iL = 0, nL = TRUE)  {
    iS = paste(rep(" ", iL), collapse = "")
    m = paste0(iS, paste0(...))
    if (nL)
        m = paste0(m, "\n")
    cat(m)
}


# - GLOB -----------------------------------------------------------------------
g = list(
    d = list(
        entsoe = file.path("data", "entsoe"),
        o = file.path("data", "output"),
        wd = file.path("..", "web", "data")
    ),
    f = list(
        creds = "creds.json"
    ),
    entsoe = list(
        params = list(
            protocol = "sftp",
            server = "sftp-transparency.entsoe.eu/"
        ),
        fileTypes = list(
            generation = "AggregatedGenerationPerType_16.1.B_C",
            load = "ActualTotalLoad_6.1.A"
        )
    ), gie = list(
        params = list()
    ), aggm = list(
        params = list()
    )
)

g$entsoe$params = modifyList(g$entsoe$params, read_json(g$f$creds)$entsoe)
g$gie$params = modifyList(g$gie$params, read_json(g$f$creds)$gie)
g$aggm$params = modifyList(g$aggm$params, read_json(g$f$creds)$aggm)

# g$entsoe = modifyList(g$entsoe, list(
#     connString = glue("{g$entsoe$params$protocol}://{g$entsoe$params$server}"),
#     credString = glue("{g$entsoe$params$user}:{g$entsoe$params$pass}")
# ))



addRollMean = function(d, l, g = character(0)) {
    d[, (paste0('rm', l)) := rollmean(value, l, fill = NA, align = "right"), by=c(g)]
}

addCum = function(d) {
    d[, cum := cumsum(value), by=.(year(date))]
}

meltAndRemove = function(d) {
    melt(d, id.vars = "date")[!is.na(value)]
}

removeLastDays = function(d, days = 1) {
    d[date <= max(date) - days, ]
}

# PLOT DATA
# d.agg = loadData(file.path(g$d$o, 'consumption-gas.csv'))

dates2PlotDates = function(d) {
    c.date20 = copy(d$date)
    year(c.date20) = 2020

    d[, `:=`(
        day = yday(date),
        year = year(date),
        date20 = c.date20
    )]
}
