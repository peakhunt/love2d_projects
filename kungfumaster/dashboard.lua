--
-- dashboard
--
local state = require('state')
local font = love.graphics.newFont("assets/arcadeclassic.ttf", 20)
local font_small = love.graphics.newFont("assets/arcadeclassic.ttf", 15)
local font_big = love.graphics.newFont("assets/arcadeclassic.ttf", 25)
local energy_bar_width = 200

function drawScore()
  local str
  str = string.format("1P-%06d", state.score)

  love.graphics.setColor(love.math.colorFromBytes(00, 0xff, 0xff))
  love.graphics.print(str, font, 30, 10)

  str = string.format("2P-%06d", 0)
  love.graphics.print(str, font, 585, 10)
end

function drawTopScore()
  local str
  str = string.format("TOP-%06d", state.top_score)

  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x0, 0x0))
  love.graphics.print(str, font, 300, 10)
end

function drawHeroEnergy()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x99, 0x33))
  love.graphics.print("PLAYER", font, 30, 50)

  local width = energy_bar_width * state.hero_energy / 100
  love.graphics.rectangle("fill", 160, 50, width, 22)
end

function drawBossEnergy()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x00, 0xff))
  love.graphics.print("ENERMY", font, 30, 80)

  local width = energy_bar_width * state.enemy_energy / 100
  love.graphics.rectangle("fill", 160, 80, width, 22)
end

function drawCurrentLevel()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0xfe, 0xe0))
  love.graphics.print("1F 2F 3F 4F 5F", font_small, 400, 50)
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x00, 0xff))
  love.graphics.print("  →  →  →  →  ", font_small, 400, 80)
end

function drawLivesLeft()
end

function drawTimeLeft()
  local str
  str = string.format("%04d", state.time_left)

  love.graphics.setColor(love.math.colorFromBytes(0xff, 0xff, 0xff))
  love.graphics.print("TIME", font_big, 650, 50)
  love.graphics.print(str, font_big, 650, 80)
end

function update(dt)
end

function draw()
  drawScore()
  drawTopScore()
  drawHeroEnergy()
  drawBossEnergy()
  drawCurrentLevel()
  drawLivesLeft()
  drawTimeLeft()
end

return {
  update = update,
  draw = draw,
}
