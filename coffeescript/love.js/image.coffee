class Love.ImageModule
  constructor: () ->

  isCompressed: =>
  newCompressedData: () =>
  newImageData: (filedata) =>
    new Love.ImageModule.ImageData(filedata)
