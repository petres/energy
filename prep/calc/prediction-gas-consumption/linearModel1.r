# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('calc/prediction-gas-consumption/_shared.r')


# - CONF -----------------------------------------------------------------------
update.data = FALSE


# - LOAD -----------------------------------------------------------------------
d.base = loadBase(update.data)

# AUGMENT
d.base[, `:=`(
    t.squared = t^2,
    temp.15 = ifelse(temp < 15, 15 - temp, 0),
    temp.squared  = temp^2,
    temp.lag = shift(temp, 1)
)]

d.base[, `:=`(
    temp.15.squared = temp.15^2,
    temp.15.lag = shift(temp.15, 1)
)]


# - MODEL ----------------------------------------------------------------------
d.train = d.base[year %in% (min(year):(max(year) - 1)), ]
d.pred = copy(d.base)

m.linear = lm(
    value ~ t + t.squared +
        temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
        wday + week
, data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]


# - PLOT -----------------------------------------------------------------------
d.month = d.pred[, .(
    value = mean(value),
    prediction = mean(prediction)
) , by = .(month, year)]

d.month[, diff := prediction - value]

# d.month = melt(d.month, variable.name = 'type',
#              id.vars = c('year', 'month'), measure.vars = c('value', 'prediction', 'diff')
# )

ggplot(d.month, aes(x = as.Date(glue("{year}-{month}-15")), y = diff)) + geom_line()

