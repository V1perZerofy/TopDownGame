-- Map module: loads a Tiled .lua map via STI and draws layers in order
local sti = require("libs.sti")

local Map = {}
local layersDrawOrder = { "Floor", "Walls", "Decoration" }
local torches = {}
local defaultRadius = 100

----------------------------------------------------------------
-- load(mapFile)  : mapFile = path to Tiled Lua export
----------------------------------------------------------------
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
                local keyProp = prop.key
                local keyBool = (keyProp == true or keyProp == "true")
                local data = {
                    map   = prop.map,
                    spawn = prop.spawn,
                    key   = keyBool
                }
                fixture:setUserData({type="MapChange", data=data})
            end
        end
    end

    -- Clear existing torches
    torches = {}

    -- Load torches from Tiled "Torches" object layer
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

----------------------------------------------------------------
function Map.update(dt)
    if Map.tiled then Map.tiled:update(dt) end
end

----------------------------------------------------------------
function Map.draw()
    if not Map.tiled then return end
    for _, name in ipairs(layersDrawOrder) do
        local layer = Map.tiled.layers[name]
        if layer then
            Map.tiled:drawLayer(layer)
        end
    end
end

-- Draw a single named layer
function Map.drawLayer(name)
    if not Map.tiled then return end
    local layer = Map.tiled.layers[name]
    if layer then
        Map.tiled:drawLayer(layer)
    end
end

function Map.debugDraw()
    if not Map.tiled or not Map.world then return end
    love.graphics.setColor(0, 1, 0, 0.5) -- green, semi-transparent
    for _, body in pairs(Map.world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local bx, by = body:getPosition()
            love.graphics.push()
            love.graphics.translate(bx, by)
            love.graphics.rotate(body:getAngle())
            if shape:typeOf("PolygonShape") then
                love.graphics.polygon("line", shape:getPoints())
            elseif shape:typeOf("CircleShape") then
                love.graphics.circle("line", 0, 0, shape:getRadius())
            end
            love.graphics.pop()
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
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
        local r, g, b = name:match("(%d*%.?%d+),(%d*%.?%d+),(%d*%.?%d+)")
        if r and g and b then return {tonumber(r), tonumber(g), tonumber(b)} end
        return colorMap[name] or {1.0, 1.0, 1.0}
    end
    return {1.0, 1.0, 1.0}
end

function Map.addTorch(x, y, radius, color)
    table.insert(torches, {
        x = x,
        y = y,
        radius = radius or 100,
        color = color or "white"
    })
end

function Map.getTorches()
    return torches
end

return Map
