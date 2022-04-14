local common_conf = require('entities/common_conf')

local utils = require('utils')
local state = require('state')

return function(pos_x, pos_y, states, animations, start_state)
  local entity = {
    pos = {
      x = pos_x,
      y = pos_y,
      scale_x = -common_conf.scale_factor,
      scale_y = common_conf.scale_factor,
    },
    savedPos = {
      x = 0,
      y = 0,
    },
    animations = animations,
    states = states,
    forward = true,
    currentState = nil,
    currentAnim = nil,
    currentAnimTime = 0,
    setPos = function(self, x, y)
      self.pos.x = x
      self.pos.y = y
    end,

    getPos = function(self)
      return self.pos.x, self.pos.y
    end,

    moveState = function(self, newstate)
      local oldState = self.currentState

      if oldState ~= nil and oldState.leave then
        oldState:leave(self)
      end

      self.currentState = newstate

      if newstate.enter then
        self.currentState:enter(self, oldState)
      else
        self.currentAnimTime = 0
        self.currentAnim = newstate.animation
      end 
    end,

    draw = function(self)
      local x,y = self:getPos()
      utils.drawAnimation(self.currentAnim, self.currentAnimTime, x, y, 0, self.pos.scale_x, self.pos.scale_y)
    end,

    update = function(self, dt)
      self.currentState:update(self, dt)
    end,

    commonUpdate = function(self, dt)
      self.currentAnimTime = self.currentAnimTime + dt
      if self.currentAnimTime >= self.currentAnim.duration then
        self.currentAnimTime = self.currentAnimTime - self.currentAnim.duration
        return true
      end
      return false
    end,

    updateOneshot = function(self, dt, nextState)
      if self:commonUpdate(dt) == true then
        self:moveState(nextState)
      end
    end,
  }

  entity:moveState(start_state)

  return entity
end
