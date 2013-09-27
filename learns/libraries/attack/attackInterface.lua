--weapons module
require '../vector'
require '../libraries/middleclass'
--require '../weapons/basicWeapon'

Attack = class('attack')

function Attack:initialize()
	print("attack init")
	self.attack_timer_start = love.timer.getTime()
	self.attack_timer_current = love.timer.getTime()
	self.attack_timer_delta = self.attack_timer_current - self.attack_timer_start
end

--input:
--[[	px = player x position (from the middle)
  		py = player y position (from the middle)
  		ph = player height
  		py = player width
  		ps = player state
]]--
function Attack:initiateProjectile(px, py, ph, pw, ps)
	--get the time right away
	self.attack_timer_current = love.timer.getTime()
	--if 0, then the attack can be done
	if(self.attack_timer_delta == 0) then
		--draw circle & collision
		self:createProjectile(px, py, ph, pw, ps)
		--time since last attack
		self.attack_timer_start = love.timer.getTime()
	end
	--calculate time since last attack
	self.attack_timer_delta = self.attack_timer_current - self.attack_timer_start
	--if delta is greater than the cool down(right now = 2) then allow an attack
	if(self.attack_timer_delta > .5) then
		self.attack_timer_delta = 0
	end
end

function Attack:createProjectile(px, py, ph, pw, ps)
		print("attack accepted")
		print("x: " .. px .. " y: " .. py)

		local vertices = {px, py, 10, 5, px, py}

		if string.find(ps,'left') ~= nil then
			print("facing: left")
			print("firing @ x: " .. px-pw .. " y: " .. py)
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("line", px-pw, py, 5, 5)
			--love.graphics.point(px-pw, py)	
			--love.graphics.polygon("fill", vertices)
		else
			print("facing: right")
		end 		
		

end