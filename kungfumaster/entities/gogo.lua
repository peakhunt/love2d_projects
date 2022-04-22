--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')
local resource = require('resource')

local spriteSheet = resource.spriteSheet
local assetGogo = asset_conf.gogo
local sprites = assetGogo.sprites

local testTime = 2

--------------------------------------------------------------------------------
-- 
-- gogo sprite animations
--
--------------------------------------------------------------------------------
local animKey = {
  "standing",
  "walking",
  "throwingHigh",
  "throwingLow",
  "falling",
  "hit1",
  "hit2",
}

local animations = {
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing, assetGogo.refFrame),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking, assetGogo.refFrame),
  throwingHigh = utils.newAnimationFromConf(spriteSheet, sprites.throwingHigh, assetGogo.refFrame),
  throwingLow = utils.newAnimationFromConf(spriteSheet, sprites.throwingLow, assetGogo.refFrame),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling, assetGogo.refFrame),
  hit1 = utils.newAnimationFromConf(spriteSheet, sprites.hit1, assetGogo.refFrame),
  hit2 = utils.newAnimationFromConf(spriteSheet, sprites.hit2, assetGogo.refFrame),
}

--------------------------------------------------------------------------------
-- 
-- gogo state machine
--
--------------------------------------------------------------------------------
local states = {}

states.walking = {
  animation = animations.walking,
  update = function(self, entity, dt)
    entity:commonUpdate(dt)
  end,
  hit = function(self, entity, hitQuad)
    if entity.hitCount == 0 then
      entity:moveState(states.hit1)
      entity.hitCount = 1
    else
      entity:moveState(states.hit2)
      entity.hitCount = 0
    end
  end,
}

states.hit1 = {
  animation = animations.hit1,
  update = function(self, entity, dt)
    -- just for test for now
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.walking)
    end
  end,
}

states.hit2 = {
  animation = animations.hit2,
  update = function(self, entity, dt)
    -- just for test for now
    if entity:commonUpdate(dt) == true then
      entity:moveState(states.walking)
    end
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.walking)

  entity.testDt = 0
  entity.name = "gogo"
  entity.hitCount = 0

  return entity
end
