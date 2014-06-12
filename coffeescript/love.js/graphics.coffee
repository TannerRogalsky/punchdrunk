class Love.Graphics
  constructor: (width = 800, height = 600) ->
    if Love.element
      if @isSupported("webgl")
        @canvas = new CanvasWebGL(width, height, Love.element)
      else
        @canvas = new Canvas2D(width, height, Love.element)
    else
      if @isSupported("webgl")
        @canvas = new CanvasWebGL(width, height)
      else
        @canvas = new Canvas2D(width, height)
      document.body.appendChild(@canvas.element)
      Love.element = @canvas.element

    @default_canvas = @canvas
    @default_font = new Font("Vera", 12)

    @setColor(255, 255, 255)
    @setBackgroundColor(0, 0, 0)
    @setFont(@default_font)

  # DRAWING
  arc: (mode, x, y, radius, startAngle, endAngle, segments) =>
    @canvas.arc(mode, x, y, radius, startAngle, endAngle, segments)

  circle: (mode, x, y, radius, segments = radius) =>
    @canvas.circle(mode, x, y, radius, segments)

  clear: () =>
    [r, g, b, a] = @getBackgroundColor()
    @canvas.clear(@canvas, r, g, b, a)

  draw: (args...) =>
    @canvas.draw(args...)

  line: (points...) =>
    @canvas.line(points...)

  point: (x, y) =>
    @canvas.point(x, y)

  polygon: (mode, points...) =>
    @canvas.polygon(mode, points...)

  print: (text, x, y) =>
    @canvas.print(text, x, y)

  # TODO: word wrap? UGH
  printf: (text, x, y, limit, align = "left") =>
    @canvas.printf(text, x, y, limit, align)

  rectangle: (mode, x, y, width, height) =>
    @canvas.rectangle(mode, x, y, width, height)

  # OBJECT CREATION
  newCanvas: (width = @getWidth(@), height = @getHeight(@)) =>
    new Canvas2D(width, height)

  newFont: (filename, size = 12) =>
    new Font(filename, size)

  newImage: (data) =>
    new Image(data)

  newImageFont: =>

  newMesh: () =>
  newParticleSystem: () =>

  newQuad: (x, y, width, height, sw, sh) =>
    new Quad(x, y, width, height, sw, sh)

  newScreenshot: =>
  newShader: () =>
  newSpriteBatch: () =>

  setNewFont: (filename, size) =>
    font = @newFont(filename, size)
    @setFont(font)

  # STATE
  getBackgroundColor: () =>
    @canvas.getBackgroundColor()

  getBlendMode: () =>
    @canvas.getBlendMode()

  getCanvas: () =>
    @canvas

  getColor: () =>
    @canvas.getColor()

  getColorMask: () =>
    @canvas.getColorMask()

  getDefaultFilter: () =>
    @canvas.getDefaultFilter()

  getFont: () =>
    @canvas.getFont()

  getLineJoin: () =>
    @canvas.getLineJoin()

  getLineStyle: () =>
    @canvas.getLineStyle()

  getLineWidth: () =>
    @canvas.getLineWidth()

  getMaxImageSize: () =>
    @canvas.getMaxImageSize()

  getMaxPointSize: () =>
    @canvas.getMaxPointSize()

  getPointSize: () =>
    @canvas.getPointSize()

  getPointStyle: () =>
    @canvas.getPointStyle()

  getRendererInfo: () =>
    @canvas.getRendererInfo()

  getScissor: () =>
    @canvas.getScissor()

  getShader: () =>
    @canvas.getShader()

  getSystemLimit: () =>
    @canvas.getSystemLimit()

  isSupported: (features...) =>
    for feature in features
      switch feature
        when "webgl"
          if !window.WebGLRenderingContext
            return false
        else
          return false
    return true

  isWireframe: () =>
    @canvas.isWireframe()

  reset: () =>
    @setCanvas()
    @origin()

  setBackgroundColor: (r, g, b, a = 255) =>
    @canvas.setBackgroundColor(r, g, b, a)

  setBlendMode: (mode) =>
    @canvas.setBlendMode(mode)

  setCanvas: (canvas) =>
    if canvas == undefined or canvas == null
      @default_canvas.copyContext(@canvas.context)
      @canvas = @default_canvas
    else
      canvas.copyContext(@canvas.context)
      @canvas = canvas

  setColor: (r, g, b, a = 255) =>
    @canvas.setColor(r, g, b, a)

  setFont: (font) =>
    @canvas.setFont(font)

  setColorMask: (r, g, b, a) =>
    @canvas.setColorMask(r, g, b, a)

  setDefaultFilter: (min, mag, anisotropy) =>
    @canvas.setDefaultFilter(min, mag, anisotropy)

  setInvertedStencil: (callback) =>
    @canvas.setInvertedStencil(callback)

  setLineJoin: (join) =>
    @canvas.setLineJoin(join)

  setLineStyle: (style) =>
    @canvas.setLineStyle(style)

  setLineWidth: (width) =>
    @canvas.setLineWidth(width)

  setPointSize: (size) =>
    @canvas.setPointSize(size)

  setPointStyle: (style) =>
    @canvas.setPointStyle(style)

  setScissor: (x, y, width, height) =>
    @canvas.setScissor(x, y, width, height)

  setShader: (shader) =>
    @canvas.setShader(shader)

  setStencil: (callback) =>
    @canvas.setStencil(callback)

  setWireframe: (enable) =>
    @canvas.setWireframe(enable)

  # COORDINATE SYSTEM
  origin: () =>
    @canvas.origin()

  pop: () =>
    @canvas.pop()

  push: () =>
    @canvas.push()

  rotate: (r) =>
    @canvas.rotate(r)

  scale: (sx, sy = sx) =>
    @canvas.scale(sx, sy)

  shear: (kx, ky) =>
    @canvas.shear(kx, ky)

  translate: (dx, dy) =>
    @canvas.translate(dx, dy)

  # WINDOW
  getDimensions: () =>
    [@getWidth(), @getHeight()]

  getHeight: () =>
    @default_canvas.getHeight(@default_canvas)

  getWidth: () =>
    @default_canvas.getWidth(@default_canvas)
