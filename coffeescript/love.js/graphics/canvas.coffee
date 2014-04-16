class Canvas
  constructor: (@width, @height) ->
    @element = document.createElement('canvas')
    @element.setAttribute('width', @width)
    @element.setAttribute('height', @height)
    @context = @element.getContext('2d')

  clear: (r, g, b, a) =>
    if r == null or r == undefined
      color = Canvas.transparent
    else
      color = new Color(r, g, b, a)

    @context.save()
    @context.setTransform(1,0,0,1,0,0)
    @context.fillStyle = color.html_code
    @context.globalAlpha = color.a / 255
    @context.fillRect(0, 0, @canvas.width, @canvas.height)
    @context.restore()

  getDimensions: () =>
    [@width, @height]

  getHeight: () =>
    @height

  getImageData: () =>
    image_data = @context.getImageData(0, 0, @width, @height)
    new ImageData(image_data)

  getPixel: (x, y) =>
    data = @context.getImageData(x, y, 1, 1).data
    [data[0], data[1], data[2], data[3]]

  getWidth: () =>
    @width

  # TODO: wrapping also applies to textures and quads
  getWrap: () =>

  setWrap: () =>

  # PRIVATE
  draw: (context, x, y, r, sx, sy, ox, oy, kx, ky) ->
    context.drawImage(@element, x, y)

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

Canvas.transparent = new Color(0, 0, 0, 0)
