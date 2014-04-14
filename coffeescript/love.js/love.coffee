class @Love
  constructor: () ->
    @graphics = new Graphics()
    @timer = new Timer()

  set_callbacks: (load, update, draw) =>
    @load = load
    @update = update
    @draw = draw

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
