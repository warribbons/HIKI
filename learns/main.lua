require 'libraries/middleclass'
require 'libraries/middleclass-extras'
require 'libraries/gamestate'
require 'scenes/scene_lvl1'


function love.load()
	love.graphics.setCaption('Testing')
	  -- Seed random
	local seed = os.time()
	math.randomseed(seed);
	math.random(); math.random(); math.random()
	local f = love.graphics.newFont(love._vera_ttf, 10)
	Gamestate.registerEvents()
	Gamestate.switch(lvl1)
end

function love.update(dt)
end
	