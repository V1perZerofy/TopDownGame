function love.conf(t)
    t.window.title = "Whispers of the Hollow"
    t.window.width = 1200
    -- keep aspect ratio
    t.window.height = math.floor(t.window.width * 430 / 800)
    -- frame rate
    t.window.vsync = 1
end