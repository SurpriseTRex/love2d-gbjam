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
            visible = true
        },
        swing = {
            image = swing_img,
            x = 64,
            y = 64,
            r = 0,
            visible = false
        }
    }

    player = spriteLayer.sprites.player
    swing = spriteLayer.sprites.swing

    function love.keypressed(key, scancode, isrepeat)
      local step = 8

      if scancode == "escape" then
        love.event.push("quit")
      end
      if scancode == "w" and isrepeat == false then
        player.y = player.y - step
        swing.y = player.y - step
        swing.x = player.x
      end
      if scancode == "s" and isrepeat == false then
        player.y = player.y + step
        swing.y = player.y + step
        swing.x = player.x
      end
      if scancode == "a" and isrepeat == false then
        player.x = player.x - step
        swing.x = player.x - step
        swing.y = player.y
      end
      if scancode == "d" and isrepeat == false then
        player.x = player.x + step
        swing.x = player.x + step
        swing.y = player.y
      end
    end

    function spriteLayer:update(dt)

    end

    function spriteLayer:draw()
        for _, sprite in pairs(self.sprites) do
            local x = math.floor(sprite.x)
            local y = math.floor(sprite.y)

            if sprite.visible then
              love.graphics.draw(sprite.image, x, y, 0)
            end
        end
    end
end

function love.update(dt)
    visible_timer = 100

    if visible_timer == 0 then
      visible_timer = 100
      swing.visible = not swing.visible
    end

    visible_timer = visible_timer - 1

    map:update(dt)
end

function love.draw()
    love.graphics.scale(3)

    love.graphics.setColor(0, 0, 0, 255)

    map:setDrawRange(0, 0, windowWidth, windowHeight)

    map:draw()
end
