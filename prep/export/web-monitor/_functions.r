addRollMean = function(d, l, g = character(0)) {
    d[, (paste0('rm', l)) := rollmean(value, l, fill = NA, align = "right"), by=c(g)]
}

addCum = function(d, g = character(0)) {
    d[, year := year(date)]
    d[, cum := cumsum(value), by=c("year", g)]
    d[, year := NULL]
}

meltAndRemove = function(d) {
    melt(d, id.vars = "date")[!is.na(value)][date >= "2019-01-01"]
}

removeLastDays = function(d, days = 1) {
    d[date <= max(date) - days, ]
}

dates2PlotDates = function(d) {
    c.date20 = copy(d$date)
    year(c.date20) = 2020

    d[, `:=`(
        # day = yday(date),
        year = year(date),
        date20 = c.date20
    )]
}


prepData = function(d.raw) {
    d.plot = melt(d.raw, id.vars = "date")[order(date), ]
    d.plot = d.plot[date > "2018-12-01"]

    # Fill missing dates
    d.plot = merge(
        d.plot,
        expand.grid(date = as.Date(min(d.plot$date):max(d.plot$date)), variable=unique(d.plot$variable)),
        by=c('date', 'variable'), all = TRUE
    )

    l = 7
    d.plot[, (paste0('rm', l)) := rollmean(value, l, fill = NA, align = "right", na.rm = TRUE), by=variable]

    d.plot = d.plot[date >= "2019-01-01" & !is.na(rm7)]
    d.plot[, value := NULL]
    dates2PlotDates(d.plot)
    d.plot[]
}
