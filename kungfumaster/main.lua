local entities = require('entities')
local asset_conf = require('asset_conf')
local input = require('input')
local level = require('level')
local state = require('state')
local viewport = require('viewport')
local dashboard = require('dashboard')

function love.load()
  love.graphics.setFont(love.graphics.newFont(12))
  state.current_level = level(1, entities[6])
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  state.current_level:draw()

  for _, entity in ipairs(entities) do
    if entity.draw then
      entity:draw()
     end
  end

  dashboard.draw()

  if state.button_debug then
    love.graphics.setColor(0, 0, 0, 1)
    -- Draw the current FPS.
    love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 150)
    -- Draw the current delta-time. (The same value
    -- is passed to update each frame).
    love.graphics.print("dt: " .. love.timer.getDelta(), 50, 170)
    love.graphics.print("z: kick, x: punch, arrow keys for move, space: debug", 50, 190)

    love.graphics.setColor(1, 0, 0, 1)

    love.graphics.line(viewport.screen.x + viewport.screen.width / 2 - 1,
                       viewport.screen.y,
                       viewport.screen.x + viewport.screen.width / 2 - 1,
                       viewport.screen.y + viewport.screen.height - 1)

    love.graphics.line(viewport.screen.x ,
                       viewport.screen.y + viewport.screen.height/2 -1,
                       viewport.screen.x + viewport.screen.width - 1,
                       viewport.screen.y + viewport.screen.height/2 -1)
    love.graphics.setColor(1, 1, 1, 1)
  end
end

function love.focus(focused)
end

function love.keypressed(pressed_key)
  input.press(pressed_key)
end

function love.keyreleased(released_key)
  input.release(released_key)
end

function love.update(dt)
  local index = 1

  state.time_left = state.time_left - dt
  if state.time_left < 0 then
  state.time_left = 0
  end

  --
  -- XXX test code
  --
  --[[
  state.hero_energy = state.hero_energy + love.math.random(-30, 30) * dt
  if state.hero_energy < 0 then
    state.hero_energy = 0
  end
  if state.hero_energy > 100 then
    state.hero_energy = 100 
  end
  state.enemy_energy = state.enemy_energy + love.math.random(-30, 30) * dt
  if state.enemy_energy < 0 then
    state.enemy_energy = 0
  end
  if state.enemy_energy > 100 then
    state.enemy_energy = 100
  end
  state.score = state.score + love.math.random(-300, 300) * dt
  if state.score < 0 or state.score > 999999 then
    state.score = 0
  end
  -- end of test code
  --]]

  while index <= #entities do
    local entity = entities[index]

    if entity.update then
      entity:update(dt)
    end

    index = index + 1
  end

  state.current_level:update(dt)
  input.update(dt)
  dashboard.update(dt)
end
