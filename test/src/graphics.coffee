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

  describe 'drawing methods', ->
    graphics = null
    canvas = null
    beforeEach ->
      graphics = new Love.Graphics()
      canvas = graphics.canvas

    describe 'arc', ->
      it 'should call the current canvas\'s arc method', ->
        arc = sinon.spy(canvas, 'arc')
        graphics.arc("fill", 0, 0, 20, 0, Math.PI)
        expect(arc).to.have.been.called

    describe 'circle', ->
      it 'should call the current canvas\'s circle method', ->
        circle = sinon.spy(canvas, 'circle')
        graphics.circle("fill", 0, 0, 20)
        expect(circle).to.have.been.called

    describe 'clear', ->
      it 'should call the current canvas\'s clear method', ->
        clear = sinon.spy(canvas, 'clear')
        graphics.clear()
        expect(clear).to.have.been.called

    describe 'draw', ->
      it 'should call the current canvas\'s draw method', ->
        draw = sinon.spy(canvas, 'draw')
        graphics.draw(new Love.Graphics.Image("sprites.png"), 100, 100)
        expect(draw).to.have.been.called

    describe 'line', ->
      it 'should call the current canvas\'s line method', ->
        line = sinon.spy(canvas, 'line')
        graphics.line(0, 0, 100, 100, 100, 0)
        expect(line).to.have.been.called

    describe 'point', ->
      it 'should call the current canvas\'s point method', ->
        point = sinon.spy(canvas, 'point')
        graphics.point(100, 100)
        expect(point).to.have.been.called

    describe 'polygon', ->
      it 'should call the current canvas\'s polygon method', ->
        polygon = sinon.spy(canvas, 'polygon')
        graphics.polygon("fill", 0, 0, 100, 100, 100, 0)
        expect(polygon).to.have.been.called

    describe 'print', ->
      it 'should call the current canvas\'s print method', ->
        print = sinon.spy(canvas, 'print')
        graphics.print("test", 100, 100)
        expect(print).to.have.been.called

    describe 'printf', ->
      it 'should call the current canvas\'s printf method', ->
        printf = sinon.spy(canvas, 'printf')
        graphics.printf("test", 100, 100, 200)
        expect(printf).to.have.been.called

    describe 'rectangle', ->
      it 'should call the current canvas\'s rectangle method', ->
        rectangle = sinon.spy(canvas, 'rectangle')
        graphics.rectangle("test", 100, 100, 25, 50)
        expect(rectangle).to.have.been.called
