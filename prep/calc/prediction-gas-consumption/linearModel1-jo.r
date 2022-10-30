# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(stringr, tidyverse)


# - DATA -----------------------------------------------------------------------
d.hdd = fread(file.path(g$d$o, 'temp-hdd.csv'))[, `:=`(
    date = as.Date(date)
)]

# LOAD/PREP GAS CONS
d.consumption = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, .(
    date = as.Date(date),
    value = value
)]

# MERGE
d.comb = merge(d.consumption, d.hdd, by = "date")

# AUGMENT
d.comb[, `:=`(
    t = as.integer(date - min(date)),
    year = year(date),
    day = yday(date),
    week = week(date),
    wday = factor(
        weekdays(date, abbreviate = TRUE),
        c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
    ),
    temp.15 = ifelse(temp < 15, 15 - temp, 0),
    temp.squared  = temp^2,
    temp.lag = shift(temp, 1)
)]

d.comb[, `:=`(
    t.squared = t^2,
    workday = ifelse(wday %in% c("Sat", "Sun"), wday, "Working day"),
    week = str_pad(week, 2, pad = "0"),
    temp.15.squared = temp.15^2,
    temp.15.lag = shift(temp.15, 1),
    year_character = as.character(year)
)]

max.day <- d.comb %>%
    filter(year==2022) %>%
    summarize(max.day=max(day)) %>%
    unlist()

cut_off_year <- 2015

d.presentation <- d.comb %>%
    filter(day<=max.day) %>%
    mutate(month=month(date)) %>%
    dplyr::select(year, month, value, hdd) %>%
    filter(year > cut_off_year)

nmb_years <- d.comb %>%
    filter(year > cut_off_year) %>%
    dplyr::select(year) %>%
    unique() %>%
    unlist() %>%
    length() - 1

d.presentation.mean.year <- d.presentation %>%
    filter(year!=2022) %>%
    summarize(value.sum.mean=sum(value)/nmb_years,
              hdd.sum.mean=sum(hdd)/nmb_years)

d.presentation.mean.month <- d.presentation %>%
    filter(year!=2022) %>%
    group_by(month) %>%
    summarize(value.sum.mean=sum(value)/nmb_years,
              hdd.sum.mean=sum(hdd)/nmb_years)

d.presentation %>%
    filter(year>2017) %>%
    group_by(year) %>%
    summarize(value.sum=sum(value),hdd.sum=sum(hdd)) %>%
    bind_cols(d.presentation.mean.year) %>%
    mutate(value.sum.rel=100*value.sum/value.sum.mean-100) %>%
    mutate(hdd.sum.rel=100*hdd.sum/hdd.sum.mean-100) %>%
    dplyr::select(year,value.sum.rel,hdd.sum.rel) %>%
    gather(variable,value,-year) %>%
    mutate(variable=ifelse(variable=="hdd.sum.rel","Heizgradtage","Gasverbrauch")) %>%
    ggplot(aes(x=year, y=value)) +
    geom_bar(stat="identity") +
    facet_wrap(.~variable, scale="free") +
    theme_bw(base_size=16) +
    xlab("Jahr") +
    ylab("Relative Veränderung \nzum Durchschnitt 2016-2021 \n(%)")

d.presentation %>%
    filter(year %in% c(2019, 2022)) %>%
    group_by(year,month) %>%
    summarize(value.sum=sum(value),hdd.sum=sum(hdd)) %>%
    full_join(d.presentation.mean.month,by=c("month"="month")) %>%
    mutate(value.sum.rel=100*value.sum/value.sum.mean-100) %>%
    mutate(hdd.sum.rel=100*hdd.sum/hdd.sum.mean-100) %>%
    dplyr::select(year,month,value.sum.rel,hdd.sum.rel) %>%
    gather(variable,value,-year,-month) %>%
    mutate(variable=ifelse(variable=="hdd.sum.rel","Heizgradtage","Gasverbrauch")) %>%
    mutate(Jahr=as.character(year)) %>%
    mutate(month=as.numeric(month)) %>%
    ggplot(aes(x=month, y=value)) +
    geom_line(aes(col=Jahr),size=1) +
    # scale_color_manual(values=rev(COLORS5)) +
    facet_grid(variable~.,scale="free") +
    theme_bw(base_size=16) +
    xlab("Monat") +
    ylab("Relative Veränderung zum Durchschnitt 2018-2021") +
    scale_x_continuous(breaks=c(1:10))

