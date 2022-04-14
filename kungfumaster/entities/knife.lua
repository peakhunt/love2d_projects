--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.knife.sprites

--------------------------------------------------------------------------------
-- 
-- knife sprite animations
--
--------------------------------------------------------------------------------
local animations = {
  flying = utils.newAnimationFromConf(spriteSheet, sprites.flying),
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
    local x,y = entity:getPos()

    if x < 10 or x > 790 then
      if x < 10 then
        entity.forward = false
      end

      if x > 700 then
        entity.forward = true
      end
    end

    if entity.forward then
      x = x - common_conf.move_speed * dt
      entity.pos.scale_x = -1 * common_conf.scale_factor
    else
      x = x + common_conf.move_speed * dt
      entity.pos.scale_x = common_conf.scale_factor
    end

    entity:setPos(x, y)
    entity:commonUpdate(dt)
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.flying)

  entity.name = "knife"

  return entity
end
