class Love.MathModule
  constructor: () ->
    @simplex = new SimplexNoise()

  gammaToLinear: =>
  getRandomSeed: =>
  isConvex: =>
  linearToGamma: =>
  newBezierCurve: =>
  newRandomGenerator: =>
  noise: (dimensions...) =>
    switch dimensions.length
      when 1 then @simplex.noise1D(dimensions[0])
      when 2 then @simplex.noise2D(dimensions[0], dimensions[1])
      when 3 then @simplex.noise3D(dimensions[0], dimensions[1], dimensions[2])
      when 4 then @simplex.noise4D(dimensions[0], dimensions[1], dimensions[2], dimensions[3])

  random: (min, max) =>
    if min == undefined && max == undefined
      return Math.random()

    if max == undefined
      max = min
      min = 1

    Math.floor(Math.random() * (max - min + 1) + min)

  randomNormal: =>
  setRandomSeed: =>
  triangulate: =>
