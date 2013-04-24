require("controls")
require("characters")

function love.load()
	--gets called at the beggining of the program, initialize shit
	local f = love.graphics.newFont(love._vera_ttf, 10)
	love.graphics.setFont(f)
	--displays the current key on the screen
	keypress = "current key pressed"

    player = loadPlayer()
end

function love.update(dt)
	--gets called often
	--dt is the delta time from the last update
	control:getKeyPress(dt)
	mouseX, mouseY = getMouseLocation()
end

function love.keypressed(key)
	--displays the current key on the screen
	keypress = key

	--exits the game
	if key == "escape" then
      love.event.push("quit")
   	end
end

function love.keyreleased()
	keypress = "no key pressed"
end

function love.draw()
    love.graphics.print("MOUSE POS -> X: " .. mouseX .. " Y: " .. mouseY
    	.. "    KEYPRESS: " .. keypress, 0, 0)
    love.graphics.draw(player.image, player.x, player.y)
end

