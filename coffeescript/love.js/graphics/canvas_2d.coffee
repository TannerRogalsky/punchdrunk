class Canvas2D
  constructor: (width, height) ->
    @element = document.createElement('canvas')
    this.setDimensions(width, height)
    @context = @element.getContext('2d')

  clear: (self, r, g, b, a) ->
    if r == null or r == undefined
      color = Canvas.transparent
    else
      color = new Color(r, g, b, a)

    self.context.save()
    self.context.setTransform(1,0,0,1,0,0)
    self.context.fillStyle = color.html_code
    self.context.globalAlpha = color.a / 255
    self.context.fillRect(0, 0, self.width, self.height)
    self.context.restore()

  getDimensions: (self) ->
    [self.width, self.height]

  getHeight: (self) ->
    self.height

  getImageData: (self) ->
    image_data = self.context.getImageData(0, 0, self.width, self.height)
    new ImageData(image_data)

  getPixel: (self, x, y) ->
    data = self.context.getImageData(x, y, 1, 1).data
    [data[0], data[1], data[2], data[3]]

  getWidth: (self) ->
    self.width

  # TODO: wrapping also applies to textures and quads
  getWrap: (self) ->

  setWrap: (self) ->

  # PRIVATE
  arc: (mode, x, y, radius, startAngle, endAngle, segments) ->
    @context.beginPath()
    @context.moveTo(x, y)
    @context.arc(x, y, radius, startAngle, endAngle)
    @context.closePath()
    switch mode
      when "fill" then @context.fill()
      when "line" then @context.stroke()

  circle: (mode, x, y, radius, segments) ->
    @context.beginPath()
    @context.arc(x, y, radius, 0, 2 * Math.PI)
    @context.closePath()
    switch mode
      when "fill" then @context.fill()
      when "line" then @context.stroke()

  draw: (drawable, quad) ->
    switch true
      when quad not instanceof Quad then drawDrawable.apply(this, arguments)
      when quad instanceof Quad then drawWithQuad.apply(this, arguments)

  line: (points...) ->
    @context.beginPath()
    @context.moveTo(points[0], points[1])
    for i in [2...points.length] by 2
      [x, y] = [points[i], points[i + 1]]
      @context.lineTo(x, y)
    @context.stroke()

  point: (x, y) ->
    @context.fillRect(x, y, 1, 1)

  polygon: (mode, points...) ->
    @context.beginPath()
    @context.moveTo(points[0], points[1])
    for i in [2...points.length] by 2
      [x, y] = [points[i], points[i + 1]]
      @context.lineTo(x, y)
    @context.closePath()
    switch mode
      when "fill" then @context.fill()
      when "line" then @context.stroke()

  print: (text, x, y) ->
    @context.fillText(text, x, y)

  # TODO: word wrap? UGH
  printf: (text, x, y, limit, align = "left") ->
    @context.save()
    @context.translate(x + limit / 2, y)
    switch align
      when "center" then @context.textAlign = "center"
      when "left" then @context.textAlign = "left"
      when "right" then @context.textAlign = "right"
    @context.fillText(text, 0, 0)
    @context.restore()

    @context.textBaseline = "top"

  rectangle: (mode, x, y, width, height) ->
    switch mode
      when "fill" then @context.fillRect(x, y, width, height)
      when "line" then @context.strokeRect(x, y, width, height)

  setColor: (r, g, b, a = 255) ->
    if typeof(r) == "number"
      @current_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @current_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))
    @context.fillStyle = @current_color.html_code
    @context.strokeStyle = @current_color.html_code
    @context.globalAlpha = @current_color.a / 255

  setFont: (font) ->
    if font
      @context.font = font.html_code
    else
      @context.font = @default_font.html_code

  origin: () ->
    @context.setTransform(1,0,0,1,0,0)

  pop: () ->
    @context.restore()

  push: () ->
    @context.save()

  rotate: (r) ->
    @context.rotate(r)

  scale: (sx, sy = sx) ->
    @context.scale(sx, sy)

  shear: (kx, ky) ->
    @context.transform(1, ky, kx, 1, 0, 0)

  translate: (dx, dy) ->
    @context.translate(dx, dy)

  copyContext: (context) ->
    @context.fillStyle = context.fillStyle
    @context.font = context.font
    @context.globalAlpha = context.globalAlpha
    @context.globalCompositeOperation = context.globalCompositeOperation
    @context.lineCap = context.lineCap
    @context.lineDashOffset = context.lineDashOffset
    @context.lineJoin = context.lineJoin
    @context.lineWidth = context.lineWidth
    @context.miterLimit = context.miterLimit
    @context.shadowBlur = context.shadowBlur
    @context.shadowColor = context.shadowColor
    @context.shadowOffsetX = context.shadowOffsetX
    @context.shadowOffsetY = context.shadowOffsetY
    @context.strokeStyle = context.strokeStyle
    @context.textAlign = context.textAlign
    @context.textBaseline = context.textBaseline

  setDimensions: (@width, @height) ->
    @element.setAttribute('width', @width)
    @element.setAttribute('height', @height)

  drawDrawable = (drawable, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
    halfWidth = drawable.element.width / 2
    halfHeight = drawable.element.height / 2

    @context.save()
    @context.translate(x, y)
    @context.rotate(r)
    @context.scale(sx, sy)
    @context.transform(1, ky, kx, 1, 0, 0) # shearing
    @context.translate(-ox, -oy)
    @context.drawImage(drawable.element, 0, 0)
    @context.restore()

  drawWithQuad = (drawable, quad, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
    halfWidth = drawable.element.width / 2
    halfHeight = drawable.element.height / 2

    @context.save()
    @context.translate(x, y)
    @context.rotate(r)
    @context.scale(sx, sy)
    @context.transform(1, ky, kx, 1, 0, 0) # shearing
    @context.translate(-ox, -oy)
    @context.drawImage(drawable.element, quad.x, quad.y, quad.width, quad.height, 0, 0, quad.width, quad.height)
    @context.restore()

Canvas2D.transparent = new Color(0, 0, 0, 0)
