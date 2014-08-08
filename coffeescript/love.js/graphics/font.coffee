class Love.Graphics.Font
  constructor: (@filepath, @size) ->

    if typeof @filepath == "number" # newFont(size): Use standard font
      @size = @filepath
      @filename = "Vera"
      @filepath = "Vera"
      
    if typeof @filepath != "string" # newFont(): Use standard font and standard size 
      @size = 12
      @filename = "Vera"
      @filepath = "Vera"

    if not @filename      # newFont(filepath, size): Use given font and size
      @filename = @filepath.replace( /\\ /g, '/' )
      @filename = @filename.substring(@filename.lastIndexOf('/')+1, @filename.lastIndexOf('.'))
      # Load font by adding CSS 
      styleElement = document.createElement("style");
      styleElement.textContent = '@font-face{font-family: "'+@filename+'"; src: url("'+Love.root+'/'+@filepath+'");}'
      document.head.appendChild(styleElement)
    @html_code = "#{@size}px #{@filename}"

    

    # Get font height
    body = document.getElementsByTagName("body")[0]
    dummy = document.createElement("div")
    dummyText = document.createTextNode("x")
    dummy.appendChild(dummyText)
    dummy.setAttribute("style", "font: " + @html_code + "; padding:0;margin:0;position:absolute;width:auto;height:auto;visibility:hidden;")
    body.appendChild(dummy)
    @height = dummy.offsetHeight
    body.removeChild(dummy)
  getAscent: (self) ->
  getBaseline: (self) ->
  getDescent: (self) ->
  getFilter: (self) ->
  getHeight: (self) ->
    return self.height
  getLineHeight: (self) ->
  getWidth: (self, text) ->
    canvas = document.getElementsByTagName("canvas")[0]
    ctx = canvas.getContext("2d");
    oldfont = ctx.font
    ctx.font = self.html_code
    width = ctx.measureText(text).width
    ctx.font = oldfont
    return width
  getWrap: (self, text, width) ->
    canvas = document.getElementsByTagName("canvas")[0]
    ctx = canvas.getContext("2d");
    oldfont = ctx.font
    ctx.font = self.html_code
    numlines = 0
    maxwidth = 0
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
          metrics = ctx.measureText(testLine)
          testWidth = metrics.width
        if testWidth > width && n > 0
          linewidth = ctx.measureText(line).width
          maxwidth = Math.max(maxwidth, linewidth)
          numlines += 1
          line = words[n]
        else
          line = testLine
      linewidth = ctx.measureText(line).width
      maxwidth = Math.max(maxwidth, linewidth)
      numlines += 1

    ctx.font = oldfont
    return [maxwidth, numlines]
      

  hasGlyphs: (self) ->
  setFilter: (self) ->
  setLineHeight: (self) ->
