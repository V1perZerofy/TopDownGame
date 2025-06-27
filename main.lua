local Map    = require("map")
local Player = require("player")

local world  -- Box2D world shared by map & player

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.physics.setMeter(32)

    world = love.physics.newWorld(0, 0)

    Map.load(world, "assets/maps/dungeon.lua")  -- Tiled export
    Player.load(world)                        -- dynamic body + sprite
end

function love.update(dt)
    world:update(dt)  -- physics step
    Map.update(dt)    -- STI internal timers
    Player.update(dt)
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

    Map.debugDraw()  -- draw Box2D bodies for debugging
    Player.debugDraw()  -- draw player body for debugging
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
end
