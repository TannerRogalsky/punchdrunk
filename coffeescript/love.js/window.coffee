class Window
  constructor: (@graphics) ->

  getDesktopDimensions: () =>

  getDimensions: () =>

  getDisplayCount: () =>

  getFullscreen: () =>

  getFullscreenModes: () =>

  getHeight: () =>

  getIcon: () =>

  getMode: () =>

  getPixelScale: () =>

  getTitle: () =>

  getWidth: () =>

  hasFocus: () =>

  hasMouseFocus: () =>

  isCreated: () =>

  isVisible: () =>

  setFullscreen: () =>

  setIcon: () =>

  setMode: (width, height, flags) =>
    @graphics.canvas.setDimensions(width, height)

  setTitle: () =>

