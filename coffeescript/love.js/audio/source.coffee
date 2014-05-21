class Source
  constructor: (@filename, @type) ->
    @element = document.createElement("audio")
    @element.setAttribute("src", Love.root + "/" + filename)

    # one would think that you should use preload=none for a stream type asset
    # except that that doesn't really work for our use-case
    @element.setAttribute("preload", "auto")

  clone: (self) ->
    new Source(self.filename, self.type)

  getAttenuationDistances: (self) ->

  getChannels: (self) ->

  getCone: (self) ->

  getDirection: (self) ->

  getPitch: (self) ->

  getPosition: (self) ->

  getRolloff: (self) ->

  getVelocity: (self) ->

  getVolume: (self) ->
    self.element.volume

  getVolumeLimits: (self) ->

  isLooping: (self) ->
    !!self.element.getAttribute("loop")

  isPaused: (self) ->
    self.element.paused

  isPlaying: (self) ->
    !self.element.paused

  isRelative: (self) ->

  isStatic: (self) ->

  isStopped: (self) ->
    self.isPaused(self) and self.currentTime == 0

  pause: (self) ->
    self.element.pause()

  play: (self) ->
    self.element.play()

  resume: (self) ->
    self.element.play()

  rewind: (self) ->
    self.element.currentTime = 0

  seek: (self, offset, time_unit = "seconds") ->
    switch time_unit
      when "seconds" then self.element.currentTime = offset

  setAttenuationDistances: (self) ->

  setCone: (self) ->

  setDirection: (self) ->

  setLooping: (self, looping) ->
    self.element.setAttribute("loop", looping)

  setPitch: (self) ->

  setPosition: (self) ->

  setRelative: (self) ->

  setRolloff: (self) ->

  setVelocity: (self) ->

  setVolume: (self, volume) ->
    self.element.volume = volume

  setVolumeLimits: (self) ->

  stop: (self) ->
    self.element.load()

  tell: (self, time_unit = "seconds") ->
    switch time_unit
      when "seconds" then self.element.currentTime
      when "samples" then 0
