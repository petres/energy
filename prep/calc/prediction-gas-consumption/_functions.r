# load economic activity
library(readODS)

read.economic.activity = function(){
    url <- "https://www.statistik.at/fileadmin/pages/189/PI2015_BDL.ods"
    f <- tempfile()
    download.file(url, dest=f)
    d.economic.activity <- readODS::read_ods(f) %>%
        as_tibble(.name_repair = "unique")
    unlink(f)


    names(d.economic.activity)[1] = "year"
    names(d.economic.activity)[2] = "month"
    names(d.economic.activity)[3] = "economic.activity"

    d.economic.activity %>%
        slice_tail(n= -10) %>%
        fill(year) %>%
        mutate(month = as.numeric(as.roman(str_replace(month, "\\.", "")))) %>%
        mutate(year = as.numeric(year)) %>%
        mutate(economic.activity = as.numeric(economic.activity)) %>%
        dplyr::select(year, month, economic.activity) %>%
        na.omit()


}

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

