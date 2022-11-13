loadBase = function(update) {
    base.file.name = file.path(g$d$tmp, 'prediction-gas-consumption-base.rData')

    if (!update & file.exists(base.file.name)) {
        return(readRDS(base.file.name))
    }

    # - LOAD -------------------------------------------------------------------
    # Temp & HDD
    d.hdd = loadFromStorage(id = "temperature-hdd")[, `:=`(
        date = as.Date(date)
    )]

    # Gas Consumption
    d.consumption = loadFromStorage(id = "consumption-gas-aggm")[, .(
        date = as.Date(date), value
    )]

    # Holidays
    d.holidays = loadFromStorage(id = "holidays")[, `:=`(
        date = as.Date(date)
        # holiday.name = ifelse(holiday.name == "", NA, holiday.name),
        # vacation.name = ifelse(vacation.name == "", NA, vacation.name)
    )]

    # - MERGE ------------------------------------------------------------------
    d.comb = merge(d.consumption, d.hdd, by = "date")
    d.comb = merge(d.comb, d.holidays, by = "date")

    # - AUGMENT ----------------------------------------------------------------
    d.comb[, `:=`(
        t = as.integer(date - min(date)),
        year = year(date),
        month = month(date),
        day = yday(date),
        week = str_pad(week(date), 2, pad = "0"),
        wday = factor(
            weekdays(date, abbreviate = TRUE),
            c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
        )
    )]
    d.comb[, `:=`(
        workday = ifelse(wday %in% c("Sat", "Sun"), as.character(wday), "Working day")
    )]

    saveRDS(d.comb, base.file.name)
    d.comb[]
}


### the economic indicator is published at monthly resolution, t + 45 days
### to be able to predict up to the current moment,
### I do a very dirty prediction of the economic indicator:
### it is economic activity of (t - 365 days) times
### the growth rate of the current year for the available time period
### compared to last year
growth.rate = function(d.economic.activity){

    maximum.month.last.year = as_tibble(d.economic.activity) %>%
        filter(year==max(year)) %>%
        filter(month==max(month)) %>%
        dplyr::select(month) %>%
        unlist()

    as_tibble(d.economic.activity) %>%
        filter(year >= max(year) -1) %>%
        filter(month <= maximum.month.last.year) %>%
        group_by(year) %>%
        summarize(economic.activity = sum(economic.activity)) %>%
        add_row(.[2,]/.[1,]) %>%
        slice_tail(n=1) %>%
        dplyr::select(economic.activity) %>%
        unlist()

}

