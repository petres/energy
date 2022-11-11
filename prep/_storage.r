loadPackages(
    'googledrive'
)

saveToStorages = function(data, meta, storages = c("local", "googledrive")) {
    fileName = glue("{meta$id}-{meta$source}.{meta$format}")
    if (meta$format == 'csv') {
        fileWriteFunction = function(d, f) fwrite(d, f)
    } else {
        stop(glue("Format type '{meta$format}' not implemented!"))
    }
    for (storage in storages) {
        l(glue("Storage '{storage}':"))
        if (storage == "local") {
            filePath = file.path(g$d$storage, fileName)
            l(glue("-> '{filePath}'"), iL = 2)
            fileWriteFunction(data, filePath)
        } else if (storage == "googledrive") {
            fileTemp = tempfile()
            fileWriteFunction(data, fileTemp)
            l(glue("-> '{fileName}'"), iL = 2)
            uploadGoogleDrive(fileTemp, fileName)
        } else {
            stop(glue("Storage type '{storage}' not implemented!"))
        }
    }
}

# loadFromStorages = function(types, id) {
#
# }


uploadGoogleDrive = function(file, fileName) {
    drive_put(file, path = file.path(g$googledrive, fileName))
}

