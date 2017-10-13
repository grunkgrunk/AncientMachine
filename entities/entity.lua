local class = require "utility.middleclass"
local Vector = require "utility.vector"
local Entity = class("Entity")

function Entity:initialize(pos, sclX, sclY, spritePath, depth)
  self.pos = pos or Vector(0,0)
  self.sclX = sclX or 64
  self.sclY = sclY or 64
  self.depth = depth or 0 -- smaller number are beghind larger numbers are in front

  -- load the sprite
  self.spritePath = spritePath
  if self.spritePath then
    self.sprite = love.graphics.newImage(self.spritePath)
  end

  self:addToWorld()
  STATES.game:append(self)
end

function Entity:addToWorld()
  self.body = love.physics.newBody(STATES.game.world, self.pos.x, self.pos.y, "dynamic")
  self.shape = love.physics.newRectangleShape(self.sclX, self.sclY)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setFilterData(0, 0, -8)
end

function Entity:draw()
  -- love.graphics.setColor(255, 0, 0)
  -- love.graphics.setLineWidth(1)
  -- if self.shapeType == "rectangle" then
  --love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
  -- end
  -- if self.shapeType == "circle" then
  --   local x,y = self.body:getPosition()
  --   love.graphics.ellipse("line", x,y, self.sclX/2, self.sclY/2)
  -- end
  if self.sprite then
    local x,y = self.body:getPosition()
    love.graphics.setColor(255, 255, 255, 255)
    local r = self.body:getAngle()
    love.graphics.draw(self.sprite, x, y, r, 1, 1, 32, 32)
  end


end

function Entity:getPosition()
  --return self.body:getWorldPoints(self.shape:getPoints())
  local x,y = self.body:getPosition()
  return Vector(x, y)
end

function Entity:update(dt)

end

return Entity
