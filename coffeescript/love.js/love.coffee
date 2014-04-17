class @Love
  constructor: (window_conf) ->
    @graphics = new Graphics(window_conf.width, window_conf.height)
    @timer = new Timer()

  run: () =>
    @timer.step()

    @load.call()

    game_loop = =>
      @timer.step()

      @update.call(null, @timer.getDelta())

      @graphics.clear()
      @draw.call()

      @timer.nextFrame(game_loop)

    @timer.nextFrame(game_loop)
