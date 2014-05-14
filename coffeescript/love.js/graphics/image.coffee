class Image
  constructor: (path) ->
    @element = document.createElement("img")
    @element.setAttribute("src", path)

  getData: (self) ->

  getDimensions: (self) ->
    [self.element.width, self.element.height]

  getFilter: (self) ->

  getHeight: (self) ->
    self.element.height

  getMipmapFilter: (self) ->

  getWidth: (self) ->
    self.element.width

  getWrap: (self) ->

  isCompressed: (self) ->

  refresh: (self) ->

  setFilter: (self) ->

  setMipmapFilter: (self) ->

  setWrap: (self) ->

  # PRIVATE
