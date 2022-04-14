--
-- dwarf entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

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
  local entity = entity_common(pos_x, pos_y, states, animations, states.walking)

  entity.testDt = 0

  return entity
end
