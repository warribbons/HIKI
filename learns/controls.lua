control = {}

--control functions
function control:getKeyPress(dt)
	--get the keypresses from the keyboard
	local currentKeyPress = "no key down"
    if love.keyboard.isDown("left") then
		control:moveLeft(dt)
 	elseif love.keyboard.isDown("right") then
		control:moveRight(dt)
 	elseif love.keyboard.isDown("up") then
		control:moveUp(dt)
 	elseif love.keyboard.isDown("down") then
		control:moveDown(dt)
	end
end

function getMouseLocation()
	--get x and y coordinates from the mouse
	local x, y = love.mouse.getPosition()
	return x, y
end

--player functions
function control:moveLeft(dt)
	player.x = player.x - (player.speed * dt)
end

function control:moveRight(dt)
	player.x = player.x + (player.speed * dt)
end

--NOTE: y is downwards positive
function control:moveUp(dt)
	player.y = player.y - (player.speed * dt)
end

function control:moveDown(dt)
	player.y = player.y + (player.speed * dt)
end