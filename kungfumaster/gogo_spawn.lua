local viewport = require('viewport')
local factory = require('factory')
local asset_conf = require('asset_conf')
local state = require('state')

return function(config)
  local gogo_spawn = {
    timeAccumulated = 0,
    started = false,

    update = function(self, dt)
      if state.test_mode then
        return
      end

      if self.started == false then
        return
      end

      if state.boss_activated == true then
        return
      end

      if state.gogo_count >= config.max then
        self.timeAccumulated = 0
        return
      end

      self.timeAccumulated = self.timeAccumulated + dt

      if love.math.random() <= config.missRate or
         self.timeAccumulated < config.delay then
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

      self.timeAccumulated = 0
      local entity = factory.entities.gogo(x, asset_conf.floor_bottom)

      table.insert(state.entities, entity)
      state.gogo_count = state.gogo_count + 1
    end,

    start = function(self)
      self.timeAccumulated = 0
      self.started = true
    end,

    stop = function(self)
      self.started = false
    end,
  }

  return gogo_spawn
end
