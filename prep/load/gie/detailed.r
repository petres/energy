# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/gie/_shared.r")


# - DOIT -----------------------------------------------------------------------
countries = c("AT", "EU")

for (country in countries) {
    # Load
    d.base = loadGieFull(country = country)

    # Plot, Preparation
    d.plot = d.base[, .(
        type = "stock",
        date = as.Date(gasDayStart),
        value = as.numeric(gasInStorage)

    )][order(date)]

    d.plot = rbind(d.plot, d.plot[, .(
        type = "flow",
        date,
        value = value - shift(value, 7)
    )])

    dates2PlotDates(d.plot)

    # Save
    fwrite(d.plot, file.path(g$d$wd, "gas", glue("storage-{country}.csv")))
}
