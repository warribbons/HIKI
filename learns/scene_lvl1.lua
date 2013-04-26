

require("controls")
require("player")
require("ground")
require("zombie")
require("vector")

lvl1 = Gamestate.new()
lvl1.test = ''
function lvl1.enter(self, pre)

	--gets called at the beggining of the program, initialize shit
	--the current key on the screen

	--physics initialization
	love.physics.setMeter(50) --set a meter to be 64px
	
	world = love.physics.newWorld(0, 9.81*50, true) --creates a world
	lvl1.keypress = "current key pressed"

	lvl1.player = Player(vector(100,575))
	lvl1.player:setState('standing-center')
	
	lvl1.ground = Ground()
	
	lvl1.enemies = {}

end


function lvl1.keypressed(self, key, unicode)
	--displays the current key on the screen
	--exits the game
	if key == "escape" then
      love.event.push("quit")
   	end
end

function lvl1.mousepressed(self, x, y, button)
end

function lvl1.mousereleased(self, x, y, button)
end


function lvl1.spawnEnemy(self)
	local zomb = Zombie(vector(math.random(100,700),555))
	table.insert(self.enemies, zomb)
end


function lvl1.update(self, dt)
	--gets called often
	--dt is the delta time from the last update

	world:update(dt) --this puts the world into motion

	self.player:update(dt)
	if #self.enemies ~= 3 then
		self:spawnEnemy(self)
	end
	for i, zomb in ipairs(self.enemies) do
		zomb:update(dt,vector(self.player.body:getX(),self.player.body:getY()))
	end
	--lvl1.zombie:update(dt)
	--mouseX, mouseY = control:getMouseLocation()
end

function lvl1.draw(self)
	--get the default colour
	r, g, b, a = love.graphics.getColor()

    --love.graphics.print("MOUSE POS -> X: " .. mouseX .. " Y: " .. mouseY
    --	.. "    KEYPRESS: " .. keypress, 0, 0)

    --draw player
    self.player:draw()

    --draw zombie
	if #self.enemies ~= 0 then
		for i, zomb in ipairs(self.enemies) do
			zomb:draw()
		end
	end
    --draw ground
    love.graphics.setColor(50, 50, 50)
    love.graphics.polygon("line", self.ground.body:getWorldPoints(self.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --set back to default colour
    love.graphics.setColor(r, g, b, a)

end


