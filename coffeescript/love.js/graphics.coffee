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
    c = @background_color
    @canvas.clear(@canvas, c.r, c.g, c.b, c.a)

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


  newQuad: (x, y, width, height, sw, sh) =>
    new Quad(x, y, width, height, sw, sh)

  # STATE

  setColor: (r, g, b, a = 255) =>
    @canvas.setColor(r, g, b, a)

  setBackgroundColor: (r, g, b, a = 255) =>
    if typeof(r) == "number"
      @background_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @background_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))

  setCanvas: (canvas) =>
    if canvas == undefined or canvas == null
      @default_canvas.copyContext(@canvas.context)
      @canvas = @default_canvas
    else
      canvas.copyContext(@canvas.context)
      @canvas = canvas

  setFont: (font) =>
    @canvas.setFont(font)

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
  getWidth: () =>
    @default_canvas.width

  getHeight: () =>
    @default_canvas.height
