class Love.Audio
  constructor: () ->

  getDistanceModel: () =>

  getOrientation: () =>

  getPosition: () =>

  getSourceCount: () =>

  getVelocity: () =>

  getVolume: () =>

  newSource: (filename, type) =>
    new Love.Audio.Source(filename, type)

  pause: (source) =>
    source.pause(source)

  play: (source) =>
    source.play(source)

  resume: (source) =>
    source.play(source)

  rewind: (source) =>
    source.rewind(source)

  setDistanceModel: () =>

  setOrientation: () =>

  setPosition: () =>

  setVelocity: () =>

  setVolume: () =>

  stop: (source) =>
    source.stop(source)
