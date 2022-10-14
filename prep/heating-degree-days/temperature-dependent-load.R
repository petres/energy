# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')

d.base <- fread("data/output/heating-degree-days.csv")

d.hdd = d.base[, .(
    date = as.Date(time),
    value = `0`
)]

d.agg.aggm <- fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))

#####temperature correction with linear model#####
d.agg.aggm.variables <- d.agg.aggm[,.(
    date=as.Date(date),
    year=year(date),
    day=yday(date),
    wday=weekdays(date),
    value
),]

d.agg.aggm.variables <- d.agg.aggm.variables[d.hdd, on = "date"][,.(
    date,
    year=year(date),
    day=yday(date),
    wday=ifelse(weekdays(date)%in%c("Saturday","Sunday"),weekdays(date),"Working day"),
    sinc=sin(2*pi*day/365),
    cosc=cos(2*pi*day/365),
    value,
    hdd=i.value,
    hdd2=i.value^2,
    hdd_s_10=ifelse(i.value<10, i.value, 0),
    hdd_l_10=ifelse(i.value>=10, i.value, 0),
    week=as.character(week(date)),
    month=as.character(month(date))
),]

d.agg.aggm.variables <- d.agg.aggm.variables[,':='(hdd_l_10_2=hdd_l_10*hdd_l_10,
                                                   hdd_l_10_log=log(hdd_l_10+0.000001)),]

data_training <- d.agg.aggm.variables[year %in% (2019:(max(year)-1)), , ]
#data_training <- d.agg.aggm.variables[year %in% c(2019, 2021), , ]

data_prediction <- d.agg.aggm.variables

linear_model <- lm(value~wday+hdd_s_10+hdd_l_10+week, data=data_training)

summary(linear_model)

data_prediction$prediction <- predict(linear_model, data_prediction)

d.agg.aggm <- d.agg.aggm[,.(
    date=as.Date(date),
    value,
    type="Beobachtung"
),]

data_prediction <- data_prediction [,.(
    date,
    value=prediction,
    type="Nachfrage geschätzt mit Klima von 2022\n basierend auf Daten 2019-2021"
)]

d.all <- rbindlist(list(d.agg.aggm,
            data_prediction))

addRollMean(d.all, 7)
addCum(d.all)
d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
dates2PlotDates(d.plot)

#proposal for visualization
d.plot %>%
    filter(year==2022) %>%
    filter(variable=="rm7") %>%
    ggplot(aes(x=day, y=value)) +
    geom_line(aes(linetype=type)) +
    theme_bw()

