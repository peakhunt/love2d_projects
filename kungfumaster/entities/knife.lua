--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')
local gameutil = require('gameutil')

local spriteSheet = resource.spriteSheet
local assetKnife = asset_conf.knife
local sprites = assetKnife.sprites

--------------------------------------------------------------------------------
-- 
-- knife sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  flying = utils.newAnimationFromConf(spriteSheet, sprites.flying, assetKnife.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- knife state machine
--
--------------------------------------------------------------------------------
local states = {}

states.flying = {
  animation = animations.flying,
  update = function(self, entity, dt)

    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 4 then
      entity.health = 0
    end

    local xdelta = gameutil.calcXDelta(entity.forward, common_conf.knife_speed, dt)
    entity:move(xdelta, 0)

    entity:commonUpdate(dt)
  end,
  collideWithHero = function(self, entity, hero)
    entity.health = 0
    hero:takeHit(entity, entity.vQuad)
  end,
}

return function(pos_x, pos_y, forward)
  local entity = entity_common(pos_x, pos_y, states, animations, states.flying)

  entity.forward = forward
  entity.timeAccumulated = 0
  entity.name = "knife"

  return entity
end
