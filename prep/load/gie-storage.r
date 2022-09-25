# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(
    RCurl
)


# - DOIT -----------------------------------------------------------------------
# Load
loadGieData = function(date = Sys.Date(), page = 1) {
    l(glue('page: {page}'))
    url = glue("https://agsi.gie.eu/api?country=AT&from=2018-12-01&to={date}&size=300&page={page}")
    t = getURL(url, httpheader = c("x-key" = g$gie$params$key))
    t = sub('<a href="/historical/eu">EU</a> > AT', '', t, fixed = TRUE)
    fromJSON(t)
}

page = 1
d.base = data.table()
while(TRUE) {
    l.d = loadGieData(page = page)
    d.base = rbind(d.base, l.d$data)
    if (l.d$last_page == page)
        break;
    page = page + 1
}

d.base = as.data.table(d.base)

# Save
saveRDS(d.base, file.path(g$d$o, 'storage.rData'))

# Plot, Preparation
d.plot = d.base[, .(
    date = as.Date(gasDayStart),
    value = as.numeric(gasInStorage)
)][order(date)]
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'storage', 'data.csv'))
