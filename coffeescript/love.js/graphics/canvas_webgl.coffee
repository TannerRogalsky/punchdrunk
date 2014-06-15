class CanvasWebGL
  constructor: (width, height, @element) ->
    @element ?= document.createElement('canvas')
    if (canvas_width = Number(@element.getAttribute('width'))) != 0
      width = canvas_width
    if (canvas_height = Number(@element.getAttribute('height'))) != 0
      height = canvas_height
    @setDimensions(width, height)
    @context = getGLContext(@element)

    @defaultVertexShader = createShader(@context, "vertex", DEFAULT_VERTEX_SOURCE)
    @defaultFragmetShader = createShader(@context, "fragment", DEFAULT_FRAGMENT_SOURCE)
    @defaultProgram = createProgram(@context, @defaultVertexShader, @defaultFragmetShader)

    @context.enable(@context.BLEND)
    # @context.blendFunc(@context.SRC_ALPHA, @context.ONE)
    @context.blendFuncSeparate(@context.SRC_ALPHA, @context.ONE_MINUS_SRC_ALPHA, @context.ONE, @context.ONE_MINUS_SRC_ALPHA)

    @context.useProgram(@defaultProgram)
    @defaultTexture = createDefaultTexture(@context)

    @colorLocation = @context.getUniformLocation(@defaultProgram, "u_color")
    @context.uniform4f(@colorLocation, 1, 1, 1, 1)

    @resolutionLocation = @context.getUniformLocation(@defaultProgram, "u_resolution")
    @context.uniform2f(@resolutionLocation, @width, @height)

    @positionLocation = @context.getAttribLocation(@defaultProgram, "a_position")
    @texCoordLocation = @context.getAttribLocation(@defaultProgram, "a_texCoord")

    @texCoordBuffer = @context.createBuffer()
    @positionBuffer = @context.createBuffer()

    # @context.bindBuffer(@context.ARRAY_BUFFER, @texCoordBuffer)
    # @context.bufferData(@context.ARRAY_BUFFER, new Float32Array([
    #     0.0,  0.0,
    #     1.0,  0.0,
    #     0.0,  1.0,
    #     0.0,  1.0,
    #     1.0,  0.0,
    #     1.0,  1.0]), @context.STATIC_DRAW)
    # @context.enableVertexAttribArray(@texCoordLocation)
    # @context.vertexAttribPointer(@texCoordLocation, 2, @context.FLOAT, false, 0, 0)

  clear: (self, r, g, b, a) ->
    @context.clear(@context.COLOR_BUFFER_BIT)

  origin: () ->

  setColor: (r, g, b, a) ->
    if typeof(r) == "number"
      @current_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @current_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))
    c = @current_color
    @context.uniform4f(@colorLocation, c.r / 255, c.g / 255, c.b / 255, c.a / 255)

  setBackgroundColor: (r, g, b, a) ->
    if typeof(r) == "number"
      @background_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @background_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))
    c = @background_color
    @context.clearColor(c.r / 255, c.g / 255, c.b / 255, c.a / 255)

  getBackgroundColor: () ->
    c = @background_color
    [c.r, c.g, c.b, c.a]

  setFont: () ->


  circle: (mode, x, y, radius, points) ->
    angle_shift = Math.PI * 2 / points
    phi = 0
    coords = []

    # Fill mode will use a triangle fan internally, so we want the "hub" of the
    # fan (its first vertex) to be the midpoint of the circle.
    if mode == "fill"
      coords[0] = x
      coords[1] = y

    for i in [0...points]
      phi += angle_shift
      coords[2*i]   = x + radius * Math.cos(phi)
      coords[2*i+1] = y + radius * Math.sin(phi)

    @polygon(mode, coords)

  line: (points...) ->
    @context.bindTexture(@context.TEXTURE_2D, @defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(points), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.LINE_STRIP, 0, points.length / 2)

    @context.disableVertexAttribArray(@positionLocation)


  polygon: (mode, points...) ->
    if points.length == 1
      # we were passed a sequence
      points = points[0]

    draw_mode = @context.TRIANGLE_FAN
    switch mode
      when "line"
        draw_mode = @context.LINE_LOOP
      when "fill"
        draw_mode = @context.TRIANGLE_FAN
    # @context.prepareDraw()
    @context.bindTexture(@context.TEXTURE_2D, @defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(points), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(draw_mode, 0, points.length / 2)

    @context.disableVertexAttribArray(@positionLocation)

  rectangle: (mode, x, y, w, h) ->
    @polygon(mode, x,y, x,y+h, x+w,y+h, x+w,y)

  draw: (drawable, x, y, r, sx, syx, ox, oy, kx, ky) ->
    @context.bindTexture(@context.TEXTURE_2D, drawable.texture)

    @context.enableVertexAttribArray(@positionLocation)
    @context.enableVertexAttribArray(@texCoordLocation)

    @context.bindBuffer(@context.ARRAY_BUFFER, @texCoordBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array([
        0.0,  0.0,
        1.0,  0.0,
        0.0,  1.0,
        0.0,  1.0,
        1.0,  0.0,
        1.0,  1.0]), @context.DYNAMIC_DRAW)
    @context.vertexAttribPointer(@texCoordLocation, 2, @context.FLOAT, false, 0, 0)

    [width, height] = drawable.getDimensions(drawable)
    x1 = x
    x2 = x + width
    y1 = y
    y2 = y + height

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array([
       x1, y1,
       x2, y1,
       x1, y2,
       x1, y2,
       x2, y1,
       x2, y2]), @context.DYNAMIC_DRAW)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.TRIANGLES, 0, 6)

    @context.disableVertexAttribArray(@positionLocation)
    @context.disableVertexAttribArray(@texCoordLocation)

  # PRIVATE
  setDimensions: (@width, @height) ->
    @element.setAttribute('width', @width)
    @element.setAttribute('height', @height)

  # INTERNAL
  getGLContext = (canvas) ->
    names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"]
    for name in names
      try
        context = canvas.getContext(name)
      catch e
      if context
        break
    return context

  createShader = (gl, type, source) ->
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

  createProgram = (gl, vertex_shader, fragment_shader) ->
    program = gl.createProgram()
    gl.attachShader(program, vertex_shader)
    gl.attachShader(program, fragment_shader)
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

  setRectangle = (gl, x, y, width, height) ->
      x1 = x
      x2 = x + width
      y1 = y
      y2 = y + height
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
         x1, y1,
         x2, y1,
         x1, y2,
         x1, y2,
         x2, y1,
         x2, y2]), gl.STATIC_DRAW)

  createDefaultTexture = (gl) ->
    data = new Uint8Array([255, 255, 255, 255])
    texture = gl.createTexture()
    gl.bindTexture(gl.TEXTURE_2D, texture)
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, data)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST)
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST)
    return texture

  DEFAULT_VERTEX_SOURCE = """
attribute vec2 a_position;
attribute vec2 a_texCoord;

uniform vec2 u_resolution;

varying vec2 v_texCoord;

void main() {
   // convert the rectangle from pixels to 0.0 to 1.0
   vec2 zeroToOne = a_position / u_resolution;

   // convert from 0->1 to 0->2
   vec2 zeroToTwo = zeroToOne * 2.0;

   // convert from 0->2 to -1->+1 (clipspace)
   vec2 clipSpace = zeroToTwo - 1.0;

   gl_Position = vec4(clipSpace * vec2(1, -1), 0, 1);

   // pass the texCoord to the fragment shader
   // The GPU will interpolate this value between points.
   v_texCoord = a_texCoord;
}"""

  DEFAULT_FRAGMENT_SOURCE = """
precision mediump float;
uniform vec4 u_color;

// our texture
uniform sampler2D u_image;

// the texCoords passed in from the vertex shader.
varying vec2 v_texCoord;

void main() {
  gl_FragColor = u_color * texture2D(u_image, v_texCoord);
}"""
