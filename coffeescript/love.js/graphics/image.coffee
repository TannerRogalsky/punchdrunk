class Love.Graphics.Image
  constructor: (data) ->
    if data instanceof ImageData
      @element = document.createElement("img")
      @element.setAttribute("src", data.getString(data))
    else
      filename = data
      @element = document.getElementById(filename)

      if @element == null
        @element = document.createElement("img")
        @element.setAttribute("src", Love.root + "/" + filename)

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
