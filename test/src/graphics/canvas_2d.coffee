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

      describe 'drawDrawable', ->
        [save,translate,rotate,scale,transform,drawImage,restore] = []
        beforeEach ->
          save = sinon.spy(canvas.context, 'save')
          translate = sinon.spy(canvas.context, 'translate')
          rotate = sinon.spy(canvas.context, 'rotate')
          scale = sinon.spy(canvas.context, 'scale')
          transform = sinon.spy(canvas.context, 'transform')
          drawImage = sinon.spy(canvas.context, 'drawImage')
          restore = sinon.spy(canvas.context, 'restore')

        it 'should call the appropriate 2D context functions', ->
          image = new Love.Graphics.Image("sprites.png")
          [x,y,r,sx,sy,ox,oy,kx,ky] = [100, 100, Math.PI, 2, 5, 50, 50, 3, 4]
          canvas.draw(image, x, y, r, sx, sy, ox, oy, kx, y)

          expect(drawImage).to.be.calledWith(image.element, 0, 0)
          expect(save).to.be.called
          expect(restore).to.be.called
          expect(translate).to.be.calledWith(x, y)
          expect(translate).to.be.calledWith(-ox, -oy)
          expect(rotate).to.be.calledWith(r)
          expect(scale).to.be.calledWith(sx, sy)

      it 'calls drawWithQuad if you pass it a quad', ->
        image = new Love.Graphics.Image("sprites.png")
        quad = new Love.Graphics.Quad(3, 3, 1, 1)
        drawWithQuad = sinon.spy(canvas, 'drawWithQuad')
        canvas.draw(image, quad, 100, 100)
        expect(drawWithQuad).to.be.calledOnce

      describe 'drawWithQuad', ->
        [save,translate,rotate,scale,transform,drawImage,restore] = []
        beforeEach ->
          save = sinon.spy(canvas.context, 'save')
          translate = sinon.spy(canvas.context, 'translate')
          rotate = sinon.spy(canvas.context, 'rotate')
          scale = sinon.spy(canvas.context, 'scale')
          transform = sinon.spy(canvas.context, 'transform')
          drawImage = sinon.spy(canvas.context, 'drawImage')
          restore = sinon.spy(canvas.context, 'restore')

        it 'should call the appropriate 2D context functions', ->
          image = new Love.Graphics.Image("sprites.png")
          quad = new Love.Graphics.Quad(3, 3, 1, 1)
          [x,y,r,sx,sy,ox,oy,kx,ky] = [100, 100, Math.PI, 2, 5, 50, 50, 3, 4]
          canvas.draw(image, quad, x, y, r, sx, sy, ox, oy, kx, y)

          expect(drawImage).to.be.calledWith(image.element, quad.x, quad.y, quad.width, quad.height, 0, 0, quad.width, quad.height)
          expect(save).to.be.called
          expect(restore).to.be.called
          expect(translate).to.be.calledWith(x, y)
          expect(translate).to.be.calledWith(-ox, -oy)
          expect(rotate).to.be.calledWith(r)
          expect(scale).to.be.calledWith(sx, sy)

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
