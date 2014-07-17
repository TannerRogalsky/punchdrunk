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
    if vertices.length == 1
      vertices = if vertices[0].__shine
          # make up for lua being one-indexed with the slice
          vertices[0].__shine.numValues.slice(1, vertices[0].__shine.numValues.length)
        else
          vertices[0]

    polygon = []
    for i in [0...vertices.length] by 2
      polygon.push
        x: vertices[i]
        y: vertices[i + 1]

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

  newBezierCurve: =>

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

  triangulate: =>

  getGammaArgs = (colors) ->
    if colors.length == 1 and colors[0] instanceof Object
      colors = if colors[0].__shine
          # make up for lua being one-indexed with the slice
          colors[0].__shine.numValues.slice(1, colors[0].__shine.numValues.length)
        else
          colors[0]
    else
      colors
