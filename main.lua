

-- require all stuff
Gamestate    = require "utility.gamestate"

ser          = require "utility.ser"
class        = require "utility.middleclass"
--Game         = require "utility.game"
Vector       = require "utility.vector"
Grid         = require "utility.grid"
Entity       = require "entities.entity"
MachineFrame = require "entities.machineFrame"
Marker       = require "entities.marker"
anim8        = require "utility.anim8"

WIDTH, HEIGHT = love.graphics.getWidth(), love.graphics.getHeight()

-- setup font
local mainFontPath = "assets/kenpixel_square.ttf"
MAIN_FONT_BIG = love.graphics.newFont(mainFontPath, 50)
MAIN_FONT_SMALL = love.graphics.newFont(mainFontPath, 12)

-- setup the king
kingImg = love.graphics.newImage("assets/king.png")
kingG   = anim8.newGrid(128, 128, kingImg:getWidth(), kingImg:getHeight())
kingAnim = anim8.newAnimation(kingG('1-4', 1), 0.1)
kingTimer = 0.2

MUSIC = love.audio.newSource("sounds/music.ogg", "stream")
MUSIC:setLooping(true)
love.audio.play(MUSIC)
SOUNDS = {
  click1 = love.audio.newSource("sounds/click1.wav", "static"),
  click2 = love.audio.newSource("sounds/click2.wav", "static"),
  inHole = love.audio.newSource("sounds/inHole.wav", "static"),
  --insertHole2 = love.audio.newSource("sounds/insertHole2.wav", "static"),
  rollOver1 = love.audio.newSource("sounds/rollOver1.wav", "static"),
  rollOver2 = love.audio.newSource("sounds/rollOver2.wav", "static")
}


STATES = {
  menu = require "states.menu",
  intro = require "states.intro",
  credits = require "states.credits",
  game = require "states.game",
  score = require "states.score"
}


function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(STATES.menu)
end
