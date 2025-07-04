local Map    = require("map")
local Player = require("player")

local world          -- Box2D world shared by map & player
local nextMap, currentChangeData

local function setupWorld()
    world = love.physics.newWorld(0, 0)
    love.physics.setMeter(32)
    world:setCallbacks(
        function(a, b)
            local ua, ub = a:getUserData(), b:getUserData()
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                currentChangeData = ua.data; Player.triggerMapChange()
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                currentChangeData = ub.data; Player.triggerMapChange()
            end
        end,
        function(a, b)
            local ua, ub = a:getUserData(), b:getUserData()
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                currentChangeData = nil; Player.clearMapChange()
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                currentChangeData = nil; Player.clearMapChange()
            end
        end
    )
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    setupWorld()

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

    love.graphics.push()
    love.graphics.scale(scale, scale)

    -- Draw map layers & player
    Map.drawLayer("Floor")
    Map.drawLayer("Decoration")
    Player.draw()
    Map.drawLayer("Walls")
    --Map.debugDraw()
    --Player.debugDraw()

    love.graphics.pop()

    -- if we're on a MapChange trigger, show prompt in screen‐space
    if currentChangeData then
        love.graphics.setColor(1,1,1,1)
        love.graphics.printf(
            "Press E to enter " .. currentChangeData.map,
            0, h - 30,      -- x=0, y=30px from bottom
            w,              -- full width
            "center"
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
