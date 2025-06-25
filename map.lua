-- Map module: loads a Tiled .lua map via STI and draws layers in order
local sti = require("libs.sti")

local Map = {}
local layersDrawOrder = { "Floor", "Walls", "Decoration" }

----------------------------------------------------------------
-- load(mapFile)  : mapFile = path to Tiled Lua export
----------------------------------------------------------------
function Map.load(world, mapFile)
    Map.world = world
    Map.tiled = sti(mapFile, { "box2d" })
    Map.tiled:box2d_init(world)        -- create static wall bodies
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

return Map
