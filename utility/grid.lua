local class = require "utility.middleclass"
local Vector = require "utility.vector"

local Grid = class("Grid")

function Grid:initialize(width, height, squareScl)
  self.squareScl = squareScl or 64
  self.width     = width or 3
  self.height    = height or 3
  self.size      = self.width * self.height
  self.pixelX    = self.width * self.squareScl
  self.pixelY    = self.height * self.squareScl
  self.space     = {}
  --self:init()

end

function Grid:init()
  for i = 1, self.size do
    self.space[i] = {}
  end

  -- for y = 1, self.height do
  --   line = {}
  --   for x = 1, self.width do
  --     line[x] = {}
  --   end
  --   self.space[y] = line
  -- end
end

function Grid:set(i, val)
  self.space[i] = val
  --self.space[pos.y][pos.x] = val
end

function Grid:append(val)
  self.space[#self.space + 1] = val
end

function Grid:get(i)
  return self.space[i]
  -- if self:inSpace(pos) and pos ~= nil then
  --   return self.space[pos.y][pos.x]
  -- end
  -- return nil
end

function Grid:inSpace(pos)
  return ((pos.x >= 1 and pos.x <= self.width) and
    (pos.y >= 1 and pos.y <= self.height))
end

function Grid:worldToSpace(pos)
  -- takes a position from the world and converts it to the index in Grid.space
  local spacePos = Vector(math.ceil(pos.x/self.squareScl), math.ceil(pos.y/self.squareScl))
  if self:get(spacePos) then
    return spacePos
  end
  return nil -- if there is no such index
end

function Grid:getFromWorld(pos)
  local spacepos = self:worldToSpace(pos)
  return self:get(spacepos)
end

function Grid:spaceToWorld(pos)
  local worldPos = pos * self.squareScl
  worldPos = worldPos - Vector(self.squareScl / 2, self.squareScl / 2)
  return worldPos
end

return Grid
