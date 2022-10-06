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

    prepData(d.raw)
}
