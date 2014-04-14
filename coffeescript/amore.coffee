# Forward print() messages to the console
shine.stdout.write = () ->
  console.log.apply(console, arguments)

env = {
  love: new Love()
};

vm = new shine.VM(env)
vm.load('./lua/boot.lua.json')
