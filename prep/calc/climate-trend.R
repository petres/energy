# - INIT -----------------------------------------------------------------------
rm(list = ls())
source('_shared.r')

d.temp.raw = fread(file.path(g$d$era5, "temp.csv")) %>%
    spread(expver, t2m) %>%
    mutate(value = `1`) %>%
    mutate(value = ifelse(is.na(value), `5`, value))

months = tibble(number = c(1:12),
                name = c("Jänner", "Februar", "März", "April", "Mai", "Juni", "Juli",
                         "August", "September", "Oktober", "November", "Dezember"))

d.temp.raw.monthly = d.temp.raw %>%
    group_by(year=year(time), month=month(time)) %>%
    summarize(time = min(time),
        value = mean(value)) %>%
    full_join(months, by = c("month" = "number")) %>%
    mutate(name = factor(name, levels=months$name))


d.temp.raw.annual = d.temp.raw %>%
    group_by(year=year(time)) %>%
    summarize(time = min(time),
              value = mean(value))

d.temp.raw.monthly %>%
    group_by(month) %>%
    mutate(last_date = ifelse(time == max(time), "Letztes Monat", "Nicht letztes Monat")) %>%
    ungroup() %>%
    ggplot(aes(x = time, y = value)) +
    geom_point(aes(col = last_date)) +
    geom_smooth(method = "lm") +
    scale_color_manual(values = c("red", "black")) +
    facet_wrap(.~reorder(name, name), scale="free") +
    theme_bw() +
    xlab("Jahr") +
    ylab("Monatliche Durchschnittstemperatur (°C)") +
    theme(legend.position = "none")

d.temp.raw.annual %>%
    filter(time < max(time)) %>%
    mutate(last_date = ifelse(time == max(time), "Letztes Jahr", "Nicht letztes Jahr")) %>%
    ggplot(aes(x = time, y = value)) +
    geom_point(aes(col = last_date)) +
    geom_smooth(method = "lm") +
    scale_color_manual(values = c("red", "black")) +
    theme(legend.position = "none")
