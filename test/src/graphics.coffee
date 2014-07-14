describe "love.graphics", ->
  it 'exists', ->
    expect(Love.Graphics).to.be.a("function")

  describe 'constructor', ->
    beforeEach ->
      # Is the need for this indicative of something bad?
      Love.element = null

    describe 'when called without arguments', ->
      it 'uses default values for width and height', ->
        graphics = new Love.Graphics()
        expect(graphics.getWidth()).to.equal(800)
        expect(graphics.getHeight()).to.equal(600)

    describe 'when called with arguments', ->
      it 'uses those arguments for the width and height of the graphics context', ->
        [width, height] = [300, 400]
        graphics = new Love.Graphics(width, height)
        expect(graphics.getWidth()).to.equal(width)
        expect(graphics.getHeight()).to.equal(height)

    it 'creates a default canvas rendering context', ->
      graphics = new Love.Graphics()
      expect(graphics.default_canvas).to.be.an.instanceOf(Love.Graphics.Canvas2D)

    it 'sets the default background and foreground colors', ->
      graphics = new Love.Graphics()
      expect(graphics.getColor()).to.eql(new Love.Color(255, 255, 255).unpack())
      expect(graphics.getBackgroundColor()).to.eql(new Love.Color(0, 0, 0).unpack())
