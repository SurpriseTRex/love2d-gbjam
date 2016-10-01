local sti = require "sti"

function love.load()
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    map = sti("assets/testmap.lua")
    map:addCustomLayer("Sprite Layer", 3)

    local spriteLayer = map.layers["Sprite Layer"]

    spriteLayer.sprites = {
        player = {
            image = love.graphics.newImage("assets/player.png"),
            x = 64,
            y = 64,
            r = 0,
        }
    }

    function spriteLayer:update(dt)
      local y_diff = 0
      local x_diff = 0

      if love.keyboard.isDown("w") then
        y_diff = -1
      end
      if love.keyboard.isDown("s") then
        y_diff = 1
      end
      if love.keyboard.isDown("a") then
        x_diff = -1
      end
      if love.keyboard.isDown("d") then
        x_diff = 1
      end

      spriteLayer.sprites.player.x = spriteLayer.sprites.player.x + x_diff
      spriteLayer.sprites.player.y = spriteLayer.sprites.player.y + y_diff
    end

    function spriteLayer:draw()
        for _, sprite in pairs(self.sprites) do
            local x = math.floor(sprite.x)
            local y = math.floor(sprite.y)
            love.graphics.draw(sprite.image, x, y, 0)
        end
    end
end

function love.update(dt)
    map:update(dt)
end

function love.draw()
    love.graphics.scale(3)
    map:setDrawRange(0, 0, windowWidth, windowHeight)

    map:draw()
end
