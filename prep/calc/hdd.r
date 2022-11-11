# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')


# - CONF -----------------------------------------------------------------------
v.raumtemp = 20
v.heiztremp = 12


# - LOAD/PREPARE ---------------------------------------------------------------
d.pop.raw = fread(file.path(g$d$era5, "pop.csv"))
d.pop = d.pop.raw[!is.na(value), .(
    latitude, longitude, pop = value
)]

d.temp.raw = fread(file.path(g$d$era5, "temp.csv"))
d.temp = d.temp.raw[!is.na(t2m)]

# CHECK expver, REMOVE expver
# d.temp[, diff := length(unique(t2m)) > 1, by=.(time, latitude, longitude)]
d.temp = d.temp[, .(temp = t2m[1]),  by=.(time, latitude, longitude)]


# - HDD ------------------------------------------------------------------------
d.temp[, hdd := ifelse(temp <= 12, v.raumtemp - temp, 0)]


# - MERGE/AGG ------------------------------------------------------------------
d.comb = merge(d.temp, d.pop, by=c("latitude", "longitude"))
# d.comb[, sum(pop), by=.(time)]

d.austria = d.comb[, .(
    temp = sum(temp*pop),
    hdd = sum(hdd*pop)
), by=.(date = time)]

d.vienna = d.comb[latitude == 48.25 & longitude == 16.25, .(
    date = time, temp.vienna = temp, hdd.vienna = temp
)]

d.final = merge(d.austria, d.vienna, by = 'date')


# - SAVE -----------------------------------------------------------------------
saveToStorages(d.final, list(
    id = "temperature-hdd",
    source = "era5",
    format = "csv"
))
