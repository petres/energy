# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')

d.storage = fread(file.path(g$d$wd, "gas", glue("storage-AT.csv"))) %>%
    filter(type == "stock")

d.storage.plot = rbind(d.storage, d.storage[, .(
    type = "flow-1",
    date,
    value = value - shift(value, 1),
    day,
    year,
    date20
)])

d.consumption = fread(file.path(g$d$wd, 'gas', 'consumption-aggm.csv')) %>%
    filter(variable == "value")

d.join = full_join(d.consumption, d.storage.plot, by = c("date" = "date")) %>%
    na.omit() %>%
    filter(type == "flow-1")  %>%
    mutate(gas_to_austria = value.x + value.y)

d.join %>%
    filter(day.x > 1) %>%
    group_by(year.x) %>%
    mutate(gas_to_austria = rollmean(gas_to_austria, 7, fill = NA)) %>%
    ggplot(aes(x = day.x, y = gas_to_austria)) +
    geom_line(aes(col = as.character(year.x))) +
    theme_bw()
