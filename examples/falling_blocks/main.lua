--   LÖVE Code Doodle #3
--      by HugoBDesigner

function love.load()
   -- GOOD VARIABLE S TO MESS AROUND WITH:
   recsize = 40 --Size, in pixels, of the blocks
   maxheight = 12 --The maximum height of a pile of blocks
   fakeblockmaxtime = 2 --The time it takes to remove a line after it surpasses the maximum height

   gridw = math.floor(800/recsize)
   gridh = math.floor(600/recsize)
   maxheight = gridh-maxheight
   fakeblocks = {}
   fakeblocktimer = 0

   simspeed = 1

   grid = {}
   gridwait = {}
   minspawntime = .05
   maxspawntime = .25
   minspeed = 3
   maxspeed = 12
   spawntime = math.random(minspawntime, maxspawntime)
   for x = 1, gridw do
      grid[x] = {}
      gridwait[x] = false
      for y = 1, gridh do
         grid[x][y] = false
      end
   end
   economic = false
   pyramid = true
   fallingblocks = {}

   love.graphics.setBackgroundColor(255, 255, 255, 255)
end

function love.update(ndt)
   local dt = ndt*simspeed
   if fakeblocktimer > 0 then
      fakeblocktimer = fakeblocktimer - dt
      if fakeblocktimer <= 0 then
         fakeblocktimer = 0
         removeline()
      end
      return
   end

   for i, v in pairs(fallingblocks) do
      v.y = v.y + v.speed*dt
      if v.y >= v.dy and not v.die then
         grid[v.x][v.dy] = v.color
         gridwait[v.x] = false
         local rem = v.removes
         fallingblocks[i] = nil
         if rem then
            fakeblocktimer = fakeblockmaxtime
         end
      elseif v.die and v.y >= gridh+1 then --offset, MURDER IT!!!
         gridwait[v.x] = false
         fallingblocks[i] = nil
      end
   end

   spawntime = spawntime - dt
   if spawntime <= 0 then
      spawntime = math.random(minspawntime, maxspawntime)
      spawnblock()
   end
end

function love.draw()
   if fakeblocktimer > 0 then
      love.graphics.push()
      love.graphics.translate(0, recsize-fakeblocktimer/fakeblockmaxtime*recsize)
   end

   for x = 1, gridw do
      for y = 1, gridh do
         if grid[x][y] then
            love.graphics.setColor(unpack(grid[x][y]))
            love.graphics.rectangle("fill", (x-1)*recsize, (y-1)*recsize, recsize, recsize)
            if pyramid then --TOOK ME A FREAKIN LONG TIME TO MAKE!
               local p1 = {(x-1)*recsize, (y-1)*recsize,
                     (x-1)*recsize+recsize, (y-1)*recsize+recsize}
               local p2 = {(x-1)*recsize+recsize/4, (y-1)*recsize+recsize/4,
                     (x-1)*recsize+recsize-recsize/4, (y-1)*recsize+recsize-recsize/4}
               love.graphics.setColor(255, 255, 255, 55) --left
               love.graphics.polygon("fill", p1[1], p1[2], p1[1], p1[4], p2[1], p2[4], p2[1], p2[2])
               love.graphics.setColor(255, 255, 255, 75) --top
               love.graphics.polygon("fill", p1[1], p1[2], p1[3], p1[2], p2[3], p2[2], p2[1], p2[2])
               love.graphics.setColor(0, 0, 0, 55) --right
               love.graphics.polygon("fill", p1[3], p1[2], p1[3], p1[4], p2[3], p2[4], p2[3], p2[2])
               love.graphics.setColor(0, 0, 0, 75) --bottom
               love.graphics.polygon("fill", p1[1], p1[4], p1[3], p1[4], p2[3], p2[4], p2[1], p2[4])
            end
            if not economic then
               love.graphics.setColor(dark(grid[x][y]))
               love.graphics.rectangle("fill", (x-1)*recsize, (y-1)*recsize, 2, recsize)
               love.graphics.rectangle("fill", x*recsize-2, (y-1)*recsize, 2, recsize)
               love.graphics.rectangle("fill", (x-1)*recsize+2, (y-1)*recsize, recsize-4, 2)
               love.graphics.rectangle("fill", (x-1)*recsize+2, y*recsize-2, recsize-4, 2)
            end
         end
      end
   end

   for i, v in pairs(fallingblocks) do
      love.graphics.setColor(v.color)
      love.graphics.rectangle("fill", (v.x-1)*recsize, (v.y-1)*recsize, recsize, recsize)
      if pyramid then --TOOK ME A FREAKIN LONG TIME TO MAKE!
         local p1 = {(v.x-1)*recsize, (v.y-1)*recsize,
               (v.x-1)*recsize+recsize, (v.y-1)*recsize+recsize}
         local p2 = {(v.x-1)*recsize+recsize/4, (v.y-1)*recsize+recsize/4,
               (v.x-1)*recsize+recsize-recsize/4, (v.y-1)*recsize+recsize-recsize/4}
         love.graphics.setColor(255, 255, 255, 55) --left
         love.graphics.polygon("fill", p1[1], p1[2], p1[1], p1[4], p2[1], p2[4], p2[1], p2[2])
         love.graphics.setColor(255, 255, 255, 75) --top
         love.graphics.polygon("fill", p1[1], p1[2], p1[3], p1[2], p2[3], p2[2], p2[1], p2[2])
         love.graphics.setColor(0, 0, 0, 55) --right
         love.graphics.polygon("fill", p1[3], p1[2], p1[3], p1[4], p2[3], p2[4], p2[3], p2[2])
         love.graphics.setColor(0, 0, 0, 75) --bottom
         love.graphics.polygon("fill", p1[1], p1[4], p1[3], p1[4], p2[3], p2[4], p2[1], p2[4])
      end
      if not economic then
         love.graphics.setColor(dark(v.color))
         love.graphics.rectangle("fill", (v.x-1)*recsize, (v.y-1)*recsize, 2, recsize)
         love.graphics.rectangle("fill", v.x*recsize-2, (v.y-1)*recsize, 2, recsize)
         love.graphics.rectangle("fill", (v.x-1)*recsize+2, (v.y-1)*recsize, recsize-4, 2)
         love.graphics.rectangle("fill", (v.x-1)*recsize+2, v.y*recsize-2, recsize-4, 2)
      end
   end

   if fakeblocktimer > 0 then
      love.graphics.pop()
   end

   love.graphics.setColor(0, 205, 255, 25)
   local x, y = love.mouse.getPosition()
   x = math.max(1, math.min(gridw, math.floor(x/recsize)+1))
   y = math.max(1, math.min(gridw, math.floor(y/recsize)+1))
   love.graphics.rectangle("fill", (x-1)*recsize, (y-1)*recsize, recsize, recsize)

   love.graphics.setColor(205, 255, 0, 55)
   love.graphics.line(0, maxheight*recsize, gridw*recsize, maxheight*recsize)
