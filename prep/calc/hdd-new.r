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

d.final = d.comb[, .(
    temp = sum(temp*pop),
    hdd = sum(hdd*pop)
), by=.(date = time)]


# - SAVE -----------------------------------------------------------------------
fwrite(d.final, file.path(g$d$o, 'temp-hdd.csv'))
