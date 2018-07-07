function writeToFile(data) {
  const app = Application.currentApplication()
  app.includeStandardAdditions = true
  app.strictPropertyScope = true

  const dataRoot = Path(app.systemAttribute('HISTORY_DATA_PATH')).toString()
  const fullPath = `${dataRoot}/data/photos/metadata.json`
  const filePath = Path(fullPath).toString()

  try {
    const file = app.openForAccess(filePath, { writePermission: true })

    app.setEof(file, { to: 0 })
    app.write(JSON.stringify(data), { to: file, startingAt: 0 })

    app.closeAccess(file)

    return true
  } catch(errorWriteData) {
    console.log(`Couldn't write data: ${errorWriteData}`)
    try {
      app.closeAccess(fullPath)
    } catch(errorCloseFile) {
      console.log(`Couldn't close file: ${errorCloseFile}`)
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

    const startTime = new Date(item.date()).toISOString()

    return {
      altitude: item.altitude(),
      id: item.id(),
      lat: latitude,
      lng: longitude,
      name: item.name(),
      note: item.description(),
      startTime: startTime,
      // @note Ideally if `item` is a video this would be `startTime` + video
      //   duration, but the duration isn't exposed.
      endTime: startTime,
    }
  }).filter((item) => item)

  return locations
}

if (Application('Photos').running()) {
  writeToFile(getData())
}
