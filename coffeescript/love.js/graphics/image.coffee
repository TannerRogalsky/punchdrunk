class Image
  constructor: (data, context) ->
    if data instanceof ImageData
      @element = document.createElement("img")
      @element.setAttribute("src", data.getString(data))
    else
      @element = document.getElementById(data)

      if @element == null
        @element = document.createElement("img")
        @element.setAttribute("src", Love.root + "/" + data)
    if typeof(context.createTexture) == "function"
      gl = context
      @texture = gl.createTexture()
      gl.bindTexture(gl.TEXTURE_2D, @texture)

      # Set the parameters so we can render any size image.
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE)
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE)
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
      gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)

      # Upload the image into the texture.
      gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, @element)

  getData: (self) ->

  getDimensions: (self) ->
    [self.getWidth(self), self.getHeight(self)]

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
