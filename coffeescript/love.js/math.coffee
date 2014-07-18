class Love.Math
  constructor: () ->
    @random_generator = new Love.Math.RandomGenerator()
    simplex_r = new Love.Math.RandomGenerator()
    @simplex = new SimplexNoise(simplex_r.random.bind(simplex_r, simplex_r))

  gammaToLinear: (gamma_colors...) =>
    gamma_colors = getGammaArgs(gamma_colors)

    for c in gamma_colors
      c /= 255
      if c > 1
        c = 1
      else if c < 0
        c = 0
      else if c < 0.0031308
        c *= 12.92
      else
        c = 1.055 * window.Math.pow(c, 0.41666) - 0.055
      c *= 255

  getRandomSeed: =>
    @random_generator.getSeed(@random_generator)

  isConvex: (vertices...) =>
    polygon = toPolygon(vertices)

    i = polygon.length - 2
    j = polygon.length - 1
    k = 0

    p =
      x: polygon[j].x - polygon[i].x
      y: polygon[j].y - polygon[i].y
    q =
      x: polygon[k].x - polygon[j].x
      y: polygon[k].y - polygon[j].y
    winding = p.x * q.y - p.y * q.x

    while k + 1 < polygon.length
      i = j
      j = k
      k++
      p.x = polygon[j].x - polygon[i].x
      p.y = polygon[j].y - polygon[i].y
      q.x = polygon[k].x - polygon[j].x
      q.y = polygon[k].y - polygon[j].y

      if (p.x * q.y - p.y * q.x) * winding < 0
        return false
    return true


  linearToGamma: (linear_colors...) =>
    linear_colors = getGammaArgs(linear_colors)

    for c in linear_colors
      c /= 255
      if c > 1
        c = 1
      else if c < 0
        c = 0
      else if c <= 0.04045
        c /= 12.92
      else
        c = window.Math.pow((c + 0.055) / 1.055, 2.4)
      c *= 255

  newBezierCurve: (vertices...) =>
    if vertices.length == 1
      vertices = if vertices[0].__shine
          # make up for lua being one-indexed with the slice
          vertices[0].__shine.numValues.slice(1, vertices[0].__shine.numValues.length)
        else
          vertices[0]

    controlPoints = for i in [0...vertices.length] by 2
      x: vertices[i]
      y: vertices[i + 1]

    new @constructor.BezierCurve(controlPoints)

  newRandomGenerator: (low, high) =>
    r = new Love.Math.RandomGenerator()
    if low
      r.setSeed(r, low, high)
    return r

  noise: (dimensions...) =>
    switch dimensions.length
      when 1 then @simplex.noise1D(dimensions[0])
      when 2 then @simplex.noise2D(dimensions[0], dimensions[1])
      when 3 then @simplex.noise3D(dimensions[0], dimensions[1], dimensions[2])
      when 4 then @simplex.noise4D(dimensions[0], dimensions[1], dimensions[2], dimensions[3])

  random: (min, max) =>
    @random_generator.random(@random_generator, min, max)

  randomNormal: (stddev = 1, mean = 0) =>
    @random_generator.randomNormal(@random_generator, stddev, mean)

  setRandomSeed: (low, high) =>
    @random_generator.setSeed(@random_generator, low, high)

  triangulate: (vertices...) =>
    polygon = toPolygon(vertices)

    next_idx = new Array(polygon.length)
    prev_idx = new Array(polygon.length)
    idx_lm = 0

    for i in [0...polygon.length]
      lm = polygon[idx_lm]
      p = polygon[i]
      if p.x < lm.x or (p.x == lm.x and p.y < lm.y)
        idx_lm = i
      next_idx[i] = i+1
      prev_idx[i] = i-1
    next_idx[next_idx.length-1] = 0
    prev_idx[0] = prev_idx.length-1

    if !is_oriented_ccw(polygon[prev_idx[idx_lm]], polygon[idx_lm], polygon[next_idx[idx_lm]])
      [next_idx, prev_idx] = [prev_idx, next_idx]

    concave_vertices = []
    for i in [0...polygon.length]
      if !is_oriented_ccw(polygon[prev_idx[i]], polygon[i], polygon[next_idx[i]])
        concave_vertices.push(polygon[i])

    triangles = []
    n_vertices = polygon.length
    [current, skipped, next, prev] = [1, 0]
    while n_vertices > 3
      next = next_idx[current]
      prev = prev_idx[current]
      a = polygon[prev]
      b = polygon[current]
      c = polygon[next]

      if is_ear(a,b,c, concave_vertices)
        triangles.push([a,b,c])
        next_idx[prev] = next
        prev_idx[next] = prev
        concave_vertices.splice(concave_vertices.indexOf(b), 1)
        --n_vertices
        skipped = 0
      else if ++skipped > n_vertices
        console.log "Cannot triangulate polygon."

      current = next

    next = next_idx[current]
    prev = prev_idx[current]

    triangles.push([polygon[prev], polygon[current], polygon[next]])

    return triangles

  getGammaArgs = (colors) ->
    if colors.length == 1 and colors[0] instanceof Object
      colors = if colors[0].__shine
          # make up for lua being one-indexed with the slice
          colors[0].__shine.numValues.slice(1, colors[0].__shine.numValues.length)
        else
          colors[0]
    else
      colors

  toPolygon = (vertices) ->
    if vertices.length == 1
      vertices = if vertices[0].__shine
          # make up for lua being one-indexed with the slice
          vertices[0].__shine.numValues.slice(1, vertices[0].__shine.numValues.length)
        else
          vertices[0]

    for i in [0...vertices.length] by 2
      x: vertices[i]
      y: vertices[i + 1]

  # check if an angle is oriented counter clockwise
  is_oriented_ccw = (a, b, c) ->
    return ((b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)) >= 0

  # check if a and b are on the same side of the line c->d
  on_same_side = (a, b, c, d) ->
    px = d.x - c.x
    py = d.y - c.y
    l = px * (a.y - c.y) - py * (a.x - c.x)
    m = px * (b.y - c.y) - py * (b.x - c.x)
    return l * m >= 0

  # checks is p is contained in the triangle abc
  point_in_triangle = (p, a, b, c) ->
    return on_same_side(p,a, b,c) and on_same_side(p,b, a,c) and on_same_side(p,c, a,b)

  # checks if any vertex in `vertices` is in the triangle abc.
  any_point_in_triangle = (vertices, a, b, c) ->
    for p in vertices
      if (p.x != a.x and p.y != a.y) and (p.x != b.x and p.y != a.y) and (p.x != c.x and p.y != a.y) and point_in_triangle(p, a,b,c)
        true
    false

  is_ear = (a, b, c, vertices) ->
    is_oriented_ccw(a,b,c) and !any_point_in_triangle(vertices, a,b,c)
