class Canvas
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
    self.context.fillRect(0, 0, self.canvas.width, self.canvas.height)
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

Canvas.transparent = new Color(0, 0, 0, 0)
