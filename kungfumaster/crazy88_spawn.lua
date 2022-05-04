local viewport = require('viewport')
local timer = require('timer')
local factory = require('factory')
local asset_conf = require('asset_conf')
local state = require('state')

return function(config)
  local timer = timer(config.rate,
  function()
    if state.test_mode then
      return
    end

    if state.boss_activated == true then
      return
    end

    if state.crazy88_count >= config.max or love.math.random() <= config.missRate then
      return
    end

    local lx, rx = viewport:spaceLeftRight(0.5)

    if lx == -1 and rx == -1 then
      return
    end

    if lx ~= -1 and rx ~= -1 then
      if love.math.random() < 0.5 then
        x = lx
      else
        x = rx
      end
    elseif lx ~= -1 then
      x = lx
    else
      x = rx
    end

    local entity = factory.entities.crazy88(x, asset_conf.floor_bottom)

    table.insert(state.entities, entity)
    state.crazy88_count = state.crazy88_count + 1
  end)

  local crazy88_spawn = {
    timer = timer,

    update = function(self, dt)
      self.timer:update(dt)
    end,

    start = function(self)
      self.timer:start()
    end,

    stop = function(self)
      self.timer:stop()
    end,
  }

  return crazy88_spawn
end
