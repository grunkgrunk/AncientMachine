local intro = {}
local Button = require "entities.button"

function intro:enter()
  self.currSay = 1
  self.kingSays = {
  "Hello pesant! (press 'next' to continue)", "I, Luis the Unimaginative, king of this great country need your help!", "I am in dire need of beautiful pieces of art to woo a pretty lady.",
  "But I am in trouble!", "/n","I hired the smartest engineer in the entire kingdom to build a machine to help me.", "But alas! He died before he could ever test it.", "This is where you come in: ",
  "I need YOU to use the machine to create pieces of art that will dazzle the love of my life.", "But beware - the engineer did not make the machine easy to operate.", "Please say yes: ", "You are my only hope!"
  }
  self.kingTimer = 0.1

  self.quest = "You have recieved a quest: Operate this ancient machinery to make art and most importantly impress King Luis' one true love2d! Choose a starting point now. When in game, press space to submit your drawing and press r to restart the current level. (You can restart after having your drawing graded!)"

  self.menuButton = Button:new(Vector(50, 50), 50, "menu")
  self.nextButton = Button:new(Vector(WIDTH - 50, 50), 50, "next")
end

function intro:update(dt)
  if self.currSay ~= #self.kingSays then
    self.kingTimer = self.kingTimer - dt
    if self.kingTimer < 0 then
      kingAnim:gotoFrame(math.floor(math.random(1, 4) + 0.5))
      self.kingTimer = 0.1
    end
  else
    kingAnim:gotoFrame(4)
  end

  self.menuButton:update(dt)
  self.nextButton:update(dt)
end

function intro:draw()
  local msg = self.kingSays[self.currSay]
  -- local font = love.graphics.newFont(24)

  -- local fW = font:getWidth(msg)
  love.graphics.printf(msg, WIDTH/4, HEIGHT/2, WIDTH/2, "center")

  kingAnim:draw(kingImg, WIDTH/2 - 64, HEIGHT - 20*self.currSay)

  self.menuButton:draw()
  self.nextButton:draw()

end

function intro:keypressed(key)
  if key == "space" then

  end
end

function intro:mousepressed(mouseButton)
  if self.menuButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.menu)
  end

  if self.nextButton.isChosen == true then
    SOUNDS.click1:play()
    if self.currSay < #self.kingSays then
      self.currSay = self.currSay + 1
    else
      -- switch state!
      Gamestate.switch(STATES.game, 1)
    end
  end
end
return intro
