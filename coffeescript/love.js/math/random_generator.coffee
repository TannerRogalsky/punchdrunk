class Love.Math.RandomGenerator
  constructor: ->
    seed = new Long(0xCBBF7A44, 0x0139408D)
    @setSeed(seed)

  rand: ->
    @rng_state = @rng_state.xor(@rng_state.shiftLeft(13))
    @rng_state = @rng_state.xor(@rng_state.shiftRight(7))
    @rng_state = @rng_state.xor(@rng_state.shiftLeft(17))

  random: (min, max) ->
    if min == undefined && max == undefined
      return Math.abs(@rand().toNumber() / MAX_VALUE)

    if max == undefined
      max = min
      return @random() * max

    @random() * (max - min) + min

  setSeed: (@seed) ->
    @rng_state = @seed
    for i in [0..2]
      @rand()

  getSeed: ->
    @seed

  Long = goog.math.Long
  MAX_VALUE = Long.fromNumber(Number.MAX_VALUE).toNumber()
