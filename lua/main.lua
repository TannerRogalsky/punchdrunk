function love.load()
  line_box = {
    x = 40,
    y = 40
  }
end

function love.update(dt)
  line_box.y = line_box.y + 100 * dt
end

function love.draw()
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", 20, 20, 40, 50)

  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("line", line_box.x, line_box.y, 50, 40)

  love.graphics.setColor(255, 255, 255)
  local fps = math.floor(love.timer.getFPS())
  local r = math.random
  love.graphics.print("FPS: " .. fps, 10, 10)
end
