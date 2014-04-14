function love.load()
  print("load")
end

function love.update(dt)
  print("update:" .. dt)
end

function love.draw()
  print("draw")
  -- love.graphics.setColor(255,225,255)
  -- local fps = math.floor(love.timer.getFPS())
  -- love.graphics.print("FPS: " + fps, sd.width - 40, 10)
end
