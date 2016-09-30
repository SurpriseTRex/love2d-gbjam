debug = true

player = {x = 23, y = 30, speed = 2}

function love.load(args)
  position = {x = 0, y = 0}
end

function love.update(dt)
  if love.keyboard.isDown("w") then

  end
end

function love.draw(dt)
  love.graphics.print("Hello World", player.x, player.y)
end
