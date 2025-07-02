-- Map module: loads a Tiled .lua map via STI and draws layers in order
local sti = require("libs.sti")

local Map = {}
local layersDrawOrder = { "Floor", "Walls", "Decoration" }

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
                local data = { map = obj.properties and obj.properties.map,
                               spawn = obj.properties and obj.properties.spawn }
                fixture:setUserData({type="MapChange", data=data})
            end
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

return Map
