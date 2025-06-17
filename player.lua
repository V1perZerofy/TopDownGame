local Player = {}

Player.x = 64
Player.y = 64
Player.speed = 100

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

    for i = 0, (sheetWidth / frameWidth) - 1 do
        quads[#quads + 1] = love.graphics.newQuad(
            i * frameWidth, 0,
            frameWidth, frameHeight,
            spriteSheet:getDimensions()
        )
    end
end

function Player.update(dt)
    local moving = false

    if love.keyboard.isDown("w") then Player.y = Player.y - Player.speed * dt; moving = true end
    if love.keyboard.isDown("s") then Player.y = Player.y + Player.speed * dt; moving = true end
    if love.keyboard.isDown("a") then Player.x = Player.x - Player.speed * dt; moving = true end
    if love.keyboard.isDown("d") then Player.x = Player.x + Player.speed * dt; moving = true end

    if moving then
        frameTimer = frameTimer + dt
        if frameTimer >= frameDelay then
            frameTimer = 0
            currentFrame = currentFrame % totalFrames + 1
        end
    else
        currentFrame = 1
    end
end

function Player.draw()
    love.graphics.draw(spriteSheet, quads[currentFrame], Player.x, Player.y)
end

return Player
