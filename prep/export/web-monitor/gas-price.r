# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('export/web-monitor/_shared.r')


# - LOAD -----------------------------------------------------------------------
d.price = loadFromStorage(id = "price-gas")


# d.ext.raw = fread(file.path(g$d$tmp, 'AT_Day_Ahead_20221010.csv'))
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
# d.ext.raw = fread(file.path(g$d$tmp, 'AT_Within_Day_20221010.csv'))
# d.ext = d.ext.raw[, .(
#     # TradingDay,
#     date = as.Date(TradingDay, format="%d.%m.%Y"),
#     price = as.numeric(gsub(",", ".", Price)),
#     volume  = as.numeric(gsub(",", ".", AccVolume))
# )]
# d.ext = d.ext[, .(price = mean(price)), by=date]


d.plot = prepData(d.price)

# Save
fwrite(d.plot, file.path(g$d$wd, "gas", "price.csv"))
