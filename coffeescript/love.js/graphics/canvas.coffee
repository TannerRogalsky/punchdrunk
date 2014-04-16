class Canvas
  constructor: (@width, @height) ->
    @element = document.createElement('canvas')
    @element.setAttribute('width', @width)
    @element.setAttribute('height', @height)
    @context = @element.getContext('2d')

  clear: () =>

  getDimensions: () =>
    [@width, @height]

  getHeight: () =>
    @height

  getImageData: () =>

  getPixel: () =>

  getWidth: () =>
    @width

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
