-- this kind of creates a class of some sort...
-- essentially it's a table with functions in it
-- functions are added when something like control:moveLeft is defined
-- as a function
control = {}

--control functions
function control:getKeyPress(dt)
	--get the keypresses from the keyboard
	local currentKeyPress = "no key down"
	local velx, vely = player.body:getLinearVelocity()
    if love.keyboard.isDown("left") then
		player:moveLeft(dt,velx)
 	elseif love.keyboard.isDown("right") then
		player:moveRight(dt,velx)
	end
 	if love.keyboard.isDown("up") then
		player:moveUp(dt,vely)
 	elseif love.keyboard.isDown("down") then
		player:moveDown(dt)
	end

	--debug functions
	if love.keyboard.isDown("r") then 
		player:setPos(800/2, 650/2)
	end
end

function control:getMouseLocation()
	--get x and y coordinates from the mouse
	local x, y = love.mouse.getPosition()
	return x, y
end

