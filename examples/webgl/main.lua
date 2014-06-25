function love.load()
  -- print(love.graphics.isSupported("webgl"))
  index = 0
  sprite_sheet = love.graphics.newImage("sprites.png")

  quad = love.graphics.newQuad(0, 0, 50, 50, 128, 128)

  shader = love.graphics.newShader([[
varying vec4 vpos;

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    vpos = vertex_position;
    return transform_projection * vertex_position;
}
]],[[
varying vec4 vpos;

extern number time;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    color = vec4(cos(time), sin(vpos.y), tan(vpos.x + vpos.y), 1);
    vec4 texcolor = Texel(texture, texture_coords);
    return texcolor * color;
}
]])
end

function love.update(dt)
  index = index + 1
  love.graphics.setBackgroundColor(index % 255, 0, 255 - index % 255)
end

function love.draw()
  -- love.graphics.rotate(math.pi)
  -- love.graphics.translate(-600, -600)
  -- love.graphics.scale(2)
  -- love.graphics.shear(2, 2)
  local g = love.graphics

  g.setColor(100, 255, 100, 100)
  g.polygon("fill", 150, 150, 350, 150, 350, 350, 150, 350)

  g.setColor(0, 0, 0)
  g.polygon("fill", 25, 25, 50, 25, 30, 30, 50, 50, 25, 50)
  g.setColor(0, 255, 255)
  g.polygon("line", 25, 25, 50, 25, 30, 30, 50, 50, 25, 50)

  g.setColor(255, 255, 255, 50)
  g.polygon("fill", 100, 100, 200, 200, 100, 200)

  g.setColor(0, 255, 0, 50)
  g.polygon("fill", 300, 300, 200, 200, 300, 200)

  g.setColor(0, 0, 0)
  g.polygon("line", 50, 50, 200, 200, 50, 200)

  g.rectangle("fill", 150, 300, 50, 50)
  g.setColor(255, 0, 0, 200)
  g.rectangle("line", 175 - 25 / 2, 325 - 25 / 2, 25, 25)

  g.setColor(0, 0, 0)
  g.circle("fill", 100, 250, 50)
  g.setColor(255, 255, 255)
  g.circle("line", 100, 255, 25, 8)

  g.setColor(255, 255, 255)
  g.line(200, 200, 300, 300, 100, 300)

  g.setColor(0, 0, 0)
  g.point(10, 10)

  g.setColor(255, 255, 255)
  g.draw(sprite_sheet, quad, 100, 0)

  g.setColor(50, 255, 50)
  g.draw(sprite_sheet, 100 + sprite_sheet:getWidth(), 50, math.rad(index), 0.5, 0.5, sprite_sheet:getWidth() / 2, sprite_sheet:getHeight() / 2, -2, -2)

  g.setColor(255, 255, 255)
  g.setShader(shader)
  shader:send("time", index / 30)
  g.draw(sprite_sheet, quad, 400, 400, 0, 3, 3)
  g.setShader()
end
