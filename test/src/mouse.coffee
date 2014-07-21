describe "love.mouse", ->
  mouseButtonNumbers =
    l: 1
    m: 2
    r: 3

  dispatchMouseEvent = (eventType, button, x, y, dw) ->
    evt = document.createEvent("Events")
    evt.initEvent(eventType, true, true)

    evt.which = mouseButtonNumbers[button]
    [evt.pageX, evt.pageY] = [x, y]
    evt.wheelDelta = dw

    Love.element.dispatchEvent(evt)

  it 'exists', ->
    expect(Love.Mouse).to.be.a("function")

  [love] = []
  beforeEach ->
    love = new Love()

  describe 'mousepressed', ->
    it 'should put an event onto the queue when the mouse is pressed', ->
      [button, x, y] = ['l', 100, 200]
      dispatchMouseEvent("mousemove", null, x, y)
      love.event.clear()
      dispatchMouseEvent("mousedown", button)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("mousepressed")
      expect(evt.arg1).to.equal(x)
      expect(evt.arg2).to.equal(y)
      expect(evt.arg3).to.equal(button)

    it 'should put two events onto the queue when the mouse wheel is spun and then stopped', (done) ->
      [x, y, wheel_move] = [0, 0, 1]
      dispatchMouseEvent("mousewheel", null, x, y, wheel_move)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("mousepressed")
      expect(evt.arg1).to.equal(x)
      expect(evt.arg2).to.equal(y)
      expect(evt.arg3).to.equal("wu")
      love.event.clear()
      setTimeout =>
        evt = love.event.internalQueue[0]
        expect(evt).to.be.ok
        expect(evt.eventType).to.equal("mousereleased")
        expect(evt.arg1).to.equal(x)
        expect(evt.arg2).to.equal(y)
        expect(evt.arg3).to.equal("wu")
        love.event.clear()
        done()
      , Love.Mouse.WHEEL_TIMEOUT * 1000 * 1.1

  describe 'mousereleased', ->
    it 'should put an event onto the queue when the mouse is released', ->
      [button, x, y] = ['l', 100, 200]
      dispatchMouseEvent("mousemove", null, x, y)
      love.event.clear()
      dispatchMouseEvent("mouseup", button)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("mousereleased")
      expect(evt.arg1).to.equal(x)
      expect(evt.arg2).to.equal(y)
      expect(evt.arg3).to.equal(button)

  describe 'getCursor', ->
    it ''

  describe 'getPosition', ->
    it ''

  describe 'getSystemCursor', ->
    it ''

  describe 'getX', ->
    it ''

  describe 'getY', ->
    it ''

  describe 'isDown', ->
    it ''

  describe 'isGrabbed', ->
    it ''

  describe 'isVisible', ->
    it ''

  describe 'newCursor', ->
    it ''

  describe 'setCursor', ->
    it ''

  describe 'setGrabbed', ->
    it ''

  describe 'setPosition', ->
    it ''

  describe 'setVisible', ->
    it ''

  describe 'setX', ->
    it ''

  describe 'setY', ->
    it ''
