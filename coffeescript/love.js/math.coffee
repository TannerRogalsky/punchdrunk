class MathModule
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
      # when 1 then
      when 2 then @simplex.noise2D(dimensions[0], dimensions[1])
      when 3 then @simplex.noise3D(dimensions[0], dimensions[1], dimensions[2])
      when 4 then @simplex.noise4D(dimensions[0], dimensions[1], dimensions[2], dimensions[3])

  random: =>
  randomNormal: =>
  setRandomSeed: =>
  triangulate: =>
