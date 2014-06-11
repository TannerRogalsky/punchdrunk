function love.load()
  print(love.graphics.isSupported("webgl"))

  index = 0
end

function love.update(dt)
  index = index + 1
  love.graphics.setBackgroundColor(index % 255, 0, 255 - index % 255)
end

function love.draw()
  local g = love.graphics
  g.setColor(255, 255, 255)
  g.polygon("fill", 100, 100, 200, 200, 100, 200)

  g.setColor(0, 255, 0, 100)
  g.polygon("fill", 300, 300, 200, 200, 300, 200)

  -- g.circle("fill", 50, 50 + 25, 25)

  -- g.setColor(100, 100, 255)
  -- g.rectangle("line", 100, 50, 25, 50)

  -- g.setColor(0, 255, 0)
  -- g.line(150, 50, 200, 100)
end
