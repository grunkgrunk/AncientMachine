--local scoreScreen = require "utility.scoreScreen"
local Entity = require "entities.entity"
local Button = require "entities.button"
local Vector = require "utility.vector"
local anim8 = require "utility.anim8"



local Game = {}

Game.sortByDrawOrder = function(a, b)
  return a.depth < b.depth
end

function Game:reset(lvl)
  --self.ui = love.graphics.newImage("assets/wall.png")
  self.levels = require "assets.levels"
  self.currentLvl = lvl or 1
  -- print(self.currentLvl)

  self.entities = {}

  love.physics.setMeter(64)
  self.world = love.physics.newWorld(0, 0, true)

  self.background = love.graphics.newImage("assets/beach_sand.png")

  -- make the wall
  wall = Entity:new(Vector(WIDTH/2, HEIGHT/2), 300, 300)
  wall.body:setType("kinematic")
  wall.body:setFixedRotation(true)

  -- make the machine frame
  local frame = MachineFrame:new()

  local armYOffset = 85
  arm = Entity:new(Vector(WIDTH/2, HEIGHT/2 - armYOffset), 64, armYOffset, nil, 1)

  jointFrameArm = love.physics.newWeldJoint(frame.body, arm.body, WIDTH/2, HEIGHT/2 - armYOffset, false)

  --join marker and arm
  marker = Marker:new(Vector(WIDTH/2, HEIGHT/2 - armYOffset - armYOffset/2), 64, arm.body)

  -- make marker
  local sx = frame.grid.squareScl
  local pos = marker:getPosition()
  local e = Entity:new(pos, sx, sx, "assets/holev2.png", 1)
  frame.grid:append(e)
  love.physics.newWeldJoint(e.body, arm.body, pos.x, pos.y, false)

  self.menuButton = Button:new(Vector(50, 50), 50, "menu")
  self.gradeButton = Button:new(Vector(WIDTH - 50, 50), 50, "get score")
  self.replayButton = Button:new(Vector(WIDTH - 50, 150), 50, "replay")
end

function Game:enter(gamestate, lvl)
  self:reset(lvl)
end

function Game:draw()
-- draw the background
  love.graphics.draw(self.background, 0, 0)
  love.graphics.setColor(255, 255, 255, 200)

  love.graphics.setLineWidth(10)
  love.graphics.push()
  love.graphics.translate((WIDTH - 800) / 2, (HEIGHT - 600) / 2)
  love.graphics.line(self.levels[self.currentLvl])
  love.graphics.pop()
  -- draw all entities
  table.sort(self.entities, self.sortByDrawOrder)
  for _, v in ipairs(self.entities) do
    v:draw()
  end

  -- draw the button
  self.menuButton:draw()
  self.gradeButton:draw()
  self.replayButton:draw()
end


function Game:update(dt)
  for _, v in ipairs(self.entities) do
    v:update(dt)
  end
  self.world:update(dt)

  self.menuButton:update(dt)
  self.gradeButton:update(dt)
  self.replayButton:update(dt)

end

function Game:append(e)
  table.insert(self.entities, e)
end

function Game:mousepressed(mouseButton)
  if self.menuButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.menu)
  end
  if self.gradeButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.score,  marker.points, self.levels[self.currentLvl], self.currentLvl)
  end
  if self.replayButton.isChosen == true then
    SOUNDS.click1:play()
    Gamestate.switch(STATES.game, self.currentLvl)
  end
end

-- remove?

return Game
