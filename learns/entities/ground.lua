
require '../libraries/middleclass'

Ground = class('Ground')

--physics
function Ground:initialize()
	self.body = love.physics.newBody(world, 0, 0, "static") --not dynamic
	self.shape = love.physics.newRectangleShape(0, 0, 99999, 10)
	self.fixture = love.physics.newFixture(self.body, self.shape)
end


