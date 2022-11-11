# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/gie/_shared.r")
loadPackages(
    countrycode
)


c.euCountries = as.data.table(codelist)[eu28 == "EU", iso2c]

colnames()


# - DOIT -----------------------------------------------------------------------
# Load


d.base = loadGieDataAllPages()
d.base = rbind(d.base, loadGieDataAllPages(country = "EU"))



# Plot, Preparation
d.plot = d.base[, .(
    date = as.Date(gasDayStart),
    value = as.numeric(gasInStorage),
    country = name
)][order(date)]
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, "gas", "storage.csv"))
