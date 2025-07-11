-- main.lua
local Map    = require("map")
local Player = require("player")

-- Shader
local radialShader = love.graphics.newShader("shaders/radial_light.glsl")
local blurShader   = love.graphics.newShader("shaders/gaussian_blur.glsl")

local world
local nextMap, currentChangeData

local currentLightRadius = 180
local targetLightRadius = 180
local lightLerpSpeed = 5

-- Canvas for lighting mask + blur intermediate
local lightMask   = love.graphics.newCanvas()
local blurTemp    = love.graphics.newCanvas()
local blurredMask = love.graphics.newCanvas()

----------------------------------------------------------------
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

----------------------------------------------------------------
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupWorld()
    Map.load(world, "assets/maps/map3.lua")
    Player.load(world)
end

----------------------------------------------------------------
function love.update(dt)
    world:update(dt)
    Map.update(dt)
    Player.update(dt)

    -- weicher Licht-Radius-Übergang
    currentLightRadius = currentLightRadius + (targetLightRadius - currentLightRadius) * math.min(lightLerpSpeed * dt, 1)
    targetLightRadius = Player.isMoving() and 180 or 240

    -- Mapwechsel durchführen
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

----------------------------------------------------------------
function love.draw()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(
        w / (Map.tiled.width  * Map.tiled.tilewidth),
        h / (Map.tiled.height * Map.tiled.tileheight)
    )
    local px, py = Player.getPosition()
    local screenX, screenY = px * scale, py * scale

    -- 1) Lichtmaske rendern mit radialShader
    lightMask:renderTo(function()
        love.graphics.clear(0, 0, 0, 1)
        love.graphics.setShader(radialShader)
        -- Spieler-Licht
        radialShader:send("lightPos", {screenX, screenY})
        radialShader:send("radius", currentLightRadius)
        radialShader:send("lightColor", {1.0, 0.6, 0.2, 1})
        love.graphics.rectangle("fill", 0, 0, w, h)
        -- Fackeln
        for _, torch in ipairs(Map.getTorches()) do
            local tx, ty = torch.x * scale, torch.y * scale
            radialShader:send("lightPos", {tx, ty})
            radialShader:send("radius", torch.radius)
            radialShader:send("lightColor", Map.getTorchColor(torch.color) or {1.0, 0.6, 0.2})  -- Standard orange
            love.graphics.rectangle("fill", 0, 0, w, h)
        end
        love.graphics.setShader()
    end)

    -- 2) Separable Gaussian-Blur: horizontal
    blurShader:send("blurRadius", 40)  -- Größe des Blurs
    blurTemp:renderTo(function()
        love.graphics.setShader(blurShader)
        blurShader:send("direction", {1, 0})
        love.graphics.draw(lightMask)
        love.graphics.setShader()
    end)
    -- vertical
    blurShader:send("blurRadius", 40)  -- Größe des Blurs
    blurredMask:renderTo(function()
        love.graphics.setShader(blurShader)
        blurShader:send("direction", {0, 1})
        love.graphics.draw(blurTemp)
        love.graphics.setShader()
    end)

    -- 3) Szene normal zeichnen
    love.graphics.push()
    love.graphics.scale(scale)
    Map.drawLayer("Floor")
    Map.drawLayer("Decoration")
    Player.draw()
    Map.drawLayer("Walls")
    --Player.debugDraw()
    --Map.debugDraw()
    love.graphics.pop()

    -- 4) Lichtmaske multiplizieren
    love.graphics.setBlendMode("multiply", "premultiplied")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(blurredMask)
    love.graphics.setBlendMode("alpha")

    -- HUD-Prompt für Map-Change
    if currentChangeData then
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf("Press E to enter " .. currentChangeData.map, 0, h - 30, w, "center")
    end
end

----------------------------------------------------------------
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "e" and currentChangeData then
        nextMap = { path = "assets/maps/" .. currentChangeData.map .. ".lua", spawn = currentChangeData.spawn }
        currentChangeData = nil
    end
end
