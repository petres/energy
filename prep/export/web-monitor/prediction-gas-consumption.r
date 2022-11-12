# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('export/web-monitor/_shared.r')


# - LOAD/PREP ------------------------------------------------------------------
#
# d.all = melt(d.pred, variable.name = 'type',
#              id.vars = c('date'), measure.vars = c('value', 'prediction')
# )


#
#
# # PREP FOR PLOT
# addRollMean(d.all, 7, 'type')
# addCum(d.all, 'type')
# d.plot <- melt(d.all, id.vars = c("date", "type"))[!is.na(value)]
# dates2PlotDates(d.plot)
#
# # SAVE
# fwrite(d.plot[date >= "2019-01-01"], file.path(g$d$wd, 'pred-gas-cons.csv'))
