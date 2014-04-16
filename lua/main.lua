function love.load()
  line_box = {
    x = 40,
    y = 40
  }

  canvas = love.graphics.newCanvas(300, 400)
  print(canvas)
  local w, h = canvas:getDimensions()
  print(w)
  print(h)
end

function love.update(dt)
  line_box.y = line_box.y + 100 * dt
end

function love.draw()
  local g = love.graphics


  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  g.setColor(255,0,0)
  love.graphics.print("woo", 100, 100)
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0)

  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", 20, 20, 40, 50)

  love.graphics.setColor(0, 0, 255, 100)
  love.graphics.rectangle("fill", 40, 40, 40, 50)

  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle("line", line_box.x, line_box.y, 50, 40)

  love.graphics.setColor(255, 255, 255)
  local fps = math.floor(love.timer.getFPS())
  local r = math.random
  love.graphics.print("FPS: " .. fps, 10, 10)
end
