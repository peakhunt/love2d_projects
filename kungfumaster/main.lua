local world = require('world')
local entities = require('entities')
local asset_conf = require('asset_conf')
local input = require('input')
local level = require('level')
local state = require('state')

function love.load()
  love.graphics.setFont(love.graphics.newFont(11))
  state.current_level = level(1, entities[6])
end

function love.draw()
  --love.graphics.setBackgroundColor(115/255, 27/255, 135/255, 1)
  --love.graphics.line(0, 400, 800, 400)
  state.current_level:draw()

  for _, entity in ipairs(entities) do
    if entity.draw then
      entity:draw()
     end
  end

  -- Draw the current FPS.
  love.graphics.print("FPS: " .. love.timer.getFPS(), 50, 50)
  -- Draw the current delta-time. (The same value
  -- is passed to update each frame).
  love.graphics.print("dt: " .. love.timer.getDelta(), 50, 70)
  love.graphics.print("z: kick, x: punch, arrow keys for move", 50, 90)
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

  while index <= #entities do
    local entity = entities[index]

    if entity.update then
      entity:update(dt)
    end

    index = index + 1
  end

  state.current_level:update(dt)
  world:update(dt)
  input.update(dt)
end
