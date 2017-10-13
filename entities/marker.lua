local class = require "utility.middleclass"
local Vector = require "utility.vector"
local Entity = require "entities.entity"
local Marker = class("Marker", Entity)

function Marker:initialize(pos, scl, attachTo)
  Entity.initialize(self, pos, scl)
  self.joint = love.physics.newWeldJoint(self.body, attachTo, pos.x, pos.y, false)
  self.points = {pos.x, pos.y, pos.x, pos.y}
  self.msPerPoint = 50
  self.time = self.msPerPoint
  self.depth = -1
end

function Marker:collectPoints(dt)
  self.time = self.time - dt * 1000
  local floor = math.floor
  local w = math.abs(self.body:getAngularVelocity())


  if self.time < 0 and w > 0.1 then
    local px,py = self.points[#self.points-1], self.points[#self.points]
    local x,y = self.body:getPosition()

    local pPos = Vector(px, py)
    local cPos = Vector(x, y)
    local dist = Vector.distance(pPos, cPos)
    table.insert(self.points, math.floor(x))
    table.insert(self.points, math.floor(y))

    ---- print(#self.points)
    self.time = self.msPerPoint
  end
end

function Marker:update(dt)
  self:collectPoints(dt)
end

function Marker:draw()
  -- love.graphics.setColor(255, 0, 0)
  -- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.setColor(76, 70, 50)
  love.graphics.setLineWidth(10)
  -- love.graphics.setLineStyle("smooth")
  love.graphics.line(self.points)
end

return Marker
