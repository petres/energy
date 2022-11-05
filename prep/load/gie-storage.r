# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("_shared.r")
loadPackages(
    RCurl
)


# - DOIT -----------------------------------------------------------------------
# Load
loadGieData = function(date = Sys.Date(), page = 1, country = "AT") {
    l(glue("page: {page}"))
    url = glue("https://agsi.gie.eu/api?country={country}&from=2018-12-01&to={date}&size=300&page={page}")
    if(country == "EU"){
        url = glue("https://agsi.gie.eu/api?type={country}&from=2018-12-01&to={date}&size=300&page={page}")
    }
    t = getURL(url, httpheader = c("x-key" = g$gie$params$key))
    # NO VALID JSON, HOW THEY ARE ABLE TO PRODUCE SOMETHING LIKE THAT
    t = sub("<a href=\"/data-overview/eu\">EU</a> > AT", "", t, fixed = TRUE)
    fromJSON(t)
}

loadGieDataAllPages = function(date = Sys.Date(), country = "AT"){

    page = 1
    d.base = data.table()
    while(TRUE) {
        l.d = loadGieData(date, page = page, country)
        d.base = rbind(d.base, l.d$data)
        if (l.d$last_page == page)
            break;
        page = page + 1
    }

    d.base = as.data.table(d.base)

    return(d.base)

}

d.base = loadGieDataAllPages()
d.base = rbind(d.base, loadGieDataAllPages(country = "EU"))

d.base %>%
    ggplot(aes(x=))

# Save
saveRDS(d.base.at, file.path(g$d$o, "storage.at.rData"))

# Plot, Preparation
d.plot = d.base[, .(
    date = as.Date(gasDayStart),
    value = as.numeric(gasInStorage),
    country = name
)][order(date)]
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, "gas", "storage.csv"))
