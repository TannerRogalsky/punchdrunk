class Graphics
  constructor: (@width = 800, @height = 600) ->
    @canvas = new Canvas2D(@width, @height)
    document.body.appendChild(@canvas.element)

    @default_canvas = @canvas
    @default_font = new Font("Vera", 12)

    @setColor(255, 255, 255)
    @setBackgroundColor(0, 0, 0)
    @setFont(@default_font)

  # DRAWING
  arc: (mode, x, y, radius, startAngle, endAngle, segments) =>
    @canvas.arc(mode, x, y, radius, startAngle, endAngle, segments)

  circle: (mode, x, y, radius, segments) =>
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
    @canvas.polygon(mode, points)

  print: (text, x, y) =>
    @canvas.print(text, x, y)

  # TODO: word wrap? UGH
  printf: (text, x, y, limit, align = "left") =>
    @canvas.printf(text, x, y, limit, align)

  rectangle: (mode, x, y, width, height) =>
    @canvas.rectangle(mode, x, y, width, height)

  # OBJECT CREATION
  newCanvas: (width, height) =>
    new Canvas(width, height)

  newFont: (filename, size = 12) =>
    new Font(filename, size)

  newImage: (path) =>
    new Image(path)

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
  getCanvas: () =>
    @canvas

  getColor: () =>
    @canvas.getColor()

  getColorMask: () =>
  getDefaultFilter: () =>
  getFont: () =>
  getLineJoin: () =>
  getLineStyle: () =>
  getLineWidth: () =>
  getMaxImageSize: () =>
  getMaxPointSize: () =>
  getPointSize: () =>
  getPointStyle: () =>
  getRendererInfo: () =>
  getScissor: () =>
  getShader: () =>
  getSystemLimit: () =>

  isSupported: () =>
  isWireframe: () =>
  reset: () =>

  setBackgroundColor: (r, g, b, a = 255) =>
    @canvas.setBackgroundColor(r, g, b, a)

  setBlendMode: () =>

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

  setColorMask: () =>
  setDefaultFilter: () =>
  setInvertedStencil: () =>
  setLineJoin: () =>
  setLineStyle: () =>
  setLineWidth: () =>
  setPointSize: () =>
  setPointStyle: () =>
  setScissor: () =>
  setShader: () =>
  setStencil: () =>
  setWireframe: () =>

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
    @default_canvas.getHeight()

  getWidth: () =>
    @default_canvas.getWidth()
