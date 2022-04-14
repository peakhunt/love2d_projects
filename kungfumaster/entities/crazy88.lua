--
-- crazy88 entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.crazy88.sprites

local testTime = 2

--------------------------------------------------------------------------------
-- 
-- crazy88 sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking),
  approaching = utils.newAnimationFromConf(spriteSheet, sprites.approaching),
  holding = utils.newAnimationFromConf(spriteSheet, sprites.holding),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling),
  hitTop = utils.newAnimationFromConf(spriteSheet, sprites.hitTop),
  hitMiddle = utils.newAnimationFromConf(spriteSheet, sprites.hitMiddle),
  hitBottom = utils.newAnimationFromConf(spriteSheet, sprites.hitBottom),
}

--------------------------------------------------------------------------------
-- 
-- crazy88 state machine
--
--------------------------------------------------------------------------------
local states = {}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt -testTime 
      entity:moveState(states.approaching)
    end

    entity:commonUpdate(dt)
  end,
}

states.approaching = {
  animation = animations.approaching,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
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
      entity:moveState(states.hitTop)
    end

    entity:commonUpdate(dt)
  end,
}

states.hitTop = {
  animation = animations.hitTop,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
      entity:moveState(states.hitMiddle)
    end

    entity:commonUpdate(dt)
  end,
}
states.hitMiddle = {
  animation = animations.hitMiddle,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt - testTime 
      entity:moveState(states.hitBottom)
    end

    entity:commonUpdate(dt)
  end,
}

states.hitBottom = {
  animation = animations.hitBottom,
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
  local entity = entity_common(pos_x, pos_y, states, animations, states.walking)

  entity.testDt = 0
  entity.name = "crazy88"

  return entity
end
