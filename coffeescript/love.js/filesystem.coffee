class FileSystem
  constructor: () ->

  append: () =>

  createDirectory: () =>

  exists: (filename) =>
    localStorage.getItem(filename) != null

  getAppdataDirectory: () =>

  getDirectoryItems: () =>

  getIdentity: () =>

  getLastModified: () =>

  getSaveDirectory: () =>

  getSize: () =>

  getUserDirectory: () =>

  getWorkingDirectory: () =>

  init: () =>

  isDirectory: () =>

  isFile: () =>

  isFused: () =>

  lines: () =>

  load: () =>

  mount: () =>

  newFile: () =>

  newFileData: () =>

  read: (filename) =>
    localStorage.getItem(filename)

  remove: (filename) =>
    localStorage.removeItem(filename)

  setIdentity: () =>

  setSource: () =>

  unmount: () =>

  write: (filename, data) =>
    localStorage.setItem(filename, data)
