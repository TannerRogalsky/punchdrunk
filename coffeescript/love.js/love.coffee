class @Love
  constructor: () ->
    @graphics = new Graphics()
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
