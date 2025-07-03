local Map    = require("map")
local Player = require("player")

local world          -- Box2D world shared by map & player
local nextMap, currentChangeData
local lightCanvas, lightShader
local lightMaskCanvas

local currentLightRadius = 180
local targetLightRadius = 180
local lightLerpSpeed = 5 -- higher = faster fade

local function setupWorld()
    world = love.physics.newWorld(0, 0)
    love.physics.setMeter(32)
    world:setCallbacks(
        -- beginContact: decide auto or require key
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
        -- endContact: clear require‐key prompt
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

local torchShader = love.graphics.newShader([[
    extern vec2 torchPos;
    extern number torchRadius;
    extern vec3 torchColor;

    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
        float d = distance(screenCoord, torchPos);
        float glow = 1.0 - smoothstep(torchRadius - 150.0, torchRadius, d);
        glow = clamp(glow, 0.0, 1.0); // ✨ safe
        return vec4(torchColor * glow, glow);
    }
]])


function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupWorld()

    lightCanvas = love.graphics.newCanvas()
    lightMaskCanvas = love.graphics.newCanvas()

    lightShader = love.graphics.newShader([[
    extern Image lightMask;

    vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
        vec4 base = Texel(tex, texCoord);
        float light = Texel(lightMask, texCoord).r; // Use red channel (all channels are equal)
        float shadow = 1.0 - light;
        return vec4(mix(base.rgb, vec3(0.0), shadow), 1.0); // black fog
    }
]])



    Map.load(world, "assets/maps/map1.lua")
    Player.load(world)
end

function love.update(dt)
    world:update(dt)
    Map.update(dt)
    Player.update(dt)

    -- Smooth radius interpolation
    currentLightRadius = currentLightRadius + (targetLightRadius - currentLightRadius) * math.min(lightLerpSpeed * dt, 1)

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

---- filepath: c:\Users\niels\Documents\GitKraken\TopDownGame\main.lua
function love.draw()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / (Map.tiled.width * Map.tiled.tilewidth), h / (Map.tiled.height * Map.tiled.tileheight))
    local px, py = Player.getPosition()
    local screenX, screenY = px * scale, py * scale

    --------------------------------------------------------
    -- 1. Draw world to main canvas
    --------------------------------------------------------
    lightCanvas:renderTo(function()
        love.graphics.clear()
        love.graphics.push()
        love.graphics.scale(scale, scale)
        Map.drawLayer("Floor")
        Map.drawLayer("Decoration")
        Player.draw()
        Map.drawLayer("Walls")
        love.graphics.pop()
    end)

    lightMaskCanvas:renderTo(function()
        love.graphics.clear(0, 0, 0, 1) -- full black

        -- Player glow (non-flickering)
        torchShader:send("torchPos", {screenX, screenY})
        torchShader:send("torchRadius", currentLightRadius)
        love.graphics.setShader(torchShader)
        love.graphics.setBlendMode("add")
        love.graphics.rectangle("fill", 0, 0, w, h)

        -- Torches (flickering)
        for _, torch in ipairs(Map.getTorches()) do
            local time = love.timer.getTime()
            local flicker = math.sin(time * 3 + torch.x * 0.1) * 6
            local color = Map.getTorchColor(torch.color)
            torchShader:send("torchPos", { torch.x * scale, torch.y * scale })
            torchShader:send("torchRadius", torch.radius + flicker)
            --torchShader:send("torchColor", color)
            torchShader:send("torchColor", {1.0, 0.0, 0.0}) -- RED

            love.graphics.setShader(torchShader)
            love.graphics.rectangle("fill", 0, 0, w, h)
        end


        love.graphics.setShader(lightShader)
        love.graphics.setBlendMode("alpha")
        love.graphics.setShader()
    end)


    --------------------------------------------------------
    -- 3. Apply fog shader using light mask
    --------------------------------------------------------
    lightShader:send("lightMask", lightMaskCanvas)
    love.graphics.setShader(lightShader)
    love.graphics.draw(lightCanvas)
    love.graphics.setShader()

    --------------------------------------------------------
    -- 4. UI
    --------------------------------------------------------
    if currentChangeData then
        love.graphics.setColor(1,1,1,1)
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
