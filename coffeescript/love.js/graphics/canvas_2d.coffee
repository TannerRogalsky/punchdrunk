class Love.Graphics.Canvas2D
  @TRANSPARENT = new Love.Color(0, 0, 0, 0)

  constructor: (width, height, @element) ->
    @element ?= document.createElement('canvas')
    if (canvas_width = Number(@element.getAttribute('width'))) != 0
      width = canvas_width
    if (canvas_height = Number(@element.getAttribute('height'))) != 0
      height = canvas_height
    @setDimensions(width, height)
    @context = @element.getContext('2d')

    @current_transform = Matrix.I(3)

    @context.textBaseline = "top"
  clear: (self, r, g, b, a) ->
    if r == null or r == undefined
      color = @constructor.TRANSPARENT
    else
      color = new Color(r, g, b, a)

    self.context.save()
    self.context.setTransform(1,0,0,1,0,0)
    self.context.fillStyle = color.html_code
    self.context.globalAlpha = color.a / 255
    self.context.fillRect(0, 0, self.width, self.height)
    self.context.restore()

  getDimensions: =>
    [@getWidth(), @getHeight()]

  getHeight: =>
    @height

  getImageData: =>
    image_data = @context.getImageData(0, 0, @width, @height)
    new ImageData(image_data)

  getPixel: (self, x, y) ->
    data = self.context.getImageData(x, y, 1, 1).data
    [data[0], data[1], data[2], data[3]]

  getWidth: =>
    @width

  # TODO: wrapping also applies to textures and quads
  getWrap: (self) ->

  setWrap: (self) ->

  # PRIVATE
  arc: (mode, x, y, radius, startAngle, endAngle, points) ->
    points ||= if radius > 10 then radius else 10
    angle_shift = (endAngle - startAngle) / points
    phi = startAngle - angle_shift

    @context.beginPath()
    @context.moveTo(x, y)
    for i in [0..points]
      phi += angle_shift
      @context.lineTo(x + radius * Math.cos(phi), y + radius * Math.sin(phi))
    @context.closePath()

    switch mode
      when "fill" then @context.fill()
      when "line" then @context.stroke()

  circle: (mode, x, y, radius, segments) ->
    if radius < 0
      # don't try to draw a circle with negative radius
      return

    @context.beginPath()
    @context.arc(x, y, radius, 0, 2 * Math.PI)
    @context.closePath()
    switch mode
      when "fill" then @context.fill()
      when "line" then @context.stroke()

  draw: (drawable, quad) ->
    switch true
      when quad not instanceof Love.Graphics.Quad then @drawDrawable.apply(this, arguments)
      when quad instanceof Love.Graphics.Quad then @drawWithQuad.apply(this, arguments)

  line: (points...) ->
    if points.length == 1
      points = points[0].__shine.numValues.slice(1, points[0].__shine.numValues.length)

    @context.beginPath()
    @context.moveTo(points[0], points[1])
    for i in [2...points.length] by 2
      [x, y] = [points[i], points[i + 1]]
      @context.lineTo(x, y)
    @context.stroke()

  point: (x, y) ->
    @context.fillRect(x, y, 1, 1)

  polygon: (mode, points...) ->
    if points.length == 1
      points = points[0].__shine.numValues.slice(1, points[0].__shine.numValues.length)

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
    linesN = text.split('\n')
    if linesN.length > 1
      starty = y
      lineHeight = @current_font.getHeight(@current_font)
      for line in linesN
        @context.fillText(line, x, starty)
        starty += lineHeight

    else
      @context.fillText(text, x, y)

  printf: (text, x, y, limit, align = "left") ->

    # get lines
    lines = []
    linesN = text.split('\n')
    for lineN in linesN
      words = lineN.split(' ')
      line = ''

      for n in [0..(words.length-1)] 
        if line == '' # Print first word even if its longer than limit
          line = words[n] 
          testLine = words[n]
          continue
        else
          testLine = line + ' ' + words[n]
          metrics = @context.measureText(testLine)
          testWidth = metrics.width
        if testWidth > limit && n > 0
          lines.push(line)
          line = words[n]
        else
          line = testLine
      lines.push(line)




    textx = 0
    switch align
       when "center"
        @context.textAlign = "center"
        textx = x + (limit/2)
       when "left"
        @context.textAlign = "left"
        textx = x
       when "right"
        @context.textAlign = "right"
        textx = x + limit

    texty = y
    for line in lines 
      @context.fillText(line, textx, texty)
      texty += @current_font.getHeight(@current_font)


    @context.textAlign = "left"

  rectangle: (mode, x, y, width, height) ->
    switch mode
      when "fill" then @context.fillRect(x, y, width, height)
      when "line" then @context.strokeRect(x, y, width, height)

  getBackgroundColor: () ->
    c = @background_color
    [c.r, c.g, c.b, c.a]

  getBlendMode: () ->
    switch @context.globalCompositeOperation
      when "source-over" then "alpha"
      when "multiply" then "multiplicative"
      when "lighten" then "additive"

  getColor: () ->
    c = @current_color
    [c.r, c.g, c.b, c.a]

  getColorMask: () ->
  getDefaultFilter: () ->
  getFont: () ->
    @current_font

  getLineJoin: () ->
  getLineStyle: () ->
  getLineWidth: () ->
  getMaxImageSize: () ->
  getMaxPointSize: () ->
  getPointSize: () ->
  getPointStyle: () ->
  getRendererInfo: () ->
  getScissor: () ->
  getShader: () ->
  getSystemLimit: () ->
  isSupported: () ->
  isWireframe: () ->

  setBackgroundColor: (r, g, b, a) ->
    if typeof(r) == "number"
      @background_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @background_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))

  setBlendMode: (mode) ->
    switch mode
      when "alpha" then @context.globalCompositeOperation = "source-over"
      when "multiplicative" then @context.globalCompositeOperation = "multiply"
      when "additive" then @context.globalCompositeOperation = "lighten"

  setColor: (r, g, b, a = 255) ->
    if typeof(r) == "number"
      @current_color = new Color(r, g, b, a)
    else # we were passed a sequence
      @current_color = new Color(r.getMember(1), r.getMember(2), r.getMember(3), r.getMember(4))
    @context.fillStyle = @current_color.html_code
    @context.strokeStyle = @current_color.html_code
    @context.globalAlpha = @current_color.a / 255

  setFont: (font) ->
    @current_font = font
    if font
      @context.font = font.html_code
    else
      @context.font = @default_font.html_code

  setColorMask: () ->
  setDefaultFilter: () ->
  setInvertedStencil: () ->
  setLineJoin: () ->
  setLineStyle: () ->
  setLineWidth: () ->
  setPointSize: () ->
  setPointStyle: () ->
  setScissor: (x, y, width, height) ->
  setShader: () ->
  setStencil: (callback) ->
  setWireframe: () ->

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

  # INTERNAL
  drawDrawable: (drawable, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
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

  drawWithQuad: (drawable, quad, x = 0, y = 0, r = 0, sx = 1, sy = sx, ox = 0, oy = 0, kx = 0, ky = 0) ->
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
