--
-- dwarf entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')

local spriteSheet = resource.spriteSheet
local assetDwarf = asset_conf.dwarf
local sprites = assetDwarf.sprites

--------------------------------------------------------------------------------
-- 
-- dwarf sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetDwarf.refFrame),
  holding = utils.newAnimationFromConf(spriteSheet, sprites.holding, assetDwarf.refFrame),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling, assetDwarf.refFrame),
  tumbling = utils.newAnimationFromConf(spriteSheet, sprites.tumbling, assetDwarf.refFrame),
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
    entity:commonUpdate(dt)
  end,
  hit = function(self, entity, hitQuad)
    entity:moveState(states.falling)
  end,
}

states.holding = {
  animation = animations.holding,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
}

states.falling = {
  animation = animations.falling,
  update = function(self, entity, dt)
    -- just for test for now
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.walking)
    end
  end,
}

states.tumbling = {
  animation = animations.tumbling,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.walking)

  entity.name = "dwarf"
  return entity
end
