local asset_conf = require('asset_conf')
local level = require('level')
local state = require('state')
local viewport = require('viewport')
local dashboard = require('dashboard')
local scenemanager = require('scenes/scenemanager')

function love.load()
  level(4)
  scenemanager:reset()
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  scenemanager:draw()
end

function love.focus(focused)
end

function love.keypressed(pressed_key)
  if pressed_key == 'p' then
    state.paused = not state.paused
    return
  end

  scenemanager:keypressed(pressed_key)
end

function love.keyreleased(released_key)
  scenemanager:keyreleased(released_key)
end

function love.update(dt)
  if state.paused or dt > 0.1 then
    return
  end

  scenemanager:update(dt)
end
