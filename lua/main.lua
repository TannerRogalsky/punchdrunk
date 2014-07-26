local inspector = {}
local background = {}
local bubble = {}
local text = {}
local rain = {}
local g_time = 0

function love.load()
  love.graphics.setBackgroundColor(11, 88, 123)

  local win_w = love.graphics.getWidth()
  local win_h = love.graphics.getHeight()

  inspector.image = love.graphics.newImage("inspector.png")
  inspector.img_w = inspector.image:getWidth()
  inspector.img_h = inspector.image:getHeight()
  inspector.x = win_w * 0.45
  inspector.y = win_h * 0.55

  background.image = love.graphics.newImage("background.png")
  background.img_w = background.image:getWidth()
  background.img_h = background.image:getHeight()
  background.x = 0
  background.y = 0

  bubble.image = love.graphics.newImage("bubble.png")
  bubble.img_w = bubble.image:getWidth()
  bubble.img_h = bubble.image:getHeight()
  bubble.x = 140
  bubble.y = -80

  text.image = love.graphics.newImage("text.png")
  text.x = 25
  text.y = 9

  -- Baby Rain
  rain.spacing_x = 110
  rain.spacing_y = 80
  rain.image = love.graphics.newImage("baby.png")
  rain.img_w = rain.image:getWidth()
  rain.img_h = rain.image:getHeight()
  rain.ox = -rain.img_w / 2
  rain.oy = -rain.img_h / 2
  rain.t = 0

  create_rain()
end

function create_rain()
  local sx = rain.spacing_x
  local sy = rain.spacing_y
  local ox = rain.ox
  local oy = rain.oy

  local m = 1
  local batch_w = 2 * math.ceil(m * love.graphics.getWidth() / sx) + 2
  local batch_h = 2 * math.ceil(m * love.graphics.getHeight() / sy) + 2

  rain.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight() + sy)
  rain.small_canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight() + sy)

  love.graphics.setCanvas(rain.canvas)
  for i = 0, batch_h - 1 do
    for j = 0, batch_w - 1 do
      local is_even = (j % 2) == 0
      local offset_y = is_even and 0 or sy / 2
      local x = ox + j * sx
      local y = oy + i * sy + offset_y
      love.graphics.draw(rain.image, x, y)
    end
  end

  love.graphics.setCanvas(rain.small_canvas)
  ox = ox / 2
  for i = 0, (batch_h - 1) * 4 do
    for j = 0, (batch_w - 1) * 4 do
      local is_even = (j % 2) == 0
      local offset_y = is_even and 0 or sy / 4
      local x = ox + j * sx / 2
      local y = oy + i * sy / 2 + offset_y
      love.graphics.draw(rain.image, x, y, 0, 0.5, 0.5)
    end
  end

  love.graphics.setCanvas()
end

local function update_rain(t)
  rain.t = t
end

function love.update(dt)
  g_time = g_time + dt / 2
  local int, frac = math.modf(g_time)
  update_rain(frac)
  local scale = 1
  inspector.x = love.graphics.getWidth() * 0.45 / scale
  inspector.y = love.graphics.getHeight() * 0.55 / scale
end

local function draw_grid()
  local y = rain.spacing_y * rain.t

  local small_y = -rain.spacing_y + y / 2
  local big_y = -rain.spacing_y + y

  love.graphics.setBlendMode("additive")
  love.graphics.setColor(255, 255, 255, 128)
  love.graphics.draw(rain.small_canvas, 0, small_y)

  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(rain.canvas, 0, big_y)
end

local function draw_text(x, y)
  local int, frac = math.modf(g_time)
  if frac < 0.5 then
    return
  end
  local tx = x + text.x
  local ty = y + text.y
  love.graphics.draw(text.image, tx, ty, 0, 1, 1, 70, 70)
end

local function draw_background(x, y)
  local intensity = (math.sin(math.pi * g_time * 2) + 1) / 2

  local bx = x
  local by = y

  love.graphics.setColor(255, 255, 255, 64 + 16*intensity)
  love.graphics.draw(background.image, bx, by, 0, 0.7, 0.7, 256, 256)
  love.graphics.setColor(255, 255, 255, 32 + 16*intensity)
  love.graphics.draw(background.image, bx, by, 0, 0.65, 0.65, 256, 256)
  love.graphics.setBlendMode("additive")
  love.graphics.setColor(255, 255, 255, 16 + 16*intensity)
  love.graphics.draw(background.image, bx, by, 0, 0.6, 0.6, 256, 256)
end

local function draw_bubble(x, y)
  local osc = 10 * math.sin(math.pi * g_time)
  local bx = x + bubble.x
  local by = y + bubble.y + osc
  love.graphics.draw(bubble.image, bx, by, 0, 1, 1, 70, 70)

  draw_text(bx, by)
end

local function draw_inspector()
  local x, y = inspector.x, inspector.y
  local ox, oy = inspector.img_w / 2, inspector.img_h / 2
  draw_background(x, y)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode("alpha")
  love.graphics.draw(inspector.image, x, y, 0, 1, 1, ox, oy)
  draw_bubble(x, y)
end

function love.draw()
  love.graphics.setColor(255, 255, 255)

  draw_grid()
  draw_inspector()
end
