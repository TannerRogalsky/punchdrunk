describe 'love.math', ->
  it 'exists', ->
    expect(Love.MathModule).to.be.a("function")

  describe '.noise', ->
    noise = null
    beforeEach ->
      noise = new Love().math.noise

    describe 'when called with one argument', ->
      it 'should return the same value for the same input', ->
        expect(noise(0.1)).to.equal(noise(0.1))

      it 'should return a different value for a different input', ->
        expect(noise(0.1)).to.not.equal(noise(0.2))

      it 'should return values between -1 and 1', ->
        for i in [0..10]
          expect(noise(i)).to.be.above(-1).and.below(1)

      it 'should return similar values for similar inputs', ->
        expect(Math.abs(noise(0.1) - noise(0.101))).to.be.below(0.1)

    describe 'when called with two arguments', ->
      it 'should return the same value for the same input'
      it 'should return a different value for a different input'
      it 'should return values between -1 and 1'
      it 'should return similar values for similar inputs'

    describe 'when called with three arguments', ->
      it 'should return the same value for the same input'
      it 'should return a different value for a different input'
      it 'should return values between -1 and 1'
      it 'should return similar values for similar inputs'

    describe 'when called with four arguments', ->
      it 'should return the same value for the same input'
      it 'should return a different value for a different input'
      it 'should return values between -1 and 1'
      it 'should return similar values for similar inputs'

  describe '.random', ->
    describe 'when called with no arguments', ->
      it 'should return a value between 0 and 1'

    describe 'when called with one argument', ->
      it 'should return a value between 0 and the argument'

    describe 'when called with two arguments', ->
      it 'should return a value between the two arguments'
