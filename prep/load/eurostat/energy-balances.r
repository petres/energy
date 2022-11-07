# - INIT -----------------------------------------------------------------------
rm(list = ls())
source("load/eurostat/_shared.r")

# d.toc = as.data.table(get_eurostat_toc())
# View(d.toc[grepl('energy', title)])


# - DOIT -----------------------------------------------------------------------
d.bal = as.data.table(get_eurostat('nrg_bal_c'))
d.bal.f = d.bal[geo == "AT" & time > "2010-01-01" & unit == "GWH"]
d.bal.f[, `:=`(
    geo = NULL,
    unit = NULL
)]

c.dims = c('nrg_bal', 'siec') #, 'unit')
invisible(sapply(c.dims, function(d) {
    d.t = as.data.table(get_eurostat_dic(d))
    c.t = setNames(d.t$full_name, d.t$code_name)
    d.bal.f[, (paste0(d, '.name')) := c.t[get(d)]]
}))
setcolorder(d.bal.f, unlist(lapply(c.dims, function(v) c(v, paste0(v, '.name')))))

View(unique(d.bal.f[, .(nrg_bal, nrg_bal.name)]))

saveData(d.)

