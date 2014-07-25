local g = love.graphics

function love.load()
  canvas = g.newCanvas()
  color_index = 1
  colors = {
    {255, 255, 255},
    {255, 0, 0},
    {0, 255, 0},
    {0, 0, 255},
  }
end

function love.draw()
  g.setColor(255, 255, 255)
  g.draw(canvas, 0, 0)
end

function love.update(dt)
  g.setCanvas(canvas)
  g.setColor(colors[color_index])
  if love.touch then
    for i=0,love.touch.getTouchCount() do
      local id, x, y, pressure = love.touch.getTouch(i)
      g.circle("fill", x, y, 20)
    end
  end
  if love.mouse then
    if love.mouse.isDown("l") then
      local x, y = love.mouse.getPosition()
      g.circle("fill", x, y, 20)
    end
  end
  g.setCanvas()
end

function love.touchpressed(id, x, y)
  print("touchpressed", id, x, y)
end

function love.touchreleased(id, x, y)
  print("touchreleased", id, x, y)
  color_index = color_index % #colors + 1
end

function love.mousepressed(x, y, button)
  print("mousepressed", button, x, y)
end

function love.mousereleased(x, y, button)
  print("mousereleased", button, x, y)
  color_index = color_index % #colors + 1
end
