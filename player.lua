local Player = {}

-- animation config
local FRAME_W, FRAME_H     = 64, 64
local FRAME_TIME           = 0.08
local FRAMES_TOTAL         = 10 -- walking
local IDLE_FRAMES_TOTAL    = 6  -- idle
local facing               = 1  -- 0 = left, 1 = right
local currentIdle;
local currentIdleQuads;

-- assets
local spriteLeft, spriteRight, spriteIdleLeft, spriteIdleRight
local quadsLeft, quadsRight, quadsIdleLeft, quadsIdleRight = {}, {}, {}, {}

-- animation state
local currentSprite, currentQuads
local currentFrame, frameTimer = 1, 0

-- physics
local body

-- map transition flag
local mapChangeTriggered = false

function Player.triggerMapChange()
    mapChangeTriggered = true
end

function Player.clearMapChange()
    mapChangeTriggered = false
end

----------------------------------------------------------------
function Player.load(world)
    spriteLeft       = love.graphics.newImage("assets/sprites/enemies_left.png")
    spriteRight      = love.graphics.newImage("assets/sprites/enemies.png")
    spriteIdleLeft   = love.graphics.newImage("assets/sprites/enemies_idle_l.png")
    spriteIdleRight  = love.graphics.newImage("assets/sprites/enemies_idle_r.png")

    -- cut frames
    for i = 0, FRAMES_TOTAL - 1 do
        quadsLeft[i + 1]  = love.graphics.newQuad(i * FRAME_W, 14, FRAME_W, FRAME_H, spriteLeft:getDimensions())
        quadsRight[i + 1] = love.graphics.newQuad(i * FRAME_W, 14, FRAME_W, FRAME_H, spriteRight:getDimensions())
    end
    for i = 0, IDLE_FRAMES_TOTAL - 1 do
        quadsIdleLeft[i + 1]  = love.graphics.newQuad(i * FRAME_W, 14, FRAME_W, FRAME_H, spriteIdleLeft:getDimensions())
        quadsIdleRight[i + 1] = love.graphics.newQuad(i * FRAME_W, 14, FRAME_W, FRAME_H, spriteIdleRight:getDimensions())
    end

    -- default facing
    currentSprite = spriteRight
    currentQuads  = quadsRight
    currentIdle   = spriteIdleRight
    currentIdleQuads = quadsIdleRight

    -- body
    body = love.physics.newBody(world, 100, 100, "dynamic")
    body:setFixedRotation(true)
    local shape = love.physics.newRectangleShape(25, 23)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData("Player")
end

----------------------------------------------------------------
function Player.update(dt)
    local speed = 50
    local vx, vy = 0, 0
    local moved = false

    if love.keyboard.isDown("w") then
        vy = vy - 1
        facing = 2  -- up
    end
    if love.keyboard.isDown("s") then
        vy = vy + 1
        facing = 3  -- down
    end
    if love.keyboard.isDown("a") then
        vx = vx - 1
        facing = 0
    end
    if love.keyboard.isDown("d") then
        vx = vx + 1
        facing = 1
    end
    if vx ~= 0 or vy ~= 0 then
        moved = true
    end

    local len = math.sqrt(vx * vx + vy * vy)
    if len > 0 then
        vx, vy = vx / len, vy / len
        body:setLinearVelocity(vx * speed, vy * speed)
    else
        body:setLinearVelocity(0, 0)
    end

    -- animation update
    frameTimer = frameTimer + dt
    if moved then
        if facing == 0 then
            currentSprite = spriteLeft
            currentQuads = quadsLeft
        elseif facing == 1 then
            currentSprite = spriteRight
            currentQuads = quadsRight
        elseif facing == 2 then
            currentSprite = spriteLeft
            currentQuads = quadsLeft
        elseif facing == 3 then
            currentSprite = spriteRight
            currentQuads = quadsRight
        end

        if currentFrame > FRAMES_TOTAL then
            currentFrame = 1
        end

        if frameTimer >= FRAME_TIME then
            frameTimer = frameTimer - FRAME_TIME
            currentFrame = currentFrame % FRAMES_TOTAL + 1
        end
    else
        if facing == 0 then
            currentSprite = spriteIdleLeft
            currentQuads = quadsIdleLeft
        elseif facing == 1 then
            currentSprite = spriteIdleRight
            currentQuads = quadsIdleRight
        elseif facing == 2 then
            currentSprite = spriteIdleLeft
            currentQuads = quadsIdleLeft
        elseif facing == 3 then
            currentSprite = spriteIdleRight
            currentQuads = quadsIdleRight
        end

        if currentFrame > IDLE_FRAMES_TOTAL then
            currentFrame = 1
        end
        
        if frameTimer >= FRAME_TIME then
            frameTimer = frameTimer - FRAME_TIME
            currentFrame = currentFrame % IDLE_FRAMES_TOTAL + 1
        end
    end
end

----------------------------------------------------------------
function Player.draw()
    local x, y = body:getPosition()
    love.graphics.draw(currentSprite, currentQuads[currentFrame], x - FRAME_W/2, y - FRAME_H/2)
end

function Player.debugDraw()
    local x, y = body:getPosition()
    local shape = body:getFixtures()[1]:getShape()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(body:getAngle())
    if shape:typeOf("PolygonShape") then
        love.graphics.polygon("line", shape:getPoints())
    end
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------------------------------
function Player.setPosition(x, y)
    if body then
        body:setPosition(x, y)
        body:setLinearVelocity(0, 0)
    end
end

function Player.getPosition()
    if body then return body:getPosition() end
    return 0, 0
end

return Player
