local sti = require "sti"

function love.load()
    y_move = 0
    windowWidth  = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    map = sti("assets/maps/map.lua")
    map:addCustomLayer("Sprite Layer", 3)

    local spriteLayer = map.layers["Sprite Layer"]

    local player_img = love.graphics.newImage("assets/sprites/player.png")
    local swing_img = love.graphics.newImage("assets/sprites/swing.png")
    player_img:setFilter("nearest", "nearest")
    swing_img:setFilter("nearest", "nearest")

    spriteLayer.sprites = {
        player = {
            image = player_img,
            x = 64,
            y = 64,
            r = 0,
        },
        swing = {
            image = swing_img,
            x = 64,
            y = 64,
            r = 0,
        }
    }

    function love.keypressed(key, scancode, isrepeat)
      local step = 8
      local player_y = spriteLayer.sprites.player.y
      local player_x = spriteLayer.sprites.player.x

      if key == "escape" then
        love.event.push("quit")
      end
      if key == "w" and isrepeat == false then
        spriteLayer.sprites.player.y = player_y - step
        spriteLayer.sprites.swing.y = spriteLayer.sprites.player.y - step
        spriteLayer.sprites.swing.x = spriteLayer.sprites.player.x
      end
      if key == "s" and isrepeat == false then
        spriteLayer.sprites.player.y = player_y + step
        spriteLayer.sprites.swing.y = spriteLayer.sprites.player.y + step
        spriteLayer.sprites.swing.x = spriteLayer.sprites.player.x
      end
      if key == "a" and isrepeat == false then
        spriteLayer.sprites.player.x = player_x - step
        spriteLayer.sprites.swing.x = spriteLayer.sprites.player.x - step
        spriteLayer.sprites.swing.y = spriteLayer.sprites.player.y
      end
      if key == "d" and isrepeat == false then
        spriteLayer.sprites.player.x = player_x + step
        spriteLayer.sprites.swing.x = spriteLayer.sprites.player.x + step
        spriteLayer.sprites.swing.y = spriteLayer.sprites.player.y
      end
    end

    function spriteLayer:update(dt)

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
