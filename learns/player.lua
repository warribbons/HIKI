
player = {
	--attributes
	speed = 200,
	density = 80,
	y_velocity = 0,
	x_velocity = 0,
	--image
	image = love.graphics.newImage("characters/player.png"),
	height = 73,
	width = 69
}
gravity = 400
jump_height = 5


-- quads, animation frames
-------------------------------------------------------------------
tileSizeX = 100
tileSizeY = 100

player.animations = {}
player.animations['standing-center'] = {}
player.animations['standing-center'].quads = {
	love.graphics.newQuad(0,0,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['standing-left'] = {}
player.animations['standing-left'].quads = {
	love.graphics.newQuad(100,0,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['standing-right'] = {}
player.animations['standing-right'].quads = {
	love.graphics.newQuad(400,0,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['jumping-left'] = {}
player.animations['jumping-left'].behaviour = 'once'
player.animations['jumping-left'].frameInterval = 0.15
player.animations['jumping-left'].quads = {
	love.graphics.newQuad(200,700,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(200,800,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['jumping-right'] = {}
player.animations['jumping-right'].behaviour = 'once'
player.animations['jumping-right'].frameInterval = 0.15
player.animations['jumping-right'].quads = {
	love.graphics.newQuad(300,700,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(300,800,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['running-left'] = {}
--player.animations['running-left'].behaviour = 'once'
player.animations['running-left'].frameInterval = 0.2
player.animations['running-left'].quads = {
	love.graphics.newQuad(200,0,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(200,100,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(200,200,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(200,300,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(200,400,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.animations['running-right'] = {}
--player.animations['running-right'].behaviour = 'once'
player.animations['running-right'].frameInterval = 0.2
player.animations['running-right'].quads = {
	love.graphics.newQuad(300,0,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(300,100,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(300,200,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(300,300,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight()),
	love.graphics.newQuad(300,400,tileSizeX,tileSizeY,player.image:getWidth(), player.image:getHeight())
}

player.state = 'standing-center'
player.animation = {}
player.animation.frame = 1
player.animation.elapsed = 0

--physics
-------------------------------------------------------------------
player.body = love.physics.newBody(world, 400, 200, "dynamic")
player.shape = love.physics.newRectangleShape(69,73)
player.fixture = love.physics.newFixture(player.body, 
					player.shape, player.density)



--imaging
-------------------------------------------------------------------
--offset for drawing the image at the corner of the colliding rectangle
player.drawnOffsetX = player.width/3
player.drawnOffsetY = player.height/3

--initial positions
-------------------------------------------------------------------
--initialize collider rectangle
--rectangle is drawn from the centre
player.col_x, player.col_y = player.body:getWorldPoints(x1, y1, x2, y2)

--initialize image on corner
--image is drawn from the top left corner
player.image_x = player.col_x - player.drawnOffsetX
player.image_y = player.col_y - player.drawnOffsetY

--player functions
-------------------------------------------------------------------
--movement
--note: update the collider, not the image
function player:moveLeft(dt)
	if player.body:getLinearVelocity() > -player.speed then --limit speed
		x = player.col_x - (player.speed * dt)
		player.body:applyForce(-player.speed*250, 0)
		player.x_velocity = player.speed*250
		player:setState('running-left')
		end
end

function player:moveRight(dt)
	if player.body:getLinearVelocity() < player.speed then --limit speed
		x = player.col_x + (player.speed * dt)
		player.body:applyForce(player.speed*250, 0)
		player.x_velocity = player.speed*250
		player:setState('running-right')
	end
end

	--NOTE: y is downwards positive
function player:moveUp(dt)
	if player.y_velocity == 0 then
	player.body:applyForce(0,-999000)
	player.y_velocity = jump_height * 2000
	y = player.col_y + (player.speed * dt)
	player:setOrientation('jumping')
	end
end

function player:moveDown(dt)
	--y = player.col_y + (player.speed * dt)
	--player.body:setPosition(player.col_x, y)
end

function player:setPos(x, y)
	player.body:setPosition(x, y)
end

function player:handle_animation(dt)
	if string.find(player.state,'running') ~= nil and player.body:getLinearVelocity() == 0 then
		player:setOrientation('standing')
	end
	if player.animations[player.state].behaviour == nil then
		player:update_animation(dt)
	else --we have a behaviour -- so far will only be 'once' [loop only once]
		if player.animation.elapsed ~= 0 or 
		player.animation.frame + 1 > #player.animations[player.state].quads  then
			player:update_animation(dt)
		end
	end
end

--update animate img
function player:update_animation(dt)
	player.animation.elapsed = player.animation.elapsed + dt
  
  -- Handle animation
  if #player.animations[player.state].quads > 1 then -- more than one frame
    local interval = player.animations[player.state].frameInterval
    
    if player.animation.elapsed > interval then -- switch to next frame

      if player.animation.frame + 1 > #player.animations[player.state].quads then-- loop around
        player.animation.frame = 1
	 else
		    player.animation.frame = player.animation.frame + 1
      end
      player.animation.elapsed = 0
    end
  end
end

--update players animation state
function player:setState(newstate)
  if (player.state ~= newstate) then
    player.state = newstate
    player.animation.current = 1
    player.animation.frame = 1
  end
end

--update data
function player:update_position(dt)
	if player.y_velocity ~= 0 then -- we're probably jumping
        player.col_y = player.col_y + player.y_velocity * dt -- dt means we wont move at
        -- different speeds if the game lags
		player.y_velocity = player.y_velocity - gravity * dt
        if player.col_y > 557 then -- we hit the ground again
            player.y_velocity = 0
			player:setOrientation('standing')
        end
    end
	--gets the collider coordinates and calcs the image start location
	player.col_x, player.col_y = player.body:getWorldPoints(x1, y1, x2, y2)
	player.image_x = player.col_x - player.drawnOffsetX
	player.image_y = player.col_y - player.drawnOffsetY
end

function player:setOrientation(action)
	if string.find(player.state,'left') ~= nil then
		player:setState(action..'-left')
	else
		player:setState(action..'-right')
	end
end