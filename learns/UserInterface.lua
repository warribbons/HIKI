--user interface

require 'libraries/middleclass'
UserInterface = class('UserInterface')

function UserInterface:initialize()
	self.pos_x = 0
	self.pos_y = 630
end

function UserInterface:draw(x, y, player)
	self.pos_x = x
	self.pos_y = y + 600
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", self.pos_x, self.pos_y, 800, 50)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("Health: " .. player.health, self.pos_x, self.pos_y)
end

