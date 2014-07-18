class Love.Math.BezierCurve
  constructor: (@controlPoints) ->

  evaluate: (self, t) ->
    if t < 0 or t > 1
      throw new Love.Exception("Invalid evaluation parameter: must be between 0 and 1")
    if self.controlPoints.length < 2
      throw new Love.Exception("Invalid Bezier curve: Not enough control points.")

    # de casteljau
    points = self.controlPoints.slice(0)
    for step in [1...self.controlPoints.length]
      for i in [0...(self.controlPoints.length - step)]
        points[i] =
          x: points[i].x * (1-t) + points[i+1].x * t
          y: points[i].y * (1-t) + points[i+1].y * t

    [points[0].x, points[0].y]

  getControlPoint: (self, i) ->
    if i < 0
      i += self.controlPoints.length

    if i < 0 or i >= self.controlPoints.length
      throw new Love.Exception("Invalid control point index")

    [self.controlPoints[i].x, self.controlPoints[i].y]

  getControlPointCount: (self) ->
    self.controlPoints.length

  getDegree: (self) ->
    self.controlPoints.length - 1

  getDerivative: (self) ->
    if self.getDegree(self) < 1
      throw new Love.Exception("Cannot derive a curve of degree < 1.")

    forward_differences = new Array()
    degree = self.getDegree(self)
    for i in [0...self.controlPoints.length - 1]
      forward_differences.push
        x: (self.controlPoints[i+1].x - self.controlPoints[i].x) * degree
        y: (self.controlPoints[i+1].y - self.controlPoints[i].y) * degree

    new self.constructor(forward_differences)


  insertControlPoint: (self, x, y, pos = -1) ->
    if pos < 0
      pos += self.controlPoints.length + 1

    if pos < 0 or pos > self.controlPoints.length
      throw new Love.Exception("Invalid control point index")

    self.controlPoints.splice pos, 0,
      x: x
      y: y

  render: (self, depth = 5) ->
    if self.controlPoints.length < 2
      throw new Love.Exception("Invalid Bezier curve: Not enough control points.")
    vertices = self.controlPoints.slice(0)
    subdivide(vertices, depth)
    results = []
    for vertice in vertices
      results.push(vertice.x)
      results.push(vertice.y)
    return results

  rotate: (self, angle, ox = 0, oy = 0) ->
    c = Math.cos(angle)
    s = Math.sin(angle)
    for controlPoint in self.controlPoints
      v =
        x: controlPoint.x - ox
        y: controlPoint.y - oy
      controlPoint.x = c * v.x - s * v.y + ox
      controlPoint.y = s * v.x + c * v.y + oy

  scale: (self, s, ox = 0, oy = 0) ->
    for controlPoint in self.controlPoints
      controlPoint.x = (controlPoint.x - ox) * s + ox
      controlPoint.y = (controlPoint.y - oy) * s + oy

  setControlPoint: (self, i, x, y) ->
    if i < 0
      i += self.controlPoints.length

    if i < 0 or i >= self.controlPoints.length
      throw new Love.Exception("Invalid control point index")

    self.controlPoints[i] =
      x: x
      y: y

  translate: (self, dx, dy) ->
    for controlPoint in self.controlPoints
      controlPoint.x += dx
      controlPoint.y += dy

  subdivide = (points, k) ->
    if k <= 0
      return

    left = []
    right = []

    for step in [1...points.length]
      left.push(points[0])
      right.push(points[points.length - step])
      for i in [0...(points.length - step)]
        points[i] = (points[i] + points[i+1]) * .5
    left.push(points[0])
    right.push(points[0])

    subdivide(left, k - 1)
    subdivide(right, k - 1)

    for i in [0...left.length]
      points[i] = left[i]
    for i in [0...right.length]
      points[i-1 + left.length] = right[right.length - i - 1]
    return points
