local Map    = require("map")
local Player = require("player")

local world  -- Box2D world shared by map & player
local nextMap = nil  -- queued map change data
local currentChangeData = nil  -- active MapChange data when overlapping
 
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(32)

    world = love.physics.newWorld(0, 0)

    -- set up begin/end contact to detect MapChange overlap
    world:setCallbacks(
        function(a, b, coll)
            local ua, ub = a:getUserData(), b:getUserData()
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                currentChangeData = ua.data
                Player.triggerMapChange()
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                currentChangeData = ub.data
                Player.triggerMapChange()
            end
        end,
        function(a, b, coll)
            local ua, ub = a:getUserData(), b:getUserData()
            if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                currentChangeData = nil
                Player.clearMapChange()
            elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                currentChangeData = nil
                Player.clearMapChange()
            end
        end
    )

    Map.load(world, "assets/maps/map1.lua")  -- initial map
    Player.load(world)
end

function love.update(dt)
    -- physics step
    world:update(dt)
    Map.update(dt)
    Player.update(dt)
    -- apply queued map change by resetting the world
    if nextMap then
        -- recreate physics world to clear old bodies
        world = love.physics.newWorld(0, 0)
        love.physics.setMeter(32)
        -- re-establish collision callback
        world:setCallbacks(
            function(a, b, coll)
                local ua, ub = a:getUserData(), b:getUserData()
                if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                    currentChangeData = ua.data
                    Player.triggerMapChange()
                elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                    currentChangeData = ub.data
                    Player.triggerMapChange()
                end
            end,
            function(a, b, coll)
                local ua, ub = a:getUserData(), b:getUserData()
                if type(ua) == "table" and ua.type == "MapChange" and ub == "Player" then
                    currentChangeData = nil
                    Player.clearMapChange()
                elseif type(ub) == "table" and ub.type == "MapChange" and ua == "Player" then
                    currentChangeData = nil
                    Player.clearMapChange()
                end
            end
        )
        -- reload map and recreate player bodies
        Map.load(world, nextMap.path)
        Player.load(world)
        -- position player if spawn provided
        if nextMap.spawn then
            local x, y = nextMap.spawn:match("(%d+),%s*(%d+)")
            if x and y then Player.setPosition(tonumber(x), tonumber(y)) end
        end
        nextMap = nil
        Player.clearMapChange()  -- clear the trigger after loading the new map
    end
end

function love.draw()
    -- scale to fit window
    local w, h = love.graphics.getDimensions()
    local mapWidth = Map.tiled.width * Map.tiled.tilewidth
    local mapHeight = Map.tiled.height * Map.tiled.tileheight
    local scale = math.min(w / mapWidth, h / mapHeight)
    love.graphics.scale(scale, scale)
    -- Draw Floor layer only
    Map.drawLayer("Floor")
    Map.drawLayer("Decoration")

    -- Draw player
    Player.draw()

    -- Draw Walls and Decoration layers
    Map.drawLayer("Walls")


    --display player position
    local px, py = Player.getPosition()
    love.graphics.print(string.format("Player Position: (%.2f, %.2f)", px, py), 10, 10)
    --Map.debugDraw()  -- draw Box2D bodies for debugging
    --Player.debugDraw()  -- draw player body for debugging
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "e" and currentChangeData then
        -- schedule map change on key press
        nextMap = { path = "assets/maps/" .. currentChangeData.map .. ".lua", spawn = currentChangeData.spawn }
    end
end
