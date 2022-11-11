### the economic indicator is published at monthly resolution, t + 45 days
### to be able to predict up to the current moment,
### I do a very dirty prediction of the economic indicator:
### it is economic activity of (t - 365 days) times
### the growth rate of the current year for the available time period
### compared to last year
growth.rate = function(d.economic.activity){

    maximum.month.last.year = d.economic.activity %>%
        filter(year==max(year)) %>%
        filter(month==max(month)) %>%
        dplyr::select(month) %>%
        unlist()

    d.economic.activity %>%
        filter(year >= max(year) -1) %>%
        filter(month <= maximum.month.last.year) %>%
        group_by(year) %>%
        summarize(economic.activity = sum(economic.activity)) %>%
        add_row(.[2,]/.[1,]) %>%
        slice_tail(n=1) %>%
        dplyr::select(economic.activity) %>%
        unlist()

}

