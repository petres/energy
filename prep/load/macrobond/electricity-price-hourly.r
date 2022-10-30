# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/macrobond/_shared.r")
loadPackages(stringi)


# Title	Source	Frequency	Start date	Name
# Austria, AT, Hour 00-01, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot00
# Austria, AT, Hour 00-01	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot00vol
# Austria, AT, Hour 01-02, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot01
# Austria, AT, Hour 01-02	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot01vol
# Austria, AT, Hour 02-03, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot02
# Austria, AT, Hour 02-03	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot02vol
# Austria, AT, Hour 03-04, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot03
# Austria, AT, Hour 03-04	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot03vol
# Austria, AT, Hour 04-05, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot04
# Austria, AT, Hour 04-05	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot04vol
# Austria, AT, Hour 05-06, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot05
# Austria, AT, Hour 05-06	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot05vol
# Austria, AT, Hour 06-07, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot06
# Austria, AT, Hour 06-07	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot06vol
# Austria, AT, Hour 07-08, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot07
# Austria, AT, Hour 07-08	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot07vol
# Austria, AT, Hour 08-09, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot08
# Austria, AT, Hour 08-09	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot08vol
# Austria, AT, Hour 09-10, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot09
# Austria, AT, Hour 09-10	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot09vol
# Austria, AT, Hour 10-11, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot10
# Austria, AT, Hour 10-11	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot10vol
# Austria, AT, Hour 11-12, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot11
# Austria, AT, Hour 11-12	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot11vol
# Austria, AT, Hour 12-13, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot12
# Austria, AT, Hour 12-13	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot12vol
# Austria, AT, Hour 13-14, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot13
# Austria, AT, Hour 13-14	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot13vol
# Austria, AT, Hour 14-15, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot14
# Austria, AT, Hour 14-15	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot14vol
# Austria, AT, Hour 15-16, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot15
# Austria, AT, Hour 15-16	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot15vol
# Austria, AT, Hour 16-17, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot16
# Austria, AT, Hour 16-17	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot16vol
# Austria, AT, Hour 17-18, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot17
# Austria, AT, Hour 17-18	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot17vol
# Austria, AT, Hour 18-19, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot18
# Austria, AT, Hour 18-19	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot18vol
# Austria, AT, Hour 19-20, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot19
# Austria, AT, Hour 19-20	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot19vol
# Austria, AT, Hour 20-21, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot20
# Austria, AT, Hour 20-21	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot20vol
# Austria, AT, Hour 21-22, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot21
# Austria, AT, Hour 21-22	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot21vol
# Austria, AT, Hour 22-23, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot22
# Austria, AT, Hour 22-23	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot22vol
# Austria, AT, Hour 23-24, EUR	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot23
# Austria, AT, Hour 23-24	EEX (European Energy Exchange)	Daily	01.10.2018	atelspot23vol

# - DOIT -----------------------------------------------------------------------
d.vars = data.table(
    hour = 0:23
)
d.vars[, id := paste0("atelspot", stri_pad(0:23, width = 2, pad = "0"))]

d.raw = getMacrobondData(d.vars$id)
d = melt(d.raw, id.vars = "date")

d.m = merge(d, d.vars, by.x = "variable", by.y ="id")
if (FALSE) {
    fwrite(d.m[date >= "2019-01-01"][, .(date, hour, price = value)], file.path(g$d$o, "price-electricity-hourly.csv"))
}
d.m[, year := year(date)]

d.plot = d.m[year > 2018, .(
    value = mean(value)
), by=.(year, hour)][order(year, hour)]


# Save
fwrite(d.plot, file.path(g$d$wd, "electricity", "price-hourly.csv"))
