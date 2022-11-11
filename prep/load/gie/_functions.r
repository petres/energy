loadGieSingle = function(country, startDate, endDate, page = 1) {
    apiUrl = "https://agsi.gie.eu/api"
    # l(glue("page: {page}"))
    url = glue("{apiUrl}?country={country}&from={startDate}&to={endDate}&size=300&page={page}")
    if(country == "EU"){
        url = glue("{apiUrl}?type={country}&from={startDate}&to={endDate}&size=300&page={page}")
    }
    t = getURL(url, httpheader = c("x-key" = g$gie$params$key))
    # NO VALID JSON, HOW THEY ARE ABLE TO PRODUCE SOMETHING LIKE THAT
    t = sub("<a href=\"/data-overview/eu\">EU</a> > AT", "", t, fixed = TRUE)
    fromJSON(t)
}

loadGieFull = function(country, startDate = "2018-12-01", endDate = Sys.Date()) {
    page = 1
    d.base = data.table()
    while(TRUE) {
        l.d = loadGieSingle(country = country, startDate = startDate, endDate = endDate, page = page)
        d.base = rbind(d.base, l.d$data)
        if (l.d$last_page == page)
            break;
        page = page + 1
    }
    d = as.data.table(d.base)
    d[, info := NULL]
    d
}