end

function love.keypressed(key, u)
   if key == "enter" or key == "return" or key == "kpenter" then
      economic = not economic
   elseif key == "p" then
      pyramid = not pyramid
   elseif key == " " then
      spawnblock()
   elseif key == "r" then
      for x = 1, gridw do
         for y = 1, gridh do
            if grid[x][y] then
               grid[x][y] = {math.random(155, 255), math.random(155, 255), math.random(155, 255), 255}
            end
         end
      end

      for i, v in pairs(fallingblocks) do
         v.color = {math.random(155, 255), math.random(155, 255), math.random(155, 255), 255}
      end
   elseif key == "down" or key == "s" or key == "delete" then
      if fakeblocktimer == 0 then
         for x = 1, gridw do --check if it CAN remove line
            if grid[x][gridh] then
               fakeblocktimer = fakeblockmaxtime
               break
            end
         end
      end
   elseif key == "escape" then
      love.event.quit()
   end
end

function love.mousepressed(x, y, button)
   if button == "wu" then
      if simspeed < 1 then
         simspeed = math.min(1, simspeed+.1)
      else
         simspeed = math.min(5, simspeed+1)
      end
   elseif button == "wd" then
      if simspeed > 1 then
         simspeed = math.max(1, simspeed-1)
      else
         simspeed = math.max(.1, simspeed-.1)
      end
   elseif button == "m" then
      simspeed = 1
   elseif button == "l" then
      spawnblock(math.max(1, math.min(gridw, math.floor(x/recsize)+1)))
   elseif button == "r" then
      local rem = 0
      if fakeblocktimer > 0 then
         rem = 1-fakeblocktimer/fakeblockmaxtime
      end
      local nx = math.max(1, math.min(gridw, math.floor(x/recsize)+1))
      local found = false
      for i, v in pairs(fallingblocks) do
         if v.x == nx and (v.y-1+rem)*recsize <= y and (v.y-1+rem)*recsize+recsize > y then --It should be this one!
            v.color = {math.random(155, 255), math.random(155, 255), math.random(155, 255), 255}
            found = true
            break
         end
      end

      if not found then --check stacked blocks
         local ny = math.max(1, math.min(gridh, math.floor((y-(rem*recsize))/recsize)+1))
         if grid[nx][ny] then
            grid[nx][ny] = {math.random(155, 255), math.random(155, 255), math.random(155, 255), 255}
         end
      end
   end
end

function spawnblock(prex)
   local prex = prex or false
   local xtable = {}
   for x = 1, gridw do
      if grid[x][maxheight] == false and not gridwait[x] and (prex == false or x == prex) then
         table.insert(xtable, x)
      end
   end

   if #xtable == 0 then
      return --mostly won't happen, but just in case...
   end

   local x = xtable[math.random(#xtable)]
   local dy = gridh
   local removes = false
   for y = 1, gridh do
      if grid[x][y] == false then
         dy = y
      end
   end
   if dy == maxheight then
      removes = true --removes last line of blocks
   end
   gridwait[x] = true
   local col = {math.random(155, 255), math.random(155, 255), math.random(155, 255), 255}

   local ft = {x = x, y = -1, dy = dy, color = col, removes = removes, speed = math.random(minspeed, maxspeed), die = false}

   table.insert(fallingblocks, ft)
end

function removeline()
   for i, v in pairs(fallingblocks) do
      if v.dy < gridh then
         v.dy = v.dy + 1
      end
      if v.y >= gridh-.75 then -- Almost falling? Let it fall!
         v.die = true
      end
      v.y = v.y + 1
   end

   for x = 1, gridw do
      for y = gridh, 2, -1 do
         grid[x][y] = grid[x][y-1]
      end
      grid[x][1] = false
   end
end

function dark(c)
   local r, g, b, a = unpack(c)
   return math.max(r*.75, 0), math.max(g*.75, 0), math.max(b*.75, 0), a
end
