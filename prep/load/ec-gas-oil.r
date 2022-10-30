# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')
loadPackages(
    openxlsx
)


# - DOWN -----------------------------------------------------------------------
url = "https://ec.europa.eu/energy/observatory/reports/Oil_Bulletin_Prices_History.xlsx"
t = tempfile(fileext = ".xlsx")
download.file(url, t, mode = "wb")


# - PREP -----------------------------------------------------------------------
d.raw = as.data.table(openxlsx::read.xlsx(t, sheet = "Prices with taxes, per CTR", startRow = 7))
d.raw = d.raw[-1]
d.raw = d.raw[1:(which(d.raw$Date == "BE") - 1)]

d.base = d.raw[, .(
    date = convertToDate(Date),
    euroSuper95 = as.numeric(sub(',', '', `Euro-super.95.(I)`))/1000,
    gasOil = as.numeric(sub(',', '', `Gas.oil.automobile.Automotive.gas.oil.Dieselkraftstoff.(I)`))/1000
)]

d.plot = melt(d.base, id.vars = "date")[order(date), ]
d.plot = d.plot[date > "2018-12-01"]

# Fill missing dates
d.plot = merge(
    d.plot,
    expand.grid(date = as.Date(min(d.plot$date):max(d.plot$date)), variable=unique(d.plot$variable)),
    by=c('date', 'variable'), all = TRUE
)

d.plot[, last := na.locf(value), by=variable]

d.plot = d.plot[date >= "2019-01-01"]
d.plot[, value := NULL]
dates2PlotDates(d.plot)
# d.plot[]


# - SAVE -----------------------------------------------------------------------
fwrite(d.plot, file.path(g$d$wd, 'others', 'data-gas-oil.csv'))


