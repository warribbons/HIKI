
zombie = {
	--attributes
	speed = 50,
	density = 80,
	y_velocity = 0,
	x_velocity = 0,
	--image
	image = love.graphics.newImage("characters/zombie.png"),
	height = 65,
	width = 30,
	state = 'risen',
	scale = 1.5,

	gravity = 400,
	jump_height = 5
}


-- quads, animation frames
-------------------------------------------------------------------
zombie.tileSizeX = 30
zombie.tileSizeY = 65

zombie.animations = {}
zombie.animations['risen'] = {}
zombie.animations['risen'].behaviour = 'once'
zombie.animations['risen'].frameInterval = 0.5
zombie.animations['risen'].quads = {
	love.graphics.newQuad(6*zombie.width,0,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(7*zombie.width,0,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(8*zombie.width,0,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(9*zombie.width,0,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(10*zombie.width,0,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight())
}

zombie.animations['standing-left'] = {}
zombie.animations['standing-left'].quads = {
	love.graphics.newQuad(3*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
}

zombie.animations['standing-right'] = {}
zombie.animations['standing-right'].quads = {
	love.graphics.newQuad(18*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
}

zombie.animations['walking-left'] = {}
zombie.animations['walking-left'].frameInterval = 0.5
zombie.animations['walking-left'].quads = {
	love.graphics.newQuad(0*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(1*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(2*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(3*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(4*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(5*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(6*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(7*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight())
}

zombie.animations['walking-right'] = {}
zombie.animations['walking-right'].frameInterval = 0.5
zombie.animations['walking-right'].quads = {
	love.graphics.newQuad(21*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(20*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(19*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(18*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(17*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(16*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(15*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight()),
	love.graphics.newQuad(14*zombie.width,1*zombie.height,zombie.tileSizeX,zombie.tileSizeY,zombie.image:getWidth(), zombie.image:getHeight())
}

zombie.animation = {}
zombie.animation.frame = 1
zombie.animation.elapsed = 0

--physics
-------------------------------------------------------------------
zombie.body = love.physics.newBody(world, 400, 200, "dynamic")
zombie.body:setFixedRotation(true)
zombie.shape = love.physics.newRectangleShape(35, 90)
zombie.fixture = love.physics.newFixture(zombie.body, 
					zombie.shape, zombie.density)



--imaging
-------------------------------------------------------------------
--offset for drawing the image at the corner of the colliding rectangle
zombie.drawnOffsetX = zombie.width
zombie.drawnOffsetY = zombie.height

--initial positions
-------------------------------------------------------------------
--initialize collider rectangle
--rectangle is drawn from the centre
zombie.col_x, zombie.col_y = zombie.body:getWorldPoints(x1, y1, x2, y2)

--initialize image on corner
--image is drawn from the top left corner
zombie.image_x = zombie.col_x - zombie.drawnOffsetX
zombie.image_y = zombie.col_y - zombie.drawnOffsetY

--zombie functions
-------------------------------------------------------------------
--movement
--note: update the collider, not the image
function zombie:moveLeft(dt)
	if zombie.body:getLinearVelocity() > -zombie.speed then --limit speed
		x = zombie.col_x - (zombie.speed * dt)
		zombie.body:applyForce(-zombie.speed*250, 0)
		zombie.x_velocity = zombie.speed*250
		zombie:setState('walking-left')
		end
end

function zombie:moveRight(dt)
	if zombie.body:getLinearVelocity() < zombie.speed then --limit speed
		x = zombie.col_x + (zombie.speed * dt)
		zombie.body:applyForce(zombie.speed*250, 0)
		zombie.x_velocity = zombie.speed*250
		zombie:setState('walking-right')
	end
end

	--NOTE: y is downwards positive
function zombie:moveUp(dt)
	if zombie.y_velocity == 0 then
	zombie.body:applyForce(0,-999000)
	zombie.y_velocity = zombie.jump_height * 2000
	y = zombie.col_y + (zombie.speed * dt)
	zombie:setOrientation('jumping')
	end
end

function zombie:moveDown(dt)
	--y = zombie.col_y + (zombie.speed * dt)
	--zombie.body:setPosition(zombie.col_x, y)
end

function zombie:setPos(x, y)
	zombie.body:setPosition(x, y)
end

function zombie:handle_animation(dt)
	if string.find(zombie.state,'walking') ~= nil and zombie.body:getLinearVelocity() == 0 then
		zombie:setOrientation('standing')
	end
	if zombie.animations[zombie.state].behaviour == nil then
		zombie:update_animation(dt)
	else --we have a behaviour -- so far will only be 'once' [loop only once]
		if zombie.animation.elapsed ~= 0 or 
		zombie.animation.frame + 1 > #zombie.animations[zombie.state].quads  then
			zombie:update_animation(dt)
		end
	end
end

--update animate img
function zombie:update_animation(dt)
	zombie.animation.elapsed = zombie.animation.elapsed + dt
  
  -- Handle animation
  if #zombie.animations[zombie.state].quads > 1 then -- more than one frame
    local interval = zombie.animations[zombie.state].frameInterval
    
    if zombie.animation.elapsed > interval then -- switch to next frame

      if zombie.animation.frame + 1 > #zombie.animations[zombie.state].quads then-- loop around
        zombie.animation.frame = 1
	 else
		    zombie.animation.frame = zombie.animation.frame + 1
      end
      zombie.animation.elapsed = 0
    end
  end
end

--update zombies animation state
function zombie:setState(newstate)
  if (zombie.state ~= newstate) then
    zombie.state = newstate
    zombie.animation.current = 1
    zombie.animation.frame = 1
  end
end

--update data
function zombie:update_position(dt)
	if zombie.col_x ~= player.col_x then -- we're probably jumping
		print(dt)
		if zombie.col_x > player.col_x then
			zombie:moveLeft(dt)
		else
			zombie:moveRight(dt)
		end
    end
	--gets the collider coordinates and calcs the image start location
	zombie.col_x, zombie.col_y = zombie.body:getWorldPoints(x1, y1, x2, y2)
	zombie.image_x = zombie.col_x - zombie.drawnOffsetX
	zombie.image_y = zombie.col_y - zombie.drawnOffsetY
end

function zombie:setOrientation(action)
	if string.find(zombie.state,'left') ~= nil then
		zombie:setState(action..'-left')
	else
		zombie:setState(action..'-right')
	end
end

--draw function(s)

--function draws the images and hitboxes
function zombie:draw()
	if #enemies == 0 then --more than one enemy?
		spawnEnemy()
	end
	print(enemies[0])
	for i, zombie in ipairs(enemies) do --these should all reference inner copy of table zombie
	--animation
	    --set back to default colour
    	love.graphics.setColor(r, g, b, a)
        love.graphics.drawq(zombie.image, 
						zombie.animations[zombie.state].quads[zombie.animation.frame],
						zombie.image_x,
						zombie.image_y,
						0,
						1.5,
						1.5,
						-5,
						-10)

	--hitbox
   		 love.graphics.setColor(50, 50, 50)
		love.graphics.polygon("line", zombie.body:getWorldPoints(zombie.shape:getPoints())) 
    end
end

--update function(s)

--function updates everything that is needed
function zombie:update_all(dt)
	for i, zombie in ipairs(enemies) do --these should all reference inner copy of table zombie
		zombie:update_position(dt)
		zombie:handle_animation(dt)
	end
end
