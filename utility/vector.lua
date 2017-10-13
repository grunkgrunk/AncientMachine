local class = require "utility.middleclass"

local Vector = class("Vector")

function Vector:initialize(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vector:add(a)
  self.x = self.x + a.x
  self.y = self.y + a.y
end

function Vector:sub(a)
  self.x = self.x - a.x
  self.y = self.y - a.y
end

function Vector:mult(a)
  self.x = self.x * a
  self.y = self.y * a
end

function Vector:div(a)
  self.x = self.x / a
  self.y = self.y / a
end

function Vector:set(v)
  self.x = v.x
  self.y = v.y
end


function Vector.__add(a, b)
  return Vector(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
  return Vector(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
  return Vector(a.x * b, a.y * b)
end

function Vector.__div(a, b)
  return Vector(a.x / b.x, a.y / b.y)
end

function Vector.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

function Vector.__lt(a, b)
  return a.x < b.x or (a.x == b.x and a.y < b.y)
end

function Vector.__le(a, b)
  return a.x <= b.x and a.y <= b.y
end

function Vector.__tostring(a)
  return "(" .. a.x .. ", " .. a.y .. ")"
end

function Vector.distance(a, b)
  return (b - a):mag()
end

function Vector:distanceSq(target)
  return (target - self):magSq()
end

function Vector:clone()
  return Vector(self.x, self.y)
end

function Vector:unpack()
  return self.x, self.y
end

function Vector:mag()
  return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:magSq()
  return self.x * self.x + self.y * self.y
end

function Vector:normalize()
  local mag = self:mag()
  if mag ~= 0 then
    self.x = self.x / mag
    self.y = self.y / mag
  end
  return self
end

function Vector:rotate(phi)
  local c = math.cos(phi)
  local s = math.sin(phi)
  self.x = c * self.x - s * self.y
  self.y = s * self.x + c * self.y
  return self
end

function Vector:rotated(phi)
  return self:clone():rotate(phi)
end

function Vector:perpendicular()
  return Vector(-self.y, self.x)
end

function Vector:projectOn(other)
  return (self * other) * other / other:magSq()
end

function Vector:cross(other)
  return self.x * other.y - self.y * other.x
end

function Vector:getAngle(pos)
  return math.atan2(self.y + pos.y, self.x + pos.x)
end

function Vector:look(pos, target)
  local mag = self:mag()
  local between = target - pos
  local norm = between:normalize()
  return norm * mag
end

function Vector:limit(maxmag)
  local currmag = self:magSq()
  if maxmag * maxmag > currmag then
    return self:normalize() * maxmag
  end
  return self
end

function Vector:heading()
  return math.atan2(self.y, self.x)
end

return Vector
