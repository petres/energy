loadPackages(
    'googledrive'
)

saveToStorages = function(data, meta, storages = c("local", "googledrive")) {
    fileName = glue("{meta$id}.{meta$format}")
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

loadFromStorage = function(id, format = 'csv', storage = "googledrive") {
    # format = 'csv'
    # id = "temperature-hdd"
    fileName = glue("{id}.{format}")

    if (format == 'csv') {
        fileReadFunction = function(f) fread(f)
    } else {
        stop(glue("Format type '{format}' not implemented!"))
    }

    if (storage == "local") {
        file = file.path(g$d$storage, fileName)
        return(fileReadFunction(file))
    } else if (storage == "googledrive") {
        file = tempfile()
        drive_download(file.path(g$googledrive, fileName), file)
        return(fileReadFunction(file))
    } else {
        stop(glue("Storage type '{storage}' not implemented!"))
    }
}


uploadGoogleDrive = function(file, fileName) {
    drive_put(file, path = file.path(g$googledrive, fileName))
}

