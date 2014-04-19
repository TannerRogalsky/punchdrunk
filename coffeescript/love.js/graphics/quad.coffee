class Quad
  constructor: (@x, @y, @width, @height, @sw, @sh) ->

  getViewport: (self) ->
    [self.x, self.y, self.width, self.height]

  setViewport: (self, x, y, width, height) ->
    self.x = x
    self.y = y
    self.width = width
    self.height = height
