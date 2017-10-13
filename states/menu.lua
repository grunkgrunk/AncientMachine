local Vector = require "utility.vector"
local Button = require "entities.button"

local menu = {}



function menu:enter()
  self.buttons = {}
  self.buttonRadius = 50
  self.selectedButton = 0
  self.levels = require "assets.levels"

  local r = self.buttonRadius
  local circlesW = r * 6 * 2
  for y = 1, 2 do
    for x = 1, #(self.levels) / 2 do
      -- the position
      local posx = (x - 1) * r * 2 + WIDTH / 2 - circlesW / 2 + r
      local posy = (y - 1) * r * 2 + 300 + r
      local pos = Vector(posx, posy)

      -- the state
      local lvl = x + (y-1) * #self.levels / 2
      --local button = {pos = pos, type = "lvl", lvl = lvl}
      local button = Button:new(pos, self.buttonRadius, "lvl")

      -- now insert the button
      table.insert(self.buttons, button)
    end
  end

  local introButton = Button:new(Vector(WIDTH/2 - r * 1, 250), self.buttonRadius, "intro")
  table.insert(self.buttons, introButton)

  local credsButton = Button:new(Vector(WIDTH/2 + r, 250), self.buttonRadius, "credits")
  table.insert(self.buttons, credsButton)
end


function menu:draw()
  love.graphics.setColor(255, 255, 255)
  -- WIDTH is where the text is on x-axis
  love.graphics.setFont(MAIN_FONT_BIG)
  love.graphics.printf("Ancient Machine", 0, 100, WIDTH, "center")

  local r = self.buttonRadius
  for i = 1, #self.buttons do
    -- container for levels
    local button = self.buttons[i]
    button:draw()

    local pos = button.pos

    if button.type == "lvl" then
      love.graphics.setColor(255, 255, 255)
      love.graphics.push()

      local px, py = pos.x - button.rInvis, pos.y - button.rInvis + 5

      love.graphics.translate(px,py)
      love.graphics.scale(0.13)
      love.graphics.line(self.levels[i])
      love.graphics.pop()
    end
  end
end

function menu:update(dt)
  self.selectedButton = 0
  for i = 1, #self.buttons do
    local button = self.buttons[i]
    button:update(dt)
    if button.isChosen then
      self.selectedButton = i
    end
  end
end

function menu:mousepressed(x, y, buttonKey)
  if self.selectedButton >= 1 then
    local button = self.buttons[self.selectedButton]
    local type = button.type
    if button.type == "lvl" then
      SOUNDS.click1:play()
      -- print("s", self.selectedButton)
      Gamestate.switch(STATES.game, self.selectedButton) -- go to the specific lvl
    end

    if button.type == "intro" then
      SOUNDS.click1:play()
      Gamestate.switch(STATES.intro)
    end

    if button.type == "credits" then
      SOUNDS.click1:play()
      Gamestate.switch(STATES.credits)
    end
  end
end

return menu
