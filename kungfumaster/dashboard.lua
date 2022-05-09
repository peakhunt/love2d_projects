--
-- XXX FIXME rewrite this using virtual coordinate unit!!!
--
-- dashboard
--
local state = require('state')
local asset_conf = require('asset_conf')
local resource = require('resource')
local viewport = require('viewport')

local energy_bar_width = 200
local spriteSheet = resource.spriteSheet
local lifeRect = asset_conf.lifeSprite
local lifeQuad = love.graphics.newQuad(
  lifeRect.pos_x,
  lifeRect.pos_y,
  lifeRect.width,
  lifeRect.height,
  spriteSheet:getDimensions()
)

function setLevelColor(target)
  if target < state.level then
    love.graphics.setColor(love.math.colorFromBytes(0x66, 0xff, 0x00))
  else
    love.graphics.setColor(love.math.colorFromBytes(0x00, 0x50, 0x00))
  end
end

function drawScore()
  local str
  str = string.format("1P-%06d", state.score)

  love.graphics.setColor(love.math.colorFromBytes(00, 0xff, 0xff))
  love.graphics.print(str, resource.font, 30, 10)

  str = string.format("2P-%06d", 0)
  love.graphics.print(str, resource.font, 585, 10)
end

function drawTopScore()
  local str
  str = string.format("TOP-%06d", state.top_score)

  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x0, 0x0))
  love.graphics.print(str, resource.font, 300, 10)
end

function drawHeroEnergy()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x99, 0x33))
  love.graphics.print("PLAYER", resource.font, 30, 50)

  local width = energy_bar_width * state.hero_energy
  love.graphics.rectangle("fill", 160, 50, width, 22)
end

function drawBossEnergy()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x00, 0xff))
  love.graphics.print("ENERMY", resource.font, 30, 80)

  local width = energy_bar_width * state.boss_energy
  love.graphics.rectangle("fill", 160, 80, width, 22)
end

function drawCurrentLevel()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0xfe, 0xe0))
  love.graphics.print("1F 2F 3F 4F 5F", resource.font_small, 400, 50)

  love.graphics.setColor(love.math.colorFromBytes(0xff, 0x00, 0xff))
  love.graphics.print("  →  →  →  →  ", resource.font_small, 400, 76)

  setLevelColor(1)
  love.graphics.rectangle('fill', 410, 74, 12, 20)

  setLevelColor(2)
  love.graphics.rectangle('fill', 455, 74, 12, 20)

  setLevelColor(3)
  love.graphics.rectangle('fill', 500, 74, 12, 20)

  setLevelColor(4)
  love.graphics.rectangle('fill', 545, 74, 12, 20)

  setLevelColor(5)
  love.graphics.rectangle('fill', 590, 74, 12, 20)
end

function drawLivesLeft()
  love.graphics.setColor(love.math.colorFromBytes(0xff, 0xff, 0xff))

  local px, py
  local sx, sy

  sx, sy = -1.5, 1.5 

  px = 420
  py = 100

  for i = 1, state.life_left - 1 do
    love.graphics.draw(spriteSheet, lifeQuad, px, py, 0, sx, sy)
    px = px + 20
  end
end

function drawTimeLeft()
  local str
  str = string.format("%04d", state.time_left)

  love.graphics.setColor(love.math.colorFromBytes(0xff, 0xff, 0xff))
  love.graphics.print("TIME", resource.font_big, 650, 50)
  love.graphics.print(str, resource.font_big, 650, 80)
end

function update(dt)
end

function draw()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.rectangle("fill",
      viewport.dashboard.x,
      viewport.dashboard.y,
      viewport.dashboard.width,
      viewport.dashboard.height)

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
