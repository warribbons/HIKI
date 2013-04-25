player = {
	--attributes
	speed = 200,
	density = 1,
	jumpStrength = -800, --negative is up

	--image
	image = love.graphics.newImage("characters/testimage.png"),
	height = 73,
	width = 69
}

--physics
-------------------------------------------------------------------
player.body = love.physics.newBody(world, 400, 200, "dynamic")
player.shape = love.physics.newRectangleShape(69,73)
player.fixture = love.physics.newFixture(player.body, 
					player.shape, player.density)

--imaging
-------------------------------------------------------------------
--offset for drawing the image at the corner of the colliding rectangle
player.drawnOffsetX = player.width/2
player.drawnOffsetY = player.height/2

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
	x = player.col_x - (player.speed * dt)
	player.body:setPosition(x, player.col_y)
end

function player:moveRight(dt)
	x = player.col_x + (player.speed * dt)
	player.body:setPosition(x, player.col_y)
end

	--NOTE: y is downwards positive
function player:moveUp(dt)
	player.body:applyForce(0, player.jumpStrength)
end

function player:moveDown(dt)
	y = player.col_y + (player.speed * dt)
	player.body:setPosition(player.col_x, y)
end

function player:setPos(x, y)
	player.body:setPosition(x, y)
end

--update data
function player:update_position()
	--gets the collider coordinates and calcs the image start location
	player.col_x, player.col_y = player.body:getWorldPoints(x1, y1, x2, y2)
	player.image_x = player.col_x - player.drawnOffsetX
	player.image_y = player.col_y - player.drawnOffsetY
end