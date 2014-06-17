class WebGL
  constructor: (@context) ->

  createShader: (type, source) ->
    switch type
      when "fragment" then shader = @context.createShader(@context.FRAGMENT_SHADER)
      when "vertex" then shader = @context.createShader(@context.VERTEX_SHADER)
      else return null
    @context.shaderSource(shader, source)
    @context.compileShader(shader)

    # See if it compiled successfully
    if not @context.getShaderParameter(shader, @context.COMPILE_STATUS)
        console.log ("An error occurred compiling the shaders: " + @context.getShaderInfoLog(shader))
        return null
    else
      return shader

  createProgram: (vertex_shader, fragment_shader) ->
    program = @context.createProgram()
    @context.attachShader(program, vertex_shader)
    @context.attachShader(program, fragment_shader)
    @context.bindAttribLocation(program, 0, "VertexPosition")
    @context.bindAttribLocation(program, 1, "VertexTexCoord")
    @context.bindAttribLocation(program, 2, "VertexColor")
    @context.linkProgram(program)

    # Check the link status
    linked = @context.getProgramParameter(program, @context.LINK_STATUS)
    if not linked
        # something went wrong with the link
        lastError = @context.getProgramInfoLog (program)
        console.log("Error in program linking:" + lastError)

        @context.deleteProgram(program)
        return null
    return program

  createDefaultTexture: ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = @context.createTexture()
    @context.bindTexture(@context.TEXTURE_2D, texture)
    @context.texImage2D(@context.TEXTURE_2D, 0, @context.RGBA, 1, 1, 0, @context.RGBA, @context.UNSIGNED_BYTE, data)
    @context.texParameteri(@context.TEXTURE_2D, @context.TEXTURE_MAG_FILTER, @context.NEAREST)
    @context.texParameteri(@context.TEXTURE_2D, @context.TEXTURE_MIN_FILTER, @context.NEAREST)
    return texture


  @getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context
