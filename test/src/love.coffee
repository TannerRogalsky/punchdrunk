describe "love", ->
  it 'exists', ->
    expect(Love).to.be.a("function")

  describe 'constructor', ->
    describe 'when invoked without parameters', ->
      it 'should provide sensible defaults', ->
        love = new Love()

        expect(love.graphics).to.be.ok
        expect(love.window).to.be.ok
        expect(love.timer).to.be.ok
        expect(love.event).to.be.ok
        expect(love.keyboard).to.be.ok
        expect(love.mouse).to.be.ok
        expect(love.touch).to.be.ok
        expect(love.filesystem).to.be.ok
        expect(love.audio).to.be.ok
        expect(love.system).to.be.ok
        expect(love.image).to.be.ok
        expect(love.math).to.be.ok

        expect(love.graphics.getWidth()).to.equal(800)
        expect(love.graphics.getHeight()).to.equal(600)

        expect(love.load).to.be.a("function")
        expect(love.update).to.be.a("function")
        expect(love.mousepressed).to.be.a("function")
        expect(love.mousereleased).to.be.a("function")
        expect(love.touchpressed).to.be.a("function")
        expect(love.touchreleased).to.be.a("function")
        expect(love.touchmoved).to.be.a("function")
        expect(love.keypressed).to.be.a("function")
        expect(love.keyreleased).to.be.a("function")
        expect(love.draw).to.be.a("function")
        expect(love.quit).to.be.a("function")

    describe 'when invoked with parameters', ->
      it 'uses the element specified', ->
        canvas = document.createElement('canvas')
        love = new Love(canvas)

        expect(Love.element).to.equal(canvas)

      it 'reads the width and height from element', ->
        canvas = document.createElement('canvas')
        canvas.setAttribute('width', 320)
        canvas.setAttribute('height', 200)

        love = new Love(canvas)

        expect(love.graphics.getWidth()).to.equal(320)
        expect(love.graphics.getHeight()).to.equal(200)

      it 'uses the specified dimensions', ->
        love = new Love(null, {
          width: 900
          height: 300
        })

        expect(love.graphics.getWidth()).to.equal(900)
        expect(love.graphics.getHeight()).to.equal(300)
