ground = {}

--physics
ground.body = love.physics.newBody(world, 0, 0, "static") --not dynamic
ground.shape = love.physics.newRectangleShape(800/2, 600, 600, 10)
ground.fixture = love.physics.newFixture(ground.body, ground.shape)
