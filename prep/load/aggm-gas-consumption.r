# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')

headers = c(
    "Content-Type" = "text/xml",
    "Accept" = "text/xml"
)

requests = list(
    authenticate = "
        <request>
            <metadata>
                <action>authenticate</action>
            </metadata>
            <payload>
                <username>{g$aggm$params$user}</username>
                <password>{g$aggm$params$pass}</password>
            </payload>
        </request>
    ",
    timeseries = "
        <request>
            <metadata>
                <action>publicInterface</action>
                <accessToken>{token}</accessToken>
            </metadata>
            <payload>
                <timeseriesData>
                    <from>{startDate}T00:00:00Z</from>
                    <to>{endDate}T00:00:00Z</to>
                    <timeseries>
                        <name>ErmittelterEKVOst</name>
                        <name>ErmittelterEKVTirol</name>
                        <name>ErmittelterEKVVorarlberg</name>
                    </timeseries>
                </timeseriesData>
            </payload>
        </request>
    "
)


# - CONF -----------------------------------------------------------------------
startDate = '2018-12-15'
# endDate = '2014-12-31'
endDate = Sys.Date()

# - DOIT -----------------------------------------------------------------------
return_token = POST(
    "https://agimos.aggm.at/datenmanagementApi/Authenticate",
    body = glue(requests$authenticate),
    add_headers(headers)
)

token = xml_text(xml_children(xml_children(content(return_token))))[2]

return_timeseries = POST(
    "https://agimos.aggm.at/datenmanagementApi/PublicInterface",
    body = glue(requests$timeseries),
    add_headers(headers)
)

xml_timeseries = content(return_timeseries)

from = xml_text(
    xml_find_all(xml_timeseries, "/response/payload/timeseriesData/timeseries/dataSet/data/from")
)
value = xml_text(
    xml_find_all(xml_timeseries, "/response/payload/timeseriesData/timeseries/dataSet/data/value")
)

d.base = data.table(from = as.POSIXct(from), value = as.numeric(value))


# - AGG/SAVE -------------------------------------------------------------------
d.agg = d.base[, .(
    value = sum(value)/10^9
), by=.(date = as.Date(from))][order(date)]

#### comparison of two data sources, uses tidyverse
#d.agg[d.agg, on = .(date)] %>%
#    gather(source, value, -date) %>%
#    ggplot(aes(x=date, y=value))+
#    geom_line(aes(col=source))

range(d.agg$date)

# Save
# fwrite(d.agg, file.path(g$d$o, 'consumption-gas-aggm-12.csv'))
# d.agg = fread(file.path(g$d$o, 'consumption-gas-aggm.csv'))[, `:=`(
#     date = as.Date(date)
# )]

# Plot, Preparation
addRollMean(d.agg, 7)
addCum(d.agg)
d.plot = meltAndRemove(d.agg)
dates2PlotDates(d.plot)

# Save
fwrite(d.plot, file.path(g$d$wd, 'gas/consumption', 'data-aggm.csv'))
