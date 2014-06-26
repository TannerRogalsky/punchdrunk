class @Love
  constructor: (element = null, window_conf = {}, module_conf = {}) ->
    Love.element = element
    @graphics = new Love.Graphics(window_conf.width, window_conf.height)
    @window = new Love.Window(@graphics)
    @timer = new Love.Timer()
    @event = new Love.EventQueue()
    @keyboard = new Love.Keyboard(@event, Love.element)
    @mouse = new Love.Mouse(@event, Love.element)
    @touch = new Love.Touch(@event, Love.element)
    @filesystem = new Love.FileSystem()
    @audio = new Love.Audio()
    @system = new Love.System()
    @image = new Love.ImageModule()
    @math = new Love.MathModule()

    window.addEventListener "beforeunload", () =>
      @quit.call()

  run: () =>
    @timer.step()

    @load.call()

    game_loop = =>
      for e in @event.internalQueue
        @[e.eventType].call(null, e.arg1, e.arg2, e.arg3, e.arg4)
      @event.clear()

      @timer.step()

      @update.call(null, @timer.getDelta())

      @graphics.origin()
      @graphics.clear()
      @draw.call()

      @timer.nextFrame(game_loop)

    @timer.nextFrame(game_loop)

  # default functions to be overwritten by main.lua
  load: (args) ->
  update: (dt) ->
  mousepressed: (x, y, button) ->
  mousereleased: (x, y, button) ->
  touchpressed: (id, x, y) ->
  touchreleased: (id, x, y) ->
  touchmoved: (id, x, y) ->
  keypressed: (key, unicode) ->
  keyreleased: (key, unicode) ->
  draw: () ->
  quit: () ->

Love.root = "lua"
Love.element = null
