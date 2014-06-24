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

    @defaultProgram = new Shader(@context)

    @context.disable(@context.CULL_FACE)
    @context.disable(@context.DEPTH_TEST)
    @context.enable(@context.BLEND)
    # @context.blendFunc(@context.SRC_ALPHA, @context.ONE)
    @context.blendFuncSeparate(@context.SRC_ALPHA, @context.ONE_MINUS_SRC_ALPHA, @context.ONE, @context.ONE_MINUS_SRC_ALPHA)

    @gl.useProgram(@defaultProgram)
    @defaultTexture = @gl.createDefaultTexture()

    @resolutionLocation = @context.getUniformLocation(@defaultProgram.program, "love_ScreenSize")
    @pointSizeLocation = @context.getUniformLocation(@defaultProgram.program, "love_PointSize")
    @transformMatrixLocation = @context.getUniformLocation(@defaultProgram.program, "TransformMatrix")
    @projectionMatrixLocation = @context.getUniformLocation(@defaultProgram.program, "ProjectionMatrix")
    @transformProjectionMatrixLocation = @context.getUniformLocation(@defaultProgram.program, "TransformProjectionMatrix")

    @context.uniform4f(@resolutionLocation, @width, @height, 0, 0)
    @context.uniform1f(@pointSizeLocation, 1)

    @positionLocation = @context.getAttribLocation(@defaultProgram.program, "VertexPosition")
    @texCoordLocation = @context.getAttribLocation(@defaultProgram.program, "VertexTexCoord")
    @colorLocation = @context.getAttribLocation(@defaultProgram.program, "VertexColor")

    @texCoordBuffer = @context.createBuffer()
    @positionBuffer = @context.createBuffer()

  clear: (self, r, g, b, a) ->
    @context.clear(@context.COLOR_BUFFER_BIT)

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

    @gl.bindTexture(@defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array(points), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.LINE_STRIP, 0, points.length / 2)

    @context.disableVertexAttribArray(@positionLocation)

  point: (x, y) ->
    @prepareDraw()

    @gl.bindTexture(@defaultTexture)

    @context.bindBuffer(@context.ARRAY_BUFFER, @positionBuffer)
    @context.bufferData(@context.ARRAY_BUFFER, new Float32Array([x, y]), @context.DYNAMIC_DRAW)
    @context.enableVertexAttribArray(@positionLocation)
    @context.vertexAttribPointer(@positionLocation, 2, @context.FLOAT, false, 0, 0)

    @context.drawArrays(@context.POINTS, 0, 1)

    @context.disableVertexAttribArray(@positionLocation)

  polygon: (mode, points...) ->
    if points.length == 1
      # we were passed a sequence
      points = if points[0].__shine
        points[0].__shine.numValues.slice(1, points[0].__shine.numValues.length)
      else
        points[0]


    draw_mode = @context.TRIANGLE_FAN
    switch mode
      when "line"
        draw_mode = @context.LINE_LOOP
      when "fill"
        draw_mode = @context.TRIANGLE_FAN
    @prepareDraw()

    @gl.bindTexture(@defaultTexture)

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
    @transformMatrices.push(@transformMatrices.top().x(imageDrawTransform))

    @prepareDraw()

    @gl.bindTexture(texture)

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

  origin: () ->
    @transformMatrices.pop()
    @transformMatrices.push(Matrix.I(4))

  pop: () ->
    @transformMatrices.pop()

  push: () ->
    @transformMatrices.push(Matrix.create(@transformMatrices.top()))

  rotate: (r) ->
    new_transform = @transformMatrices.pop().x(Matrix.Rotation(r).ensure4x4())
    @transformMatrices.push(new_transform)

  scale: (sx, sy) ->
    m = Matrix.I(4)
    m.elements[0][0] = sx
    m.elements[1][1] = sy
    new_transform = @transformMatrices.pop().x(m)
    @transformMatrices.push(new_transform)

  shear: (kx, ky) ->
    m = Matrix.I(4)
    m.elements[0][1] = kx
    m.elements[1][0] = ky
    new_transform = @transformMatrices.pop().x(m)
    @transformMatrices.push(new_transform)

  translate: (dx, dy) ->
    m = Matrix.I(4)
    m.elements[0][3] = dx
    m.elements[1][3] = dy
    new_transform = @transformMatrices.pop().x(m)
    @transformMatrices.push(new_transform)

  getDimensions: (self) ->
    [@getWidth(self), @getHeight(self)]

  getHeight: (self) ->
    self.height

  getWidth: (self) ->
    self.width

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
    @defaultProgram.sendMatrix(@context, "TransformMatrix", transformMatrix)
    @defaultProgram.sendMatrix(@context, "ProjectionMatrix", projectionMatrix)
    @defaultProgram.sendMatrix(@context, "TransformProjectionMatrix", transformProjectionMatrix)
