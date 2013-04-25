--physics initialization
love.physics.setMeter(50) --set a meter to be 64px
world = love.physics.newWorld(0, 9.81*50, true) --creates a world

require("controls")
require("player")
require("ground")

--the current key on the screen
keypress = "current key pressed"

function love.load()
	--gets called at the beggining of the program, initialize shit

	--background color
	--love.graphics.setBackgroundColor(0, 255, 255)
	--set font and font size
	local f = love.graphics.newFont(love._vera_ttf, 10)
	love.graphics.setFont(f)
end

function love.update(dt)
	--gets called often
	--dt is the delta time from the last update
	player:update_position()

	world:update(dt) --this puts the world into motion

	control:getKeyPress(dt)
	mouseX, mouseY = control:getMouseLocation()

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
	--get the default colour
	r, g, b, a = love.graphics.getColor()

    love.graphics.print("MOUSE POS -> X: " .. mouseX .. " Y: " .. mouseY
    	.. "    KEYPRESS: " .. keypress, 0, 0)

    love.graphics.print("PLAYER -> COL X1: " .. player.col_x ..
    	"COL Y1: " .. player.col_y, 0, 12)

    --draw player
    love.graphics.draw(player.image, player.image_x, player.image_y)

    --draw ground
    love.graphics.setColor(50, 50, 50)
    love.graphics.polygon("line", ground.body:getWorldPoints(ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --draw player collider
    --love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --set back to default colour
    love.graphics.setColor(r, g, b, a)
end

