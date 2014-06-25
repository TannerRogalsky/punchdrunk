class WebGL
  constructor: (@gl) ->


  createDefaultTexture: ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = @gl.createTexture()
    @gl.bindTexture(@gl.TEXTURE_2D, texture)
    @gl.texImage2D(@gl.TEXTURE_2D, 0, @gl.RGBA, 1, 1, 0, @gl.RGBA, @gl.UNSIGNED_BYTE, data)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.NEAREST)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.NEAREST)
    return texture

  prepareDraw: ->
    @gl.uniformMatrix4fv(@transformMatrixLocation, false, new Float32Array(@transformMatrix.flatten()))
    @gl.uniformMatrix4fv(@projectionMatrixLocation, false, new Float32Array(@projectionMatrix.flatten()))
    @gl.uniformMatrix4fv(@transformProjectionMatrixLocation, false, new Float32Array(@transformProjectionMatrix.flatten()))

  bindTexture: (texture) ->
    if texture != @activeTexture
      @gl.bindTexture(@gl.TEXTURE_2D, texture)
      @activeTexture = texture

  useProgram: (shader) ->
    @gl.useProgram(shader.program)


  @getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context
