--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
local sprites = asset_conf.gogo.sprites

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
  standing = utils.newAnimationFromConf(spriteSheet, sprites.standing),
  walking = utils.newAnimationFromConf(spriteSheet, sprites.walking),
  throwingHigh = utils.newAnimationFromConf(spriteSheet, sprites.throwingHigh),
  throwingLow = utils.newAnimationFromConf(spriteSheet, sprites.throwingLow),
  falling = utils.newAnimationFromConf(spriteSheet, sprites.falling),
  hit1 = utils.newAnimationFromConf(spriteSheet, sprites.hit1),
  hit2 = utils.newAnimationFromConf(spriteSheet, sprites.hit2),
}

--------------------------------------------------------------------------------
-- 
-- gogo state machine
--
--------------------------------------------------------------------------------
local states = {}

states.gogo = {
  currentStep = 1,
  animation = animations.standing,
  update = function(self, entity, dt)
    entity.testDt = entity.testDt + dt;
    if entity.testDt > testTime then
      entity.testDt = entity.testDt -testTime 
      self.currentStep = self.currentStep + 1
      if self.currentStep > #animKey then
        self.currentStep = 1
      end
      entity.currentAnimTime = 0
      entity.currentAnim = animations[animKey[self.currentStep]]
    end

    entity:commonUpdate(dt)
  end,
}

return function(pos_x, pos_y)
  local entity = entity_common(pos_x, pos_y, states, animations, states.gogo)

  entity.testDt = 0

  return entity
end
