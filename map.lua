local Map = {}

local tileSize = 32
local tileset
local tileQuads = {}
local tileData = {
    { 1, 1, 1, 1, 1 },
    { 1, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 1 },
    { 1, 1, 1, 1, 1 }
}

function Map.load()
    tileset = love.graphics.newImage("assets/tiles/tiles.png")
    local cols = tileset:getWidth() / tileSize
    local rows = tileset:getHeight() / tileSize

    for y = 0, rows - 1 do
        for x = 0, cols - 1 do
            local id = y * cols + x + 1
            tileQuads[id] = love.graphics.newQuad(
                x * tileSize, y * tileSize, tileSize, tileSize,
                tileset:getDimensions()
            )
        end
    end
end

function Map.draw()
    for y = 1, #tileData do
        for x = 1, #tileData[y] do
            local id = tileData[y][x]
            if tileQuads[id] then
                love.graphics.draw(tileset, tileQuads[id], (x - 1) * tileSize, (y - 1) * tileSize)
            end
        end
    end
end

return Map
