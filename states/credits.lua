-- make button class

local Vector = require "utility.vector"
local Button = require "entities.button"

local credits = {}

function credits:enter()
  self.msg = "Made with Löve, by Schauser and Grunkin"
  --self.menuButton = {pos = Vector(WIDTH/2, HEIGHT - 100), type = "back", isChosen = false, r = 50 / 1.1}
  self.menuButton = Button:new(Vector(50, 50), 50, "menu")
end

function credits:update(dt)
  -- local button = self.menuButton
  -- local mPos = Vector(love.mouse.getX(), love.mouse.getY())
  -- local dist = Vector.distance(button.pos, mPos)
  -- if dist < button.r then
  --   button.isChosen = true
  -- else
  --   button.isChosen = false
  -- end
  self.menuButton:update(dt)
end

function credits:draw()
  love.graphics.setColor(255, 255, 255)
  -- WIDTH is where the text is on x-axis
  love.graphics.setFont(MAIN_FONT_BIG)
  love.graphics.printf("Ancient Machine", 0, 100, WIDTH, "center")

  love.graphics.setFont(MAIN_FONT_SMALL)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(self.msg, 0, HEIGHT/2, WIDTH, "center")
  -- local button = self.menuButton
  -- if button.isChosen then
  --   love.graphics.setColor(255, 165, 122, 200)
  --   love.graphics.circle("fill", button.pos.x, button.pos.y, button.r, 100)
  -- end
  -- love.graphics.setColor(100, 100, 100)
  -- love.graphics.circle("line", button.pos.x, button.pos.y, button.r, 100)
  --
  -- love.graphics.setColor(255, 255, 255)
  -- love.graphics.printf(button.type, 0, button.pos.y - 10, WIDTH, "center")
  self.menuButton:draw()
end

function credits:mousepressed(mouseButton)
  local button = self.menuButton
  if button.isChosen then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.menu)
  end
end

return credits
