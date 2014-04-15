class Timer
  constructor: () ->
    # The time that has passed since the timer was created, in milliseconds
    @microTime = performance.now()

    # The time that has passed between the last two frames, in seconds
    @deltaTime = 0

    # The upper value that deltaTime can have, in seconds. Defaults to 0.25.
    # Can be changed via `setDeltaTimeLimit`.
    # Note that this does *not* magically make a game go faster. If a game has
    # very low FPS, this makes sure that the delta time is not too great (its bad
    # for things like physics simulations, etc).
    @deltaTimeLimit = 0.25

    @events = {}
    @maxEventId = 0

  nextFrame: (callback) =>
    requestAnimationFrame(callback)

  getDelta: () =>
    @deltaTime

  getFPS: () =>
    if @deltaTime == 0 then 0 else 1 / @deltaTime

  getTime: () =>
    @microTime

  sleep: () =>

  step: () =>
    dt = (performance.now() - @microTime) / 1000
    @deltaTime = Math.max(0, Math.min(@deltaTimeLimit, dt))
    @microTime += dt * 1000

  performance = window.performance || Date
  performance.now = performance.now     ||
                  performance.msNow     ||
                  performance.mozNow    ||
                  performance.webkitNow ||
                  Date.now

  lastTime = 0
  requestAnimationFrame =
    window.requestAnimationFrame       ||
    window.msRequestAnimationFrame     ||
    window.mozRequestAnimationFrame    ||
    window.webkitRequestAnimationFrame ||
    window.oRequestAnimationFrame      ||
    (callback) ->
      currTime   = performance.now()
      timeToCall = Math.max(0, 16 - (currTime - lastTime))
      delay      = -> callback(currTime + timeToCall)
      lastTime   = currTime + timeToCall
      setTimeout(delay, timeToCall)
