--physics initialization
love.physics.setMeter(50) --set a meter to be 64px
world = love.physics.newWorld(0, 9.81*50, true) --creates a world

require("controls")
require("player")
require("ground")
require("zombie")

--the current key on the screen
keypress = "current key pressed"

enemies = {}

function spawnEnemy()
	z = deepcopy(zombie) -- not working can only have 1 zombie
	table.insert(enemies,zombie)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

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
	player:update_position(dt)
	player:handle_animation(dt)

	world:update(dt) --this puts the world into motion

	control:getKeyPress(dt)
	mouseX, mouseY = control:getMouseLocation()
	
	for i, zombie in ipairs(enemies) do --these should all reference inner copy of table zombie
		zombie:update_position(dt)
		zombie:handle_animation(dt)
	end

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
    love.graphics.drawq(player.image, 
						player.animations[player.state].quads[player.animation.frame],
						player.image_x,
						player.image_y,
						0,
						1,
						1,
						0,
						0)

    --draw ground
    love.graphics.setColor(50, 50, 50)
    love.graphics.polygon("line", ground.body:getWorldPoints(ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --draw player collider
    love.graphics.polygon("line", player.body:getWorldPoints(player.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --set back to default colour
    love.graphics.setColor(r, g, b, a)
	if #enemies == 0 then --more than one enemy?
		spawnEnemy()
	end
	print(enemies[0])
	for i, zombie in ipairs(enemies) do --these should all reference inner copy of table zombie
         love.graphics.drawq(zombie.image, 
						zombie.animations[zombie.state].quads[zombie.animation.frame],
						zombie.image_x,
						zombie.image_y,
						0,
						1.5,
						1.5,
						0,
						0)

		love.graphics.polygon("line", zombie.body:getWorldPoints(zombie.shape:getPoints())) 
    end
end

