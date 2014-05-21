class ImageModule
  constructor: () ->

  isCompressed: =>
  newCompressedData: () =>
  newImageData: (filedata) =>
    new ImageData(filedata)
