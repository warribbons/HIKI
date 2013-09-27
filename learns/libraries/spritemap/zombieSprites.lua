	
	zombieSprites = {}
	zombieSprites.tileSizeX = 30
	zombieSprites.tileSizeY = 65
	zombieSprites.image = love.graphics.newImage("sprites/characters/zombie.png")
	zombieSprites.animations = {}
	zombieSprites.animations['risen'] = {}
	zombieSprites.animations['risen'].behaviour = 'once'
	zombieSprites.animations['risen'].frameInterval = 0.5
	zombieSprites.animations['risen'].quads = {
		love.graphics.newQuad(6*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(7*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(8*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(9*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(10*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(10*zombieSprites.tileSizeX,0,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight())
	}

	zombieSprites.animations['standing-left'] = {}
	zombieSprites.animations['standing-left'].quads = {
		love.graphics.newQuad(3*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
	}

	zombieSprites.animations['standing-right'] = {}
	zombieSprites.animations['standing-right'].quads = {
		love.graphics.newQuad(18*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
	}

	zombieSprites.animations['walking-left'] = {}
	zombieSprites.animations['walking-left'].frameInterval = 0.5
	zombieSprites.animations['walking-left'].quads = {
		love.graphics.newQuad(0*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(1*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(2*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(3*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(4*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(5*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(6*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(7*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight())
	}

	zombieSprites.animations['walking-right'] = {}
	zombieSprites.animations['walking-right'].frameInterval = 0.5
	zombieSprites.animations['walking-right'].quads = {
		love.graphics.newQuad(21*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(20*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(19*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(18*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(17*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(16*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(15*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight()),
		love.graphics.newQuad(14*zombieSprites.tileSizeX,1*zombieSprites.tileSizeY,zombieSprites.tileSizeX,zombieSprites.tileSizeY,zombieSprites.image:getWidth(), zombieSprites.image:getHeight())
	}