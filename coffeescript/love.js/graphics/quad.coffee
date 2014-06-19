class Quad
  constructor: (@x, @y, @width, @height, @sw, @sh) ->
    @refresh_vertices()

  getViewport: (self) ->
    [self.x, self.y, self.width, self.height]

  setViewport: (self, x, y, width, height) ->
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.refresh_vertices()

  refresh_vertices: ->
    @coords = []
    @coords.push(0)
    @coords.push(0)
    @coords.push(0)
    @coords.push(@height)
    @coords.push(@width)
    @coords.push(@height)
    @coords.push(@width)
    @coords.push(0)

    @uvs = []
    @uvs.push(@x/@sw)
    @uvs.push(@y/@sh)
    @uvs.push(@x/@sw)
    @uvs.push((@y+@height)/@sh)
    @uvs.push((@x+@width)/@sw)
    @uvs.push((@y+@height)/@sh)
    @uvs.push((@x+@width)/@sw)
    @uvs.push(@y/@sh)
