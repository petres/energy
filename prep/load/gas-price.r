# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
# loadPackages()


# - DOIT -----------------------------------------------------------------------
# Load
l.base = read_json(file.path(g$d$o, 'gas-price.json'))
sapply(l.base, `[[`, 'name')

date = sapply(l.base[[4]]$data, `[[`, 1)
price = sapply(l.base[[4]]$data, `[[`, 2)
price[sapply(price, is.null)] = list(0)

d.raw = data.table(date = as.Date(as_datetime(date/1000)), price = unlist(price))


# d.ext.raw = fread(file.path(g$d$o, 'AT_Day_Ahead_20221010.csv'))
# d.ext = d.ext.raw[, .(
#     # TradingDay,
#     date = as.Date(TradingDay, format="%d.%m.%Y"),
#     price.close = as.numeric(gsub(",", ".", ClosePrice)),
#     price.open  = as.numeric(gsub(",", ".", OpenPrice))
# )]
# # d.ext = d.ext[, .(price = mean(price)), by=date]
#
# merge(d.raw, d.ext, by='date')
# d.ext.raw
# # fwrite(d.raw[date >= "2019-01-01"], file.path('data', 'gas-price.csv'))
#
#
#
# d.ext.raw = fread(file.path(g$d$o, 'AT_Within_Day_20221010.csv'))
# d.ext = d.ext.raw[, .(
#     # TradingDay,
#     date = as.Date(TradingDay, format="%d.%m.%Y"),
#     price = as.numeric(gsub(",", ".", Price)),
#     volume  = as.numeric(gsub(",", ".", AccVolume))
# )]
# d.ext = d.ext[, .(price = mean(price)), by=date]


d.plot = prepData(d.raw)

# Save
fwrite(d.plot, file.path(g$d$wd, 'gas', 'data-price.csv'))
fwrite(d.raw, file.path(g$d$o, 'price-gas.csv'))
