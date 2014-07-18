describe 'love.math', ->
  it 'exists', ->
    expect(Love.Math).to.be.a("function")

  math = null
  beforeEach ->
    math = new Love.Math()

  describe '.noise', ->
    noise = null
    beforeEach ->
      noise = math.noise

    describe 'when called with one argument', ->
      it 'should return the same value for the same input', ->
        expect(noise(0.1)).to.equal(noise(0.1))

      it 'should return a different value for a different input', ->
        expect(noise(0.1)).to.not.equal(noise(0.2))

      it 'should return values between -1 and 1', ->
        for x in [0..10]
          expect(noise(x)).to.be.within(-1, 1)

      it 'should return similar values for similar inputs', ->
        expect(Math.abs(noise(0.1) - noise(0.101))).to.be.below(0.1).and.above(0)

      it 'should invoke the correct function in the underlying library', ->
        noise1D = sinon.spy(math.simplex, "noise1D")
        noise(0.1)
        expect(noise1D).to.have.been.called

    describe 'when called with two arguments', ->
      it 'should return the same value for the same input', ->
        expect(noise(0.1, 0.2)).to.equal(noise(0.1, 0.2))

      it 'should return a different value for a different input', ->
        expect(noise(0.1, 0.1)).to.not.equal(noise(0.2, 0.2))

      it 'should return values between -1 and 1', ->
        for x in [0..10]
          for y in [0..10]
            expect(noise(x, y)).to.be.within(-1, 1)

      it 'should return similar values for similar inputs', ->
        expect(Math.abs(noise(0.1, 0.2) - noise(0.101, 0.201))).to.be.below(0.1).and.above(0)

      it 'should invoke the correct function in the underlying library', ->
        noise2D = sinon.spy(math.simplex, "noise2D")
        noise(0.1, 0.2)
        expect(noise2D).to.have.been.called

    describe 'when called with three arguments', ->
      it 'should return the same value for the same input', ->
        expect(noise(0.1, 0.2, 0.3)).to.equal(noise(0.1, 0.2, 0.3))

      it 'should return a different value for a different input', ->
        expect(noise(0.1, 0.1, 0.1)).to.not.equal(noise(0.2, 0.2, 0.2))

      it 'should return values between -1 and 1', ->
        for i in [0..10]
          for j in [0..10]
            expect(noise(i / 5, j / 5, i + j)).to.be.within(-1, 1)

      it 'should return similar values for similar inputs', ->
        expect(Math.abs(noise(0.1, 0.2, 0.3) - noise(0.101, 0.201, 0.301))).to.be.below(0.1).and.above(0)

      it 'should invoke the correct function in the underlying library', ->
        noise3D = sinon.spy(math.simplex, "noise3D")
        noise(0.1, 0.2, 0.3)
        expect(noise3D).to.have.been.called

    describe 'when called with four arguments', ->
      it 'should return the same value for the same input', ->
        expect(noise(0.1, 0.2, 0.3, 0.4)).to.equal(noise(0.1, 0.2, 0.3, 0.4))

      it 'should return a different value for a different input', ->
        expect(noise(0.1, 0.1, 0.1, 0.1)).to.not.equal(noise(0.2, 0.2, 0.2, 0.2))

      it 'should return values between -1 and 1', ->
        for i in [0..10]
          for j in [0..10]
            expect(noise(i / 5, j / 5, i + j, i - j)).to.be.within(-1, 1)

      it 'should return similar values for similar inputs', ->
        expect(Math.abs(noise(0.1, 0.2, 0.3, 0.4) - noise(0.101, 0.201, 0.301, 0.401))).to.be.below(0.1).and.above(0)

      it 'should invoke the correct function in the underlying library', ->
        noise4D = sinon.spy(math.simplex, "noise4D")
        noise(0.1, 0.2, 0.3, 0.4)
        expect(noise4D).to.have.been.called

  describe '.random', ->
    random = null
    beforeEach ->
      random = math.random

    describe 'when called with no arguments', ->
      it 'should return a value between 0 and 1', ->
        expect(random()).to.be.within(0, 1)

    describe 'when called with one argument', ->
      it 'should return a value between 1 and the argument, inclusively', ->
        expect(random(10)).to.be.within(1, 10 + 1)

    describe 'when called with two arguments', ->
      it 'should return a value between the two arguments, inclusively', ->
        expect(random(5, 10)).to.be.within(5, 10 + 1)

  describe '.setRandomSeed', ->
    random = null
    beforeEach ->
      random = math.random

    it 'should result in the same random numbers when passed the same args', ->
      [seed_low, seed_high] = [100, 200]

      math.setRandomSeed(seed_low, seed_high)
      result_set_a = for i in [1..5]
        random()

      math.setRandomSeed(seed_low, seed_high)
      result_set_b = for i in [1..5]
        random()

      expect(result_set_a).to.eql(result_set_b)

  describe '.getRandomSeed', ->
    random = null
    beforeEach ->
      random = math.random

    it 'should return the same numbers passed to setRandomSeed', ->
      [seed_low, seed_high] = [100, 200]
      math.setRandomSeed(seed_low, seed_high)
      expect(math.getRandomSeed()).to.eql([seed_low, seed_high])
      random()
      expect(math.getRandomSeed()).to.eql([seed_low, seed_high])

  describe '.gammaToLinear', ->
    it 'should be reversed by linearToGamma', ->
      rounding_error_margin = 0.1
      [gr, gg, gb] = [120, 50, 100]
      [lr, lg, lb] = math.gammaToLinear(gr, gg, gb)
      [rr, rg, rb] = math.linearToGamma(lr, lg, lb)
      expect(rr).to.be.closeTo(gr, rounding_error_margin)
      expect(rg).to.be.closeTo(gg, rounding_error_margin)
      expect(rb).to.be.closeTo(gb, rounding_error_margin)

    describe 'when called with three separate color components', ->
      it 'should return three linear-space color components', ->
        [gr, gg, gb] = [120, 50, 100]
        [lr, lg, lb] = math.gammaToLinear(gr, gg, gb)
        expect(lr).to.be.ok
        expect(lg).to.be.ok
        expect(lb).to.be.ok

    describe 'when called with a sequence of color components', ->
      it 'should return three linear-space color components', ->
        [gr, gg, gb] = [120, 50, 100]
        [lr, lg, lb] = math.gammaToLinear(gr, gg, gb)
        expect(lr).to.be.ok
        expect(lg).to.be.ok
        expect(lb).to.be.ok

    describe 'when called with one color component', ->
      it 'should return three linear-space color components', ->
        [gr, gg, gb] = [120, 50, 100]
        [lr, lg, lb] = math.gammaToLinear(gr, gg, gb)
        expect(lr).to.be.ok
        expect(lg).to.be.ok
        expect(lb).to.be.ok

  describe '.isConvex', ->
    it 'returns true for a convex polygon', ->
      vertices = [0,0, 0,100, 100,100, 100,0]
      expect(math.isConvex(vertices)).to.be.true

    it 'returns false for a non-convex polygon', ->
      vertices = [0,0, 0,100, -100,-100, 100,0]
      expect(math.isConvex(vertices)).to.be.false

  describe '.linearToGamma', ->
    it 'should be reversed by gammaToLinear', ->
      rounding_error_margin = 0.1
      [lr, lg, lb] = [120, 50, 100]
      [gr, gg, gb] = math.linearToGamma(lr, lg, lb)
      [rr, rg, rb] = math.gammaToLinear(gr, gg, gb)
      expect(rr).to.be.closeTo(lr, rounding_error_margin)
      expect(rg).to.be.closeTo(lg, rounding_error_margin)
      expect(rb).to.be.closeTo(lb, rounding_error_margin)

    describe 'when called with three separate color components', ->
      it 'should return three gamma-space color components', ->
        [lr, lg, lb] = [120, 50, 100]
        [gr, gg, gb] = math.linearToGamma(lr, lg, lb)
        expect(gr).to.be.ok
        expect(gg).to.be.ok
        expect(gb).to.be.ok

    describe 'when called with a sequence of color components', ->
      it 'should return three gamma-space color components', ->
        linear_colors = [120, 50, 100]
        [gr, gg, gb] = math.linearToGamma(linear_colors)
        expect(gr).to.be.ok
        expect(gg).to.be.ok
        expect(gb).to.be.ok

    describe 'when called with one color component', ->
      it 'should return one gamma-space color component', ->
        linear_color = 120
        [gr, gg, gb] = math.linearToGamma(linear_color)
        expect(gr).to.be.ok
        expect(gg).to.be.undefined
        expect(gb).to.be.undefined

  describe '.newBezierCurve', ->
    it 'should return a new bezier curve comprised of the vertices that were passed', ->
      controls_points = [100,100, 125,125, 100,125]
      bezier = math.newBezierCurve(controls_points)
      for i in [0...3]
        [x, y] = bezier.getControlPoint(bezier, i)
        expect(x).to.equal(controls_points[i * 2])
        expect(y).to.equal(controls_points[i * 2 + 1])

  describe '.newRandomGenerator', ->
    it 'should return a new RandomGenerator object', ->
      expect(math.newRandomGenerator()).to.be.an.instanceof(Love.Math.RandomGenerator)

    it 'should use the seed passed to it', ->
      [low_s, high_s] = [100, 200]
      r = math.newRandomGenerator(low_s, high_s)
      [low, high] = r.getSeed(r)
      expect(low_s).to.equal(low)
      expect(high_s).to.equal(high)

  describe '.randomNormal', ->
    it ''

  describe '.triangulate', ->
    it 'should return two triangles when you pass it a rectangular polygon', ->
      vertices = [0,0, 0,100, 100,100, 100,0]
      triangles = math.triangulate(vertices)
      expect(triangles.length).to.equal(2)

    it 'should handle concave polygons', ->
      vertices = [0,0, 0,100, -100,-100, 100,0]
      triangles = math.triangulate(vertices)
      expect(triangles.length).to.equal(2)

    it 'should handle clockwise vertices', ->
      vertices = [0,0, 100,0, 100,100, 0,100]
      triangles = math.triangulate(vertices)
      expect(triangles.length).to.equal(2)

