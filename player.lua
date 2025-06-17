local Player = {}
local Map = require("map") -- only if not already required at the top


Player.x = 64
Player.y = 64
Player.speed = 150

local spriteSheet
local quads = {}
local frameWidth = 32
local frameHeight = 32
local currentFrame = 1
local frameTimer = 0
local frameDelay = 0.1
local totalFrames = 4

function Player.load()
    spriteSheet = love.graphics.newImage("assets/sprites/player.png")
    local sheetWidth = spriteSheet:getWidth()
    Player.width = 32
    Player.height = 32


    for i = 0, (sheetWidth / frameWidth) - 1 do
        quads[#quads + 1] = love.graphics.newQuad(
            i * frameWidth, 0,
            frameWidth, frameHeight,
            spriteSheet:getDimensions()
        )
    end
end

local Map = require("map")

function Player.update(dt)
    local dx, dy = 0, 0
    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end

    local len = math.sqrt(dx * dx + dy * dy)
    if len > 0 then
        dx = dx / len
        dy = dy / len

        local moveX = dx * Player.speed * dt
        local moveY = dy * Player.speed * dt

        local nextX = Player.x + moveX
        local nextY = Player.y + moveY

        local w, h = Player.width or 28, Player.height or 28

        -- Check all 4 corners after X movement
        local function checkCollisionAt(x, y)
            return Map.isSolid(x, y)
        end

        local xOK =
            not checkCollisionAt(nextX, Player.y) and
            not checkCollisionAt(nextX + w - 1, Player.y) and
            not checkCollisionAt(nextX, Player.y + h - 1) and
            not checkCollisionAt(nextX + w - 1, Player.y + h - 1)

        if xOK then Player.x = nextX end

        -- Check all 4 corners after Y movement (note: X may have changed above)
        local yOK =
            not checkCollisionAt(Player.x, nextY) and
            not checkCollisionAt(Player.x + w - 1, nextY) and
            not checkCollisionAt(Player.x, nextY + h - 1) and
            not checkCollisionAt(Player.x + w - 1, nextY + h - 1)

        if yOK then Player.y = nextY end
    end
end


function Player.draw()
    love.graphics.draw(spriteSheet, quads[currentFrame], Player.x, Player.y)
end

return Player
