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
        finger = @fingers[t.identifier]
        if not finger
          rect = Love.element.getBoundingClientRect()
          finger = new Finger(t.identifier, t.pageX - rect.left, t.pageY - rect.top)
          @fingers[finger.identifier] = finger
          eventQueue.push('touchpressed', finger.identifier, finger.x, finger.y)

    touchend = (evt) =>
      preventDefault(evt)
      for t in evt.changedTouches
        finger = @fingers[t.identifier]
        if finger
          delete(@fingers[t.identifier])
          eventQueue.push('touchreleased', finger.identifier, finger.x, finger.y)
    canvas.addEventListener('touchend',    touchend)
    canvas.addEventListener('touchleave',  touchend)
    canvas.addEventListener('touchcancel', touchend)

    canvas.addEventListener 'touchmove', (evt) =>
      preventDefault(evt)

      for t in evt.targetTouches
        finger = @fingers[t.identifier]
        if finger
          rect = Love.element.getBoundingClientRect()
          finger.x = t.pageX - rect.left
          finger.y = t.pageY - rect.top
          eventQueue.push('touchmoved', finger.identifier, finger.x, finger.y)


  getTouch: (id) =>
    finger = @fingers[id]
    if finger
      [finger.x, finger.y]
    else
      [null, null]

  getTouchCount: =>
    Object.keys(@fingers).length

  class Finger
    constructor: (@identifier, @x, @y) ->
