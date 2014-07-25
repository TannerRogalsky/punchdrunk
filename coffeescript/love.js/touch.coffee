class Love.Touch
  constructor: (eventQueue, canvas) ->
    @fingers = []

    preventDefault = (evt) ->
      evt.preventDefault()
      evt.stopPropagation()

    canvas.addEventListener('gesturestart',  preventDefault)
    canvas.addEventListener('gesturechange', preventDefault)
    canvas.addEventListener('gestureend',    preventDefault)

    canvas.addEventListener 'touchstart', (evt) =>
      preventDefault(evt);

      for t in evt.targetTouches
        index = getFingerIndex(@fingers, t.identifier)
        if index == -1
          rect = Love.element.getBoundingClientRect()
          finger = new Finger(t.identifier, t.pageX - rect.left, t.pageY - rect.top)
          @fingers.push finger
          eventQueue.push('touchpressed', finger.identifier, finger.x, finger.y)

    touchend = (evt) =>
      preventDefault(evt)
      for t in evt.changedTouches
        index = getFingerIndex(@fingers, t.identifier)
        if index >= 0
          finger = @fingers[index]
          @fingers.splice(index, 1)
          eventQueue.push('touchreleased', finger.identifier, finger.x, finger.y)
    canvas.addEventListener('touchend',    touchend)
    canvas.addEventListener('touchleave',  touchend)
    canvas.addEventListener('touchcancel', touchend)

    canvas.addEventListener 'touchmove', (evt) =>
      preventDefault(evt)

      for t in evt.targetTouches
        index = getFingerIndex(@fingers, t.identifier)
        if index >= 0
          finger = @fingers[index]
          rect = Love.element.getBoundingClientRect()
          finger.x = t.pageX - rect.left
          finger.y = t.pageY - rect.top
          eventQueue.push('touchmoved', finger.identifier, finger.x, finger.y)


  getTouch: (id) =>
    finger = @fingers[id]
    if finger
      [finger.identifier, finger.x, finger.y, 1]
    else
      null

  getTouchCount: =>
    Object.keys(@fingers).length

  getFingerIndex = (fingers, id) ->
    for index in [0...fingers.length]
      finger = fingers[index]
      if finger.identifier == id
        return index
    return -1

  class Finger
    constructor: (@identifier, @x, @y) ->
