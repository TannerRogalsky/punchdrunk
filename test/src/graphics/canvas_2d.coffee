describe "love.graphics.canvas_2d", ->
  it 'exists', ->
    expect(Love.Graphics.Canvas2D).to.be.a("function")

  describe 'constructor', ->
    it 'sets the dimensions passed to it', ->
      [width, height] = [300, 400]
      canvas = new Love.Graphics.Canvas2D(width, height)
      expect(canvas.getWidth()).to.equal(width)
      expect(canvas.getHeight()).to.equal(height)

  describe 'drawing methods', ->
    canvas = null
    beforeEach ->
      canvas = new Love.Graphics.Canvas2D(400, 300)

    describe 'arc', ->
      [radius, beginPath, moveTo, lineTo, closePath, fill, stroke] = []
      beforeEach ->
        radius = 20
        beginPath = sinon.spy(canvas.context, 'beginPath')
        moveTo = sinon.spy(canvas.context, 'moveTo')
        lineTo = sinon.spy(canvas.context, 'lineTo')
        closePath = sinon.spy(canvas.context, 'closePath')
        fill = sinon.spy(canvas.context, 'fill')
        stroke = sinon.spy(canvas.context, 'stroke')

      describe 'when called with a "fill" draw mode', ->
        it 'should call the appropriate 2D context functions', ->
          canvas.arc("fill", 0, 0, radius, 0, Math.PI)

          expect(beginPath).to.be.calledOnce
          expect(moveTo).to.be.calledOnce
          expect(lineTo).to.be.callCount(radius + 1)
          expect(closePath).to.be.calledOnce
          expect(fill).to.be.calledOnce

      describe 'when called with a "stroke" draw mode', ->
        it 'should call the appropriate 2D context functions', ->
          canvas.arc("line", 0, 0, radius, 0, Math.PI)

          expect(beginPath).to.be.calledOnce
          expect(moveTo).to.be.calledOnce
          expect(lineTo).to.be.callCount(radius + 1)
          expect(closePath).to.be.calledOnce
          expect(stroke).to.be.calledOnce

    describe 'circle', ->
      it ''

    describe 'clear', ->
      it ''

    describe 'draw', ->
      it 'calls drawDrawable if you do not pass it a quad', ->
        image = new Love.Graphics.Image("sprites.png")
        drawDrawable = sinon.spy(canvas, 'drawDrawable')
        canvas.draw(image, 100, 100)
        expect(drawDrawable).to.be.calledOnce

      it 'calls drawWithQuad if you pass it a quad', ->
        image = new Love.Graphics.Image("sprites.png")
        quad = new Love.Graphics.Quad(25, 25, 50, 50)
        drawWithQuad = sinon.spy(canvas, 'drawWithQuad')
        canvas.draw(image, quad, 100, 100)
        expect(drawWithQuad).to.be.calledOnce

    describe 'line', ->
      it ''

    describe 'point', ->
      it ''

    describe 'polygon', ->
      it ''

    describe 'print', ->
      it ''

    describe 'printf', ->
      it ''

    describe 'rectangle', ->
      it ''
