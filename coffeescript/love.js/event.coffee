class EventQueue
  constructor: () ->
    @internalQueue = []

  clear: () =>
    @internalQueue = []

  # TODO: this will require some understanding custom iterators in JS and Lua
  poll: () =>

  # This doesn't need to do anything in JS.
  pump: () =>

  push: (eventType, args...) =>
    newEvent = new Event(eventType, args...)
    @internalQueue.push(newEvent)

  quit: () =>

  wait: () =>

  # PRIVATE
  class Event
    constructor: (@eventType, @arg1, @arg2, @arg3, @arg4) ->
