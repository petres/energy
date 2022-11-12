# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('calc/prediction-gas-consumption/_shared.r')


# - CONF -----------------------------------------------------------------------
update.data = FALSE


# - LOAD -----------------------------------------------------------------------
d.base = loadBase(update.data)
d.economic.activity = loadFromStorage(id = "economic-activity")


# AUGMENT
d.base[, `:=`(
    temp.15 = ifelse(temp < 15, 15 - temp, 0),
    temp.squared  = temp^2,
    temp.lag = shift(temp, 1),
    # AR TERMS, ONLY TESTING
    value.lag = shift(value, 1),
    value.lag2 = shift(value, 2)
)]

d.base[, `:=`(
    t.squared = t^2,
    temp.15.squared = temp.15^2,
    temp.15.lag = shift(temp.15, 1),
    year_character = as.character(year),
    # temp.f = cut(temp, quantile(temp, 0:20/20), all.inside = TRUE),
    temp.f = cut(temp, seq(min(temp), max(temp), length = 10), all.inside = TRUE)
)]

train.years = c(2013:2021)

d.train = d.base[year %in% train.years]
d.pred = copy(d.base)

m.linear = lm(
    value ~ t + t.squared +
        # value.lag + value.lag2 + # AR TERMS
        temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
        # temp * as.factor(temp.f) +
        wday + is.holiday + as.factor(vacation.name) + as.factor(month)
    , data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]

d.plot = melt(d.pred, id.vars = 'date', measure.vars = c('value', 'prediction'))[, `:=`(
    date = yday(date),
    year = as.factor(year(date))
)]

ggplot(d.plot[year == "2021"], aes(x = date, y = value)) +
    geom_line(aes(linetype = variable, group = paste(variable, year), color = year))




# - OUTPUT ---------------------------------------------------------------------
# d.all = melt(d.pred, variable.name = 'type',
#              id.vars = c('date'), measure.vars = c('value', 'prediction')
# )

# # PREP FOR PLOT
# addRollMean(d.all, 7, 'type')
# addCum(d.all, 'type')
# d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
# dates2PlotDates(d.plot)

# # SAVE
# fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))



d.month = d.pred[, .(
    value = mean(value),
    prediction = mean(prediction)
) , by = .(month, year)]

d.month[, diff := prediction - value]

# d.month = melt(d.month, variable.name = 'type',
#              id.vars = c('year', 'month'), measure.vars = c('value', 'prediction', 'diff')
# )


ggplot(d.month, aes(x = as.Date(glue("{year}-{month}-15")), y = diff)) + geom_line()

