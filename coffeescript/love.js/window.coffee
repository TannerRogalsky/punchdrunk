class Love.Window
  constructor: (@graphics) ->
    @fullscreen = false

  getDesktopDimensions: =>
    [window.screen.width, window.screen.height]

  getDimensions: =>
    [@getWidth(), @getHeight()]

  getDisplayCount: () =>

  getFullscreen: =>
    @fullscreen

  getFullscreenModes: () =>
    []

  getHeight: =>
    @graphics.getHeight()

  getIcon: () =>

  getMode: () =>

  getPixelScale: =>
    window.devicePixelRatio

  getTitle: =>
    window.document.title

  getWidth: =>
    @graphics.getWidth()

  hasFocus: =>
    document.activeElement == Love.element

  hasMouseFocus: () =>

  isCreated: () =>

  isVisible: () =>

  setFullscreen: (@fullscreen) =>
    @fullscreen = false

  setIcon: () =>

  setMode: (width, height, flags) =>
    @graphics.default_canvas.setDimensions(width, height)

  setTitle: (title) =>
    window.document.title = title


