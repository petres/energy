# - FILES ----------------------------------------------------------------------
files = c(
    "brent-price.r", "eua-future-price.r",
    "price-electricity-hourly.r", "price-electricity.r",
    "volume-electricity.r"
)

# - RUN IT ---------------------------------------------------------------------
invisible(lapply(file.path('load/macrobond', files), function(f) {
    l(' - ', f); source(f)
}))
