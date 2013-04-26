Zombie = class('Zombie')

function Zombie:initialize(pos)
	--attributes
	-------------------------------------------------------------------
	self.speed = 50
	self.density = 80
	self.y_velocity = 0
	self.x_velocity = 0
	--image
	self.image = love.graphics.newImage("characters/zombie.png")
	self.height = 65
	self.width = 30
	self.state = 'risen'
	self.scale = 1.5

	self.gravity = 400
	self.ump_height = 5
	
	-- quads, animation frames
	-------------------------------------------------------------------
	self.tileSizeX = 30
	self.tileSizeY = 65

	self.animations = {}
	self.animations['risen'] = {}
	self.animations['risen'].behaviour = 'once'
	self.animations['risen'].frameInterval = 1
	self.animations['risen'].quads = {
		love.graphics.newQuad(6*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(7*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(8*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(9*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(10*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		--redundant would like to remove this if can fix animation to index properly
		love.graphics.newQuad(10*self.width,0,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['standing-left'] = {}
	self.animations['standing-left'].quads = {
		love.graphics.newQuad(3*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
	}

	self.animations['standing-right'] = {}
	self.animations['standing-right'].quads = {
		love.graphics.newQuad(18*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
	}

	self.animations['walking-left'] = {}
	self.animations['walking-left'].frameInterval = 0.5
	self.animations['walking-left'].quads = {
		love.graphics.newQuad(0*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(1*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(2*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(3*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(4*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(5*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(6*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(7*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animations['walking-right'] = {}
	self.animations['walking-right'].frameInterval = 0.5
	self.animations['walking-right'].quads = {
		love.graphics.newQuad(21*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(20*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(19*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(18*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(17*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(16*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(15*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight()),
		love.graphics.newQuad(14*self.width,1*self.height,self.tileSizeX,self.tileSizeY,self.image:getWidth(), self.image:getHeight())
	}

	self.animation = {}
	self.animation.frame = 1
	self.animation.elapsed = 0

	--physics
	-------------------------------------------------------------------
	self.body = love.physics.newBody(world, pos.x, pos.y, "dynamic")
	self.body:setFixedRotation(true)
	self.shape = love.physics.newRectangleShape(35, 90)
	self.fixture = love.physics.newFixture(self.body, 
						self.shape, self.density)



	--imaging
	-------------------------------------------------------------------
	--offset for drawing the image at the corner of the colliding rectangle
	self.drawnOffsetX = self.width
	self.drawnOffsetY = self.height

	--initial positions
	-------------------------------------------------------------------
	--initialize collider rectangle
	--rectangle is drawn from the centre
	self.col_x, self.col_y = self.body:getWorldPoints(x1, y1, x2, y2)

	--initialize image on corner
	--image is drawn from the top left corner
	self.image_x = self.col_x - self.drawnOffsetX
	self.image_y = self.col_y - self.drawnOffsetY

end





--zombie functions
-------------------------------------------------------------------
--movement
--note: update the collider, not the image
function Zombie:moveLeft(dt)
	if self.body:getLinearVelocity() > -self.speed then --limit speed
		x = self.col_x - (self.speed * dt)
		self.body:applyForce(-self.speed*250, 0)
		self.x_velocity = self.speed*250
		self:setState('walking-left')
	end
end

function Zombie:moveRight(dt)
	if self.body:getLinearVelocity() < self.speed then --limit speed
		x = self.col_x + (self.speed * dt)
		self.body:applyForce(self.speed*250, 0)
		self.x_velocity = self.speed*250
		self:setState('walking-right')
	end
end

	--NOTE: y is downwards positive
function Zombie:moveUp(dt)
	if self.y_velocity == 0 then
	self.body:applyForce(0,-999000)
	self.y_velocity = self.jump_height * 2000
	y = self.col_y + (self.speed * dt)
	self:setOrientation('jumping')
	end
end

function Zombie:setPos(x, y)
	self.body:setPosition(x, y)
end

function Zombie:handle_animation(dt)
	if string.find(self.state,'walking') ~= nil and self.body:getLinearVelocity() == 0 then
		self:setOrientation('standing')
	end
	if self.animations[self.state].behaviour == nil then
		self:update_animation(dt)
	else --we have a behaviour -- so far will only be 'once' [loop only once]

		if self.animation.frame  < #self.animations[self.state].quads  then
			self:update_animation(dt)
		else
			self:setOrientation('standing')
		end
	end
end

--update animate img
function Zombie:update_animation(dt)
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

--update zombies animation state
function Zombie:setState(newstate)
  if (self.state ~= newstate) then
    self.state = newstate
    self.animation.current = 1
    self.animation.frame = 1
  end
end

--update data
function Zombie:update_position(dt,pos)
	if self.state ~= 'risen' then
		if self.col_x ~= pos.x then -- track the player
			if self.col_x > pos.x then
				self:moveLeft(dt)
			else
				self:moveRight(dt)
			end
		end
		--gets the collider coordinates and calcs the image start location
		self.col_x, self.col_y = self.body:getWorldPoints(x1, y1, x2, y2)
		self.image_x = self.col_x - self.drawnOffsetX
		self.image_y = self.col_y - self.drawnOffsetY
	end
end

function Zombie:setOrientation(action)
	if string.find(self.state,'left') ~= nil then
		self:setState(action..'-left')
	else
		self:setState(action..'-right')
	end
end

--draw function(s)

--function draws the images and hitboxes
function Zombie:draw()
	--print(enemies[0])
	--for i, zombie in ipairs(enemies) do --these should all reference inner copy of table zombie
	--animation
	    --set back to default colour
				love.graphics.setColor(r, g, b, a)
				love.graphics.drawq(self.image, 
						self.animations[self.state].quads[self.animation.frame],
						self.image_x,
						self.image_y,
						0,
						1.5,
						1.5,
						-5,
						-10)

	--hitbox
   		 love.graphics.setColor(50, 50, 50)
		--love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints())) 

end

--update function(s)

--function updates everything that is needed
function Zombie:update(dt,pos)
	self:update_position(dt,pos)
	self:handle_animation(dt)
end
