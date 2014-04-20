function love.load()
  line_box = {
    x = 40,
    y = 40
  }

  canvas = love.graphics.newCanvas(300, 400)
  enemyShip = love.graphics.newImage("enemyShip.png")
  enemyShipPos = {x = 50, y = 100}
  quad = love.graphics.newQuad(25, 10, 50, 50, enemyShip:getWidth(), enemyShip:getHeight())
  rotation = 0

  sprites = love.graphics.newImage("spritesheet.png")
  sprite_quad = love.graphics.newQuad(2 + 21 + 2, 2 + 21 + 2, 21, 21, sprites:getWidth(), sprites:getHeight())
end

function love.update(dt)
  line_box.y = line_box.y + 100 * dt
  rotation = rotation + 2 * dt

  local k = love.keyboard
  local speed = 200
  if k.isDown("up") then
    enemyShipPos.y = enemyShipPos.y - speed * dt
  end
  if k.isDown("down") then
    enemyShipPos.y = enemyShipPos.y + speed * dt
  end
  if k.isDown("left") then
    enemyShipPos.x = enemyShipPos.x - speed * dt
  end
  if k.isDown("right") then
    enemyShipPos.x = enemyShipPos.x + speed * dt
  end
end

function love.draw()
  local g = love.graphics

  g.setCanvas(canvas)
  g.clear()
  g.setColor(255,0,0)
  g.print("woo", 100, 100)

  g.arc("fill", 100, 100, 50, -math.pi, -math.pi / 2)

  g.setCanvas()
  g.draw(canvas, 50, 50)

  g.setColor(255, 0, 0)
  g.rectangle("fill", 0, 0, 40, 50)

  g.setColor(0, 0, 255, 100)
  g.rectangle("fill", 40, 40, 40, 50)

  g.setColor(0, 255, 0)
  g.circle("fill", 100, 100, 25)

  g.setColor(255, 0, 0)
  love.graphics.line(200,50, 400,50, 500,300, 100,300)

  g.setColor(0, 0, 255)
  love.graphics.polygon('fill', 100, 100, 200, 100, 150, 200)

  g.setColor(0, 255, 0)
  g.rectangle("line", line_box.x, line_box.y, 50, 40)

  g.setColor(255, 255, 255)
  g.draw(enemyShip, enemyShipPos.x, enemyShipPos.y, rotation, 1, 1, enemyShip:getWidth() / 2, enemyShip:getHeight() / 2, .75, 0)
  g.draw(enemyShip, quad, 400, 300, math.pi, 2, 2, enemyShip:getWidth() / 2, enemyShip:getHeight() / 2, .75, 0)
  g.draw(enemyShip, quad, 400, 300, 0, 2, 2, enemyShip:getWidth() / 2, enemyShip:getHeight() / 2, .75, 0)
  g.draw(enemyShip, 400, 100)
  g.draw(enemyShip, 400, 100, math.pi)
  g.draw(enemyShip, quad, 150, 100)
  g.draw(enemyShip, quad, 150, 100, math.pi)
  g.rectangle("fill", 0, 250, 21 * 4, 21 * 4)
  g.draw(sprites, sprite_quad, 0, 250, 0, 4, 4)

  g.setColor(255, 255, 255)
  local fps = math.floor(love.timer.getFPS())
  local r = math.random
  g.print("FPS: " .. fps, 10, 10)
end

function love.keypressed(key, unicode)
  -- print("keypressed", key, unicode)
end
function love.keyreleased(key, unicode)
  -- print("keyreleased", key, unicode)
end
