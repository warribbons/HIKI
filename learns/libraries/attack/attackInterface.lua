--weapons module
require '../vector'
require '../libraries/middleclass'
--require '../weapons/basicWeapon'

Attack = class('attack')

function Attack:initialize()
	print("attack init")
	--timer parameters
	self.attack_timer_start = love.timer.getTime()
	self.attack_timer_current = love.timer.getTime()
	self.attack_timer_delta = self.attack_timer_current - self.attack_timer_start

	--current projectiles table
	self.projectiles = {}
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
		--add the current projectile to the table
		self:addToTable(px, py, ph, pw, ps)
		--draw circle & collision
		self:createProjectile()
		--time since last attack
		self.attack_timer_start = love.timer.getTime()
	end
	--calculate time since last attack
	self.attack_timer_delta = self.attack_timer_current - self.attack_timer_start
	--if delta is greater than the cooldown(right now = 2) then allow an attack
	if(self.attack_timer_delta > .5) then
		self.attack_timer_delta = 0
	end
end

function Attack:createProjectile()
	for i, v in ipairs(self.projectiles) do
		print("attack #: " .. i)
		print("attack accepted")
		print("x: " .. v.x .. " y: " .. v.y)

		local vertices = {v.x, v.y, 10, 5, v.x, v.y}

		if string.find(v.s,'left') ~= nil then
			print("facing: left")
			print("firing @ x: " .. v.x-v.w .. " y: " .. v.y)
			--love.graphics.setColor(255, 255, 255)
			--love.graphics.circle("line", px-pw, py, 5, 5)
			--love.graphics.point(px-pw, py)	
			--love.graphics.polygon("fill", vertices)
		else
			print("facing: right")
		end 	
	end
end

function Attack:addToTable(px, py, ph, pw, ps)
	local proj = {}
	proj.x = px
	proj.y = py
	proj.h = ph
	proj.w = pw
	proj.s = ps
	table.insert(self.projectiles, proj)
end

--[[
	perhaps use a dynamically allocated array to create multiple projectiles?
	for now, we will use a static array
]]--
function Attack:draw()
	--print("drawing")
	love.graphics.setColor(255,255,255,255)
    for i,v in ipairs(self.projectiles) do
        love.graphics.rectangle("fill", v.x, v.y, 5, 2)
    end
end