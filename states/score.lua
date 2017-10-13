local score = {}
local Button = require "entities.button"
local levels = require "assets.levels"

function score:enter(gamestate, userPoints, levelPoints, currentLvl)
  print(#userPoints, #levelPoints)
  self.userPoints = userPoints -- from marker
  self.levelPoints = levelPoints -- from level
  self.currentLvl = currentLvl
  -- print(levelPoints)
  self.currSay = 1
  self.kingsScore = self:grade() -- get the score
  self.kingSays = {
  "That was horrible piece of shi... ergh... art. I score this: ",
  "Hmmm, that was not what i wanted. You get: ",
  "I'm pretty sure she will not be impressed by this. I give you the score of: ",
  "Is there anything wrong with the machine? I grant you a score of: ",
  "This is a wonderfully mediocre piece art. You get: ",
  "An above average drawing! If you keep practicing I might be able to impress her. You get a solid score of ",
  "My wife-to-be is a lover of beautiful paintings and will marry me if I bring her some. This is not it. Close though. I give it a score of: ",
  "This will surely not get laughed at the kings art convention. I am glad I hired you! I rate this: ",
  "So close to perfection! If you tighten up, I might get laid tonight ;)  I score you: ",
  "Well done! I give this masterpiece a score of: "}

  self.menuButton = Button:new(Vector(50, 50), 50, "menu")
  self.nextButton = Button:new(Vector(WIDTH - 50, 50), 50, "next")
  self.replayButton = Button:new(Vector(WIDTH - 50, 150), 50, "replay")
end

function score:grade()
  local threshold = 32
  local inside = 0
  local outside = 0

  for l = 1, #self.levelPoints, 2 do
    for u = 1, #self.userPoints, 2 do

      local curU = Vector(self.userPoints[u],self.userPoints[u+1])
      local curL = Vector(self.levelPoints[l] + (WIDTH - 800) / 2,self.levelPoints[l+1] + (HEIGHT - 600) / 2)
      local dist = Vector.distance(curU,curL)
      if dist < threshold then
        inside = inside + 1
        break
      end
    end
  end

  local iScore = inside/(#self.levelPoints/2)

  for u = 1, #self.userPoints, 2 do
    for l = 1, #self.levelPoints, 2 do
      local curU = Vector(self.userPoints[u],self.userPoints[u+1])
      local curL = Vector(self.levelPoints[l] + (WIDTH - 800) / 2,self.levelPoints[l+1] + (HEIGHT - 600) / 2)
      local dist = Vector.distance(curU,curL)

      if dist < threshold then
        outside = outside + 1
        break
      end
    end
  end

  local oScore = outside/(#self.userPoints/2)

  return (oScore * iScore)
end

function score:update(dt)
  kingTimer = kingTimer - dt
  if kingTimer < 0 then
    kingAnim:gotoFrame(math.floor(math.random(1, 4) + 0.5))
    kingTimer = 0.1
  end
  self.replayButton:update(dt)
  self.menuButton:update(dt)
  self.nextButton:update(dt)
end

function score:draw()
  love.graphics.setColor(255, 255, 255, 100)
  love.graphics.setLineWidth(10)
  love.graphics.line(self.userPoints)
  -- print(self.kingsScore)
  love.graphics.setColor(255, 255, 255)
  if self.kingsScore*10  <= 0 then
     self.kingsScore = 0.1
  end
  local msg = self.kingSays[math.ceil(self.kingsScore*10)] .. math.floor(self.kingsScore*100) .. " out of 100!"
  love.graphics.printf(msg, WIDTH/4, HEIGHT/2 , WIDTH/2, "center")

  -- draw the king
  kingAnim:draw(kingImg, WIDTH/2 - 64, HEIGHT -  HEIGHT * (self.kingsScore) / 2.2)

  -- draw buttons
  self.replayButton:draw()
  self.menuButton:draw()
  self.nextButton:draw()
end


function score:mousepressed(mouseButton)
  if self.menuButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.menu)
  end
  if self.nextButton.isChosen == true then
    SOUNDS.click1:play()
    if self.currentLvl < #levels then
      Gamestate.switch(STATES.game, self.currentLvl + 1)
    else
      Gamestate.switch(STATES.credits)
    end
  end
  if self.replayButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.game, self.currentLvl)
  end
end
return score
