local asset_conf = require('asset_conf')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local state = require('state')
local input = require('input')
local factory = require('factory')

local level_common = require('scenes/level_common')

return function()
  local scene = {
    name = "hero_falling",
    timeAccumulated = 0,

    enter = function(self)
      self.timeAccumulated = 0
      state:decHeroLives(1)
      state.hero:fall()
    end,

    exit = function(self)
    end,

    update = function(self, dt)
      self.timeAccumulated = self.timeAccumulated + dt
      if self.timeAccumulated >= 1.0 then
        state.current_level:restart()
        state:changeScene(factory.scenes.level_starting())
        return
      end

      level_common.update(dt)
    end,

    draw = function(self)
      level_common.draw()
    end,

    keypressed = function(self, pressed_key)
    end,

    keyreleased = function(self, released_key)
    end,
  }

  return scene
end
