# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("_shared.r")
# loadPackages()


# - DOIT -----------------------------------------------------------------------
# Load
l.base = read_json(file.path(g$d$tmp, "gas-price.json"))
sapply(l.base, `[[`, "name")

date = sapply(l.base[[4]]$data, `[[`, 1)
price = sapply(l.base[[4]]$data, `[[`, 2)
price[sapply(price, is.null)] = list(0)

d.raw = data.table(date = as.Date(as_datetime(date/1000)), price = unlist(price))


# - STORE ----------------------------------------------------------------------
saveToStorages(d.raw, list(
    id = "price-gas",
    source = "cismo",
    format = "csv"
))
