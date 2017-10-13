local class = require "utility.middleclass"
local anim8 = require "utility.anim8"
local Entity = require "entities.entity"
local Grid = require "utility.grid"
local Vector = require "utility.vector"
local MachineFrame = class("MachineFrame",Entity)

local function dottedCircle(x, y, r, n)
  local points = {}
  for i = 0, n do
    table.insert(points, math.cos((i * 2 * math.pi/n))*r + x)
    table.insert(points, math.sin(i * 2 * math.pi/n) *r+ y)
  end
  love.graphics.points(points)
end

local function sign(a)
  a = math.floor(a+0.5)
  if a > 0 then return 1 end
  if a < 0 then return -1 end
  if a == 0 then return 0 end
end

local w, h = love.graphics.getWidth(), love.graphics.getHeight()

function MachineFrame:initialize(pos, sclX, sclY)
  self.grid = Grid:new()
  Entity.initialize(self, pos or Vector:new(w / 2, h / 2), self.grid.pixelX, self.grid.pixelY, nil, 2)

  -- set rotation


  -- add entities to grid
  for y = 0, self.grid.height - 1 do
    for x = 0, self.grid.width - 1 do
      local xx, yy = x * self.grid.squareScl + self.pos.x + self.grid.squareScl/2 - self.grid.pixelX/2,
      y * self.grid.squareScl + self.pos.y + self.grid.squareScl/2 - self.grid.pixelY/2;
      local e = Entity:new(Vector(xx, yy), self.grid.squareScl,self.grid.squareScl, "assets/holev2.png", 1)
      love.physics.newWeldJoint(self.body, e.body, xx, yy, false)
      -- e.fixture:setUserData("hole")
      self.grid:append(e)
    end
  end

  -- get wall from list of entities
  self.jointToWall = love.physics.newRevoluteJoint(wall.body, self.body, w/2, h/2, false)
  self.inControl = self.grid:get(1)
  self.isReadyToMove = true
  self.wheelSpeed = 0.05
  self.wheelImg  = love.graphics.newImage('assets/wheel.png')
  self.wheelG    = anim8.newGrid(64, 64, self.wheelImg:getWidth(), 64)
  self.wheelAnim = anim8.newAnimation(self.wheelG('1-7',1), self.wheelSpeed)
  self.wheelAnim:pause()
  self.dir = -1
  self.wheelAnim.delays = 0.4

end

function MachineFrame:chooseHole()
  self.jointToWall:destroy()
  local entInControlPos = self.inControl:getPosition()
  self.jointToWall = love.physics.newRevoluteJoint(wall.body, self.body, entInControlPos.x,entInControlPos.y, false)
  -- control grid
  local mx, my = love.mouse.getX(), love.mouse.getY()
  local mouse = Vector(mx, my)
  local grid = self.grid
  for _, e in ipairs(self.grid.space) do
    local pos = e:getPosition()
    local dist = Vector.distance(pos, mouse)
    if dist < e.sclX/2 then
      if self.inControl ~= e then
        SOUNDS.inHole:play()
      end
      self.inControl = e
    end

  end
end

function MachineFrame:rotateMachine()
  local lastAngVel = self.body:getAngularVelocity()
  self.body:setAngularVelocity(0)
  local currImg = self.wheelAnim.position
  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    self.body:setAngularVelocity(-1)
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    self.body:setAngularVelocity(1)
  end
  local angVel = self.body:getAngularVelocity()
  --self.wheelSpeed = math.abs(angVel/15)
  if sign(angVel) ~= sign(lastAngVel) then
    if sign(angVel) == 1 then
      self.wheelAnim = anim8.newAnimation(self.wheelG('7-1',1), self.wheelSpeed)
    elseif sign(angVel) == -1 then
      self.wheelAnim = anim8.newAnimation(self.wheelG('1-7',1), self.wheelSpeed)
    else
      self.wheelAnim:pause()
    end
  end

end

function MachineFrame:isDirChanged()
end


function MachineFrame:getPoints()
  return self.body:getWorldPoints(self.shape:getPoints())
end

function MachineFrame:update(dt)
  self:chooseHole()
  self:rotateMachine()
  self.wheelAnim:update(dt)
end



function MachineFrame:draw()
  -- love.graphics.setColor(255, 255, 255)
  -- love.graphics.polygon("line", self:getPoints()) -- machine frame
  for _, e in ipairs(self.grid.space) do
    e:draw() -- holes
  end

  -- helper lines

  local mPos = marker:getPosition() -- move to marker


  local entInControlPos = self.inControl:getPosition()
  local dist = Vector.distance(mPos, entInControlPos)
  love.graphics.setColor(100, 50, 255, 200)
  --love.graphics.circle("line", entInControlPos.x, entInControlPos.y, dist, 100)
  love.graphics.circle("line", entInControlPos.x, entInControlPos.y, 2, 100)
  love.graphics.setPointSize(5)
  dottedCircle(entInControlPos.x, entInControlPos.y, dist, math.floor(dist/2))


  -- draw the wheel
  love.graphics.setColor(255, 255, 255)
  self.wheelAnim:draw(self.wheelImg, mPos.x, mPos.y, marker.body:getAngle()-math.pi/2, 1, 1, 8,32)
end

return MachineFrame
