# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(
    readODS,
    tidyverse
)


# - LOAD -----------------------------------------------------------------------
url = "https://www.statistik.at/fileadmin/pages/189/PI2015_BDL.ods"
f = tempfile()
download.file(url, dest=f)
d.economic.activity = readODS::read_ods(f) %>%
    as_tibble(.name_repair = "unique")
unlink(f)


# - PREP -----------------------------------------------------------------------
names(d.economic.activity)[1] = "year"
names(d.economic.activity)[2] = "month"
names(d.economic.activity)[3] = "economic.activity"

d.final = d.economic.activity %>%
    slice_tail(n= -10) %>%
    fill(year) %>%
    mutate(month = as.numeric(as.roman(str_replace(month, "\\.", "")))) %>%
    mutate(year = as.numeric(year)) %>%
    mutate(value = as.numeric(economic.activity)) %>%
    dplyr::select(year, month, value) %>%
    na.omit()


# - STORAGE --------------------------------------------------------------------
saveToStorages(d.final, list(
    id = "economic-activity",
    source = "stat",
    format = "csv"
))
