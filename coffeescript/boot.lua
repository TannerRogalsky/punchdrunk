package.path = "lua/?.lua.json;lua/?.json;" .. package.path
require("main")

love.run()
