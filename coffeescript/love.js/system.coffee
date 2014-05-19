class System
  constructor: () ->

  getClipboardText: () =>

  getOS: () =>
    window.navigator.appVersion

  getPowerInfo: () =>
    battery = window.navigator.battery
    if battery
      state = if battery.charging then "charging" else "unknown"
      percent = battery.level * 100
      seconds = battery.dischargingTime
      [state, percent, seconds]
    else
      ["unknown", null, null]

  getProcessorCount: () =>
    window.navigator.hardwareConcurrency or 1

  openURL: (url) =>
    window.open(url)

  setClipboardText: (text) =>

