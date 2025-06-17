local Player = require("player")
local Map = require("map")

function love.load()
    Map.load()
    Player.load()
end

function love.update(dt)
    Player.update(dt)
end

function love.draw()
    Map.draw()
    Player.draw()
end
