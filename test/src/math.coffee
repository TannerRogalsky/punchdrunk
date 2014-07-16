describe 'love.math', ->
  it 'exists', ->
    expect(Love.Math).to.be.a("function")

  describe '.noise', ->
    noise = null
    math = null
    beforeEach ->
      math = new Love.Math()
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
      random = new Love.Math().random

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
    [math, random] = []
    beforeEach ->
      math = new Love.Math()
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
    [math, random] = []
    beforeEach ->
      math = new Love.Math()
      random = math.random

    it 'should return the same numbers passed to setRandomSeed', ->
      [seed_low, seed_high] = [100, 200]
      math.setRandomSeed(seed_low, seed_high)
      expect(math.getRandomSeed()).to.eql([seed_low, seed_high])
