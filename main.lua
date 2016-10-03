debug = true

cardImg = nil
cursorImg = nil
hpImg = nil

maxhp = 4

enemySelectedCard = 1
enemyMoveTimer = 2
enemyCardsY = 5
enemyHP = maxhp
enemyThinkingPips = 0
thinkTick = 1
thinkCounter = 0

selectedCard = 1
playerTurn = true
playerCardsY = 100
playerHP = maxhp


function playerExecuteCard(card)
  if card.type == "damage" then
    enemyHP = enemyHP - 1
  elseif card.type == "healing" then
    playerHP = playerHP + 1
  end
end

function enemyExecuteCard(card)
  if card.type == "damage" then
    playerHP = playerHP - 1
  elseif card.type == "healing" then
    enemyHP = enemyHP + 1
  end
end

function resetEnemyMoveTimer()
  enemyMoveTimer = 2
end

function decrementEnemyMoveTimer(dt)
  enemyMoveTimer = enemyMoveTimer - dt
end

function love.load(arg)
  cardImg = love.graphics.newImage('assets/card.png')
  cardImg:setFilter("nearest", "nearest")

  cursorImg = love.graphics.newImage("assets/cursor.png")
  cursorImg:setFilter("nearest", "nearest")

  hpImg = love.graphics.newImage("assets/heart.png")
  hpImg:setFilter("nearest", "nearest")

  playerCards = {
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "healing"},
  }

  enemyCards = {
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "damage"},
    {image = cardImg, type = "healing"},
    {image = cardImg, type = "healing"},
  }
end


function love.update(dt)
  if not playerTurn then
    if enemyMoveTimer <= 0 then
      enemySelectedCard = math.random(#enemyCards)

      enemyExecuteCard(enemyCards[enemySelectedCard])
      table.remove(enemyCards, enemySelectedCard)

      playerTurn = true
      enemyThinkingPips = 0
      resetEnemyMoveTimer()

    else
      decrementEnemyMoveTimer(dt)
    end
  end
end


function love.draw(dt)
  if not playerTurn then
    love.graphics.print("Thinking...", 100, enemyCardsY - 5)
  end

  love.graphics.setBackgroundColor(158, 186, 15)
  love.graphics.scale(3)

  for i = 1, playerHP do
    love.graphics.draw(hpImg, i * 10, playerCardsY - 15)
  end
  for i = 1, enemyHP do
    love.graphics.draw(hpImg, i * 10, enemyCardsY + 45)
  end

  for i = 1, #playerCards do
    love.graphics.draw(playerCards[i].image, i * 20, playerCardsY)
  end
  for i = 1, #enemyCards do
    love.graphics.draw(enemyCards[i].image, i * 20, enemyCardsY)
  end

  love.graphics.draw(cursorImg, (selectedCard * 20) + 10, playerCardsY - 5)
end


function love.keypressed(key, scancode, isrepeat)
  if scancode == "escape" then
    love.event.push("quit")
  end

  if (scancode == "a" or scancode == "w") and selectedCard > 1 then
    selectedCard = selectedCard - 1
  end
  if (scancode == "s" or scancode == "d") and selectedCard < #playerCards then
    selectedCard = selectedCard + 1
  end

  if scancode == "k" and playerTurn then
    playerExecuteCard(playerCards[selectedCard])
    table.remove(playerCards, selectedCard)
    playerTurn = false
  end
end
