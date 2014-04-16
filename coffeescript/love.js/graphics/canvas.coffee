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
    @context.strokeStyle = context.strokeStyle
    @context.globalAlpha = context.globalAlpha
