local Map = {}

local tileSize = 32
local tileset
local tileQuads = {}
local tileData = {
    {13, 14, 14, 14, 14, 14, 14, 14, 14, 13}, -- Top row (corners and top edge)
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14}, -- Second row (left/right edges)
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {14, 17, 17, 17, 17, 17, 17, 17, 17, 14},
    {13, 14, 14, 14, 14, 14, 14, 14, 14, 13}  -- Bottom row (corners and bottom edge)
}
local solidTiles = {
    [0] = false,
    [17] = false, -- Empty tile
    [13] = true,  -- Solid tile
    [14] = true   -- Solid tile
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

function Map.isSolid(worldX, worldY)
    local col = math.floor(worldX / tileSize) + 1
    local row = math.floor(worldY / tileSize) + 1
    local tile = tileData[row] and tileData[row][col]
    return solidTiles[tile or 0] or false
end

return Map
