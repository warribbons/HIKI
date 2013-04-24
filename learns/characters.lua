function loadPlayer()

	local player = {
		--initial position
		x = 75,
		y = 75,

		--attributes
		speed = 100,

		--image
		image = love.graphics.newImage("characters/hamster.png")
	}

	return player
end