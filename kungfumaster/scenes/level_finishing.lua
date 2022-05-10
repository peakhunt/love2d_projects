local asset_conf = require('asset_conf')
local collision = require('collision')
local state = require('state')
local game = require('game')

local level_common = require('scenes/level_common')

local target_duration = 4.0

return function()
  local scene = {
    name = "level_finishing",
    timeAccumulated = 0,
    xspeed = 0,
    yspeed = 0,

    enter = function(self)
      -- calculate stair up values
      local sx, sy, ex, ey

      --
      -- finish is a quad with (x,y) at top left
      --
      if state.current_level.conf.forward then
        -- right to left 
        sy = asset_conf.floor_bottom
        sx = state.current_level.finish.x + state.current_level.finish.width
        ex = state.current_level.finish.x
        ey = state.current_level.finish.y
      else
        -- left to right
        sy = asset_conf.floor_bottom
        sx = state.current_level.finish.x 
        ex = state.current_level.finish.x + state.current_level.finish.width
        ey = state.current_level.finish.y
      end

      self.xspeed = (ex - sx) / target_duration
      self.yspeed = (ey - sy) / target_duration

      if self.xspeed < 0 then
        state.hero.forward = true
      else
        state.hero.forward = false
      end

      self.timeAccumulated = 0
      state.hero:startStairUp()
    end,

    exit = function(self)
    end,

    update = function(self, dt)
      self.timeAccumulated = self.timeAccumulated + dt
      if self.timeAccumulated >= target_duration then
        game.nextLevel()
        return
      end

      local dx = self.xspeed * dt
      local dy = self.yspeed * dt

      state.hero:move(dx, dy)

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
