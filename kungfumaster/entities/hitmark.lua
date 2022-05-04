local asset_conf = require('asset_conf')
local utils = require('utils')
local resource = require('resource')
local viewport = require('viewport')
local entity_common = require('entities/entity_common')

local spriteSheet = resource.spriteSheet
local hitMark = asset_conf.hitMark
local sprites = hitMark.sprites

local animations = {
  hit = utils.newAnimationFromConf(spriteSheet, sprites.hit, hitMark.refFrame),
}

local states = {}

states.hit = {
  animation = animations.hit,
  update = function(self, entity, dt)
    entity.timeAccumulated = entity.timeAccumulated + dt
    if entity.timeAccumulated > 0.2 then
      entity.dead = true
    end
    entity:commonUpdate(dt)
  end,
}

return function(vx, vy)
  local entity = entity_common(vx, vy, states, animations, states.hit)

  entity.name = "hitMark"
  entity.timeAccumulated = 0

  return entity
end
