-- main.lua with Moonshine integrated torch lighting
local Map    = require("map")
local Player = require("player")
local moonshine = require("libs.moonshine")

local world
local nextMap, currentChangeData

local currentLightRadius = 180
local targetLightRadius = 180
local lightLerpSpeed = 5

local glowEffect = moonshine(moonshine.effects.glow)
glowEffect.glow.min_luma = 0.2
glowEffect.glow.strength = 5
--glowEffect.glow.strength = 6


local function setupWorld()
    world = love.physics.newWorld(0, 0)
    love.physics.setMeter(32)
    world:setCallbacks(
        function(a, b)
            local ua, ub = a:getUserData(), b:getUserData()
            local data
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                data = ua.data
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                data = ub.data
            end
            if data then
                if data.key then
                    currentChangeData = data
                else
                    nextMap = { path = "assets/maps/" .. data.map .. ".lua", spawn = data.spawn }
                end
            end
        end,
        function(a, b)
            local ua, ub = a:getUserData(), b:getUserData()
            local data
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                data = ua.data
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                data = ub.data
            end
            if data and data.key then
                currentChangeData = nil
            end
        end
    )
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupWorld()

    Map.load(world, "assets/maps/map3.lua")
    Player.load(world)
end

function love.update(dt)
    world:update(dt)
    Map.update(dt)
    Player.update(dt)

    currentLightRadius = currentLightRadius + (targetLightRadius - currentLightRadius) * math.min(lightLerpSpeed * dt, 1)

    if Player.isMoving() then
        targetLightRadius = 140
    else
        targetLightRadius = 180
    end

    if nextMap then
        setupWorld()
        Map.load(world, nextMap.path)
        Player.load(world)
        if nextMap.spawn then
            local x, y = nextMap.spawn:match("(%d+),%s*(%d+)")
            if x and y then Player.setPosition(tonumber(x), tonumber(y)) end
        end
        nextMap = nil
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / (Map.tiled.width * Map.tiled.tilewidth), h / (Map.tiled.height * Map.tiled.tileheight))
    local px, py = Player.getPosition()
    local screenX, screenY = px * scale, py * scale

    glowEffect(function()
        love.graphics.push()
        love.graphics.scale(scale)
        Map.drawLayer("Floor")
        Map.drawLayer("Decoration")
        Player.draw()
        Map.drawLayer("Walls")
        love.graphics.pop()

        -- Torch glow effect
        for _, torch in ipairs(Map.getTorches()) do
            local time = love.timer.getTime()
            local flicker = math.sin(time * 3 + torch.x * 0.1) * 6
            local radius = torch.radius + flicker
            local color = Map.getTorchColor(torch.color)
            love.graphics.setColor(color[1], color[2], color[3], 1.0)
            love.graphics.circle("fill", torch.x * scale, torch.y * scale, radius)
        end

        -- Player light
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle("fill", screenX, screenY, currentLightRadius)
    end)

    love.graphics.setColor(1, 1, 1, 1)
    if currentChangeData then
        love.graphics.printf("Press E to enter " .. currentChangeData.map, 0, h - 30, w, "center")
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "e" then
        if currentChangeData then
            nextMap = { path = "assets/maps/" .. currentChangeData.map .. ".lua", spawn = currentChangeData.spawn }
            currentChangeData = nil
        end
    end
end
