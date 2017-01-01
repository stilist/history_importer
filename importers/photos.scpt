function writeToFile(data) {
  const app = Application.currentApplication()
  app.includeStandardAdditions = true
  app.strictPropertyScope = true

  const dataRoot = Path(app.systemAttribute('HISTORY_DATA_PATH')).toString()
  const fullPath = `${dataRoot}/history/data/photos/metadata.json`
  const filePath = Path(fullPath).toString()

  try {
    const file = app.openForAccess(filePath, { writePermission: true })

    app.setEof(file, { to: 0 })
    app.write(JSON.stringify(data), { to: file, startingAt: 0 })

    app.closeAccess(file)

    return true
  } catch(errorWriteData) {
    console.log(`Couldn't write data: ${error}`)
    try {
      app.closeAccess(fullPath)
    } catch(errorCloseFile) {
      console.log(`Couldn't close file: ${error}`)
    }

    return false
  }
}

function getData() {
  const app = Application('Photos')
  app.includeStandardAdditions = true
  app.strictPropertyScope = true

  const items = app.mediaItems()
  const count = items.length
  Progress.description = 'Processing items'
  Progress.totalUnitCount = count

  const locations = items.map(function (item, index) {
    Progress.completedUnitCount = index + 1

    let [latitude, longitude] = item.location()
  	if (!latitude) return null

    return {
      altitude: item.altitude(),
      lat: latitude,
      lng: longitude,
      timestamp: item.date(),
    }
  }).filter((item) => item)

  return locations
}

writeToFile(getData())
