local Player = {}

-- animation config
local FRAME_W, FRAME_H = 32, 32
local FRAMES_TOTAL     = 4
local FRAME_TIME       = 0.1

-- runtime
local spriteLeft, quadsLeft = {}, {}
local spriteRight, quadsRight = {}, {}
local currentSprite, currentQuads
local currentFrame, frameTimer = 1, 0

-- physics handles
local body


function Player.load(world)
    -- sprite sheet → quads
    -- sprite sheet → quads  (horizontal layout: 4 × 32×32 = 128×32)
    spriteLeft = love.graphics.newImage("assets/sprites/player_left.png") -- 128×32
    for i = 0, FRAMES_TOTAL - 1 do
        quadsLeft[i + 1] = love.graphics.newQuad(
            i * FRAME_W,         -- x-offset moves horizontally
            0,                   -- y-offset stays 0
            FRAME_W, FRAME_H,    -- frame size
            spriteLeft:getDimensions()
        )
    end

    spriteRight = love.graphics.newImage("assets/sprites/player_right.png") -- 128×32
    for i = 0, FRAMES_TOTAL - 1 do
        quadsRight[i + 1] = love.graphics.newQuad(
            i * FRAME_W,         -- x-offset moves horizontally
            0,                   -- y-offset stays 0
            FRAME_W, FRAME_H,    -- frame size
            spriteRight:getDimensions()
        )
    end

    currentSprite = spriteLeft
    currentQuads = quadsLeft

    local startX, startY = 100, 100    -- later: read from Tiled object
    body = love.physics.newBody(world, startX, startY, "dynamic")
    body:setFixedRotation(true) -- <--- Add this line
    local shape   = love.physics.newRectangleShape(19, 23)
    local shapeTruncated = love.physics.newRectangleShape()
    local fixture = love.physics.newFixture(body, shapeTruncated)
    fixture:setUserData("Player")
end

-- update player position based on keyboard input
-- and animate sprite frames
function Player.update(dt)
    local speed = 100
    local vx, vy = 0, 0
    if love.keyboard.isDown("w") then 
        vy = vy - 1 
    end
    if love.keyboard.isDown("s") then 
        vy = vy + 1
    end
    if love.keyboard.isDown("a") then 
        vx = vx - 1 
        currentSprite = spriteLeft
        currentQuads = quadsLeft
    end
    if love.keyboard.isDown("d") then 
        vx = vx + 1 
        currentSprite = spriteRight
        currentQuads = quadsRight
    end

    local len = math.sqrt(vx*vx + vy*vy)
    if len > 0 then
        vx, vy = vx / len, vy / len
        body:setLinearVelocity(vx * speed, vy * speed)

        -- advance animation
        frameTimer = frameTimer + dt
        if frameTimer >= FRAME_TIME then
            frameTimer  = frameTimer - FRAME_TIME
            currentFrame = currentFrame % FRAMES_TOTAL + 1
        end
    else
        body:setLinearVelocity(0, 0)
        currentFrame, frameTimer = 1, 0
    end
end

-- draw player sprite at body position
function Player.draw()
    local x, y = body:getPosition()
    love.graphics.draw(currentSprite, currentQuads[currentFrame], x - FRAME_W/2, y - FRAME_H/2)
end

-- check if player collides with mapChange object
function Player.checkMapChange()
    local fixtures = body:getFixtures()
    for _, fixture in ipairs(fixtures) do
        if fixture:getUserData() == "MapChange" then
            return true
        end
    end
    return false
end

function Player.debugDraw()
    local x, y = body:getPosition()
    local shape = body:getFixtures()[1]:getShape()
    love.graphics.setColor(1, 0, 0, 0.5) -- red, semi-transparent
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(body:getAngle())
    if shape:typeOf("PolygonShape") then
        love.graphics.polygon("line", shape:getPoints())
    end
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

return Player
