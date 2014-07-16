function love.draw()
    local g = love.graphics

    g.setColor(255, 255, 255)
    g.arc("line", 100, 100, -100, 0, math.pi)
    g.setColor(255, 0, 0)
    g.arc("line", 150, 150, 100, 0, -math.pi)

    g.setColor(255, 255, 255)
    g.arc("line", 100, 200, 50, math.rad(-35), math.rad(-12))
    g.setColor(255, 0, 0)
    g.arc("line", 150, 200, -50, math.rad(-35), math.rad(-12))

    g.setColor(255, 255, 255)
    g.arc("line", 200, 200, -50, math.rad(-90), math.rad(20))
    g.setColor(255, 0, 0)
    g.arc("line", 200, 200, 50, math.rad(-90), math.rad(20))

    g.setColor(255, 255, 255)
    g.arc("line", 50, 250, -50, math.rad(1000), math.rad(950))
    g.setColor(255, 0, 0)
    g.arc("line", 50, 250, 50, math.rad(1000), math.rad(950))
end
