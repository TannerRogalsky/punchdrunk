class WebGL
  constructor: (@context) ->


  @getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context

  @createShader = (gl, type, source) ->
    switch type
      when "fragment" then shader = gl.createShader(gl.FRAGMENT_SHADER)
      when "vertex" then shader = gl.createShader(gl.VERTEX_SHADER)
      else return null
    gl.shaderSource(shader, source)
    gl.compileShader(shader)

    # See if it compiled successfully
    if not gl.getShaderParameter(shader, gl.COMPILE_STATUS)
        console.log ("An error occurred compiling the shaders: " + gl.getShaderInfoLog(shader))
        return null
    else
      return shader

  @createProgram = (gl, vertex_shader, fragment_shader) ->
    program = gl.createProgram()
    gl.attachShader(program, vertex_shader)
    gl.attachShader(program, fragment_shader)
    gl.bindAttribLocation(program, 0, "VertexPosition")
    gl.bindAttribLocation(program, 1, "VertexTexCoord")
    gl.bindAttribLocation(program, 2, "VertexColor")
    gl.linkProgram(program)

    # Check the link status
    linked = gl.getProgramParameter(program, gl.LINK_STATUS)
    if not linked
        # something went wrong with the link
        lastError = gl.getProgramInfoLog (program)
        console.log("Error in program linking:" + lastError)

        gl.deleteProgram(program)
        return null
    return program

  @createDefaultTexture = (gl) ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = gl.createTexture()
    gl.bindTexture(gl.TEXTURE_2D, texture)
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, data)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
    return texture
