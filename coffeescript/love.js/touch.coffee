class Touch
  constructor: (eventQueue, canvas) ->
    @fingers = {}

    preventDefault = (evt) ->
      evt.preventDefault()
      evt.stopPropagation()

    canvas.addEventListener('gesturestart',  preventDefault)
    canvas.addEventListener('gesturechange', preventDefault)
    canvas.addEventListener('gestureend',    preventDefault)

    canvas.addEventListener 'touchstart', (evt) =>
      preventDefault(evt);

      for t in evt.targetTouches
        finger = getFingerByIdentifier(t.identifier)
        if not finger
          finger = new Finder(t.identifier, getNextAvailablePosition(), t.offsetX, t.offsetY)
          @fingers[finger.position] = finger
          eventQueue.push("touchpressed", finger.identifier, finger.x, finger.y)

    touchend = (evt) =>
      preventDefault(evt)

      for t in evt.targetTouches
        finger = getFingerByIdentifier(t.identifier)
        if finger
          delete(@fingers[finger.position])
          eventQueue.push("touchreleased", finger.identifier, finger.x, finger.y)
    canvas.addEventListener('touchend',    touchend)
    canvas.addEventListener('touchleave',  touchend)
    canvas.addEventListener('touchcancel', touchend)

    canvas.addEventListener 'touchmove', (evt) =>
      preventDefault(evt)

      for t in evt.targetTouches
        finger = getFingerByIdentifier(t.identifier)
        if finger
          finger.x = t.offsetX
          finger.y = t.offsetY
          eventQueue.push("touchmoved", finger.identifier, finger.x, finger.y)


  getTouch: (index) =>
    finger = @fingers[index]
    [finger.identifier ,finger.x, finger.y]

  getTouchCount: ->
    maxPosition = getMaxPosition()
    count = 0
    for i in [0...maxPosition]
      if touch.getTouch(i)
        count += 1
    count

  getMaxPosition = ->
    positions = Object.keys(touch.fingers)
    if positions.length == 0
      0
    else
      Math.max.apply(Math, positions)

  getNextAvailablePosition = ->
    maxPosition = getMaxPosition()
    for i in [0...maxPosition]
      if not touch.getTouch(i)
        i
    maxPosition + 1

  getFingerByIdentifier = (identifier) =>
    fingers = @fingers
    for position in fingers
      if fingers.hasOwnProperty(position) and fingers[position].identifier == identifier
        fingers[position]

  class Finger
    constructor: (@identifier, @position, @x, @y) ->
