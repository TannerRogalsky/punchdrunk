function love.load()
  print("load")
  -- love.canvas:setBackgroundColor(255,0,30)
end

function love.update(dt)
  print("update:" .. dt)
end

function love.draw()
  print("draw")
  -- love.canvas.setColor(255,225,255)
  -- local fps = math.floor(love.timer.getFPS())
  -- love.canvas.print("FPS: " + fps, sd.width - 40, 10)
end
