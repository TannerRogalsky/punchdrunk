--[[ CODE DOODLE #2 by DaedalusYoung ]]--
--[[               Cube              ]]--

local colour = {
   left = { 1, 1, 1 },
   side = { 2, 2, 2 },
   right = { 3, 3, 3 },
   white = { 255, 255, 255 },
   black = { 0, 0, 0 },
   }
local width, height = 800, 600
local timer = 0
local direction = 10
local mathsin = math.sin
local mathcos = math.cos
local mathpi = math.pi

function colour.alpha(t, a)
   local r, g, b = unpack(t)
   a = a or 127
   return { r, g, b, a }
end

local function randomcolour()
   colour.left = { math.random(255), math.random(255), math.random(255) }
   colour.right = { math.random(255), math.random(255), math.random(255) }
   colour.side = { math.random(255), math.random(255), math.random(255) }
end

function love.load()
   width, height = love.window.getWidth(), love.window.getHeight()
   randomcolour()
end

function love.update(dt)
   if love.keyboard.isDown("left", "a") then
      direction = direction - 1
   elseif love.keyboard.isDown("right", "d") then
      direction = direction + 1
   end
   timer = timer + (direction * dt)
end

function love.draw()
   local xmax = (width / 40) + 1
   local ymax = (height / 40) - 2
   for x = 1, xmax do
      for y = 2, ymax do
         local xp = ((timer + (x * 40)) % (width + 40)) - 20
         local alpha = (xp + 32) / ((width + 64) / 255)
         local xh = (((xp - (width/2)) / xmax) ^ 3) / 70
         xp = xp + xh
         local yh = math.abs(xh) * ((y - (ymax / 2)) / 6)
         local sh = math.abs(xh) / 10
         love.graphics.setColor(colour.left)
         love.graphics.circle('fill', xp, (y * 40) + yh, 16 + sh, 16)
         love.graphics.setColor(colour.alpha(colour.right, alpha))
         love.graphics.circle('fill', xp, (y * 40) + yh, 16 + sh, 16)
      end
   end
   love.graphics.setColor(colour.black)
   local boxheight = 170
   local boxtimer = timer / 100
   local ax, bx, cx, dx = (width / 2) + (mathcos(boxtimer) * 128), (width / 2) + (mathcos(boxtimer + (mathpi / 2)) * 128), (width / 2) + (mathcos(boxtimer + mathpi) * 128), (width / 2) + (mathcos(boxtimer + (mathpi * 1.5)) * 128)
   local ay, by, cy, dy = (height / 2) + (mathsin(boxtimer) * 64) - 64, (height / 2) + (mathsin(boxtimer + (mathpi / 2)) * 64) - 64, (height / 2) + (mathsin(boxtimer + mathpi) * 64) - 64, (height / 2) + (mathsin(boxtimer + (mathpi * 1.5)) * 64) - 64
   love.graphics.polygon('fill', { ax, ay, bx, by, cx, cy, dx, dy})
   love.graphics.setColor(colour.alpha(colour.side, 191))
   love.graphics.polygon('fill', { ax, ay, bx, by, cx, cy, dx, dy})
   love.graphics.setColor(colour.white)
   love.graphics.polygon('line', { ax, ay, bx, by, cx, cy, dx, dy})
   if ax > bx then
      love.graphics.setColor(colour.black)
      love.graphics.polygon('fill', { ax, ay, bx, by, bx, by + boxheight, ax, ay + boxheight} )
      love.graphics.setColor(colour.alpha(colour.side, ax - bx))
      love.graphics.polygon('fill', { ax, ay, bx, by, bx, by + boxheight, ax, ay + boxheight} )
      love.graphics.setColor(colour.white)
      love.graphics.polygon('line', { ax, ay, bx, by, bx, by + boxheight, ax, ay + boxheight} )
   end
   if bx > cx then
      love.graphics.setColor(colour.black)
      love.graphics.polygon('fill', { bx, by, cx, cy, cx, cy + boxheight, bx, by + boxheight} )
      love.graphics.setColor(colour.alpha(colour.side, bx - cx))
      love.graphics.polygon('fill', { bx, by, cx, cy, cx, cy + boxheight, bx, by + boxheight} )
      love.graphics.setColor(colour.white)
      love.graphics.polygon('line', { bx, by, cx, cy, cx, cy + boxheight, bx, by + boxheight} )
   end
   if cx > dx then
      love.graphics.setColor(colour.black)
      love.graphics.polygon('fill', { cx, cy, dx, dy, dx, dy + boxheight, cx, cy + boxheight} )
      love.graphics.setColor(colour.alpha(colour.side, cx - dx))
      love.graphics.polygon('fill', { cx, cy, dx, dy, dx, dy + boxheight, cx, cy + boxheight} )
      love.graphics.setColor(colour.white)
      love.graphics.polygon('line', { cx, cy, dx, dy, dx, dy + boxheight, cx, cy + boxheight} )
   end
   if dx > ax then
      love.graphics.setColor(colour.black)
      love.graphics.polygon('fill', { dx, dy, ax, ay, ax, ay + boxheight, dx, dy + boxheight} )
      love.graphics.setColor(colour.alpha(colour.side, dx - ax))
      love.graphics.polygon('fill', { dx, dy, ax, ay, ax, ay + boxheight, dx, dy + boxheight} )
      love.graphics.setColor(colour.white)
      love.graphics.polygon('line', { dx, dy, ax, ay, ax, ay + boxheight, dx, dy + boxheight} )
   end
end

function love.keypressed(key)
   if key == "down" or key == "s" then
      direction = 10
   elseif key == " " then
      randomcolour()
   end
end
