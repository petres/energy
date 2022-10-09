# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(jsonlite)


# - DOIT -----------------------------------------------------------------------
# Load
l.base = read_json(file.path(g$d$o, 'gas-price.json'))
sapply(l.base, `[[`, 'name')

date = sapply(l.base[[4]]$data, `[[`, 1)
price = sapply(l.base[[4]]$data, `[[`, 2)
price[sapply(price, is.null)] = list(0)

d.raw = data.table(date = as.Date(as_datetime(date/1000)), price = unlist(price))
# fwrite(d.raw[date >= "2019-01-01"], file.path('data', 'gas-price.csv'))

d.plot = prepData(d.raw)

# Save
fwrite(d.plot, file.path(g$d$wd, 'gas', 'data-price.csv'))
