-- map.lua for Moonshine torches
local sti = require("libs.sti")
local Map = {}

local torches = {}
local defaultRadius = 100

function Map.load(world, mapFile)
    Map.world = world
    Map.tiled = sti(mapFile, {"box2d"})
    Map.tiled:box2d_init(world)

    for _, layer in ipairs(Map.tiled.layers) do
        if layer.type == "objectgroup" and layer.name == "MapChange" then
            for _, obj in ipairs(layer.objects) do
                local x = obj.x + obj.width/2
                local y = obj.y + obj.height/2
                local body = love.physics.newBody(world, x, y, "static")
                local shape = love.physics.newRectangleShape(obj.width, obj.height)
                local fixture = love.physics.newFixture(body, shape)
                fixture:setSensor(true)
                local prop = obj.properties or {}
                local data = {
                    map   = prop.map,
                    spawn = prop.spawn,
                    key   = (prop.key == true or prop.key == "true")
                }
                fixture:setUserData({type="MapChange", data=data})
            end
        end
    end

    torches = {}
    local torchLayer = Map.tiled.layers["torches"]
    if torchLayer and torchLayer.objects then
        for _, obj in ipairs(torchLayer.objects) do
            local x = obj.x + (obj.width or 0) / 2
            local y = obj.y + (obj.height or 0) / 2
            local radius = tonumber(obj.properties and obj.properties.radius) or defaultRadius
            local colorStr = obj.properties and obj.properties.color or "orange"
            Map.addTorch(x, y, radius, colorStr)
        end
    end
end

function Map.drawLayer(name)
    if Map.tiled and Map.tiled.layers[name] then
        Map.tiled:drawLayer(Map.tiled.layers[name])
    end
end

function Map.update(dt)
    if Map.tiled then Map.tiled:update(dt) end
end

function Map.addTorch(x, y, radius, color)
    table.insert(torches, {
        x = x,
        y = y,
        radius = radius or defaultRadius,
        color = color or "orange"
    })
end

local colorMap = {
    white  = {1.0, 1.0, 1.0},
    orange = {1.0, 0.6, 0.2},
    blue   = {0.4, 0.6, 1.0},
    green  = {0.5, 1.0, 0.5},
    red    = {1.0, 0.2, 0.2}
}

function Map.getTorchColor(name)
    if type(name) == "string" then
        local hex = name:match("#?([%da-fA-F]+)")
        if hex and (#hex == 6 or #hex == 8) then
            local r = tonumber(hex:sub(1,2), 16) / 255
            local g = tonumber(hex:sub(3,4), 16) / 255
            local b = tonumber(hex:sub(5,6), 16) / 255
            return {r, g, b}
        end
        return colorMap[name:lower()] or {1.0, 1.0, 1.0}
    end
    return {1.0, 1.0, 1.0}
end

function Map.getTorches()
    return torches
end

return Map
