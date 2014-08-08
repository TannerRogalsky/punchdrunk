lf = love.filesystem
ls = love.sound
la = love.audio
lp = love.physics
lt = love.thread
li = love.image
lg = love.graphics


font = lg.newFont("fonts/GeosansLight.ttf", 50)




function love.load()
	alignes = {"left", "center", "right"}
	currentalign = 1
end
function love.focus(f)



end

function love.mousepressed(x,y,button)



end

function love.keypressed(k)
	if k == "left" then
		currentalign = math.max(currentalign-1, 1)
	end
	if k == "right" then
		currentalign = math.min(currentalign+1, #alignes)
	end
end
function love.keyreleased(k)

end

function love.joystickpressed()



end

function love.update(dt)
	

end

function love.draw()
	lg.setColor(255,255,255)
	lg.setFont(font)
	lg.print("Font Test", 20, 50)
	lg.rectangle("line", 20, 50, font:getWidth("Font Test"), font:getHeight())

	-- Rectangle
	lg.setColor(100,100,100)
	local rectw = 400
	local rectx = (lg.getWidth()-rectw)/2
	lg.rectangle("fill", rectx, 0, rectw, lg.getHeight())

	-- Text
	lg.setColor(255,255,255)
	local text = [[Bacon ipsum dolor

sit amet biltong meatloaf andouille, turducken bresaola pork belly beef ribs ham hock capicola tail prosciutto landjaeger meatball pork loin. Swine turkey jowl, porchetta doner boudin meatloaf.]]
	lg.printf(text, rectx, 0, rectw, alignes[currentalign])

	-- Number of lines
	local _, lines = font:getWrap(text, rectw)
	lg.print("Number of lines:"..lines, 20, 150)


	-- Controls
	lg.printf("Use arrow keys to change align.", 20, 250, 400)
end
