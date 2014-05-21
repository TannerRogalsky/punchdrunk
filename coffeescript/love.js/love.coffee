class @Love
  constructor: (window_conf, module_conf) ->
    @graphics = new Graphics(window_conf.width, window_conf.height)
    @window = new Window(@graphics)
    @timer = new Timer()
    @event = new EventQueue()
    @keyboard = new Keyboard(@event)
    @mouse = new Mouse(@event, @graphics.default_canvas.element)
    @touch = new Touch(@event, @graphics.default_canvas.element)
    @filesystem = new FileSystem()
    @audio = new Audio()
    @system = new System()
    @image = new ImageModule()

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
