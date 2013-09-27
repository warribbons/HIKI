
require("../camera")
require("../controls")
require("../entities/player")
require("../entities/ground")
require("../entities/zombie")
require ('../libraries/spritemap/zombieSprites')
require ('../UserInterface')
require("vector")

debugLvl = Gamestate.new()
debugLvl.test = ''
function debugLvl.enter(self, pre)
	--gets called at the beggining of the program, initialize shit
	--the current key on the screen
	--physics initialization
	love.graphics.setBackgroundColor(45, 45, 45)
	love.physics.setMeter(64) --set a meter to be 64px
	
	world = love.physics.newWorld(0, 9.81*64, true) --creates a world
	world:setCallbacks( debugLvl.beginContact, debugLvl.endContact, debugLvl.preSolve, debugLvl.postSolve )

	-- Load up the map
    loader = require("AdvTiledLoader.Loader")
    loader.path = "maps/"
    map = loader.load("debug.tmx")
    map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	--debugLvl.ground = Ground()

	debugLvl.keypress = "current key pressed"

	debugLvl.player = Player(vector(100,100))
	debugLvl.player:setState('standing-center')
	collision_objs = {}
	for x, y, tile in map("Walls"):iterate() do
      if tile and map("Walls").properties.isSolid == true then
      	obj = {}
      	--print(x)
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
	
	debugLvl.enemies = {}

	--set UI
	debugLvl.UI = UserInterface()
end

function debugLvl.spawnEnemy(self)
	local playerloc =  math.floor(self.player.body:getX())
	--local zomb = Zombie(vector(math.random(playerloc,playerloc+100),200),zombieSprites.animations)
	table.insert(self.enemies, zomb)
end

function debugLvl.update(self, dt)
	--gets called often
	--dt is the delta time from the last update
	world:update(dt) --this puts the world into motion

	self.player:update(dt)

	if #self.enemies ~= 2 then
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
	
	--debugLvl.zombie:update(dt)
	--mouseX, mouseY = control:getMouseLocation()
	camera:setPosition(math.floor(self.player.body:getX() - love.graphics.getWidth() / 2), 
		math.floor(self.player.body:getY() - love.graphics.getHeight() / 2))
end

function debugLvl.draw(self)
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

		--draw user interface
		debugLvl.UI:draw(camera._x, camera._y, self.player)
		
		--set back to default colour
		love.graphics.setColor(r, g, b, a)
	camera:unset()
end

--INPUT FUNCTIONS
------------------------------------------------------------------
function debugLvl.keypressed(self, key, unicode)
	--displays the current key on the screen
	--exits the game
	if key == "escape" then
      love.event.push("quit")
   	end

   	--go to debug level
   	if key == 'd' then
   		print("switch to debug level")
		Gamestate.switch(debugLvl)
   	end
end

function debugLvl.mousepressed(self, x, y, button)
end

function debugLvl.mousereleased(self, x, y, button)
end



--WORLD CALLBACK FUNCTIONS
--for collisions
------------------------------------------------------------------
function debugLvl.beginContact ( a, b, coll )
	--print(a:getUserData() .. " " .. b:getUserData() )
		if(a:getUserData() == "player" and b:getUserData() == "zombie") then
			for i, zomb in ipairs(debugLvl.enemies) do
				debugLvl.player:damage(zomb.damage, zomb.body:getX())
				break;
			end
		end
end 

function  debugLvl.endContact ( a, b, coll )
end

function debugLvl.preSolve ( a, b, coll )
end

function debugLvl.postSolve ( a, b, coll )
end