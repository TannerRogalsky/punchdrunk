class Love.Mouse
  @WHEEL_TIMEOUT = 0.02

  constructor: (eventQueue, canvas) ->
    @x = 0
    @y = 0
    @buttonsDown = {}
    @wheelTimeOuts = {}

    handlePress = (button) =>
      @buttonsDown[button] = true
      eventQueue.push("mousepressed", @x, @y, button)

    handleRelease = (button) =>
      @buttonsDown[button] = false
      eventQueue.push("mousereleased", @x, @y, button)

    handleWheel = (evt) =>
      evt.preventDefault()
      button = getWheelButtonFromEvent(evt)
      # The 'wheel has stopped scrolling' event is triggered via setTimeout, since
      # browsers don't provide a native 'stopped scrolling' event
      clearTimeout(@wheelTimeOuts[button])
      @wheelTimeOuts[button] = setTimeout =>
        handleRelease(button)
      , @constructor.WHEEL_TIMEOUT * 1000
      handlePress(button)

    canvas.addEventListener 'mousemove', (evt) =>
      rect = Love.element.getBoundingClientRect()
      @x = evt.pageX - rect.left
      @y = evt.pageY - rect.top

    canvas.addEventListener 'mousedown', (evt) =>
      handlePress(getButtonFromEvent(evt))

    canvas.addEventListener 'mouseup', (evt) =>
      handleRelease(getButtonFromEvent(evt))

    canvas.addEventListener('DOMMouseScroll', handleWheel); # firefox
    canvas.addEventListener('mousewheel', handleWheel); # everyone else

  getCursor: =>
    null

  getPosition: =>
    [@x, @y]

  getSystemCursor: =>
    null

  getX: =>
    @x

  getY: =>
    @y

  isDown: (button, others...) =>
    if !@buttonsDown[button]
      return false
    else
      if others.length == 0
        return true
      else
        return @isDown(others...)

  isGrabbed: =>
    false

  isVisible: =>
    true

  newCursor: =>
    null

  setCursor: (cursor) =>

  setGrabbed: (grab) =>

  setPosition: (x, y) =>
    @setX(x)
    @setY(y)

  setVisible: (visible) =>

  setX: (x) =>

  setY: (y) =>

  mouseButtonNames =
    1: "l"
    2: "m"
    3: "r"

  getButtonFromEvent = (evt) ->
    mouseButtonNames[evt.which]

  getWheelButtonFromEvent = (evt) ->
    delta = Math.max(-1, Math.min(1, (evt.wheelDelta or -evt.detail)))
    if delta == 1 then 'wu' else 'wd'
