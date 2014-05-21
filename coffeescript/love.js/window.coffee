class Window
  constructor: (@graphics) ->

  getDesktopDimensions: () =>

  getDimensions: () =>

  getDisplayCount: () =>

  getFullscreen: () =>

  getFullscreenModes: () =>

  getHeight: =>
    @graphics.getHeight()

  getIcon: () =>

  getMode: () =>

  getPixelScale: () =>

  getTitle: () =>

  getWidth: =>
    @graphics.getWidth()

  hasFocus: () =>

  hasMouseFocus: () =>

  isCreated: () =>

  isVisible: () =>

  setFullscreen: () =>

  setIcon: () =>

  setMode: (width, height, flags) =>
    @graphics.default_canvas.setDimensions(width, height)

  setTitle: () =>

