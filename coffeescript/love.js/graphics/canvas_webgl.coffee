class CanvasWebGL
  constructor: (width, height, @element) ->
    @element ?= document.createElement('canvas')
    if (canvas_width = Number(@element.getAttribute('width'))) != 0
      width = canvas_width
    if (canvas_height = Number(@element.getAttribute('height'))) != 0
      height = canvas_height

    @transformMatrices = []
    @projectionMatrices = []
    @transformMatrices.push(Matrix.I(4))
    @projectionMatrices.push(Matrix.I(4))

    @context = WebGL.getGLContext(@element)
    @gl = new WebGL(@context)
    @setDimensions(width, height)

    @defaultVertexShader = @gl.createShader("vertex", DEFAULT_VERTEX_SOURCE)
    @defaultFragmetShader = @gl.createShader("fragment", DEFAULT_FRAGMENT_SOURCE)
    @defaultProgram = @gl.createProgram(@defaultVertexShader, @defaultFragmetShader)

    @context.enable(@context.BLEND)
    # @context.blendFunc(@context.SRC_ALPHA, @context.ONE)
    @context.blendFuncSeparate(@context.SRC_ALPHA, @context.ONE_MINUS_SRC_ALPHA, @context.ONE, @context.ONE_MINUS_SRC_ALPHA)

    @context.useProgram(@defaultProgram)
    @defaultTexture = @gl.createDefaultTexture()

    @resolutionLocation = @context.getUniformLocation(@defaultProgram, "love_ScreenSize")
    @pointSizeLocation = @context.getUniformLocation(@defaultProgram, "love_PointSize")
    @transformMatrixLocation = @context.getUniformLocation(@defaultProgram, "TransformMatrix")
    @projectionMatrixLocation = @context.getUniformLocation(@defaultProgram, "ProjectionMatrix")
    @transformProjectionMatrixLocation = @context.getUniformLocation(@defaultProgram, "TransformProjectionMatrix")

    @context.uniform4f(@resolutionLocation, @width, @height, 0, 0)
    @context.uniform1f(@pointSizeLocation, 1)

    @positionLocation = @context.getAttribLocation(@defaultProgram, "VertexPosition")
    @texCoordLocation = @context.getAttribLocation(@defaultProgram, "VertexTexCoord")
    @colorLocation = @context.getAttribLocation(@defaultProgram, "VertexColor")

    @texCoordBuffer = @context.createBuffer()
    @positionBuffer = @context.createBuffer()

  clear: (self, r, g, b, a) ->
    @context.clear(@context.COLOR_BUFFER_BIT)

  origin: () ->

  setColor: (r, g, b, a) ->
    if typeof(r) == "number"
      @current_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @current_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))
    c = @current_color
    @context.vertexAttrib4f(@colorLocation, c.r / 255, c.g / 255, c.b / 255, c.a / 255)

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

  arc: (mode, x, y, radius, startAngle, endAngle, segments) =>

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
    @prepareDraw()

    @context.bindTexture(@context.TEXTURE_2D, @defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(points), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.LINE_STRIP, 0, points.length / 2)

    @context.disableVertexAttribArray(@positionLocation)

  point: (x, y) ->
    @prepareDraw()

    @context.bindTexture(@context.TEXTURE_2D, @defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array([x, y]), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.POINTS, 0, 1)

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
    @prepareDraw()

    @context.bindTexture(@context.TEXTURE_2D, @defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(points), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(draw_mode, 0, points.length / 2)

    @context.disableVertexAttribArray(@positionLocation)

  rectangle: (mode, x, y, w, h) ->
    @polygon(mode, x,y, x,y+h, x+w,y+h, x+w,y)

  draw: (drawable, quad) ->
    switch true
      when quad not instanceof Quad then @drawDrawable.apply(this, arguments)
      when quad instanceof Quad then @drawQuad.apply(this, arguments)

  drawDrawable: (drawable, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
    imageDrawTransform = Matrix.I(4).setTransformation(x, y, r, sx, sy, ox, oy, kx, ky)
    @drawv(drawable.texture, imageDrawTransform, drawable.coords, drawable.uvs)

  drawQuad: (drawable, quad, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
    imageDrawTransform = Matrix.I(4).setTransformation(x, y, r, sx, sy, ox, oy, kx, ky)
    @drawv(drawable.texture, imageDrawTransform, quad.coords, quad.uvs)

  drawv: (texture, imageDrawTransform, coords, uvs) ->
    @transformMatrices.push(imageDrawTransform.x(@transformMatrices.top()))

    @prepareDraw()

    @context.bindTexture(@context.TEXTURE_2D, texture)

    @context.enableVertexAttribArray(@positionLocation)
    @context.enableVertexAttribArray(@texCoordLocation)

    @context.bindBuffer(@context.ARRAY_BUFFER, @texCoordBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(uvs), @context.DYNAMIC_DRAW)
    @context.vertexAttribPointer(@texCoordLocation, 2, @context.FLOAT, false, 0, 0)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(coords), @context.DYNAMIC_DRAW)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.TRIANGLE_FAN, 0, 4)

    @context.disableVertexAttribArray(@positionLocation)
    @context.disableVertexAttribArray(@texCoordLocation)

    @transformMatrices.pop()

  # PRIVATE
  setDimensions: (@width, @height) ->
    @element.setAttribute('width', @width)
    @element.setAttribute('height', @height)
    @context.viewport(0, 0, @width, @height)
    @projectionMatrices.push(Matrix.Ortho(0, @width, @height, 0))

  # INTERNAL
  prepareDraw: ->
    transformMatrix = @transformMatrices.top()
    projectionMatrix = @projectionMatrices.top()
    transformProjectionMatrix = projectionMatrix.x(transformMatrix)
    @context.uniformMatrix4fv(@transformMatrixLocation, false, new Float32Array(transformMatrix.flatten()))
    @context.uniformMatrix4fv(@projectionMatrixLocation, false, new Float32Array(projectionMatrix.flatten()))
    @context.uniformMatrix4fv(@transformProjectionMatrixLocation, false, new Float32Array(transformProjectionMatrix.flatten()))

  DEFAULT_VERTEX_SOURCE = """
#define number float
#define Image sampler2D
#define extern uniform
#define Texel texture2D
#define love_Canvases gl_FragData

#define VERTEX

precision mediump float;

attribute vec4 VertexPosition;
attribute vec4 VertexTexCoord;
attribute vec4 VertexColor;

varying vec4 VaryingTexCoord;
varying vec4 VaryingColor;

//#if defined(GL_EXT_draw_instanced)
//  #extension GL_EXT_draw_instanced : enable
//  #define love_InstanceID gl_InstanceIDEXT
//#else
//  attribute float love_PseudoInstanceID;
//  int love_InstanceID = int(love_PseudoInstanceID);
//#endif

uniform mat4 TransformMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 TransformProjectionMatrix;
// uniform mat4 NormalMatrix;
uniform sampler2D _tex0_;
uniform mediump vec4 love_ScreenSize;
uniform mediump float love_PointSize;

vec4 position(mat4 transform_proj, vec4 vertpos) {
  return transform_proj * vertpos;
}

void main() {
  VaryingTexCoord = VertexTexCoord;
  VaryingColor = VertexColor;
  gl_PointSize = love_PointSize;
  gl_Position = position(TransformProjectionMatrix, VertexPosition);
}"""

  DEFAULT_FRAGMENT_SOURCE = """
#define number float
#define Image sampler2D
#define extern uniform
#define Texel texture2D
#define love_Canvases gl_FragData

#define PIXEL

precision mediump float;

varying mediump vec4 VaryingTexCoord;
varying lowp vec4 VaryingColor;

uniform mat4 TransformMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 TransformProjectionMatrix;
// uniform mat4 NormalMatrix;
uniform sampler2D _tex0_;
uniform mediump vec4 love_ScreenSize;
uniform mediump float love_PointSize;

vec4 effect(lowp vec4 vcolor, Image texture, vec2 texcoord, vec2 pixcoord) {
  return Texel(texture, texcoord) * vcolor;
}

void main() {
  vec2 pixelcoord = vec2(gl_FragCoord.x, (gl_FragCoord.y * love_ScreenSize.z) + love_ScreenSize.w);

  gl_FragColor = effect(VaryingColor, _tex0_, VaryingTexCoord.st, pixelcoord);
}"""
