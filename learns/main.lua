function love.load()
	--gets called at the beggining of the program, initialize shit
	local f = love.graphics.newFont(love._vera_ttf, 10)
	love.graphics.setFont(f)
end

--control functions
function getKeyPress()
	--get the keypresses from the keyboard
	local currentKeyPress = "no key down"
    if love.keyboard.isDown("left") then
		currentKeyPress = "left"
 	elseif love.keyboard.isDown("right") then
		currentKeyPress = "right"
 	elseif love.keyboard.isDown("up") then
		currentKeyPress = "up"
 	elseif love.keyboard.isDown("down") then
		currentKeyPress = "down"
	else
		currentKeypress = "no key down"
	end

	return currentKeyPress
end

function getMouseLocation()
	--get x and y coordinates from the mouse
	local x, y = love.mouse.getPosition()
	return x, y
end


function love.update(dt)
	--gets called often
	--dt is the delta time from the last update
	keypress = getKeyPress()
	mouseX, mouseY = getMouseLocation()
end

function love.draw()
    love.graphics.print("MOUSE POS -> X: " .. mouseX .. " Y: " .. mouseY
    	.. "    KEYPRESS: " .. keypress, 0, 0)
end

