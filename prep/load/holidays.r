# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')


# - CONF -----------------------------------------------------------------------
c.years = 2012:2022


# - DOWNLOAD -------------------------------------------------------------------
if (FALSE) {
    d.holidays = rbindlist(sapply(c.years, function(year) {
        fromJSON(glue("https://date.nager.at/api/v2/publicholidays/{year}/AT"))
    }, simplify = FALSE))
    fwrite(d.holidays, file.path(g$d$tmp, 'holidays-raw.csv'))
}
d.holidays = fread(file.path(g$d$tmp, 'holidays-raw.csv'))


# - PREPARE --------------------------------------------------------------------
d.holidays = d.holidays[, .(
    date = as.Date(date),
    holiday.name = name
)]


d.holidays = merge(d.holidays, data.table(
    date = as.Date(as.Date(glue("{min(c.years)}-01-01")):as.Date(glue("{max(c.years)}-12-31")))
), all.y = TRUE, by = 'date')


d.holidays[, `:=`(
    is.holiday = !is.na(holiday.name),
    week = week(date),
    month = month(date),
    year = year(date),
    yday = yday(date)
)]


d.holidays[, vacation.name := c(NA, 'christmasNewYear')[1 + (yday > yday(glue("{year}-12-24")))], by = year]
d.holidays[yday <= 6, vacation.name := 'newYearEpiphany']


d.holidays[month == 7, vacation.name := 'july']
d.holidays[month == 8, vacation.name := 'august']

d.holidays[, week.eastern := week[is.holiday & holiday.name == "Easter Monday"], by=year]

d.holidays[week == week.eastern - 1, vacation.name := 'holy']
d.holidays[week == week.eastern, vacation.name := 'eastern']


# - CLEAN/SAVE -----------------------------------------------------------------
d.holidays[, `:=`(
    week.eastern = NULL,
    is.vacation = !is.na(vacation.name),
    week = NULL,
    month = NULL,
    year = NULL,
    yday = NULL
)]

# - STORAGE --------------------------------------------------------------------
saveToStorages(d.holidays, list(
    id = "holidays",
    source = "nager",
    format = "csv"
))
