describe "love.keyboard", ->
  dispatchKeyboardEvent = (eventType, key) ->
    evt = document.createEvent("Events")
    evt.initEvent(eventType, true, true)
    evt.keyCode = key.charCodeAt(0)
    evt.which = key.charCodeAt(0)
    evt.shiftKey = true
    Love.element.dispatchEvent(evt)

  it 'exists', ->
    expect(Love.Keyboard).to.be.a("function")

  it 'pushes a "keypressed" event onto the queue when a key is pressed', ->
    love = new Love()
    key = "E"
    dispatchKeyboardEvent("keydown", key)
    evt = love.event.internalQueue[0]
    expect(evt).to.be.ok
    expect(evt.eventType).to.equal("keypressed")
    expect(evt.arg1).to.equal(key)
    expect(evt.arg2).to.equal(key.charCodeAt(0))

  it 'pushes a "keyreleased" event onto the queue when a key is pressed', ->
    love = new Love()
    key = "E"
    dispatchKeyboardEvent("keyup", key)
    evt = love.event.internalQueue[0]
    expect(evt).to.be.ok
    expect(evt.eventType).to.equal("keyreleased")
    expect(evt.arg1).to.equal(key)
    expect(evt.arg2).to.equal(key.charCodeAt(0))

  describe '.isDown', ->
    love = null
    beforeEach ->
      love = new Love()
      dispatchKeyboardEvent("keydown", "E")

    it 'should return true if the key passed it is down', ->
      expect(love.keyboard.isDown("E")).to.be.true

    it 'should return false if the key passed it is not down', ->
      expect(love.keyboard.isDown("h")).to.be.false

    it 'should return false if any of the keys passed to it are not down', ->
      expect(love.keyboard.isDown("E", "h")).to.be.false
      expect(love.keyboard.isDown("h", "E")).to.be.false
      expect(love.keyboard.isDown("h", "E", "q")).to.be.false
