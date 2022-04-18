--
-- gogo entity
--
local asset_conf = require('asset_conf')
local utils = require('utils')
local state = require('state')
local entity_common = require('entities/entity_common')
local common_conf = require('entities/common_conf')

local spriteSheet = asset_conf.spriteSheet
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
  entity.name = "gogo"

  return entity
end
