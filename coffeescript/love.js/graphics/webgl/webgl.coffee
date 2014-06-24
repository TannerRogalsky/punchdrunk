class WebGL
  constructor: (@context) ->


  createDefaultTexture: ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = @context.createTexture()
    @context.bindTexture(@context.TEXTURE_2D, texture)
    @context.texImage2D(@context.TEXTURE_2D, 0, @context.RGBA, 1, 1, 0, @context.RGBA, @context.UNSIGNED_BYTE, data)
    @context.texParameteri(@context.TEXTURE_2D, @context.TEXTURE_MAG_FILTER, @context.NEAREST)
    @context.texParameteri(@context.TEXTURE_2D, @context.TEXTURE_MIN_FILTER, @context.NEAREST)
    return texture

  bindTexture: (texture) ->
    if texture != @activeTexture
      @context.bindTexture(@context.TEXTURE_2D, texture)
      @activeTexture = texture

  useProgram: (shader) ->
    @context.useProgram(shader.program)

  @getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context
