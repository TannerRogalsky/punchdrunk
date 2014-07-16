describe 'love.event', ->
  it 'exists', ->
    expect(Love.EventQueue).to.be.a("function")

  describe 'constructor', ->
    it 'creates an internal queue', ->
      eventQueue = new Love.EventQueue()

      expect(eventQueue.internalQueue).to.be.ok

  describe 'push', ->
    it 'should accept a variable number of arguments up to four', ->
      eventQueue = new Love.EventQueue()
      eventQueue.push("test_event", 1, 2, 3, 4)

      event = eventQueue.internalQueue[0]

      expect(event.eventType).to.equal("test_event")
      expect(event.arg1).to.equal(1)
      expect(event.arg2).to.equal(2)
      expect(event.arg3).to.equal(3)
      expect(event.arg4).to.equal(4)

  describe 'quit', ->
    it 'should push the quit event onto the queue', ->
      eventQueue = new Love.EventQueue()
      eventQueue.quit()

      event = eventQueue.internalQueue[0]
      expect(event.eventType).to.equal("quit")
