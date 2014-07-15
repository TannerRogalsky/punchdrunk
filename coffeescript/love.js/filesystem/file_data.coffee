class Love.FileSystem.FileData
  constructor: (@contents, @name, decoder) ->
    @extension = @name.match("\\.(.*)")[1]

  getPointer: (self) ->
  getSize: (self) ->
  getString: (self) ->
    self.contents

  getExtension: (self) ->
    self.extension

  getFilename: (self) ->
    self.name
