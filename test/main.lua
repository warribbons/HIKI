function makeChar(x, y)
    local o = {}
    o.x = x
    o.y = y
 
    o.body = love.physics.newBody(world, x, y, "dynamic")
    o.body:setMass(5)
    o.body:setFixedRotation(true)
 
    o.shapeLeft   = love.physics.newCircleShape(-20, 0, 5)
    o.shapeTop    = love.physics.newCircleShape(0, -50, 5)
    o.shapeRight  = love.physics.newCircleShape(20, 0, 5)
    o.shapeBottom = love.physics.newCircleShape(0, 50, 5)
 
    o.fixtureLeft   = love.physics.newFixture(o.body, o.shapeLeft, 1)
    o.fixtureLeft:setFriction(0)
    o.fixtureTop    = love.physics.newFixture(o.body, o.shapeTop, 1)
    o.fixtureTop:setFriction(0)
    o.fixtureRight  = love.physics.newFixture(o.body, o.shapeRight, 1)
    o.fixtureRight:setFriction(0)
    o.fixtureBottom = love.physics.newFixture(o.body, o.shapeBottom, 1)
    o.fixtureBottom:setFriction(100)
 
    o.jumpEnabled = false
 
    return o
end
 
renderArray = {}
chainArray  = {}
 
function love.load()
    love.graphics.setMode(700, 700, false, false)
    love.physics.setMeter(64)
 
    world = love.physics.newWorld(0, 50*64, true)
    world:setCallbacks(beginContact, endContact, function() end, function() end)
 
    worldBody = love.physics.newBody(world, 0, 0, "static")
    worldShape = love.physics.newChainShape("false",
        80, -100,
        80, 680,
        120, 680,
        180, 680,
        220, 680,
        280, 680,
        320, 680,
        380, 680,
        420, 680,
        480, 680,
        520, 680,
        620, 680,
        620, -100)
    worldFixture = love.physics.newFixture(worldBody, worldShape, 1)
 
    char = makeChar(100, 100)
 
    chainArray[#chainArray+1] = createChain(20, 340, 100)
    chainArray[#chainArray+1] = createChain(20, 400, 10)
    chainArray[#chainArray+1] = createChain(20, 300, 10)
    chainArray[#chainArray+1] = createChain(40, 300, 10)
    chainArray[#chainArray+1] = createChain(30, 200, 10)
end
 
function beginContact(a, b, coll)
    if a == char.fixtureBottom or b == char.fixtureBottom then
        char.jumpEnabled = true
    end
end
 
function endContact(a, b, coll)
    if a == char.fixtureBottom or b == char.fixtureBottom then
        char.jumpEnabled = false
    end
end
 
function love.draw()
    love.graphics.polygon("line", worldBody:getWorldPoints(worldShape:getPoints()))
 
    for i=1, #renderArray do
        local ob = renderArray[i]
        love.graphics.polygon("line", ob.body:getWorldPoints(ob.shape:getPoints()))
    end
 
    local charX, charY = char.body:getWorldCenter()
    love.graphics.circle("line", charX-20, charY, 5)
    love.graphics.circle("line", charX, charY+50, 5)
    love.graphics.circle("line", charX+20, charY, 5)
    love.graphics.circle("line", charX, charY-50, 5)
 
    love.graphics.setCaption(tostring(love.timer.getFPS()))
end
 
function love.update(dt)
    -- update chains
    for i=1, #chainArray do
        local arr = chainArray[i]
        for j=i, #arr do
            local ob = arr[j]
            local angle = (j/#arr) * math.pi * 2
            local fx = 300 * math.cos(angle)
            local fy = 300 * math.sin(angle)
            ob.body:applyForce(fx, fy)
        end
    end
 
    world:update(dt/2)
 
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        local x, y = char.body:getLinearVelocity()
        char.body:setLinearVelocity(500, y)
    end
 
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        local x, y = char.body:getLinearVelocity()
        char.body:setLinearVelocity(-500, y)
    end
 
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        if char.jumpEnabled then
            local x, y = char.body:getLinearVelocity()
            char.body:setLinearVelocity(x, -1500)
        end
    end
end
 
function love.keypressed(key, unicode)
    if key == "escape" then love.event.push("quit") end
end
 
function createGameObject(x, y, w, h)
    local o = {}
 
    o.body    = love.physics.newBody(world, x, y, "dynamic")
    o.body:setMass(5)
    o.shape   = love.physics.newRectangleShape(0, 0, w, h)
    o.fixture = love.physics.newFixture(o.body, o.shape, 1)
    o.fixture:setRestitution(0)
    o.fixture:setFriction(.1)
 
    table.insert(renderArray, o)
    return o
end
 
function createChain(n, x, y)
    local w = 10
    local h = 5
 
    local prevBody   = nil
    local firstBody  = nil
    local chainArray = {}
    for i=1, n do
        local angle  = (i/n) * math.pi * 2
        local radius = 35
        local ob = createGameObject(
            x + math.cos(angle) * radius,
            y + math.sin(angle) * radius,
            w, h)
        chainArray[#chainArray+1] = ob
        ob.body:setAngle(angle+math.pi/2)
 
        if prevBody ~= nil then
            love.physics.newRevoluteJoint(
                ob.body,
                prevBody.body,
                prevBody.body:getX() + math.cos(angle+math.pi/2) * w/2,
                prevBody.body:getY() + math.sin(angle+math.pi/2) * h/2,
                false)
        end
        prevBody = ob
        if i == 1 then firstBody = ob end
        if i == n then
            prevBody = firstBody
            love.physics.newRevoluteJoint(
                ob.body,
                prevBody.body,
                prevBody.body:getX() - math.cos(angle+math.pi/2) * w/2,
                prevBody.body:getY() - math.sin(angle+math.pi/2) * h/2,
                false)
        end
    end
    return chainArray
end