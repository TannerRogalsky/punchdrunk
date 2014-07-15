class Love.Graphics.Image
  constructor: (data, context) ->
    if data instanceof Love.ImageModule.ImageData
      @element = document.createElement("img")
      @element.setAttribute("src", data.getString(data))
      @name = data.name
    else
      filename = data
      @element = document.getElementById(filename)

      if @element == null
        @element = document.createElement("img")
        @element.setAttribute("src", Love.root + "/" + filename)

      @name = data

    if @element.complete
      @create_texture(context)
    else
      console.log "#{@name} can't be loaded synchronously. It will be loaded
        asynchronously but this may result in undefined behaviour."
      @element.onload = =>
        @create_texture(context)

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
  create_texture: (context) ->
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

      @coords = []
      @coords.push(0)
      @coords.push(0)
      @coords.push(0)
      @coords.push(@getHeight(@))
      @coords.push(@getWidth(@))
      @coords.push(@getHeight(@))
      @coords.push(@getWidth(@))
      @coords.push(0)

      @uvs = []
      @uvs.push(0)
      @uvs.push(0)
      @uvs.push(0)
      @uvs.push(1)
      @uvs.push(1)
      @uvs.push(1)
      @uvs.push(1)
      @uvs.push(0)
