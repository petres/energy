getGasConsumption = function(startDate, endDate = Sys.Date()) {
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

    data.table(from = as.POSIXct(from), value = as.numeric(value))
}
