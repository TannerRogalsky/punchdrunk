class Love.Graphics.Font
  constructor: (@filename, @size) ->
    @html_code = "#{@size}px #{@filename}"
  getAscent: (self) ->
  getBaseline: (self) ->
  getDescent: (self) ->
  getFilter: (self) ->
  getHeight: (self) ->
    return self.size
  getLineHeight: (self) ->
  getWidth: (self, text) ->
    canvas = document.getElementsByTagName("canvas")[0]
    ctx = canvas.getContext("2d");
    oldfont = ctx.font
    ctx.font = self.html_code
    width = ctx.measureText(text).width
    ctx.font = oldfont
    return width
  getWrap: (self) ->
    
  hasGlyphs: (self) ->
  setFilter: (self) ->
  setLineHeight: (self) ->
