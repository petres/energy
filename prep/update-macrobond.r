# - FILES ----------------------------------------------------------------------
path = "load/macrobond"
files = dput(grep("^[0-9a-z].*", list.files(path), value = TRUE))

# - RUN IT ---------------------------------------------------------------------
invisible(lapply(file.path(path, files), function(f) {
    cat(' - ', f, '\n'); source(f)
}))
