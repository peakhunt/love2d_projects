local asset_conf = require('asset_conf')
local collision = require('collision')
local viewport = require('viewport')
local timer = require('timer')
local state = require('state')
local input = require('input')
local factory = require('factory')
local game = require('game')

local level_common = require('scenes/level_common')

local target_duration = 4.0

local hero_pos = 0.6
local silvia_pos = 0.2
local speed = (hero_pos - silvia_pos) / 2

return function()
  local scene = {
    name = "game_ending",
    timeAccumulated = 0,
    timeoutThisStep = {
      [1] = 0.5,      -- do nothing for 0.5 sec
      [2] = 2,        -- walking to hero for 2 sec
      [3] = 2,        -- hugging for 2 sec
    },
    step = 1,

    enter = function(self)
      state.hero:stand(hero_pos, asset_conf.floor_bottom)
    end,

    exit = function(self)
    end,

    update = function(self, dt)
      self.timeAccumulated = self.timeAccumulated + dt
      if self.timeAccumulated > self.timeoutThisStep[self.step] then
        if self.step == 1 then
          -- step 1 finished
          state.silvia:setPos(silvia_pos, asset_conf.floor_bottom)
          state.silvia:moveState('walking')
          self.step = 2
        elseif self.step == 2 then
          -- step 2 finished
          self.step = 3
          state.hero:moveState('hugging')
          state.silvia:moveState('hugging')
        elseif self.step == 3 then
          -- step 3 finished
          game.newGame(1)
        end

        self.timeAccumulated = 0
        return
      end

      if self.step == 1 then
        -- nothing to do
      elseif self.step == 2 then
        -- walking
        local dx

        dx = speed * dt
        state.silvia:move(dx, 0)
      elseif self.step == 3 then
        -- nothing to do
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
