# Forward print() messages to the console
shine.stdout.write = () ->
  console.log.apply(console, arguments)

conf = {
  window: {},
  modules: {}
}

new shine.FileManager().load './lua/conf.lua.json', (_, file) ->
  conf_env = {love: {}}
  conf_vm = new shine.VM(conf_env)
  conf_vm.execute(null, file)
  conf_env.love.conf.call(null, conf)

  vm = new shine.VM({
    love: new Love(conf.window)
  })
  vm.load('./lua/boot.lua.json')
