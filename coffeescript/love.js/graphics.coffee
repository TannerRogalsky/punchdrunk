class Graphics
  constructor: () ->
    @canvas = document.createElement('canvas')
    @canvas.setAttribute('width', 200)
    @canvas.setAttribute('height', 200)
    document.body.appendChild(@canvas)

    @ctx = @canvas.getContext('2d')

    @setColor(255, 255, 255)
    @setBackgroundColor(0, 0, 0)

  # DRAWING
  arc: () =>

  circle: () =>

  clear: () =>
    @ctx.save()
    @ctx.setTransform(1,0,0,1,0,0)
    @ctx.fillStyle = @background_color.html_code
    @ctx.fillRect(0, 0, @canvas.width, @canvas.height)
    @ctx.restore()

  line: () =>

  point: () =>

  polygon: () =>

  present: () =>

  print: (str, x, y) =>
    @ctx.fillText(str, x, y)

  printf: () =>

  rectangle: (mode, x, y, width, height) =>
    switch mode
      when "fill" then @ctx.fillRect(x, y, width, height)
      when "line" then @ctx.strokeRect(x, y, width, height)

  # STATE
  setColor: (r, g, b, a = 255) =>
    @current_color = new Color(r, g, b, a)
    @ctx.fillStyle = @current_color.html_code
    @ctx.strokeStyle = @current_color.html_code
    @ctx.globalAlpha = @current_color.a / 255

  setBackgroundColor: (r, g, b, a = 255) =>
    @background_color = new Color(r, g, b, a)

