--
-- dwarf entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')

local scale_factor = 3
local move_speed = 200
local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.dwarf.sprites

local testTime = 2

--------------------------------------------------------------------------------
-- 
-- dwarf sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking),
  holding = utils.newAnimationFromConf(spriteSheet, sprites.holding),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling),
  tumbling = utils.newAnimationFromConf(spriteSheet, sprites.tumbling),
}

--------------------------------------------------------------------------------
-- 
-- dwarf state machine
--
--------------------------------------------------------------------------------
local states = {}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt -testTime 
      entity:moveState(states.holding)
    end

    entity:commonUpdate(dt)
  end,
}

states.holding = {
  animation = animations.holding,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
      entity:moveState(states.falling)
    end

    entity:commonUpdate(dt)
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
      entity:moveState(states.tumbling)
    end

    entity:commonUpdate(dt)
  end,
}

states.tumbling = {
  animation = animations.tumbling,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
      entity:moveState(states.walking)
    end

    entity:commonUpdate(dt)
  end,
}
return function(pos_x, pos_y)
  local entity = {
    pos = {
      x = pos_x,
      y = pos_y,
      scale_x = -scale_factor,
      scale_y = scale_factor,
    },
    animations = animations,
    states = states,
    forward = true,
    currentState = nil,
    currentAnim = nil,
    currentAnimTime = 0,
    testDt = 0,

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

  entity:moveState(states.walking)

  return entity
end