d.comb %>%
    filter(year>2018) %>%
    mutate(Temperaturkategorie=ifelse(temp<15,"<15°C",">15°C")) %>%
    ggplot(aes(x=temp, y=value)) +
    geom_point(aes(col=Temperaturkategorie),alpha=0.1) +
    geom_smooth(method="lm",aes(col=Temperaturkategorie)) +
    # scale_color_manual(values=COLORS5) +
    xlab("Bevölkerungsgewichtete durchschnittstemperatur in Österreich (°C)") +
    ylab("Täglicher Gasverbrauch (TWh)") +
    theme_bw() +
    facet_wrap(.~year)



#add holidays (feiertage) and holidays (ferien)
holidays = list()
for(year in 2014:2022){
    url = glue("https://date.nager.at/api/v2/publicholidays/{year}/AT")
    holidays = append(holidays,
        list(fromJSON(url))
    )
}

holidays = bind_rows(holidays) %>%
    mutate(date=ymd(date)) %>%
    dplyr::select(date) %>%
    mutate(is.holiday = 1)

d.comb = d.comb %>%
    left_join(holidays,by = c("date"="date")) %>%
    mutate(is.holiday = ifelse(is.na(is.holiday), 0, 1)) %>%
    mutate(is.holiday = as.character(is.holiday)) %>%
    mutate(is.christmas.holidays = ifelse(week == 1|week == 52,1, 0)) %>%
    mutate(is.holidays.july = ifelse(month(date) == 7, 1, 0)) %>%
    mutate(is.holidays.august = ifelse(month(date) == 8, 1, 0))

###does average load & temperature dependency change over time?
coefs <- list()
for(year_c in c(2014:2022)){
    coefs = append(coefs, list(summary(lm(value~temp, dat=d.comb %>% filter(year==year_c)))$coefficients %>% as_tibble() %>% mutate(year=year_c) %>% mutate(type=c("intercept", "slope"))))
}

bind_rows(coefs) %>%
    dplyr::select(year, Estimate, type) %>%
    ggplot(aes(x=year, y=Estimate)) +
    geom_bar(aes(fill=type), stat="identity", position="dodge") +
    facet_wrap(.~type, scale="free")

####I'd say, 2016:2021 look similar, 2019 being an exception for some reason
####2014:2015 have a lower intercept and a higher slope, I would perhaps exclude them therefore - and maybe also 2019?


