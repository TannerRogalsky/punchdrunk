function love.load()
        math.randomseed(os.time(),love.mouse.getX(),love.mouse.getY())
        head = {x=400,y=300}
        tail = {}
        colors = {}
        directions = {}
        for i=1,100 do
                table.insert(tail,{x=-6000+math.random(12000),y=-6000+math.random(12000)})
                table.insert(colors,{math.random(255),math.random(255),math.random(255)})
                table.insert(directions,math.random(math.pi*2))
        end

        angle = 0

        timer = 0.2


end

function love.update(dt)

        if love.keyboard.isDown(" ") then
                for i,v in ipairs(tail) do
                        v.x = v.x + math.cos(directions[i]) * 500 * dt
                        v.y = v.y + math.sin(directions[i]) * 500 * dt
                end
        else

                for i,v in ipairs(tail) do
                        if i == 1 then
                                if getDistance(head,v) > 30 then
                                        local ang = math.atan2(head.y-v.y,head.x-v.x)
                                        v.x = v.x + math.cos(ang) * 500 * dt
                                        v.y = v.y + math.sin(ang) * 500 * dt
                                end
                        else
                                local j = i-1
                                if getDistance(tail[j],v) > 15 then
                                        local ang = math.atan2(tail[j].y-v.y,tail[j].x-v.x)
                                        v.x = v.x + math.cos(ang) * 500 * dt
                                        v.y = v.y + math.sin(ang) * 500 * dt
                                end
                        end
                end
        end

        if love.keyboard.isDown("left") then
                angle = angle - 8 * dt
        end

        if love.keyboard.isDown("right") then
                angle = angle + 8 * dt
        end

        if love.keyboard.isDown("up") then
                head.x = head.x + 500 * math.cos(angle) * dt
                head.y = head.y + 500 * math.sin(angle) * dt

        end

        if head.x > 800 then
                head.x = 0
        end
        if head.y > 600 then
                head.y = 0
        end

        if head.x < 0 then
                head.x = 800
        end
        if head.y < 0 then
                head.y = 600
        end

        timer = timer - dt

        if timer < 0 then
                local temp = colors[1]
                table.remove(colors,1)
                table.insert(colors,temp)
                timer = 0.05
        end




end

function love.draw()

        for i,v in ipairs(tail) do
                love.graphics.setColor(colors[i][1],colors[i][2],colors[i][3])
                if i == 1 then
                        love.graphics.line(v.x,v.y,head.x,head.y)
                else
                        love.graphics.line(v.x,v.y,tail[i-1].x,tail[i-1].y)
                end
                love.graphics.circle("fill", v.x, v.y, 3, 10)
        end

    love.graphics.setColor(255,255,255)
    love.graphics.push()
    love.graphics.translate(head.x, head.y)
    love.graphics.rotate(angle)
    love.graphics.polygon("fill", 0, 0, -30, -10, -30,10)
    love.graphics.pop()

end

function getDistance(a,b)
        return math.sqrt((a.x-b.x)^2+(a.y-b.y)^2)
end
