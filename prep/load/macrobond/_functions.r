getMacrobondData = function (cols, frequency = NULL, startdate = NULL) {
    seriesRequest <- CreateUnifiedTimeSeriesRequest()
    for (i in seq_len(length(cols))) {
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


getPrepMacrobondData = function(c.series, name = NULL) {
    d.raw = getMacrobondData(names(c.series))
    setnames(d.raw, names(c.series), c.series)

    if (!is.null(name)) {
        fwrite(d.raw, file.path(g$d$o, glue("{name}.csv")))
    }

    prepData(d.raw)
}
