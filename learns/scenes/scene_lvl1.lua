
require("../camera")
require("../controls")
require("../entities/player")
require("../entities/ground")
require("../entities/zombie")
require '../libraries/spritemap/zombieSprites'

require("vector")

lvl1 = Gamestate.new()
lvl1.test = ''
function lvl1.enter(self, pre)
	--gets called at the beggining of the program, initialize shit
	--the current key on the screen
	--physics initialization
	    love.graphics.setBackgroundColor(45, 45, 45)
	love.physics.setMeter(64) --set a meter to be 64px
	
	world = love.physics.newWorld(0, 9.81*64, true) --creates a world
	
	-- Load up the map
    loader = require("AdvTiledLoader.Loader")
    loader.path = "maps/"
    map = loader.load("map01.tmx")
    map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
		
	--lvl1.ground = Ground()

	lvl1.keypress = "current key pressed"

	lvl1.player = Player(vector(100,800))
	lvl1.player:setState('standing-center')
	collision_objs = {}
	for x, y, tile in map("Walls"):iterate() do
      if tile and tile.properties.isSolid == true then
      	obj = {}
      	print(x)
		obj.body = love.physics.newBody(world, (x*map.tileWidth)+map.tileHeight-15, (y*map.tileHeight)+map.tileHeight-15,'static')
		obj.shape = love.physics.newRectangleShape(map.tileWidth,map.tileHeight)
		obj.fixture = love.physics.newFixture(obj.body, obj.shape)
		obj.fixture:setRestitution(.2)
		obj.fixture:setFriction(0)
		table.insert(collision_objs,obj)
		--love.graphics.setColor(255, 255, 50)
		--print(obj.body:getWorldPoints(obj.shape:getPoints())) 
      end
   	end
	-- restrict the camera
    camera:setBounds(0, 0, 99999, math.floor(love.graphics.getHeight()))
	
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
	local playerloc =  math.floor(self.player.body:getX())
	local zomb = Zombie(vector(math.random(playerloc,playerloc+1000),200),zombieSprites.animations)
	table.insert(self.enemies, zomb)
end


function lvl1.update(self, dt)
	--gets called often
	--dt is the delta time from the last update
	world:update(dt) --this puts the world into motion

	self.player:update(dt)

	if #self.enemies ~= 100 then
		self:spawnEnemy(self)
	end
	for i, zomb in ipairs(self.enemies) do
		if math.abs(zomb.col_x - self.player.body:getX()) < 1000 then
			zomb:update(dt,vector(self.player.body:getX(),self.player.body:getY()))
		--elseif zomb.state ~= 'risen' then
		else
			zomb.body:destroy()
			for k,v in pairs(zomb) do zomb[k]=nil end
			table.remove(self.enemies, i)
			--print('number of enemies='..#self.enemies..' distance apart='..math.abs(zomb.col_x - self.player.body:getX()) )
		end
	end
	--lvl1.zombie:update(dt)
	--mouseX, mouseY = control:getMouseLocation()
	camera:setPosition(math.floor(self.player.body:getX() - love.graphics.getWidth() / 2), 
		math.floor(self.player.body:getY() - love.graphics.getHeight() / 2))
end

function lvl1.draw(self)
	camera:set()
		--get the default colour
		r, g, b, a = love.graphics.getColor()

		--draw player
		map:draw()
		self.player:draw()


		--draw zombie
			if #self.enemies ~= 0 then
				for i, zomb in ipairs(self.enemies) do
					if zomb.col_x - self.player.body:getX() < 1000 then
						zomb:draw()
					end
				end
			end
		--draw ground
		love.graphics.setColor(50, 50, 50)
		--love.graphics.polygon("line", self.ground.body:getWorldPoints(self.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

		--set back to default colour
		love.graphics.setColor(r, g, b, a)
	camera:unset()
end


