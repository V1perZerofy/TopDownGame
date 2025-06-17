function love.load()
    player = {
        x = 100,
        y = 100,
        w = 32,
        h = 32,
        speed = 200
    }
end

function love.update(dt)
    if love.keyboard.isDown("w") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("s") then player.y = player.y + player.speed * dt end
    if love.keyboard.isDown("a") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("d") then player.x = player.x + player.speed * dt end
end

function love.draw()
    love.graphics.setColor(0, 1, 0) -- Green
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end
