class @Punchdrunk
  constructor: (config = {}) ->
    game_root = config["game_root"] or "lua"
    punchdrunk_root = config["punchdrunk_root"] or "./js"
    element = config["canvas"] or null

    # Forward print() messages to the console
    shine.stdout.write = () ->
      console.log.apply(console, arguments)

    conf = {
      window: {},
      modules: {}
    }

    new shine.FileManager().load "#{game_root}/conf.lua.json", (_, file) ->
      conf_env = {love: {}}
      conf_vm = new shine.VM(conf_env)
      conf_vm.execute(null, file)
      conf_env.love.conf.call(null, conf)

      Love.root = game_root
      love = new Love(element, conf.window, conf.modules)

      vm = new shine.VM({
        love: love
      })

      vm._globals['package'].path = "#{game_root}/?.lua.json;#{game_root}/?.json;" + vm._globals['package'].path

      vm.load("#{punchdrunk_root}/boot.lua.json")
