describe "love.touch", ->
  [targetTouches] = [[]]
  dispatchTouchEvent = (eventType, id, x, y) ->
    evt = document.createEvent("Events")
    evt.initEvent(eventType, true, true)

    switch eventType
      when "touchstart"
        targetTouches.push
          identifier: id
          pageX: x
          pageY: y
      when 'touchmove'
        for targetTouche in targetTouches
          if targetTouche.identifier = id
            [targetTouche.pageX, targetTouche.pageY] = [x, y]
      when 'touchend'
        targetTouches = []
        evt.changedTouches = []
        evt.changedTouches.push
          identifier: id
          pageX: x
          pageY: y

    evt.targetTouches = targetTouches
    evt.changedTouches ||= []

    Love.element.dispatchEvent(evt)

  it 'exists', ->
    expect(Love.Touch).to.be.a("function")

  [love] = []
  beforeEach ->
    love = new Love()

  afterEach ->
    targetTouches = []

  describe 'touchpressed', ->
    it 'should push an event onto the queue when the canvas is touched', ->
      [id, x, y] = [1, 100, 200]
      dispatchTouchEvent("touchstart", id, x, y)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("touchpressed")
      expect(evt.arg1).to.equal(id)
      expect(evt.arg2).to.equal(x)
      expect(evt.arg3).to.equal(y)

  describe 'touchmoved', ->
    [id, x, y] = [1, 100, 200]
    beforeEach ->
      dispatchTouchEvent("touchstart", id, x, y)
      love.event.clear() # simulate a frame tick

    it 'should push an event onto the queue when a touch moves', ->
      [newx, newy] = [x + 1, y + 2]
      dispatchTouchEvent("touchmove", id, newx, newy)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("touchmoved")
      expect(evt.arg1).to.equal(id)
      expect(evt.arg2).to.equal(newx)
      expect(evt.arg3).to.equal(newy)

  describe 'touchreleased', ->
    [id, x, y] = [1, 100, 200]
    beforeEach ->
      dispatchTouchEvent("touchstart", id, x, y)
      love.event.clear() # simulate a frame tick

    it 'should push an event onto the queue when a touch ends', ->
      dispatchTouchEvent("touchend", id, x, y)
      evt = love.event.internalQueue[0]
      expect(evt).to.be.ok
      expect(evt.eventType).to.equal("touchreleased")
      expect(evt.arg1).to.equal(id)
      expect(evt.arg2).to.equal(x)
      expect(evt.arg3).to.equal(y)

  describe 'getTouch', ->
    it ''

  describe 'getTouchCount', ->
    it ''
