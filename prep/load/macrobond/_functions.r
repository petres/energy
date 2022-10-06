getMacrobondData = function (cols, frequency = NULL, startdate = NULL) {
    seriesRequest <- CreateUnifiedTimeSeriesRequest()
    for (i in 1:length(cols)) {
        if (!is.null(frequency)) {
            setFrequency(seriesRequest, frequency[1])
        }
        if (!is.null(startdate)) {
            setStartDate(seriesRequest, startdate)
        }
        reqExp <- addSeries(seriesRequest, cols[i])
        if (!is.null(frequency)) {
            setToLowerFrequencyMethod(reqExp, frequency[2])
        }
    }
    series = FetchTimeSeries(seriesRequest)
    data = as.data.table(MakeXtsFromUnifiedResponse(series))
    setnames(data, c("index"), c("date"))
    data
}

getPrepMacrobondData = function(c.series) {
    d.raw = getMacrobondData(names(c.series))
    setnames(d.raw, names(c.series), c.series)

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
