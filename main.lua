debug = true

font = nil

card2Img = nil
healCardImg = nil
cursorImg = nil
hpImg = nil
emptyHPImg = nil

maxhp = 5

enemySelectedCard = 1
enemyMoveTimer = 2
enemyCardsY = 10
enemyHP = 4
enemyThinkingPips = 0
thinkTick = 1
thinkCounter = 0
enemyShieldCounter = 0

selectedCard = 1
playerTurn = true
playerCardsY = 110
playerHP = 4
playerShieldCounter = 0

infoWindowOpen = false


function playerExecuteCard(card)
  if card.type == "DAMAGE" then
    if enemyShieldCounter <= 0 then
      enemyHP = enemyHP - card.value
    end
  elseif card.type == "HEALING" then
    if playerHP < maxhp then
      playerHP = playerHP + card.value
    end
  elseif card.type == "SHIELD" then
    playerShieldCounter = card.value
  end
end

function enemyExecuteCard(card)
  if card.type == "DAMAGE" then
    if playerShieldCounter <= 0 then
      playerHP = playerHP - card.value
    end
  elseif card.type == "HEALING" then
    if enemyHP < maxhp then
      enemyHP = enemyHP + card.value
    end
  elseif card.type == "SHIELD" then
    enemyShieldCounter = card.value
  end
end

function resetEnemyMoveTimer()
  enemyMoveTimer = 2
end

function decrementEnemyMoveTimer(dt)
  enemyMoveTimer = enemyMoveTimer - dt
end

function love.load(arg)
  healCardImg = love.graphics.newImage('assets/healcard.png')
  healCardImg:setFilter("nearest", "nearest")

  shieldCardImg = love.graphics.newImage('assets/shieldcard.png')
  shieldCardImg:setFilter("nearest", "nearest")

  damCardImg = love.graphics.newImage('assets/damcard.png')
  damCardImg:setFilter("nearest", "nearest")

  cursorImg = love.graphics.newImage("assets/cursor.png")
  cursorImg:setFilter("nearest", "nearest")

  shieldImg = love.graphics.newImage("assets/shield.png")
  shieldImg:setFilter("nearest", "nearest")

  hpImg = love.graphics.newImage("assets/heart.png")
  hpImg:setFilter("nearest", "nearest")

  emptyHPImg = love.graphics.newImage("assets/emptyheart.png")
  emptyHPImg:setFilter("nearest", "nearest")

  thinkingImg = love.graphics.newImage("assets/thinking.png")
  thinkingImg:setFilter("nearest", "nearest")

  windowImg = love.graphics.newImage("assets/infowindow2.png")
  windowImg:setFilter("nearest", "nearest")

  font = love.graphics.newImageFont("assets/font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
  font:setFilter("nearest", "nearest")

  math.randomseed(os.time())

  damDesc = " DMG TO ENEMY."
  healDesc = " HP RESTORE."
  shieldDesc = " TURN DMG BLOCK."

  possibleCards = {
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 1},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 1},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 1},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 1},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 1},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 2},
    {image = damCardImg, type = "DAMAGE", desc = damDesc, value = 3},
    {image = shieldCardImg, type = "SHIELD", desc = shieldDesc, value = 2},
    {image = healCardImg, type = "HEALING", desc = healDesc, value = 3},
    {image = healCardImg, type = "HEALING", desc = healDesc, value = 2}
  }

  playerCards = {}
  enemyCards = {}

  addCardsToHand(playerCards, 5)
  addCardsToHand(enemyCards, 5)
end

function addCardsToHand(hand, num)
  for i = 1, num do
    table.insert(hand, possibleCards[math.random(#possibleCards)])
  end
end

function love.update(dt)
  if not playerTurn then
    if enemyMoveTimer <= 0 then
      enemySelectedCard = math.random(#enemyCards)

      enemyExecuteCard(enemyCards[enemySelectedCard])
      table.remove(enemyCards, enemySelectedCard)

      playerShieldCounter = playerShieldCounter - 1
      addCardsToHand(enemyCards, 1)
      playerTurn = true
      enemyThinkingPips = 0
      resetEnemyMoveTimer()

    else
      decrementEnemyMoveTimer(dt)
    end
  end
end

function drawHP()
  local enemyHpY = enemyCardsY + 45
  local playerHpY = playerCardsY - 40

  local img
  local emptyImg

  if playerShieldCounter > 0 then
    img = shieldImg
    emptyImg = shieldImg
  else
    img = hpImg
    emptyImg = emptyHPImg
  end
  for i = 1, maxhp do
    if i <= playerHP then
      love.graphics.draw(img, i * 10, playerHpY)
    else
      love.graphics.draw(emptyImg, i * 10, playerHpY)
    end
  end

  if enemyShieldCounter > 0 then
    img = shieldImg
    emptyImg = shieldImg
  else
    img = hpImg
    emptyImg = emptyHPImg
  end
  for i = 1, maxhp do
    if i <= enemyHP then
      love.graphics.draw(img, i * 10, enemyHpY)
    else
      love.graphics.draw(emptyImg, i * 10, enemyHpY)
    end
  end
end

function drawCards()
  for i = 1, #playerCards do
    if i == selectedCard then
      offset = (i % 2 * 2) + 8
    else
      offset = (i % 2 * 3)
    end
    love.graphics.draw(playerCards[i].image, 8 + i * 20, playerCardsY - offset)
    love.graphics.print(playerCards[i].value, 8 + i * 20, playerCardsY - offset)
  end
  for i = 1, #enemyCards do
    love.graphics.draw(enemyCards[i].image, 8 + i * 20, enemyCardsY - (i % 2 * 3))
  end
end

function drawCursor()
  love.graphics.draw(cursorImg, (selectedCard * 20) + 16, playerCardsY - 20)
end

function drawInfoWindow(card)
  love.graphics.draw(windowImg, 20, 20)
  love.graphics.draw(card.image, 32, 50)

  love.graphics.printf(card.type, 25, 24, 110, "center")
  love.graphics.printf(card.value..card.desc, 64, 48, 72)
end

function love.draw(dt)
  love.graphics.setBackgroundColor(158, 186, 15)
  love.graphics.setFont(font)
  love.graphics.scale(3)

  drawHP()
  drawCards()
  drawCursor()

  if not playerTurn then
    love.graphics.draw(thinkingImg, 80, enemyCardsY + 45)
  end

  if infoWindowOpen then
    drawInfoWindow(playerCards[selectedCard])
  end
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

  if scancode == "j" then
    infoWindowOpen = not infoWindowOpen
  end

  if scancode == "k" and playerTurn then
    playerExecuteCard(playerCards[selectedCard])
    table.remove(playerCards, selectedCard)
    selectedCard = 1
    addCardsToHand(playerCards, 1)
    enemyShieldCounter = enemyShieldCounter - 1
    playerTurn = false
  end
end
