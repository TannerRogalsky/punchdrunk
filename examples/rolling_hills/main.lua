--[[ CODE DOODLE #5 by DaedalusYoung ]]--
--[[          Rolling Hills          ]]--

local map = {}
local width = 16
local height = 16
local timer = 0
local waveheight = 50
local wavesize = 5
local blockmode = false
local keytimer = 0
local keyinput = true

function love.load()
   love.window.setTitle("Rolling Hills")
   for y = 1, height do
      map[y] = {}
      for x = 1, width do
         map[y][x] = 0
      end
   end
end

function love.update(dt)
   timer = timer + dt
   if not keyinput then
      keytimer = keytimer + dt
      if keytimer >= 0.04 then
         keytimer = 0
         keyinput = true
      end
   else
      if love.keyboard.isDown("a", "d", "q", "e") then
         keyinput = false
      end
      if love.keyboard.isDown("a") then
         waveheight = math.floor(waveheight - 0.5)
      end
      if love.keyboard.isDown("d") then
         waveheight = math.ceil(waveheight + 0.5)
      end
      waveheight = math.min(100, math.max(1, waveheight))
      if love.keyboard.isDown("q") then
         wavesize = math.floor((wavesize * 10) - 0.5) / 10
      end
      if love.keyboard.isDown("e") then
         wavesize = math.ceil((wavesize * 10) + 0.5) / 10
      end
      wavesize = math.min(15, math.max(1, wavesize))
   end
   for y = 1, height do
      map[y] = {}
      for x = 1, width do
         map[y][x] = love.math.noise(x / wavesize, y / wavesize, timer / 4)
      end
   end
end

function love.draw()
   for y = 1, height do
      for x = 1, width do
         local x1 = (x * 24) - (y * 24) + 400
         local x2 = x1 + 22
         local x3 = x1
         local x4 = x1 - 22
         local val = map[y][x] * waveheight
         if blockmode then
            val = val - ((val + 10) % 20)
         end
         local y1 = (((y * 24) + (x * 24)) / 2) + (100 - val)
         local y2 = y1 + 11
         local y3 = y1 + 22
         local y4 = y1 + 11
         --left side
         love.graphics.setColor(32, 147, 32)
         love.graphics.polygon('fill', x3, y3, x4, y4, x4, y4 + 4, x3, y3 + 4)
         love.graphics.setColor(104, 68, 33)
         love.graphics.polygon('fill', x3, y3 + 4, x4, y4 + 4, x4, y4 + 20, x3, y3 + 20)
         love.graphics.setColor(33, 33, 33)
         love.graphics.polygon('fill', x3, y3 + 20, x4, y4 + 20, x4, y4 + 80, x3, y3 + 80)
         love.graphics.setColor(68, 68, 68)
         love.graphics.polygon('fill', x3, y3 + 21, x4, y4 + 21, x4, y4 + 40, x3, y3 + 40)
         love.graphics.polygon('fill', x3, y3 + 41, x4, y4 + 41, x4, y4 + 60, x3, y3 + 60)
         --right side
         love.graphics.setColor(25, 116, 25)
         love.graphics.polygon('fill', x2, y2, x3, y3, x3, y3 + 4, x2, y2 + 4)
         love.graphics.setColor(76, 50, 25)
         love.graphics.polygon('fill', x2, y2 + 4, x3, y3 + 4, x3, y3 + 20, x2, y2 + 20)
         love.graphics.setColor(25, 25, 25)
         love.graphics.polygon('fill', x2, y2 + 20, x3, y3 + 20, x3, y3 + 80, x2, y2 + 80)
         love.graphics.setColor(50, 50, 50)
         love.graphics.polygon('fill', x2, y2 + 21, x3, y3 + 21, x3, y3 + 40, x2, y2 + 40)
         love.graphics.polygon('fill', x2, y2 + 41, x3, y3 + 41, x3, y3 + 60, x2, y2 + 60)
         --top side
         love.graphics.setColor(43, 198, 43)
         love.graphics.polygon('fill', x1, y1, x2, y2, x3, y3, x4, y4)
         love.graphics.setColor(25, 116, 25)
         love.graphics.polygon('line', x1, y1, x2, y2, x3, y3, x4, y4)
      end
   end
   love.graphics.setColor(255, 255, 255)
   love.graphics.print("Wave size: " .. wavesize .. "  [Q] and [E] to change\nWave height: " .. waveheight .. "  [A] and [D] to change\n[B] to toggle Block Mode", 16, 16)
end

function love.keypressed(k)
   if k == "b" then
      blockmode = not blockmode
   end
end
