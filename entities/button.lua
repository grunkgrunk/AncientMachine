local class = require "utility.middleclass"
local Vector = require "utility.vector"


local Button = class("Button")

function Button:initialize(pos, r, type)
  self.pos = pos or Vector(0,0)
  self.rInvis = r or 50
  self.rVis = self.rInvis / 1.1
  self.type = type
  self.isChosen = false
  self.isRollSoundReady = true
  self.isClickSoundReady = true
end


function Button:draw()
  love.graphics.setLineWidth(2)
  if self.isChosen then
    love.graphics.setColor(255, 165, 122, 200)
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.rVis, 100)
  else
    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.rVis, 100)
  end

  love.graphics.setColor(100, 100, 100)
  love.graphics.circle("line", self.pos.x, self.pos.y, self.rVis, 100)




  if self.type ~= "lvl" then
    love.graphics.setFont(MAIN_FONT_SMALL)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(self.type, 0, self.pos.y - 10, self.pos.x * 2, "center")
  end
end

function Button:update(dt)
  local mPos = Vector(love.mouse.getX(), love.mouse.getY())
  local dist = Vector.distance(self.pos, mPos)
  if dist < self.rVis then
    self.isChosen = true
  else
    self.isChosen = false
  end

  -- play sound when hovering over button
  if self.isChosen and self.isRollSoundReady then
    SOUNDS.rollOver1:play()
    self.isRollSoundReady = false
  elseif not self.isChosen then
    self.isRollSoundReady = true
  end

  -- -- play sound when pressing
  -- if love.mouse.isDown(mouseButton) then
  --   if self.isChosen and self.isClickSoundReady then
  --     self.isClickSoundReady = false
  --   end
  -- elseif not self.isChosen then
  --   self.isClickSoundReady = true
  -- end

end

return Button
