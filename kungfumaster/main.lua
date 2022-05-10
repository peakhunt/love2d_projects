---------------------------------------------------------------
--
-- XXX this should be the first line
-- the effect is this line initializes the factory
-- it seems like this is the only way to avoid all the 
-- circular require hell
--
---------------------------------------------------------------
require('init')

local asset_conf = require('asset_conf')
local state = require('state')
local game = require('game')

local start_level = 1

function handle_cmd_args()
  if #arg < 2 then
    return
  end

  for l = 2, #arg do
    if arg[l] == '--test-mode' then
      state.test_mode = true
    elseif arg[l] == '--debug' then
      state.button_debug = true 
    elseif arg[l] == '--level1' then
      start_level = 1
    elseif arg[l] == '--level2' then
      start_level = 2
    elseif arg[l] == '--level3' then
      start_level = 3
    elseif arg[l] == '--level4' then
      start_level = 4
    elseif arg[l] == '--level5' then
      start_level = 5
    end
  end
end

function love.load()
  handle_cmd_args()
  game.newGame(start_level)
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)

  state.scene:draw()
end

function love.focus(focused)
end

function love.keypressed(pressed_key)
  if pressed_key == 'p' then
    state.paused = not state.paused
    return
  end

  state.scene:keypressed(pressed_key)
end

function love.keyreleased(released_key)
  state.scene:keyreleased(released_key)
end

function love.update(dt)
  -- XXX remove this
  if state.paused or dt > 0.1 then
    return
  end

  state.scene:update(dt)
end