years = c(2016:2020)
train_and_test_model <- function(years){

    # - MODEL ----------------------------------------------------------------------
    #d.train = d.comb[year %in% (min.year:(max(year) - 1)), ]
    d.train = d.comb[year %in% years, ]
    d.pred = copy(d.comb)

    m.linear = lm(
        value ~ t + t.squared +
            temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
            wday + is.holiday + is.christmas.holidays + is.holidays.july + is.holidays.august
        , data = d.train)

    summary(m.linear)

    d.pred[, prediction := predict(m.linear, d.pred)]

    p <-d.pred %>%
        filter(year==2022) %>%
        filter(month(date)>8) %>%
        ggplot(aes(x=prediction, y=value)) +
        geom_point(alpha=0.5, size=0.5) +
        geom_smooth(method="lm", size=1, col="red") +
        facet_wrap(.~year) +
        ylab("Tatsächlicher Verbrauch") +
        xlab("Vorhergesagter Verbrauch") +
        theme_bw()

    plot(p)

    rmse <- function(observed, predicted){
        sqrt(mean((observed - predicted)^2))
    }

    d.pred %>%
        group_by(year) %>%
        summarize(r2 = cor(value, prediction)^2,
                  mean_bias = mean(value) - mean(prediction),
                  rmse = rmse(value, prediction)) %>%
        print()

    p <- d.pred %>%
        filter(year==2022) %>%
        dplyr::select(year, day, value, prediction) %>%
        gather(variable, value, -year, -day) %>%
        mutate(value = rollmean(value, 14, na.pad = TRUE, "left")) %>%
        mutate(variable = ifelse(variable=="prediction", "Simulation", "Beobachtung")) %>%
        ggplot(aes(x=day, y=value)) +
        geom_line(aes(col=variable)) +
        facet_wrap(.~year) +
        theme_bw()+
        # scale_color_manual(values=COLORS3) +
        xlab("Tag") +
        ylab("Verbrauch (TWh)")


    plot(p)



    p <- d.pred %>%
        filter(year==2022) %>%
        dplyr::select(year, day, value, prediction) %>%
        mutate(Einsparung=100*(value-prediction)/prediction) %>%
        mutate(Einsparung = rollmean(Einsparung, 14, na.pad = TRUE, "left")) %>%
        ggplot(aes(x=day, y=Einsparung)) +
        geom_line() +
        facet_wrap(.~year) +
        theme_bw()+
        # scale_color_manual(values=COLORS3) +
        xlab("Tag") +
        ylab("Relative Einsparung (%)")


    plot(p)


    mean.value <- d.train %>%
        group_by(day) %>%
        summarize(`Durchschnitt 2016-2021`=mean(value)) %>%
        filter(day<=max.day) %>%
        dplyr::select(`Durchschnitt 2016-2021`)


    d.pred %>%
        filter(year==2022) %>%
        bind_cols(mean.value) %>%
        dplyr::select(day, value, Simulation=prediction, `Durchschnitt 2016-2021`) %>%
        gather(variable, value_sim, -day, -value) %>%
        mutate(Einsparung=100*(value-value_sim)/value_sim) %>%
        mutate(Einsparung = rollmean(Einsparung, 14, na.pad = TRUE, "left")) %>%
        ggplot(aes(x=day, y=Einsparung)) +
        geom_line(aes(col=variable)) +
        theme_bw()+
        # scale_color_manual(values=COLORS3) +
        xlab("Tag") +
        ylab("Relative Einsparung (%)")


    plot(p)

    d.pred %>%
        filter(year==2022) %>%
        bind_cols(mean.value) %>%
        dplyr::select(day, value, Simulation=prediction, `Durchschnitt 2016-2021`) %>%
        gather(variable, value_sim, -day, -value) %>%
        group_by(variable) %>%
        summarize(sim=sum(value_sim),value=sum(value),Einsparung=100*(value-sim)/sim) %>%
        ggplot(aes(x=variable,y=Einsparung)) +
        geom_bar(stat="identity") +
        theme_bw() +
        xlab("Variable") +
        ylab("Relative Einsparung 2022 vs. Periode 2016-2021 (%)")




}

years = c(2016:2018, 2019:2021)

train_and_test_model(years)

years = (min(d.comb$year):(max(d.comb$year) - 1))

train_and_test_model(years)



# - MODEL ----------------------------------------------------------------------
#d.train = d.comb[year %in% (min.year:(max(year) - 1)), ]
d.train = d.comb[year %in% years, ]
d.pred = copy(d.comb)

m.linear = lm(
    value ~ t + t.squared +
        temp + temp.squared + temp.15 + temp.15.squared + temp.15.lag +
        wday + is.holiday + is.christmas.holidays + is.holidays.july + is.holidays.august
    , data = d.train)

summary(m.linear)

d.pred[, prediction := predict(m.linear, d.pred)]

d.pred %>% ggplot(aes(x=value, y=prediction)) +
    geom_point(alpha=0.5, size=0.5) +
    geom_smooth(method="lm", size=1, col="red") +
    facet_wrap(.~year)

rmse <- function(observed, predicted){
    sqrt(mean((observed - predicted)^2))
}

d.pred %>%
    group_by(year) %>%
    summarize(r2 = cor(value, prediction)^2,
              mean_bias = mean(value) - mean(prediction),
              rmse = rmse(value, prediction))

d.pred %>%
    dplyr::select(year, day, value, prediction) %>%
    gather(variable, value, -year, -day) %>%
    mutate(value = rollmean(value, 14, na.pad = TRUE, "left")) %>%
    ggplot(aes(x=day, y=value)) +
    geom_line(aes(col=variable)) +
    facet_wrap(.~year)



# - OUTPUT ---------------------------------------------------------------------
d.all = melt(d.pred, variable.name = 'type',
             id.vars = c('date'), measure.vars = c('value', 'prediction')
)

# PREP FOR PLOT
addRollMean(d.all, 7, 'type')
addCum(d.all, 'type')
d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
dates2PlotDates(d.plot)

# SAVE
fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))
