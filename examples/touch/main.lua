function love.load()
  love.graphics.setLineWidth(3)
  circles = {}
end

function love.draw()
  for _,circle in pairs(circles) do
    love.graphics.setColor(circle.color)
    love.graphics.circle("fill", circle.x, circle.y, circle.radius)
  end
end

function love.update(dt)
  for id,circle in pairs(circles) do
    if love.touch then
      local x, y = love.touch.getTouch(id - 1)
      circle.x, circle.y = x, y
    else
      local x, y = love.mouse.getPosition()
      circle.x, circle.y = x, y
    end
  end
end

function love.touchpressed(id, x, y)
  local circle = {
    x = x,
    y = y,
    radius = 50,
    color = {255, 0, 0, 255}
  }
  -- incrementing the id is because of a bug in moonshine
  -- https://github.com/gamesys/moonshine/issues/15
  circles[id + 1] = circle
end

function love.touchreleased(id, x, y)
  circles[id + 1] = nil
end

function love.mousepressed(x, y, button)
  local circle = {
    x = x,
    y = y,
    radius = 50,
    color = {255, 0, 0, 255}
  }
  table.insert(circles, circle)
end

function love.mousereleased(x, y, button)
  table.remove(circles)
end
