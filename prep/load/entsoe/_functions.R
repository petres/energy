loadEntsoeComb = function(
    type, check.updates = TRUE,
    month.start = "2022-01", month.end = "2022-08",
    data.folder = g$d$entsoe, iL = 1
) {
    months = ymd(seq(ym(month.start), ym(month.end), by = "month"))
    entsoe.name = g$entsoe$fileTypes[[type]]

    if (check.updates) {
        l(glue('CHECK AND DOWNLOAD IF NECESSARY'), iL=iL)

        entsoe.folder = glue("TP_export/{entsoe.name}")

        conn = sftp_connect(
            server = g$entsoe$params$server,
            folder = entsoe.folder,
            username = g$entsoe$params$user,
            pass = g$entsoe$params$pass,
        )

        d.files = as.data.table(sftp_listfiles(conn, verbose = FALSE))
        d.files = d.files[, .(
            name, check = paste(filesize, t1, t2, t3)
        )]

        toc.file = file.path(data.folder, glue("{type}-toc.csv"))
        d.toc = if (file.exists(toc.file)) fread(toc.file) else data.table(name = character(0), check = character(0))

        invisible(sapply(months, function(m) {
            month2.str = format.Date(ymd(m), "%m")
            year.str = year(m)

            l(glue('month {year.str}-{month2.str}'), iL=iL+1)

            entsoe.filename = glue("{year.str}_{month2.str}_{entsoe.name}.csv")

            d.files.sel = d.files[name == entsoe.filename]
            d.toc.sel   = d.toc[name == entsoe.filename]
            if (nrow(d.files.sel) == 1) {
                if (nrow(d.toc.sel) == 1 && d.files.sel$check == d.toc.sel$check) {
                    l(glue("- exists, no change"), iL=iL+2)
                } else {
                    l(glue("- downloading ..."), iL=iL+2)
                    sftp_download(entsoe.filename, tofolder = data.folder, conn, verbose = FALSE)
                    d.toc <<- rbind(
                        d.toc[name != entsoe.filename],
                        data.table(name = as.character(entsoe.filename), check = d.files.sel$check)
                    )
                }
            } else {
                l(glue('- not existing on server'), iL=iL+2)
            }
        }))
        fwrite(d.toc, toc.file)
    }

    l(glue('LOADING'), iL=iL)
    d.full = rbindlist(lapply(months, function(m) {
        month2.str = format.Date(m, "%m")
        year.str = year(m)

        l(glue('month {year.str}-{month2.str}'), iL=iL+1)

        entsoe.filename = glue("{year.str}_{month2.str}_{entsoe.name}.csv")
        fread(file.path(data.folder, entsoe.filename))
    }))

    d.full[, `:=`(
        DateTime = ymd_hms(DateTime)
    )]

    d.full[]
}
