function love.load()
  print(love.graphics.isSupported("webgl"))

  index = 0
end

function love.update(dt)
  index = index + 1
end

function love.draw()
  local g = love.graphics

  g.setBackgroundColor(index % 255, 0, 0)
  -- g.circle("fill", 50, 50 + 25, 25)

  -- g.setColor(100, 100, 255)
  -- g.rectangle("line", 100, 50, 25, 50)

  -- g.setColor(0, 255, 0)
  -- g.line(150, 50, 200, 100)
end
