require '../libraries/vector'
require '../libraries/middleclass'
require '../libraries/attack/attackInterface'
Player = class('Player')

function Player:initialize(pos)
	--attributes
	-------------------------------------------------------------------
	self.health = 100
	self.speed = 300
	self.density = 150
	self.y_velocity = 0
	self.x_velocity = 0
	self.invulnTime = 0

	--image
	self.image = love.graphics.newImage("sprites/characters/player.png")
	
	--jump
	self.gravity = 900
	self.jump_height = 500
	self.jump_stamina = 1

	--attack
	self.playerAttack = Attack()

	-- quads, animation frames
	-------------------------------------------------------------------
	self.tileSizeX = 100
	self.tileSizeY = 100
	self.height = 60--self.tileSizeX
	self.width = 80--self.tileSizeX

	self.animations = {}

	--static animations
	self.animations['dead'] = {}
	self.animations['dead'].frameInterval = .2
	self.animations['dead'].behaviour = 'once'
	self.animations['dead'].quads = {
		love.graphics.newQuad(0,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,100,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,200,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,300,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,400,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,500,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(0,600,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}
	
	self.animations['standing-center'] = {}
	self.animations['standing-center'].quads = {
		love.graphics.newQuad(0,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['standing-left'] = {}
	self.animations['standing-left'].quads = {
		love.graphics.newQuad(100,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['standing-right'] = {}
	self.animations['standing-right'].quads = {
		love.graphics.newQuad(400,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['crouching-left'] = {}
	self.animations['crouching-left'].quads = {
		love.graphics.newQuad(100, 1100,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['crouching-right'] = {}
	self.animations['crouching-right'].quads = {
		love.graphics.newQuad(400, 1100,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	--jumping animations
	self.animations['jumping-left'] = {}
	self.animations['jumping-left'].quads = {
		love.graphics.newQuad(200,700,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())

	}

	self.animations['jumping-right'] = {}

	self.animations['jumping-right'].quads = {
		love.graphics.newQuad(300,700,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	--running animations

	self.animations['running-left'] = {}
	--self.animations['running-left'].behaviour = 'once'
	self.animations['running-left'].frameInterval = 0.2
	self.animations['running-left'].quads = {
		love.graphics.newQuad(200,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(200,100,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(200,200,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(200,300,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(200,400,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['running-right'] = {}
	--self.animations['running-right'].behaviour = 'once'
	self.animations['running-right'].frameInterval = 0.2
	self.animations['running-right'].quads = {
		love.graphics.newQuad(300,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(300,100,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(300,200,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(300,300,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(300,400,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.state = 'standing-center'
	self.animation = {}
	self.animation.frame = 1
	self.animation.elapsed = 0

	--physics
	-------------------------------------------------------------------
	self.body = love.physics.newBody(world, pos.x, pos.y, "dynamic")
	self.shape = love.physics.newCircleShape(self.height/2)
	
	--self.body:setFixedRotation(true)
	self.fixture = love.physics.newFixture(self.body, 
						self.shape, 1)
	--self.fixture:setFriction(0)
						
	self.fixture:setUserData("player")
	self.body:setGravityScale(10)	
	self.fixture:setRestitution(0.2)
	self.body:setFixedRotation(true)
	self.body:setLinearDamping(4)

	--imaging
	-------------------------------------------------------------------
	--offset for drawing the image at the corner of the colliding rectangle
	self.drawnOffsetX = self.tileSizeX/2
	self.drawnOffsetY = self.tileSizeY/2

	--initial positions
	-------------------------------------------------------------------
	--initialize collider rectangle
	--rectangle is drawn from the centre
	self.col_x, self.col_y = self.body:getWorldPoints(x1, y1, x2, y2)

	--initialize image on corner
	--image is drawn from the top left corner
	self.image_x = self.col_x + self.drawnOffsetX
	self.image_y = self.col_y + self.drawnOffsetY

end

--player functions
-------------------------------------------------------------------
--movement
--note: update the collider, not the image
--control functions
function Player:getKeyPress(dt)
	--get the keypresses from the keyboard
	local currentKeyPress = "no key down"
	local velx, vely = self.body:getLinearVelocity()
    
    --movement input
    if love.keyboard.isDown("left") then
		self:moveLeft(dt,velx)
 	elseif love.keyboard.isDown("right") then
		self:moveRight(dt,velx)	
	end

	if love.keyboard.isDown("up") then
		self:moveUp(dt,vely)
 	elseif love.keyboard.isDown("down") then
		self:moveDown(dt)
	end

	--attack input
	if love.keyboard.isDown("z") then
		self:attack(dt)
	end

	--debug functions
	if love.keyboard.isDown("r") then 
		self:setPos(800/2, 650/2)
	end
end

function Player:moveLeft(dt,velx)
	if velx > -self.speed then --limit speed
		self.body:applyForce(-self.speed*250, 0)
		self:setState('running-left')
		end
end

function Player:moveRight(dt,velx)
	if velx < self.speed then --limit speed
		self.body:applyForce(self.speed*250, 0)
		self:setState('running-right')
	end
end

function Player:attack(dt)
	--self.playerAttack:initiateProjectile(self.col_x, self.col_y,
	--									self.height, self.width, self.state)
	self.playerAttack:initiateProjectile(self.body:getX(), self.body:getY(),
										self.height, self.width, self.state)
end

	--NOTE: y is downwards positive
function Player:moveUp(dt,vely)
--print(self.jump_stamina)
	if self.jump_stamina >= 0 and vely <= 0 and vely >= -self.speed then
		self.body:applyLinearImpulse(0,-self.speed*3)
		self:setOrientation('jumping')
		self.jump_stamina = self.jump_stamina - 1
	end
end

function Player:moveDown(dt)
	self:setOrientation('crouching')
end

function Player:setPos(x, y)
	self.body:setPosition(x, y)
end

function Player:handle_animation(dt)
	local xvel, yvel = self.body:getLinearVelocity()
	--print('xvel='..xvel..', yvel='..yvel)
	if self.state ~= 'dead' then
		local jumping = string.find(self.state,'jumping')
		if xvel >= -10 and xvel <= 10 and yvel >= -10 and yvel <= 10 and string.find(self.state, 'crouching') == nil then
			self:setOrientation('standing')
		elseif jumping == nil and yvel < -20 or yvel > 20 then 
			self:setOrientation('jumping')
		end
		if (yvel >= -1 and yvel <= 5) and self.jump_stamina ~= 1 then -- we hit the ground again
			self.jump_stamina = 1
		end
	end
	if self.animations[self.state].behaviour == nil then
		self:update_animation(dt)
	else --we have a behaviour -- so far will only be 'once' [loop only once]
		if self.animation.elapsed ~= 0 or 
		self.animation.frame < #self.animations[self.state].quads  then
			self:update_animation(dt)
		end
	end

end

--update animate img
function Player:update_animation(dt)
	self.animation.elapsed = self.animation.elapsed + dt
  
  -- Handle animation
  if #self.animations[self.state].quads > 1 then -- more than one frame
    local interval = self.animations[self.state].frameInterval
    
    if self.animation.elapsed > interval then -- switch to next frame

      if self.animation.frame + 1 > #self.animations[self.state].quads then-- loop around
        self.animation.frame = 1
	 else
		    self.animation.frame = self.animation.frame + 1
      end
      self.animation.elapsed = 0
    end
  end
end

--update players animation state
function Player:setState(newstate)
  if (self.state ~= newstate) then
    self.state = newstate
    self.animation.current = 1
    self.animation.frame = 1
  end
end

--update data
function Player:update_position(dt)
	--gets the collider coordinates and calcs the image start location
	self.col_x, self.col_y = self.body:getWorldPoints(x1, y1, x2, y2)
	self.image_x = self.col_x - self.drawnOffsetX
	self.image_y = self.col_y - self.drawnOffsetY
end

function Player:setOrientation(action)
	if string.find(self.state,'left') ~= nil then
		self:setState(action..'-left')
	else
		self:setState(action..'-right')
	end 
end

--draw function(s)
-------------------------------------------------------------------
--function draws the images and hitboxes
function Player:draw()
	--animation/image
    love.graphics.drawq(self.image, 
						self.animations[self.state].quads[self.animation.frame],
						self.image_x,
						self.image_y,
						0,
						1,
						1,
						0,
						0)
	--hitbox
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), self.shape:getRadius())
    --love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

    --attacks
	self.playerAttack:draw()
end

--update function(s)
-------------------------------------------------------------------

--function updates everything that is needed
function Player:update(dt)
	if self:die() then
		self:getKeyPress(dt)
		self:update_position(dt)
		self:handle_animation(dt)
		if (self.invulnTime >= 1) then
			self.invulnTime = self.invulnTime + dt
			if self.invulnTime >= 2 then
				self.invulnTime = 0
			end
		end
	else
		self:update_position(dt)
		self:handle_animation(dt)
	end
end

--attribute functions
-------------------------------------------------------------------
function Player:damage(dmg, pos)
	if (self.invulnTime == 0) then
		self.health = self.health - dmg
		self.invulnTime = 1
		if (pos > self.body:getX()) then
			self.body:applyLinearImpulse(-self.speed*2, 0)
		else
			self.body:applyLinearImpulse(self.speed*2, 0)
		end
		if self.health == 0 then
			self.state = 'dead'
		end
	end
end

function Player:die()
	if (self.health ~= 0 and self.state ~= 'dead') then
		return true
	else
		return false
	end
end
	