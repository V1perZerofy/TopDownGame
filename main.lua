local Map    = require("map")
local Player = require("player")

local world          -- Box2D world shared by map & player
local nextMap, currentChangeData
local lightCanvas, lightShader

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

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupWorld()

    lightCanvas = love.graphics.newCanvas()

    lightShader = love.graphics.newShader([[
    extern vec2 lightPosition;
    extern number radius;

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
        float dist = distance(screen_coords, lightPosition);
        float fade = smoothstep(radius - 150.0, radius, dist);
        vec4 fog = vec4(0.0, 0.0, 0.0, fade); // dark overlay
        vec4 base = Texel(tex, texture_coords);
        return mix(base, fog, fog.a);
    }
]])



    Map.load(world, "assets/maps/map1.lua")
    Player.load(world)
end

function love.update(dt)
    world:update(dt)
    Map.update(dt)
    Player.update(dt)
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
    local mapWidth  = Map.tiled.width  * Map.tiled.tilewidth
    local mapHeight = Map.tiled.height * Map.tiled.tileheight
    local scale = math.min(w/mapWidth, h/mapHeight)

    -- draw everything to canvas
    lightCanvas:renderTo(function()
        love.graphics.clear()

        love.graphics.push()
        love.graphics.scale(scale, scale)

        Map.drawLayer("Floor")
        Map.drawLayer("Decoration")
        Player.draw()
        Map.drawLayer("Walls")
        -- Map.debugDraw()
        -- Player.debugDraw()

        love.graphics.pop()
    end)

    -- Get player light position in screen space
    local px, py = Player.getPosition()
    local screenX = px * scale
    local screenY = py * scale
    local radius = 120 -- default radius for light

    -- Get Light radius from player
    if Player.isMoving() then
        radius = 155 -- tweak for fog size
    else
        radius = 180 -- tweak for fog size
    end

    -- Apply shader and draw canvas
    lightShader:send("lightPosition", {screenX, screenY})
    lightShader:send("radius", radius) -- tweak for fog size

    love.graphics.setShader(lightShader)
    love.graphics.draw(lightCanvas)
    love.graphics.setShader()

    -- HUD / prompts on top
    if currentChangeData then
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf(
            "Press E to enter " .. currentChangeData.map,
            0, h - 30, w, "center"
        )
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
