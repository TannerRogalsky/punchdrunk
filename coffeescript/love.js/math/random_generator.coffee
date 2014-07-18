class Love.Math.RandomGenerator
  constructor: ->
    @last_random_normal = Number.POSITIVE_INFINITY
    seed = new Long(0xCBBF7A44, 0x0139408D)
    @setSeed(@, seed)

  rand: ->
    @rng_state = @rng_state.xor(@rng_state.shiftLeft(13))
    @rng_state = @rng_state.xor(@rng_state.shiftRight(7))
    @rng_state = @rng_state.xor(@rng_state.shiftLeft(17))

  random: (self, min, max) ->
    if min == undefined && max == undefined
      return Math.abs(self.rand().toNumber() / MAX_VALUE)

    if max == undefined
      max = min
      return self.random(self) * max

    self.random(self) * (max - min) + min

  randomNormal: (self, stddev = 1, mean = 0) ->
    if self.last_random_normal != Number.POSITIVE_INFINITY
      r = self.last_random_normal
      self.last_random_normal = Number.POSITIVE_INFINITY
      return r * stddev + mean

    r   = Math.sqrt(-2.0 * Math.log(1 - self.random(self)))
    phi = 2 * Math.PI * (1 - self.random(self))

    self.last_random_normal = r * Math.cos(phi)
    return r * Math.sin(phi) * stddev + mean

  setSeed: (self, low, high) ->
    if high
      self.seed = new Long(low, high)
    else
      self.seed = Long.fromNumber(low)

    self.rng_state = self.seed
    for i in [0..2]
      self.rand()

  getSeed: (self) ->
    [self.seed.getLowBits(), self.seed.getHighBits()]

  getState: (self) ->
    [low, high] = self.getSeed()
    padding = '00000000' # eight zeros
    ss = '0x'
    low_string = low.toString(16) # hex string
    high_string = high.toString(16) # hex string
    ss += padding.substring(0, padding.length - low_string.length) + low_string
    ss += padding.substring(0, padding.length - high_string.length) + high_string
    return ss

  setState: (self, state_string) ->
    low = parseInt(state_string.substring(2, 10), 16)
    high = parseInt(state_string.substring(10, 18), 16)
    self.rng_state = new Long(low, high)

  Long = goog.math.Long
  MAX_VALUE = Long.fromNumber(Number.MAX_VALUE).toNumber()
