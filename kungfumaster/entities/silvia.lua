local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')
local factory = require('factory')
local gameutil = require('gameutil')

local spriteSheet = resource.spriteSheet
local assetSilvia = asset_conf.silvia
local sprites = assetSilvia.sprites

--------------------------------------------------------------------------------
-- 
-- silvia sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  tiedDown = utils.newAnimationFromConf(spriteSheet, sprites.tiedDown, assetSilvia.refFrame),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetSilvia.refFrame),
  hugging = utils.newAnimationFromConf(spriteSheet, sprites.hugging, assetSilvia.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- silvia state machine
--
--------------------------------------------------------------------------------
local states = {}

states.tiedDown = {
  animation = animations.tiedDown,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
}

states.hugging = {
  animation = animations.hugging,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.tiedDown)

  entity.name = "silvia"
  entity.restrainPos = true
  entity.timeAccumulated = 0

  return entity
end
