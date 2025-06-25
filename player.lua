local Player = {}

-- animation config
local FRAME_W, FRAME_H = 32, 32
local FRAMES_TOTAL     = 4
local FRAME_TIME       = 0.12

-- runtime
local sprite, quads = {}, {}
local currentFrame, frameTimer = 1, 0

-- physics handles
local body


function Player.load(world)
    -- sprite sheet → quads
    -- sprite sheet → quads  (horizontal layout: 4 × 32×32 = 128×32)
    sprite = love.graphics.newImage("assets/sprites/player_left.png") -- 128×32
    for i = 0, FRAMES_TOTAL - 1 do
        quads[i + 1] = love.graphics.newQuad(
            i * FRAME_W,         -- x-offset moves horizontally
            0,                   -- y-offset stays 0
            FRAME_W, FRAME_H,    -- frame size
            sprite:getDimensions()
        )
    end

    local startX, startY = 100, 100    -- later: read from Tiled object
    body = love.physics.newBody(world, startX, startY, "dynamic")
    local shape   = love.physics.newRectangleShape(FRAME_W - 4, FRAME_H - 4)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData("Player")
end

-- update player position based on keyboard input
-- and animate sprite frames
function Player.update(dt)
    local speed = 100
    local vx, vy = 0, 0
    if love.keyboard.isDown("w") then vy = vy - 1 end
    if love.keyboard.isDown("s") then vy = vy + 1 end
    if love.keyboard.isDown("a") then vx = vx - 1 end
    if love.keyboard.isDown("d") then vx = vx + 1 end


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
    love.graphics.draw(sprite, quads[currentFrame], x - FRAME_W/2, y - FRAME_H/2)
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


return Player
